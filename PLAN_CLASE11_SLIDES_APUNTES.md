# Plan de modificación — Clase 11: slides y apuntes de Resiliencia distribuida

> Documento de traspaso para el modelo que implementa. Se ejecuta por fases, frenando al final de cada una para que el docente revise.

---

## 0. Contexto

### 0.1 Qué se quiere lograr

La clase 11 (150 minutos) deja de ser "slides + casos reales" y pasa a girar alrededor de una **demo en vivo** que el docente corre en su máquina y proyecta. Los alumnos razonan, predicen y proponen configuraciones; el docente las aplica y se contrasta la predicción con lo observado.

Por eso se reparten los roles de los dos documentos:

- **Apuntes (`apuntes/clase11-apuntes.tex`): la teoría completa y autosuficiente.** Se leen antes o después de la clase. Usan el sistema de la demo (el generador de contraseñas) como ejemplo recurrente, pero **no dependen de la demo** ni de sus números medidos.
- **Slides (`slides/clase11.tex`): el guion de la clase con la demo.** Cada bloque sigue la secuencia *pregunta → predicción → demo → concepto mínimo → decisión*. Llevan solo la teoría necesaria para leer lo que muestra la demo; el desarrollo completo está en los apuntes.

### 0.2 Repositorio y material de referencia

- Repo: `sistemas_distribuidos_2026/` (LaTeX, compila con `latexmk -xelatex`; ver `Makefile`).
- **Modelo de estilo: la clase 10, recién renovada** (`slides/clase10.tex`, `apuntes/clase10-apuntes.tex`). Leerla completa antes de escribir: tono, uso de `\pause`, diagramas TikZ, citas al pie, cierre con el modelo P-F-G-S-T y puente a la clase siguiente. **El cierre de la clase 10 ya anticipa la 11** (la cascada, "el retry que en clases anteriores era la solución, acá es el combustible", y la mención a circuit breakers, bulkheads y backoff): la clase 11 tiene que retomar esos hilos.
- **La demo:** `../opentelemetry-demo/PLAN_CLASE11_RESILIENCIA.md`. De ahí salen la arquitectura, los nombres de los escenarios y presets, los dashboards y las hipótesis de la matriz de la sección 6. **Los nombres tienen que coincidir exactamente** con los del plan de la demo.
- **Bibliografía disponible en la carpeta `bibliografía/` del curso** (consultarla; no citar de memoria):
  - Nygard, *Release It!* 2.ª ed. (PDF): caps. 2 (caso de la aerolínea), 3 (estabilidad, cadena de falla), 4 (antipatrones), 5 (patrones), 9 (sección *Demand Control*), 15 (caso de lanzamiento).
  - Beyer et al., *Site Reliability Engineering* (PDF): caps. 21 (*Handling Overload*) y 22 (*Addressing Cascading Failures*).
  - *The Site Reliability Workbook*, cap. 11 (*Managing Load*), en `https://sre.google/workbook/managing-load/`: casos Pokémon GO y Dressy.

### 0.3 Reglas de trabajo (obligatorias)

- Leer y respetar `../CLAUDE.md` (carpeta raíz del curso): cambios quirúrgicos; no reescribir textos ajenos a la tarea.
- **Alcance de la reescritura:** el cuerpo de `slides/clase11.tex` y de `apuntes/clase11-apuntes.tex` se reescribe. **No** se tocan:
  - el preámbulo de cada archivo (`\documentclass`, `\input`, `\UASet...`, `\title`, `\author`, `\date`), salvo el `\subtitle` de las slides si hace falta;
  - los archivos de clase y estilo (`cls/`), `config/`, el `Makefile` ni los validadores;
  - la guía, la guía resuelta y la guía docente de la clase 11 (fuera de alcance, ver sección 6);
  - ningún archivo de otras clases.
- Trabajar en la rama `feat/improve-class-11` (mismo esquema que la de la clase 10). Un commit por fase. **No hacer push.**
- **Citas:** las citas textuales tienen que ser literales y verificables en la fuente (con capítulo). Si no se puede verificar la literalidad, parafrasear y citar autor y capítulo. No inventar números, fechas ni casos.
- **Idioma y tono:** español. En las slides, el registro de la clase 10 (voseo y "ustedes", frases cortas). En los apuntes, el registro impersonal y formal de los apuntes de la clase 10. Términos técnicos en inglés en cursiva la primera vez (*circuit breaker*, *backoff*, *jitter*, *bulkhead*, *load shedding*), con su traducción cuando ayude.

### 0.4 Convenciones LaTeX del repo (verificadas)

- Slides: clase `ua-engineering-v6-beamer`. Secciones con `\UASectionSlide{...}`. Entornos usados en la clase 10: `frame`, `block`, `alertblock`, `itemize`, `enumerate`, `description`, `columns`/`column`, `center`, `quote`, `tikzpicture`.
- Apuntes: clase `ua-engineering-v6-article`, `\section`/`\subsection`, recuadro destacado `uakeybox`.
- Colores definidos en el estilo: `UAIngNavy`, `UAIngOrange`, `UAIngOrangeAlt`, `UAIngOrangeSoft`, `UAIngPaper`, `UAIngText`, `UAIngMuted`, `UAIngRule`. Usar solo estos.
- Citas al pie de slide, como en la clase 10: `{\scriptsize\color{UAIngMuted}Nygard, \emph{Release It!} (2018), cap.~5.}`. En los apuntes, citas en el texto con formato (Autor, año, cap.).
- Diagramas TikZ con el estilo de la clase 10 (nodos `box` con `draw=UAIngNavy`, `rounded corners`, flechas `-{Stealth[length=1.6mm]}`, `scale=0.80, transform shape`, fuente `\scriptsize`).
- **Validador del repo** (`python3 tools/validate_tex.py`, también lo corre `make validate`): entornos balanceados; slides de la clase 6 en adelante con **al menos 18 frames**; apuntes con **al menos 8000 caracteres**. Tiene que pasar.

---

## 1. Datos de la demo que usan los documentos

Tomados del plan de la demo. Si algún nombre no coincide con lo que hay en `../opentelemetry-demo/`, gana el código de la demo y se avisa.

- **Arquitectura real:** k6 (carga a ritmo fijo) → Generator → `upper`, `lower`, `digit`, `special`. `lower` llama internamente a `digit` (dependencia oculta, no figura en el diagrama original). El Generator llama a `special` a través de Toxiproxy. Cada pedido llama a cada servicio hijo unas 4 a 5 veces (fan-out); el valor exacto sale de la calibración.
- **El Generator:** gunicorn con un pool finito de hilos (8 por defecto). Las llamadas a los hijos no tenían timeout.
- **Escenarios** (sobre `special`): `base`, `latencia`, `errores` (10%, y la variante con 50%), `intermitente` (variantes `rapida` y `cuelgue`).
- **Presets:** `00-sin-proteccion`, `01-solo-timeout`, `02-timeout-retry-ingenuo`, `03-timeout-retry-backoff-jitter`, `04-cb-consecutivo-fragil` (`fail_max` 3), `04b-cb-consecutivo-tolerante` (`fail_max` 10), `05-cb-tasa` (ventana 50, mínimo 20, umbral 50%), `06-completa`, `07-cb-sin-fallback`, `08-bulkhead` (opcional).
- **Breakers:** uno por dependencia, con nombre `generator-<dependencia>`.
- **Dashboards:** "Clase 11 · Saturación y protección" y "Clase 11 · Latencias para calibrar timeouts".
- **Números provisorios** (hasta la calibración del docente): tasa de entrada 5 pedidos/s, 8 hilos, latencia inyectada 2 s, ~22 llamadas/s a `special`.

---

## 2. Apuntes: `apuntes/clase11-apuntes.tex`

### 2.1 Objetivos

- Extensión similar a los apuntes de la clase 10 (≈35–40 KB; el actual tiene ≈13 KB).
- Teoría autosuficiente: alguien que no fue a la clase tiene que poder entender los mecanismos, cuándo usarlos, cómo configurarlos y qué cuestan.
- El ejemplo recurrente es el generador de contraseñas, descrito en términos conceptuales (un servicio que llama varias veces a cuatro dependencias). Sin comandos, sin nombres de presets ni números medidos.

### 2.2 Estructura

1. **Introducción.** La falla parcial como condición normal de un sistema distribuido. Distinción *fault → error → failure* y la idea de cortar la propagación (*crackstoppers*, zonas de deformación) (Nygard, cap. 3). La pregunta de la clase: no cómo evitar toda falla, sino cómo impedir que una falla local se propague.

2. **Anatomía de una falla en cascada.**
   - Puntos de integración como principal fuente de fallas; falla rápida contra falla lenta; "una respuesta lenta es peor que ninguna" (Nygard, cap. 4).
   - Hilos bloqueados y pools agotados como mecanismo de propagación.
   - Reacciones en cadena (el ejemplo de los 8 servidores: cada uno pasa de 12,5% a ≈14,3% de la carga, +15%) y capacidades desbalanceadas (3000 hilos contra 450) (Nygard, cap. 4).
   - **Ley de Little** (L = λ·W) aplicada al pool de hilos: con 5 pedidos/s y 9 s por pedido se necesitan ≈45 pedidos simultáneos; con 8 hilos, el sistema satura. Tiempo en cola contra tiempo de procesamiento ("tiempo de residencia", Nygard, cap. 9).
   - Por qué la CPU queda baja con el sistema saturado: los hilos esperan E/S.
   - Retroalimentación: los timeouts del cliente generan reintentos justo cuando duele más (Nygard, cap. 9; SRE Book, cap. 22).

3. **Timeouts.**
   - Para qué sirven: aislar la falla de otro (Nygard, cap. 5). Timeout de conexión contra timeout de lectura.
   - Cómo elegirlos: a partir de la distribución de latencia de la dependencia (p99 de la línea de base más un margen), no a ojo. Relación con la clase 10 (percentiles, la falacia del promedio).
   - **Presupuesto de tiempo a lo largo de la cadena:** el timeout de un servicio tiene que cubrir el de sus propias dependencias. Ejemplo: `lower`, que llama a `digit` por dentro, necesita un timeout mayor que el de `digit`; con un timeout puesto sin conocer esa cadena, `lower` falla aunque cada número "parezca razonable".
   - Timeouts y *fail fast* como dos caras de la misma moneda (Nygard, cap. 5).

4. **Reintentos.**
   - Útiles ante fallas transitorias; destructivos ante saturación o fallas persistentes. Solo sobre operaciones idempotentes.
   - **Cuenta de la amplificación:** con probabilidad de falla por llamada p y n llamadas por pedido, la probabilidad de que falle el pedido es 1 − (1 − p)ⁿ (con p = 10% y n ≈ 4,4: ≈37%). Con un reintento, la falla por llamada baja a p² (≈4% de pedidos fallidos), a costa de más llamadas. Reintentos en varias capas se multiplican: 3 capas con 3 intentos cada una dan hasta 3³ = 27 llamadas.
   - Backoff exponencial y **jitter** (*full* y *equal*), con sus fórmulas. Por qué sin jitter los clientes se sincronizan (*dogpile*, Nygard, cap. 4).
   - Retry budget; no reintentar en todas las capas; nunca reintentar un rechazo del breaker.
   - **Caso Pokémon GO** (SRE Workbook, cap. 11): demanda ≈50 veces la estimada; reintentos con backoff constante que sincronizaron a los clientes y produjeron picos de ≈20 veces el máximo anterior; la mitigación (jitter y backoff exponencial truncado).

5. **Circuit breaker.** Es la sección central; tiene que ser la más completa.
   - Idea y máquina de estados: closed, open, half-open (Nygard, cap. 5). Diagrama TikZ con las condiciones de cada transición.
   - **Qué cuenta como falla:** timeouts, errores de conexión, 5xx; no los 4xx ni los errores de validación (Nygard, cap. 5, *Fail Fast*).
   - **Cuándo abrir: fallas consecutivas contra tasa de fallas en ventana.**
     - Con fallas consecutivas, el número esperado de llamadas hasta ver k fallas seguidas, con probabilidad de falla p, es E = (1 − pᵏ) / ((1 − p)·pᵏ).
     - Tabla: k = 3 con p = 10% → ≈1100 llamadas; k = 3 con p = 50% → ≈14; k = 10 con p = 10% → nunca, en la práctica; k = 10 con p = 50% → ≈2000.
     - **El dilema:** ningún k sirve para tolerar el 10% y detectar rápido el 50%, porque las fallas consecutivas mezclan tasa de error con volumen de tráfico. A alto tráfico, un breaker con k = 3 abre con un 10% de errores y degrada el 100% del tráfico.
     - La solución: tasa de fallas sobre una ventana deslizante, con un mínimo de llamadas (el modelo de resilience4j). Umbral de llamadas lentas como variante.
   - Cuánto tiempo queda abierto; half-open: cuántas pruebas deja pasar y cuántos éxitos hacen falta para cerrar (riesgo de cerrar y abrir en bucle).
   - **Alcance:** un breaker por dependencia, dentro de un solo proceso, sin compartir estado entre procesos (Nygard, cap. 5).
   - Cómo se combina con timeouts (el timeout es requisito: sin él, el breaker no ve una falla lenta) y con reintentos (cada intento cuenta; no se reintenta un rechazo).
   - Observabilidad: los cambios de estado son una señal operativa que hay que registrar y graficar (Nygard, cap. 5).
   - **Recuadro: "una protección mal implementada".** Una librería de circuit breaker que toma un lock durante toda la llamada protegida serializa todas las llamadas a la dependencia: el mismo *single-threading* accidental contra el que advierte Nygard (cap. 5). Lección: las librerías de resiliencia también se evalúan, no se adoptan a ciegas.

6. **Degradación elegante.**
   - El fallback como decisión de producto, no técnica; involucrar a los interesados (Nygard, cap. 5).
   - La degradación tiene que ser explícita para quien recibe la respuesta.
   - Cuándo no es aceptable. Ejemplo de la demo: una contraseña sin caracteres especiales puede violar la política de contraseñas; "degradar" puede ser "responder algo incorrecto".
   - Un breaker sin fallback falla rápido, pero sigue fallando.

7. **Bulkheads.** Particionar recursos para salvar parte del barco (Nygard, cap. 5): pools de hilos por dependencia, instancias reservadas para clientes críticos, granularidad. Costo: capacidad ociosa. En el caso de la aerolínea, los pools separados que permitieron que el monitoreo siguiera respondiendo (Nygard, cap. 2).

8. **Backpressure y load shedding.**
   - "Todo problema de rendimiento empieza con una cola que crece" y "las colas tienen que ser finitas para que los tiempos de respuesta sean finitos" (Nygard, cap. 5). Opciones con una cola llena: descartar, rechazar o bloquear al productor.
   - Backpressure dentro del límite del sistema; load shedding en el borde; rechazar lo antes posible; HTTP 503 y *health checks* (Nygard, caps. 5 y 9).
   - **Caso Dressy** (SRE Workbook, cap. 11): el load shedding hizo que una región pareciera más eficiente y el balanceador le mandó más tráfico. Dos mecanismos sanos, configurados por separado, que interactúan mal.

9. **Combinar mecanismos.** El orden dentro de una llamada (bulkhead → breaker → timeout → reintentos → fallback) y por qué. Interacciones peligrosas (load shedding con balanceo de carga, autoscaling ante una dependencia colgada; SRE Workbook, cap. 11). "La cantidad de patrones aplicados no es una métrica de calidad" (Nygard, cap. 5).

10. **Caso de estudio: la excepción que dejó en tierra a una aerolínea** (Nygard, cap. 2). Recorrer la cadena: falla en el cierre de un *statement* → fuga de conexiones → pool agotado → hilos bloqueados → llamadas RMI sin timeout → kioscos y respuesta telefónica caídos. Marcar en cada paso qué mecanismo de la clase la habría cortado (Nygard, cap. 3, *Stopping Crack Propagation*).

11. **Modelo del curso P-F-G-S-T**, con el formato de la clase 10.

12. **Conclusión** con `uakeybox`.

13. **Secciones finales de la plantilla**, con los mismos títulos y en el mismo orden que la clase 10, pero **con contenido propio de esta clase** (no el texto genérico actual):
    - *Síntesis razonada de la clase*: la cadena de decisiones de la clase (medir → elegir timeout → decidir reintentos → configurar breaker → definir degradación).
    - *Bibliografía guiada y ruta de profundización*, con una subsección *Referencias canónicas* en el formato de la clase 10 (ver 2.3).
    - *Conexión con el Trabajo Final Integrador*: identificar en el sistema del grupo cada dependencia remota y decidir timeout, política de reintentos, breaker y degradación, justificando los valores.
    - *Autoevaluación conceptual*: preguntas propias de la clase (por ejemplo, por qué una dependencia lenta es peor que una caída; calcular la saturación con la ley de Little; por qué el timeout de `lower` debe ser mayor que el de `digit`).
    - *Profundización autocontenida v9*: mantener sus subsecciones (problema, límite e invariante; método de análisis; caso transferible; errores frecuentes), pero con un caso transferible de resiliencia (por ejemplo, un checkout que depende de un servicio de pagos lento) en lugar del genérico de reservas.
    - *Lectura guiada*: qué buscar en cada capítulo de la bibliografía.
    - *Aplicación al Trabajo Final Integrador*: el ADR breve con la decisión de resiliencia del grupo; evidencia esperada.
    - *Autoevaluación avanzada*: preguntas de mayor nivel (el dilema del breaker con números, interacción entre mecanismos, cuándo no degradar).

### 2.3 Referencias canónicas

Verificar autores, años y capítulos contra las fuentes antes de incluirlas:

1. Nygard, M. T. (2018). *Release It! Design and Deploy Production-Ready Software* (2.ª ed.). Pragmatic Bookshelf. Caps. 2, 3, 4, 5 y 9.
2. Beyer, B., Jones, C., Petoff, J. y Murphy, N. R. (2016). *Site Reliability Engineering: How Google Runs Production Systems*. O'Reilly. Caps. 21 y 22.
3. Beyer, B., Murphy, N. R., Rensin, D. K., Kawahara, K. y Thorne, S. (2018). *The Site Reliability Workbook*. O'Reilly. Cap. 11.
4. Brooker, M. (2015). *Exponential Backoff and Jitter*. AWS Architecture Blog. (Y, si se verifica, *Timeouts, retries, and backoff with jitter*, Amazon Builders' Library.)
5. Little, J. D. C. (1961). A Proof for the Queuing Formula: L = λW. *Operations Research*, 9(3), 383–387.
6. Documentación de resilience4j, módulo *CircuitBreaker* (modelo de ventana deslizante con mínimo de llamadas).

---

## 3. Slides: `slides/clase11.tex`

### 3.1 Objetivos

- Entre 30 y 35 frames (el validador exige al menos 18).
- Siguen el orden y los tiempos de la clase. Cada bloque de demo tiene, como mínimo: una slide de **predicción** (pregunta al curso, con `\pause` antes de revelar), una de **qué mirar** (qué panel del dashboard o qué traza) y una de **concepto** (lo mínimo para explicar lo que se vio).
- **Sin comandos ni nombres de archivos de configuración.** Los escenarios y presets se nombran como en el script de la demo (por ejemplo, "Escenario: errores 10% · Preset: `04-cb-consecutivo-fragil`"), para que el docente sepa qué ejecutar.
- Los números que dependen de la calibración se escriben con el valor provisorio de la sección 1 y un comentario `% TODO calibrar` en la misma línea.
- Cita al pie en cada slide con contenido tomado de la bibliografía.

### 3.2 Estructura (bloques y minutos)

| # | Bloque (min) | Frames |
|---|---|---|
| 1 | Portada | Igual que hoy. |
| 2 | **Apertura (10')** | (a) Retomar el cierre de la clase 10: la cascada de cuatro pasos y el retry como combustible. (b) Pregunta disparadora: "si `special` se pone lenta, ¿qué le pasa al Generator? ¿y al usuario?". (c) La idea central: no evitar la falla, sino contener su propagación. |
| 3 | **Arquitectura (15')** | (a) Diagrama TikZ del sistema real: k6 → Generator → cuatro hijos, Toxiproxy delante de `special`. (b) "¿Qué falta en este diagrama?", con `\pause` para revelar `lower → digit` como dependencia oculta. (c) Fan-out: cuántas llamadas hace cada pedido (valor provisorio). (d) Qué vamos a mirar: los dos dashboards y una traza en Jaeger. |
| 4 | **Demo 1: dependencia lenta (25')** | (a) Predicción: "inyectamos 2 s de latencia en `special`, sin protección: ¿qué pasa?". (b) La cuenta con la ley de Little (5 × 9 ≈ 45 contra 8 hilos). (c) Qué mirar: pedidos en vuelo contra tamaño del pool, CPU baja, latencia del cliente contra latencia del servidor (la diferencia es tiempo en cola). (d) Concepto: timeout de conexión y de lectura; "una respuesta lenta es peor que ninguna". (e) Cómo elegir el timeout: p99 de la línea de base más un margen, en el dashboard de latencias; el caso `lower → digit`. (f) Prueba con `01-solo-timeout`: ya no satura, pero falla todo. "Fallar rápido no es funcionar." |
| 5 | **Reintentos (15')** | (a) La cuenta de la amplificación: 1 − (1 − p)ⁿ con n ≈ 4,4. (b) Reintentos en capas: 3³ = 27. (c) Backoff exponencial y jitter (gráfico TikZ simple de los tiempos de espera sin jitter y con jitter). (d) Caso Pokémon GO. (e) Prueba sugerida: escenario de errores 10% con `02` contra `03`, y la aclaración de que a esta escala el jitter no muestra diferencia visible (con pocos clientes no hay sincronización). |
| 6 | **Configurar un circuit breaker (15')** | (a) Máquina de estados redibujada en TikZ, con las condiciones de cada transición. (b) Las decisiones de configuración: qué cuenta como falla, cuándo abrir, cuánto tiempo abierto, half-open, alcance, combinación con reintentos, fallback, observabilidad. (c) **El dilema:** tabla de llamadas esperadas hasta k fallas seguidas (k = 3 y k = 10, con p = 10% y p = 50%). (d) La solución: tasa de fallas en ventana con mínimo de llamadas. |
| 7 | Pausa (10') | Una slide de pausa. |
| 8 | **Taller (25')** | (a) Consigna para los equipos: un timeout por dependencia justificado con el p99 y con la cadena `lower → digit`; política de reintentos; configuración del breaker; decisión de fallback; y una predicción para cada escenario. (b) Una slide con los datos que tienen que usar (referencia a la ficha técnica que reparte el docente). |
| 9 | **Pruebas en vivo (30')** | Una slide por prueba, con escenario + preset, la pregunta para votar y qué mirar: (1) errores 10% con `04-cb-consecutivo-fragil`; (2) errores 50% con `04b-cb-consecutivo-tolerante`; (3) errores 10% y 50% con `05-cb-tasa`; (4) intermitente con `06-completa`, mirando el ciclo del breaker y comparando `half_open_max_calls` 1 contra 0; (5) latencia con `07-cb-sin-fallback`. |
| 10 | **Cierre (10')** | (a) Lo que no probamos y por qué: bulkheads, backpressure y load shedding, con el caso Dressy en una slide. (b) Modelo P-F-G-S-T de la clase. (c) Idea central en un `block`. (d) Puente a la clase siguiente (chaos engineering, SLOs e incidentes): "hoy inyectamos fallas a mano; ¿cómo se convierte eso en un experimento con hipótesis?". (e) Ticket de salida: propiedad principal, supuesto decisivo, costo aceptado y condición bajo la cual cambiarían el diseño. |

### 3.3 Qué pasa con las slides actuales

- **Se eliminan** las slides genéricas de plantilla: "Caso de diseño: decidir antes de nombrar tecnología", "Checkpoint de comprensión", "Checkpoint de resiliencia".
- **Se integran donde corresponde** las que tienen contenido útil: "Retry budget" (bloque 5), "Backpressure vs load shedding" (bloque 10), "Pregunta correcta" (bloque 2).
- El diagrama de estados actual se reemplaza por uno con las condiciones de cada transición.

---

## 4. Fases

Al terminar cada fase: correr `python3 tools/validate_tex.py`, intentar compilar (`make clase11` o `latexmk -xelatex` sobre el archivo) si hay TeX disponible, hacer commit y **frenar** con un resumen: qué se hizo, qué fuentes se usaron (capítulos), qué quedó con `% TODO`, resultado del validador y de la compilación, y desvíos respecto de este plan.

### Fase 0 — Preparación
- Crear la rama `feat/improve-class-11` desde `main`. Commitear este plan.
- Leer la clase 10 completa (slides y apuntes) y el plan de la demo.
- Leer en la bibliografía los capítulos indicados en 0.2.
- **Aceptación:** resumen al docente con (1) las convenciones de estilo detectadas en la clase 10 que se van a replicar y (2) cualquier dato del plan de la demo que no coincida con el código de `../opentelemetry-demo/`.

### Fase 1 — Apuntes
- Reescribir el cuerpo de `apuntes/clase11-apuntes.tex` según la sección 2.
- **Aceptación:**
  - el validador pasa;
  - todas las secciones de 2.2 están presentes y las finales tienen contenido propio de la clase (ningún texto genérico copiado de la versión anterior);
  - cada cita textual indica fuente y capítulo; cada número tiene su cuenta o su fuente;
  - el documento compila, o queda indicado que no se pudo compilar y por qué.

### Fase 2 — Slides
- Reescribir el cuerpo de `slides/clase11.tex` según la sección 3.
- **Aceptación:**
  - el validador pasa (al menos 18 frames, entornos balanceados);
  - los bloques y minutos siguen la tabla de 3.2;
  - los nombres de escenarios, presets, breakers y dashboards coinciden con los del plan de la demo;
  - todos los números provisorios llevan `% TODO calibrar`;
  - compila, o queda indicado que no se pudo compilar.

### Fase 3 — Revisión cruzada
- Verificar la coherencia entre apuntes y slides: los mismos conceptos con los mismos nombres, las mismas fórmulas y números, y que cada concepto de las slides tenga su desarrollo en los apuntes.
- Listar en el resumen todos los `% TODO calibrar` de las slides, para que el docente los complete después del ensayo de la demo.
- **Aceptación:** lista de incoherencias encontradas y corregidas; lista de `% TODO` pendientes.

---

## 5. Aclaraciones

1. **Los apuntes no dependen de la demo.** Pueden mencionar el generador de contraseñas como ejemplo, pero no presets, escenarios, dashboards ni números medidos.
2. **Las slides no reemplazan a los apuntes.** Si una idea necesita más de una slide para explicarse, va completa a los apuntes y la slide queda con lo mínimo.
3. **Las fórmulas y los números tienen que coincidir** entre apuntes, slides y la matriz de hipótesis del plan de la demo (sección 6 de ese plan).
4. **No inventar casos.** Los casos que se usan son los de la bibliografía: la aerolínea (Nygard, cap. 2), Pokémon GO y Dressy (Workbook, cap. 11), y si hace falta el lanzamiento del cap. 15 de Nygard.
5. **El docente calibra después.** Los números marcados `% TODO calibrar` los reemplaza él tras el ensayo; también puede agregar capturas de pantalla del ensayo como plan B.

## 6. Fuera de alcance

- La guía de ejercicios, la guía resuelta (que hoy tiene 15 de 20 respuestas genéricas) y la guía docente de la clase 11. Quedan desalineadas con la nueva clase y se encaran en un plan aparte.
- La ficha técnica y la ficha del taller que reparte el docente.
- Cualquier cambio en la demo (`../opentelemetry-demo/`).
