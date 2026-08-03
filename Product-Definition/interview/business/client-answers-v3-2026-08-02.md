# Client Answers — Cuestionario v3 respondido

**Fuente**: `interview/respuestas-cuestionario-cliente-v3-REAL.docx`
**Recibido**: 2026-08-02
**Procesado**: 2026-08-02T05:45:00Z
**Método de lectura**: extracción de `word/document.xml`, detectando `w:highlight` por opción.
La opción resaltada es la respuesta; el texto libre bajo `[Answer]:` la matiza o la anula.

> ⚠️ **Nota de procedencia — importante para la trazabilidad.**
> El archivo que se señaló primero, `respuestas-cuestionario-cliente-v3.docx`, **no contenía
> respuestas**: su texto extraído es **idéntico byte a byte** al del cuestionario en blanco
> (56.147 caracteres, mismo MD5), con 0 resaltados, 0 comentarios y 0 cambios registrados. El
> archivo real apareció en `~/Downloads/cuestionario-cliente-v3.docx` — 66.866 caracteres
> (**+10.719**) y **197 resaltados**. Se copió al proyecto como
> `respuestas-cuestionario-cliente-v3-REAL.docx`. El archivo vacío se conserva sin borrar.

## Colores de resaltado

| Color | Nº | Lectura |
|---|---|---|
| `green` | 188 | Respuesta marcada |
| `white` | 5 | Marca retirada / tachada — se interpreta como **descartada** |
| `red` | 4 | Énfasis dentro del texto, no una opción |

**A diferencia de la v2, no hay dos respondientes en conflicto.** Un solo color de respuesta.

---

## Estado global — 55 preguntas (V-00 … V-54)

| Estado | Nº |
|---|---|
| **RESUELTA** | 34 |
| **PARCIAL** | 9 |
| **ABRE CONTRADICCIÓN NUEVA** | 7 |
| **SIN RESPUESTA** | 3 (V-21, V-22, V-23) |
| **DIFERIDA A LLAMADA** | 2 (V-25 el Excel, V-26/27/28) |

---

## PARTE 0 · Gobernanza

### V-00 · ¿Quién decide cuando ustedes no coinciden?
**Marcada: C** — depende del tema.
> *"si julian necesita algo, lo puede consultar con pablo o cesar, siempre va a tener respuesta de alguno de los dos"*

**PARCIAL.** No nombra un árbitro para cuando Pablo y César discrepen — que es exactamente lo que
ocurrió en la v2 (verde contra cian en C-51, C-58, C-61). Garantiza *respuesta*, no *desempate*.

---

## PARTE 1 · Los 14 choques

### V-01 · País, moneda e idioma 🔴 → **cierra `CX-11`**
**Marcada: B** — **Brasil · reales (BRL) · app en ESPAÑOL**
> *"solo en español, los suscriptores hablan español"*

**RESUELTA + ABRE `CX-32`.** Fija país, moneda e idioma. **Confirma LGPD** (ya declarada en T21) y
respalda `sa-east-1` (T11). ⚠️ Pero los **~1.200 prestatarios son brasileños** y son quienes reciben
los mensajes de WhatsApp del control antifraude. La app en español es para los **suscriptores**; los
mensajes van a los **clientes finales**. → `CX-32`.

### V-02 · Caja descuadrada 🔴 → **cierra `CX-12`**
**Marcada: X** *(la opción C aparece con resaltado `white` = descartada)*
> *"si el cobrador cierra la caja, faltando o sobrando dinero, el sistema deberá crear una alerta al
> administrador informando lo sucedido, para que al día siguiente el supervisor verifique la situación"*
> *"si es el caso de que el descuadre sea del cobrador que haya sacado dinero por cuenta de él, se le
> debe descontar el día sábado del sueldo"*

**RESUELTA + 2 HALLAZGOS.** Se puede cerrar descuadrado; genera **alerta** y verificación al día
siguiente. ⚠️ (1) Menciona **"el supervisor"**, rol que **V-04 declara inexistente** → `CX-34`.
(2) **Descuento de nómina**: función nueva (sueldos, descuentos, ciclo semanal con corte el sábado)
que no aparece en ningún requisito previo → `OQ-F-101`.

### V-03 · Pago tomado sin señal 🔴 → **cierra `CX-24` parcialmente**
**Marcada: X**
> *"el cobrador para cerrar la caja debe tener señal… si el cobrador no tiene señal por más de 24
> horas el administrador podrá forzar el cierre de caja con la información cargada hasta el momento…
> al otro día… los que no quedaron cargados deberá ingresarlos nuevamente, así ese mismo día le
> ingrese dos o más movimientos al cliente"*

**RESUELTA + RIESGO TÉCNICO.** ⚠️ **"deberá ingresarlos nuevamente"** es reintroducción manual de
operaciones ya enviadas. **Es exactamente el escenario que la idempotencia de T22 y la cola de
comandos de T14 deben absorber** — pero aquí el reingreso lo hace **una persona**, con datos tecleados
de nuevo, así que **la clave de idempotencia no coincidirá**. Sin un mecanismo de conciliación, esto
**duplica pagos**. → `OQ-F-102` (P0).

### V-04 · El supervisor 🔴 → **cierra la duda de rol**
**Marcada: B** — *"No tiene cuenta. Lo de C-31 y C-99 en realidad lo hace el administrador; nos
equivocamos al escribir 'supervisor'"*

**RESUELTA.** ⚠️ Pero V-02 y V-17 vuelven a nombrar al supervisor → `CX-34`.

### V-05 · App o web 🔴 → **CONFIRMA `D-03`**
**Marcada: B** — sí a la propuesta del equipo, ajustando la web mínima.
> *"crear y editar clientes, aprobar ventas, aprobar gastos, dar [llaves]"*

**RESUELTA.** **`D-03` deja de ser posición del equipo y pasa a ser decisión del cliente.**
La web mínima queda acotada a 4 funciones. *(El texto se corta en "dar" — presumiblemente "dar
llaves", coherente con V-18. **Confirmar.**)*

### V-06 · ⛔ WhatsApp 🔴 → **NO cierra `CX-16`: LO AGRAVA**
**Marcada: X**
> *"para tener la cuenta API se necesita una empresa registrada con documentos verificables ante
> Meta, y aquí es donde está el problema, que la mayoría de suscriptores no es empresa formal, es
> algo informal el tema de préstamo de dinero diario… con seguridad ningún usuario tendría una
> empresa registrada con documentos verificados"*

🔴 **EL HALLAZGO MÁS GRAVE DE TODO EL DISCOVERY.** No es que WhatsApp esté pendiente de trámite:
es que **los suscriptores estructuralmente no pueden obtener la cuenta**, porque no son empresas
formales. **Los dos controles antifraude de `C-99` dependen de ese canal.** → `CX-33` (P0),
supersede `CX-16`.

### V-07 · Qué recibe el cliente al pagar
**Marcada: A** — *"Sí, es exactamente eso"*. **RESUELTA.**

### V-08 · La tasa de interés 🔴 → **cierra `CX-18`**
**Marcada: C** — la pone quien hace la venta, dentro de un rango que fija el administrador.
> *"el % puede variar solo cuando se hace una venta nueva o una renovación, en ventas ya generadas NO
> se puede cambiar el interés… casi siempre es el 20% por ende debe salir como predefinido… si el
> cliente quiere pagar en 10 días entonces el cobrador puede tener la opción de modificarlo del 20%
> al 10%, al igual que la cantidad de cuotas, y el sistema debe… realizar la venta con el valor del %
> escogido y las cuotas, ejemplo préstamo de 1000 al 10% en 10 días, las cuotas quedan de 110 por 10 días"*

**RESUELTA — es la respuesta más ejecutable del cuestionario.** Fija: rango configurable por tenant,
20 % por defecto, tasa y nº de cuotas editables **solo en venta nueva o renovación**, inmutables
después (refuerza T14), y el sistema calcula la cuota. Ejemplo aritméticamente verificable.

### V-09 · Los 5.000 🔴 → **cierra `CX-19`**
**Marcada: X**
> *"cada empresa puede tener varios cobros, ejemplo JULIAN YA TIENE 10 COBROS, CADA COBRO TIENE 40
> CLIENTES"* · *"digamos que hoy podemos tener 10 empresas fijas cada una con un promedio de 5 cobros"*

**RESUELTA.** Escala real: **~10 tenants × ~5 rutas × ~40 clientes ≈ 2.000 clientes**, ~50 rutas.
**Valida el dimensionamiento de `infraestructura-aws.md`** (30–40 usuarios, 1.200 clientes) con
margen. Los "5.000" eran una aspiración de suscriptores, no una carga actual.

### V-10 · TryController 🔴 → **cierra `CX-20`**
**Marcadas: A + B** — empezar por préstamos vivos digitados a mano, y **pedir formalmente la
exportación al proveedor** antes de decidir.
**RESUELTA.**

### V-11 · Pasarela en la app 🔴 → **cierra `CX-21`**
**Marcada: A** — la app muestra factura y vencimiento; el pago se completa en el navegador.
**RESUELTA. Preserva `D-01` y evita la comisión de las tiendas.**

### V-12 · Préstamo "renovado" 🟡 → **cierra `CX-23`**
**Marcadas: A + X**
> *"SIEMPRE DEBE QUEDAR EL HISTORIAL DE LAS VENTAS PASADAS"* · *"el cliente terminó el préstamo y
> quiere renovar, debe quedar en 0 sin saldo, el cobrador envía nuevamente la venta al administrador
> y él aprueba"*

**RESUELTA.** Marca informativa + historial completo. El historial **alimenta la decisión de subir o
bajar el monto** en la siguiente venta.

### V-13 · Tablero al instante 🟡 → **cierra `CX-24`**
**Marcada: A** — al instante para lo sincronizado, avisando qué rutas faltan.
> *"¿existe la opción de que el sistema sincronice solo siempre y cuando tenga internet? … el sistema
> debe sincronizar y mandar al servidor cada que tenga internet"*

**RESUELTA + CAMBIO TÉCNICO.** El cliente pide **sincronización oportunista continua**, no una vez
al día (C-66). Compatible con la cola de comandos de T14, pero **cambia el disparador**: de manual/
diario a automático en cuanto haya red. → afecta consumo de datos (V-48).

### V-14 · GPS 🟡 → **cierra `CX-25`**
**Marcada: X**
> *"la mayoría de clientes pagan por transferencia bancaria (PIX) entonces si el cliente mandó su
> pago ya el cobrador no tiene que ir donde el cliente… en varias rutas… el cobrador va día de por
> medio"*

**RESUELTA — GPS descartado con razón de negocio.** 🔴 **Pero revela algo mayor**: si **la mayoría
cobra por PIX**, el modelo centrado en caja de efectivo (`C-50`, `D-02`) describe una minoría de las
operaciones. → `CX-35` (P0).

### V-15 · Nombre del producto 🟡
> *"aún no hemos definido"* — **SIN RESOLVER**, sigue abierta.

### V-16 · Redondeo 🟡
**Marcada: A** — cuotas iguales a 2 decimales, la última ajusta. **RESUELTA.**

### V-17 · Préstamo perdido 🟡
> *"después de que el supervisor verifique, el administrador ya tiene la potestad de dar el cliente
> por perdido o enviarlo a cartera castigada para generar un bloqueo en ese cliente y que más
> adelante no vuelva a pedir prestado"*

**RESUELTA + FUNCIÓN NUEVA.** ⚠️ Vuelve a nombrar al supervisor (`CX-34`). **"Cartera castigada" con
bloqueo del cliente** es funcionalidad nueva → `OQ-F-103`. Motivo dado: *"los cobradores son
cambiados y no conocen los clientes que dejaron de prestar"*.

### V-18 · Límites de autorización 🟡
> *"en todos los montos que sean por primera vez debe pedir autorización… una vez el administrador o
> encargado autorice el valor, el cobrador puede subir la venta"* · *"después de 5 cuotas el cobrador
> debe pedir llave para poder ingresar pagos al sistema"* · *"puede ser de 4 dígitos"*

**RESUELTA.** Regla concreta: **toda primera venta a un cliente requiere autorización**; **a partir de
la cuota 5 hace falta "llave"** para registrar pagos; **la llave es un PIN de 4 dígitos**.

### V-19 · Mensajes 🟡
**Marcada: A** — solo el extracto al cierre de caja (1/día por cliente visitado) + aviso de préstamo
nuevo. **RESUELTA — es la opción de menor costo de mensajería.**

### V-20 · Impago del suscriptor 🟡
> *"si la factura está para vencer el 30 del mes y no pagó, al día siguiente el usuario amanece
> bloqueado"* · *"5 días antes del vencimiento, un día antes y el mismo día (3 avisos)"* · *"al día 1
> no se dejan abrir las cajas de ese usuario hasta que pague"* · *"30 días para ir depurando"*

**RESUELTA.** ⚠️ Habla de **vencimiento mensual el día 30**, no semanal. **Contradice la
suscripción semanal** que se declaró en `CX-30`. → refuerza `CX-30`.

### V-21 · Planes y prueba gratis — **SIN RESPUESTA** *(sigue abierta `OQ-F-97`; relevante para `CX-30`)*
### V-22 · Metas en números — **SIN RESPUESTA**
### V-23 · Disponibilidad contra costo — **SIN RESPUESTA**

### V-24 · Quién usa la app 🟡 → **cierra `CX-22` parcialmente**
> *"solo los cobradores usan la app, el administrador por la web… los socios solo informativo"*
> *"ahora bien, si es más práctico, seguro y ligero para el administrador trabajar desde la app…
> se podría hacer también desde la app, porque si todo se hace por la app ¿qué sentido tiene la web??"*

**PARCIAL.** Fija el reparto pero **reabre la pregunta app/web**, que `V-05` acababa de cerrar.

### V-25 · 📎 El Excel del cierre de caja 🔴
> *"te lo explico por llamada"* — **EL ADJUNTO SIGUE SIN LLEGAR.** Es el segundo cuestionario
> consecutivo en que se pide y no se entrega. El documento exige un reporte *"idéntico al formato
> actual"*, y sin el archivo **no se puede construir ni verificar**.

### V-26 · V-27 · V-28 — llamada: *"puede ser hoy domingo en la noche"*

### V-29 · Contador o abogado 🔴
> *"esta modalidad de préstamo de dinero es informal, opera en todos los países pero no está regulado
> por ningún país, es algo alegal. Por eso también tenemos el inconveniente de la aplicación API"*

🔴 **RESUELTA, Y ES UNA DECLARACIÓN DE PRIMER ORDEN.** No hay asesor legal. El negocio de los
suscriptores es **informal y no regulado**, y ese es **el mismo motivo por el que no pueden obtener
la API de WhatsApp** (V-06). Une `CX-33`, `CX-38` y el alcance de T21.

### V-30 · Tope de usura 🔴
> *"QUE NO HAGA NADA, la app va a prestar un servicio, ya el uso que le dé el usuario final no nos
> incumbe a nosotros"*

**RESUELTA como decisión de producto.** El sistema **no avisa ni bloquea** al superar un tope legal.
⚠️ Registrada tal cual; tensiona con la postura ISO 27001 de T21 y con V-49 (tiendas).

### V-31 · Residencia de datos
> *"no tenemos preferencia"* — **RESUELTA.** `sa-east-1` queda fijada por LGPD (T21), no por exigencia
del cliente. **Cierra `OQ-N-25`.**

---

## PARTE 4 · Lo que nunca se preguntó

### V-32 · ¿Se registra lo que se mira? 🟡
**Marcada: X** — no ve valor en registrar consultas; son la herramienta del cobrador para recuperar
cartera. **RESUELTA: solo cambios.** *(Nota: reduce el alcance de auditoría que LGPD podría pedir.)*

### V-33 · ¿Se guarda el valor anterior? 🔴
> *"los montos no se pueden modificar por ningún motivo… la única modificación que puede tener una
> venta ya registrada es que el cobrador ingrese pagos"*

**RESUELTA — y refuerza T14 por completo.** No hay edición de montos. El *before/after* casi no
tiene objeto porque **no hay “after”**.

### V-34 · Quién consulta la auditoría 🟡
**Marcada: B** — administrador y socios. Además pide **búsqueda flexible** (por cliente, por día, por
rango de semanas, por mes). **RESUELTA.**

### V-35 · ¿Auditoría intocable? 🔴
**Marcada: A** — *"no se puede modificar, la idea es que los socios confíen en la información"*
**RESUELTA. Confirma el ledger append-only de T14 como requisito de negocio, no técnico.**
⚠️ *"inalterable incluso para el equipo técnico"* interactúa con `CX-31` (segregación de funciones).

### V-36 · Doble verificación 🔴
**Marcada: A** — obligatoria para administrador y socios, no para cobradores.
> *"el administrador pueda bloquear el usuario del cobrador… el sistema solo se pueda abrir en el
> celular asignado por la empresa, porque donde el cobrador pueda abrir el sistema desde otro celular
> él podría dar el usuario y contraseña a otras personas para que se roben los clientes"*

**RESUELTA — y confirma `CX-26` y el diseño de T17 palabra por palabra.** La vinculación de
dispositivo es requisito de negocio, con el motivo explícito: **robo de cartera**.

### V-37 · ¿Clave todos los días? 🟡
**Marcada: D** — conectado siempre, con huella o PIN corto.
**RESUELTA — coincide exactamente con el diseño de sesión de T17.**

### V-38 · Recuperación de clave 🟡
**Marcada: A** — el administrador la restablece desde la web.
**RESUELTA.** ⚠️ **SES ya no se justifica por recuperación de contraseña** — pero sigue justificada
por la facturación de la suscripción (T11).

### V-39 · Reportes en la primera entrega 🟡
> *"reporte diario"* — **PARCIAL**, de los 9 solo nombra uno.

### V-40 · Comparativos ⚪
**Marcadas: D + X** — contra meta, y además día anterior, semana pasada, mes, trimestre, semestre.
**RESUELTA.**

### V-41 · Fotos de cada venta 🟡 → **cierra la retención de `OQ-T-13`**
> *"solo 5 archivos… si o sí debe ir documento de identificación, comprobante de residencia, y las
> otras tres pueden ser del comercio"* · *"estas fotos se pueden borrar una vez se renueve el cliente
> y comience con el nuevo préstamo"* · *"sí se pueden borrar"*

**RESUELTA.** Máximo **5 archivos**, 2 obligatorios. **Política de retención: borrables al renovar.**
**Cierra el último hueco de `OQ-T-13`** y encaja con el diseño S3 + referencia y hash de T14.

### V-42 · Alertas automáticas 🟡
**Las 7 marcadas** (sin sincronizar, caja sin cerrar, cierre descuadrado, fallo de WhatsApp, muchos
"no pago" seguidos, intentos de clave fallidos, reclamo de cliente). **Canal: WhatsApp.**
⚠️ **Contradice `CX-29`** (Telegram para administradores) **y `CX-33`** (WhatsApp puede no existir).
→ `CX-37`.

### V-43 · Disponibilidad 🔴
> *"menos de una hora pero que no sea repetitivo"* · *"después de una hora"*
**RESUELTA — RTO objetivo < 1 hora.**

### V-44 · Ventana de mantenimiento 🟡
**Marcada: B** — domingos. **RESUELTA**, coherente con C-12.

### V-45 · Soporte 🟡
> *"siempre va a tener un canal de atención por parte de nosotros 24/7"* · *"nosotros vendemos una
> suscripción a un nuevo usuario, ese usuario debe delegar a un administrador, que es con quien
> nosotros nos vamos a entender"*

**RESUELTA en el modelo, IMPOSIBLE en la capacidad.** ⚠️ **Soporte 24/7 con equipo de una persona
(`CX-27`)** → `CX-36`.

### V-46 · Pantallas instantáneas 🟡
**Las 7 marcadas.** *(Marcar todas equivale a no priorizar.)*

### V-47 · Umbrales de espera 🟡 → **cierra `OQ-N-44` parcialmente**
> *"debe ser instantánea principalmente para los cobradores… necesitamos velocidad en todo el
> sistema"* · *"menos de un minuto"* (reportes)

**PARCIAL.** Da un objetivo para reportes (**< 1 min**) pero *"instantáneo"* no es medible.
**k6 sigue sin poder ejecutarse** hasta fijar un número para la operación del cobrador.

### V-48 · Datos y espacio 🟡
> *"normalmente se pagan 30 reales de recarga, esto pueden ser más o menos 10 GB por mes"* · *"la
> mayoría de cobradores tiene wifi en su casa, pero no todos"*

**RESUELTA.** **Presupuesto de datos: ~10 GB/mes por cobrador.** Holgado frente a los ~2 GB
estimados — **pero la sincronización continua de V-13 lo consume más rápido.**

### V-49 · Tiendas 🔴
**Marcada: A** — publicar normalmente, presentándola como herramienta de gestión interna.
> *"esta app también puede ser direccionada al sector de tiendas… ¿para estos temas legales la
> podríamos enfocar así?"*

**RESUELTA con reserva.** ⚠️ Presentar ante las tiendas una app de préstamos como otra cosa es un
riesgo de rechazo o retirada. Combinado con V-29 (*"alegal"*) y V-30 (sin tope de usura), merece
revisión explícita → `OQ-N-48`.

### V-50 · Guía de uso 🟡
**Marcada: B** — guía rápida la primera vez. **RESUELTA.**

### V-51 · Alta de empresa nueva 🟡
**Marcada: B** — autoservicio: la empresa se registra sola, paga y empieza.
> *"si después del plan piloto todo marcha como lo planeamos, ya debe ser autónomo"*

**RESUELTA.** ⚠️ Tensiona con V-45 (administrador delegado) y con V-06 (empresas informales que no
pueden verificarse). → `OQ-F-104`.

### V-52 · Instancia separada 🟡
> *"podría ser, aumentaría los costos, aunque no creo que se vea el caso"* — **RESUELTA: no en v1.**

### V-53 · Certificaciones 🟡
**Marcada: A** — *"No lo prevemos; nuestros clientes son empresas pequeñas"*
⚠️ **CONTRADICE la declaración de ISO 27001 de T21** → `CX-38`. Refuerza que la respuesta correcta a
`OQ-N-46` es **"alineado, no certificado"**.

### V-54 · Tarjetas 🔴
**Marcada: C** — *"No entiendo bien las implicaciones — explíquenmelo"*
**SIN RESOLVER.** `OQ-N-42` (alcance PCI-DSS) sigue abierta. **Requiere explicación en la llamada.**
