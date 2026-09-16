# Demostraciones de la Clase 06

Las demostraciones complementan la explicación; no reemplazan el razonamiento sobre
fallas, garantías y costos. Todas pueden ejecutarse sin modificar los documentos.

## 1. WAL y recuperación

```bash
python3 demos/clase06_wal_recovery.py
```

Muestra dos escenarios:

- crash antes de que el COMMIT sea durable;
- crash después del COMMIT durable, pero antes de materializar las páginas.

La salida separa el papel de las páginas base, los registros `WAL UPDATE`, el
registro `COMMIT`, `flush_lsn` y `page_lsn`.

## 2. Visibilidad MVCC y bloat

```bash
python3 demos/clase06_mvcc_visibility.py
```

Muestra qué versión observa un lector antiguo y uno nuevo, cuándo una versión sigue
siendo necesaria y cuándo queda reclamable. El modelo es deliberadamente simple: no
reproduce todas las reglas internas de PostgreSQL.

## 3. Backlog y write stall

```bash
python3 demos/clase06_compaction_capacity.py
```

Calcula la pendiente del backlog y el tiempo idealizado hasta los umbrales de
slowdown y stop. La cuenta supone tasas constantes; en producción deben medirse
ráfagas, niveles, CPU, dispositivo, caché y configuración.

## 4. EXPLAIN en PostgreSQL

Requiere `psql` y una base de prueba:

```bash
psql -d <base_de_prueba> -f demos/clase06_explain.sql
```

El script crea un millón de compras sintéticas, compara `EXPLAIN (ANALYZE, BUFFERS)`
antes y después de un índice compuesto y muestra el costo de mantener el índice
durante una inserción.

**Advertencia:** el último `INSERT` modifica la base de prueba. No ejecutar sobre una
base productiva.

## 5. Métricas de compactación sin RocksDB instalado

```bash
cat demos/rocksdb_compaction_metrics_didactica.txt
```

Los datos son sintéticos y están alineados con el dashboard de la presentación. Se
utilizan como fallback si no se dispone de un entorno RocksDB en el aula.

## Secuencia sugerida en clase

1. Ejecutar la demo WAL después de construir el timeline en el pizarrón.
2. Ejecutar MVCC después de que los estudiantes predigan qué ve cada snapshot.
3. Mostrar `EXPLAIN` o usar las salidas impresas.
4. Cerrar con el cálculo de backlog y una decisión de capacidad.
