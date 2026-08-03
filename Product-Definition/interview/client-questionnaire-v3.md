# Cuestionario v3 — Lo que quedó abierto

**Versión 3 · 2026-08-01.** Sustituye a la v2 (117 preguntas). **Aquí hay 54.**

De las 117 preguntas de la v2, **78 quedaron cerradas** con lo que ustedes marcaron, y otras
11 se cerraron combinando dos respuestas. Gracias: eso movió el proyecto de un 37% a un 65%
de definición, y sobre todo dejó cerrada **toda la matemática del dinero**, que era la parte
que de verdad bloqueaba.

Este documento **no repite nada de lo ya respondido**. Trae cuatro cosas:

1. **14 choques** entre dos respuestas suyas. No es que hayan respondido mal: son preguntas
   que en la v2 estaban en bloques distintos y, al juntarlas, piden cosas opuestas. Hay que
   elegir una.
2. **10 respuestas a medias**: contestaron el "qué" pero falta el número o el detalle que
   las vuelve programables.
3. **7 cosas que quedaron pendientes** de una llamada, un archivo o una consulta.
4. **23 preguntas que nunca les hicimos.** La v2 se concentró en cómo funciona el negocio;
   estas son sobre **cómo quieren que el sistema se comporte**: qué queda registrado para
   poder investigar un fraude, qué pasa cuando algo falla, cómo se distribuye la app y qué
   hace falta el día que le vendan el software a otra empresa. Son la diferencia entre
   quedarnos en el 65% y llegar al **~90%**.

> ### 📊 Si responden todo esto, ¿dónde quedamos?
>
> El lado del **negocio queda cerrado**. Lo único que quedaría abierto después sería la
> **entrevista técnica** —lenguajes, servidores, base de datos, pruebas— que resuelve el
> equipo de desarrollo y **no depende de ustedes**.
>
> Por eso vale la pena el esfuerzo de una ronda larga más: es la última.

> **Cómo responder:** igual que la vez pasada. Pueden resaltar la opción elegida o escribir
> la letra en `[Answer]:`. Si algo no encaja, `X` y lo explican.

> **Una petición nueva:** en la v2 vimos **dos colores de resaltado** — casi todo en verde y
> 8 respuestas en cian, todas sobre caja y autorizaciones. En tres de esas, la marca cian dice
> lo contrario que la verde. Como en C-116 escribieron *"lo tendríamos que definir entre los
> tres"*, necesitamos saber una cosa antes de seguir: **cuando ustedes tres no coinciden,
> ¿quién decide?** Va como pregunta V-00.

---

## V-00 · ¿Quién decide cuando ustedes no coinciden? 🔴

No es una pregunta sobre el software, es sobre el proyecto. Si dos de ustedes marcan cosas
opuestas y nosotros elegimos por nuestra cuenta, construimos algo que uno de los tres no
pidió y se descubre tarde.

**OPCIONES DE RESPUESTA**

- **A)** Una sola persona tiene la última palabra — digo quién
- **B)** Se decide entre los tres y nos lo mandan ya consensuado
- **C)** Depende del tema: unos los decide uno y otros, otro — lo explico

`[Answer]:`

---

# PARTE 1 · Los 14 choques que hay que resolver

## V-01 · ¿En qué país operan, con qué moneda y en qué idioma? 🔴
*(viene de C-02 · contradicción `CX-11`)*

Esta se quedó sin respuesta y es la que más cosas bloquea. Marcaron **B** y listaron a dónde
quieren expandirse —México, Ecuador, Argentina, Uruguay, Chile, Perú, Bolivia— pero **no
dijeron desde dónde arrancan**.

Todo lo demás apunta a **Brasil**: usan PIX, y en C-25 escribieron *"usted abonó 50 **reales**"*.
Pero entonces hay dos cosas raras: **Brasil no está en su propia lista de expansión**, y la app
tendría que estar en **portugués**, no en español.

Sin esto no podemos cerrar: la moneda y cómo se escriben las cifras, el idioma de la app,
qué ley de datos aplica (C-95), si hay tope de usura (C-94), ni la nota fiscal de C-115.

**PREGUNTA**
¿Desde qué país arrancan, con qué moneda cobran, y en qué idioma tiene que estar el sistema?

**OPCIONES DE RESPUESTA**

- **A)** Brasil, en reales (BRL), y la app en **portugués**
- **B)** Brasil, en reales, pero la app en **español** — nuestro equipo es hispanohablante
- **C)** Otro país — lo escribo abajo con su moneda y su idioma
- **D)** Arrancamos en dos países a la vez — los escribo abajo
- **X)** Otra — la explico

`[Answer]:`

**Y una que va pegada:** si van a operar en 8 países, ¿la app tiene que estar en **portugués
y español a la vez** desde el principio, o basta con un idioma ahora y el otro después?

`[Answer]:`

---

## V-02 · Cuando la caja no cuadra, ¿se puede cerrar o no? 🔴
*(viene de C-51, C-53, C-58 · contradicción `CX-12`)*

Aquí hay tres respuestas suyas que no pueden ser verdad a la vez:

- En **C-51** marcaron **B**: *dejar cerrar y registrar el faltante como deuda del cobrador*.
- Pero al lado escribieron: ***"no puede faltar ni sobrar"***, que es justo lo contrario
  (es la opción A: no dejar cerrar hasta que cuadre).
- Y en **C-58** dijeron que el cierre **no se puede corregir nunca**, *"porque una vez el
  cobrador cierra caja es porque está seguro de que todo está cuadrado"*.

Y hay un cuarto dato que lo complica: en **C-53** dijeron que el cobrador **sí puede prestar
aunque no tenga efectivo suficiente**. Eso, por definición, produce una caja que no cuadra.

La diferencia es grande: si el sistema **bloquea**, un cobrador con un error tonto a las 21:00
se queda sin poder cerrar y sin poder irse a casa. Si el sistema **deja pasar**, usted se
entera del descuadre al día siguiente, cuando ya nadie se acuerda.

**PREGUNTA**
El cobrador cierra caja, el sistema dice 850 y él tiene 840. ¿Qué hace el sistema?

**OPCIONES DE RESPUESTA**

- **A)** No lo deja cerrar. Que busque el error hasta que cuadre exacto
- **B)** No lo deja cerrar **solo él**, pero el administrador puede autorizar la diferencia y
  entonces sí cierra, quedando registrada como deuda del cobrador
- **C)** Lo deja cerrar siempre, registrando el faltante como deuda del cobrador (lo que
  marcaron en C-51)
- **X)** Otra — la explico

`[Answer]:`

**Preguntas que van pegadas:**

- ¿Y si **sobra** plata en vez de faltar? ¿Mismo trato?
- ¿Hay algún margen que pase solo? (por ejemplo, diferencias menores a 5)
- Si el faltante queda como deuda del cobrador, **¿cómo se salda?** ¿Se le descuenta del
  sueldo del sábado (C-52), de la comisión, o se le cobra aparte?

`[Answer]:`

---

## V-03 · ¿De qué día es un pago tomado sin señal? 🔴
*(viene de C-67 · contradicción `CX-13`)*

En **C-67** escribieron: *"la fecha debe ser apenas el celular tenga señal y sincronice"*.

El problema es que eso rompe todo lo demás que pidieron sobre la caja. Ejemplo real con sus
propias reglas: el cobrador cobra 30 pagos el martes en una zona sin señal. Su celular
sincroniza el miércoles a las 8 de la mañana. Con la regla que escribieron:

- El **martes** el sistema cree que no cobró nada → la caja del martes **no puede cerrar**,
  porque C-50 exige pendientes = 0.
- El **miércoles** entran 30 pagos del martes → la caja del miércoles muestra plata que no
  se recogió ese día → **descuadra**, y C-58 dice que ya no se puede corregir.
- Y el cliente que pagó el martes recibe su extracto (C-22) **un día tarde**.

La alternativa es fechar el pago **cuando el cobrador lo registró en la calle** y usar la
hora de sincronización solo como dato de auditoría. El celular guarda las dos.

**PREGUNTA**
Un pago registrado el martes a las 15:00 que llega al servidor el miércoles a las 08:00,
¿de qué día es?

**OPCIONES DE RESPUESTA**

- **A)** **Del martes**, con la hora en que el cobrador lo registró. El sistema guarda aparte
  cuándo sincronizó, para auditoría
- **B)** Del miércoles, cuando entró al sistema (lo que escribieron en C-67)
- **C)** Del martes para la deuda del cliente, pero afecta la caja del miércoles
- **X)** Otra — la explico

`[Answer]:`

**Y va pegada:** si el pago es del martes pero la caja del martes ya cerró, ¿qué hace el
sistema? ¿Reabre el cierre, o el pago entra como ajuste del miércoles?

`[Answer]:`

---

## V-04 · El supervisor: ¿está dentro o fuera del sistema? 🔴
*(viene de C-39, C-31, C-61, C-99 · contradicción `CX-14`)*

En **C-39** fueron claros: *"los supervisores **no tienen acceso al sistema**; solo cuando
llegan donde el cobrador cogen el celular y revisan"*.

Pero en otras tres respuestas el supervisor sí hace cosas dentro del sistema:

- **C-31**: *"el **supervisor autoriza el valor**"* de cada venta, antes de que el administrador
  la apruebe.
- **C-99**: si el cliente ve un pago mal registrado, *"tenga la opción de enviarle un mensaje
  **al supervisor** para verificar"*.
- **C-54**: hay una categoría de gasto que es *"**sueldo supervisor**"*.

No se puede autorizar montos ni recibir alertas de clientes sin una cuenta. O el supervisor
es un cuarto rol, o esas dos funciones son en realidad del administrador.

**PREGUNTA**
¿Qué es el supervisor?

**OPCIONES DE RESPUESTA**

- **A)** Es un **cuarto rol con cuenta propia**: autoriza el valor de las ventas y recibe las
  alertas de los clientes. Lo de "revisar el celular del cobrador" es algo adicional que hace
  en la calle
- **B)** **No tiene cuenta.** Lo de C-31 y C-99 en realidad lo hace el administrador; nos
  equivocamos al escribir "supervisor"
- **C)** No tiene cuenta propia, pero **entra con la del administrador** cuando necesita autorizar
- **X)** Otra — la explico

`[Answer]:`

**Si eligen A**, hace falta saber: ¿el supervisor ve **todas** las rutas o solo las suyas?
¿Puede ver dinero (caja, utilidad), o solo el estado del cobro?

`[Answer]:`

---

## V-05 · ¿Arrancamos por la app o por la web? 🔴
*(viene de C-107 y C-108 · contradicción `CX-15`)*

Esta es la contradicción más cara de las once, porque decide qué construimos primero.

- **C-107**: *"primero crear la base, que sería **la app**, hacer pruebas, luego integrar la
  seguridad de fraude"*.
- **C-108**: marcaron **C** — *"la **app móvil puede esperar**; arranquemos con la web"*.

En **C-109** nos delegaron esta decisión: *"eso lo tendríamos que definir con usted, que tiene
el conocimiento"*. Así que aquí va nuestra posición, no como una opción más sino como
**recomendación formal del equipo**:

> ### 🎯 Recomendamos: **app del cobrador completa + web mínima, las dos en la primera entrega**
>
> **Por qué no solo la web.** Los dos fraudes que nombraron en C-99 —la venta sin entrega de
> dinero y el pago cobrado sin registrar— **pasan en la calle, no en la oficina**. El control de
> los tres paneles de caja (C-50), el registro de pagos parciales (C-18), el trabajo sin señal
> (C-65) y el escaneo del QR (C-31) son todos pantallas de celular. Una web sin app **no le
> quita el Excel a nadie** y no ataca ninguno de los dos fraudes.
>
> **Por qué tampoco solo la app.** El flujo de aprobación que ustedes mismos describieron en
> C-31 tiene al administrador en el centro: él aprueba la venta antes de que se libere el
> dinero. Sin web, ese paso no existe y la app queda inutilizable. Lo mismo con las llaves
> (C-61) y la apertura de caja (C-50, la abre el administrador).
>
> **Qué entra en la web mínima:** crear y editar clientes, aprobar ventas, aprobar gastos, dar
> llaves de autorización, abrir cajas y ver el cierre diario. **Nada más.**
>
> **Qué queda para la segunda entrega:** el asistente de IA (ya lo aceptaron en C-108), los
> reportes avanzados y comparativos (también en C-108), el módulo de facturación del software
> (coherente con la secuencia que ustedes trazaron en C-112) y el mapa con orden geográfico
> de la ruta (C-73).

**PREGUNTA**
¿Aceptan esta recomendación?

**OPCIONES DE RESPUESTA**

- **A)** Sí, vamos con eso *(Recomendada por el equipo)*
- **B)** Sí, pero cambiando qué entra en la web mínima — lo explico abajo
- **C)** No: primero la **web** completa; la app en una segunda entrega (lo que marcaron en C-108)
- **D)** No: primero la **app** completa; la web en una segunda entrega (lo que escribieron en C-107)
- **X)** Otra — la explico

`[Answer]:`

---

## V-06 · ⛔ WhatsApp — el bloqueante nº 1 del proyecto 🔴
*(viene de C-75 · contradicción `CX-16`)*

> **Si solo leen una pregunta de este documento, que sea esta.** Es la única que puede
> retrasar el proyecto entero por un trámite que no depende ni de ustedes ni de nosotros,
> y que hay que **empezar ya**.

En **C-75** marcaron **B**: tienen *WhatsApp Business normal (la app), no la API*.

Hay que decirlo claro: **con la app de WhatsApp Business no se puede automatizar nada.** Y de
eso dependen cinco cosas que ustedes pidieron, incluidas las dos más importantes del proyecto:

| Lo que pidieron | Dónde |
|---|---|
| El **QR que libera el dinero** de una venta aprobada | C-31, C-72 — es su control antifraude nº 1 |
| El **extracto a cada cliente al cerrar caja** | C-22, C-99 — es su control antifraude nº 2 |
| Aviso al registrar un préstamo, al pagar y al no pagar | C-78 |
| El recordatorio del compromiso de pago | C-26 |
| El reporte a los socios | C-81 |

Conseguir la API oficial no es difícil, pero **el trámite tarda semanas y hay que arrancarlo
ahora**, en paralelo con el desarrollo. Esto es lo que exige, en orden:

| Paso | Qué hace falta | Quién lo hace | Cuánto tarda |
|---|---|---|---|
| 1 | Una **empresa registrada** con documentos verificables ante Meta | Ustedes | — |
| 2 | Cuenta de **Meta Business** verificada (Business Verification) | Ustedes, nosotros acompañamos | **1 a 3 semanas**, y Meta puede pedir documentos otra vez |
| 3 | Un **número de teléfono dedicado** que no esté usándose ya en la app de WhatsApp | Ustedes | 1 día |
| 4 | **Cada plantilla de mensaje aprobada una por una** por Meta | Nosotros redactamos (ya lo aceptaron en C-76), ustedes aprueban el texto | Días por plantilla, y las rechazadas hay que reescribirlas |
| 5 | Un proveedor de acceso a la API | Nosotros | 1 día |

**Sobre el costo**, que conecta con C-105 (*"lo más económico posible"*): Meta cobra **por
conversación de 24 horas**, no por mensaje. Eso juega a favor si se agrupa —es exactamente el
argumento de **V-19**: un solo extracto diario por cliente al cierre de caja cuesta **una**
conversación, mientras que avisar cada pago por separado puede costar varias.

**Y hay un detalle del paso 3 que conviene saber antes:** el número que registren en la API
**deja de funcionar en la app normal de WhatsApp**. Si hoy usan ese mismo número para hablar
con los clientes a mano, hay que conseguir uno nuevo.

**PREGUNTA**
¿Cómo quieren avanzar?

**OPCIONES DE RESPUESTA**

- **A)** **Arrancamos el trámite ya.** Díganos qué necesitan de nosotros y empezamos por el
  paso 2 esta semana *(Recomendada — es la única opción que no retrasa la v1)*
- **B)** Queremos ver primero el **costo mensual estimado** con nuestro volumen, y decidimos
  en cuanto lo tengamos *(lo calculamos, pero el trámite mientras tanto no avanza)*
- **C)** Empecemos sin WhatsApp y lo agregamos después *(hay que decirlo claro: **la v1 no
  tendría ninguno de los dos controles antifraude de C-99**, que es lo que ustedes describieron
  como el problema central del negocio)*
- **X)** Otra — la explico

`[Answer]:`

**Datos que necesitamos para arrancar el paso 1, respondan lo que respondan:**

- ¿A nombre de qué **empresa registrada** iría la cuenta, y en qué país está constituida?
  *(esto se cruza con V-01 y con la nota fiscal de C-115)* `[Answer]:`
- ¿Tienen un **número de teléfono** que puedan dedicar solo a esto? `[Answer]:`
- ¿Ya tienen cuenta de **Meta Business**, aunque sea para publicidad? `[Answer]:`

---

## V-07 · ¿Qué recibe el cliente cuando paga? 🔴
*(viene de C-23 y C-25 · contradicción `CX-17`)*

En estas dos, lo que marcaron y lo que escribieron dicen cosas opuestas:

- **C-25**: marcaron **D** (*"nada, con que quede registrado basta"*), pero escribieron el texto
  exacto de un mensaje: *"su pago fue recibido, usted abonó 50 reales y quedó con 15 cuotas
  pendientes de 20, total deuda 700"*. Eso es la opción **A**.
- **C-23**: marcaron **A** (registro manual simple del PIX), pero escribieron que la transferencia
  **debe llevar comprobante adjunto y el nombre que aparece en la transferencia**. Eso es la **B**.

Damos por buena la versión escrita en los dos casos, que además es la coherente con C-99.
Confirmen y con esto queda cerrado:

**PREGUNTA**
¿Confirman esto?

- Al registrar un pago hay **dos medios**: **DINERO** (por defecto, el cobrador no tiene que
  elegir nada) y **TRANSFERENCIA / PIX** (obliga a adjuntar comprobante y escribir el nombre
  del titular, que puede no ser el cliente).
- El cliente **no recibe nada en el momento** del pago.
- Al **cerrar la caja**, cada cliente visitado recibe **un solo mensaje**: si pagó, cuánto abonó,
  cuántas cuotas le quedan y su saldo; si no pagó, el recordatorio de mora, el saldo y el
  compromiso de fecha que dejó anotado el cobrador.

**OPCIONES DE RESPUESTA**

- **A)** Sí, es exactamente eso
- **B)** Sí, pero con cambios — los explico abajo
- **C)** No: el cliente **sí** debe recibir algo en el momento del pago — lo explico

`[Answer]:`

---

## V-08 · La tasa de interés: ¿una sola o varía? 🔴
*(viene de C-10 y C-11 · contradicción `CX-18`)*

En **C-11** marcaron **A**: *el administrador fija una tasa para toda la empresa y **nadie la
cambia***. Pero en **C-10** escribieron: *"el interés **puede variar**, pero siempre será fijo
sobre el valor prestado"*.

Entendemos que "fijo sobre el valor prestado" se refiere a la **fórmula** (que sí quedó clara,
y su ejemplo cuadra: 1.000 a 24 cuotas diarias = 1.200, cuotas de 50, o sea 20%). Lo que falta
es saber **quién puede cambiar ese 20% y cada cuánto**.

**PREGUNTA**
El porcentaje de interés, ¿de dónde sale en cada venta?

**OPCIONES DE RESPUESTA**

- **A)** Hay **un solo porcentaje** para toda la empresa. El administrador lo puede cambiar, y
  el cambio solo aplica a las ventas nuevas
- **B)** Hay **varios productos de préstamo** predefinidos (ej. "diario 20%", "semanal 15%") y el
  cobrador elige uno de la lista, sin poder inventar otro
- **C)** El porcentaje **lo pone quien hace la venta**, dentro de un rango que fija el administrador
- **X)** Otra — la explico

`[Answer]:`

**Y una consecuencia que va pegada:** si el porcentaje cambia, ¿los préstamos que ya están
corriendo **mantienen el suyo**? (Damos por hecho que sí, por C-14: la deuda nunca cambia
después de pactada. Confírmenlo.)

`[Answer]:`

---

## V-09 · Los 5.000: ¿empresas o clientes? 🔴
*(viene de C-05 · contradicción `CX-19`)*

En **C-05** escribieron: *"tomando como ejemplo Brasil hay muchos cobros, y la idea es llegarle
a todos esos suscriptores, entonces hagamos la app pensando en los **5000**"*.

Entre las dos lecturas posibles hay una diferencia enorme:

| Si son… | Significa | Lo que implica |
|---|---|---|
| **5.000 empresas suscriptoras** | Cada una con sus rutas y sus cobradores → fácilmente **millones** de clientes finales y decenas de miles de pagos al día | Multi-tenant de verdad desde el diseño, infraestructura seria, costo mensual alto |
| **5.000 clientes finales** | Una operación de unas 30–50 rutas | Un sistema mucho más simple y barato, que igual puede crecer después |

**PREGUNTA**
¿Los 5.000 qué son?

**OPCIONES DE RESPUESTA**

- **A)** **5.000 empresas** que nos compran el software
- **B)** **5.000 clientes finales** en nuestra propia operación
- **C)** Otra cifra — la escribo abajo separando las dos cosas
- **X)** Otra — la explico

`[Answer]:`

**Y para dimensionar bien, necesitamos los números de **hoy**, aunque sean aproximados** — en
C-05 no llegaron: ¿cuántos clientes tienen ahora?, ¿cuántas rutas?, ¿cuántos cobradores?,
¿cuántos pagos se registran en un día normal?

`[Answer]:`

---

## V-10 · TryController no deja sacar los datos 🔴
*(viene de C-08 · contradicción `CX-20`)*

En **C-08** marcaron **A**: reemplazo total, *"y hay que pasar **TODOS** los datos históricos al
nuevo"*. Pero en la pregunta de al lado dijeron que TryController **no** les deja exportar.

Las dos cosas juntas no se pueden. Si no hay exportación, no hay de dónde sacar el histórico.
Las salidas posibles, de menos a más costosa:

**PREGUNTA**
¿Por dónde vamos?

**OPCIONES DE RESPUESTA**

- **A)** **Empezamos por los préstamos vivos, digitados a mano.** Los viejos terminan en
  TryController y se consultan ahí mientras haga falta *(la más rápida, y suele ser suficiente)*
- **B)** Que alguien **pida formalmente la exportación** al proveedor de TryController antes de
  decidir — puede que sí exista y no lo hayan intentado
- **C)** Que nosotros **extraigamos los datos de las pantallas** de TryController de forma
  automatizada *(hay que revisar si su contrato lo permite; es lento y frágil)*
- **D)** No migramos nada: **arrancamos de cero** con los préstamos nuevos
- **X)** Otra — la explico

`[Answer]:`

**Dato clave para decidir:** ¿cuántos **préstamos activos** hay ahora mismo en TryController?
Si son 200, digitarlos a mano son dos días. Si son 5.000, es otro proyecto.

`[Answer]:`

---

## V-11 · La pasarela de pagos dentro de la app 🔴
*(viene de C-113 · contradicción `CX-21`)*

En **C-113** escribieron: *"sería bueno que **desde la misma app** se pueda integrar la pasarela
de pagos, así el suscriptor pueda hacer todo desde la app"*.

Eso choca con lo que ustedes mismos decidieron en su momento (**D-01**): el cobro del software
va **solo por la web, nunca por el móvil**. Y no es un capricho nuestro: si la app de Android o
iPhone permite pagar una suscripción dentro de ella, **Google y Apple exigen su propio sistema
de pago y se quedan con una comisión del 15% al 30%**. Es la razón por la que Netflix o Spotify
no dejan suscribirse desde su app.

Hay una salida intermedia que da casi la misma comodidad: **la app le muestra al suscriptor su
factura y su fecha de vencimiento, y el botón de pagar lo lleva al navegador.** Eso es legal,
no paga comisión de tienda, y el suscriptor casi no nota la diferencia.

**PREGUNTA**
¿Cómo lo hacemos?

**OPCIONES DE RESPUESTA**

- **A)** La app **muestra** la factura y el vencimiento, y el pago se completa **en el navegador**
  *(Recomendada — mantiene D-01 y evita la comisión de las tiendas)*
- **B)** El pago **solo** en la web; la app no menciona la facturación *(D-01 tal cual)*
- **C)** Queremos el pago **dentro de la app** aunque cueste la comisión de las tiendas — lo
  asumimos
- **X)** Otra — la explico

`[Answer]:`

---

## V-12 · Si para renovar hay que pagar todo, ¿qué es un préstamo "renovado"? 🟡
*(viene de C-27 y C-28 · contradicción `CX-23`)*

En **C-27** dijeron que la lista de estados está completa y correcta. Esa lista incluye
**temporal**, **renovado** y **refinanciado**. Pero otras dos respuestas suyas dejan dos de
esos estados sin contenido:

- **C-32**: *"no debe haber ventas temporales"* → el estado **temporal** sobra.
- **C-28**: para renovar hay que **pagar el 100%** de la deuda, y el sistema bloquea si hay
  saldo. Si la deuda vieja siempre queda en cero antes de la nueva, un préstamo **renovado**
  es indistinguible de uno nuevo.

No es un problema grave, pero hay que decidirlo: un estado que no significa nada acaba
llenándose de datos que nadie entiende.

**PREGUNTA**
¿Qué hacemos con "renovado"?

**OPCIONES DE RESPUESTA**

- **A)** Se queda como **marca informativa**: el préstamo es nuevo, pero queda señalado que
  es de un cliente que ya había pagado uno antes. Sirve para saber quién es cliente recurrente
- **B)** Se elimina. Un cliente que vuelve a pedir simplemente tiene un préstamo nuevo más
- **C)** Significa otra cosa que no capturamos — lo explico
- **X)** Otra — la explico

`[Answer]:`

**Y confirmen de paso:** damos por eliminado el estado **temporal**, por C-32. ¿Correcto?

`[Answer]:`

---

## V-13 · El tablero "al instante" contra el celular que sincroniza una vez al día 🟡
*(viene de C-83 y C-66 · contradicción `CX-24`)*

En **C-83** marcaron **A**: *"al instante: si el cobrador registra un pago, quiero verlo ya"*.

Pero en **C-66** aceptaron que el cobrador **sincronice solo una vez al día**, y en **C-65** que
trabaje toda la jornada sin señal. Cuando un pago está guardado en el celular y no ha
sincronizado, **el tablero no puede mostrarlo**: no existe todavía para el servidor. No es una
limitación que se pueda programar, es física.

Lo que sí podemos hacer es que el tablero **sea honesto**: que muestre lo que hay y además
avise de lo que falta. Por ejemplo: *"Recaudo del día: 4.200. **3 rutas sin sincronizar desde
las 11:40**"*. Así usted sabe si el número está completo o no, que es lo que de verdad importa
para decidir.

**PREGUNTA**
¿Cómo lo hacemos?

**OPCIONES DE RESPUESTA**

- **A)** Al instante para lo que **ya sincronizó**, y el tablero **avisa qué rutas faltan** y
  desde cuándo *(Recomendada)*
- **B)** Al instante y ya; asumimos que los números pueden estar incompletos sin avisar
- **C)** Que el tablero **solo muestre datos completos**: no enseña el día hasta que todas las
  rutas hayan sincronizado
- **X)** Otra — la explico

`[Answer]:`

**Y va pegada, porque es la otra mitad del problema:** ¿quieren que el sistema **exija
sincronizar** a media jornada —por ejemplo al mediodía— para que usted no se quede ciego toda
la mañana? En C-66 solo pidieron una vez al día.

`[Answer]:`

---

## V-14 · El GPS no está cubriendo el fraude que sí les preocupa 🟡
*(viene de C-45 y C-99 · contradicción `CX-25`)*

En **C-45** marcaron **A** y **C**: el GPS sirve para guardar dónde vive el cliente y para
ordenar la ruta del día. **No marcaron la B**: *verificar que el cobrador estuvo físicamente
donde dice que estuvo*.

Pero en **C-99** describieron como uno de sus dos fraudes principales exactamente eso: *"el
cobrador recibe el pago y no le ingresa al sistema el valor pagado por el cliente"*. Y hay una
variante que no mencionaron pero es igual de común: marcar **"no pago"** sin haber ido a
visitar al cliente.

Guardar la ubicación en el momento de registrar cada pago o cada "no pago" es **el control más
barato que existe** contra eso: no cuesta infraestructura, no molesta al cobrador y deja
evidencia. La contra es que algunos cobradores lo viven como vigilancia.

**PREGUNTA**
¿Quieren que el sistema guarde dónde estaba el cobrador al registrar cada visita?

**OPCIONES DE RESPUESTA**

- **A)** Sí, **guardarlo siempre y en silencio**. Sirve para revisar después si hay sospecha
  *(Recomendada — es gratis y ataca directamente el fraude nº 2 de C-99)*
- **B)** Sí, y además que **avise en el momento** si el cobrador está lejos del cliente
- **C)** Sí, y que **bloquee** el registro si está a más de X metros
- **D)** No. Preferimos no medir eso; genera desconfianza en el equipo
- **X)** Otra — la explico

`[Answer]:`

**Si eligen B o C:** ¿a partir de cuántos metros se considera "lejos"? Ojo: el GPS de un
celular de gama media en una zona con edificios se equivoca fácilmente **entre 20 y 100 metros**,
así que un umbral muy estricto va a dar falsas alarmas.

`[Answer]:`

---

# PARTE 2 · Respuestas a medias

Aquí contestaron el "qué" pero falta el número o el detalle que lo vuelve programable.

## V-15 · ¿Cómo se va a llamar el producto? 🟡
*(C-01 quedó sin responder)*

Seguimos con cuatro nombres dando vueltas: `TRIPRI` (el repositorio), `TryPRI`, *"Sistema
Inteligente de Administración de Préstamos"*, y `TryController`, que es el programa que usan
hoy y **no es suyo** — conviene alejarse de ese nombre.

`[Answer]:`

## V-16 · El redondeo 🟡
*(C-17 · sigue abierta)*

Escribieron: *"en el TryController esto no afecta, si quedan decimales se pone el valor con
decimales"*. Pero eso no resuelve el caso: si presta 1.000 a 21 cuotas al 20%, la cuota exacta
da **57,142857…** y nadie puede pagar eso.

**OPCIONES DE RESPUESTA**

- **A)** Todas las cuotas iguales, redondeadas a 2 decimales, **y la última ajusta la diferencia**
  *(Recomendada: la suma da exacta siempre)*
- **B)** Redondear cada cuota hacia arriba a la unidad — indico a cuál (al entero, a los 5…)
- **C)** Redondear hacia abajo — indico a cuál
- **X)** Otra — la explico

`[Answer]:`

## V-17 · ¿Cuándo se da un préstamo por perdido? 🟡
*(C-15 · adicional)*

Para el estado de mora nos dieron un número claro: **3 días**. Pero para la cartera castigada
escribieron *"a partir de que el cliente no se pueda ubicar"*, y eso el sistema no lo puede
calcular solo.

Como en **C-33** dijeron que la baja la decide el administrador **manualmente**, uno por uno,
lo que necesitamos es solo el aviso: **¿a los cuántos días sin pagar debe el sistema
sugerírselo al administrador?**

`[Answer]:`  ___ días

## V-18 · Los límites que disparan una autorización 🟡
*(C-64 · faltan los valores)*

Dijeron que hay **un límite único para toda la empresa** (C-64) y que las dos operaciones que
piden llave son **prestar por encima del monto** y **recibir cuotas adelantadas de más** (C-59).
Faltan los dos números que usan hoy:

- Monto máximo que un cobrador puede prestar sin pedir autorización: `[Answer]:`
- Máximo de cuotas adelantadas que puede recibir sin autorización: `[Answer]:`
- Y el código de autorización, ¿de cuántos dígitos? *(en el material aparecían 5 y también
  "de 3 a 6")* `[Answer]:`

## V-19 · Los mensajes: ¿uno por pago o un resumen? 🟡
*(C-78 · adicional)*

Marcaron como indispensables los avisos **al prestar**, **al pagar** y **al no pagar**, pero
después escribieron: *"se podría estudiar si por semana"*.

El cálculo importa, porque cada mensaje se paga: en un préstamo diario de 24 cuotas, avisar
cada pago son **24 mensajes por préstamo**. Con 500 clientes activos son unos **12.000 mensajes
al mes**, solo de confirmaciones.

Y hay algo que quizá lo resuelve solo: en **C-22** ya pidieron que **al cerrar caja cada cliente
reciba su extracto**. Ese mensaje ya dice si pagó, cuánto y cuánto le queda. **Un mensaje diario
por cliente cubre el aviso de pago y el de no pago a la vez.**

**OPCIONES DE RESPUESTA**

- **A)** Solo el **extracto al cierre de caja** (1 al día por cliente visitado) + el aviso al
  registrar un préstamo nuevo *(Recomendada: cubre todo lo que pidieron al menor costo)*
- **B)** Como marcaron: uno por cada pago, uno por cada no pago, y además el de préstamo nuevo
- **C)** Un **resumen semanal** por cliente
- **X)** Otra — la explico

`[Answer]:`

## V-20 · Si un suscriptor no paga el software 🟡
*(C-114 · faltan los plazos)*

Marcaron **B**: avisar y **suspender todo, incluida la app de los cobradores**. Faltan los
plazos, y el detalle delicado que mencionamos en la v2: al suspender deja una operación entera
parada a mitad de jornada, con pagos sin sincronizar en los celulares.

- ¿Cuántos días de gracia desde el vencimiento? `[Answer]:`
- ¿Cuántos avisos antes, y a los cuántos días? `[Answer]:`
- Al suspender, ¿la app debe **dejar sincronizar lo que ya está en el celular** antes de
  bloquearse? `[Answer]:`
- Si el suscriptor se va definitivamente, ¿cuánto tiempo le guardan los datos por si vuelve?
  `[Answer]:`

## V-21 · Planes y prueba gratis 🟡
*(C-116 · era "no lo he pensado")*

Escribieron que podría ser *"el primer mes al 50% del valor del plan"*, y que lo definen entre
los tres. Con lo de C-04 (cobro **por ruta activa**) ya hay media respuesta. Falta:

- El precio por ruta al mes, aunque sea un rango: `[Answer]:`
- ¿Hay un mínimo de rutas para poder contratar? `[Answer]:`
- ¿Prueba gratuita, o el primer mes al 50%? ¿Cuántos días/meses? `[Answer]:`

## V-22 · A dónde quieren llegar, en números 🟡
*(C-100 y C-07)*

En C-100 escribieron algo que entendemos y compartimos: *"ser la APP Nº1 en toda Sudamérica y
Centroamérica"*. Pero para saber si el sistema está sirviendo hace falta algo medible. En C-07
respondieron *"por la cantidad de suscriptores"*, así que vamos por ahí:

- ¿Cuántos suscriptores esperan tener **en 12 meses**? `[Answer]:`
- ¿Y **en 24 meses**? `[Answer]:`
- Aparte de suscriptores, ¿hay algo de su **operación propia** que quieran ver mejor y se
  pueda medir? (ej. *"que el cierre de caja pase de 2 horas a 10 minutos"*, *"cero descuadres
  al mes"*, *"bajar la mora del 18% al 12%"*) `[Answer]:`

## V-23 · Disponibilidad contra costo 🟡
*(C-102 y C-105 · van juntas)*

Estas dos respuestas tiran en direcciones opuestas y conviene verlo junto:

- **C-102**: el sistema no se puede caer **de 14:00 hasta el cierre de caja, que puede ser las
  23:00** — y advirtieron que la proyección es multi-país, con husos horarios distintos. Ocho
  países con esa ventana **es prácticamente 24/7**.
- **C-105**: *"lo más económico posible"*, y *"los costos no deben superar lo que tenemos
  proyectado cobrar por cada suscriptor"*.

Lo segundo tiene solución si nos dan el dato: **¿cuánto piensan cobrar por ruta al mes?** (V-21).
Con eso podemos dimensionar la infraestructura para que el costo por suscriptor quepa dentro.

- ¿Cuánto están dispuestos a gastar **al mes en total** para operar el sistema durante el primer
  año, mientras solo lo usan ustedes? `[Answer]:`
- Si cayera 30 minutos un martes a las 16:00, ¿qué pasa **de verdad** en la operación? ¿Los
  cobradores siguen trabajando sin señal (C-65) y sincronizan después, o se paran? `[Answer]:`

## V-24 · ¿Quién usa la app móvil? 🟡
*(C-74 · marcaron tres opciones que se excluyen)*

Marcaron **A** (*solo los cobradores*), **B** (*también el administrador*) y **C** (*también los
socios*). Suponemos que quisieron decir que la usan los tres. Confirmen, y aclaren el alcance:

- El **administrador** en el móvil, ¿solo consulta, o también **aprueba ventas y da llaves**?
  `[Answer]:`
- El **socio** en el móvil, ¿solo el resumen del día, o el tablero completo? `[Answer]:`

---

# PARTE 3 · Lo que quedó pendiente de algo

## V-25 · 📎 El Excel del cierre de caja 🔴
*(C-57 · marcaron "sí, lo adjunto" pero no venía)*

Sigue siendo lo más valioso que nos pueden mandar. Su documento pide un reporte *"idéntico al
formato utilizado actualmente"*, y sin ver el archivo eso no se puede construir ni verificar.
Con un día real basta, aunque cambien los nombres de los clientes.

`[Answer]:`

## V-26, V-27, V-28 · Las tres de la llamada 🔴

Ustedes mismos pidieron responder estas hablando, y estamos de acuerdo: son de explicar, no
de marcar opciones. Las dejamos listas para esa reunión:

- **V-26** *(C-49)* — **El circuito del dinero**: dónde entra, dónde se acumula y a dónde va.
  Las tres cajas que aparecen en sus documentos (cobrador, general de la unidad, PIX) y cómo
  se conectan. Con lo de C-52 y C-53 ya tenemos media película: el cobrador no consigna, usa
  el efectivo para prestar, gasolina y sueldos, y el administrador le inyecta de lo recaudado
  por PIX. Falta cerrarla.
- **V-27** *(C-82)* — **Los indicadores del tablero**, mirando su Excel. En particular los tres
  que pidieron ver al abrir el sistema: **caja inicial, caja actual y "recaudo pretendido"**.
  Ese último es un indicador nuevo, no estaba en la lista de 13 del documento, y hay que
  definir cómo se calcula.
- **V-28** *(C-91)* — **Los patrones de fraude** que quieren detectar. En C-99 ya nombraron los
  dos grandes y sus controles; esto es para el detalle de qué comportamientos deberían levantar
  una alerta.

**¿Cuándo les queda bien esa llamada?** `[Answer]:`

## V-29, V-30, V-31 · Las cuatro legales que no sabían 🔴
*(C-93, C-94, C-95, C-98)*

En estas cuatro respondieron **"no lo sé"**, y es una respuesta legítima — pero no se pueden
quedar así, porque cambian cómo se construye el sistema y salen caras si se descubren tarde.
Las tres primeras **dependen de V-01**: sin saber el país no se pueden ni consultar.

Nuestra propuesta es que las averigüemos nosotros en cuanto nos digan el país, y ustedes lo
validen con un contador o abogado local. Lo que necesitamos saber ahora:

- **V-29** — ¿Tienen contador o abogado en el país donde operan al que podamos consultarle?
  `[Answer]:`
- **V-30** — Sobre el **tope legal de interés** (C-94): su ejemplo de C-10 es **20% sobre 24 días**.
  Anualizado eso es una tasa muy alta, y en varios países de su lista de expansión existe un
  límite de usura. ¿Quieren que el sistema **les avise** al pasarse, que **lo bloquee**, o que
  no haga nada? `[Answer]:`
- **V-31** — Sobre **dónde se guardan los datos** (C-98): ¿tienen alguna preferencia o exigencia
  de un cliente sobre que la información se quede en su país? `[Answer]:`

---

# PARTE 4 · Lo que nunca les preguntamos

La v2 se concentró en **cómo funciona su negocio**. Estas 23 son sobre **cómo debe comportarse
el sistema**, y no estaban en ningún documento que nos dieran.

Son más aburridas, no lo negamos. Pero varias de ellas son **caras de cambiar después**: la
auditoría, el aislamiento entre empresas y la política de tarjetas se deciden una vez y
condicionan todo lo que se construya encima.

Si tienen que repartirse el trabajo, este bloque es el más fácil de delegar: casi ninguna
necesita mirar el Excel ni consultar a nadie.

---

## Bloque A · La auditoría: qué queda registrado

En **C-99** nos dijeron que el fraude interno es su problema nº 1. La auditoría es la
herramienta con la que se investiga cuando ya pasó. Estas cuatro preguntas deciden si esa
herramienta les va a servir o no.

### V-32 · ¿Se registra solo lo que se cambia, o también lo que se mira? 🟡

Registrar cada **cambio** (un pago, una venta, una anulación) es obligatorio y barato.
Registrar además cada **consulta** —quién miró la ficha de qué cliente— permite detectar cosas
como *"este usuario revisó 200 clientes que no son suyos el viernes"*, pero multiplica el
tamaño del registro por diez o más, y eso cuesta dinero todos los meses.

- **A)** Solo los cambios *(Recomendada para arrancar)*
- **B)** Cambios, y además las consultas a datos sensibles (fotos de documentos, listados completos)
- **C)** Absolutamente todo, incluidas las consultas normales
- **X)** Otra — la explico

`[Answer]:`

### V-33 · Cuando alguien cambia un dato, ¿se guarda cómo estaba antes? 🔴

Es la diferencia entre que el sistema le diga *"Ana modificó el préstamo 4821 el martes"* y
que le diga *"Ana cambió el monto del préstamo 4821 **de 1.000 a 1.500** el martes a las
15:42"*. Sin el valor anterior, la auditoría le dice que algo pasó pero no qué pasó, y para
investigar un fraude eso no sirve.

Cuesta más espacio, pero es la única forma de que el registro tenga valor probatorio.

- **A)** Sí, guardar siempre el valor anterior y el nuevo *(Recomendada)*
- **B)** Solo en lo que toca dinero (montos, pagos, cuotas, caja)
- **C)** No hace falta, con saber quién y cuándo basta

`[Answer]:`

### V-34 · ¿Quién puede consultar la auditoría? 🟡

- **A)** Solo el administrador principal
- **B)** El administrador y los socios
- **C)** También los supervisores *(depende de cómo respondan V-04)*
- **X)** Otra — la explico

`[Answer]:`

**Y va pegada:** ¿necesitan poder **buscar** en la auditoría (por cliente, por cobrador, por
fecha, por tipo de acción) y **exportarla** a Excel, o basta con poder leerla en pantalla?

`[Answer]:`

### V-35 · ¿La auditoría debe ser intocable, incluso para nosotros? 🔴

Esta es incómoda pero hay que hacerla. Normalmente, quien administra la base de datos —o sea,
el equipo técnico— **puede borrar o modificar cualquier registro**, incluida la auditoría. Si
el día de mañana hay una disputa seria sobre dinero, alguien podría preguntar: *"¿y cómo sé
que ese registro no lo tocaron?"*

Se puede construir de forma que **nadie**, ni siquiera nosotros, pueda alterar el histórico
una vez escrito. Cuesta algo más y hay que decidirlo ahora, porque después implica rehacer
cómo se guardan los datos.

- **A)** Sí, que sea inalterable para todos, incluido el equipo técnico *(Recomendada dado
  lo que nos contaron en C-99)*
- **B)** No hace falta; confiamos en el equipo
- **C)** No entiendo bien las implicaciones — explíquenmelo en la llamada

`[Answer]:`

---

## Bloque B · Entrar al sistema

### V-36 · ¿Doble verificación para entrar? 🔴

Hoy, quien tenga el usuario y la clave del administrador **puede aprobar ventas, dar llaves y
ver toda la plata**. Si esa clave se filtra —o si alguien del equipo la anota en un papel— no
hay nada más que lo detenga.

La "verificación en dos pasos" es lo que ya usan en el banco: además de la clave, un código que
llega al celular. Encarece poco y cierra el agujero más grande.

- **A)** Sí, obligatoria **para el administrador y los socios**; los cobradores no la necesitan
  *(Recomendada — protege lo que importa sin molestar al equipo de calle)*
- **B)** Obligatoria para todos, incluidos los cobradores
- **C)** Opcional: quien quiera la activa
- **D)** No la queremos, complica el día a día
- **X)** Otra — la explico

`[Answer]:`

### V-37 · El cobrador, ¿tiene que poner su clave todos los días? 🟡

Su celular guarda datos de todos sus clientes y fotos de documentos de identidad. Si lo pierde
o se lo roban (escenario que ya contemplaron en C-71), lo que pase depende de esto.

- **A)** Queda conectado siempre; solo pide clave si se desvincula el equipo
- **B)** Pide clave **una vez al día**, al abrir la caja *(Recomendada — encaja con que la caja
  la abre el administrador)*
- **C)** Pide clave cada vez que abre la app
- **D)** Queda conectado, pero con huella o PIN corto para abrir *(buen equilibrio si el equipo
  es poco hábil con la tecnología, como dijeron en C-106)*

`[Answer]:`

### V-38 · Si un cobrador olvida su clave, ¿cómo la recupera? 🟡

Lo normal sería "le mandamos un correo", pero en C-42 no pidieron correo electrónico al crear
usuarios, y es probable que varios cobradores no tengan uno que usen.

- **A)** El administrador se la restablece desde la web y se la dice *(Recomendada — simple y
  encaja con que el administrador ya controla todo)*
- **B)** Por SMS al celular del cobrador
- **C)** Por WhatsApp
- **D)** Por correo electrónico — sí tienen todos
- **X)** Otra — la explico

`[Answer]:`

---

## Bloque C · Reportes, tablero y fotos

### V-39 · De los 9 reportes, ¿cuáles van en la primera entrega? 🟡

En **C-85** marcaron *"todos son indispensables"* pero escribieron al lado *"podríamos analizar
los más importantes"*. Las dos frases se anulan, así que preguntamos directo. Los nueve son:
ventas, cobranza, mora, caja, PIX, efectivo, flujo de caja, rentabilidad y comparativos.

**Marquen los que necesitan desde el primer día:**

- ☐ Ventas ☐ Cobranza ☐ Mora ☐ Caja ☐ PIX ☐ Efectivo ☐ Flujo de caja ☐ Rentabilidad ☐ Comparativos

`[Answer]:`

**Y para cada uno que marquen:** ¿por qué periodo lo necesitan (día, semana, mes) y filtrado
por qué (ruta, cobrador, todos)?

`[Answer]:`

### V-40 · Los "comparativos", ¿contra qué comparan? ⚪

Aparecen en su lista de reportes pero nunca se dijo contra qué.

- **A)** Contra el día anterior
- **B)** Contra el mismo día de la semana pasada *(suele ser lo útil: los lunes se parecen a
  los lunes, no a los domingos)*
- **C)** Contra el promedio del mes
- **D)** Contra la meta que yo fije
- **X)** Otra — la explico

`[Answer]:`

### V-41 · Las fotos de cada venta 🟡

En **C-44** dejaron cerradas las fotos **del cliente**: 5 fijas (1 documento, 1 residencia,
3 del comercio). Pero en una venta concreta puede que quieran adjuntar otras cosas: la foto de
una garantía, el comprobante de un PIX (C-23), la evidencia de una visita.

- ¿Cuántas fotos, como máximo, por venta? `[Answer]:`
- ¿Y por pago? (el comprobante de PIX ya cuenta como una) `[Answer]:`
- Esas fotos de venta, ¿se conservan igual que las del cliente, o se pueden borrar antes?
  *(en C-97 dijeron: fotos y comprobantes se pueden borrar tras 12 meses de inactividad)*
  `[Answer]:`

---

## Bloque D · Cuando algo va mal

### V-42 · ¿De qué quieren que el sistema les avise solo? 🟡

No es lo mismo enterarse de un problema porque alguien lo notó, que porque el sistema le
escribió. **Marquen lo que quieren que les llegue sin pedirlo:**

- ☐ Una ruta lleva más de X horas sin sincronizar
- ☐ Una caja quedó sin cerrar al final del día
- ☐ Un cierre de caja no cuadró
- ☐ Falló el envío de mensajes de WhatsApp
- ☐ Un cobrador registró muchos "no pago" seguidos
- ☐ Alguien intentó entrar con clave equivocada varias veces
- ☐ Un cliente reclamó por un pago mal registrado *(el canal que pidieron en C-99)*
- ☐ Otra — la explico

`[Answer]:`

**¿Y por dónde les llega ese aviso?** ¿WhatsApp, correo, una campanita dentro del sistema?

`[Answer]:`

### V-43 · Si el sistema se cae, ¿qué tiene que seguir funcionando? 🔴

En **C-102** dijeron que no puede caerse entre las 14:00 y el cierre de caja. Ningún sistema
cumple eso al 100%, así que la pregunta real es qué pasa el día que falle.

La buena noticia es que ustedes ya tienen media respuesta sin saberlo: en **C-65** pidieron que
la app funcione **sin señal**. Eso significa que, si el servidor cae, **los cobradores pueden
seguir cobrando todo el día** y sincronizan cuando vuelva. Lo que se cae es la web del
administrador: no podría aprobar ventas ni dar llaves.

- ¿Es aceptable que, durante una caída, **los cobradores sigan trabajando pero no se puedan
  aprobar ventas nuevas** hasta que vuelva? `[Answer]:`
- ¿Cuánto tiempo caído es "malo pero se aguanta"? ¿1 hora? ¿4 horas? ¿un día? `[Answer]:`
- ¿A partir de cuánto tiempo lo considerarían un problema grave que hay que compensarles a los
  suscriptores? `[Answer]:`

### V-44 · Para actualizar el sistema hay que pararlo un rato 🟡

De vez en cuando hay que hacer mantenimiento. Con su horario (35% mañana, 65% de 14:00 a
21:00, según C-101) y la ventana crítica de C-102, la franja que queda es estrecha —y se
complica más si operan en varios países con husos distintos.

- **A)** De madrugada, entre las 02:00 y las 05:00, avisando con antelación
- **B)** Domingos, que según C-12 no se cobra
- **C)** Cuando haga falta, avisando con 24 horas
- **X)** Otra — la explico

`[Answer]:`

### V-45 · ¿Quién atiende cuando algo falla? 🟡

Esto no es sobre el software, es sobre el servicio. El día que un cobrador no pueda cerrar caja
a las 22:00, alguien tiene que contestar.

- ¿Quién atiende a los cobradores cuando tienen un problema con la app: ustedes, o esperan que
  lo hagamos nosotros? `[Answer]:`
- ¿En qué horario debe haber alguien disponible? `[Answer]:`
- Cuando le vendan el software a otras empresas, ¿quién atiende a **sus** cobradores?
  `[Answer]:`

---

## Bloque E · Velocidad y consumo

### V-46 · ¿Qué pantallas tienen que sentirse instantáneas? 🟡

Hacer que **todo** sea instantáneo multiplica el costo. Hacer que lo sean **las tres pantallas
que el cobrador usa 200 veces al día** cuesta poco y se nota igual.

**Marquen lo que tiene que responder al toque, sin esperas:**

- ☐ Abrir la lista de clientes del día
- ☐ Registrar un pago
- ☐ Buscar un cliente
- ☐ Ver el estado de la caja
- ☐ Abrir la ficha de un cliente con sus fotos
- ☐ El tablero del administrador
- ☐ Generar el cierre de caja

`[Answer]:`

### V-47 · ¿Cuánto es "demasiado" para esperar? 🟡

Denos un número aproximado, aunque sea a ojo:

- Sincronizar toda la jornada al final del día: `[Answer]:` segundos/minutos
- Generar el cierre de caja: `[Answer]:`
- Exportar un reporte a Excel: `[Answer]:`

### V-48 · Espacio en el celular y datos móviles 🟡

En **C-104** dijeron que la empresa da los celulares (Samsung gama media) y **paga los datos**.
Eso importa: las fotos son lo que más consume. Cinco fotos por cliente, con 150 clientes por
ruta, son unos **300 MB** solo de imágenes.

- ¿Cuántos datos móviles al mes tiene cada cobrador en su plan? `[Answer]:`
- ¿Prefieren que las fotos se suban **solo con WiFi** cuando el cobrador llegue a la oficina,
  aunque tarden más en verse en la web? `[Answer]:`
- ¿Cuánto espacio del celular puede ocupar la app? *(los Samsung de gama media suelen tener
  64 GB, pero llenos)* `[Answer]:`

---

## Bloque F · Cómo llega la app al celular

### V-49 · ⚠️ Play Store y App Store tienen reglas para apps de préstamos 🔴

Esto conviene saberlo ahora y no cuando la app esté lista. **Google y Apple tienen políticas
específicas para aplicaciones de préstamos personales**, y son estrictas: piden documentación
de la licencia para operar, obligan a mostrar la tasa efectiva anual, prohíben plazos de
devolución cortos en algunos casos, y **rechazan apps de préstamos con intereses altos**.

Su caso tiene un matiz a favor: **su app no le presta a nadie**. Es una herramienta interna
para que los cobradores de una empresa hagan su trabajo — más parecida a una app de gestión de
ventas que a una de préstamos. Eso normalmente la saca de esa política. Pero hay que
presentarla bien, y conviene tener un plan B.

- **A)** Publicarla en **Play Store y App Store** normalmente, y nosotros nos encargamos de
  presentarla como herramienta de gestión interna *(Recomendada)*
- **B)** **Solo Android**, instalada directamente por ustedes sin pasar por Play Store *(evita
  las tiendas por completo, pero cada actualización hay que instalarla a mano en cada celular)*
- **C)** Las dos cosas: en las tiendas, y con instalación directa como respaldo
- **X)** Otra — la explico

`[Answer]:`

**Dato que hace falta:** ¿tienen cuenta de desarrollador de Google Play (25 USD, pago único)
o de Apple (99 USD al año)? Si no, hay que crearlas a nombre de la empresa, y **la de Apple
tarda en verificarse**.

`[Answer]:`

### V-50 · ¿La app tiene que enseñar a usarse? 🟡

En **C-106** dijeron que en su equipo *"hay de todo, desde muy hábiles hasta muy básicos"*. Y
cuando le vendan el software a otras empresas, van a llegar cobradores que ustedes no
capacitaron.

- **A)** No hace falta; nosotros capacitamos a cada equipo en persona
- **B)** Una guía rápida la primera vez que el cobrador abre la app
- **C)** Además, ayuda dentro de cada pantalla para consultar cuando se atasque
- **X)** Otra — la explico

`[Answer]:`

---

## Bloque G · El día que le vendan el software a otra empresa

En **C-112** trazaron la secuencia: usar la app en su propia operación → piloto de venta de
paquetes → comercializar. Estas cuatro se deciden **ahora** aunque se usen dentro de un año,
porque cambian cómo se guardan los datos desde el primer día.

### V-51 · Cuando llegue una empresa nueva, ¿cómo se da de alta? 🟡

- **A)** **Ustedes la crean a mano** desde un panel, cobran por fuera y la activan *(Recomendada
  para empezar: es lo que hace falta para el piloto de C-112 y no requiere construir nada extra)*
- **B)** **Autoservicio**: la empresa se registra sola en la web, paga y empieza a usarlo
- **C)** Empezamos a mano y pasamos a autoservicio cuando haya volumen

`[Answer]:`

### V-52 · ¿Podría un cliente exigir que sus datos estén separados de los demás? 🟡

Por defecto, todas las empresas comparten la misma base de datos, cada una viendo solo lo suyo
—es lo normal y lo económico. Pero alguna empresa grande podría exigir su propia instalación
aparte, o que sus datos estén en un país concreto.

- **A)** No lo prevemos; todos comparten
- **B)** Sí, queremos poder ofrecer instalación separada como plan premium
- **C)** No lo sé todavía

`[Answer]:`

### V-53 · ¿Les van a pedir certificaciones? 🟡

Cuando le vendan a empresas medianas o grandes, es común que el comprador pida certificaciones
de seguridad (ISO 27001, SOC 2). Sacarlas es un proyecto en sí mismo, de meses y con costo.

- **A)** No lo prevemos; nuestros clientes son empresas pequeñas
- **B)** Sí, tarde o temprano nos las van a pedir — mejor construir pensando en eso
- **C)** No lo sé

`[Answer]:`

### V-54 · Las tarjetas: una decisión que es barata hoy y carísima después 🔴

Cuando cobren el software con tarjeta (C-113), hay dos formas:

| | Cómo funciona | Qué implica |
|---|---|---|
| **Checkout externo** | Al pagar, el suscriptor va a la página del proveedor de pagos (Stripe, Mercado Pago, Asaas…), mete la tarjeta **ahí**, y vuelve. Su sistema nunca ve el número | Cumplimiento mínimo, un formulario y listo |
| **Formulario propio** | El suscriptor mete la tarjeta **dentro de su web**, que se ve más integrada | Su sistema entra en el alcance completo de **PCI-DSS**: auditorías anuales, escaneos, controles. Decenas de miles de dólares al año |

No hay término medio, y cambiar de la primera a la segunda después significa rehacer el módulo
y auditar todo el sistema.

**PREGUNTA**
¿Aceptan como regla fija que **ningún número de tarjeta pase nunca por su sistema**?

- **A)** Sí, aceptado *(Recomendada, con diferencia. La única razón para no hacerlo sería que
  quisieran que el pago se vea 100% dentro de su marca, y no compensa)*
- **B)** No; queremos el formulario dentro de nuestra web
- **C)** No entiendo bien las implicaciones — explíquenmelo

`[Answer]:`

---

## Cierre

Son 54, pero no se asusten con el número: **14 son elegir entre dos cosas que ustedes mismos
ya dijeron**, y las 23 de la Parte 4 son cortas y se pueden repartir entre los tres. Ninguna
necesita que busquen información fuera, salvo el Excel de V-25.

**Si responden todo esto, el lado del negocio queda cerrado** y ya no volvemos a molestarlos
con cuestionarios: lo que siga es entrevista técnica interna.

Si solo pueden atender unas pocas, este es el orden que más desbloquea:

| Prioridad | Pregunta | Por qué |
|---|---|---|
| **1** | **V-06** — la API de WhatsApp | ⛔ El trámite tarda semanas y no depende de nosotros. Cada día que pase es un día de retraso de la v1, y sin él **no existe ninguno de los dos controles antifraude** |
| **2** | **V-01** — país, moneda e idioma | Bloquea las 4 legales, la moneda, el idioma y la nota fiscal. Además el paso 1 de V-06 lo necesita |
| **3** | **V-05** — app o web primero | Decide qué construimos en la primera entrega. Ya va con recomendación del equipo: solo hace falta un sí |
| **4** | **V-02** y **V-03** — descuadre de caja y fecha del pago offline | Sin esto la caja no cuadra, que es lo que más temen (C-110) |
| **5** | **V-25** — el Excel | Es un archivo, no una respuesta; nos ahorra la reunión V-27 |
| **6** | **V-09** — los 5.000 | Decide el tamaño de todo lo que se construya |
| **7** | **V-04** y **V-08** — el supervisor y la tasa | Afectan permisos y cálculo, que se tocan en todas partes |
| **8** | **V-33**, **V-35** y **V-54** — auditoría y tarjetas | Las tres son **baratas hoy y carísimas después**: condicionan cómo se guardan los datos desde el primer día |

**Cómo repartírselo, si ayuda:** la Parte 1 y la Parte 2 necesitan a quien conoce el negocio
por dentro. La Parte 3 es una llamada y un archivo. **La Parte 4 la puede responder cualquiera
de los tres** — son preferencias sobre cómo debe portarse el sistema, no reglas de la operación.

---

*Generado a partir de `Product-Definition/open-questions.md` y del registro de respuestas en
`interview/business/client-answers-2026-08-01.md`.*
*Versión 3 · 2026-08-01 — 54 preguntas (V-00 más V-01…V-54). La v2 tenía 117; 89 quedaron
cerradas con sus respuestas. Respondiendo esta v3, la definición del producto pasa de ~65% a
~90%: lo restante es entrevista técnica, que no depende del cliente.*
