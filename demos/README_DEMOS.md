# Demos didácticas — Clases 7, 8 y 9

Las demos usan únicamente la biblioteca estándar de Python 3. No pretenden reemplazar un cluster real: hacen visibles los mecanismos y permiten mover una falla de manera reproducible durante la explicación.

## Clase 7

```bash
python3 demos/clase07_offsets.py
python3 demos/clase07_event_time.py
```

- `clase07_offsets.py`: contrasta pérdida at-most-once, duplicación at-least-once y efecto idempotente.
- `clase07_event_time.py`: compara ventanas por event time y processing time e introduce late data.

## Clase 8

```bash
python3 demos/clase08_quorum_versiones.py
python3 demos/clase08_truetime.py
```

- `clase08_quorum_versiones.py`: verifica intersección de quorums y compara version vectors.
- `clase08_truetime.py`: determina cuándo un timestamp queda definitivamente en el pasado de un intervalo TrueTime simplificado.

## Clase 9

```bash
python3 demos/clase09_disponibilidad.py
python3 demos/clase09_outbox_saga.py
```

- `clase09_disponibilidad.py`: muestra cómo una cadena sincrónica reduce disponibilidad idealizada.
- `clase09_outbox_saga.py`: recorre una saga y sus compensaciones idempotentes; recuerda la frontera de outbox.

## Criterio pedagógico

1. Hacer predecir el resultado.
2. Ejecutar la demo.
3. Mover el crash, el quorum o la incertidumbre.
4. Pedir que el estudiante nombre garantía y costo.
5. Conectar la salida con una métrica o SLO.


## Ajustes v11.4

- `clase07_offsets.py` modela explícitamente la atomicidad entre efecto e inbox y muestra el contraejemplo cuando se separan.
- `clase07_event_time.py` corrige el cálculo: E3 llega 2 min 10 s después del cierre de la ventana.
- `clase08_truetime.py` declara que representa el predicado de seguridad y no una implementación de TrueTime.
- `clase09_outbox_saga.py` implementa realmente transacción local + outbox, relay con ACK perdido, republicación, inbox/deduplicación y saga idempotente.
