# Contradicciones del sistema — Lo que no puede ser verdad a la vez

**Fecha**: 2026-08-02 · **14 contradicciones abiertas** · ~35 minutos

Una contradicción es cuando dos cosas que se dieron por buenas **no pueden cumplirse las dos**. No
son errores de nadie: aparecen cuando un proyecto se define en varias conversaciones, con varias
personas y a lo largo de semanas.

Importan porque **si no se resuelven, alguien las resuelve por su cuenta al construir** — y esa
elección silenciosa se descubre tarde, cuando ya hay código encima.

Están ordenadas por gravedad. **Las tres primeras bloquean la planificación de la primera entrega.**

## Cómo responder

- Marque la letra y explique en **Descripción**. Es donde está el valor real de este cuadernillo.
- Si la contradicción es un malentendido nuestro, dígalo: *"no se contradicen, lo que pasa es que…"*
- Si no puede decidir ahora, escriba **"lo hablamos en la llamada"** y la dejamos anotada.

---

## C-01 · 🔴 Los suscriptores no pueden obtener WhatsApp Business API

**Contexto**

En **V-06** nos explicaron el problema con toda claridad:

> *"para tener la cuenta API se necesita una empresa registrada con documentos verificables ante
> Meta, y aquí es donde está el problema, que la mayoría de suscriptores no es empresa formal…
> con seguridad ningún usuario tendría una empresa registrada con documentos verificados"*

Y en **V-29** lo confirmaron por otro lado: *"esta modalidad de préstamo de dinero es informal…
no está regulado por ningún país, es algo alegal"*.

**Esto cambia la naturaleza del problema.** Hasta ahora teníamos anotado que faltaba hacer un
trámite. No es un trámite: es que **la puerta está cerrada** para el tipo de empresa que va a usar
el sistema.

Y de ese canal dependen **los dos controles antifraude que ustedes describieron en C-99**:

1. El **QR al WhatsApp del cliente** para liberar el efectivo de una venta.
2. El **extracto al cierre**, que permite al cliente detectar un pago que el cobrador no registró.

Sin canal, la primera entrega sale **sin ningún control antifraude** — y el antifraude es lo que
distingue a este producto de TryController.

**Pregunta**

¿Cómo se resuelve el canal de mensajería al cliente final?

**Opciones de respuesta**

A) **La cuenta de WhatsApp la pone la empresa del software**, no cada suscriptor. Un solo remitente
   verificado para todos los clientes *(es la salida más viable: nuestra empresa sí puede
   registrarse ante Meta)*
B) **Telegram** en lugar de WhatsApp — **no exige empresa verificada**. El costo baja a cero, pero
   el cliente final tiene que tener Telegram instalado
C) **SMS** — funciona en cualquier teléfono, pero es más caro por mensaje y no permite botones ni QR
D) **La primera entrega sale sin control antifraude** y se resuelve después
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

Si elige **A**, hay una consecuencia: todos los mensajes saldrían del **mismo número**, el de
ustedes, no del de cada empresa prestamista. El cliente final vería un remitente que no reconoce.
¿Es aceptable? ¿O prefieren que se vea el nombre de cada empresa en el texto del mensaje?

Si elige **B**, la pregunta es: **¿cuántos de sus ~2.000 clientes usan Telegram?** En Brasil no es
el canal habitual.

`[Answer]:`

---

## C-02 · 🔴 Si la mayoría paga por PIX, el diseño de caja describe una minoría

**Contexto**

En **V-14** dijeron algo que cambia el peso de todo lo demás:

> *"la mayoría de clientes pagan por transferencia bancaria (**PIX**) entonces si el cliente mandó
> su pago ya el cobrador no tiene que ir donde el cliente"*

Todo lo que hemos definido hasta hoy gira alrededor del **efectivo**: la caja del cobrador que
cierra a cero (`C-50`), el cobrador que usa lo recaudado para prestar, gasolina y sueldos
(`C-52`, `C-53`), el QR para liberar el efectivo de una venta, y **el descuadre de caja como señal
principal de fraude** (`V-02`).

Si la mayoría de los pagos son PIX, ese modelo **describe la parte pequeña del negocio**. Y hay algo
más: el fraude nº 1 que describieron —*cobrar y no registrar*— **casi no aplica a un pago por PIX**,
porque ese pago ya quedó registrado en el banco del prestamista, lo anote el cobrador o no.

**Pregunta**

De cada 10 pagos que reciben, ¿cuántos son en efectivo y cuántos por PIX?

**Opciones de respuesta**

A) Casi todo efectivo (8 o más de cada 10)
B) Mitad y mitad
C) Casi todo PIX (8 o más de cada 10)
D) Depende mucho de la ruta — lo explico abajo
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

Tres preguntas que van pegadas y son igual de importantes:

1. Cuando un cliente paga por PIX, **¿quién lo registra en el sistema: el cobrador, o entra solo?**
2. **¿Se compara contra el extracto del banco?** Si no, un pago por PIX que el cobrador no registre
   desaparece igual que uno en efectivo.
3. **¿El cliente que ya pagó por PIX sigue apareciendo en la ruta del día del cobrador?**

`[Answer]:`

---

## C-03 · 🔴 La IA en el plan básico contra "la IA puede esperar"

**Contexto**

Tres declaraciones sobre lo mismo, y no encajan:

| Dónde | Qué dice |
|---|---|
| **C-108** (v2) | Ustedes marcaron: *"puede esperar: **la IA**"* |
| Alcance acordado | El asistente de IA queda **fuera** de la primera entrega |
| Conversación del 2 de agosto | El **plan básico de la suscripción incluye IA** |

Si la IA es el plan de entrada, **la IA es el producto mínimo** — no puede esperar, porque sería
vender un plan que no existe.

Y hay algo que nos preocupa más que la contradicción: **nunca se ha definido qué hace el
asistente**. No sabemos si solo responde preguntas o si también ejecuta acciones, ni si las cifras
que dé tienen que ser exactas. **En un sistema de dinero, un número inventado es inaceptable**, y esa
diferencia cambia por completo cómo se construye.

**Pregunta**

¿La IA entra en la primera entrega?

**Opciones de respuesta**

A) **No.** Confirmamos C-108: la IA puede esperar. El plan básico incluye otra cosa
B) **Sí**, es el plan de entrada. Aceptamos que alarga el plazo de la primera versión
C) La v1 sale sin IA y **el plan básico se vende sin ella**; la IA es el plan superior, en la v2
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

Si la IA entra, necesitamos que respondan esto antes de construir nada:

- ¿El asistente **solo consulta**, o también **ejecuta acciones** (registrar un pago, aprobar una
  llave)?
- ¿Las cifras que dé deben ser **exactas y verificables**, o se acepta una respuesta aproximada?
- ¿Quién lo puede usar, y **qué datos ve**: su ruta, toda su empresa, o más?
- ¿Aceptan que los datos de sus clientes **salgan hacia un proveedor externo de IA**?

`[Answer]:`

---

## C-04 · El "supervisor" desaparece y vuelve a aparecer

**Contexto**

En **V-04** fueron claros:

> *"No tiene cuenta. Lo de C-31 y C-99 en realidad lo hace el administrador; **nos equivocamos al
> escribir 'supervisor'**"*

Pero **en el mismo cuestionario**, dos preguntas más adelante, el supervisor vuelve:

- **V-02**: *"para que al día siguiente **el supervisor** verifique la situación"*
- **V-17**: *"después de que **el supervisor** verifique, el administrador ya tiene la potestad…"*

O el rol existe, o esas dos frases querían decir "administrador". Hay que elegir, porque de esto
depende la lista de roles y quién puede hacer qué — y eso se decide una vez.

**Pregunta**

¿Existe el supervisor como usuario del sistema?

**Opciones de respuesta**

A) **No existe.** En V-02 y V-17 quisimos decir "administrador"
B) **Sí existe**, es un cuarto rol con cuenta propia — describo qué puede hacer
C) No tiene cuenta propia, pero **entra con la del administrador** cuando le toca verificar
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

Si responde **B**, díganos: ¿verifica los descuadres de caja? ¿autoriza el paso a cartera castigada?
¿aprueba llaves? ¿ve una ruta, varias, o todas?

`[Answer]:`

---

## C-05 · Tres canales de mensajería incompatibles

**Contexto**

En tres conversaciones distintas quedaron tres canales, y no encajan:

| Para qué | Canal declarado | Dónde |
|---|---|---|
| Alertas automáticas (caja sin cerrar, descuadre, fallos) | **WhatsApp** | `V-42` |
| Reportes a los administradores | **Telegram** | conversación del 2 de agosto |
| Mensajes al cliente final (QR, extracto) | **WhatsApp** | `C-99` |

Y encima, la contradicción **C-01** de este mismo documento dice que **WhatsApp puede no estar
disponible en absoluto**. No se pueden mandar alertas por un canal que los suscriptores no pueden
contratar.

**Pregunta**

¿Qué canal se usa para cada tipo de mensaje?

**Opciones de respuesta**

Marque uno por fila:

| Tipo de mensaje | Canal |
|---|---|
| **Alertas operativas** al administrador (caja sin cerrar, descuadre, fallo de envío) | WhatsApp / Telegram / Correo / Dentro de la app |
| **Reporte diario** a los socios | WhatsApp / Telegram / Correo / Dentro de la app |
| **Mensajes al cliente final** (QR de la venta, extracto del pago) | WhatsApp / SMS / Telegram |
| **Aviso al cobrador** de que le aprobaron una llave | Notificación de la app / WhatsApp / Telegram |

**Descripción** *(argumente la respuesta o añada otra opción)*

Una observación práctica: las **alertas al administrador** y los **reportes a los socios** van a
personas de su organización, que sí pueden instalar lo que haga falta. Los **mensajes al cliente
final** van a 2.000 personas que no controlan ustedes — ese es el canal difícil, y el único que
depende de C-01.

`[Answer]:`

---

## C-06 · El cobrador sin señal no puede pedir llave, y sin llave no puede cobrar

**Contexto**

Dos reglas suyas que se bloquean mutuamente:

- **C-65**: el cobrador tiene que poder **trabajar toda la jornada sin señal**.
- **V-18**: *"después de 5 cuotas el cobrador debe pedir **llave** para poder ingresar pagos"*.

La llave la aprueba el administrador, y para eso hace falta conexión. **Si el cobrador está sin
señal y llega a un cliente que va por la cuota 6, no puede pedir la llave y no puede registrar el
pago.** El cliente paga, y el sistema no lo sabe — que es exactamente el fraude que se quiere evitar.

**Pregunta**

¿Qué hace el cobrador sin señal cuando necesita una llave?

**Opciones de respuesta**

A) **Registra el pago igual**, queda marcado como "pendiente de llave", y el administrador lo
   autoriza al sincronizar *(el pago no se pierde; la autorización se hace después)*
B) **Llama por teléfono** al administrador, que le dicta la llave de viva voz, y el cobrador la
   teclea *(funciona sin datos, solo con cobertura de voz)*
C) **No puede registrar** hasta tener señal; el cobrador anota en papel y lo mete después
D) La llave **solo se exige cuando hay conexión**; sin señal el cobrador registra libre
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

Piensen en el caso real: ruta en un pueblo sin cobertura, un cliente que va por la cuota 8 y quiere
pagar. **¿Qué debería pasar?** La opción A es la que menos dinero pierde, pero significa que el
control llega tarde en vez de bloquear.

`[Answer]:`

---

## C-07 · Reingresar pagos a mano puede duplicarlos

**Contexto**

En **V-03** describieron qué hacer cuando la sincronización falla:

> *"al otro día cuando ya se tenga señal se deberá verificar los registros que se hicieron y quedaron
> efectivamente cargados en el servidor, **los que no quedaron cargados deberá ingresarlos
> nuevamente**"*

El sistema está preparado para que un envío que se repite **no cobre dos veces**: reconoce el mismo
movimiento y lo ignora. Pero eso funciona cuando **es el teléfono el que reenvía**.

Aquí es **una persona tecleando de nuevo**, y para el sistema eso es un pago distinto. Lo va a
aceptar. Y como el registro de movimientos **no se puede editar** —que es lo que hace que las
cuentas sean confiables— corregirlo exige otro asiento que anule el primero.

**Pregunta**

¿Cómo prefieren que el sistema evite el pago duplicado?

**Opciones de respuesta**

A) **Antes de dejar reingresar, el sistema le muestra al cobrador qué operaciones del día SÍ
   llegaron al servidor** — así solo teclea las que faltan *(la más segura)*
B) El sistema **detecta candidatos a duplicado** (mismo cliente, mismo monto, mismo día) y **pide
   confirmación** antes de aceptar
C) Se permite el reingreso sin más, y el administrador revisa después
D) A y B, las dos
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

Hay un caso legítimo que complica esto: **un cliente sí puede pagar dos veces el mismo día por el
mismo monto** (una cuota en la mañana y otra en la tarde). Si el sistema bloquea los duplicados sin
preguntar, rechaza un pago verdadero. Por eso B **pregunta** en vez de bloquear.

`[Answer]:`

---

## C-08 · El alcance comprometido no cabe en el equipo que existe

**Contexto**

El equipo técnico es **una persona**, con perfil junior, fuerte en la parte del servidor y **sin
experiencia previa en aplicaciones móviles**.

Y lo comprometido hasta hoy incluye, además de la app y la web:

- Un **motor de sincronización sin conexión** construido a medida — la pieza más difícil del sistema.
- Un **sistema de identificación propio** con vinculación al teléfono.
- **Seis tipos de pruebas** automáticas obligatorias y controles de calidad en dos niveles.

Cada decisión está bien argumentada por separado. Juntas son **una cantidad de trabajo que nadie ha
dimensionado**. Y el riesgo no está repartido: **está concentrado en la app del cobrador**, que es a
la vez la primera entrega y la única tecnología sin experiencia previa.

**Pregunta**

¿Cómo quieren ajustar esto?

**Opciones de respuesta**

A) **Se mantiene el alcance** y se alarga el plazo — indico cuánto tiempo hay disponible
B) **Se reduce el alcance** de la primera entrega — indico qué se puede dejar fuera
C) **Se amplía el equipo** — indico si hay presupuesto para una segunda persona
D) Se entrega **por etapas más pequeñas**: primero la web, luego la app, luego el modo sin conexión
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

Un dato para decidir: **la web mínima es la parte que sí está dentro de la experiencia del equipo**.
Sale antes y con menos riesgo. La app del cobrador es lo contrario. Si hay que elegir por dónde
empezar, empezar por la web reduce el riesgo — **aunque en C-107 ustedes dijeron lo contrario**.

`[Answer]:`

---

## C-09 · Soporte 24/7 con una sola persona

**Contexto**

En **V-45** prometieron a los suscriptores:

> *"siempre va a tener un canal de atención por parte de nosotros **24/7**"*

Y en **V-43** fijaron que una caída del sistema no debe durar **más de una hora**.

Con **una persona** que además desarrolla y opera, eso no es sostenible. Y no es un problema técnico:
es una promesa comercial que crea una obligación frente a los suscriptores.

**Pregunta**

¿Qué compromiso de soporte se le ofrece realmente al suscriptor?

**Opciones de respuesta**

A) **Horario laboral** de lunes a sábado, con un canal donde dejar el mensaje fuera de ese horario
B) **Horario extendido** cubriendo la franja crítica de la cobranza (mañana temprano y cierre)
C) **24/7 real**, y asumimos el costo de tener a alguien disponible
D) 24/7 solo para **caídas del sistema**; el resto en horario laboral
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

El momento crítico de este negocio es acotado y previsible: **el arranque de ruta a las 7 de la
mañana y el cierre de caja al final del día**. Cubrir bien esas dos franjas vale más, y es mucho más
sostenible, que prometer 24 horas y no poder responder a las 3 de la madrugada.

`[Answer]:`

---

## C-10 · La app en español, pero los clientes son brasileños

**Contexto**

En **V-01** eligieron: **Brasil, en reales, y la app en español**, con el argumento de que
*"los suscriptores hablan español"*. Para la app tiene todo el sentido: la usan los cobradores y los
administradores.

Pero hay un grupo que **no habla español**: los **~2.000 clientes finales**, que son brasileños. Y
son justamente quienes reciben los mensajes de los que depende el control antifraude — el QR para
liberar la venta y el extracto del cierre.

**Si esos mensajes van en español, el control deja de funcionar como control**: no se puede pedir a
alguien que detecte un error en un mensaje que no entiende.

**Pregunta**

¿En qué idioma van los mensajes al cliente final?

**Opciones de respuesta**

A) **App en español, mensajes al cliente en portugués** *(recomendada: cada uno en su idioma)*
B) Todo en español, incluidos los mensajes al cliente
C) Todo en portugués
D) Que cada empresa elija el idioma de sus mensajes
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

Si elige **A**, hace falta que alguien **redacte y revise las plantillas en portugués**. No son
muchas —el aviso de préstamo nuevo, el extracto del cierre y el QR de la venta— pero tienen que
estar bien escritas, porque además hay que someterlas a aprobación de Meta.

`[Answer]:`

---

## C-11 · ¿Quién usa la app: solo cobradores, o también el administrador?

**Contexto**

En **V-05** confirmaron el alcance: **app del cobrador + web mínima** para el administrador.

Pero en **V-24**, unas preguntas después, ustedes mismos lo pusieron en duda:

> *"si es más práctico, seguro y ligero para el administrador trabajar desde la app para aprobar
> gastos, ventas, llaves, etc. se podría hacer también desde la app… **porque si todo se hace por la
> app ¿qué sentido tiene la web??**"*

Es una buena pregunta y merece una respuesta clara, porque **construir las aprobaciones en los dos
sitios cuesta el doble** que construirlas en uno.

**Pregunta**

¿Dónde aprueba el administrador las ventas, los gastos y las llaves?

**Opciones de respuesta**

A) **Solo en la web** — como se acordó en V-05
B) **Solo en la app** — y la web queda para reportes y configuración
C) **En los dos sitios** — y aceptamos que cuesta más y sale más tarde
D) **Primero en la app** (que es donde está el administrador cuando lo llaman) y la web después
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

Piensen en el caso real: **el cobrador llama al administrador desde la calle pidiendo autorización
para una venta**. ¿Dónde está el administrador en ese momento — frente a un computador, o con el
teléfono en la mano?

`[Answer]:`

---

## C-12 · ISO 27001: el equipo lo declaró, ustedes no lo prevén

**Contexto**

El equipo técnico decidió construir siguiendo **ISO 27001** (un estándar de seguridad de la
información) y **LGPD** (la ley brasileña de protección de datos).

Pero en **V-53** ustedes marcaron: *"No lo prevemos; nuestros clientes son empresas pequeñas"* —
es decir, **no esperan que nadie les pida certificaciones**.

No es una contradicción grave, pero **cambia mucho el costo**, y conviene decidirlo a propósito:

| | Qué implica |
|---|---|
| **Alineado con ISO 27001** | Se usa el estándar como lista de control al construir. Buena parte ya está hecha. **Sin costo adicional** |
| **Certificado ISO 27001** | Documentación formal, análisis de riesgos, auditoría interna y **auditoría externa pagada**. Meses de trabajo |

**LGPD no está en discusión**: es obligatoria por ley porque guardan fotos de documentos de
identidad de personas brasileñas.

**Pregunta**

¿ISO 27001 como guía, o como certificación?

**Opciones de respuesta**

A) **Como guía** — construir bien, sin auditoría ni certificado *(recomendada: nadie se lo exige)*
B) **Certificación real** — asumimos el costo y el calendario porque nos abre clientes
C) Guía ahora, certificación más adelante si algún cliente la pide
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

Hay una consecuencia práctica: ese estándar exige que **quien escribe el código no sea el mismo que
lo aprueba**. Con un equipo de una persona eso es imposible. Como **guía**, se documenta la excepción
y se compensa con otros controles. Como **certificación auditada**, no pasa la auditoría.

`[Answer]:`

---

## C-13 · El Excel del cierre de caja — pedido dos veces, no ha llegado

**Contexto**

No es una contradicción entre dos respuestas, sino entre **lo que se pide y lo que se ha entregado**.

El documento de requisitos exige un reporte de cierre *"**idéntico al formato utilizado
actualmente**"*. Ese formato solo existe en un archivo de Excel que ustedes usan a diario.

Se ha pedido dos veces:

- **C-57** (cuestionario v2): marcaron *"sí, lo adjunto"* — **no venía**.
- **V-25** (cuestionario v3): *"te lo explico por llamada"*.

**Sin ver el archivo, ese requisito no se puede construir ni verificar.** Explicarlo por teléfono no
sustituye verlo: lo que importa son las columnas, el orden, las fórmulas y los totales.

**Pregunta**

¿Cómo nos hacen llegar el formato del cierre?

**Opciones de respuesta**

A) Adjunto el archivo de Excel de **un día real** *(con nombres cambiados si prefieren)*
B) Adjunto **una foto o captura de pantalla** del cierre de un día
C) Lo explico en la llamada y ustedes lo reconstruyen, y luego lo validamos
D) No tenemos ese archivo; el cierre se hace de otra forma — lo explico
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

Si es una cuestión de confidencialidad, **una captura con los importes tapados sirve igual**: lo que
necesitamos ver es la **estructura**, no los datos.

`[Answer]:`

---

## C-14 · La factura vence el día 30, pero la suscripción es semanal

**Contexto**

En **V-20** describieron el cobro del software con este detalle:

> *"si la factura está para vencer el **30 del mes** y no pagó, al día siguiente el usuario amanece
> bloqueado"* · *"5 días antes del vencimiento, un día antes y el mismo día (3 avisos)"*

Todo eso es un ciclo **mensual**. Pero en la conversación del 2 de agosto nos transmitieron que la
suscripción sería **semanal**, con planes escalonados.

No pueden ser las dos. Y no es un detalle: **semanal son 52 cobros al año por cliente en vez de 12**,
con cuatro veces más avisos, más reintentos y más gestiones de pago fallido.

*(Esta contradicción está emparentada con la pregunta B-02 del cuadernillo de Negocio — respóndanla
en cualquiera de los dos.)*

**Pregunta**

¿El ciclo de facturación es mensual o semanal?

**Opciones de respuesta**

A) **Mensual**, con vencimiento el día 30 y los 3 avisos de V-20 *(lo que dice el cuestionario)*
B) **Semanal**, y los avisos y el bloqueo se ajustan a ese ritmo
C) **Mensual**, pero con planes escalonados como los que se describieron
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

Si es semanal, díganos **qué día de la semana vence** y **cuánto margen hay antes del bloqueo**.
En V-20 el bloqueo es al día siguiente, sin gracia — con ciclo semanal eso significa que un
suscriptor puede quedar bloqueado **cuatro veces al mes**.

`[Answer]:`

---

Cuando termine, devuelva el archivo o responda con una sola palabra: **listo**
