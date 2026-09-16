# Changelog - Clase 06 v11.12

## Base

- Se conserva byte a byte la última fuente de diapositivas suministrada para la Clase 06.
- Se reconstruye el resto del material para usar esa presentación como contrato conceptual y terminológico.

## Apuntes

- Ampliación del contexto de almacenamiento distribuido y del rol del motor local.
- Definición ordenada de acrónimos y vocabulario antes de su uso.
- Nueva sección sobre camino crítico y E/S secuencial frente a dispersa.
- Explicación completa de recovery:
  `estado anterior + REDO del WAL confirmado pendiente`.
- Distinción entre registros de actualización y registro COMMIT.
- Desarrollo de LSN, prefijo durable, group commit y checkpoints.
- Transición explícita de MVCC hacia localización física con árbol B.
- Desarrollo de fan-out, índice compuesto y planes de ejecución.
- Explicación de filtros de Bloom sin usar la expresión ambigua “archivo imposible”.
- Desarrollo de bloat, amplificaciones, backlog y write stall.
- Conexión explícita con el Trabajo Final Integrador.

## Guía de ejercicios

- Revisión completa de los 20 ejercicios.
- Mayor exigencia de timelines, modelo de falla, garantía y evidencia.
- Nuevo ejercicio sobre la objeción “COMMIT durable sin páginas materializadas”.
- Ejercicios de transición MVCC -> árbol B -> EXPLAIN.
- Cálculos de group commit, checkpoints y capacidad de compactación.

## Guía resuelta

- Correspondencia uno a uno con los 20 ejercicios.
- Resoluciones ampliadas con mecanismos, límites, métricas y pruebas.
- Fórmulas largas divididas para evitar desbordes tipográficos.

## Guía docente

- Guion operativo para 180 minutos.
- Dossier técnico para preguntas sobre WAL, MVCC, B-tree/EXPLAIN y LSM.
- Respuestas preparadas en niveles de 30 segundos, 2 minutos y 5 minutos.
- Preguntas posibles de estudiantes y auditor.
- Estrategias de explicación, diagnóstico, contingencia y evaluación formativa.
- Explicación específica de bloat y de recovery sin páginas materializadas.

## Recursos

- Ficha de aula ampliada con vocabulario, timelines, transición MVCC/árbol B y evidencia.
- Timelines WAL y MVCC imprimibles.
- Demos Python para WAL, MVCC y compaction.
- Demo SQL para EXPLAIN.

## Build y QA

- Makefile autocontenido con targets totales y parciales.
- Validador específico de contenido y entornos.
- Siete PDF compilados.
- Render e inspección visual de todos los PDF.
- Limpieza automática de auxiliares.
