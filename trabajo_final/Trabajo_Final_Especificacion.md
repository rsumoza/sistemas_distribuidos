# Trabajo Final Integrador 2026
## Sistemas Distribuidos - dos entregas intermedias y entrega final

## 1. Propósito

Diseñar, implementar parcialmente, experimentar y defender un sistema distribuido que resuelva un problema real. Cada decisión deberá justificarse mediante el marco **problema - fallas - garantías - solución - trade-offs**.

## 2. Organización

- Equipos de 3 estudiantes.
- Entregas acumulativas: cada hito corrige y amplía el anterior.
- Caso de uso libre sujeto a aprobación docente.
- Repositorio reproducible con instrucciones de ejecución.
- Prototipo que demuestre al menos dos decisiones centrales.
- Defensa individual obligatoria.

## 3. Cronograma definitivo

| Instancia | Fecha | Evidencia principal |
|---|---:|---|
| Entrega intermedia 1 | **jueves 10 de septiembre de 2026** | Problema, arquitectura, comunicación, fallas, coordinación y consistencia preliminar. |
| Entrega intermedia 2 | **jueves 15 de octubre de 2026** | Datos, almacenamiento, logs, transacciones, arquitectura y observabilidad inicial. |
| Entrega final y defensa | **jueves 12 de noviembre de 2026** | Documento consolidado, prototipo, experimento bajo falla, resiliencia, SLOs y defensa individual. |

## 4. Entrega intermedia 1

1. Definición del problema, actores, alcance y justificación de la distribución.
2. Requisitos funcionales y no funcionales.
3. Diagrama de contexto, componentes y distribución física/lógica.
4. Modelo de fallas y comunicación: RPC/eventos, deadlines, retries e idempotencia.
5. Datos críticos, intención de consistencia y estrategia preliminar de replicación.
6. Puntos que requieren consenso, líder, exclusión o transacción.
7. Primer ADR con una alternativa descartada y criterio de decisión.

## 5. Entrega intermedia 2

8. Corrección de la entrega anterior.
9. Consenso y replicación concretos donde corresponda.
10. Storage: WAL/MVCC/B-tree/LSM o servicio administrado elegido, incluyendo recovery.
11. CAP/PACELC por operación crítica.
12. Transacciones: serializabilidad, 2PC o saga, con invariantes explícitos.
13. Topics, particiones, consumer groups, offsets y semántica de entrega.
14. Descomposición de servicios y primer diseño de observabilidad.
15. Prototipo parcial y demostración reproducible de una falla.

## 6. Entrega final y defensa

16. Documento consolidado y coherente de 15 a 22 páginas más anexos.
17. Repositorio con ejecución reproducible.
18. Dos demostraciones ejecutables de decisiones centrales.
19. Experimento de falla con hipótesis, baseline, perturbación, métricas y conclusión.
20. Resiliencia y graceful degradation del camino crítico.
21. SLI, SLO, error budget, burn rate y alertas.
22. Runbook breve y ejemplo de postmortem.
23. Limitaciones y trabajo futuro.
24. Presentación de 12 a 15 minutos y defensa individual ante comité.

## 7. Rúbrica

| Criterio | Peso |
|---|---:|
| Problema, requisitos y modelo de fallas | 15% |
| Arquitectura, comunicación y datos | 20% |
| Consistencia, coordinación y transacciones | 20% |
| Prototipo y evidencia experimental | 20% |
| Observabilidad, resiliencia y operación | 15% |
| Redacción y defensa individual | 10% |

## 8. Uso de inteligencia artificial

Todo uso de IA deberá declararse. El equipo será responsable de verificar, reproducir y explicar cualquier texto, código o diagrama asistido. La defensa podrá incluir modificaciones en vivo para comprobar comprensión.
