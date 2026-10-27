# Estructura de una solución - V1
Este documento provee una estructura más ordenada para describir una solución en un problema del TP.

Esto está orientado a poder entender la solución en su conjunto y documentar bien los comportamientos que deben aparecer
en la solución.

Esta primera de versión solo tenemos algunos lineamientos para presentar, pero sirven bastante para aclarar el panorama.

## Describir cada interacción entre componentes
En todo sistema distribuído, hay que describir cada escenario de interacción de alto nivel entre los componentes del sistema.

Esto es importante porque en esa interacción debe incluir:
- método de comunicación (en este caso es gRPC)
- operaciones posibles

Después se debe describir que pasa internamente en el DC y en el cliente, pero esto define el contrato entre ellos.
Lo que pasa internamente en cada componente (como implementa su solución) es otro escenario / documento.

# Ejemplo - Interacción Cliente - DC para el ingreso a zona de combate
Este escenario es solo describe la interacción entre el cliente y un DC para tratar de ingresar.

Lo voy a ejemplificar más que nada con algunas definiciones y más preguntas que deberían contestarse para completar la interacción
- El cliente llama un método "_Instancia/SolicitarIngreso_" a un DC con estos datos:
  - el cliente envía:
    - envía un **requestId** único que generó y almacenó
    - el **InstanceId** de la zona de batalla que quiere ingresar
    - su **PlayerId** que lo identifica
  - el DC responde:
    - 200 si el ingreso fue aceptado y el ingreso a la zona está habilitado
    - 400 si tuvo algún problema que no permitió el ingreso, con un texto que describe el problema.
    - 503 si el servicio no está disponible o no respondió a tiempo
  - El cliente puede reintentar el pedido ante un error 503 como condición normal, con los errores 400 debería ver que pasó antes.
- Si el cliente por alguna causa necesita saber el estado de una solicitud, puede llamar a "_Instancia/ConsultarIngreso_" para saber el estado de un **requestId**.

Preguntas:
- ¿No definimos como se autentica el cliente en cada request, es un token Oauth? ¿Pasa credenciales cada vez?
  - si los requests ya vienen asociados a una sesión de usuario no necesito su **PlayerId**
- ¿Los clientes reciben algún **battleId** o algo parecido para después usar en la batalla misma?
- Tampoco definimos si el frontend del DC es un balanceador de carga o es un solo monolito que recibe todo.
  - Tampoco que hacemos si el request llega a un DC "incorrecto". ¿Cómo defino incorrecto? ¿Es el de la instancia o del usuario? ¿Qué pasa si migramos de DC para algo?
- En _Instancia/SolicitarIngreso_:
  - me alcanza con un 400 o necesito más detalle de lo que falló?
  - lo mismo con el 503, separamos no disponible de timeout?
-  ¿Si el cliente por alguna causa tuvo de reinstalar la aplicación en el teléfono, borró toda la data, como recupera sus estados?
  - Como lo definí nos faltaría un método para consultar mis pedidos de ingreso para saber que pasó con cada uno y no repetir.
- ninguno se preguntó si gRPC usa los mismos códigos de status HTTP?
  - [Chan](https://grpc.io/docs/guides/status-codes/)
  - [Revisen esto](https://docs.accelbyte.io/gaming-services/modules/foundations/extend/advanced-topics/extend-app-request-handling/#grpc-to-http-status-code-mapping) y ajusten mi definición
