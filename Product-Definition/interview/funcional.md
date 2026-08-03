# Componente Funcional — Preguntas para cerrar el Discovery

**Fecha**: 2026-08-02 · **46 preguntas en 12 bloques** · ~70 minutos

Este es el cuadernillo más largo y también el que más cierra: el bloque funcional está hoy al
**45,2 %**, el más bajo de todos, y describe **cómo se debe comportar el sistema** en cada situación.

**No hace falta responderlo de una sentada.** Está dividido en bloques independientes y **se puede
repartir entre varias personas**: quien maneja la caja no necesita opinar sobre el asistente de IA.

## Cómo responder

- Marque la letra y use **Descripción** para argumentar o matizar. Ahí está el valor.
- Combine letras cuando quiera decir varias: `A y C`.
- Si no aplica a su operación, escríbalo: *"eso no lo hacemos"* cierra la pregunta igual de bien.
- Si no lo sabe, dígalo. Una respuesta inventada cuesta más que un hueco declarado.

> **Seis preguntas funcionales viven en el cuadernillo de Contradicciones**, porque además de faltar,
> chocan con otra respuesta: el canal de WhatsApp, la proporción de PIX, el alcance de la IA, la
> llave sin señal, el reingreso de pagos duplicados y el Excel del cierre. **No las repita aquí.**

---

# BLOQUE 1 · Roles y estructura

## F-01 · Quién puede hacer qué, exactamente

**Contexto**

Sabemos que hay tres roles: **administrador**, **socio** y **cobrador**. Y sabemos a grandes rasgos
qué hace cada uno. Lo que no existe es la lista precisa de permisos, y sin ella quien construya va a
decidir por su cuenta.

**Pregunta**

Para cada acción, ¿quién puede hacerla?

**Opciones de respuesta**

| Acción | Administrador | Socio | Cobrador |
|---|---|---|---|
| Crear un cliente nuevo | | | |
| Editar los datos de un cliente | | | |
| Crear una venta (préstamo) | | | |
| Aprobar una venta | | | |
| Registrar un pago | | | |
| Anular o corregir un pago | | | |
| Aprobar una llave | | | |
| Registrar un gasto | | | |
| Aprobar un gasto | | | |
| Cerrar la caja | | | |
| Ver el historial de auditoría | | | |
| Ver otras rutas distintas a la suya | | | |
| Dar de alta a otro usuario | | | |

**Descripción** *(argumente la respuesta o añada otra opción)*

`[Answer]:`

---

## F-02 · Cómo se asignan los clientes a un cobrador

**Contexto**

En **C-80** dijeron que *"cada cliente debe estar asociado al número de la ruta"*. Falta saber cómo
llega ahí y qué pasa cuando hay que moverlo — por ejemplo cuando un cobrador renuncia, se enferma o
lo cambian de zona, que según **V-17** ocurre con frecuencia.

**Pregunta**

¿Cómo se asigna y reasigna un cliente?

**Opciones de respuesta**

A) El cliente pertenece a la ruta desde que se crea, y solo el administrador puede moverlo
B) El administrador reasigna clientes entre rutas cuando quiere, sin restricción
C) Se puede reasignar, pero **no si el cliente tiene un préstamo activo**
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

Cuando un cliente pasa de una ruta a otra teniendo un préstamo vivo: **¿los pagos ya cobrados siguen
contando para el cobrador antiguo o para el nuevo?** Afecta a las comisiones y a los reportes.

`[Answer]:`

---

## F-03 · Un administrador, ¿cuántas rutas?

**Contexto**

En **V-10** dijeron: *"cada administrador que delega el suscriptor puede encargarse de ese tema
(ejemplo: tengo mis rutas, yo me encargo de eso)"*. Suena a que un administrador puede tener varias
rutas, pero no todas las de la empresa.

**Pregunta**

¿Un administrador ve y gestiona todas las rutas de su empresa, o solo algunas?

**Opciones de respuesta**

A) **Todas** las rutas de su empresa
B) **Solo las que le asignen** — puede haber varios administradores repartiéndose las rutas
C) Hay **un administrador principal** que ve todo, y otros que ven solo lo suyo
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

`[Answer]:`

---

# BLOQUE 2 · Clientes

## F-04 · Qué datos son obligatorios para crear un cliente

**Contexto**

En **V-41** cerraron las fotos: máximo 5 archivos, y **documento de identidad + comprobante de
residencia obligatorios**. Falta la lista de campos de texto.

Importa porque cada campo obligatorio es una fricción en la calle: el cobrador está de pie frente al
cliente y cada dato de más es tiempo. Pero un campo que falta hoy es un cliente imposible de
localizar mañana.

**Pregunta**

¿Cuáles de estos son obligatorios para poder guardar un cliente?

**Opciones de respuesta**

| Campo | Obligatorio / Opcional / No se pide |
|---|---|
| Documento de identidad (CPF) | |
| Nombre completo | |
| Teléfono celular | |
| Dirección de vivienda | |
| Ciudad / barrio | |
| Dirección del negocio | |
| Referencia personal (nombre y teléfono) | |
| Fecha de nacimiento | |
| Correo electrónico | |

**Descripción** *(argumente la respuesta o añada otra opción)*

`[Answer]:`

---

## F-05 · ¿Puede el mismo cliente estar en dos rutas?

**Contexto**

Una persona puede tener préstamos con dos cobradores distintos de la misma empresa, o con dos
empresas diferentes. Hoy no está definido si el sistema lo permite, ni si el documento de identidad
es único.

Esto decide algo importante: **si el sistema puede o no avisar de que un cliente ya debe dinero en
otra ruta**.

**Pregunta**

¿El mismo documento de identidad puede aparecer en varias rutas?

**Opciones de respuesta**

A) **No.** Un cliente pertenece a una sola ruta; si aparece en otra, el sistema lo bloquea
B) **Sí**, pero el sistema **avisa** al cobrador de que ese cliente ya existe en otra ruta
C) **Sí**, sin avisar — son operaciones independientes
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

Una pregunta que va pegada: **¿ese aviso debería cruzar empresas?** Es decir, ¿si un cliente le debe
a la empresa A, debería enterarse la empresa B? Es muy útil para ustedes, pero **la ley brasileña de
datos lo complica**: sería usar los datos de una persona para un fin distinto del que se recogieron.
Nuestra recomendación previa es **que el aviso no cruce empresas**.

`[Answer]:`

---

## F-06 · ¿Se valida el documento contra alguna fuente externa?

**Contexto**

Nunca se preguntó. Hoy el cobrador teclea el documento y el sistema lo acepta tal cual.

**Pregunta**

¿El sistema debe comprobar el documento contra algún servicio externo?

**Opciones de respuesta**

A) **No.** Basta con la foto del documento que ya se toma
B) Sí, validar solo que el **formato del CPF sea correcto** (es gratis y evita errores de tecleo)
C) Sí, consultar un **buró de crédito** — indico cuál y quién paga la consulta
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

La opción **B** es prácticamente gratis y atrapa errores de digitación, que a 2.000 clientes ocurren
seguro. La **C** cuesta dinero por consulta y hay que contratarla aparte.

`[Answer]:`

---

## F-07 · Referencias y codeudores

**Contexto**

En los documentos aparecen "referencias" pero nunca se aclaró qué son: ¿un texto que se guarda por
si acaso, o personas a las que se contacta cuando el cliente no paga?

**Pregunta**

¿Qué son las referencias y para qué se usan?

**Opciones de respuesta**

A) Solo **texto informativo** — nombre y teléfono que se guardan y nadie usa automáticamente
B) Son **codeudores reales**: responden por la deuda y se les puede reclamar
C) Se les **contacta cuando el cliente entra en mora**, pero no responden legalmente
D) No usamos referencias
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

Si se les contacta (**B** o **C**), hay que decidir si reciben mensajes automáticos — y eso exige su
consentimiento, igual que el del cliente.

`[Answer]:`

---

## F-08 · ¿Se puede borrar un cliente?

**Contexto**

En **V-17** dijeron que un cliente que no paga **se bloquea**, no se borra. Y en **V-33** que los
montos no se modifican nunca. Falta el caso del borrado real.

Y hay un caso que **la ley obliga a resolver**: un cliente puede exigir que se eliminen sus datos
personales. El sistema tiene que poder hacerlo sin romper las cuentas.

**Pregunta**

¿Qué pasa cuando hay que eliminar a un cliente?

**Opciones de respuesta**

A) **Nunca se borra.** Se bloquea y queda el historial completo
B) Se borran sus **datos personales y sus fotos**, pero **se conservan los movimientos de dinero**
   sin nombre *(así las cuentas siguen cuadrando)*
C) Se borra todo, incluidos los movimientos
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

La opción **B** es la que cumple la ley sin romper la contabilidad, y el sistema ya está diseñado
para permitirlo: las fotos viven aparte de los movimientos. **¿Quién debería poder autorizar un
borrado así — el administrador de la empresa, o ustedes?**

`[Answer]:`

---

# BLOQUE 3 · Préstamos y su ciclo de vida

## F-09 · ¿Cuándo un préstamo está "en mora"?

**Contexto**

En **V-17** dijeron que pasar un cliente a **cartera castigada** lo decide el administrador a mano.
Pero antes de eso hay un estado intermedio —"moroso"— que nadie ha definido en días.

Sin un número, el sistema no puede pintar la lista del día en colores, ni avisar al administrador,
ni calcular cuánta cartera está en riesgo.

**Pregunta**

¿A partir de cuántos días sin pagar un préstamo se considera "en mora"?

**Opciones de respuesta**

A) 1 día — si no pagó su cuota del día, ya está en mora
B) 3 días
C) 7 días
D) No usamos ese concepto; solo miramos cuántas cuotas debe
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

Ojo con la frecuencia diaria: si se cobra de lunes a sábado, **un cliente que no pagó ayer ya debe
una cuota**. ¿Eso ya es mora, o hay margen?

`[Answer]:`

---

## F-10 · ¿Hay cobros además del interés?

**Contexto**

En **V-08** quedó clara la fórmula del interés. Lo que no sabemos es si además se cobra algo al
desembolsar.

**Pregunta**

¿Se cobra algo más aparte del interés?

**Opciones de respuesta**

A) **No.** Solo el interés, como en el ejemplo de V-08
B) Sí, una **comisión de apertura** — indico cuánto y si se descuenta del desembolso
C) Sí, un **seguro** — indico cuánto
D) Sí, otros conceptos — los detallo abajo
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

Si se cobra algo, díganos si **se descuenta del dinero que recibe el cliente** (presta 1.000, recibe
950) o **se suma a lo que debe pagar** (presta 1.000, debe 1.250). No es lo mismo y cambia todos los
cálculos.

`[Answer]:`

---

## F-11 · La lista de estados de un préstamo

**Contexto**

De las conversaciones han salido estos estados: **activo**, **al día**, **en mora**, **renovado**,
**cartera castigada**, **cancelado**. La "venta temporal" se eliminó en `C-32`.

Falta confirmar la lista definitiva y, sobre todo, **qué transiciones son posibles**: por ejemplo,
¿un préstamo castigado puede volver a activo si el cliente aparece y paga?

**Pregunta**

¿Es correcta esta lista? ¿Falta o sobra alguno?

**Opciones de respuesta**

A) Está completa y correcta
B) Falta alguno — lo añado abajo
C) Sobra alguno — lo indico abajo
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

Dos casos concretos:

1. **Un préstamo castigado, ¿puede volver a activo** si el cliente reaparece y paga?
2. **Un préstamo cancelado, ¿se puede reabrir**, o es definitivo?

`[Answer]:`

---

## F-12 · Refinanciación: ¿existe y en qué se diferencia de renovar?

**Contexto**

En **V-12** cerraron la renovación: el cliente debe quedar **en cero** y se hace una venta nueva. Eso
es claro.

Pero en los documentos también aparece "refinanciación", que normalmente significa lo contrario:
**reestructurar una deuda que el cliente no puede pagar**, sin exigirle que la salde antes.

**Pregunta**

¿Existe la refinanciación en su operación?

**Opciones de respuesta**

A) **No existe.** O el cliente paga todo y renueva, o no hay préstamo nuevo
B) **Sí existe**: a un cliente que no puede pagar se le arma un préstamo nuevo con el saldo viejo
   dentro — lo explico abajo
C) Se le da más plazo sin crear un préstamo nuevo
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

Si responde **B**, la pregunta clave es: **¿el interés ya causado se cobra igual, o se perdona parte?**

`[Answer]:`

---

## F-13 · Preventa, estudio y aprobación

**Contexto**

En **V-18** describieron el flujo: *"en todos los montos que sean por primera vez debe pedir
autorización — se llama al administrador preguntando el valor que necesita ese cliente — una vez
autorice, el cobrador puede subir la venta al sistema"*.

En esa descripción **la autorización ocurre por teléfono, antes de tocar el sistema**. Pero en otros
documentos aparece un flujo de "preventa" o "enviar a estudio" **dentro** del sistema.

**Pregunta**

¿Cómo funciona realmente la aprobación de una venta nueva?

**Opciones de respuesta**

A) **Por teléfono, antes**: el cobrador llama, le autorizan el monto, y lo registra ya aprobado
B) **Dentro del sistema**: el cobrador crea la venta, queda "pendiente", el administrador la aprueba
   en su pantalla y el cobrador recibe el aviso
C) **Las dos**: llama para ponerse de acuerdo, pero además queda el registro de aprobación
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

La opción **A** es la más rápida pero **deja el "quién autorizó" solo en la memoria de dos personas**.
La **B** deja rastro auditable, que es justamente lo que pidieron en `C-99`. La **C** es lo mejor de
las dos y probablemente lo que ya hacen en la práctica.

`[Answer]:`

---

## F-14 · Cartera castigada

**Contexto**

En **V-17** dijeron que el administrador manda al cliente a cartera castigada y eso **lo bloquea**
para futuros préstamos, *"ya que en muchos casos los cobradores son cambiados y no conocen los
clientes que dejaron de prestar"*.

Faltan dos cosas.

**Pregunta**

Sobre la cartera castigada:

**Opciones de respuesta**

**a) ¿Se sigue contando el interés después de castigarla?**
A) No, la deuda se congela en el monto que tenía
B) Sí, sigue creciendo

**b) ¿Hasta dónde llega el bloqueo del cliente?**
C) Solo en la ruta donde no pagó
D) En **toda la empresa** — ninguna ruta le puede prestar
E) En **todas las empresas** que usen el sistema

**Descripción** *(argumente la respuesta o añada otra opción)*

Sobre la opción **E**: es la más potente para ustedes, pero **la ley brasileña de datos la
complica** — sería compartir el historial de una persona entre empresas competidoras sin su permiso.
Nuestra recomendación previa es **D**.

`[Answer]:`

---

# BLOQUE 4 · Pagos

## F-15 · Abono extraordinario a capital

**Contexto**

Como el interés es **fijo sobre el capital** (`V-08`), el cliente debe una cantidad total desde el
primer día. Si un día llega con dinero de más, hay dos formas de aplicarlo.

**Pregunta**

Si un cliente paga más de lo que le toca, ¿qué pasa?

**Opciones de respuesta**

A) **Se adelanta**: paga cuotas futuras, termina antes, y debe lo mismo en total
B) **Se descuenta del total** y se le recalculan las cuotas restantes más bajas
C) Solo se aceptan cuotas completas; el excedente se le devuelve
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

En `D-02` quedó que **no hay descuento por pagar antes**, así que la opción **A** es la coherente:
termina antes pero paga lo mismo. Confírmenlo o corríjanlo.

`[Answer]:`

---

## F-16 · Corregir un pago mal registrado

**Contexto**

El sistema está diseñado para que **los movimientos no se puedan borrar ni editar** — eso es lo que
hace que las cuentas sean confiables y es lo que ustedes pidieron en **V-35**.

Corregir un error, entonces, es **registrar un movimiento que anula el anterior**, quedando los dos
visibles. Falta decidir quién puede hacerlo y hasta cuándo.

**Pregunta**

¿Quién puede corregir un pago mal registrado, y hasta cuándo?

**Opciones de respuesta**

**a) ¿Quién?**
A) Solo el administrador
B) El cobrador, el mismo día
C) El cobrador el mismo día, y el administrador siempre

**b) ¿Hasta cuándo?**
D) Solo antes de cerrar la caja de ese día
E) Cualquier día, mientras el préstamo esté activo
F) Siempre

**Descripción** *(argumente la respuesta o añada otra opción)*

Y un caso incómodo: **si al cliente ya le llegó el mensaje del pago, y luego se corrige, ¿se le avisa
de la corrección?** Si no se le avisa, el cliente tiene un mensaje que ya no coincide con su saldo.

`[Answer]:`

---

## F-17 · Los pagos por PIX

**Contexto**

*(La proporción de PIX contra efectivo está en el cuadernillo de Contradicciones, C-02. Aquí van las
preguntas de funcionamiento.)*

El sistema **no recibe dinero** — solo registra la información del pago. Eso está decidido. Lo que
falta es cómo entra la información de un pago por PIX.

**Pregunta**

Cuando un cliente paga por PIX, ¿cómo se entera el sistema?

**Opciones de respuesta**

A) El **cobrador lo registra a mano**, igual que un pago en efectivo, después de ver el comprobante
B) El **administrador lo registra** cuando lo ve en el extracto del banco
C) El cliente **manda el comprobante** y alguien lo carga
D) Nos gustaría que **entrara solo desde el banco**, sin que nadie lo teclee
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

Si elige **D**, hay que saber que eso exige que el banco ofrezca una conexión automática, y **es un
desarrollo aparte** que no está en el alcance actual. Con **A**, el pago por PIX depende de que el
cobrador lo registre — igual que el efectivo.

`[Answer]:`

---

## F-18 · Qué otros medios de pago hay que poder registrar

**Contexto**

Hasta ahora tenemos efectivo y PIX.

**Pregunta**

¿Qué otras formas de pago recibe un cliente?

**Opciones de respuesta**

A) Solo efectivo y PIX
B) También **transferencia bancaria** normal
C) También **depósito en corresponsal** (lotérica, farmacia, etc.)
D) También **tarjeta**
X) Otras — las explico

**Descripción** *(argumente la respuesta o añada otra opción)*

`[Answer]:`

---

## F-19 · Cuando el cliente no paga

**Contexto**

En **V-42** pidieron que el sistema avise cuando un cobrador registra **muchos "no pago" seguidos**.
Eso presupone que el "no pago" se registra con un motivo — pero el catálogo de motivos no existe.

**Pregunta**

Cuando un cliente no paga, ¿qué registra el cobrador?

**Opciones de respuesta**

A) Solo marca "no pagó", sin más
B) Marca "no pagó" y **elige un motivo de una lista** — propongo la lista abajo
C) Marca "no pagó" y **escribe un comentario libre**
D) B y C
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

Si eligen **B**, ¿sirve esta lista? *No estaba · No tenía dinero · Pidió plazo · Se negó a pagar ·
Negocio cerrado · Cambió de dirección · Otro.* Añadan o quiten.

Y una pregunta aparte: **¿el "no pago" debe exigir foto o ubicación?** Es el único momento en que
el cobrador dice que estuvo y no cobró, y es donde más se podría mentir.

`[Answer]:`

---

## F-20 · Promesa de pago

**Contexto**

En la cobranza diaria es habitual que el cliente diga *"vuelve el jueves y te pago"*. Hoy el sistema
no tiene dónde anotarlo.

**Pregunta**

¿Quieren registrar promesas de pago?

**Opciones de respuesta**

A) **No**, no lo usamos
B) **Sí**, solo como nota para el cobrador
C) **Sí**, y que el sistema le **recuerde al cobrador** el día prometido
D) Sí, y que además **avise al administrador** si la promesa se incumple
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

`[Answer]:`

---

# BLOQUE 5 · Llaves y autorizaciones

## F-21 · Cuánto vive una llave

**Contexto**

Ya sabemos que la llave es un **código de 4 dígitos** (`V-18`) y que hace falta para ventas nuevas y
para registrar pagos a partir de la cuota 5.

Lo que no está definido es **si caduca**. Si una llave sirve para siempre y para cualquier venta, el
control desaparece: el cobrador guarda una y la reutiliza.

**Pregunta**

¿Cuánto vale una llave?

**Opciones de respuesta**

A) **Un solo uso**, para la operación concreta que se pidió, y **caduca ese mismo día**
   *(recomendada: es la que mantiene el control)*
B) Un solo uso, pero **sin caducidad**
C) Sirve **todo el día** para cualquier operación de ese cobrador
D) No caduca ni se limita
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

`[Answer]:`

---

## F-22 · Quién aprueba una llave

**Contexto**

En **V-18** dijeron *"el administrador o encargado"*. Falta la pregunta incómoda: **¿puede la misma
persona pedir una llave y aprobársela?**

Importa más de lo que parece. En `C-99` describieron el fraude interno como el problema nº 1, y la
llave es el control que lo frena. **Si quien la pide puede aprobarla, el control no existe.**

**Pregunta**

Sobre la aprobación de llaves:

**Opciones de respuesta**

**a) ¿Quién puede aprobar?**
A) Solo el administrador
B) El administrador o un encargado que él designe
C) También los socios

**b) ¿Puede alguien aprobarse su propia llave?**
D) **No, nunca** — siempre tiene que ser otra persona
E) Sí, el administrador sí puede

**c) ¿Hay un monto por encima del cual ni el administrador puede aprobar solo?**
F) No, el administrador puede todo
G) Sí, por encima de ____ hace falta también un socio

**Descripción** *(argumente la respuesta o añada otra opción)*

`[Answer]:`

---

## F-23 · El identificador de la llave

**Contexto**

Cada llave aprobada deja un registro. Falta saber si ese registro es visible y buscable, o solo
interno.

**Pregunta**

¿El cobrador y el auditor ven un número de llave que puedan citar?

**Opciones de respuesta**

A) **Sí**, cada llave tiene un identificador visible y se puede buscar por él
B) No hace falta; basta con ver la lista de llaves aprobadas por fecha y cobrador
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

`[Answer]:`

---

# BLOQUE 6 · Caja, gastos y consignación

> **Aviso**: este bloque es el que más depende de la llamada pendiente. Si prefieren, respondan solo
> lo que tengan claro y el resto lo cerramos hablando.

## F-24 · Cuántas cajas hay y cómo se relacionan

**Contexto**

En los documentos aparecen tres cosas que se llaman "caja": la del **cobrador**, una **general de la
unidad**, y una de **PIX**. Nunca se explicó cómo se conectan.

Y en **C-52** y **C-53** dijeron algo que lo complica: el cobrador **no consigna** el dinero — lo usa
para prestar, para gasolina y para sueldos, y el administrador le inyecta efectivo de lo recaudado
por PIX.

**Pregunta**

¿Cuántas cajas existen y qué contiene cada una?

**Opciones de respuesta**

A) Solo **la caja del cobrador**; lo demás son reportes, no cajas
B) **Caja del cobrador** + **caja general de la unidad**
C) Las tres: cobrador, general y PIX
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

Lo que más ayudaría: **describan el recorrido de un billete**. Un cliente paga 50 reales en efectivo
el lunes a las 9 de la mañana — ¿dónde está ese dinero el lunes por la noche, el martes, y el sábado?

`[Answer]:`

---

## F-25 · Quién abre la caja y cuándo

**Contexto**

De **V-03** sabemos que **el cobrador cierra** y que si lleva más de 24 horas sin señal el
administrador puede forzar el cierre. Falta la apertura.

**Pregunta**

¿Quién abre la caja del día y cuándo?

**Opciones de respuesta**

A) El **cobrador**, al empezar la jornada
B) El **administrador**, cuando le entrega el efectivo de arranque
C) Se abre **sola** al cerrar la del día anterior
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

Dos preguntas pegadas: **¿puede haber dos cajas abiertas a la vez del mismo cobrador?** Y **¿qué pasa
si un cobrador no cierra un día — puede abrir la del día siguiente?**

`[Answer]:`

---

## F-26 · La consignación

**Contexto**

En **C-52** dijeron que el cobrador **no consigna**. Pero el dinero tiene que llegar en algún momento
a la empresa, y ese traspaso hoy no está definido en el sistema.

**Pregunta**

¿Cómo entrega el cobrador el dinero, y cómo se registra?

**Opciones de respuesta**

A) **No entrega**: el efectivo se queda con él y se usa para prestar y para gastos
B) Entrega al administrador **cuando este se lo pide** — se registra como movimiento
C) Entrega en un día fijo de la semana — indico cuál
D) Consigna en el banco y sube el comprobante
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

Si es **A**, hay una consecuencia: **el efectivo en manos del cobrador crece sin tope**. ¿Hay un
límite a partir del cual tiene que entregarlo? ¿Y alguien confirma que lo recibió?

`[Answer]:`

---

## F-27 · Gastos

**Contexto**

En **V-05** confirmaron que **aprobar gastos** entra en la web mínima. Falta todo lo demás.

**Pregunta**

Sobre los gastos que registra el cobrador:

**Opciones de respuesta**

**a) ¿Hay categorías fijas?**
A) Sí — propongo: *Gasolina · Transporte · Comida · Sueldo · Papelería · Otro*
B) No, se escribe libre

**b) ¿Necesitan aprobación?**
C) Todos
D) Solo por encima de un monto — indico cuál
E) Ninguno; se registran y ya

**c) ¿Necesitan foto del comprobante?**
F) Todos
G) Solo por encima de un monto
H) Ninguno

**Descripción** *(argumente la respuesta o añada otra opción)*

`[Answer]:`

---

## F-28 · "Dinero pendiente" en el cierre

**Contexto**

En **C-50** dijeron que la caja cierra **a cero pendiente**. Pero nunca se aclaró qué cuenta como
"pendiente": ¿el dinero recaudado que aún no se ha entregado, o las cuotas que los clientes no
pagaron?

Son cosas muy distintas, y de esto depende **si la caja puede cerrar o no**.

**Pregunta**

¿Qué es exactamente "dinero pendiente"?

**Opciones de respuesta**

A) **Efectivo recaudado que el cobrador todavía no ha entregado**
B) **Cuotas que los clientes no pagaron** ese día
C) La diferencia entre lo que el sistema dice que debería tener y lo que tiene en el bolsillo
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

Si es **B**, la caja **nunca cerraría a cero** — siempre hay clientes que no pagan. Por eso creemos
que es **C**, pero hay que confirmarlo.

`[Answer]:`

---

## F-29 · El desembolso de un préstamo nuevo

**Contexto**

En **C-52** dijeron que el cobrador usa el efectivo recaudado **para prestar**. Es decir, el dinero
de un préstamo nuevo sale de su bolsillo, no de un banco.

**Pregunta**

¿Qué pasa si el cobrador no tiene efectivo suficiente para desembolsar una venta aprobada?

**Opciones de respuesta**

A) **No puede desembolsar** — el sistema se lo impide hasta que tenga efectivo
B) Puede desembolsar igual; su caja queda en negativo y se arregla después
C) Pide al administrador que le inyecte efectivo, y hasta entonces la venta espera
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

`[Answer]:`

---

# BLOQUE 7 · Cierre y reportes

## F-30 · Corregir un cierre ya hecho

**Contexto**

En **V-02** dijeron que si la caja no cuadra se **cierra igual**, se genera una alerta y **al día
siguiente se verifica**. Falta qué pasa en esa verificación.

**Pregunta**

Cuando al día siguiente se revisa un cierre descuadrado, ¿qué se hace?

**Opciones de respuesta**

A) Se **reabre** el cierre y se corrige
B) **No se reabre nunca**; se registra un movimiento de ajuste con su explicación
   *(es lo que encaja con "la auditoría es intocable" de V-35)*
C) Depende de si ya pasó el cierre de la semana
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

`[Answer]:`

---

## F-31 · A qué nivel se cierra la caja

**Contexto**

Sabemos que cada cobrador cierra la suya. Falta saber si hay un cierre por encima.

**Pregunta**

¿Hay un cierre por ruta o por empresa además del de cada cobrador?

**Opciones de respuesta**

A) Solo el del cobrador
B) También un **cierre por ruta**, cuando todos sus cobradores han cerrado
C) También un **cierre de toda la empresa**
D) B y C
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

`[Answer]:`

---

## F-32 · Cuáles de los reportes entran en la primera entrega

**Contexto**

En los documentos hay **9 reportes**. En **V-39** solo nombraron uno: *"reporte diario"*.

Construir 9 reportes es semanas de trabajo. Construir 2 o 3 y añadir el resto después es mucho más
razonable — pero hay que saber cuáles.

**Pregunta**

Marque los que necesitan **desde el primer día**:

**Opciones de respuesta**

| Reporte | ¿En la v1? |
|---|---|
| Cierre de caja diario | |
| Recaudo por cobrador / por ruta | |
| Clientes en mora | |
| Cartera activa (cuánto está prestado) | |
| Ventas del periodo | |
| Gastos del periodo | |
| Historial de un cliente | |
| Comparativo entre periodos | |
| Auditoría de operaciones | |

**Descripción** *(argumente la respuesta o añada otra opción)*

¿Los necesitan **en pantalla**, para **exportar a Excel**, o **en PDF**? Cada formato es trabajo
aparte.

`[Answer]:`

---

## F-33 · ¿Hace falta contabilidad formal?

**Contexto**

En los documentos aparece "asiento contable automático". El sistema hoy está diseñado como un
**registro de movimientos de dinero**, no como una contabilidad de partida doble.

**Pregunta**

¿Necesitan contabilidad formal, o basta el registro de movimientos?

**Opciones de respuesta**

A) **Basta el registro de movimientos** — entra dinero, sale dinero, todo trazable
B) Necesitamos **contabilidad de partida doble** con plan de cuentas
C) No hace falta ahora, pero sí exportar en un formato que el contador pueda usar
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

En **V-29** dijeron que el negocio *"no está regulado por ningún país"*. Si no hay obligación de
presentar libros, la opción **A** es suficiente y mucho más barata.

`[Answer]:`

---

# BLOQUE 8 · Mensajes al cliente

> El **canal** (WhatsApp, Telegram o SMS) se decide en el cuadernillo de Contradicciones, C-01.
> Aquí van las preguntas que se aplican sea cual sea el canal.

## F-34 · El permiso del cliente para recibir mensajes

**Contexto**

Tanto la ley brasileña de datos como las reglas de WhatsApp exigen que el cliente **haya dado
permiso** para recibir mensajes. Hoy no hay ningún sitio donde ese permiso se pida ni se guarde.

**Pregunta**

¿Cómo se obtiene y se guarda el permiso del cliente?

**Opciones de respuesta**

A) Se le pide **al crear el cliente**, el cobrador marca una casilla en la app, y queda registrado
   con fecha *(recomendada)*
B) Se incluye en el **contrato del préstamo** que ya firma
C) Se le manda un primer mensaje pidiéndole que confirme
D) No lo vemos necesario
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

Y la otra mitad: **¿cómo se da de baja un cliente que ya no quiere mensajes?** La ley obliga a que
pueda hacerlo.

`[Answer]:`

---

## F-35 · Cuando el mensaje no llega

**Contexto**

En **C-79** dijeron que un envío fallido **solo se registra como fallido**. Pero el control
antifraude depende de que el cliente reciba el extracto: **si no llega, el control no ocurrió**.

**Pregunta**

Si el mensaje al cliente no se puede entregar, ¿qué debe pasar?

**Opciones de respuesta**

A) Solo se registra como fallido, como está hoy
B) El sistema **reintenta** varias veces y luego lo marca
C) Se **avisa al administrador** de los clientes cuyo mensaje no llegó
D) B y C
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

Y una pregunta de fondo: **¿qué pasa con los clientes que no tienen ese canal?** Si un cliente no
tiene WhatsApp, ¿queda sin control antifraude, o se le manda por otro medio?

`[Answer]:`

---

## F-36 · El reporte diario a los socios

**Contexto**

En **C-81** dijeron: al día siguiente **antes de abrir la caja**, el administrador **elige a qué
socios** enviárselo, y **puede ser semanal**.

Falta el detalle operativo.

**Pregunta**

Sobre el reporte a socios:

**Opciones de respuesta**

**a) ¿Se envía solo o lo manda el administrador?**
A) Automático, a una hora fija — indico la hora
B) El administrador aprieta un botón cuando quiere

**b) ¿Qué pasa si algún cobrador no ha cerrado todavía?**
C) Se envía igual, indicando qué rutas faltan
D) No se envía hasta que todos hayan cerrado

**Descripción** *(argumente la respuesta o añada otra opción)*

`[Answer]:`

---

# BLOQUE 9 · Avisos automáticos

## F-37 · ¿Quién configura los avisos?

**Contexto**

En **V-42** marcaron **las 7 alertas** de la lista. Falta saber si esas 7 son fijas o si cada empresa
puede añadir las suyas.

Es una diferencia de tamaño grande: 7 avisos fijos son días de trabajo; **un sistema donde el
administrador se arma sus propias reglas son semanas**.

**Pregunta**

¿Los avisos son fijos o configurables?

**Opciones de respuesta**

A) **Fijos**: las 7 de V-42, y si hace falta otra nos la piden y la añadimos *(recomendada para
   empezar)*
B) **Configurables**: el administrador arma sus propias reglas desde una pantalla
C) Fijos ahora, configurables más adelante
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

Si eligen **B**, díganos **qué tres reglas armarían primero**. Si no se les ocurren tres, probablemente
la respuesta correcta sea **A**.

`[Answer]:`

---

## F-38 · Cuándo salta cada aviso

**Contexto**

De las 7 alertas que marcaron, **cuatro necesitan un número** para poder funcionar.

**Pregunta**

Complete los números:

**Opciones de respuesta**

| Aviso | Umbral |
|---|---|
| Una ruta lleva **____ horas** sin sincronizar | |
| Una caja quedó sin cerrar — avisar a las **____** | |
| Un cobrador registró **____ "no pago" seguidos** | |
| Alguien falló la clave **____ veces** | |
| Un cierre no cuadró por más de **____ reales** *(o cualquier diferencia)* | |

**Descripción** *(argumente la respuesta o añada otra opción)*

`[Answer]:`

---

# BLOQUE 10 · App móvil y trabajo sin señal

## F-39 · Qué se puede hacer sin señal

**Contexto**

En **C-65** dijeron que el cobrador tiene que poder trabajar toda la jornada sin señal, y en **V-03**
que necesita señal **para cerrar la caja**. Falta la lista exacta de lo que sí se puede hacer.

**Pregunta**

Marque lo que el cobrador debe poder hacer **sin señal**:

**Opciones de respuesta**

| Acción | ¿Sin señal? |
|---|---|
| Ver su lista de clientes del día | |
| Registrar un pago | |
| Registrar un "no pago" | |
| Tomar fotos | |
| Recoger la firma del cliente | |
| **Crear una venta nueva** | |
| Registrar un gasto | |
| Consultar el historial de un cliente | |
| Cerrar la caja | |

**Descripción** *(argumente la respuesta o añada otra opción)*

**"Crear una venta nueva" es la difícil**: en `V-18` toda primera venta necesita autorización, y la
autorización necesita conexión. ¿Puede el cobrador dejarla preparada sin señal y que se envíe al
sincronizar?

`[Answer]:`

---

## F-40 · Con qué fecha queda un pago tomado sin señal

**Contexto**

Un cobrador registra un pago el martes a las 10 de la mañana, sin señal. Sube el martes a las 8 de la
noche. **¿De qué día es ese pago?**

El sistema guarda las dos horas: la del teléfono y la del servidor. Falta decidir cuál manda para
cada cosa.

**Pregunta**

¿Cuál es la fecha que vale?

**Opciones de respuesta**

A) **La del teléfono para todo**: el pago es del martes, para el cliente y para la caja
B) **La del teléfono para el cliente, la del servidor para la caja**
C) La del servidor para todo
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

Hay una razón para no fiarse del todo del teléfono: **la hora del móvil se puede cambiar a mano**.
Por eso el sistema guarda las dos y deja rastro. Pero para el cliente, **el pago es del día en que
pagó** — eso no se discute.

`[Answer]:`

---

## F-41 · Si el administrador y el cobrador tocan lo mismo a la vez

**Contexto**

El cobrador está sin señal registrando pagos sobre un préstamo. Al mismo tiempo, el administrador
toca ese mismo préstamo desde la web.

Por suerte, **V-33** reduce mucho el problema: *"los montos no se pueden modificar por ningún
motivo"*. Así que casi no hay choque posible. Pero quedan casos.

**Pregunta**

Si el administrador **da por perdido** un préstamo mientras el cobrador, sin señal, está registrando
un pago de ese cliente, ¿qué gana?

**Opciones de respuesta**

A) **Gana el pago**: el dinero entró de verdad, y el préstamo vuelve a activo
B) **Gana el administrador**: el pago queda apartado para que él lo revise
C) Se registran los dos y se avisa al administrador para que decida
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

`[Answer]:`

---

## F-42 · Si se bloquea el teléfono de un cobrador

**Contexto**

En **V-36** pidieron que el administrador pueda **bloquear al cobrador** — por ejemplo si se va de la
empresa o si se sospecha de él. Es una función importante.

Pero hay un caso incómodo: **ese teléfono puede tener pagos que todavía no se han subido**. Son
pagos que los clientes hicieron de verdad.

**Pregunta**

¿Qué pasa con los pagos sin subir de un teléfono bloqueado?

**Opciones de respuesta**

A) **Se pierden.** Si se bloqueó al cobrador es porque no confiamos en él
B) **Se suben igual** y entran normalmente
C) **Se suben pero quedan apartados**, y el administrador aprueba uno por uno *(recomendada)*
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

La opción **A** es la más segura frente al fraude, pero **destruye el registro de dinero que sí
entró** — y esos clientes van a reclamar que ya pagaron. La **C** es el punto medio.

`[Answer]:`

---

## F-43 · La firma del cliente

**Contexto**

En los documentos aparece "firma digital". Puede significar dos cosas muy distintas: un dibujo con el
dedo en la pantalla, o una firma con validez legal (con certificado y sello de tiempo), que es un
producto aparte y se contrata.

**Pregunta**

¿Qué tipo de firma necesitan?

**Opciones de respuesta**

A) **Un dibujo en la pantalla** que se guarda como imagen, para dejar constancia
B) **Firma con validez legal** ante un juez — indico si ya tienen proveedor
C) No usamos firma
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

En **V-29** dijeron que el negocio *"no está regulado"*. Si nunca van a llevar un préstamo a juicio,
la opción **A** es suficiente y es gratis.

`[Answer]:`

---

## F-44 · El contrato del préstamo

**Contexto**

En los documentos aparece "generar contrato". Nunca se aclaró si el sistema debe producir un
documento.

**Pregunta**

¿El sistema tiene que generar un contrato?

**Opciones de respuesta**

A) **No.** El acuerdo es verbal; basta con el registro del préstamo
B) Sí, un **documento simple** con los datos del préstamo, que el cliente firma en el móvil
C) Sí, un **contrato legal** con plantilla revisada por un abogado
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

`[Answer]:`

---

## F-45 · El seguro de repatriación

**Contexto**

Aparece nombrado en los documentos y **nunca se explicó qué es**. No sabemos si es un producto que
venden junto al préstamo, un dato que se guarda, o algo que quedó de otro proyecto.

**Pregunta**

¿Qué es y entra en el alcance?

**Opciones de respuesta**

A) **No aplica** — se coló de otro documento
B) Es un producto que vendemos junto al préstamo — lo explico abajo
C) Solo guardamos el dato de si el cliente lo tiene
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

`[Answer]:`

---

# BLOQUE 11 · Tablero e indicadores

## F-46 · Cómo se calcula cada indicador del tablero

**Contexto**

En los documentos hay **13 indicadores** para el tablero, y en **V-27** ustedes pidieron explicar
tres por teléfono: **caja inicial**, **caja actual** y **"recaudo pretendido"** —este último no
estaba en la lista original y nadie sabe cómo se calcula.

Un indicador mal definido es peor que no tenerlo: el administrador toma decisiones con un número que
no significa lo que cree.

**Pregunta**

Para los tres que más urgen, ¿cuál es la fórmula?

**Opciones de respuesta**

| Indicador | ¿Cómo se calcula? |
|---|---|
| **Caja inicial** | |
| **Caja actual** | |
| **Recaudo pretendido** | |
| **Utilidad estimada** | |

**Descripción** *(argumente la respuesta o añada otra opción)*

Ejemplo de lo que buscamos: *"recaudo pretendido = suma de las cuotas que vencen hoy en toda la
ruta, hayan pagado o no"*. Con esa frase se puede construir; con la palabra sola, no.

`[Answer]:`

---

## F-47 · Qué ve cada rol en el tablero

**Contexto**

En **V-34** pidieron búsqueda flexible y en **V-40** los periodos de comparación. Falta si todos ven
lo mismo.

**Pregunta**

¿Ven todos los mismos números?

**Opciones de respuesta**

A) El **cobrador** ve solo su ruta; el **administrador** las suyas; el **socio** todo
B) Todos ven todo
C) El cobrador no ve tablero, solo su lista de clientes
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

`[Answer]:`

---

# BLOQUE 12 · Suscripción y datos personales

## F-48 · Con qué se paga la suscripción

**Contexto**

En **V-11** quedó **dónde** se paga (en el navegador, no en la app). Falta **con qué**.

**Pregunta**

¿Cómo paga una empresa su suscripción?

**Opciones de respuesta**

A) **PIX** — el suscriptor transfiere y ustedes confirman
B) **Boleto bancario**
C) **Tarjeta con cobro automático** cada periodo
D) Transferencia bancaria normal
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

Recuerden lo de **V-06**: la mayoría de suscriptores **no son empresas formales**. Un cobro
automático con tarjeta necesita un titular identificable. **¿Quién firma la suscripción — la empresa
o una persona?**

`[Answer]:`

---

## F-49 · ¿Hay que emitir factura?

**Contexto**

Con Brasil confirmado como país (`V-01`), la nota fiscal es previsible. Nunca se respondió.

**Pregunta**

¿Hay que emitir un documento fiscal por la suscripción?

**Opciones de respuesta**

A) **Sí, nota fiscal** — y hay que integrarse con un emisor
B) Basta un **recibo simple** sin valor fiscal
C) No lo sabemos todavía
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

`[Answer]:`

---

## F-50 · Quién ve la facturación

**Contexto**

Hay dos niveles: ustedes como dueños del software, y cada empresa suscrita.

**Pregunta**

¿Qué ve cada uno?

**Opciones de respuesta**

A) Solo ustedes ven todo; la empresa suscrita no ve nada de facturación
B) La empresa suscrita ve **sus propias facturas y su historial de pagos**
C) Además puede **cambiar de plan** ella misma
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

`[Answer]:`

---

## F-51 · Cuando un cliente pide que borren sus datos

**Contexto**

La ley brasileña de protección de datos da a cualquier persona el derecho a pedir **una copia de todo
lo que se guarda sobre ella** y, en ciertos casos, **que se borre**.

Esto **no está en ningún requisito del proyecto**, y tiene una dificultad práctica: los titulares son
los **~2.000 prestatarios**, que **no son usuarios del sistema**. No tienen dónde pedirlo.

**Pregunta**

¿Cómo se atiende una petición así?

**Opciones de respuesta**

A) El cliente se lo pide **al cobrador o al administrador**, y el administrador genera el archivo
   desde el sistema *(recomendada)*
B) Se lo piden directamente a ustedes, y ustedes lo generan
C) No lo prevemos
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

Aunque hoy no lo pida nadie, **construir la exportación después es mucho más caro** que preverla
ahora. Es una pantalla que junta lo que el sistema ya tiene.

`[Answer]:`

---

## F-52 · Los sueldos y los descuentos del cobrador

**Contexto**

En **V-02** apareció algo nuevo: *"si el descuadre es del cobrador que haya sacado dinero por cuenta
de él, **se le debe descontar el día sábado del sueldo**"*.

Es la primera vez que se menciona que el sistema tenga algo que ver con los sueldos.

**Pregunta**

¿Qué debe hacer el sistema con esto?

**Opciones de respuesta**

A) **Nada.** El descuento se hace por fuera; el sistema solo deja constancia del descuadre
B) **Registrar el descuento** como un movimiento, sin gestionar sueldos
   *(punto medio: queda el rastro, sin construir una nómina)*
C) **Gestionar el sueldo completo** del cobrador: cuánto gana, qué se le descuenta, qué se le paga
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

La opción **C** es un módulo de nómina, y es mucho más trabajo del que parece. La **B** cubre lo que
de verdad necesitan —saber cuánto se le descontó y por qué— sin construir todo eso.

`[Answer]:`

---

Cuando termine, devuelva el archivo o responda con una sola palabra: **listo**
