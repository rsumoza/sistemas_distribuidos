# Auditoría final de consolidación - versión 11.4

## Dictamen

La versión 11.4 conserva la precisión técnica y la preparación para auditoría de v11.3, pero recupera la continuidad narrativa de los apuntes v11.1/v11.2. No agrega una tercera capa de contenidos: reorganiza, integra y separa correctamente los materiales para estudiantes y docentes.

La secuencia común de las cuatro clases es:

`caso real -> predicción -> intuición controlada -> formalización -> ejecución/falla -> evidencia -> decisión -> recuperación`.

## Decisiones de consolidación

### Diapositivas

- Se mantienen las correcciones técnicas de v11.3.
- Los títulos de sección se acortaron para evitar cortes silábicos visualmente pobres.
- Cada frame de contenido incorpora una etiqueta discreta: `NÚCLEO`, `ACTIVIDAD`, `EXTENSIÓN` o `RESPALDO`.
- Las etiquetas permiten conducir 180 minutos sin intentar proyectar linealmente todo el material.
- No se agregaron entornos ni paquetes LaTeX; el `.sty` y los `.cls` permanecen sin cambios.

### Apuntes

- Clase 06 parte de la versión autocontenida v11.1.
- Clases 07-09 parten de la narrativa compacta v11.2.
- Se incorporó una única sección de `Precisiones técnicas indispensables` en cada capítulo.
- Se eliminaron las segundas exposiciones completas que hacían repetitiva la v11.3.
- Cada capítulo incluye una ruta explícita de estudio y conserva casos, formalización, fallas, métricas, glosario y autoevaluación.

### Guías y soluciones

- Se conservan los 20 ejercicios con entregables observables y ruta de uso en clase/postclase/desafío.
- Las soluciones para estudiantes contienen 20 respuestas uno a uno y un criterio de autocorrección.
- Las matrices de corrección, errores penalizables y preguntas de defensa fueron trasladadas a la guía docente.

### Guías docentes

Cada guía tiene tres partes:

1. **Guion operativo para 180 minutos**: tiempos, pizarrón, preguntas, demostraciones, errores y contingencias.
2. **Dossier técnico de preparación**: definiciones precisas, formalización, respuestas difíciles y explicación en tres profundidades.
3. **Auditoría, evaluación y evidencias**: preguntas posibles del auditor, matrices de corrección, evidencias y checklist del día.

### Demos

- Se corrigió la demora de late data de `2m20s` a `2m10s` después del cierre.
- La demo de offsets distingue deduplicación atómica de una implementación con ventana de crash.
- La demo de TrueTime se rotula como modelo del predicado, no como implementación del servicio.
- La demo de outbox ahora ejecuta transacción local, relay, ACK perdido, republicación e inbox/deduplicación, además de la saga.

## Metadatos

Los documentos se identifican como `Segundo cuatrimestre 2026`. Se usa `2026` como fecha neutral de portada para no atribuir la misma fecha de clase a los cuatro encuentros. Cada archivo puede redefinir `\UASetDate{...}` cuando se confirme el calendario definitivo.

## Alcance pedagógico por clase

### Clase 06

Pregunta: ¿qué debe ocurrir físicamente para que una promesa lógica sobreviva un crash?

Evidencias: timeline WAL, timeline MVCC, lectura de EXPLAIN, dashboard de compaction y decisión CampusShop/telemetría.

### Clase 07

Pregunta: ¿qué significa publicado, procesado y aplicado cuando log, offset, estado y efecto pueden fallar por separado?

Evidencias: key de partición, timeline efecto-offset, frontera exactly-once, outbox/inbox y política de late data.

### Clase 08

Pregunta: ¿qué error acepta cada operación durante una partición y qué latencia paga en operación normal?

Evidencias: caso asiento/carrito, quorum humano, version vectors, TrueTime y matriz híbrida por subsistema.

### Clase 09

Pregunta: ¿qué autonomía concreta compra una frontera y por qué justifica su prima distribuida?

Evidencias: canvas de frontera, cálculo de disponibilidad compuesta, dual write/outbox, saga durable y migración reversible.

## Control de calidad

- 25 PDF compilados.
- 20 ejercicios y 20 respuestas por clase.
- 0 archivos auxiliares finales en `build/`.
- `.sty`, `.cls` y `Makefile` sin cambios respecto de v11.3.
- Validador adaptado a la separación estudiante/docente de v11.4.
- Scripts Python ejecutados correctamente.
- PDFs abiertos y contabilizados mediante PyMuPDF, sin páginas vacías.
