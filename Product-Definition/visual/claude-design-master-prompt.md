# Prompt maestro — Demo web (Claude Design)

> **Uso**: copiar el bloque completo de abajo y pegarlo en Claude Design. Es autocontenido: no
> asume acceso al repositorio.
>
> **Estado**: sidecar. No forma parte del handoff de AI-DLC y **no cierra ninguna pregunta abierta**
> del discovery. Generado el 2026-08-08 a partir de `vision-document.md`, `technical-environment.md`
> y los lotes `D-02`, `D-03`, `D-05`, `V-xx` y `B-xx`.

---

## PROMPT (copiar desde aquí)

Necesito un **prototipo web clickeable** de un producto SaaS. Es un **demo para enseñar a un cliente
el flujo del producto**, no código de producción y no una app funcional. Todo el estado es simulado
en el navegador; no hay backend, no hay red, no hay persistencia real.

---

### 1. Qué es el producto

**SaaS multi-tenant de gestión de préstamos y cobranza en calle** para financieras pequeñas que
operan en **Brasil**. Moneda **real brasileño (BRL)**, **interfaz en español**, zona horaria
`America/Sao_Paulo`.

**Su razón de ser no es gestionar cobranza: es impedir el fraude interno.** Esto tiene que notarse
en el diseño. Hay dos fraudes concretos y dos controles, y son la columna vertebral del demo:

| Fraude | Control en el producto |
|---|---|
| El cobrador manda una venta y **no le entrega el dinero al cliente** | **QR enviado al WhatsApp del cliente**; el cobrador debe escanearlo para liberar el efectivo. Sin escaneo no hay desembolso |
| El cobrador **cobra y no registra** el pago | **Extracto por WhatsApp al cliente final al cierre de caja**, con saldo y canal de reclamo. Convierte cada pago en evidencia verificable por un tercero |

Reglas duras que el prototipo no puede contradecir:

- **El sistema nunca custodia dinero.** No es wallet, ni fintech, ni medio de pago. Efectivo y PIX
  se **registran como información**. No debe aparecer ningún botón de "transferir", "pagar" o
  "retirar fondos".
- **El registro es inmutable.** Libro mayor de solo-añadir. Una corrección es una **contrapartida**,
  nunca una edición. No debe existir un botón "editar movimiento" ni "eliminar pago".
- **Multi-tenant.** Cada financiera está aislada. El demo opera dentro de una sola financiera.

**Este demo cubre solo la web del administrador.** Existe también una app móvil del cobrador (fuera
de alcance aquí), y la web debe leerse como *el lado que autoriza* lo que el cobrador hace en calle.

---

### 2. Quién mira el demo

Un cliente no técnico, dueño de una financiera pequeña, en una reunión de ~15 minutos. Debe entender
**el flujo**, no la tecnología. Prioridad: que reconozca su propia operación diaria en pantalla.

---

### 3. Restricciones de diseño (obligatorias)

- **Estética**: shadcn/ui sobre Tailwind. Paleta neutra (zinc/slate), radios suaves, tipografía Inter
  o similar. Densidad de panel administrativo, no de landing page. Sin degradados decorativos, sin
  ilustraciones, sin emojis en la UI.
- **Idioma**: todo en **español**. Nunca portugués ni inglés, ni siquiera en etiquetas de estado.
- **Formato de moneda**: `R$ 1.200,00` — punto de miles, coma decimal.
- **Formato de fecha**: `dd/mm/aaaa`. Hora en 24 h.
- **Nunca mostrar decimales con coma flotante**. Los importes son exactos.
- **Banner de prototipo permanente** en la parte superior, discreto pero siempre visible:
  `Prototipo de demostración — datos simulados, sin conexión a sistemas reales`. No lo quites en
  ninguna pantalla.
- **Responsive**: la web es de escritorio (el administrador trabaja en computador), pero no debe
  romperse en tablet.

---

### 4. Módulos — 10 en total

**Núcleo del demo (7): M1–M7.** Deben estar completos y navegables.
**Secundarios (3): M8–M10.** Pueden ser una sola pantalla cada uno, sin profundidad.

---

#### M1 · Acceso y contexto

Pantallas: `Login` → `Selector de financiera` → `Shell de la aplicación`.

Acciones:
1. Login con correo y contraseña (cualquier valor entra; no valides credenciales).
2. Elegir financiera de una lista de 2 — deja claro que es multi-tenant.
3. Shell con navegación lateral por los 10 módulos, nombre de la financiera visible en todo momento,
   y un menú de usuario con el rol activo.
4. **Conmutador de rol** en el menú de usuario: `Administrador principal` / `Administrador
   secundario`. Al cambiar a secundario, tres entradas del menú se muestran **deshabilitadas con
   candado** (Llaves de autorización, Dispositivos, Usuarios y roles). Es la forma más rápida de
   enseñarle al cliente qué significa "delegar sin perder el control".

---

#### M2 · Tablero

Pantalla única. Es lo primero que ve el administrador cada mañana.

Contenido:
- **Tres cifras grandes de la mañana**: `Caja inicial`, `Caja actual`, `Recaudo pretendido`.
  Marca `Recaudo pretendido` con un icono de información y el tooltip:
  *"Definición pendiente de acordar con el cliente"*. **Deja ese marcador visible: es intencional.**
- Fila de estado por ruta: ruta, gestor asignado, clientes visitados / total, recaudado, estado de
  caja (`Abierta` / `Cerrada` / `Sin abrir`), última sincronización.
- Panel **Requiere tu atención** con contadores clickeables que llevan al módulo correspondiente:
  `3 ventas por aprobar`, `2 gastos por aprobar`, `1 llave solicitada`, `1 dispositivo por vincular`.
- Franja de **alertas activas** (ver M9).
- Indicador de actualización: *"Actualizado hace 8 s"* con refresco visible cada pocos segundos.
  El cliente pidió explícitamente ver los pagos **al instante**.

---

#### M3 · Clientes

Pantallas: `Lista` → `Ficha del cliente` → `Alta / edición`.

**Lista**: tabla con nombre, documento, ruta, teléfono WhatsApp, estado, saldo, cuotas restantes.
Filtros por ruta y por estado. Buscador.

**Estados posibles** (usa exactamente estos siete): `Temporal`, `Activo`, `En mora`, `Castigado`,
`Cancelado`, `Renovado`, `Refinanciado`.

**Ficha del cliente**, con pestañas:
- *Datos* — personales, dirección, teléfono con WhatsApp.
- *Documentos* — exactamente **5 archivos**: 1 documento de identidad (obligatorio), 1 comprobante
  de residencia (obligatorio), 3 fotos del comercio. Son **fijas por cliente**, no por venta. Al
  reemplazar una, la anterior se sustituye. Muestra un aviso: *"Solo el administrador puede borrar
  documentos"*.
- *Préstamos* — historial con estado y saldo.
- *Movimientos* — extracto de solo lectura, cronológico, sin acciones de edición.

**Alta / edición**: formulario con validación visible. El campo **teléfono con WhatsApp es
obligatorio** — si falta, bloquea el guardado con el mensaje *"Sin WhatsApp el cliente no puede
recibir el QR de liberación ni su extracto diario"*. Esa frase enseña el modelo del producto mejor
que cualquier explicación.

---

#### M4 · Ventas (préstamos) — **el módulo más importante del demo**

Es el control antifraude nº 1. Modela el flujo completo en **4 pasos** con estado visible tipo
*stepper* horizontal:

| Paso | Quién | Dónde ocurre | Estado resultante |
|---|---|---|---|
| 1. Alta del cliente y recolección de documentos | Cobrador | App móvil | `Documentos completos` |
| 2. Autorización del valor | Administrador secundario | Web | `Valor autorizado` |
| 3. Envío de la venta con documentos | Cobrador | App móvil | `Pendiente de aprobación` |
| 4. Aprobación de la venta | Administrador principal | Web | `Aprobada — QR emitido` |

Y después, el paso que cierra el círculo:

| 5. Escaneo del QR | Cobrador, frente al cliente | App móvil | `Efectivo liberado` |

**Pantallas:**

`Lista de ventas` — tabla con columna de estado usando los cinco estados de arriba, con color
distinto cada uno. Filtro por estado.

`Detalle de la venta` — el corazón del demo. Debe mostrar:
- Datos del cliente y los 5 documentos como miniaturas ampliables.
- **Condiciones del préstamo, calculadas en vivo**: capital, interés fijo sobre el capital, número
  de cuotas, valor de cuota, total a pagar. Usa este ejemplo como caso por defecto y respétalo
  exactamente: **capital R$ 1.000,00 → 24 cuotas diarias de R$ 50,00 → total R$ 1.200,00**.
- Reglas visibles en el formulario: **interés fijo sobre lo prestado**, **cuota indivisible**, **sin
  mora**, **sin descuento por pago anticipado**. Cobro **de lunes a sábado**; domingos y festivos
  corren al día siguiente sin acumular cuota.
- Botones `Aprobar venta` y `Rechazar` (con motivo obligatorio).
- **Al aprobar**: modal que muestra el **QR generado** y el mensaje de WhatsApp que se envía al
  cliente. Después, la venta pasa a `Aprobada — QR emitido` y aparece un panel
  *"Esperando escaneo del cobrador"* con un botón `Simular escaneo` que la lleva a
  `Efectivo liberado` y registra el evento en el libro mayor (M7). Ese botón es solo del demo —
  etiquétalo como tal.

`Nueva venta / renovación` — al elegir un cliente con saldo pendiente, **el sistema bloquea el envío**
con el mensaje: *"El cliente debe pagar el 100 % de la deuda para renovar. Saldo pendiente:
R$ 340,00"*. La regla del 100 % es dura y no admite excepción.

---

#### M5 · Caja y cierre diario

Es el control antifraude nº 2 y la rutina diaria del administrador.

`Cajas del día` — una fila por ruta, con estado y acción `Abrir caja`. **Solo el administrador abre
la caja; el cobrador la cierra.** Si el cobrador no cierra, el administrador puede cerrarla por él.

`Detalle de caja` — **tres paneles lado a lado**, exactamente con estos nombres:
`CLIENTES PENDIENTES` · `CLIENTES QUE PAGARON` · `CLIENTES QUE NO PAGARON`.

- La caja **solo se puede cerrar con `CLIENTES PENDIENTES` = 0**. Mientras haya pendientes, el botón
  `Cerrar caja` está deshabilitado con el motivo escrito al lado.
- Cada cliente en `PAGARON` muestra el importe y el medio: **DINERO** o **TRANSFERENCIA (PIX)**.
  Los de PIX llevan comprobante adjunto y nombre del titular, que **puede diferir del cliente**.
- Cada cliente en `NO PAGARON` muestra motivo de una lista fija más el comentario libre del cobrador
  con el compromiso de fecha.
- **Pagos parciales con contador fraccionado de cuotas.** Incluye al menos un caso y respétalo:
  cuota de R$ 50,00, recibe R$ 25,00 → se registra **0,5 cuota** y quedan **19,5 de 20 cuotas**.
  Muéstralo así, con el decimal.
- Resumen de arqueo: recaudado en efectivo, recaudado por PIX, gastos, saldo esperado, saldo
  declarado, **diferencia**.
- **Al cerrar**: modal de confirmación con la advertencia *"El cierre es irreversible"*, y a
  continuación una pantalla que muestra **el extracto de WhatsApp que sale hacia cada cliente**, con
  el texto real del mensaje (pagó / no pagó, saldo pendiente, compromiso, y cómo reclamar).
  **Esta pantalla es la que le explica al cliente por qué el producto existe. Dale peso visual.**

`Cierres` — dos vistas: **por cobrador** y **consolidado de toda la empresa**.

Incluye un caso con **descuadre**: una caja donde la diferencia no es cero. Muestra el bloqueo y una
nota visible: *"Regla de tolerancia pendiente de confirmar"*. Es intencional, no lo resuelvas.

---

#### M6 · Aprobaciones

Bandeja única de todo lo que espera decisión del administrador, con tres pestañas:

1. **Ventas** — enlaza a M4.
2. **Gastos** — el cobrador sube gastos igual que las ventas, con soporte. **Factura obligatoria en
   todos los casos**. Categorías fijas, usa exactamente estas siete: `gasolina`, `aceite`,
   `sueldo cobrador`, `sueldo supervisor`, `viáticos`, `comisión por cliente nuevo`, `otros`.
   Acciones: `Aprobar` / `Rechazar con motivo`.
3. **Llaves de autorización** — el cobrador la pide desde la app y el administrador la aprueba desde
   la web (llave automática; no existe llave manual). **Solo el administrador principal las emite.**
   Hay **un límite único para toda la empresa** — muestra el campo con el valor vacío y la etiqueta
   *"Umbral pendiente de definir"*.

Cada acción de aprobación o rechazo escribe una línea en el libro mayor (M7).

---

#### M7 · Libro mayor / Auditoría

Tabla cronológica de solo-añadir. Columnas: fecha y hora, actor, rol, acción, entidad afectada,
importe, referencia.

- **Sin botones de editar ni eliminar en ninguna fila.** En su lugar, `Registrar contrapartida`,
  que abre un formulario que crea **un movimiento nuevo que compensa al anterior** — ambos quedan
  visibles, enlazados entre sí.
- Filtros por actor, tipo de acción y rango de fechas.
- Incluye entradas de todos los módulos: aprobación de venta, emisión de QR, escaneo del QR, cierre
  de caja, aprobación de gasto, emisión de llave, vinculación de dispositivo, aceptación de términos.

---

#### M8 · Dispositivos *(secundario)*

**Un cobrador = un teléfono = una ruta.** Pantalla única con la lista de dispositivos: modelo,
gestor, ruta, estado, última sincronización.

Flujo de alta, en un solo modal:
1. El gestor instala la app y esta **genera un PIN**.
2. El PIN llega a la web **mostrando el modelo del dispositivo** para que el administrador reconozca
   el aparato.
3. El administrador **aprueba** → el sistema **genera la contraseña** (el gestor no la elige).
4. El administrador puede **vincular y desvincular**.

Al desvincular: **advertencia previa si hay movimientos sin sincronizar**, y confirmación de que
**se borra la información del teléfono**.

---

#### M9 · Alertas *(secundario)*

Pantalla de configuración con **exactamente estas siete alertas**, cada una con interruptor:
dispositivo sin sincronizar · caja sin cerrar · cierre descuadrado · fallo de envío de WhatsApp ·
muchos "no pago" seguidos · intentos de clave fallidos · reclamo de un cliente.

Canal: WhatsApp. Añade una nota visible: *"Canal alternativo en evaluación"*.

---

#### M10 · Usuarios y roles *(secundario)*

Lista de usuarios: administrador principal, administradores secundarios, gestores, socios.

- El administrador principal **crea administradores secundarios** y **les asigna permisos sobre los
  recursos**.
- Muestra la matriz de permisos por recurso como una **rejilla de casillas** (recurso × acción), y
  márcala visiblemente con una nota: *"Alcance de este módulo pendiente de definición"*. **No la
  desarrolles a fondo — el marcador es el objetivo.**
- Pestaña `Términos y condiciones`: versión vigente, historial de versiones, y quién aceptó cuál y
  cuándo, en registro inmutable.

---

### 5. Datos de muestra

Realistas y coherentes entre pantallas — el cliente va a seguir a la misma persona por varios
módulos, así que no cambien los nombres ni los importes.

- **Financiera activa**: 1 ruta piloto, 1 gestor, ~40 clientes. Segunda financiera en el selector,
  solo para demostrar el aislamiento.
- **Escala del producto** (úsala en el consolidado): ~2.000 clientes, ~50 rutas, cartera bajo
  R$ 100.000, ticket medio ~R$ 50.
- **Nombres**: brasileños (Joana Ribeiro, Marcos Oliveira, Cleiton da Silva…), con la interfaz en
  español.
- **Caso protagonista**, que debe atravesar todo el demo: cliente **Joana Ribeiro**, préstamo de
  **R$ 1.000,00 en 24 cuotas diarias de R$ 50,00, total R$ 1.200,00**, con un pago parcial de
  R$ 25,00 que deja **19,5 de 20 cuotas**.
- Fecha del demo: un **jueves**, con caja abierta y en curso.

---

### 6. Qué NO debe aparecer

Está fuera del MVP y su presencia daría una impresión falsa de lo que existe:

- Módulo de facturación o cobro de la suscripción.
- Asistente de IA, scoring crediticio automático, o cualquier recomendación automática.
- Reportes avanzados, gráficas comparativas de desempeño entre gestores.
- Mapa con orden geográfico de rutas.
- Portal para el cliente final.
- Contrato con plantilla legal o firma en el móvil.
- Cualquier acción que mueva dinero real.

---

### 7. Comportamiento del prototipo

- **Todo lo clickeable debe llevar a algún sitio.** Nada de botones muertos. Si algo no está
  modelado, muestra un estado vacío honesto en vez de una pantalla en blanco.
- **El estado persiste durante la sesión**: si el administrador aprueba una venta, el contador del
  tablero baja y aparece la línea en el libro mayor. Esa continuidad es lo que hace creíble el demo.
- **Botón `Reiniciar demo`** en el menú de usuario, que devuelve todo al estado inicial.
- Las acciones que en la realidad ocurren en el móvil llevan un botón `Simular…` claramente marcado
  como del prototipo.
- Sin animaciones largas. El cliente pidió velocidad; que se sienta instantáneo.

---

### 8. Los marcadores de "pendiente" son deliberados

Hay cinco puntos que **el demo debe mostrar sin resolver**, porque siguen en discusión con el
cliente y verlos en pantalla es la mejor forma de cerrarlos:

1. `Recaudo pretendido` en el tablero — sin definición acordada.
2. Umbral de la llave de autorización — sin valor.
3. Tolerancia de descuadre en el cierre de caja — sin regla.
4. Alcance del módulo de permisos por recurso — sin decidir.
5. Canal de alertas alternativo a WhatsApp — en evaluación.

Trátalos con un estilo visual consistente (icono de información + texto tenue). **No los inventes,
no los rellenes con un valor plausible y no los escondas.**

---

### 9. Entregable

Un prototipo navegable con las pantallas de M1 a M10, arrancando en el login y con un camino
completo desde el tablero hasta el cierre de caja.

Además, sugiere un **guion de demostración de 5 minutos**: la secuencia exacta de clics que cuenta
la historia del producto de principio a fin —de una venta que necesita aprobación, al QR que libera
el efectivo, al cierre de caja que manda el extracto al cliente.

## (fin del prompt)

---

## Notas para ti, no para Claude Design

- **El demo enseña los dos controles antifraude funcionando, y hoy no está garantizado que puedan
  construirse**: ambos dependen de la **API de WhatsApp Business**, que el cliente no tiene
  (`CX-16`, `C-75`). El banner de prototipo ayuda, pero conviene decirlo en voz alta en la reunión.
- **El alcance del demo ≠ alcance comprometido.** `CX-27` sigue abierta: el alcance no cabe en un
  desarrollador. Diez módulos en pantalla se leen como diez módulos prometidos.
- **Aprovecha la reunión para los tres P0 que fallaron por escrito** — métrica de éxito (`OQ-B-7`),
  planes y precios (`OQ-B-4`) y presupuesto (`OQ-B-9`). La nota de proceso del vision document dice
  que no se vuelvan a preguntar por cuestionario. Un demo en pantalla es el sustituto.
- El flujo del paso 2 (autorización del valor) lo hace el **administrador secundario**, apoyado en
  `D-05`. Es la lectura más probable del "supervisor" de `C-31`, pero **`CX-14`/`CX-34` siguen
  abiertas** y `B-12` lo pregunta. Si el cliente reacciona a esa pantalla, ahí se cierra.
