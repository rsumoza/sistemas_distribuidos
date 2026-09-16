# Clase 07 v11.13 - Logs distribuidos: de un hecho durable a un efecto recuperable

Esta versión responde al diagnóstico posterior a la Clase 06: el grupo no posee todavía un modelo firme de memoria, persistencia, archivos y organización física. La clase evita comenzar con Kafka y construye primero una base mínima de registro, append, log, lector y progreso durable.

## Pregunta central

¿Cómo hacer que un hecho producido una vez pueda ser leído por varios componentes, aun si alguno falla, sin perder el progreso ni ejecutar dos veces el mismo efecto lógico?

## Ruta nuclear

1. memoria de trabajo frente a persistencia;
2. registro, append, log y lector;
3. partición, key y orden local;
4. position y committed offset;
5. at-most-once y at-least-once mediante timelines;
6. event ID, idempotencia e inbox;
7. dual write y transactional outbox;
8. lag por partición y evidencia operacional.

## Profundización

- producer idempotence e ISR;
- transacciones Kafka--Kafka;
- state store y changelog;
- watermark y late data;
- poison events y DLQ.

## Cronograma de 180 minutos

| Tiempo | Actividad |
|---:|---|
| 0--12 | CampusShop y predicción |
| 12--30 | Base mínima |
| 30--48 | De llamadas directas a historia compartida |
| 48--68 | Log, partición y key |
| 68--82 | Actividad de particionado |
| 82--92 | Pausa y recuperación |
| 92--112 | Consumer, offset y grupo |
| 112--138 | Timelines de falla e inbox |
| 138--156 | Dual write y outbox |
| 156--169 | Tiempo en streams |
| 169--178 | Diseño y defensa |
| 178--180 | Exit ticket |

## Compilación

```bash
make validate
make all
```

El target `make all` de este paquete compila los siete documentos de la Clase 07. Para el repositorio general, use el Makefile global del curso.

## Integración

El parche asociado copia únicamente archivos de la Clase 07 y crea un respaldo con timestamp. No sustituye clases, estilos ni workflows compartidos.
