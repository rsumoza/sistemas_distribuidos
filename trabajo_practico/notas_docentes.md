# ASTERIA ONLINE - NOTAS PARA DOCENTES
## Objetivos pedagógicos de la progresión de entregas y racional de diseño
## Sistemas Distribuidos - Universidad Austral

-----------------------------------------------------------
PARTE 1 - Objetivos cognitivos de cada entrega
-----------------------------------------------------------

La progresión de tres entregas no es solo una forma de repartir carga de
trabajo en el tiempo: cada entrega está pensada para forzar un tipo de
razonamiento distinto, y cada una depende de que la anterior haya quedado
bien resuelta. El objetivo de fondo del trabajo práctico es que el alumno
entienda que en un sistema distribuido el problema de negocio y la garantía
que hay que sostener son estables, mientras que el mecanismo técnico para
sostenerla debe evolucionar a medida que el entorno se vuelve más hostil.
Esa es la idea central que atraviesa las tres entregas y que se busca que
quede grabada al final del trabajo.

**Entrega 1:** pensar en términos de negocio antes que de tecnología.

El objetivo cognitivo de la primera entrega es que el alumno aprenda a
separar el problema de negocio del mecanismo que lo resuelve, antes de que
sepa cómo lo va a resolver. Es deliberado que en esta entrega esté prohibido
proponer solución: se busca evitar el reflejo típico del estudiante de
ingeniería de saltar directo a la arquitectura sin primero preguntarse qué
es lo que realmente hay que garantizar y para quién. Identificar una falla
de cliente (pérdida de señal, reintento, doble tap en la pantalla) es el
disparador más accesible para esto, porque son fallas del dominio que el
alumno ya vivió como usuario de cualquier app móvil, y le permiten entrar al
ejercicio sin necesidad de conocimiento previo de sistemas distribuidos. El
mínimo de seis pares busca que no se queden en los tres o cuatro problemas
obvios de los casos de uso de referencia, sino que efectivamente exploren
el contexto completo (juego, infraestructura, negocio) buscando problemas
menos evidentes.

**Entrega 2:** aprender que hay más de un mecanismo posible, y que elegir uno
tiene costo.

La segunda entrega introduce dos saltos cognitivos distintos a la vez. El
primero es puramente técnico: aparecen las fallas de infraestructura y,
con ellas, el teorema CAP como herramienta de decisión real y no teórica,
porque el escenario de particionamiento entre datacenters obliga a elegir
entre consistencia y disponibilidad de forma concreta, subsistema por
subsistema. El segundo salto es más sutil: al pedir una solución para cada
par ya identificado en la Entrega 1, el alumno descubre que la garantía de
negocio que definió antes no cambia, pero el mecanismo para sostenerla
ahora es más complejo porque el entorno (con fallas de infraestructura)
es más hostil que el de la Entrega 1 (solo con fallas de cliente). Permitir
un máximo de un "no se encontró solución" bien justificado cumple una
función pedagógica específica: evita que el alumno fuerce una solución
artificial solo para completar la tabla, y lo obliga a demostrar que
entendió el problema lo suficiente para argumentar honestamente por qué
no tiene, con el conocimiento actual del curso, una solución satisfactoria.
El requisito de al menos un par con dos soluciones distintas siembra el
material que se va a usar recién en la Entrega 3, anticipando que casi
ningún problema de sistemas distribuidos tiene una única respuesta
correcta.

El mínimo de cuatro fallas de infraestructura repartidas sobre al menos
tres pares distintos está calibrado con dos intenciones. Por un lado,
obliga a que aproximadamente la mitad de los pares se enfrente a
infraestructura, para que no quede como un anexo al final. Por otro, al
pedir más fallas que pares, deja espacio para que algún par acumule dos
fallas de infraestructura distintas (típicamente una caída y un
particionamiento sobre el mismo problema), que es exactamente donde se ve
si el grupo entendió que son escenarios de naturaleza diferente y no dos
nombres para lo mismo.

**Entrega 3:** comparar soluciones y pensar como un atacante.

La tercera entrega agrega dos capacidades de orden más alto. La primera es
el análisis de trade-offs: no alcanza con que la solución funcione, hay que
poder explicar qué se sacrifica al elegirla (latencia, complejidad,
consistencia, costo) y comparar objetivamente las dos soluciones del par
que se guardó para este momento. Esto fuerza al alumno a razonar en
términos de ingeniería real, donde raramente hay una solución sin costo. La
segunda capacidad es el pensamiento adversarial: las fallas de seguridad
piden que el alumno mire sus propios mecanismos de tolerancia a fallas
(pensados en las entregas anteriores para casos honestos, como reintentos
ante pérdida de señal) y se pregunte cómo un cliente malicioso podría
explotarlos a propósito. Este es el salto cognitivo más exigente del
trabajo, porque requiere revisar críticamente decisiones ya tomadas, no
solo agregar cosas nuevas, y es intencional que llegue al final, cuando el
alumno ya conoce el sistema completo y tiene más herramientas para
detectar dónde está la superficie de ataque.

La defensa oral final cumple una función que la entrega escrita no puede
cubrir: obliga a que cada integrante pueda justificar decisiones que quizás
no tomó personalmente, lo que desalienta el reparto del trabajo en
compartimentos estancos y permite detectar rápidamente qué grupos
entendieron el razonamiento y cuáles solo completaron una tabla.

En síntesis, la progresión va de negocio a técnica, de técnica simple a
técnica con decisiones sin respuesta única, y de ahí a pensamiento crítico y
adversarial sobre el propio diseño. Cada entrega reutiliza íntegramente el
trabajo de la anterior: nada se descarta, se le van agregando capas.

-----------------------------------------------------------
PARTE 2 - La sección de Garantías y por qué existe
-----------------------------------------------------------

La sección 5 del enunciado, dedicada exclusivamente a definir qué es una
garantía y cómo debe escribirse, es un agregado posterior al diseño
original, y responde a un problema concreto que se detectó al revisar la
consistencia interna del trabajo.

El principio "la garantía es fija, el mecanismo evoluciona" solo funciona si
la garantía está bien escrita desde el arranque. Si un grupo enuncia en la
Entrega 1 una garantía que en realidad es un mecanismo disfrazado ("el
sistema reintenta si el jugador pierde señal"), o que trae adentro una
promesa de certeza absoluta ("el jugador nunca pierde el oro pagado"), esa
garantía va a resultar imposible de sostener sin retoques cuando aparezcan
fallas más exigentes en las entregas siguientes. El grupo entonces se ve
tentado a "adaptar" la garantía, y ahí se pierde todo el valor pedagógico
de la progresión: si la garantía se puede mover, nunca se siente la
tensión de tener que cambiar el mecanismo para sostenerla.

La solución adoptada fue atacar el problema en el origen, con dos reglas de
redacción explícitas:

- La garantía expresa un interés a proteger (qué le pasa al jugador, a su
  oro, a sus objetos), y tiene que poder leerse sin mencionar de qué falla
  se protege ni cómo se implementa.
- La garantía no lleva cuantificadores absolutos ("nunca", "siempre") ni
  números concretos ("en menos de 2 segundos", "0% de pérdida"). El grado
  de certeza no es parte del interés protegido: es un atributo de la
  solución, y por lo tanto varía con cada mecanismo y con cada tipo de
  falla.

La consecuencia lógica de esas dos reglas es que, cuando una solución no
logra sostener el interés de forma completa frente a una falla dura, eso no
se registra como una garantía que se debilitó, sino como una brecha
documentada en el trade-off de la Entrega 3. Esto convierte un problema
que amenazaba la coherencia del trabajo en material de análisis, y refuerza
justo la capacidad que ya se busca desarrollar en esa entrega.

Vale la pena señalar que esta distinción entre el interés protegido y el
grado de certeza logrado es en sí misma un buen disparador de debate en
clase, y probablemente convenga trabajarla en el aula antes de la Entrega 1
en lugar de confiar en que la lectura de la sección 5 alcance. Es la clase
de idea que se entiende mucho mejor discutiendo ejemplos concretos mal
escritos y reformulándolos entre todos.

-----------------------------------------------------------
PARTE 3 - Por qué se acotó el universo respecto al original
-----------------------------------------------------------

La primera versión de trabajo (más cercana al material de partida original)
incluía una biblioteca más amplia de conceptos de diseño de juego: gremios,
guerras de gremios, captura de territorio, arenas, ciudades y bosques, y un
número fijo de regiones en el mapa. Se decidió dejar todo eso afuera del
enunciado final, y la razón no es que sean conceptos inválidos, sino que
ninguno de ellos agrega un problema de sistemas distribuidos que no esté ya
cubierto por los elementos que sí quedaron (zonas, instancias, datacenter
hogar, evento global, directorio de zonas, oro). Agregarlos hubiera sumado
volumen de lectura y de dominio de juego sin sumar dificultad ni variedad
real al ejercicio central de la materia. El criterio de corte que se usó en
todo momento fue: cada elemento del contexto de juego tiene que existir
porque genera al menos un problema de concurrencia, particionamiento,
consistencia o seguridad que valga la pena, no porque haga al juego más
completo o más entretenido como producto.

Ese mismo criterio es el que llevó a eliminar el concepto de "grupo" cerrado
de jugadores que existía en versiones previas: exigir que un grupo se
forme antes de entrar a pelear agregaba una capa de lógica social y de
coordinación previa que no aporta nada distinto a lo que ya aporta el
combate colectivo sin formación previa (que además permite unificar el
modelo de la mazmorra chica y el evento masivo bajo la misma regla,
diferenciándose solo en escala y en si es mono o multi-datacenter).

Por el mismo criterio, pero en sentido inverso, sí se incorporaron algunas
reglas que a primera vista parecen detalles de juego y no lo son. La regla
de que un jugador no puede estar en más de una instancia a la vez es el
caso más claro: es una invariante global que hay que sostener cuando las
instancias pueden crearse en datacenters distintos y el jugador puede
intentar entrar a dos casi en simultáneo. Lo mismo vale para el tiempo
límite de combate por zona, que en el evento global obliga a coordinar un
timer entre los tres datacenters.

Sobre por qué no se incluyó un caso de uso dedicado a migración de
datacenter, o una comparativa explícita entre estrategias de migración: la
decisión fue tratar la migración como una consecuencia de una falla de
infraestructura (caída de un datacenter), no como un caso de uso de negocio
en sí mismo. La distinción es deliberada: un caso de uso en este trabajo
describe una interacción con valor de negocio (alguien entra a una
mazmorra, alguien compra oro), mientras que la migración es un mecanismo
técnico que puede aparecer como Solución S frente a esa falla, en la
Entrega 2, pero no tiene sentido de negocio propio para justificar un cuarto
caso de uso. Dicho de otro modo: se prefirió dejar la migración como algo
que los grupos van a tener que descubrir y proponer ellos mismos al resolver
sus pares P,G,F de infraestructura, en lugar de entregársela resuelta o
insinuada de antemano en el contexto. Lo mismo aplica a la comparativa entre
estrategias: forzar esa comparación desde el enunciado hubiera anticipado
el ejercicio que se busca que el grupo haga solo en la Entrega 3, cuando
elige el par con dos soluciones y las compara.

En términos más generales, la decisión de fondo en todo el rediseño fue
alejarse de un modelo con puntos de falla predefinidos por caso de uso
(donde el docente ya sabe de antemano dónde está cada problema y el alumno
solo tiene que encontrarlo) a favor de un modelo de descubrimiento libre
dentro de un contexto acotado pero completo. Los tres casos de uso de
referencia (Mazmorra del Jefe, Jefe de Evento Global, Compra de Oro) alcanzan
para que el alumno entienda el nivel de detalle esperado y tenga por dónde
empezar, pero el contexto de juego, infraestructura y negocio en su
conjunto (secciones 2, 3 y 4 del enunciado) es deliberadamente más rico que
esos tres casos, para que el mínimo de seis pares de la Entrega 1 obligue a
buscar problemas que el enunciado no señaló de forma explícita. Un ejemplo
concreto que se dejó sin resolver a propósito es el problema del directorio
de zonas como estado compartido multi-datacenter: está descripto con
suficiente detalle como para que un grupo atento lo detecte y lo trabaje,
pero no se lo señaló como caso de uso aparte, precisamente para ver si los
grupos son capaces de encontrarlo por su cuenta.

Nota sobre las garantías transversales: en versiones previas la
trazabilidad de operaciones y la continuidad ante sobrecarga aparecían como
una categoría separada de "garantías transversales". En el enunciado final
esas dos ideas están incorporadas como reglas de negocio dentro de la
sección 4 (retención de registros por 90 días, prioridad de los jugadores
conectados ante picos de demanda). La razón es coherente con el modelo de
descubrimiento libre: nombrarlas como categoría aparte hubiera equivalido a
señalarle al alumno dónde buscar, mientras que dejarlas como reglas del
contexto permite que las detecte por sí mismo al explorar la sección 4.

-----------------------------------------------------------
PARTE 4 - Estimación de esfuerzo
-----------------------------------------------------------

Estimación para un equipo de 3 alumnos, expresada en horas de trabajo de
equipo (no horas-persona):

- Entrega 1: entre 10 y 14 horas. El trabajo mecánico es poco; lo caro es el
  cambio de chip. Es esperable que la primera tanda de garantías venga con
  "nunca" adentro o con el mecanismo incorporado, y que haya que
  reescribirlas una o dos veces. Conviene contar con al menos una sesión
  que termina en descarte.
- Entrega 2: entre 25 y 30 horas. Es la entrega más pesada, y es donde
  entra el diseño técnico real, la decisión CAP por subsistema, las cuatro
  fallas de infraestructura y el par con dos soluciones.
- Entrega 3: entre 15 y 20 horas, más la preparación de la defensa oral.
  Los trade-offs son relativamente mecánicos una vez que las soluciones
  están claras; lo caro es el pensamiento adversarial y la comparación
  objetiva.

Total del orden de 50 a 65 horas de trabajo de equipo, aproximadamente 17 a
22 horas por persona a lo largo del cuatrimestre, asumiendo un reparto
razonable. Con cinco o seis semanas entre entregas el ritmo es cómodo; con
tres semanas, la Entrega 2 se convierte en el cuello de botella y conviene
considerar bajar el mínimo de fallas de infraestructura.
