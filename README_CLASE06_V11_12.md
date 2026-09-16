# Sistemas Distribuidos - Clase 06 v11.12

## Storage distribuido y almacenamiento permanente

Este paquete reúne el material completo de la Clase 06 y toma como fuente de verdad la última versión de las diapositivas entregada para la materia.

La arquitectura pedagógica común es:

```
contexto -> vocabulario -> intuición -> formalización -> falla
         -> evidencia -> decisión -> recuperación
```

El caso conductor es **CampusShop**: una compra identificada como `9F2A` se confirma y el nodo pierde energía. A partir de ese caso se conectan durabilidad, recuperación, acceso concurrente, planificación de consultas y mantenimiento físico.

## Contenido

| Componente | Fuente | PDF compilado | Resultado |
|---|---|---|---|
| Diapositivas | `slides/clase06.tex` | `build/slides/clase06.pdf` | 67 frames activos, 88 páginas por overlays |
| Apuntes autocontenidos | `apuntes/clase06-apuntes.tex` | `build/apuntes/clase06-apuntes.pdf` | 23 páginas |
| Guía de ejercicios | `guias/clase06-guia.tex` | `build/guias/clase06-guia.pdf` | 20 ejercicios, 7 páginas |
| Guía resuelta | `guias_resueltas/clase06-guiaresuelta.tex` | `build/guias_resueltas/clase06-guiaresuelta.pdf` | 20 soluciones, 11 páginas |
| Guía docente y dossier | `docente/clase06-docente.tex` | `build/docente/clase06-docente.pdf` | 24 páginas |
| Ficha de aula | `recursos/clase06-ficha-aula.tex` | `build/recursos/clase06-ficha-aula.pdf` | 10 páginas |
| Timelines imprimibles | `recursos/clase06-timelines-pizarra.tex` | `build/recursos/clase06-timelines-pizarra.pdf` | 2 páginas |

También se incluyen:

- `demos/clase06_wal_recovery.py`: recovery a partir de páginas anteriores, registros WAL y COMMIT.
- `demos/clase06_mvcc_visibility.py`: snapshots, versiones reclamables y bloat.
- `demos/clase06_compaction_capacity.py`: crecimiento de backlog, slowdown y write stall.
- `demos/clase06_explain.sql`: comparación reproducible de `EXPLAIN (ANALYZE, BUFFERS)` antes y después de un índice.
- `demos/rocksdb_compaction_metrics_didactica.txt`: salida sintética para leer métricas de compactación sin depender de una instalación de RocksDB.

## Núcleos técnicos

1. **Contexto del storage distribuido**: diferencia entre la capa distribuida y el motor local.
2. **WAL y recovery**: regla log-before-data, COMMIT-before-ACK, prefijo durable, LSN, REDO, group commit y checkpoint.
3. **MVCC**: versiones, snapshot, visibilidad, vista coherente, bloat, VACUUM y write skew.
4. **Árbol B, índices y EXPLAIN**: transición desde visibilidad lógica hacia localización física; fan-out, índice compuesto y lectura de planes.
5. **LSM-tree**: memtable, SSTable, flush, filtros de Bloom, merge ordenado, compaction, backlog, stalls y amplificaciones.
6. **Integración**: comparación CampusShop/telemetría y decisión mediante carga, garantía, costo y evidencia.

## Ruta sugerida para 180 minutos

| Tiempo | Bloque |
|---:|---|
| 0-10 min | Apertura con CampusShop y predicción |
| 10-25 min | Contexto del storage distribuido |
| 25-42 min | Vocabulario y objetos físicos |
| 42-52 min | Repaso ágil de las clases 1 a 5 |
| 52-82 min | WAL, frontera durable y recovery |
| 82-92 min | Actividad de timeline y pausa |
| 92-119 min | MVCC, snapshots, bloat y write skew |
| 119-145 min | Árbol B, índices y demostración de EXPLAIN |
| 145-169 min | LSM, Bloom, compaction y write stalls |
| 169-178 min | CampusShop frente a telemetría |
| 178-180 min | Exit ticket |

La guía docente distingue contenido **núcleo**, **actividad**, **extensión** y **respaldo** para que no sea necesario proyectar todas las páginas con la misma profundidad.

## Compilación

Requiere `latexmk`, XeLaTeX y una distribución TeX Live con TikZ y `tcolorbox`.

```bash
make validate
make all
```

Targets parciales:

```bash
make slides
make apuntes
make guia
make guia_resuelta
make docente
make recursos
make demos
```

`make all` elimina auxiliares y conserva únicamente los PDF dentro de `build/`.

```bash
make clean       # elimina auxiliares, conserva PDF
make distclean   # elimina build/ completo
```

## Integración en el repositorio del curso

Para no modificar infraestructura compartida, utilice el parche de repositorio y su instalador:

```bash
./apply_clase06_v11_12.sh "/ruta/al/repositorio"
```

El instalador crea un respaldo con timestamp y reemplaza únicamente materiales de la Clase 06. No modifica:

- `cls/`;
- el `.sty` institucional;
- `Makefile`;
- `.latexmkrc`;
- `config/course-config.tex`;
- `.github/workflows/`.

## Compatibilidad

Los documentos usan únicamente los entornos institucionales existentes:

- `uakeybox`;
- `uainfo`;
- `uawarn`;
- `uaexercise`;
- `uaanswer`.

No requieren `minted`, `pgfplots`, `shell-escape`, `uacheck`, `uacase` ni `uademo`.

## Control de calidad

- `VALIDATION_STATUS=PASS`.
- 20 ejercicios y 20 soluciones correspondientes.
- Siete PDF compilados y abiertos correctamente.
- Los siete PDF fueron renderizados para inspección visual.
- No se detectaron errores LaTeX fatales ni cajas `overfull` en la compilación final.
- Los avisos tipográficos `underfull` restantes son no bloqueantes y no producen recortes visibles.
- `build/` contiene exclusivamente PDF después de `make all`.
