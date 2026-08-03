# Client Answers — Cuestionario v2 respondido por los interesados

**Fuente**: `interview/respuesta-cuestionario-cliente.docx`
**Recibido**: 2026-08-01
**Procesado**: 2026-08-01T15:27:21Z
**Método de lectura**: extracción de `word/document.xml`, detectando `w:highlight` (marcador)
por opción. La opción marcada es la respuesta; el texto libre bajo `SU RESPUESTA:` la matiza
o la anula.

## Nota sobre los dos colores de resaltado

Se detectaron **dos colores**, lo que sugiere **dos personas** respondiendo:

| Color | Nº de marcas | Dónde |
|---|---|---|
| `green` | 191 | Todo el documento |
| `cyan` | 8 | Solo C-44, C-51, C-53, C-54, C-58, C-61, C-63, C-64 — bloques 5, 6 y 7 (caja y autorizaciones) |

Las 8 marcas en cian caen todas en el terreno de **caja, descuadre y autorizaciones**, y en
tres casos **contradicen la opción marcada en verde de la misma pregunta** (ver `CX-12`).
Ambas se registran como válidas; la contradicción se resuelve en sesión. Esto es coherente
con C-116, donde el interesado escribe *"lo tendríamos que definir entre los tres"*.

---

## Estado global

| Estado | Nº | Significado |
|---|---|---|
| **RESUELTA** | 78 | Opción marcada, sin ambigüedad, sin contradicción con otra respuesta |
| **PARCIAL** | 21 | Contestada pero incompleta: falta un dato que la vuelve ejecutable |
| **CONTRADICE** | 14 | Choca con otra respuesta del mismo documento o con D-01 |
| **NO SÉ** | 4 | El interesado declara desconocimiento (C-93, C-94, C-95, C-98) |
| **SIN RESPUESTA** | 3 | C-01, y los adjuntos prometidos de C-57 y C-64 |
| **DIFERIDA A LLAMADA** | 3 | C-49, C-82, C-91 — el interesado pide explicarlo hablando |

---

## Bloque 0 · Lo esencial

| ID | Marcada | Respuesta registrada | Estado |
|---|---|---|---|
| **C-01** | — | *(sin responder)* — el producto sigue sin nombre | **SIN RESPUESTA** |
| **C-02** | **B** | Un país por ahora + expansión a México, Ecuador, Argentina, Uruguay, Chile, Perú, Bolivia. **No dice cuál es el país actual, ni la moneda, ni el idioma.** Evidencia indirecta de Brasil: PIX (C-23/C-24) y *"usted abonó 50 **reales**"* (C-25). Brasil **no** aparece en la lista de expansión. | **PARCIAL** → `CX-11` |
| **C-03** | **B** | Solo para su empresa por ahora; quiere venderlo **en ~1 año** | RESUELTA |
| **C-04** | **B** | Cobro **por ruta o unidad de cobro activa** | RESUELTA |
| **C-05** | texto | *"esto depende… tomando como ejemplo brasil hay muchos cobros, y la idea es llegarle a todos esos suscriptores, entonces hagamos la app pensando en los 5000"* — **no aclara si 5.000 son empresas suscriptoras o clientes finales**; la diferencia es de dos órdenes de magnitud | **PARCIAL** → `CX-19` |
| **C-06** | texto | *"siempre ha sido digital"* — no hay línea base de esfuerzo manual que mejorar | PARCIAL |
| **C-07** | texto | *"por la cantidad de suscriptores"* — no hay métricas de éxito medibles | PARCIAL |
| **C-08** | **A** | Reemplaza a TryController por completo y hay que **migrar TODO el histórico**. Adicional: **TryController NO permite exportar** los datos | **CONTRADICE** → `CX-20` |
| **C-09** | **B** | Fecha deseable pero flexible; no se indica cuál | PARCIAL |

## Bloque 1 · Las cuentas: intereses y cuotas

| ID | Marcada | Respuesta registrada | Estado |
|---|---|---|---|
| **C-10** | **A** | **Interés fijo sobre el monto prestado.** Texto: *"el interés puede variar, pero siempre será fijo sobre el valor prestado"*. **Ejemplo numérico dado**: presté **1.000**, a **24** cuotas, frecuencia **diaria**, pagó **1.200** en total, en cuotas de **50** → 20% fijo, 24 × 50 = 1.200 ✔ aritméticamente consistente | RESUELTA (fórmula) |
| **C-11** | **A** | El administrador fija **una tasa para toda la empresa y nadie la cambia** | **CONTRADICE** C-10 → `CX-18` |
| **C-12** | **B** | Lunes a sábado; domingos y festivos no se cobra. Adicional: **se corre al día siguiente**, el cliente solo paga una cuota (no se acumulan) | RESUELTA |
| **C-13** | texto | **"LA MODALIDAD LIBRE NO APLICA"** → se elimina del catálogo de frecuencias | RESUELTA — cierra `CX-7` |
| **C-14** | **A** | **No hay interés ni recargo por mora.** La deuda no crece por atraso | RESUELTA |
| **C-15** | **B** | Mora a partir de **3 días** sin pagar. Adicional (cartera castigada): *"a partir de que el cliente no se pueda ubicar"* — **no es un criterio automatizable** | PARCIAL |
| **C-16** | **A** | Solo el interés; sin comisiones, seguros ni papelería. Adicional: no | RESUELTA |
| **C-17** | texto | *"en el trycontroller esto no afecta, si quedan decimales se pone el valor con decimales"* — **no define regla de redondeo**; con BRL (2 decimales) una cuota de 57,142857 sigue sin ser cobrable | **PARCIAL** → sigue abierta |

## Bloque 2 · Cuando el cliente paga

| ID | Marcada | Respuesta registrada | Estado |
|---|---|---|---|
| **C-18** | **X** | **Se recibe el pago parcial.** El cobrador teclea el monto recibido y se descuenta del total. **El contador de cuotas es fraccionario**: si la cuota es 50 y recibe 25, se registra **0,5 cuota** y quedan **19,5 cuotas** de 20 | RESUELTA — regla clave |
| **C-19** | **D** | No se separa interés de capital: **la cuota es una sola cosa**. Coherente con C-10 y C-14 | RESUELTA |
| **C-20** | **A** | El abono grande **adelanta cuotas**; el préstamo termina antes | RESUELTA |
| **C-21** | **A** | **No hay descuento por pago anticipado** | RESUELTA |
| **C-22** | **A** | El cobrador corrige él mismo, **solo el mismo día y antes de cerrar caja**. Adicional: **no** se avisa la anulación, porque **al cierre de caja el sistema manda automáticamente a cada cliente su extracto de deuda** | RESUELTA |
| **C-23** | **A** | ⚠️ Marcó A (manual simple) pero el texto describe otra cosa: el registro tiene **dos medios — DINERO o TRANSFERENCIA BANCARIA**; DINERO se registra **automáticamente sin que el cobrador lo seleccione**; TRANSFERENCIA (PIX) exige **comprobante adjunto + nombre del titular** (puede diferir del cliente) → esto es la opción **B**, no la A | **CONTRADICE** → `CX-17` |
| **C-24** | **A + B** | Dos opciones marcadas; el texto las reconcilia: *"el pix es la misma transferencia bancaria"* → medios = **efectivo + transferencia (PIX)** | RESUELTA |
| **C-25** | **D** | ⚠️ Marcó D (*"nada, con que quede registrado basta"*) pero el texto pide un mensaje: *"su pago fue recibido, usted abonó 50 reales y quedó con 15 cuotas pendientes de 20, total deuda 700"*, y lo mismo si no paga, recordándole la mora → es la opción **A**. Adicional: **sin validez fiscal**, solo informativo y de control | **CONTRADICE** → `CX-17` |
| **C-26** | **B** | Motivo de una lista **+ comentario libre del cobrador** con el compromiso de fecha. Ese compromiso se le reenvía al cliente **en el mensaje de cierre de caja**, junto con la mora y el saldo | RESUELTA |

## Bloque 3 · La vida del préstamo

| ID | Marcada | Respuesta registrada | Estado |
|---|---|---|---|
| **C-27** | **A** | La lista de estados está completa: temporal, activo, en mora, castigado, cancelado, renovado, refinanciado | **CONTRADICE** C-32 (elimina "temporal") y C-28 (elimina "renovado" tal como está definido) |
| **C-28** | **X** | **El cliente debe pagar el 100% de la deuda para poder renovar.** El sistema **bloquea** y no deja enviar la venta si hay saldo pendiente. Adicional: *"todos los clientes deben pagar el 100% de la deuda para renovar"* | RESUELTA — pero ver `CX-23` |
| **C-29** | **A** | Refinanciar = reestructurar sin entregar plata nueva. **El interés se recalcula sobre el saldo que debe** y **el cliente arranca en 0, sin atraso**, para pagar ese saldo | RESUELTA |
| **C-30** | **A** | Cancelación anticipada: **paga el total pactado**, no se rebaja interés | RESUELTA |
| **C-31** | **C** | Hay estudio real, en 4 pasos: (1) el cobrador crea el cliente y recoge los documentos exigidos; (2) informa al **supervisor**, que **autoriza el valor**; (3) el cobrador sube la venta al sistema con los documentos; (4) el **administrador aprueba** la venta. Al aprobarse, **llega un QR al WhatsApp que el cliente registró**; el cobrador lo **escanea para liberar el dinero** | RESUELTA — pero ver `CX-14` |
| **C-32** | texto | **"No debe haber ventas temporales"** — el flujo es el de C-31 | RESUELTA |
| **C-33** | **A** | Baja manual, decidida por el administrador uno por uno. Adicional: **la deuda se congela**; en ningún caso aumenta, solo se cobra lo pactado desde el inicio | RESUELTA |
| **C-34** | **A** | ⚠️ Marcó A (mismo día y sin movimientos) pero el texto dice *"se puede modificar así hayan pasado días, pero sin que se hayan registrado pagos"* → la restricción real es **"sin pagos"**, no **"mismo día"**. Adicional: si ya tiene pagos, **los valores no se tocan**; solo se corrigen **datos personales**, y **solo el administrador** | **CONTRADICE** (aclarado por el texto) |
| **C-35** | **A** | **No hay contrato escrito**; el registro en el sistema basta | RESUELTA |

## Bloque 4 · Tu equipo y tu estructura

| ID | Marcada | Respuesta registrada | Estado |
|---|---|---|---|
| **C-36** | **A** | Tres roles. **Administrador** (*"como la secretaria"*): aprueba ventas y gastos; **tiene todos los dominios**. **Socio**: inversionista, pueden ser uno o varios; **solo extrae información del estado del cobro**, no modifica nada ni aprueba ventas. **Cobrador**: uno por ruta; registra pagos (única acción que **no** requiere aprobación), sube documentos de ventas y gastos para que el administrador los apruebe, y ve su panel de caja, clientes y cuotas pendientes | RESUELTA — cierra `CX-6` |
| **C-37** | **A** | **Una ruta = un cobrador = un celular** | RESUELTA |
| **C-38** | **A** | El cliente pertenece a la ruta donde se creó. Adicional: **se puede trasladar si el administrador lo aprueba**, siempre que el cliente esté pagando bien, y por motivos de ubicación geográfica | RESUELTA |
| **C-39** | **B** | Sí hay supervisores, pero *"**no tienen acceso al sistema**; solo cuando llegan donde el cobrador cogen el celular y revisan todos los clientes para constatar que todo está bien"* | **CONTRADICE** C-31, C-61 y C-99 → `CX-14` |
| **C-40** | **B** | Los socios entran a ver el tablero pero no modifican nada. Adicional: **ven todo, pero solo de su misma sociedad** | RESUELTA |
| **C-41** | texto | Seguro de repatriación: *"sería muy bueno pero tendríamos que evaluar los costos adicionales y cómo funciona"* — **no decidido** | PARCIAL |

## Bloque 5 · Los clientes

| ID | Marcada | Respuesta registrada | Estado |
|---|---|---|---|
| **C-42** | **X** | Obligatorios: **foto del documento de identidad**, **recibo de energía u otro comprobante de dirección**, **fotos del comercio**, y **celular con WhatsApp** | RESUELTA |
| **C-43** | **B** | Se permite el mismo cliente en dos rutas, avisando. Adicional: **sí puede tener dos préstamos activos en la misma ruta, si el administrador lo aprueba** | RESUELTA |
| **C-44** | **A** `cyan` | 5 fotos está bien, y el desglose cuadra exacto: **1 documento + 1 comprobante de residencia + 3 del comercio**. Son **fijas por cliente** (no por venta) y **al actualizarlas el sistema borra o reemplaza automáticamente las antiguas**. Borra **solo el administrador** o el sistema. Se conservan **mientras el cliente esté en el sistema** | RESUELTA — cierra `CX-9` |
| **C-45** | **A + C** | GPS para **guardar dónde vive y trabaja** el cliente **y para armar la ruta del día en orden geográfico**. **No marcó B** (verificar que el cobrador estuvo allí) | RESUELTA — ver `CX-25` |
| **C-46** | **A** | Las referencias solo sirven para ubicar al cliente; **nadie las contacta desde el sistema** | RESUELTA |
| **C-47** | **A** | **El cliente no se borra nunca**; se desactiva y el historial permanece | RESUELTA |
| **C-48** | **A** | No se consulta buró ni central de riesgo | RESUELTA |

## Bloque 6 · El dinero: cajas y cierre

| ID | Marcada | Respuesta registrada | Estado |
|---|---|---|---|
| **C-49** | **B** | *"Prefiero explicarlo en una llamada o reunión"* | **DIFERIDA A LLAMADA** |
| **C-50** | **A** | La caja **solo se cierra cuando todos los clientes fueron visitados**. Debe tener **3 paneles: CLIENTES PENDIENTES · CLIENTES QUE PAGARON · CLIENTES QUE NO PAGARON**, y solo se puede cerrar con **pendientes = 0**. Adicional: **solo el administrador abre** la caja; **el cobrador la cierra**; si el cobrador no la cierra, **el administrador puede cerrarla** | RESUELTA |
| **C-51** | **B** `green` / texto `cyan` | ⚠️ Marcó B (*dejar cerrar y registrar el faltante como deuda del cobrador*), pero la respuesta en cian dice lo contrario: *"**no puede faltar ni sobrar**; si sobra es porque no le metió pago a algún cliente y si falta es porque le metió de más a algún cliente"* → eso es la opción **A** (no dejar cerrar hasta cuadrar). **Sin tolerancia declarada** | **CONTRADICE** → `CX-12` |
| **C-52** | **D** | El efectivo **no se consigna**: el cobrador lo usa para **renovaciones (préstamos nuevos), gasolina y el pago de sueldos del sábado**. Adicional: **la entrega debe quedar confirmada por ambas partes** | RESUELTA |
| **C-53** | **A + B + C** | Cascada de fondeo: (1) primero **el efectivo que él mismo recaudó**; (2) si no alcanza, **el administrador le envía de su propia caja** (lo recaudado por transferencias/PIX); (3) si tampoco hay, el administrador **envía el valor restante** y el cobrador **registra un ingreso a caja**. Adicional `cyan`: **NO** se le impide registrar el préstamo aunque no tenga efectivo | RESUELTA — ver `CX-12` |
| **C-54** | **X** | El cobrador **sube los gastos igual que las ventas, con soportes**, y el administrador **los aprueba**. Categorías fijas `cyan`: **gasolina, aceite, sueldo cobrador, sueldo supervisor, viáticos, comisión por cliente nuevo, otros**. **Factura obligatoria en todos los casos** | RESUELTA |
| **C-55** | texto | **"Dinero pendiente no aplicaría"** → el campo se elimina del cierre de caja | RESUELTA |
| **C-56** | **A** | Un cierre **por cobrador**, más uno **consolidado de toda la empresa** | RESUELTA |
| **C-57** | **A** | *"Sí, lo adjunto"* — **pero el Excel no venía adjunto** al documento recibido | **SIN RESPUESTA** (pendiente el archivo) |
| **C-58** | **X** `cyan` | *"No se puede corregir, porque una vez el cobrador cierra caja es porque está seguro de que todo está cuadrado"* → **el cierre es irreversible** | RESUELTA — refuerza `CX-12` |

## Bloque 7 · Autorizaciones

| ID | Marcada | Respuesta registrada | Estado |
|---|---|---|---|
| **C-59** | **A + B** | Requieren autorización: **préstamos por encima del monto límite** y **recibir más de X cuotas adelantadas**. Nada más | RESUELTA |
| **C-60** | **X** | El código *"sirve solo para ese cliente específico durante el día, antes de cerrar la caja"*. Adicional: **no se puede reutilizar** | RESUELTA |
| **C-61** | **A** | **Solo el administrador principal** da códigos. Adicional `cyan`: **no existe un tope que el administrador no pueda aprobar solo** | **CONTRADICE** C-31 (allí es el *supervisor* quien autoriza el valor) → `CX-14` |
| **C-62** | **A** | Sin señal **no puede hacer la operación**; que espere a tener señal | RESUELTA |
| **C-63** | **B** `cyan` | **Solo la llave automática** (pedir desde la app, aprobar desde la web) | RESUELTA — cierra `CX-10` |
| **C-64** | **A** `cyan` | **Un límite único para toda la empresa**. Los valores de referencia **no se dieron** | PARCIAL |

## Bloque 8 · La calle: cobranza y trabajo sin señal

| ID | Marcada | Respuesta registrada | Estado |
|---|---|---|---|
| **C-65** | **A+B+C+F** | Sin señal el cobrador puede: **ver su lista del día**, **registrar pagos en efectivo**, **registrar "no pago" y visitas**, y **registrar un pago por PIX**. **No** puede: tomar fotos, recoger firma, ni crear un préstamo nuevo | RESUELTA |
| **C-66** | **A** | Debe **sincronizar al menos una vez al día** o se bloquea | RESUELTA |
| **C-67** | **X** | *"La fecha debe ser apenas el celular tenga señal y sincronice"* → el pago se fecha **al sincronizar**, no al registrarse | **CONTRADICE** C-50, C-51, C-22 y C-58 → `CX-13` |
| **C-68** | **X** | *"El administrador solo puede cancelar ventas si el cobrador se lo pide, y en ese caso el cobrador ya no le puede poner pago"* → el conflicto se previene por procedimiento, no se resuelve técnicamente | PARCIAL |
| **C-69** | **A** | **Sincronización automática**; se elimina la descarga manual de la UGI | RESUELTA — cierra `CX-4` |
| **C-70** | **A** | **Un solo celular por ruta** | RESUELTA |
| **C-71** | **A** | El sistema **debe advertir antes de desvincular** si hay movimientos sin sincronizar. Adicional: **sí, borrar la información del celular** al desvincular | RESUELTA |
| **C-72** | **X** | *"Una vez se haga la venta, al cliente le llega el QR donde el funcionario deberá escanear para liberar el dinero. Eso sería la firma digital"* → **no hay firma dibujada ni certificada**; el QR la sustituye | RESUELTA |
| **C-73** | **B + C** | Sí: **ordenar las visitas por cercanía** y **mostrar el mapa con todos sus clientes** | RESUELTA — cierra `CX-5` |
| **C-74** | **A + B + C** | ⚠️ Las tres opciones marcadas se excluyen entre sí: A dice *"solo los cobradores"*, B añade al administrador y C a los socios. Lectura razonable: **los tres perfiles usan la app móvil** | **CONTRADICE** → `CX-22` |

## Bloque 9 · WhatsApp y avisos

| ID | Marcada | Respuesta registrada | Estado |
|---|---|---|---|
| **C-75** | **B** | Tiene **WhatsApp Business normal (la app), no la API** | **CONTRADICE** todo el modelo de mensajería automática → `CX-16` |
| **C-76** | **B** | *"Prefiero que ustedes los propongan y yo los apruebo"* | RESUELTA |
| **C-77** | **B** | El cobrador pregunta el permiso y **lo marca en la app al crear el cliente**. Adicional: **el administrador puede desactivar los mensajes** para un cliente | RESUELTA |
| **C-78** | **A+B+C** | Indispensables: **al registrar un préstamo nuevo**, **cada vez que el cliente paga**, y **cuando no paga**. Adicional: *"se podría estudiar si por semana, ya que lo ideal es tener un control de los cobradores"* | PARCIAL (frecuencia sin cerrar) |
| **C-79** | **A** | Si el mensaje falla, **solo se registra como fallido** | RESUELTA |
| **C-80** | **C** | Las respuestas **llegan al cobrador asignado**; *"cada cliente debe estar asociado al número de la ruta"* | RESUELTA |
| **C-81** | **X** | El reporte a socios sale **al día siguiente, antes de abrir la caja**. El administrador **elige a qué socios** enviárselo, y **puede ser semanal** | RESUELTA |

## Bloque 10 · Reportes y tablero

| ID | Marcada | Respuesta registrada | Estado |
|---|---|---|---|
| **C-82** | **B** | *"Prefiero explicarlo en una reunión mirando el Excel actual"*. **Los 3 números de la mañana: caja inicial, caja actual, recaudo pretendido** — *"recaudo pretendido"* es un indicador nuevo, no está en la lista de 13 del documento y no está definido | **DIFERIDA A LLAMADA** |
| **C-83** | **A** | Tablero **al instante**: si el cobrador registra un pago, quiere verlo ya | **CONTRADICE** C-66 (sync 1×día) → `CX-24` |
| **C-84** | **A** | Administrador ve todo; socio todo **menos gastos internos**; cobrador **solo lo suyo** | RESUELTA |
| **C-85** | **B** | *"Todos son indispensables"* + *"podríamos analizar los más importantes"* — las dos frases se anulan | PARCIAL |
| **C-86** | **A** | **Solo registro ordenado de entradas y salidas.** No es contabilidad formal de partida doble | RESUELTA |

## Bloque 11 · Inteligencia artificial

| ID | Marcada | Respuesta registrada | Estado |
|---|---|---|---|
| **C-87** | **B** | La IA va en **segunda etapa**; primero que la operación funcione | RESUELTA |
| **C-88** | **A** | **Solo responde preguntas**, no modifica nada | RESUELTA |
| **C-89** | **A** | **Exactitud total**: las cifras siempre salen de la base de datos | RESUELTA |
| **C-90** | **A** | Sí a un proveedor externo **serio que no entrene con sus datos** | RESUELTA |
| **C-91** | **B + C** | Acceso: administrador, socios, **y cobradores solo sobre sus propios clientes**. Sobre detección de fraude: *"se responde por llamada"* | **DIFERIDA A LLAMADA** (parte de fraude) |

## Bloque 12 · Automatizaciones

| ID | Marcada | Respuesta registrada | Estado |
|---|---|---|---|
| **C-92** | **C** | **Reglas fijas al principio, configurables más adelante** | RESUELTA |

## Bloque 13 · Lo legal y lo delicado

| ID | Marcada | Respuesta registrada | Estado |
|---|---|---|---|
| **C-93** | **D** | **No sabe** si prestar dinero requiere licencia en su país | **NO SÉ** |
| **C-94** | **D** | **No sabe** si existe tope legal de interés (usura) | **NO SÉ** |
| **C-95** | **D** | **No sabe** qué ley de protección de datos aplica | **NO SÉ** |
| **C-96** | **B** | Sí hay obligación de reportar operaciones sospechosas, pero **el reporte lo arma él por fuera**; el sistema solo debe darle los datos | RESUELTA |
| **C-97** | **X** | Se conserva **el registro del cliente y su historial de pagos**; **las fotos y comprobantes se pueden borrar si el cliente lleva 12 meses inactivo** | RESUELTA |
| **C-98** | **C** | **No sabe** si hay exigencia de residencia de datos en el país | **NO SÉ** |
| **C-99** | **F** | Los dos fraudes reales, con el control que quiere para cada uno: **(1)** el cobrador manda una venta y **no le entrega el dinero al cliente** → control: **QR al WhatsApp del cliente**, que el cobrador escanea, y así **le llega al administrador que la venta fue verdadera**; **(2)** el cobrador **recibe el pago y no lo ingresa al sistema** → control: **al cierre de caja le llega un mensaje al cliente** diciendo si pagó o no y el saldo pendiente, y si el valor no cuadra, **el cliente puede avisarle al supervisor** | RESUELTA — es el corazón del producto |

## Bloque 14 · Tamaño y expectativas

| ID | Marcada | Respuesta registrada | Estado |
|---|---|---|---|
| **C-100** | **X** | *"Queremos ser la APP Nº1 en toda Sudamérica y Centroamérica para ayudar a las personas a tener mayor control de sus funcionarios"* — **sin cifras de crecimiento** | PARCIAL |
| **C-101** | **X** | **35% de uso por la mañana, 65% entre las 14:00 y las 21:00** | RESUELTA |
| **C-102** | **X** | *"Si se cae no es un daño grave, pero se pierde credibilidad"*. **Ventana en la que no se puede caer: de 14:00 hasta el cierre de caja, que puede ser las 23:00** — y advierte que **la proyección es multi-país con husos horarios distintos** | PARCIAL → tensión con C-105 |
| **C-103** | **C** | Aceptable perder hasta 1 hora de datos **si pasa muy rara vez** | RESUELTA |
| **C-104** | **A** | **La empresa da el celular**: Samsung de gama media (*"con TryController algunos celulares no son compatibles"*). **Los datos móviles los paga la empresa**; la señal varía por ciudad y operador | RESUELTA |
| **C-105** | **B** | Lo más económico posible: *"los costos no deben superar lo que tenemos proyectado cobrar por cada suscriptor"* | PARCIAL (no hay cifra) |
| **C-106** | **C** | Habilidad tecnológica del equipo: **hay de todo, desde muy hábiles hasta muy básicos** | RESUELTA |

## Bloque 15 · Prioridades

| ID | Marcada | Respuesta registrada | Estado |
|---|---|---|---|
| **C-107** | **X** | *"Creo que todo tiene que ir paulatinamente: primero crear la base, que sería **la app**; hacer pruebas; luego integrar la seguridad de fraude, que va muy ligada con la IA y con el WhatsApp"* | **CONTRADICE** C-108 → `CX-15` |
| **C-108** | **B + C + D** | Pueden esperar: **la IA**, **la app móvil (arrancar por la web)** y **los reportes avanzados** | **CONTRADICE** C-107 y C-87 (parcialmente) → `CX-15` |
| **C-109** | **X** | *"No necesitamos sacrificar nada; debemos definir tiempos y hacer el proyecto por etapas. No es lógico que el proyecto salga al 100%; eso lo tendríamos que definir con usted, que tiene el conocimiento"* | RESUELTA (delega la priorización) |
| **C-110** | **B + E** | Lo que más le preocupa: **que las cuentas no cuadren y perder plata en la transición**, y **que se caiga en un momento crítico** | RESUELTA |
| **C-111** | **A** | Arranque con **una sola ruta piloto** primero | RESUELTA |

## Bloque 16 · Cobro del software

| ID | Marcada | Respuesta registrada | Estado |
|---|---|---|---|
| **C-112** | **X** | Secuencia en tres tiempos: (1) usar la app **en sus propios cobros** para verificar el funcionamiento; (2) con esos mismos cobros, **piloto de compra de paquetes desde la web**; (3) ya con todo funcionando, **comercializar a otros usuarios** | RESUELTA — es la hoja de ruta comercial |
| **C-113** | **C** | Autoservicio para pequeños + factura manual para grandes. Texto: **el cliente debe tener clara su fecha de vencimiento**; si la factura se vence, **el sistema bloquea automáticamente al suscriptor y todas las rutas que dependan de él**. Y añade: *"también sería bueno que **desde la misma app** se pueda integrar la pasarela de pagos, así el suscriptor pueda hacer todo desde la app"* | **CONTRADICE** D-01 → `CX-21` |
| **C-114** | **B** | Avisar y **suspender todo, incluida la app de los cobradores**. **Días de gracia y retención de datos: sin responder** | PARCIAL |
| **C-115** | **C** | **El sistema debe emitir la factura / nota fiscal** por sí solo | PARCIAL — bloqueada por `CX-11` (no se sabe el país) |
| **C-116** | **D** | No lo ha pensado. *"Lo tendríamos que definir entre los tres; puede ser que el primer mes se le cobre un 50% del valor del plan"* | PARCIAL |
| **C-117** | **B** | Él ve la facturación, **y cada empresa cliente ve sus propias facturas y su estado de cuenta** | RESUELTA |
