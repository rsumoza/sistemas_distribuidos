# Clase 07 v11.13 - cambios principales

## Reestructuración pedagógica

- Se incorporó una cápsula inicial de memoria, persistencia, registro, append, lector y progreso durable.
- Se redujo la ruta nuclear a partición/key, progreso, timelines de falla, inbox y outbox.
- Producer idempotence, ISR, transacciones Kafka--Kafka, state stores, watermarks y DLQ quedaron como extensión o respaldo.
- Se usa CampusShop como caso conductor y Asteria solamente como transferencia.
- Se agregó una actividad cada 12--15 minutos y una separación explícita entre NÚCLEO, ACTIVIDAD, EXTENSIÓN y RESPALDO.

## Materiales

- Slides reducidas y reordenadas: 62 frames activos, 66 páginas PDF.
- Apuntes con sección `Base mínima para esta clase` y ruta esencial/profundización.
- Guía con 20 ejercicios clasificados en clase, consolidación y profundización.
- Guía resuelta ajustada al nuevo ejercicio inicial.
- Guía docente de 180 minutos reescrita para el diagnóstico real del grupo.
- Ficha de aula y timelines con página inicial de registro/append/progreso.
- Validador específico actualizado.

## Compatibilidad

No se modifican `.cls`, `.sty`, configuración general, Makefile del repositorio ni workflows de GitHub.
