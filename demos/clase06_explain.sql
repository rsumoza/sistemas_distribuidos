-- Clase 06 - demo reproducible de EXPLAIN en PostgreSQL
-- Caso: últimas 20 compras CONFIRMED de un estudiante.
-- Los tiempos dependen de hardware, caché y configuración; el objetivo es comparar
-- la forma del plan, las filas descartadas y los buffers tocados.

DROP TABLE IF EXISTS purchases;

CREATE TABLE purchases (
    id            BIGSERIAL PRIMARY KEY,
    student_id    INTEGER NOT NULL,
    total         NUMERIC(10,2) NOT NULL,
    confirmed_at  TIMESTAMPTZ NOT NULL,
    status        TEXT NOT NULL
);

-- Un millón de compras sintéticas para 20.000 estudiantes.
INSERT INTO purchases (student_id, total, confirmed_at, status)
SELECT
    1 + (g % 20000),
    500 + (g % 9500),
    TIMESTAMPTZ '2026-01-01 08:00:00+00' + (g || ' seconds')::interval,
    CASE WHEN g % 20 = 0 THEN 'CANCELLED' ELSE 'CONFIRMED' END
FROM generate_series(1, 1000000) AS g;

ANALYZE purchases;

\echo '============================================================'
\echo 'PLAN SIN INDICE COMPUESTO'
\echo 'Lea de abajo hacia arriba: scan -> filter -> sort -> limit.'
\echo '============================================================'
EXPLAIN (ANALYZE, BUFFERS)
SELECT id, total, confirmed_at
FROM purchases
WHERE student_id = 8421
  AND status = 'CONFIRMED'
ORDER BY confirmed_at DESC
LIMIT 20;

\echo '============================================================'
\echo 'CREANDO INDICE QUE REFLEJA IGUALDAD + IGUALDAD + ORDEN'
\echo '============================================================'
CREATE INDEX idx_purchase_student_status_date
ON purchases (student_id, status, confirmed_at DESC);

ANALYZE purchases;

\echo '============================================================'
\echo 'PLAN CON INDICE COMPUESTO'
\echo 'Observe scan, sort, filas y buffers.'
\echo '============================================================'
EXPLAIN (ANALYZE, BUFFERS)
SELECT id, total, confirmed_at
FROM purchases
WHERE student_id = 8421
  AND status = 'CONFIRMED'
ORDER BY confirmed_at DESC
LIMIT 20;

\echo '============================================================'
\echo 'COSTO DE ESCRITURA: EL INDICE TAMBIEN DEBE MANTENERSE'
\echo '============================================================'
EXPLAIN (ANALYZE, BUFFERS, WAL)
INSERT INTO purchases (student_id, total, confirmed_at, status)
SELECT
    8421,
    1500,
    now() + (g || ' milliseconds')::interval,
    'CONFIRMED'
FROM generate_series(1,1000) AS g;

-- Para repetir desde cero, vuelva a ejecutar el script completo.
