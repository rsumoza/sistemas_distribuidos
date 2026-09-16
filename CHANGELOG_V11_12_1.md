# Changelog - Clase 06 v11.12.1

## Corrección principal

La v11.12 utilizaba títulos editoriales válidos, pero diferentes de los literales requeridos por el validador global. Por eso `make all` se detenía antes de ejecutar XeLaTeX.

## Apuntes

Se agregaron dos secciones reales, no marcadores vacíos:

1. `Cómo estudiar este capítulo`: propone tres pasadas de estudio basadas en promesa observable, timeline/falla y frontera/costo/evidencia.
2. `Mapa intuitivo antes del formalismo`: ubica WAL, MVCC, árbol B/EXPLAIN, LSM/compaction y backlog/write stall dentro del problema general.

## Guía

- `Ruta recomendada` pasa a llamarse `Ruta recomendada de uso`.

## Validador específico

- comprueba los mismos tres componentes editoriales exigidos por el validador global.

## Infraestructura

No se modificaron `.cls`, `.sty`, `Makefile`, `.latexmkrc`, configuración general ni workflows.
