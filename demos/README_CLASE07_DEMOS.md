# Demos reproducibles — Clase 07

Todas usan Python estándar y no requieren un cluster Kafka.

## 1. Offsets y semánticas

```bash
python3 demos/clase07_offsets.py
```

Muestra pérdida at-most-once, duplicación at-least-once, inbox atómica y el contraejemplo de efecto/deduplicación no atómicos.

## 2. Event time y evento tardío

```bash
python3 demos/clase07_event_time.py
```

Compara ventanas por event time y processing time. E3 llega 2 min 10 s después del cierre nominal de la ventana 10:00–10:05.

## 3. Hot partition y lag

```bash
python3 demos/clase07_particiones_lag.py
```

Demuestra por qué la capacidad agregada del grupo puede ocultar una única partición cuya tasa de ingreso supera su capacidad.

## 4. Outbox e inbox

```bash
python3 demos/clase07_outbox_inbox.py
```

Simula una transacción local pedido+outbox, un ACK perdido del relay, una republicación y una inbox que transforma dos entregas físicas en un solo efecto lógico.

Las demos son modelos didácticos: hacen visible una frontera concreta y no reemplazan una prueba sobre Kafka, una base real y la configuración de producción.
