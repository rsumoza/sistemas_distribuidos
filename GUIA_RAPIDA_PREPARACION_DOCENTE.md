# Guía rápida de preparación docente - v11.4

Este documento funciona como índice de ensayo. El contenido completo está en las guías docentes.

## Protocolo común

Antes de cada clase, debe poder:

1. explicar el propósito en una frase;
2. dibujar de memoria el caso conductor;
3. explicar cada núcleo en 30 segundos, 2 minutos y 5 minutos;
4. declarar dónde termina cada analogía;
5. construir una ejecución normal y una adversarial;
6. responder qué garantía ofrece el mecanismo y qué no ofrece;
7. ejecutar una demo y sostener una alternativa de pizarra;
8. formular una pregunta de transferencia al Trabajo Final;
9. nombrar la evidencia que conservará para la auditoría;
10. proteger ocho minutos finales para síntesis y exit ticket.

## Clase 06 - control técnico

- ¿Dónde puede estar el byte cuando `write()` retorna?
- ¿Por qué un `COMMIT` durable no exige escribir todas las páginas?
- ¿Qué relación existe entre LSN, pageLSN y REDO?
- ¿Qué cambian STEAL/NO-STEAL y FORCE/NO-FORCE?
- ¿Por qué WAL no produce exactly-once por sí solo?
- ¿Qué reduce MVCC y qué no elimina?
- ¿Por qué una transacción larga produce bloat?
- ¿Por qué el planner puede ignorar un índice existente?
- ¿Cuándo un sequential scan es correcto?
- ¿Qué representan write, read y space amplification?
- ¿Cuándo un stall protege y cuándo revela falta de capacidad?

**Actividad que no debe faltar:** completar el timeline WAL y justificar la frontera de ACK.

## Clase 07 - control técnico

- ¿Por qué un log distribuido no es simplemente una cola?
- ¿Dónde existe orden total y dónde no?
- ¿Cómo afecta la key a orden, paralelismo y skew?
- ¿Qué diferencia hay entre event ID, offset, position y committed offset?
- ¿Qué cubre el producer idempotente?
- ¿Por qué at-least-once no garantiza éxito del negocio?
- ¿Qué puede coordinar una transacción Kafka y qué queda fuera?
- ¿Qué resuelve outbox y por qué el relay puede repetir?
- ¿Por qué inbox y efecto deben persistirse atómicamente?
- ¿Cómo se recupera un state store junto con su progreso?
- ¿Qué significan event time, watermark y late data?

**Actividad que no debe faltar:** mover el crash entre efecto y offset y comparar pérdida con duplicación.

## Clase 08 - control técnico

- ¿Qué significan C, A y P en el modelo del teorema?
- ¿Un `503` rápido cuenta como disponibilidad CAP?
- ¿Cómo produce la partición indistinguibilidad?
- ¿Qué agrega PACELC y qué estatus conceptual tiene?
- ¿Qué garantiza `R+W>N` y qué no garantiza?
- ¿Qué cambia con sloppy quorum?
- ¿Cómo detecta un version vector concurrencia?
- ¿Por qué Dynamo original no es sinónimo de DynamoDB?
- ¿Por qué TrueTime devuelve un intervalo?
- ¿Por qué TrueTime no reemplaza consenso?
- ¿Qué compra commit wait?
- ¿Por qué Spanner no contradice CAP?

**Actividad que no debe faltar:** decidir para el último asiento antes de introducir CP/AP.

## Clase 09 - control técnico

- ¿Qué caracteriza a un monolito modular sano?
- ¿Qué prima agrega una frontera de red?
- ¿Qué autonomía concreta compra el servicio?
- ¿Cada bounded context debe ser un proceso?
- ¿Database-per-service exige un servidor físico propio?
- ¿Quién puede escribir el dato y cómo leen los demás?
- ¿Cuándo conviene RPC, evento o consulta?
- ¿Por qué dual write no tiene un orden seguro?
- ¿Qué resuelve outbox y qué deja abierto?
- ¿Por qué una saga necesita estado durable?
- ¿Por qué compensar no es volver al pasado?
- ¿Cuándo elegir coreografía u orquestación?
- ¿Qué evidencia demuestra que la extracción compró autonomía?

**Actividad que no debe faltar:** construir las dos ventanas de dual write antes de presentar outbox.

## Ensayo final de 12 minutos por clase

- 2 min: caso y predicción;
- 3 min: intuición y límite de la analogía;
- 3 min: formalización;
- 2 min: falla o contraejemplo;
- 1 min: costo y evidencia;
- 1 min: síntesis y transferencia.

Grabe el ensayo y revise velocidad, silencios después de preguntar, precisión del vocabulario y legibilidad de los diagramas.
