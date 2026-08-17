# Prompt maestro — Demo móvil, app del gestor de cobranza (Claude Design)

> **Uso**: copiar el bloque completo de abajo y pegarlo en Claude Design. Es autocontenido: no
> asume acceso al repositorio.
>
> **Estado**: sidecar. No forma parte del handoff de AI-DLC y **no cierra ninguna pregunta abierta**
> del discovery. Complementa a `claude-design-master-prompt.md` (web del administrador).
> Generado el 2026-08-08 a partir de `vision-document.md`, `technical-environment.md` y los lotes
> `D-02`, `D-03`, `D-05`, `V-xx` y `B-xx`.

---

## PROMPT (copiar desde aquí)

Necesito un **prototipo móvil clickeable** de una aplicación de campo. Es un **demo para enseñar a
un cliente el flujo del producto**, no código de producción y no una app funcional. Todo el estado
es simulado en el navegador; no hay backend, no hay red, no hay persistencia real.

Preséntalo dentro de un **marco de teléfono**, en vertical, tamaño de un Android de gama media
(360 × 800 aprox.).

---

### 1. Qué es el producto y quién usa esta app

Es la app de campo de un **SaaS de gestión de préstamos y cobranza en calle** para financieras
pequeñas en **Brasil**. Moneda **real brasileño (BRL)**, **interfaz en español**, zona horaria
`America/Sao_Paulo`.

**El usuario de esta app es el gestor de cobranza (el cobrador).** Recorre una ruta a pie o en moto,
**de lunes a sábado**, visitando entre 30 y 50 clientes al día, cobrando cuotas pequeñas en efectivo
puerta a puerta. Trabaja **solo, sin supervisión, y buena parte de la mañana sin señal de móvil**.
Su habilidad tecnológica es variable: algunos son muy hábiles, otros muy básicos. Diseña para el
más básico.

**El producto no es un CRM de cobranza: es un sistema antifraude.** Y el fraude que combate lo
comete precisamente la persona que usa esta app. Eso no debe hacerla hostil ni policial —debe
hacerla **incontestable**: cada acción deja evidencia que otro puede verificar. Los dos controles:

| Fraude | Control, tal como lo vive el gestor en la app |
|---|---|
| Manda una venta y **no le entrega el dinero al cliente** | Al aprobarse la venta, **al cliente le llega un QR por WhatsApp**. El gestor debe **escanearlo delante del cliente** para que se libere el efectivo. Sin escaneo no hay desembolso |
| **Cobra y no registra** el pago | **Al cerrar caja, cada cliente recibe su extracto por WhatsApp** con lo que pagó y su saldo. Si no cuadra, el cliente reclama |

Reglas duras que el prototipo no puede contradecir:

- **El sistema nunca custodia dinero.** No recibe, no retiene, no transfiere. Efectivo y PIX se
  **registran como información**. Nunca un botón de "transferir", "pagar" o "retirar".
- **Lo registrado no se edita.** Los montos de una venta no se modifican por ningún motivo. La
  única corrección posible es la del **mismo día, antes de cerrar caja** (ver M6).
- **Un gestor = un teléfono = una ruta.** No hay multi-dispositivo.
- **No hay contrato escrito ni firma dibujada.** El QR escaneado sustituye a la firma.

---

### 2. Quién mira el demo

El dueño de una financiera pequeña, no técnico, en una reunión de ~15 minutos. Tiene que reconocer
**el día de su cobrador** en pantalla, minuto a minuto. Prioridad absoluta: la secuencia real, no
la belleza.

---

### 3. Restricciones de diseño (obligatorias)

Esta app se usa **de pie, en la calle, con una mano, bajo el sol y a veces bajo lluvia**. Eso manda
sobre cualquier consideración estética:

- **Objetivos táctiles grandes** (mínimo 48 px de alto). Botones principales anchos, al alcance del
  pulgar, en la mitad inferior de la pantalla.
- **Alto contraste.** Nada de gris claro sobre blanco. Se lee a plena luz.
- **Mínimo tecleo.** Teclado numérico grande para importes. Todo lo demás, selección.
- **Tipografía grande para las cifras.** El importe de la cuota y el saldo son lo más grande de cada
  pantalla.
- **Navegación inferior de 4 pestañas**: `Mi ruta` · `Nueva venta` · `Mi caja` · `Más`.
- **Idioma**: todo en **español**. Nunca portugués ni inglés.
- **Moneda**: `R$ 1.200,00` — punto de miles, coma decimal.
- **Fecha**: `dd/mm/aaaa`, hora 24 h.
- **Banner de prototipo permanente** en la parte superior, discreto pero siempre visible:
  `Prototipo de demostración — datos simulados`. No lo quites en ninguna pantalla.
- Estética nativa Android sobria: sin degradados decorativos, sin ilustraciones, sin emojis en la UI.

---

### 4. Capa transversal — señal, sincronización y modo sin conexión

**Esto no es un módulo: es una banda que atraviesa todas las pantallas del demo.** Es la
característica que más diferencia al producto y la que el cliente más necesita ver.

Barra de estado fija bajo el encabezado, con tres estados visibles:

| Estado | Aspecto | Texto |
|---|---|---|
| Conectado y al día | Verde tenue | `En línea · Todo sincronizado` |
| Sin señal, con trabajo pendiente | Ámbar | `Sin conexión · 7 movimientos guardados en el teléfono` |
| Sincronizando | Neutro, con progreso | `Sincronizando… 4 de 7` |

Añade un **interruptor de demo** visible para alternar entre conectado y sin conexión, de modo que
en la reunión se pueda enseñar el contraste en vivo. Etiquétalo como control del prototipo.

**Qué SÍ puede hacer el gestor sin señal** — y debe funcionar en el demo con el interruptor en
"sin conexión":
- Ver su lista de clientes del día.
- Registrar un pago en **efectivo**.
- Registrar un pago por **PIX**.
- Registrar un **"no pago"** con motivo y compromiso.
- Registrar una visita.

**Qué NO puede hacer sin señal** — al intentarlo, muestra un bloqueo con el motivo escrito:
- **Tomar fotos** de documentos.
- **Crear un préstamo nuevo.**
- **Pedir una llave de autorización** (*"Necesitas conexión para pedir una autorización. Espera a
  tener señal."*).

**Regla de sincronización**: automática, sin descarga manual. Debe sincronizar **al menos una vez
al día o la app se bloquea**. Incluye una pantalla de advertencia: *"Llevas 22 horas sin
sincronizar. Conéctate antes de las 08:00 o no podrás seguir registrando."*

> **Marcador deliberado**: junto a cada movimiento pendiente de sincronizar, muestra la etiqueta
> `Fecha del pago: pendiente de definir`. Hay una regla sin acordar sobre si el pago se fecha al
> registrarse o al sincronizar, y afecta al cierre de caja. **No la resuelvas.**

---

### 5. Módulos y permisos

El gestor tiene acceso a **10 módulos**. Su regla de permisos es simple y debe notarse en toda la
app:

> **El gestor registra y solicita. No aprueba, no abre, no borra, no edita.**
> La única acción que ejecuta sin que nadie la apruebe es **registrar un pago**.

Matriz de permisos — refléjala en la UI, no la muestres como tabla:

| Módulo | Puede | No puede |
|---|---|---|
| M1 Alta del dispositivo | Generar el PIN, entrar | Elegir su propia contraseña; entrar desde otro teléfono |
| M2 Inicio | Ver sus 3 cifras del día | Ver otras rutas u otros gestores |
| M3 Mi ruta | Ver y ordenar sus clientes | Ver clientes de otra ruta |
| M4 Ficha del cliente | Consultar, actualizar fotos | **Borrar** al cliente o sus documentos; **editar datos** si ya tiene pagos; trasladarlo de ruta |
| M5 Registrar pago | **Registrar — sin aprobación** | Modificar montos de la venta |
| M6 Registrar "no pago" | Registrar motivo y compromiso | — |
| M7 Nueva venta | Crear cliente, subir la venta, **escanear el QR** | **Aprobar** la venta; fijar el valor por encima del límite sin llave |
| M8 Gastos | Subir el gasto con factura | **Aprobar** el gasto |
| M9 Llaves | **Pedir** la llave | **Emitirla** |
| M10 Mi caja | **Cerrar** la caja | **Abrir** la caja; reabrirla; corregir tras el cierre |

Cada acción bloqueada debe mostrar **por qué**, no solo un botón gris. Ejemplo:
*"Solo el administrador puede abrir la caja del día."*

---

#### M1 · Alta del dispositivo y primer ingreso — **el minuto cero**

Es la primera pantalla del demo y explica el control contra el robo de cartera. Cinco pasos, cada
uno una pantalla:

1. **Bienvenida.** La app recién instalada, sin cuenta. Un solo botón: `Vincular este teléfono`.
2. **PIN generado.** La app genera un código de vinculación grande y legible (ej. `4T9-K2M`) y
   muestra debajo **el modelo del teléfono** (`Samsung Galaxy A15`) — es lo que el administrador ve
   para reconocer el aparato que está aprobando. Texto: *"Dale este código a tu administrador."*
3. **Esperando aprobación.** Pantalla de espera con el estado. Botón de demo `Simular aprobación`.
4. **Contraseña emitida.** *"Tu administrador aprobó el teléfono."* **El sistema genera la
   contraseña — el gestor no la elige.** Muéstrala una vez, con la advertencia de que no se repite.
5. **Primer ingreso** con usuario y esa contraseña.

Después del primer ingreso:
- **Guía rápida de 4 pantallas** que se muestra solo la primera vez: cómo cobrar, cómo registrar un
  "no pago", cómo funciona sin señal, cómo cerrar caja. Con opción de saltar.
- **Los ingresos siguientes son con huella o PIN corto**, con la sesión siempre activa. **El gestor
  no tiene doble verificación** — esa es obligatoria solo para administradores y socios.

Incluye también, accesible desde `Más`, la pantalla de **desvinculación**: si el administrador
desvincula el teléfono, la app avisa primero **si hay movimientos sin sincronizar** y luego confirma
que **la información del teléfono se borra**.

---

#### M2 · Inicio — "Mi día"

Primera pantalla tras entrar. Debe responder tres preguntas en dos segundos: *¿cuánto llevo?,
¿cuánto me falta?, ¿qué tengo trabado?*

- **Tres cifras grandes**: `Recaudado hoy`, `Clientes visitados / total`, `Efectivo en mano`.
- Barra de progreso de la ruta.
- Tarjeta **Pendientes**: `2 ventas esperando aprobación`, `1 llave solicitada`,
  `7 movimientos sin sincronizar`.
- Aviso del día si aplica: *"Hoy es sábado: recuerda el pago de sueldos."*
- Acceso directo grande: `Continuar mi ruta`.

---

#### M3 · Mi ruta

Dos vistas conmutables: **Lista** y **Mapa**.

**Lista** — una tarjeta por cliente, ordenada **por cercanía** (no alfabética). Cada tarjeta:
nombre, dirección corta, **valor de la cuota del día en grande**, cuotas restantes (`19,5 / 20`),
estado, y días de atraso si los hay. Un toque abre la ficha; un botón directo `Cobrar`.

Agrupa por: `Por visitar` · `Pagaron` · `No pagaron`. Los tres grupos suman el total de la ruta.

**Mapa** — todos los clientes de la ruta con marcadores, y el orden de visita sugerido por cercanía.
El GPS sirve para **guardar dónde vive y trabaja el cliente y para armar la ruta**. Añade una nota
visible: *"La ubicación no se usa para verificar dónde estuviste."*

Filtros: por estado y por atraso. Buscador por nombre.

---

#### M4 · Ficha del cliente (en calle)

Diseñada para consultarse de pie, frente a la persona.

- Encabezado: nombre, foto, teléfono con acceso directo a WhatsApp, dirección.
- **Estado** — usa exactamente estos siete: `Temporal`, `Activo`, `En mora`, `Castigado`,
  `Cancelado`, `Renovado`, `Refinanciado`. La mora entra **a los 3 días** sin pagar.
- **Bloque de deuda, en grande**: total del préstamo, pagado, **saldo**, cuotas restantes con
  decimal, próxima cuota.
- Botones principales: `Registrar pago` · `Registrar no pago`.
- Pestaña *Documentos*: los **5 archivos** del cliente — 1 documento de identidad (obligatorio),
  1 comprobante de residencia (obligatorio), 3 fotos del comercio. Son **fijas por cliente**, no por
  venta. El gestor puede **actualizarlas** (la anterior se reemplaza) pero no borrarlas:
  *"Solo el administrador puede borrar documentos."*
- Pestaña *Movimientos*: extracto cronológico, solo lectura, sin ninguna acción de edición.
- Si el cliente tiene pagos registrados, el botón de editar datos aparece bloqueado:
  *"Este cliente ya tiene pagos. Solo el administrador puede corregir sus datos."*

---

#### M5 · Registrar un pago — **la acción más frecuente del día**

Debe resolverse en menos de 10 segundos y **es la única acción del gestor que no requiere
aprobación de nadie**.

Flujo en una sola pantalla:

1. Cabecera con el cliente y la cuota del día.
2. **Teclado numérico grande** con el importe de la cuota precargado. El gestor puede teclear un
   importe distinto.
3. **Medio de pago**:
   - **DINERO** — es el predeterminado y se registra **sin que el gestor lo seleccione**.
   - **TRANSFERENCIA (PIX)** — exige **comprobante adjunto** y **nombre del titular**, que **puede
     ser distinto del cliente**. Ambos campos obligatorios.
4. **Cálculo en vivo, antes de confirmar** — es el detalle que más sorprende al cliente, dale peso:
   con cuota de `R$ 50,00`, si teclea `R$ 25,00` muestra
   *"Se registra **0,5 cuota**. Quedan **19,5 de 20 cuotas**. Saldo: R$ 975,00."*
   El **contador de cuotas es fraccionado**. Un abono grande **adelanta cuotas** y termina el
   préstamo antes. **No hay mora ni recargo por atraso, y no hay descuento por pago anticipado.**
5. Confirmar → recibo en pantalla con el mensaje que le llegará al cliente:
   *"Su pago fue recibido. Abonó R$ 50,00 y quedan 15 cuotas de 20. Deuda total: R$ 700,00."*
   Añade la nota: *"Sin validez fiscal — comprobante informativo."*

**Corrección**: desde el recibo o desde el movimiento, el gestor puede anular y volver a registrar
**él mismo, solo el mismo día y antes de cerrar la caja**. Después del cierre, la acción desaparece.
Al anular no se avisa a nadie: el extracto del cierre de caja ya se encarga.

---

#### M6 · Registrar un "no pago"

- **Motivo de una lista fija** (no hizo ventas, no estaba, se niega, enfermedad, otro).
- **Comentario libre obligatorio con el compromiso de fecha** — el gestor escribe cuándo prometió
  pagar.
- Confirmación que explica la consecuencia: *"Este compromiso se le enviará al cliente en el
  mensaje del cierre de caja, junto con su saldo."*
- El cliente pasa al grupo `No pagaron` de M3 y su caja queda contabilizada.

Incluye también `Registrar visita` (sin cobro y sin promesa), disponible sin señal.

---

#### M7 · Nueva venta, renovación y refinanciación

Aquí es donde el gestor participa en el **control antifraude nº 1**. Modela los 5 pasos con un
indicador de progreso visible en todo momento:

| Paso | Quién | Dónde | Estado |
|---|---|---|---|
| 1. Crear cliente y tomar los documentos | **Gestor** | App | `Documentos completos` |
| 2. Autorizar el valor | Administrador secundario | Web | `Valor autorizado` |
| 3. Subir la venta con los documentos | **Gestor** | App | `Pendiente de aprobación` |
| 4. Aprobar la venta | Administrador principal | Web | `Aprobada — QR enviado al cliente` |
| 5. **Escanear el QR delante del cliente** | **Gestor** | App | `Efectivo liberado` |

**Pantallas del gestor:**

`Nueva venta` — selector: cliente nuevo o existente.

`Alta de cliente` — formulario en pasos cortos: datos personales, dirección con **captura de GPS**,
teléfono, **5 fotos con la cámara**, y una casilla explícita:
**`El cliente autoriza recibir mensajes por WhatsApp`** — el gestor lo pregunta y lo marca aquí.
Sin teléfono con WhatsApp no se puede continuar: *"Sin WhatsApp el cliente no puede recibir el QR
ni su extracto diario."*
**Todo este paso está bloqueado sin señal**, porque requiere cámara y GPS.

`Condiciones del préstamo` — capital, cuotas, valor de cuota, total, **calculado en vivo**. Usa este
caso por defecto y respétalo exactamente: **capital R$ 1.000,00 → 24 cuotas diarias de R$ 50,00 →
total R$ 1.200,00**. Interés fijo sobre el capital, cuota indivisible.
Si el valor supera el límite de la empresa, aparece: *"Este monto necesita una llave de
autorización"* con acceso directo a M9.

`Mis ventas` — lista con el estado de cada una y qué falta. Una venta en `Aprobada — QR enviado`
muestra un botón grande y destacado: **`Escanear QR del cliente`**.

`Escanear QR` — visor de cámara simulado, con botón de demo `Simular escaneo`. Al escanear:
confirmación a pantalla completa **`Efectivo liberado — entrega R$ 1.000,00 a Joana Ribeiro`**,
y la venta pasa a `Efectivo liberado`. Esta pantalla es el corazón del demo: dale peso visual.
Explica en una línea: *"Al escanear, el administrador confirma que la venta fue real."*

**Renovación** — al elegir un cliente con saldo pendiente, **bloqueo duro**: *"El cliente debe pagar
el 100 % de la deuda para renovar. Saldo pendiente: R$ 340,00."* Sin excepción y sin llave que lo
salte.

**Refinanciación** — reestructura sin entregar dinero nuevo: **el interés se recalcula sobre el
saldo que debe** y **el cliente arranca en 0, sin atraso**. Muestra el antes y el después.

---

#### M8 · Gastos

El gestor sube los gastos igual que las ventas, y el administrador los aprueba.

- **Categorías fijas — usa exactamente estas siete**: `gasolina`, `aceite`, `sueldo cobrador`,
  `sueldo supervisor`, `viáticos`, `comisión por cliente nuevo`, `otros`.
- **Factura obligatoria en todos los casos.** Sin foto adjunta no se puede enviar.
- Lista `Mis gastos` con estados `Pendiente` / `Aprobado` / `Rechazado con motivo`.
- El gasto aprobado descuenta del efectivo en mano y aparece en el arqueo de M10.

---

#### M9 · Llaves de autorización

Solo dos operaciones las necesitan: **un préstamo por encima del monto límite** y **recibir más de
X cuotas adelantadas**. Nada más.

- Pantalla `Pedir autorización`: operación, cliente, valor, motivo. Botón `Solicitar`.
- Estado de espera con la nota: *"Solo el administrador principal puede autorizar."*
- Al aprobarse, el código llega a la app y **sirve solo para ese cliente, solo ese día, y solo antes
  de cerrar la caja. No se puede reutilizar.** Muestra esas tres condiciones en pantalla.
- **Sin señal no se puede pedir ni usar**: *"Espera a tener conexión."*
- El campo del umbral aparece con la etiqueta `Límite pendiente de definir`. **Déjalo así.**

---

#### M10 · Mi caja y cierre del día

La rutina que cierra la jornada. Es el control antifraude nº 2 visto desde el gestor.

**Apertura** — el gestor **no abre la caja**. Si el administrador no la abrió, la pantalla dice:
*"Tu administrador aún no abrió la caja de hoy."*

**Mi caja** — **tres paneles**, con estos nombres exactos, en pestañas:
`CLIENTES PENDIENTES` · `CLIENTES QUE PAGARON` · `CLIENTES QUE NO PAGARON`.

- **La caja solo se cierra con `CLIENTES PENDIENTES` = 0.** Mientras haya pendientes, el botón
  `Cerrar caja` está deshabilitado y muestra el número que falta: *"Te faltan 4 clientes por
  visitar."*
- **Arqueo**: recaudado en efectivo · recaudado por PIX · gastos aprobados · efectivo entregado ·
  **efectivo que debe quedar en mano** · **diferencia**. No existe el concepto de "dinero
  pendiente".
- **Fondeo del efectivo** (cuando necesita dinero para prestar): cascada de tres pasos visible en
  pantalla — (1) usa el efectivo que él mismo recaudó; (2) si no alcanza, el administrador le envía
  de su caja; (3) si tampoco, el administrador envía el resto y **el gestor registra un ingreso a
  caja**. Importante: **nunca se le impide registrar un préstamo por no tener efectivo.**
- **El efectivo no se consigna en un banco**: se usa para renovaciones, gasolina y los sueldos del
  sábado. Toda entrega de efectivo **debe quedar confirmada por ambas partes** — modela esa doble
  confirmación.
- **Cierre**: modal con la advertencia **`El cierre es irreversible`**, y a continuación una
  pantalla que muestra **los extractos de WhatsApp que salen hacia los clientes**, con el texto
  real: pagó o no pagó, saldo pendiente, compromiso de fecha, y cómo reclamar. Dale peso visual:
  es la razón de existir del producto.

Incluye un caso de **descuadre**: una diferencia distinta de cero que impide cerrar, con la nota
visible `Regla de tolerancia pendiente de confirmar`. Es intencional, no lo resuelvas.

---

### 6. Módulo `Más`

Agrupa lo secundario: perfil del gestor y su ruta · estado del dispositivo y desvinculación ·
la guía rápida para volver a verla · **términos y condiciones con la versión aceptada y la fecha** ·
ayuda · cerrar sesión.

---

### 7. Datos de muestra

Coherentes entre pantallas — el cliente va a seguir a la misma persona por varios módulos.

- **Gestor**: Marcos Oliveira, ruta `Centro 1`, teléfono `Samsung Galaxy A15`.
- **Ruta del día**: 38 clientes, un **jueves**, media mañana: 21 visitados, 15 pagaron, 6 no
  pagaron, 17 por visitar.
- **Cliente protagonista**, presente en todo el demo: **Joana Ribeiro** — préstamo de
  **R$ 1.000,00 en 24 cuotas diarias de R$ 50,00, total R$ 1.200,00**, con un pago parcial de
  R$ 25,00 que deja **19,5 de 20 cuotas**.
- **Segundo caso**: un cliente con saldo pendiente que intenta renovar y queda bloqueado.
- **Tercer caso**: un cliente en mora de 5 días, para mostrar el estado sin recargo.
- Nombres brasileños, interfaz en español.

---

### 8. Qué NO debe aparecer

Está fuera del MVP y su presencia daría una impresión falsa de lo que existe:

- Asistente de IA, scoring automático o recomendaciones de a quién prestar.
- Comparativo de desempeño entre gestores.
- Reportes avanzados.
- Firma dibujada en pantalla o contrato con plantilla legal.
- Portal o inicio de sesión del cliente final.
- Cualquier acción que mueva dinero real.
- Consulta a buró o central de riesgo.

---

### 9. Comportamiento del prototipo

- **Todo lo clickeable lleva a algún sitio.** Nada de botones muertos.
- **El estado persiste durante la sesión**: si el gestor registra un pago, el contador de M2 sube,
  el cliente cambia de grupo en M3 y el arqueo de M10 cambia. Esa continuidad es lo que hace
  creíble el demo.
- Las acciones que ocurren del lado del administrador llevan un botón `Simular…` marcado como
  control del prototipo.
- **Botón `Reiniciar demo`** dentro de `Más`.
- Sin animaciones largas: el cliente pidió que se sintiera instantáneo.

---

### 10. Los marcadores de "pendiente" son deliberados

Cinco puntos que **el demo debe mostrar sin resolver**, porque siguen en discusión y verlos en
pantalla es la mejor forma de cerrarlos:

1. **Fecha del pago registrado sin señal** — ¿la del momento del registro o la de la
   sincronización? Afecta a qué caja cae el pago.
2. **Tolerancia de descuadre** al cerrar caja — sin regla acordada.
3. **Umbral de la llave de autorización** — sin valor.
4. **Regla de redondeo** cuando la cuota no da un número exacto de centavos.
5. **Cuántas cuotas adelantadas** disparan la necesidad de autorización — la "X" no está definida.

Trátalos con un estilo consistente (icono de información + texto tenue). **No los inventes, no los
rellenes con un valor plausible y no los escondas.**

---

### 11. Entregable

Un prototipo navegable de M1 a M10 dentro de un marco de teléfono, **arrancando en la app recién
instalada sin cuenta** y con un camino completo hasta el cierre de caja.

Además, sugiere un **guion de demostración de 5 minutos** que cuente el día completo del gestor:
vincular el teléfono → ver la ruta → cobrar una cuota parcial sin señal → registrar un "no pago" →
sincronizar al recuperar la señal → escanear el QR de una venta aprobada → cerrar caja y ver los
extractos que salen hacia los clientes.

## (fin del prompt)

---

## Notas para ti, no para Claude Design

- **La app del gestor es el 80 % del MVP.** `D-03` fija la primera entrega como *app del cobrador
  completa + web mínima*: este prompt cubre bastante más alcance que el de la web, y conviene
  decirlo en la reunión para que el cliente no lea las dos demos como si pesaran igual.
- **Los dos controles antifraude dependen de la API de WhatsApp Business**, que el cliente no tiene
  (`CX-16`, `C-75`). En esta demo se ven el QR y los extractos funcionando de punta a punta. El
  banner ayuda; dilo también en voz alta.
- **`CX-13` es la contradicción que más daño hace en móvil**: `C-67` fecha el pago **al
  sincronizar**, y eso choca con el cierre de caja del día (`C-50`, `C-51`, `C-22`, `C-58`). Con las
  reglas tal como están hoy, **el cierre diario no puede cuadrar**. El marcador nº 1 de la sección
  10 existe precisamente para provocar esa conversación frente a la pantalla.
- **`CX-12`**: el cliente dijo a la vez que se puede cerrar con faltante registrándolo como deuda
  del cobrador, y que *"no puede faltar ni sobrar"*. Sin tolerancia declarada. Marcador nº 2.
- **`CX-22` sigue abierta**: `C-74` marcó que la app la usan cobradores, administradores **y**
  socios. Este prompt asume **solo el gestor**, coherente con `C-36`. Si el cliente reacciona al
  ver la app, ahí se cierra.
- **`CX-25`**: `C-45` pidió GPS para ubicar al cliente y armar la ruta, y **no marcó** la opción de
  verificar que el cobrador estuvo allí. La nota *"la ubicación no se usa para verificar dónde
  estuviste"* en M3 es fiel a lo respondido — pero es justo el tipo de frase que puede hacer que el
  cliente cambie de opinión en la reunión. Vale la pena observar su reacción.
- **`CX-14` / `CX-34`**: el paso 2 (autorizar el valor) se lo asigné al **administrador secundario**,
  igual que en el prompt de la web. `C-39` dice que los supervisores **no tienen acceso al sistema**.
  `B-12` lo pregunta. Sin cerrar.
