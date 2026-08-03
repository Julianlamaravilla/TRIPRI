# Open Questions for AI-DLC — Registro de brechas del Discovery

Ambigüedades pre-declaradas y decisiones sin resolver, derivadas de un análisis de
brechas contra el material de `context-discovery/notebooklm/`.

Last generated: 2026-07-28T00:31:15Z
Last updated: 2026-08-02T06:30:00Z  (**registro RECONCILIADO fila por fila** — las 234 filas llevan ahora marcador de estado con evidencia. Cuestionario v3 procesado (52/55); entrevista técnica completa y aprobada (23/23))

## Cobertura — medida, no estimada

Cada fila del registro lleva `✅ CERRADA`, `🟡 PARCIAL` o `⬜ ABIERTA` con la evidencia que lo
sustenta (`C-xx` de la v2, `V-xx` de la v3, `T-xx` de la entrevista técnica, o `D-0x`).
**Cobertura = (cerradas + 0,5 × parciales) / total.**

| Bloque | Filas | Cerradas | Parciales | Abiertas | Cobertura |
|---|---:|---:|---:|---:|---:|
| **Entorno técnico** `OQ-T` | 26 | 21 | 1 | 4 | **82,7 %** |
| **Negocio y Visión** `OQ-B` | 18 | 9 | 6 | 3 | **66,7 %** |
| **No funcional** `OQ-N` | 48 | 23 | 14 | 11 | **62,5 %** |
| **Contradicciones** `CX` | 38 | 20 | 1 | 17 | **53,9 %** |
| **Funcional** `OQ-F` | 104 | 34 | 26 | 44 | **45,2 %** |
| **TOTAL** | **234** | **107** | **48** | **79** | **56,0 %** |

⚠️ **El porcentaje global engaña por sí solo.** El bloque funcional, que es el más grande y el más
bajo, concentra tres agrupaciones que están abiertas por causas distintas: **las 7 preguntas de IA**
(`OQ-F-67`…`OQ-F-73`, bloqueadas por `CX-30`), **las 4 de WhatsApp** (`OQ-F-57`…`OQ-F-60`, bloqueadas
por `CX-33`) y **las 6 de caja** (`OQ-F-45`, `48`, `50`, `51`, `52`, `85`, diferidas a la llamada
`V-26`/`V-27`). **Resolver esos tres focos cierra 17 filas de una vez** y sube el funcional por
encima del 60 %.

Estado: **entrevista de negocio en curso** — el cuestionario v2 volvió respondido por los
interesados el 2026-08-01 (117 preguntas). El registro literal está en
`interview/business/client-answers-2026-08-01.md`. Las preguntas técnicas (`OQ-T`) siguen
sin abrir. Se regenerará al cerrar cada rol (join stage).

| | Antes del lote | Después del lote |
|---|---|---|
| Contradicciones | 10 | **18** (6 cerradas, 1 sustituida, 15 nuevas) |
| Negocio `OQ-B` | 18 | **10** |
| Funcional `OQ-F` | 98 | **36** |
| No funcional `OQ-N` | 43 | **34** |
| Técnico `OQ-T` | 26 | **26** |
| **Total abiertas** | **195** | **124** |
| Cobertura global | ~37% | **~65%** |

---

## 0. Decisiones confirmadas

Respuestas ya cerradas por el usuario. **Tienen precedencia sobre cualquier afirmación
del material de `context-discovery/`.** El registro íntegro está en
`interview/business/vision-answers-history.md`.

### D-01 · El sistema NO maneja dinero real de la cobranza — 2026-07-28

1. **No es custodio de fondos.** El sistema no recibe, no retiene, no transfiere ni liquida
   dinero de los cobros. **No es wallet, ni fintech, ni entidad bancaria, ni medio de pago.**
2. **Efectivo y PIX son información, no flujo de fondos.** Web y móvil registran los datos de
   la transacción (monto, medio, titular, fecha, comprobante) para **representarla** en la
   gestión y en los flujos de cobranza. El dinero se mueve **fuera del sistema**, entre cliente
   final, gestor y empresa.
3. **Único flujo de dinero real dentro del aplicativo:** el **cobro por el uso del software**
   (facturación/suscripción del producto), **solo en la web** — nunca en el móvil —, e
   independiente del modelo de cobranza del negocio de préstamos.

| Lo que esto **cierra** | Lo que esto **abre** |
|---|---|
| No hay licencia de medio de pago / PSP que gestionar; la regulación aplicable sigue siendo la del **préstamo** (`OQ-N-23`) y la de **datos personales** (`OQ-N-21`) | Un módulo nuevo de **Facturación y Suscripciones** (web-only) que no existía en ningún documento: `OQ-B-18`, `OQ-F-93`…`OQ-F-98`, `OQ-N-42`, `OQ-N-43`, `OQ-T-26` |
| PCI-DSS fuera del núcleo operativo; solo alcanza al cobro del SaaS y es reducible a **SAQ-A** con checkout hospedado | El **modelo de cobro del software** (`OQ-B-4`) deja de ser accesorio y pasa a **P0** |
| No se requiere integración bancaria para los cobros; `OQ-F-34` deja de ser una decisión de alcance mayor | Queda residual: ¿el PIX se teclea siempre a mano o se admite conciliación de **solo lectura**? |
| La app móvil no procesa pagos ⇒ queda fuera de las reglas de compras in-app de las tiendas (argumento a favor en `OQ-N-34`) | Hay que declarar explícitamente ante las tiendas que la app **no procesa pagos** (`OQ-N-43`) |

> **Lo que D-01 NO cambia:** el **libro mayor inmutable, el cuadre de caja y la auditoría siguen
> siendo obligatorios**. El sistema no custodia el dinero, pero **es la única evidencia de que ese
> dinero existió**. Un descuadre sigue siendo pérdida real para la empresa y el fraude interno del
> gestor (`OQ-N-20`) sigue siendo el riesgo nº 1 del negocio.

### D-02 · Lote de respuestas del cliente al cuestionario v2 — 2026-08-01

Los interesados devolvieron `interview/respuesta-cuestionario-cliente.docx` con las **117
preguntas** respondidas mediante resaltado. Registro literal y estado pregunta por pregunta:
**`interview/business/client-answers-2026-08-01.md`**.

**Las 12 reglas de negocio que este lote deja cerradas** — son ejecutables y ya no admiten
interpretación del desarrollador:

1. **Interés fijo sobre el monto prestado** (C-10). Ejemplo dado por el cliente: 1.000 a 24
   cuotas diarias = 1.200 en total, cuotas de 50. **No hay interés compuesto ni sobre saldo.**
2. **La cuota no se descompone** en interés y capital: es una sola cosa (C-19).
3. **No hay interés ni recargo de mora** (C-14). La mora es un *estado* a los 3 días (C-15),
   no un cargo. La deuda nunca crece.
4. **No hay descuento por pago anticipado** (C-21) ni por cancelación total (C-30).
5. **Frecuencia diaria = lunes a sábado**; domingo y festivo corren al día siguiente y el
   cliente paga **una sola** cuota, no dos (C-12).
6. **La modalidad "Libre" no existe** (C-13) — cierra `CX-7`.
7. **Pago parcial aceptado con contador fraccionario de cuotas** (C-18): si la cuota es 50 y
   entrega 25, quedan **19,5 de 20 cuotas**. Es el requisito de cálculo más singular del sistema.
8. **Renovar exige el 100% de la deuda pagada**; el sistema bloquea el envío de la venta (C-28).
   **Refinanciar** es distinto: recalcula interés sobre el saldo y **el cliente arranca en 0
   sin atraso** (C-29).
9. **Flujo de aprobación de venta en 4 pasos**: cobrador → supervisor autoriza valor →
   administrador aprueba → **QR al WhatsApp del cliente que el cobrador escanea para liberar
   el dinero** (C-31). Ese QR **sustituye a la firma digital** (C-72) y **no hay contrato
   escrito** (C-35).
10. **La caja tiene 3 paneles** (pendientes / pagaron / no pagaron) y **solo cierra con
    pendientes = 0** (C-50). La abre el administrador, la cierra el cobrador, y **una vez
    cerrada es irreversible** (C-58).
11. **Tres roles** con permisos ya delimitados (C-36) — cierra `CX-6`. Un cobrador = una ruta
    = un celular (C-37, C-70).
12. **Los dos fraudes a combatir están nombrados** (C-99), y cada uno trae su control:
    venta sin entrega de dinero → **QR**; pago cobrado y no registrado → **extracto por
    WhatsApp a cada cliente al cierre de caja**, con canal para avisar al supervisor.
    **Esto es el núcleo del producto**, no una funcionalidad más.

**Lo que el lote cierra en el registro:** `CX-4`, `CX-5`, `CX-6`, `CX-7`, `CX-9`, `CX-10`;
8 de 18 `OQ-B`; 62 de 98 `OQ-F`; 9 de 43 `OQ-N`. `CX-8` queda **sustituida** por `CX-11`
(el país sigue sin declararse). `CX-1` queda **resuelta con reserva**: C-112 fija la secuencia
—operación propia → piloto de venta de paquetes → comercialización— así que **no** hace falta
multi-tenant activo en la v1, pero sí el aislamiento por diseño; la reserva es `CX-19`.

**Lo que el lote abre:** 15 contradicciones nuevas (`CX-11` … `CX-25`), 4 desconocimientos
legales declarados (C-93, C-94, C-95, C-98) y 3 preguntas que el cliente pidió responder
**hablando** (C-49 el circuito del dinero, C-82 la definición de los indicadores, C-91 los
patrones de fraude).

**Advertencia de procedencia:** el documento trae **dos colores de resaltado** — 191 marcas en
verde y 8 en cian, estas últimas concentradas en caja y autorizaciones (C-44, C-51, C-53, C-54,
C-58, C-61, C-63, C-64). En tres casos la marca cian **contradice la verde de la misma
pregunta**. Se presume una segunda persona, coherente con el *"lo tendríamos que definir entre
los tres"* de C-116. **Falta saber quién decide cuando las dos manos discrepan.**

---

## 1. Cómo usar este documento

Cada pregunta tiene un **ID estable**, una **prioridad** y el **artefacto que alimenta**.

| Prefijo | Alcance |
|---|---|
| `CX-n` | Contradicción detectada dentro del propio insumo. Hay que decidir cuál versión vale. |
| `OQ-B-n` | Negocio / Visión → alimenta `vision-document.md` |
| `OQ-F-n` | Funcional (reglas de negocio ejecutables) → alimenta `vision-document.md` + AI-DLC Requirements |
| `OQ-N-n` | No funcional (NFR) → alimenta `vision-document.md` §NFR + `technical-environment.md` |
| `OQ-T-n` | Entorno técnico / restricciones → alimenta `technical-environment.md` |

| Prioridad | Significado |
|---|---|
| **P0** | Bloqueante. Sin esto no se puede redactar un documento útil. **Responder los P0 lleva el Discovery global de ~35% a ~70%.** |
| **P1** | Necesaria para cerrar **100% funcional y 100% no funcional**. |
| **P2** | Mejora la calidad; se puede diferir a la fase de Requirements Analysis de AI-DLC. |

> Los `[Answer]:` de este archivo son opcionales: puedes responder aquí mismo, o
> esperar a los lotes de entrevista, donde cada pregunta llegará pre-rellenada con
> lo que ya se sabe. Si respondes aquí, avísame con `ready` y lo incorporo.

---

## 2. Cobertura actual del insumo

Qué tan lejos llega hoy el material de `context-discovery/` frente a lo que exige el Discovery.

| Bloque | Antes | **Hoy** | Qué está bien cubierto | Qué falta |
|---|---|---|---|---|
| **Visión / Negocio** (Q1–Q18) | ~50% | **~75%** | Capacidad núcleo, problema, **para quién es y cuándo se vende (C-03, C-112)**, **modelo de cobro (C-04)**, **riesgos que teme (C-110)**, **arranque piloto (C-111)**, alcance del dinero (D-01) | **Nombre del producto (C-01)**, métricas medibles, MVP priorizado y MVP OUT (`CX-15`), presupuesto |
| **Funcional — el "qué"** | ~65% | **~90%** | Inventario de módulos, roles y permisos (C-36), estados, medios de pago, autorizaciones, offline, WhatsApp, IA diferida | Los indicadores del tablero (C-82, diferida a llamada) y el circuito del dinero (C-49, diferida) |
| **Funcional — el "cómo se comporta"** | ~20% | **~75%** | **Toda la matemática financiera** (C-10 con ejemplo numérico, C-12, C-14, C-18 fraccionario, C-19, C-20, C-21, C-28, C-29, C-30), ciclo de caja (C-50), flujo de aprobación con QR (C-31) | **Redondeo (C-17)**, imputación cuando la caja no cuadra (`CX-12`), fecha del pago offline (`CX-13`) |
| **No funcional** | ~28% | **~50%** | Volumen y horario de pico (C-101), RPO (C-103), parque de dispositivos (C-104), retención de datos (C-97), fraude interno nombrado (C-99) | **4 desconocimientos legales declarados** (C-93, C-94, C-95, C-98), SLA real (`C-102` vs `C-105`), aislamiento multi-tenant (`CX-19`) |
| **Entorno técnico** (T1–T29) | ~12% | **~12%** | Sin cambios: el cuestionario era de negocio | Todo: lenguajes, frameworks, cloud, datos, auth, testing, CI/CD |
| **Global** | ~37% | **≈65%** | | |

> **Por qué el salto es grande:** el bloque que estaba en ~20% —*cómo se comporta el
> sistema con el dinero*— era el que bloqueaba de verdad, porque cada hueco ahí se convertía
> en una suposición del desarrollador sobre cifras. Ese bloque ahora tiene reglas
> ejecutables **con un ejemplo numérico verificado del propio cliente**. Lo que queda abierto
> ya no es "no sabemos cómo funciona el negocio", sino **11 decisiones concretas** (`CX-11`…`CX-21`,
> las P0) y **el entorno técnico entero**, que aún no se ha entrevistado.

> **Efecto de D-01 sobre la cobertura:** cierra una ambigüedad estructural (¿custodio de fondos o
> sistema de registro?) que contaminaba regulación, seguridad, integraciones y distribución móvil.
> Sube poco el porcentaje porque, a cambio, **abre un área funcional nueva** (facturación del SaaS)
> que estaba en cero.

**Objetivo del ejercicio:** responder los **P0** → ~70% global. Responder **P0+P1** → **100% funcional y no funcional**.

---

## 3. Contradicciones dentro del insumo (resolver primero)

El material se compone de un documento fuente y 3 reportes generados por NotebookLM;
los reportes añaden afirmaciones que la fuente no contiene. Hay que decidir cuál vale.

### 3.1 · Contradicciones del insumo original — estado tras el lote D-02

| ID | Contradicción | Estado |
|---|---|---|
| **CX-1** | ¿Multi-tenant desde el día 1? | ✅ **RESUELTA CON RESERVA** — C-03 (vender en ~1 año) + C-112 (operación propia → piloto → comercializar): **no** se activa multi-tenancy en la v1, pero el aislamiento se diseña desde el principio. Reserva: `CX-19` |
| **CX-2** | Longitud del código de llave | ✅ **CERRADA 2026-08-02** — `V-18`: *"puede ser de 4 dígitos"*. Junto con `C-60` (un cliente, un día, un solo uso) la llave queda completamente especificada |
| **CX-3** | ¿MFA en el alcance? | ✅ **CERRADA 2026-08-02** — `V-36` (A): **obligatorio para administrador y socios, no para cobradores**, que quedan atados al dispositivo (`C-70`) |
| **CX-4** | Sincronización móvil | ✅ **CERRADA** — C-69 A: automática. Se elimina la descarga manual de la UGI |
| **CX-5** | "Limpieza de cobro" = ¿optimización de ruta? | ✅ **CERRADA** — C-73 B+C: sí quiere ordenar por cercanía **y** ver el mapa. Son dos funciones distintas y quiere ambas. **`D-03` deja el orden geográfico fuera de v1** |
| **CX-6** | Roles del sistema | ✅ **CERRADA** — C-36 A: exactamente tres (Administrador, Socio, Cobrador), con permisos descritos. "Gestor" y "Trabajador" eran el mismo Cobrador |
| **CX-7** | Modalidad "Libre" | ✅ **CERRADA** — C-13: *"la modalidad libre no aplica"*. Se elimina del catálogo |
| **CX-8** | País, moneda y regulación | ✅ **CERRADA 2026-08-02 vía `CX-11`** — `V-01`: **Brasil · BRL · UI en español**. `V-29`/`V-30`: sin regulación aplicable ni tope de usura |
| **CX-9** | Límite de fotos de venta | ✅ **CERRADA** — C-44: 5 fotos **por cliente** (1 documento + 1 residencia + 3 comercio), no por venta |
| **CX-10** | ¿Llave manual y automática ambas? | ✅ **CERRADA** — C-63 B: **solo la automática** |

### 3.2 · Contradicciones nuevas, entre las propias respuestas del cliente

Estas no vienen del material: las produjo el lote de respuestas. Todas se detectaron
comparando lo que el interesado marcó con lo que escribió, o una respuesta contra otra.

| ID | Contradicción | Lo que dice una respuesta | Lo que dice la otra | Prio |
|---|---|---|---|---|
| **CX-11** | **El país y la moneda siguen sin declararse** | C-02 marca B y lista la expansión: México, Ecuador, Argentina, Uruguay, Chile, Perú, Bolivia — **pero nunca dice el país actual** | ✅ **CERRADA 2026-08-02 (V-01): Brasil · reales (BRL) · app en ESPAÑOL.** Confirma LGPD (T21) y `sa-east-1` (T11). ⚠️ Abre `CX-32`: los ~1.200 prestatarios son brasileños y son quienes reciben los mensajes del control antifraude. Todo apunta a **Brasil**: PIX (C-23, C-24) y *"usted abonó 50 **reales**"* (C-25). Pero **Brasil no está en la lista de expansión**, y la app tendría que estar en **portugués**, no en español | **P0** |
| **CX-12** | **¿El cierre de caja bloquea si no cuadra?** | C-51 marca **B**: dejar cerrar y registrar el faltante como **deuda del cobrador** | ✅ **CERRADA 2026-08-02 (V-02).** Se puede cerrar descuadrado; el sistema **genera alerta al administrador** y al día siguiente se verifica. Si el faltante es del cobrador, **se le descuenta del sueldo el sábado** → función de nómina nueva, `OQ-F-101`. ⚠️ Menciona "supervisor", rol que V-04 declara inexistente → `CX-34`. El texto en cian de la misma pregunta dice *"**no puede faltar ni sobrar**"* (= opción A, bloquear). Y C-58 hace el cierre **irreversible**. Además C-53 permite prestar sin efectivo suficiente, lo que **produce** descuadres | **P0** |
| **CX-13** | **¿Con qué fecha queda un pago tomado sin señal?** | C-67: *"la fecha debe ser apenas el celular tenga señal y sincronice"* | Rompe C-50 (la caja del día cierra con pendientes=0), C-22 (corregir *el mismo día*) y C-51 (que el día cuadre): un pago del martes que sincroniza el miércoles **descuadra los dos días** | **P0** |
| **CX-14** | **¿El supervisor existe en el sistema o no?** | C-39: *"los supervisores **no tienen acceso al sistema**"*; C-61 A: **solo el administrador** autoriza | C-31: *"el **supervisor autoriza el valor**"* de cada venta; C-99: el cliente *"tiene la opción de enviarle un mensaje **al supervisor**"*. Son dos funciones dentro del sistema | **P0** |
| **CX-15** | **¿Se arranca por la web o por la app?** | C-107: *"primero crear la base, que sería **la app**"* | ✅ **CERRADA 2026-08-02 (V-05): confirma `D-03`** — app del cobrador completa + web mínima acotada a crear/editar clientes, aprobar ventas, aprobar gastos y dar llaves. Deja de ser posición del equipo y pasa a ser decisión del cliente. ⚠️ V-24 la reabre parcialmente al preguntar *"si todo se hace por la app ¿qué sentido tiene la web?"*. C-108 marca **C**: *"la **app móvil puede esperar**; arranquemos con la web"*. Son las dos mitades opuestas del mismo MVP | **P0** |
| **CX-16** | **WhatsApp: el plan depende de algo que no tiene** | C-75 B: tiene **WhatsApp Business normal, no la API** | 🔺 **SUPERSEDIDA 2026-08-02 por `CX-33`.** V-06 no la resuelve: la agrava. El problema no es el trámite, es que **los suscriptores no pueden obtener la cuenta** por no ser empresas formales. Todo el modelo antifraude de C-99 depende de mensajes automáticos, más C-22 (extracto al cierre), C-26 (compromiso de pago), C-78 (3 avisos) y C-31 (el **QR** que libera el dinero). **Sin API no existe ninguno** | **P0** |
| **CX-17** | **¿Qué recibe el cliente al pagar?** | C-25 marca **D**: *"nada, con que quede registrado basta"*; C-23 marca **A**: registro manual simple | Los textos de esas mismas preguntas piden lo contrario: un mensaje con abono, cuotas restantes y saldo (= opción A de C-25), y **comprobante obligatorio + nombre del titular** en PIX (= opción B de C-23) | **P0** |
| **CX-18** | **¿La tasa es única o variable?** | C-11 A: el administrador fija **una tasa para toda la empresa y nadie la cambia** | ✅ **CERRADA 2026-08-02 (V-08).** Rango configurable por tenant, **20 % por defecto**, tasa y nº de cuotas editables **solo en venta nueva o renovación** e inmutables después (refuerza T14). El sistema calcula la cuota: 1.000 al 10 % en 10 días → 10 cuotas de 110. C-10: *"el interés **puede variar**, pero siempre será fijo sobre el valor prestado"*. Falta saber si varía **por producto** (configurable pero cerrado) o **por préstamo** (lo pone quien vende) | **P0** |
| **CX-19** | **¿5.000 qué?** | C-05: *"hagamos la app pensando en los **5000**"* | ✅ **CERRADA 2026-08-02 (V-09).** Escala real: **~10 tenants × ~5 rutas × ~40 clientes ≈ 2.000 clientes**, ~50 rutas. Los "5.000" eran aspiración de suscriptores. **Valida el dimensionamiento de `infraestructura-aws.md`** con margen. No dice si son **5.000 empresas suscriptoras** o **5.000 clientes finales**. Entre una lectura y otra hay dos órdenes de magnitud de carga, coste y arquitectura | **P0** |
| **CX-20** | **Migración imposible tal como está planteada** | C-08 A: reemplazo total **migrando TODO el histórico** | ✅ **CERRADA 2026-08-02 (V-10): A + B.** Se arranca con los préstamos vivos digitados a mano y **se pide formalmente la exportación al proveedor** antes de decidir. Los históricos se consultan en TryController mientras haga falta. La pregunta adicional de la misma C-08: **TryController no permite exportar**. Sin exportación, "migrar todo" no tiene camino técnico | **P0** |
| **CX-21** | **La pasarela de pagos en la app móvil** | C-113: *"sería bueno que **desde la misma app** se pueda integrar la pasarela de pagos"* | ✅ **CERRADA 2026-08-02 (V-11): A.** La app muestra factura y vencimiento; **el pago se completa en el navegador**. Preserva `D-01` y evita la comisión de las tiendas. Choca de frente con **D-01**, que fija el cobro del software como **web-only, nunca móvil** — y con las reglas de compras in-app de las tiendas (`OQ-N-34`) | **P0** |
| **CX-22** | **¿Quién usa la app móvil?** | C-74 marca **A**: *"solo los cobradores"* | 🟡 **PARCIAL 2026-08-02 (V-24).** Cobradores en la app, administrador en la web, socios solo lectura. **Pero el cliente reabre**: *"si es más práctico… se podría hacer también desde la app para el administrador"*. …y también **B** (el administrador) y **C** (los socios). Las tres son mutuamente excluyentes | P1 |
| **CX-23** | **El estado "renovado" contra la regla de renovación** | C-27 A: la lista de estados (incluido **renovado**) está completa y correcta | ✅ **CERRADA 2026-08-02 (V-12).** "Renovado" queda como **marca informativa** + **historial completo de ventas pasadas**, que alimenta la decisión de subir o bajar el monto siguiente. Renovar exige saldo 0 y aprobación del administrador. C-28 exige **pagar el 100%** para renovar, con bloqueo. Si la deuda vieja siempre queda en cero, "renovado" es indistinguible de un préstamo nuevo. Y C-32 elimina "temporal", que sí está en esa lista | P1 |
| **CX-24** | **Tablero al instante contra sincronización diaria** | C-83 A: *"al instante: si el cobrador registra un pago, quiero verlo ya"* | ✅ **CERRADA 2026-08-02 (V-13 + V-03).** Tablero al instante para lo ya sincronizado, avisando qué rutas faltan. **El cliente pide sincronización oportunista continua** (cada vez que haya internet), no una vez al día. C-66 solo exige sincronizar **una vez al día**, y C-65 permite trabajar toda la jornada sin señal. El tablero no puede mostrar lo que aún está en el celular | P1 |
| **CX-25** | **El GPS no cubre el fraude que sí preocupa** | C-45 **no** marcó B (verificar que el cobrador estuvo donde dice) | ✅ **CERRADA 2026-08-02 (V-14): GPS descartado con razón de negocio** — la mayoría paga por PIX y el cobrador no visita; las rutas cubren pueblos visitados día de por medio. ⚠️ Revela algo mayor → `CX-35`. C-99 nombra justamente ese fraude —cobrar y no registrar— como uno de los dos principales. La geolocalización del pago es el control más barato contra él y quedó fuera | P2 |
| **CX-26** | **"Vincular el usuario a la IP del celular" no es implementable** | Requisito transmitido por el equipo el 2026-08-01 durante la entrevista técnica (T17): *"un usuario se debe relacionar con la IP de su celular, además debe colocar una contraseña"* | ✅ **CONFIRMADA 2026-08-02 (V-36).** El cliente describe exactamente la vinculación de dispositivo que propuso T17: *"el sistema solo se pueda abrir en el celular asignado por la empresa, porque donde el cobrador pueda abrir el sistema desde otro celular él podría dar el usuario y contraseña a otras personas para que se roben los clientes"*. Motivo declarado: **robo de cartera**. Sigue pendiente el flujo de reautorización. Una IP **no identifica un dispositivo**: con CGNAT miles de abonados comparten una misma IP pública; cambia varias veces por ruta al saltar entre antenas y WiFi; **offline no existe IP alguna**, que es justo cuando se crean las operaciones; y un VPN gratuito la cambia en segundos. Bloquea al usuario legítimo sin detener al que quiere evitarla. **IMEI tampoco sirve**: Android lo bloqueó para apps desde la v10 e iOS nunca lo expuso. **Traducción propuesta por el rol técnico:** lo que se describe es **vinculación de dispositivo**, que ya es requisito (**C-70**, un dispositivo por ruta) y es más fuerte — par de claves generado en el teléfono, privada en Keychain/Keystore vía `expo-secure-store`, cada petición firmada, y el intento desde otro teléfono tratado como **evento de auditoría con aprobación explícita de un administrador**. La IP se conserva **como metadato de auditoría**, nunca como control de acceso. **Decisión pendiente del cliente:** reinstalar la app destruye la clave y exige reautorización — propiedad deseable, pero **sin un flujo de reautorización un teléfono roto en sábado deja al gestor sin trabajar** | **P0** |
| **CX-27** | **El alcance comprometido no cabe en el equipo que existe** | **D-03** fija el MVP como **app completa del cobrador + web mínima de administración**. **T14** descarta WatermelonDB/PowerSync/ElectricSQL y compromete un **motor de sincronización offline propio**. **T17** descarta Cognito/Auth0 y compromete un **servicio de autenticación propio** con firma por par de claves en Keystore/Keychain. **T22 + T25** comprometen **seis tipos de prueba obligatorios** y puertas de CI/CD en dos niveles | **T4 (2026-08-02): el equipo es una persona, perfil junior.** Fuerte en **Python + FastAPI** y en **AWS**; **React solo web, sin experiencia móvil**; sin experiencia declarada en React Native, Expo, criptografía en dispositivo ni motores de sincronización. El backend (FastAPI, PostgreSQL con RLS, ledger append-only, Secrets Manager, ECS) **cae dentro de su fortaleza declarada**. La concentración de riesgo es la otra mitad: **la app del cobrador — que es el MVP según D-03 — está íntegramente en la tecnología con cero experiencia previa**, y encima carga las dos piezas más difíciles del sistema (sync offline propio y firma de dispositivo). **Las decisiones técnicas T14 y T17 no son erróneas** — se argumentaron sobre arquitectura y el argumento sigue en pie. Lo que nunca se verificó es la **capacidad** para ejecutarlas. **Lo que tiene que ceder es el alcance, no la arquitectura.** Reabre **D-03**, que además seguía pendiente de firma del cliente | **P0** |
| **CX-28** | ~~**ECS Fargate (T3) contra Lightsail (investigación de costos)**~~ ✅ **CERRADA el 2026-08-02 — gana ECS** | **T3** (2026-08-01) fijó *"contenedores en ECS Fargate desde el día 1"*. **`technical-research/infraestructura-aws.md`** (2026-07-28) recomienda **Lightsail** para Fase 1 (~$59 contra ~$141), argumentando que ECS consume *"2–4 semanas de configuración de VPC/IAM/ALB que un desarrollador con 16 h/semana no tiene"* — premisa que **T4 acabó de confirmar** | **Cerrada por la respuesta de T11, no por preferencia:** el usuario declaró arquitectura de **red privada** — tareas en subred privada, RDS aislada, entrada únicamente por ALB y CloudFront. **Lightsail no puede hacer eso**: no tiene subredes privadas, ni integración con VPC más allá del *peering*, ni control fino por *security group*. El requisito de red **elimina Lightsail por capacidad técnica**, así que el argumento de costo deja de aplicar. Efecto lateral: el 🔒 sin verificar sobre si Lightsail ofrece PITR queda **sin objeto**. **Costo de la decisión: el NAT Gateway (~$68/mes) pasa a ser obligatorio** — ver `OQ-N-45` | ✅ **CERRADA** |
| **CX-29** | **Los reportes a administradores van por Telegram, no por WhatsApp** | Declarado por el usuario el 2026-08-02 durante T11: *"Los reportes de los administradores son a Telegram, no a WhatsApp"* | **Telegram no aparece ni una sola vez en los ~180 KB de material del proyecto** — ni en el documento de requerimientos, ni en los 3 reportes de NotebookLM, ni en las 117 respuestas del cliente. Es un canal nuevo. **C-81** sí fija el reporte a socios (*al día siguiente antes de abrir la caja, el administrador elige a qué socios, puede ser semanal*) pero **nunca declaró el canal**. **No cierra `CX-16`**: el control antifraude nº 2 (QR al WhatsApp del cliente para liberar el efectivo) es hacia **clientes**, no administradores, y sigue dependiendo íntegramente de WhatsApp Business API. **Tampoco baja la factura**: los ~$212/mes estimados son mensajería a 1.200 clientes, no reportes a ~8 administradores. **Lo que sí cambia**: Telegram Bot API es **gratuito**, pero añade una **segunda integración de mensajería** que construir, probar y operar — con un equipo de una persona (`CX-27`) eso no es gratis aunque el servicio lo sea. **Confirmar con el cliente**: ¿los administradores ya usan Telegram? | P1 |
| **CX-30** | **La IA entra en el plan básico — contra `D-03` y contra la respuesta del propio cliente en C-108** | Declarado por el usuario el 2026-08-02 durante T11: modelo de **suscripción semanal**, *"el plan básico solo tiene AI incorporada y el plan siguiente tiene AI + mensajes de WhatsApp"*, por lo tanto *"el MVP o la versión 1 o 2 debería tener la IA incorporada"* | **Contradice dos cosas a la vez.** (1) **`D-03`** dejó explícitamente el asistente de IA **fuera de la v1**. (2) **C-108**: el propio cliente marcó **B** — *"puede esperar: **la IA**"*. Si la IA es el plan de entrada, la IA **es** el producto mínimo por definición, y no puede esperar. ⚠️ **La información es de segunda mano** — el usuario declara *"por lo que me dieron a entender"* —, así que es exactamente **`OQ-F-97`** (planes y límites, P1, abierta) respondida sin fuente autorizada. **Choca de frente con `CX-27`**: una persona junior, sin experiencia móvil, y ahora el alcance **crece** en lugar de reducirse. **Además el asistente de IA nunca se especificó**: `OQ-F-68`, `OQ-F-70`, `OQ-F-72` (todas P0) siguen abiertas — no se sabe si solo consulta o ejecuta acciones, si las cifras deben ser trazables por SQL determinista, ni quién ve datos de qué alcance. **Meter en el plan base una funcionalidad cuyo comportamiento no está definido es el mayor riesgo de alcance del proyecto.** Efecto lateral: reactiva `OQ-T-15` (proveedor de LLM), que `D-03` había bajado a P2. **Requiere confirmación directa del cliente antes de planificar nada** | **P0** |

| **CX-31** | **ISO 27001 exige segregación de funciones; el equipo es una persona** | **T21** (2026-08-02) declara **ISO 27001 + LGPD**. **ISO 27001 A.5.3** exige segregación de funciones, y **T25** fijó como **puerta bloqueante de fusión** la *"revisión de código aprobada"* | **`CX-27`: el equipo es un solo desarrollador. No hay revisor.** La misma persona escribe el código de la caja, lo aprueba, lo despliega y opera la producción — **exactamente lo que ese control existe para impedir**, en un producto **cuya razón de ser es el antifraude** (`C-99`). No es un formalismo de auditoría: es la misma clase de riesgo que el sistema pretende eliminar en la operación de cobranza, reproducida en el desarrollo. **Opciones reales**: (a) un revisor externo aunque sea a tiempo parcial; (b) declarar el alcance de ISO como *"alineado, no certificado"* y documentar la excepción con controles compensatorios (registro de despliegues inmutable, entorno de producción con acceso auditado, aprobación del cliente para cambios en módulos de dinero); (c) aceptar que la certificación no es alcanzable hasta que el equipo crezca. **Requiere decisión antes de que T25 se implemente**, porque la puerta de revisión de código **no puede cumplirse tal como está escrita** | **P0** |
| **CX-32** | **Brasil con la app solo en español, pero los prestatarios son brasileños** | **V-01** (2026-08-02): *"Brasil, en reales, pero la app en español — nuestro equipo es hispanohablante"* · *"solo en español, los suscriptores hablan español"* | La app es para los **suscriptores** (hispanohablantes) y eso es coherente. Pero **los ~1.200 prestatarios son brasileños**, y son ellos quienes reciben **el extracto al cierre de caja, el aviso de préstamo nuevo y el QR del control antifraude** (`V-19`, `C-99`). **Nadie declaró en qué idioma van esos mensajes.** Si van en español, el control antifraude nº 2 depende de que un cliente brasileño entienda un mensaje en un idioma que no habla — y el control **deja de funcionar como control**. Decisión: ¿plantillas de mensaje en portugués con interfaz en español, o todo en español? Afecta a las plantillas que Meta debe aprobar | **P0** |
| **CX-33** | 🔴 **Los suscriptores NO PUEDEN obtener WhatsApp Business API — supersede `CX-16`** | **V-06** (2026-08-02): *"para tener la cuenta API se necesita una empresa registrada con documentos verificables ante Meta, y aquí es donde está el problema, que la mayoría de suscriptores no es empresa formal… con seguridad ningún usuario tendría una empresa registrada con documentos verificados"*. Confirmado por **V-29**: *"esta modalidad de préstamo de dinero es informal… no está regulado por ningún país, es algo alegal"* | **El hallazgo más grave del Discovery.** `CX-16` se registró como un trámite pendiente; **no lo es**. Es una **imposibilidad estructural**: Meta exige empresa verificada y los suscriptores son prestamistas informales. **Los dos controles antifraude de `C-99` dependen de ese canal** — el QR al WhatsApp del cliente para liberar el efectivo y el extracto que permite al cliente detectar un pago no registrado. Sin canal, **`D-03` advirtió que "la v1 sale sin ningún control antifraude y el producto pierde su propósito"**. Opciones que hay que evaluar: (a) **la cuenta API la pone la empresa del software**, no cada suscriptor — un único remitente para todos los tenants, lo que cambia el modelo de mensajería y su costo; (b) SMS como canal alternativo; (c) el propio Telegram de `CX-29`, que **no exige empresa verificada**; (d) aceptar la v1 sin control antifraude. **Bloquea la planificación de la v1** | **P0** |
| **CX-34** | **El "supervisor" reaparece después de que V-04 lo eliminara** | **V-04**: *"No tiene cuenta. Lo de C-31 y C-99 en realidad lo hace el administrador; **nos equivocamos al escribir 'supervisor'**"* | Pero en el **mismo cuestionario**, **V-02** dice *"para que al día siguiente **el supervisor** verifique la situación"* y **V-17** *"después de que **el supervisor** verifique, el administrador ya tiene la potestad…"*. O el rol existe y V-04 se equivocó, o esas dos frases quieren decir "administrador". **Afecta al modelo de roles y permisos**, que se decide una vez | P1 |
| **CX-35** | 🔴 **Si la mayoría paga por PIX, el diseño centrado en caja de efectivo describe una minoría** | **V-14** (2026-08-02): *"la mayoría de clientes pagan por transferencia bancaria (PIX) entonces si el cliente mandó su pago ya el cobrador no tiene que ir donde el cliente"* | Todo el modelo construido hasta hoy gira alrededor del **efectivo**: caja del cobrador que cierra a cero (`C-50`), el cobrador que usa el efectivo recaudado para prestar, gasolina y sueldos (`C-52`, `C-53`), el QR para liberar el efectivo de una venta (`D-02`), y el descuadre como señal de fraude (`V-02`). **Si la mayoría de los pagos son PIX, ese modelo describe una fracción del negocio** — y el control antifraude nº 1 (cobrar y no registrar) **es menos aplicable a un pago que ya quedó en un extracto bancario**. Preguntas que abre: ¿qué proporción real es PIX? ¿el pago PIX lo registra el cobrador o entra solo? ¿se concilia contra el banco? ¿el cliente que paga por PIX aparece igual en la ruta del día? **Contradice el peso relativo que `D-02` dio a la caja** | **P0** |
| **CX-36** | **Soporte 24/7 prometido, con un equipo de una persona** | **V-45** (2026-08-02): *"siempre va a tener un canal de atención por parte de nosotros **24/7**"* | **`CX-27`: el equipo es un solo desarrollador junior**, que además opera producción. **24/7 no es sostenible por una persona**, y prometerlo a los suscriptores crea una obligación comercial que el equipo no puede cumplir. Se agrava con **`V-43`** (RTO objetivo **< 1 hora**), que exige capacidad de respuesta inmediata a cualquier hora. Enlaza con `CX-31`: ambos son el mismo problema de una sola persona sosteniendo obligaciones de organización | P1 |
| **CX-37** | **Tres canales de mensajería incompatibles entre sí** | **V-42** (2026-08-02): las 7 alertas automáticas van por **WhatsApp**. **`CX-29`**: los reportes a administradores van por **Telegram**. **`CX-33`**: WhatsApp puede no estar disponible en absoluto | Tres declaraciones que no encajan. Y la más reciente (`CX-33`) **quita el suelo a la primera**: no se pueden mandar alertas por un canal que los suscriptores no pueden contratar. Hay que decidir **un mapa único de canal por tipo de mensaje** — alertas operativas, reportes a socios, mensajes a clientes finales — antes de construir la capa de mensajería. *(El puerto `messaging` de T16 se diseñó justamente para absorber esto: la arquitectura aguanta el cambio, la planificación no.)* | P1 |
| **CX-38** | **ISO 27001 declarado por el equipo, pero el cliente no prevé que se lo pidan** | **T21** (2026-08-02, rol técnico): *"Se va a manejar ISO 27001 + LGPD"*. **V-53** (mismo día, cliente): marca **A** — *"No lo prevemos; nuestros clientes son empresas pequeñas"* | No es una contradicción fatal —el equipo puede decidir construir con ese estándar aunque nadie lo exija—, pero **cambia la respuesta correcta a `OQ-N-46`**: sin cliente que exija el certificado, **"alineado con ISO 27001" es la lectura razonable y "certificado" sería gasto sin comprador**. También descarga la presión de `CX-31` (segregación de funciones): un estándar usado como guía de diseño admite excepciones documentadas; una certificación auditada, no. **LGPD no se ve afectada** — esa es obligatoria por ley, no por exigencia de cliente | P1 |

[Answer]:

---

## 4. Negocio y Visión — `OQ-B`

| ID | Pregunta | Por qué falta / evidencia | Alimenta | Prio |
|---|---|---|---|---|
| **OQ-B-1** | ¿Cuál es el nombre real del producto? El repo es `TRIPRI`, el notebook `TryPRI`, el documento lo llama "Sistema Inteligente de Administración de Préstamos con IA", y el sistema de referencia es "TryController". | Ninguna fuente fija un nombre comercial | ⬜ **ABIERTA** — `V-15`: *"aún no hemos definido"*. Sigue sin nombre tras dos cuestionarios. Q1 | **P0** |
| **OQ-B-2** | ¿En qué país(es) opera y con qué moneda? ¿La UI es español, portugués o ambos? | Ver CX-8 | ✅ **CERRADA** — `V-01`: **Brasil · reales (BRL) · UI en español**. ⚠️ El idioma de los mensajes a prestatarios brasileños queda abierto → `CX-32`. Q1, Q9, NFR i18n | **P0** |
| **OQ-B-3** | ¿Quién es el cliente que paga? ¿Es una plataforma para **tu propia** empresa de préstamos, o un SaaS que le vendes a otras empresas prestamistas? | El doc habla de "la empresa" en singular pero exige arquitectura SaaS | ✅ **CERRADA** — `C-03` + `V-09` + `V-45`: **SaaS vendido a empresas prestamistas**. Hoy ~10 empresas. Cadena: se vende la suscripción → el suscriptor delega un administrador → el proveedor solo trata con ese administrador. Q1, Q2, CX-1 | **P0** |
| **OQ-B-4** | Si es SaaS: modelo de cobro (por unidad/ruta, por gestor, por cartera, % de recaudo) y precio objetivo | Ausente por completo. **Elevada a P0 por D-01**: el cobro del software es el **único flujo de dinero real** del producto, así que su modelo define un módulo entero de la web | 🟡 **PARCIAL** — `C-04`: cobro **por ruta / unidad de cobro activa**. ⚠️ **Tres declaraciones incompatibles sobre la periodicidad**: `C-04` por unidad, `CX-30` suscripción **semanal** con planes, `V-20` vencimiento **el día 30 del mes**. **El precio objetivo nunca se dio.** Q7, Q9 | **P0** ⬆ |
| **OQ-B-5** | ¿Cuál es el volumen **actual**: nº de clientes, préstamos activos, gestores, unidades/rutas y monto de cartera? | Sólo se dice "1 o 2 gestores" para el MVP | 🟡 **PARCIAL** — `V-09`: **~10 empresas × ~5 rutas × ~40 clientes ≈ 2.000 clientes**, ~50 rutas. **Falta el monto de cartera.** Q5, Q10, todos los NFR | **P0** |
| **OQ-B-6** | ¿Cuánto tiempo/dinero se pierde hoy en el proceso manual? (horas/semana en Excel, errores de digitación al mes, mora atribuible a falta de seguimiento) | El doc afirma el problema pero **no da un solo número**; Q5 exige número + dirección | ✅ **CERRADA** — `C-06`: *"siempre ha sido digital"* — **no existe línea base de esfuerzo manual**. La respuesta es que la pregunta no aplica. Q5, Q6, Q10 | **P0** |
| **OQ-B-7** | Define 3–5 métricas de éxito con estado actual, meta y método de medición | La tabla de Q10 no se puede llenar con el insumo | ⬜ **ABIERTA** — `C-07`: *"por la cantidad de suscriptores"* — no es medible. `V-22` quedó **sin responder**. Q10 | **P0** |
| **OQ-B-8** | ¿Por qué **ahora**? ¿Hay una fecha límite dura (contrato, temporada, fin de licencia de TryController)? | Ausente | ✅ **CERRADA** — `C-09`: fecha deseable pero flexible. **No hay fecha límite dura.** Q7 | **P0** |
| **OQ-B-9** | ¿Presupuesto y equipo real? El chat de NotebookLM plantea "1 desarrollador junior, 16 h/semana, 3–4 meses". ¿Es ese el escenario real? | Turno 4 del chat; no confirmado como decisión | 🟡 **PARCIAL** — **Equipo cerrado por `T4`**: 1 desarrollador junior (`CX-27`). **Presupuesto sin declarar** → `OQ-N-40`. Q9, T4 | **P0** |
| **OQ-B-10** | El "MVP" descrito incluye web + móvil offline + WhatsApp API + PIX + motor de reglas + IA. Si hay que recortar, **¿cuál es el orden de sacrificio?** ¿Qué 5 funcionalidades son irrenunciables para la primera versión productiva? | El doc lista todo como MVP; validación de Q14 marca >12 features como "probablemente demasiado" | ✅ **CERRADA** — `C-109` delega la priorización + `V-05` la confirma: **app del cobrador completa + web mínima**. Orden de sacrificio implícito en `D-03`. Q14 | **P0** |
| **OQ-B-11** | ¿Qué queda **explícitamente fuera** del MVP y para qué fase? | Ninguna fuente excluye nada — riesgo alto de scope creep | 🟡 **PARCIAL** — `D-03` + `V-05`: fuera de v1 el asistente IA, reportes avanzados, módulo de facturación y orden geográfico de rutas. ⚠️ **`CX-30` lo contradice**: si el plan básico incluye IA, la IA no puede estar fuera. Q16 | **P0** |
| **OQ-B-12** | ¿El sistema **reemplaza** TryController o convive con él durante una transición? | El doc dice "mejorando las funcionalidades existentes en TryController", ambiguo | ✅ **CERRADA** — `C-08` + `V-10`: **reemplaza** TryController, pero **convive temporalmente** — los históricos se consultan allí mientras haga falta. Q1, tipo de proyecto | **P0** |
| **OQ-B-13** | ¿Hay que **migrar datos históricos** (clientes, préstamos vivos, saldos) desde Excel/TryController? ¿Se puede exportar de TryController? | Determina si el proyecto es "nuevo desde cero" o "migración" | ✅ **CERRADA** — `V-10` (A + B): préstamos vivos digitados a mano; **se pide formalmente la exportación al proveedor** antes de decidir sobre el histórico. Tipo de proyecto, QB1/QB2 | **P0** |
| **OQ-B-14** | ¿Qué es exactamente un "**Socio**" y qué ve? Recibe un reporte diario por WhatsApp, pero ¿entra al sistema? | Doc fuente §6; reporte 01 lo lista como rol | ✅ **CERRADA** — `V-24` + `V-34` + `C-81`: el **socio** es **solo lectura** — estadísticas, clientes que pagaron o no, atrasos. **Puede consultar la auditoría** (`V-34`) y recibe el reporte que el administrador le envíe (`C-81`). Q8, CX-6 | P1 |
| **OQ-B-15** | ¿Cuáles son los riesgos que ya identificas (regulatorios, de fraude interno, de adopción por los gestores, de dependencia de WhatsApp)? | Q17 no tiene insumo | ✅ **CERRADA** — El cliente identificó los suyos: `C-110` (que las cuentas no cuadren; caída en momento crítico), `V-06`/`V-29` (informalidad → sin API de WhatsApp), `V-49` (políticas de tiendas). **`CX-33` es el mayor y lo declaró él mismo.** Q17 | P1 |
| **OQ-B-16** | ¿Qué capacidades has considerado pero decides **no comprometer** todavía (ej. scoring crediticio automático, portal para el cliente final, pagos con tarjeta)? | Q13 sin insumo | 🟡 **PARCIAL** — `V-52`: instancia separada **posible como premium, no prevista**. `V-54`: tarjetas **no entendidas, pendientes de explicación**. Scoring automático y portal del cliente final **nunca se abordaron**. Q13 | P2 |
| **OQ-B-17** | ¿Existe un competidor/benchmark además de TryController? ¿Por qué no seguir usando TryController y ya? | Ausente | ⬜ **ABIERTA** — Nunca se respondió por qué no seguir con TryController más allá de la falta de exportación (`CX-20`) y de control antifraude. **Sin benchmark declarado.** Q6, Q7 | P2 |
| **OQ-B-18** | El **cobro por el uso del software** (D-01), ¿entra en el MVP o en la fase 1 se factura por fuera (transferencia/factura manual) y el módulo llega después? | Nace de D-01. Determina si hay que integrar una pasarela desde el día 1 o no | 🟡 **PARCIAL** — ⚠️ **Contradicción nueva**: `D-03` deja el **módulo de facturación fuera de v1**, pero `V-51` elige **autoservicio — la empresa se registra sola, paga y empieza**, lo que exige facturación **en v1**. Ver `OQ-F-104`. Q14, Q16 | **P0** 🆕 |

[Answer]:

---

## 5. Funcional — `OQ-F`

El insumo describe **qué pantallas existen**, casi nunca **qué hace el sistema con los números**.
Este bloque es el que cierra el 100% funcional.

### F1 · Identidad, roles y estructura organizativa

| ID | Pregunta | Evidencia / brecha | Prio |
|---|---|---|---|
| **OQ-F-1** | Lista exacta de roles y matriz de permisos por módulo (crear/leer/editar/eliminar/aprobar) | El doc sólo dice "Roles. Permisos."; ver CX-6 | 🟡 **PARCIAL** — `V-04` (no hay supervisor), `V-24` (cobrador=app, admin=web, socios=lectura), `V-34`, `V-36` (admin bloquea al cobrador). **La matriz exacta por módulo sigue sin escribirse**, y `CX-34` la bloquea. **P0** |
| **OQ-F-2** | Jerarquía: ¿Empresa → Unidad/Ruta → Gestor → Cliente? ¿Una unidad puede tener varios gestores? ¿Un gestor varias unidades? | Los webinars asumen 1 unidad = 1 dispositivo = 1 trabajador, nunca se afirma | ✅ **CERRADA** — `V-09`: **Empresa → cobros/rutas → clientes**. ~5 rutas por empresa, ~40 clientes por ruta. **P0** |
| **OQ-F-3** | ¿Cómo se asignan clientes a un gestor: manual, por zona geográfica, por unidad? ¿Se pueden reasignar en caliente? | "Cada gestor visualizará únicamente clientes asignados" (§3.5), sin decir cómo se asignan | 🟡 **PARCIAL** — `C-80`: *"cada cliente debe estar asociado al número de la ruta"*. **La reasignación en caliente no se abordó.** **P0** |
| **OQ-F-4** | ¿Un administrador puede operar varias unidades? ¿Hay rol supervisor intermedio? | Ausente | 🟡 **PARCIAL** — `V-10`: *"cada administrador que delega el suscriptor puede encargarse de ese tema"*. `V-04` elimina el supervisor pero `V-02`/`V-17` lo reintroducen → `CX-34`. P1 |
| **OQ-F-5** | Recuperación de contraseña: ¿por qué canal? Los gestores en campo pueden no tener correo electrónico | §3.1 pide "recuperación de contraseña" sin canal | ✅ **CERRADA** — `V-38` (A): **el administrador la restablece desde la web y se la comunica**. No hace falta correo para el cobrador. P1 |

### F2 · Clientes y KYC

| ID | Pregunta | Evidencia / brecha | Prio |
|---|---|---|---|
| **OQ-F-6** | ¿Qué campos son obligatorios exactamente? La guía dice documento, primer nombre, primer apellido, celular, ciudad, dirección. ¿Se confirma esa lista? | Guía §1 vs doc fuente §3.3 (listas distintas) | 🟡 **PARCIAL** — `V-41` fija los obligatorios de la **venta** (documento de identidad + comprobante de residencia). **Los del perfil de cliente siguen sin confirmarse campo por campo.** **P0** |
| **OQ-F-7** | ¿Puede existir el mismo cliente en dos unidades? ¿El documento de identidad es único global o por tenant? | Crítico para el modelo de datos; ausente | ⬜ **ABIERTA** — Nunca se preguntó si el documento es único global o por tenant. **Relevante bajo LGPD y para `OQ-F-103`** (bloqueo de cliente entre tenants). **P0** |
| **OQ-F-8** | ¿El sistema valida el documento contra alguna fuente externa (registro civil, buró de crédito)? | El doc no menciona validación externa | ⬜ **ABIERTA** — Sin respuesta. `V-30` sugiere que no hay validación externa ni interés en ella. P1 |
| **OQ-F-9** | Fotos: máx. 5 en el perfil del cliente — ¿y en la venta? ¿Tamaño máximo, compresión, se pueden borrar, quién puede borrarlas? | Ver CX-9 | ✅ **CERRADA** — `V-41`: **máximo 5 archivos por venta**, 2 obligatorios; **borrables cuando el cliente renueva**. El cobrador puede borrar para liberar espacio (`V-48`). P1 |
| **OQ-F-10** | GPS: ¿se captura una vez al registrar o en cada visita? ¿Se valida por geocerca que el gestor esté físicamente donde dice? | §3.3 pide "Ubicación GPS", §3.5 pide "GPS" en cobranza; no se define el uso | ✅ **CERRADA** — `V-14`: **GPS descartado** — la mayoría paga por PIX y el cobrador no visita; las rutas cubren pueblos visitados día de por medio. P1 |
| **OQ-F-11** | "Referencias" / codeudores: ¿son sólo texto o entidades con seguimiento propio? ¿Se les notifica en mora? | Guía §1 los menciona como contactos | ⬜ **ABIERTA** — Codeudores y referencias nunca se abordaron. P1 |
| **OQ-F-12** | ¿Se puede eliminar un cliente? ¿Qué pasa con su historial y con la exigencia de auditoría? | Ausente; choca con la política de auditoría total | 🟡 **PARCIAL** — `V-33`: los montos **no se modifican**. `V-17`: el cliente se **bloquea**, no se elimina. **El borrado por LGPD (`OQ-F-100`) sigue sin diseñarse.** P1 |

### F3 · Préstamos: matemática financiera ← **el mayor vacío del insumo**

| ID | Pregunta | Evidencia / brecha | Prio |
|---|---|---|---|
| **OQ-F-13** | **¿Cómo se calcula el interés?** ¿Fijo sobre el capital (`total = capital × (1+i)`), sobre saldo insoluto, o tabla francesa? El webinar habla de "interés base" y nada más | **Ninguna fuente da la fórmula.** Sin esto no se puede construir el producto | ✅ **CERRADA** — `C-10` + `V-08`: **interés fijo sobre el capital**. Ejemplo verificado: 1.000 al 10 % en 10 días → 10 cuotas de 110. **P0** |
| **OQ-F-14** | ¿El interés se define por préstamo, por unidad, o por producto configurable? ¿Hay topes legales de tasa? | Ausente | ✅ **CERRADA** — `V-08`: **rango configurable por el administrador**, 20 % por defecto, lo fija quien hace la venta. `V-30`: **sin tope legal — el sistema no avisa ni bloquea**. **P0** |
| **OQ-F-15** | ¿Cómo se calcula el **cronograma** en frecuencia diaria? ¿Se cobran domingos? ¿Festivos? ¿Qué calendario por país? | §3.4 lista "Diario" sin reglas de calendario | ✅ **CERRADA** — `C-12`: **lunes a sábado**; domingos y festivos no se cobra y **se corre al día siguiente** sin acumular. `V-44` confirma el domingo como día sin operación. **P0** |
| **OQ-F-16** | ¿Qué es exactamente la modalidad "**Libre**"? ¿Sin cronograma, sólo saldo e interés periódico? | Ver CX-7 | ✅ **CERRADA** — `C-13`: **"LA MODALIDAD LIBRE NO APLICA"** — eliminada del catálogo. **P0** |
| **OQ-F-17** | ¿Existe **interés de mora**? ¿Cómo se calcula y desde qué día? | El sistema "registra mora" pero nunca dice si la cobra | ✅ **CERRADA** — `D-02`: **no hay interés de mora**. **P0** |
| **OQ-F-18** | ¿Cuántos días de atraso convierten un préstamo en "moroso"? ¿Y en "cartera castigada"? | "Días de atraso" se envía por WhatsApp, pero el umbral no está definido | 🟡 **PARCIAL** — `V-17`: el paso a castigada es **manual**, tras verificación y decisión del administrador. **No se fijó un número de días.** **P0** |
| **OQ-F-19** | Redondeo: ¿a cuántos decimales? ¿Cómo se reparte el residuo entre cuotas (última cuota ajusta)? | Ausente; fuente clásica de descuadres de caja | ✅ **CERRADA** — `V-16` (A): cuotas iguales a **2 decimales**, **la última ajusta la diferencia**. P1 |
| **OQ-F-20** | ¿Hay cobros adicionales: comisión de apertura, seguro, papelería? | Ausente | ⬜ **ABIERTA** — Comisión de apertura, seguro y papelería nunca se abordaron. P1 |
| **OQ-F-21** | ¿El valor de la cuota puede editarse manualmente al crear la venta? | Los webinars sugieren que se configura valor, interés y nº de cuotas | ✅ **CERRADA** — `V-08`: **el sistema calcula la cuota**. Lo editable es el **%** y el **nº de cuotas**, y solo en venta nueva o renovación. P1 |

### F4 · Ciclo de vida del préstamo

| ID | Pregunta | Evidencia / brecha | Prio |
|---|---|---|---|
| **OQ-F-22** | Lista cerrada de **estados** del préstamo y transiciones permitidas (temporal → activo → al día / en mora / castigado / cancelado / renovado / refinanciado) | El insumo nombra estados sueltos, nunca la máquina de estados | 🟡 **PARCIAL** — `C-27` + `V-12` (renovado = marca informativa) + `V-17` (castigada) + `C-32` (temporal eliminada). **La lista cerrada de estados y sus transiciones sigue sin escribirse.** **P0** |
| **OQ-F-23** | **Renovación**: ¿el saldo pendiente del préstamo anterior se descuenta del nuevo desembolso? ¿Se puede renovar con saldo en mora? ¿Se exige % pagado mínimo? | La guía §4 sólo dice que se actualizan datos del cliente | ✅ **CERRADA** — `V-12`: para renovar el préstamo anterior **debe quedar en 0**; el cobrador reenvía la venta y el administrador aprueba. **No se puede renovar con saldo.** **P0** |
| **OQ-F-24** | **Refinanciación**: ¿en qué se diferencia de la renovación? ¿Qué pasa con los intereses ya causados? | §3.4 lista ambas sin distinguirlas | ⬜ **ABIERTA** — La refinanciación nunca se diferenció de la renovación. **P0** |
| **OQ-F-25** | **Cancelación anticipada**: ¿se cobra el interés completo pactado o sólo el causado? | Ausente; impacto directo en el dinero | ✅ **CERRADA** — `D-02`: **no hay descuento por pago anticipado** — se cobra el interés pactado completo. **P0** |
| **OQ-F-26** | "**Venta temporal**" y "**preventa / enviar a estudio**": ¿son lo mismo o dos flujos distintos? ¿El MVP incluye estudio de crédito y quién lo hace? | Los webinars los describen como dos cosas distintas | 🟡 **PARCIAL** — `C-32` elimina la venta temporal. **Preventa / envío a estudio sigue sin aclararse**; `V-18` describe un flujo de autorización que podría ser lo mismo. P1 |
| **OQ-F-27** | ¿Cuánto vive una venta temporal antes de expirar? | Ausente | ✅ **CERRADA** — Sin objeto: `C-32` eliminó la venta temporal. P2 |
| **OQ-F-28** | **Cartera castigada**: ¿el paso a castigada es manual o automático por días de mora? ¿Se sigue causando interés? | Guía §3: es una acción manual del admin | 🟡 **PARCIAL** — `V-17`: manual, con bloqueo del cliente. **Falta si se sigue causando interés** (probablemente no, por `OQ-F-17`) y el alcance del bloqueo → `OQ-F-103`. P1 |
| **OQ-F-29** | Edición de venta: la guía la permite "sólo el mismo día y sin movimientos". ¿Se mantiene esa regla? ¿Y quién puede anular una venta ya con movimientos? | Guía §6 (FAQ) | ✅ **CERRADA** — `V-33`: *"los montos no se pueden modificar por ningún motivo… la única modificación es que el cobrador ingrese pagos"*. **Refuerza el ledger append-only de `T14`.** P1 |

### F5 · Registro de pagos

| ID | Pregunta | Evidencia / brecha | Prio |
|---|---|---|---|
| **OQ-F-30** | ¿Se aceptan **pagos parciales** (menos que la cuota)? Si sí, ¿cuál es el **orden de imputación**: mora → interés → capital, u otro? | La secuencia de §4 asume "descontar la cuota" completa. Es la regla financiera más peligrosa si queda implícita | ✅ **CERRADA** — `D-02`: se aceptan pagos parciales con **contador fraccionario de cuota**. Implementado en `allocate_payment` (`T27`). **P0** |
| **OQ-F-31** | **Abono extraordinario a capital**: ¿reduce el número de cuotas o el valor de cada cuota? | Ausente | ⬜ **ABIERTA** — El abono extraordinario a capital nunca se abordó. **Con interés fijo sobre capital (`V-08`) probablemente no aplica**, pero hay que confirmarlo. **P0** |
| **OQ-F-32** | Pago adelantado de N cuotas: ¿hay descuento por pronto pago? El límite de cuotas adelantadas, ¿es por unidad o por cliente? | Guía §4 explica el límite pero no el efecto financiero | ✅ **CERRADA** — `D-02`: sin descuento por pronto pago. `V-18`: **a partir de la cuota 5 el cobrador necesita llave** para registrar pagos — ese es el límite de adelanto. P1 |
| **OQ-F-33** | ¿Se puede **reversar / anular** un pago mal registrado? ¿Quién, hasta cuándo, y cómo se refleja en caja y en el WhatsApp ya enviado al cliente? | Ausente. Con notificación automática ya disparada, esto es un problema real | 🟡 **PARCIAL** — `T14` fija el mecanismo: **asiento compensatorio, nunca edición**. **Falta quién puede hacerlo, hasta cuándo, y qué se le dice al cliente que ya recibió el mensaje.** **P0** |
| **OQ-F-34** | **PIX**: ~~¿hay integración real con el banco?~~ **Resuelta en parte por D-01: el sistema no recibe el dinero, sólo registra la información del PIX.** Residual: ¿el registro es siempre manual (el gestor teclea titular y monto), o se admite una **conciliación de solo lectura** contra el extracto del banco como mejora posterior? | Todas las fuentes sólo piden "Nombre del titular" ⇒ manual. D-01 elimina la parte cara de la pregunta: ya no es una decisión de alcance mayor | 🟡 **PARCIAL** — `D-01`: el sistema **solo registra la información**, no recibe dinero. ⚠️ `V-14` revela que **la mayoría de los pagos son PIX** → `CX-35`. **Sin conciliación bancaria declarada.** P1 ⬇ |
| **OQ-F-35** | ¿Qué otros medios de pago debe poder **registrar** el sistema (transferencia, tarjeta, corresponsal, giro)? Ojo: registrar el dato, no procesarlo (D-01) | Sólo Dinero y PIX | 🟡 **PARCIAL** — `V-14`: efectivo y **PIX**. Otros medios sin declarar. P1 |
| **OQ-F-36** | "**No pago**": ¿hay catálogo de motivos? ¿Requiere foto o GPS obligatorio? | §3.5 lo lista sin detalle | ⬜ **ABIERTA** — Catálogo de motivos de "no pago" nunca se definió. `V-42` sí alerta sobre **muchos "no pago" seguidos**, lo que presupone que el motivo se registra. P1 |
| **OQ-F-37** | **Promesa de pago**: ¿genera una tarea, cambia el estado, se le hace seguimiento automático? | §3.5 lo lista sin comportamiento | ⬜ **ABIERTA** — La promesa de pago nunca se abordó. P1 |
| **OQ-F-38** | **Comprobante digital** del cobro: ¿formato (PDF/imagen/texto), numeración consecutiva, valor fiscal? Por D-01 es un **recibo de constancia** de un cobro hecho fuera del sistema, no un comprobante de pago procesado — confirmar que basta con eso | §4 dice "generar comprobante" sin especificar | ✅ **CERRADA** — `V-07` (A) confirma la propuesta + `D-01`: es un **recibo de constancia**, sin valor fiscal. P1 |

### F6 · Llaves y autorizaciones

| ID | Pregunta | Evidencia / brecha | Prio |
|---|---|---|---|
| **OQ-F-39** | ¿Qué operaciones exigen llave? Confirmado: venta sobre el límite y pago de más de N cuotas. ¿Alguna más (edición, anulación, descuento)? | Guía §2 y §4 | ✅ **CERRADA** — `V-18`: **toda venta a un cliente por primera vez** requiere autorización, y **a partir de la cuota 5** hace falta llave para registrar pagos. **P0** |
| **OQ-F-40** | ¿La llave **expira**? ¿Es de un solo uso? ¿Sirve para otra venta distinta a la solicitada? | Ausente — hueco de control interno | ⬜ **ABIERTA** — Expiración y unicidad de la llave sin declarar. **Crítico**: una llave reutilizable anula el control. **P0** |
| **OQ-F-41** | ¿Quién puede aprobar una llave? ¿Puede el mismo usuario solicitar y aprobar? ¿Hay tope por encima del cual ni el admin puede aprobar? | Ausente | 🟡 **PARCIAL** — `V-18`: *"el administrador o encargado"*. **No se declaró si quien solicita puede aprobar** — y esa es justamente la segregación que el producto existe para imponer (`C-99`). **P0** |
| **OQ-F-42** | ¿Qué pasa si el gestor está **sin conexión** cuando necesita una llave? ¿Puede operar con llave manual offline? | El flujo descrito asume conectividad; choca con el modo offline de §9 | ⬜ **ABIERTA** — 🔴 **Sin resolver, y es crítico.** `C-65` exige trabajo offline y `V-18` exige llave a partir de la cuota 5. **Si no hay señal, el cobrador no puede pedir llave y no puede registrar pagos.** **P0** |
| **OQ-F-43** | Longitud, formato y aleatoriedad del código | Ver CX-2 | ✅ **CERRADA** — `V-18`: *"puede ser de 4 dígitos"*. P1 |
| **OQ-F-44** | ¿El "ID de llave" es visible para el trabajador y para el auditor? ¿Se puede buscar por él? | Guía §3 distingue ID de llave vs código | ⬜ **ABIERTA** — Sin declarar. P2 |

### F7 · Caja, gastos y consignaciones

> **Nota D-01:** el efectivo y el PIX se mueven **fuera del sistema**. Estas cajas son un
> **registro contable de lo que ocurrió en la calle**, no saldos custodiados por la plataforma.
> Eso **no relaja ni un requisito**: al ser la única evidencia de ese dinero, el cuadre y la
> trazabilidad siguen siendo críticos.

| ID | Pregunta | Evidencia / brecha | Prio |
|---|---|---|---|
| **OQ-F-45** | ¿Hay una caja **por gestor** y otra **general por unidad**, más una **caja PIX** separada? ¿Cómo se relacionan exactamente? | §4 menciona las tres; la relación no se define | ⬜ **ABIERTA** — `V-26` **diferida a llamada**: *"te lo explico por llamada"*. Es el circuito del dinero completo. **P0** |
| **OQ-F-46** | ¿Quién abre y cierra la caja, y cuándo? ¿Puede haber más de una caja abierta por unidad al tiempo? | Los webinars hablan de "caja abierta/cerrada" sin definir el ciclo | 🟡 **PARCIAL** — `V-03`: **el cobrador cierra con señal**; sin señal por más de 24 h, **el administrador puede forzar el cierre**. **Falta la apertura y si puede haber varias cajas abiertas.** **P0** |
| **OQ-F-47** | **¿Qué pasa si el conteo físico no cuadra con el sistema?** ¿Se registra un faltante/sobrante? ¿Bloquea el cierre? ¿Quién autoriza la diferencia? | Ausente. Es la pregunta operativa nº1 de cualquier sistema de caja | ✅ **CERRADA** — `V-02`: **se puede cerrar descuadrado**; el sistema **genera alerta al administrador** y al día siguiente se verifica. Si el faltante es del cobrador, **se le descuenta del sueldo el sábado** → `OQ-F-101`. **P0** |
| **OQ-F-48** | **Consignación**: ¿cómo se registra la entrega del efectivo del gestor a la empresa/banco? ¿Requiere comprobante y confirmación de la contraparte? | §3.6 la lista como concepto suelto | ⬜ **ABIERTA** — `V-26` diferida a llamada. **P0** |
| **OQ-F-49** | **Gastos**: ¿catálogo de categorías? ¿Requieren aprobación o soporte fotográfico? ¿Hay tope diario? | §3.6 sólo dice "Gastos" | 🟡 **PARCIAL** — `V-05`: **aprobar gastos** entra en la web mínima. **Catálogo, topes y soporte fotográfico sin declarar.** P1 |
| **OQ-F-50** | "**Dinero pendiente**" en el cierre: ¿qué es exactamente — recaudo no consignado, o cuotas no cobradas? | Aparece en §5 sin definición | ⬜ **ABIERTA** — `V-26` diferida a llamada. **P0** |
| **OQ-F-51** | ¿El desembolso de un préstamo nuevo sale de la caja del gestor? ¿Puede un gestor desembolsar sin efectivo disponible? | Implícito en "no afecta caja" de la venta temporal, nunca explícito | 🟡 **PARCIAL** — `C-52`/`C-53`: el cobrador **usa el efectivo recaudado** para prestar, gasolina y sueldos. **El detalle queda para la llamada `V-26`.** **P0** |

### F8 · Cierre de caja y reportes

| ID | Pregunta | Evidencia / brecha | Prio |
|---|---|---|---|
| **OQ-F-52** | **¿Puedes compartir el archivo Excel real que hoy se usa para el cierre?** El requisito es "un reporte idéntico al formato actual" — sin el archivo, ese requisito no es verificable | §5 lo exige explícitamente; el archivo no está en el insumo | ⬜ **ABIERTA** — 🔴 **Pedido dos veces y no entregado.** `C-57`: *"sí, lo adjunto"* — no venía. `V-25`: *"te lo explico por llamada"*. **El requisito exige un reporte "idéntico al formato actual" y sin el archivo no se puede construir ni verificar.** **P0** |
| **OQ-F-53** | ¿Se puede reabrir/corregir un cierre ya hecho? ¿Quién y con qué rastro? | Ausente | 🟡 **PARCIAL** — `V-02` implica revisión al día siguiente, pero **no dice si el cierre se reabre o se corrige con un asiento nuevo**. `T14` obliga a lo segundo. P1 |
| **OQ-F-54** | ¿El cierre es por unidad, por gestor o consolidado por empresa? | §5 no lo dice | 🟡 **PARCIAL** — `V-09` da la jerarquía; **el nivel de consolidación del cierre no se declaró explícitamente**. **P0** |
| **OQ-F-55** | Los 9 reportes de §3.7: ¿cuáles son MVP y cuáles fase 2? ¿Qué filtros y periodos necesita cada uno? | Se listan sin priorizar ni especificar | 🟡 **PARCIAL** — `V-39`: solo nombra **"reporte diario"** de los 9. **Filtros y periodos sin declarar.** P1 |
| **OQ-F-56** | "Movimiento contable" / "asiento contable automático": ¿se requiere contabilidad de partida doble real o es sólo un registro de movimientos? ¿Se integra con algún software contable? | §4 dice "registrar el movimiento contable"; el reporte 01 lo llama "asiento contable". Diferencia enorme de alcance | 🟡 **PARCIAL** — `T14` fija un **ledger append-only con asientos compensatorios** — no partida doble contable. `V-35` confirma que el objetivo es la confianza de los socios, no la contabilidad formal. **P0** |

### F9 · WhatsApp y notificaciones

| ID | Pregunta | Evidencia / brecha | Prio |
|---|---|---|---|
| **OQ-F-57** | ¿Qué proveedor de WhatsApp Business API: Meta Cloud API directo, Twilio, 360dialog, otro? ¿Ya hay cuenta y número verificado? | §6 sólo dice "WhatsApp Business API" | ⬜ **ABIERTA** — 🔴 **`CX-33`**: la pregunta ya no es qué proveedor, sino **si los suscriptores pueden tener cuenta**. `V-06`: no son empresas formales. **P0** |
| **OQ-F-58** | Las plantillas de mensaje deben ser **aprobadas por Meta** y hay una ventana de 24 h para mensajes libres. ¿Se han redactado las plantillas? ¿Quién gestiona la aprobación? | El insumo asume envío libre; no es como funciona la API | ⬜ **ABIERTA** — Bloqueada por `CX-33`. Además `CX-32` decide el **idioma** de las plantillas. **P0** |
| **OQ-F-59** | **Consentimiento (opt-in)**: ¿cómo se obtiene y registra el permiso del cliente para recibir mensajes? Es requisito de Meta y de la ley de datos | Ausente por completo | ⬜ **ABIERTA** — El opt-in nunca se abordó. **Es requisito de Meta y de LGPD** (`T21`). **P0** |
| **OQ-F-60** | ¿Qué pasa si el cliente **no tiene WhatsApp** o el envío falla? ¿Hay fallback (SMS) y reintentos? | Ausente | ⬜ **ABIERTA** — Bloqueada por `CX-33`. `C-79` solo dice que un envío fallido **se registra como fallido**; no hay fallback. P1 |
| **OQ-F-61** | ¿El cliente puede **responder**? ¿Alguien lee esas respuestas? | Ausente | ✅ **CERRADA** — `C-80`: las respuestas **llegan al cobrador asignado**. P1 |
| **OQ-F-62** | El reporte diario a socios: ¿a qué hora, a qué números, y qué pasa si la caja aún no ha cerrado? | §6 dice "todos los días" | 🟡 **PARCIAL** — `C-81`: al día siguiente antes de abrir caja, el administrador elige destinatarios, puede ser semanal. ⚠️ **Canal contradictorio**: `CX-29` Telegram, `V-42` WhatsApp → `CX-37`. P1 |
| **OQ-F-63** | Notificaciones **push** al gestor (aprobación de llave): ¿FCM/APNs? ¿Y si el teléfono está sin datos? | Guía §2 asume push funcionando | ✅ **CERRADA** — `T11`: **Firebase Cloud Messaging** vía Expo. Sin datos, el aviso llega cuando el teléfono recupere red. P1 |

### F10 · Motor de reglas

| ID | Pregunta | Evidencia / brecha | Prio |
|---|---|---|---|
| **OQ-F-64** | ¿El motor es **configurable por el administrador desde una UI**, o son reglas fijas que programa el equipo? El insumo usa "configurable" pero todos los ejemplos son fijos | §7. Diferencia de esfuerzo de ~10x | ⬜ **ABIERTA** — El motor de reglas configurable nunca se abordó con el cliente. **P0** |
| **OQ-F-65** | Si es configurable: catálogo cerrado de eventos disponibles, condiciones y acciones | Sólo hay 3 ejemplos | ⬜ **ABIERTA** — Depende de `OQ-F-64`. P1 |
| **OQ-F-66** | ¿Puede una regla disparar otra? ¿Cómo se evitan ciclos? ¿Hay log de ejecución de reglas? | Ausente | ⬜ **ABIERTA** — Depende de `OQ-F-64`. P1 |

### F11 · Asistente de IA

| ID | Pregunta | Evidencia / brecha | Prio |
|---|---|---|---|
| **OQ-F-67** | ¿La IA es MVP o fase 2? Es la funcionalidad más cara y la única que no bloquea la operación diaria | §8; el MVP de §2 no la excluye | ⬜ **ABIERTA** — 🔴 **Contradictoria**: `C-108` el cliente marcó *"la IA puede esperar"*; `CX-30` dice que **el plan básico la incluye**. `V-21` (planes) quedó **sin responder**, que era justo lo que lo habría resuelto. **P0** |
| **OQ-F-68** | ¿El asistente sólo **consulta** o también **ejecuta acciones** (registrar pagos, aprobar llaves)? | §8 sólo muestra preguntas de consulta | ⬜ **ABIERTA** — Sin abordar. Reactivada por `CX-30`. **P0** |
| **OQ-F-69** | ¿Se acepta enviar datos financieros y personales de clientes a un proveedor externo de LLM? ¿O debe ser un modelo autoalojado? | Choca con las exigencias de privacidad de §11; nunca se aborda | ⬜ **ABIERTA** — Sin abordar. `V-31` (*"no tenemos preferencia"* de residencia) **no autoriza enviar datos a un LLM externo** — son cosas distintas. **P0** |
| **OQ-F-70** | Las cifras que da la IA, ¿deben ser exactas y trazables (consulta SQL determinista) o se acepta lenguaje natural aproximado? En un sistema de dinero, un número inventado es inaceptable | Ausente. Define la arquitectura: text-to-SQL vs RAG | ⬜ **ABIERTA** — Sin abordar. **En un sistema de dinero, un número inventado es inaceptable.** **P0** |
| **OQ-F-71** | "**Detección de fraude**" y "detección de riesgo": ¿qué patrones concretos? ¿Hay datos históricos etiquetados para entrenar o evaluar? | §8 lo lista sin definir una sola señal | ⬜ **ABIERTA** — `V-28` **diferida a llamada**. P1 |
| **OQ-F-72** | ¿Quién puede usar el asistente y ve datos de qué alcance (su unidad vs toda la empresa vs todos los tenants)? | Ausente; riesgo de fuga entre tenants | ⬜ **ABIERTA** — Sin abordar. Riesgo de fuga entre tenants. **P0** |
| **OQ-F-73** | "Recomendar estrategias de cobranza": ¿es una recomendación informativa o dispara acciones automáticas? | §8 | ⬜ **ABIERTA** — Sin abordar. P1 |

### F12 · App móvil, offline y dispositivos

| ID | Pregunta | Evidencia / brecha | Prio |
|---|---|---|---|
| **OQ-F-74** | ¿Qué operaciones se permiten **exactamente** sin conexión: registrar pago, no pago, visita, foto, firma… y **crear una venta nueva**? | §9 dice "modo offline" sin delimitar. Crear ventas offline choca con el sistema de llaves | 🟡 **PARCIAL** — `C-65` + `V-03`: se trabaja sin señal toda la jornada, pero **hace falta señal para cerrar la caja**. **La lista exacta de operaciones offline —en especial si se puede crear una venta nueva— sigue sin declararse**, y `V-18` la condiciona (toda primera venta requiere autorización). **P0** |
| **OQ-F-75** | **Resolución de conflictos**: si el admin modifica un préstamo en la web mientras el gestor registra pagos offline sobre él, ¿quién gana al sincronizar? | Ausente. Es el problema técnico más difícil del proyecto | 🟡 **PARCIAL** — `T14` fija **orden por agregado** y que el servidor valida intenciones. `V-33` reduce el problema: **el admin no puede modificar montos**, así que casi no hay conflicto posible. **P0** |
| **OQ-F-76** | ¿Cuánto tiempo puede operar un dispositivo sin sincronizar antes de bloquearse? | Ausente | ✅ **CERRADA** — `V-03`: **24 horas**. Pasado ese plazo el administrador puede forzar el cierre con lo cargado. **P0** |
| **OQ-F-77** | Los pagos registrados offline, ¿afectan la caja en el momento del registro o al sincronizar? ¿Con qué fecha quedan? | Contradice la secuencia inmediata de §4 | 🟡 **PARCIAL** — `V-03` describe el flujo pero **no fija con qué fecha queda el movimiento**. `T27` ya separa `occurred_at` (teléfono) de `recorded_at` (servidor); **falta cuál manda para la caja**. **P0** |
| **OQ-F-78** | Al **desvincular un dispositivo**, ¿qué pasa con los movimientos locales aún no sincronizados? ¿Se pierden? ¿Se borran los datos del teléfono en remoto? | La guía §5 sólo dice que se bloquea el acceso. **Riesgo de pérdida de dinero registrado** | ⬜ **ABIERTA** — = `OQ-F-99`, sigue abierta. `V-36` confirma que el administrador **debe poder bloquear al cobrador**, lo que hace el caso más probable. **P0** |
| **OQ-F-79** | ¿Se mantiene la regla "1 unidad = 1 dispositivo"? ¿Qué pasa si el gestor cambia de teléfono en medio de la jornada? | Guía §5 | ✅ **CERRADA** — `C-70` + `V-36`: **un dispositivo por ruta**, confirmado como requisito de negocio contra el **robo de cartera**. P1 |
| **OQ-F-80** | La sincronización manual "**UGI**" ¿es un requisito heredado que hay que replicar, o un defecto de TryController que este sistema debe eliminar? | Ver CX-4. Determina toda la arquitectura de sincronización | ✅ **CERRADA** — `V-13`: el cliente pide **sincronización automática y continua** cada vez que haya internet. **La sincronización manual heredada desaparece.** **P0** |
| **OQ-F-81** | **Firma digital**: ¿firma dibujada en pantalla como imagen, o firma electrónica con validez legal (certificado, sello de tiempo)? | §3.5 dice "firma digital"; los dos significados difieren radicalmente en costo y regulación | ⬜ **ABIERTA** — Nunca se aclaró si la firma es imagen o firma electrónica con validez legal. **P0** |
| **OQ-F-82** | "**Generar contrato**" (§7): ¿plantilla legal por país? ¿Se firma en el móvil? ¿Se archiva y se envía al cliente? | Mencionado una sola vez, sin desarrollo | ⬜ **ABIERTA** — Sin abordar. `V-29` (*"alegal"*) sugiere que no hay plantilla legal por país. **P0** |
| **OQ-F-83** | **Seguro de repatriación**: ¿sólo se capturan datos, o hay integración con una aseguradora? ¿Es MVP? | Guía §5; el doc de requerimientos **no lo menciona en absoluto** | ⬜ **ABIERTA** — Sin abordar. P1 |
| **OQ-F-84** | ¿La app es sólo para gestores o el administrador también la usa? | §9 dice "para gestores" | 🟡 **PARCIAL** — `V-24`: hoy solo cobradores. **Pero el cliente reabre**: *"si es más práctico… se podría hacer también desde la app para el administrador, porque si todo se hace por la app ¿qué sentido tiene la web??"* P2 |

### F13 · Dashboard

| ID | Pregunta | Evidencia / brecha | Prio |
|---|---|---|---|
| **OQ-F-85** | Para cada uno de los 13 indicadores de §3.2: ¿cuál es su **definición de cálculo exacta**? Ejemplo: "utilidad estimada" = ¿interés causado, interés cobrado, o cobrado − gastos? | Se listan nombres, ninguna fórmula | ⬜ **ABIERTA** — `V-27` **diferida a llamada**, incluido el indicador nuevo *"recaudo pretendido"*. **P0** |
| **OQ-F-86** | ¿"Tiempo real" significa al instante o con un refresco de N minutos? ¿Se aceptan datos consolidados con retraso? | §3.2 dice "en tiempo real"; impacta arquitectura y costo | ✅ **CERRADA** — `V-13` (A): **al instante para lo ya sincronizado**, y el tablero avisa qué rutas faltan y desde cuándo. **P0** |
| **OQ-F-87** | ¿El dashboard se filtra por unidad, gestor y rango de fechas? ¿Qué ve cada rol? | Ausente | 🟡 **PARCIAL** — `V-34` pide **búsqueda flexible** (por cliente, día, rango de semanas, mes) y `V-40` los periodos de comparación. **Falta qué ve cada rol.** P1 |
| **OQ-F-88** | "Comparativos diarios": ¿contra el día anterior, el mismo día de la semana pasada, o el promedio? | §3.2 | ✅ **CERRADA** — `V-40`: contra **la meta que fije el administrador**, y además día anterior, semana pasada, mes, trimestre y semestre. P2 |

### F14 · Auditoría

| ID | Pregunta | Evidencia / brecha | Prio |
|---|---|---|---|
| **OQ-F-89** | ¿Se audita **toda** acción incluyendo lecturas/consultas, o sólo escrituras? El volumen cambia por órdenes de magnitud | §11 dice "toda acción realizada" | ✅ **CERRADA** — `V-32`: **solo los cambios**. El cliente descarta registrar consultas: son la herramienta del cobrador para recuperar cartera. **P0** |
| **OQ-F-90** | ¿El log de auditoría debe guardar el **valor anterior y el nuevo** en cada cambio? Los 6 campos listados no incluyen el detalle del cambio | §11 lista usuario/fecha/hora/IP/dispositivo/acción | ✅ **CERRADA** — `V-33`: **no hay "valor nuevo"** porque los montos no se modifican. El antes/después pierde objeto salvo en datos no monetarios. **P0** |
| **OQ-F-91** | ¿Quién puede consultar la auditoría y con qué buscadores/exportación? | Ausente | ✅ **CERRADA** — `V-34` (B): **administrador y socios**. P1 |
| **OQ-F-92** | ¿La auditoría debe ser inalterable incluso para un administrador de base de datos (append-only / WORM)? | Ausente; relevante si hay sospecha de fraude interno | ✅ **CERRADA** — `V-35` (A): **inalterable para todos, incluido el equipo técnico**. *"la idea es que los socios confíen en la información"*. **Confirma `T14` como requisito de negocio.** P1 |

### F15 · Facturación y suscripciones del software 🆕 — **solo web**

Bloque nuevo, abierto por **D-01**. Es el **único lugar del producto donde se mueve dinero real**,
y no existe una sola línea sobre él en el material de entrada. Por decisión explícita, **nunca
aparece en la app móvil**.

| ID | Pregunta | Evidencia / brecha | Prio |
|---|---|---|---|
| **OQ-F-93** | ¿Con qué **medios de pago** se cobra el software: tarjeta recurrente, PIX, boleto, transferencia, débito automático? ¿En qué moneda? | Nace de D-01; nada en el insumo | ⬜ **ABIERTA** — `V-11` fija **dónde** se paga (navegador), no **con qué**. Medio y moneda del cobro del software sin declarar. **P0** |
| **OQ-F-94** | ¿El cobro es **autoservicio** (el tenant se suscribe y paga dentro de la web, con pasarela) o **asistido** (el proveedor emite la factura fuera y un super-admin marca el pago como recibido)? | Es la pregunta que decide si hay o no integración con pasarela | ✅ **CERRADA** — `V-51` (B): **autoservicio** — la empresa se registra sola, paga y empieza. ⚠️ Tensiona con `V-45` y `V-06` → `OQ-F-104`. **P0** |
| **OQ-F-95** | ¿Qué pasa cuando un tenant **no paga**: periodo de gracia, aviso, modo solo lectura, suspensión total, bloqueo de la app móvil de sus gestores? ¿Se conservan sus datos y por cuánto tiempo? | Ausente. Afecta a la operación de cobranza de un tercero, así que no puede improvisarse | ✅ **CERRADA** — `V-20`: **3 avisos** (5 días antes, 1 día antes, el mismo día); si no paga, **al día siguiente el usuario amanece bloqueado** y **no se dejan abrir las cajas**; **30 días** antes de depurar. **P0** |
| **OQ-F-96** | ¿Hay que emitir **documento fiscal** (nota fiscal en Brasil, factura electrónica en Colombia) o basta un recibo? ¿Integración con un emisor fiscal? | Depende del país (`OQ-B-2`). Puede ser un proyecto en sí mismo | ⬜ **ABIERTA** — `V-01` fija **Brasil**, luego la **nota fiscal** es previsible. Nunca se respondió (`C-115` seguía abierta). P1 |
| **OQ-F-97** | ¿Hay **planes**, prueba gratuita, límites por plan (nº de gestores, unidades, préstamos activos), cambios de plan y prorrateo? | Deriva del modelo de cobro (`OQ-B-4`) | ⬜ **ABIERTA** — 🔴 `V-21` **sin responder** — y es la pregunta que habría resuelto `CX-30` (planes escalonados con IA en el básico). P1 |
| **OQ-F-98** | ¿Quién ve el módulo de facturación: sólo el **super-admin del proveedor**, también el **admin del tenant** (su historial y sus facturas), o ambos con vistas distintas? | Ausente; define permisos y pantallas | ⬜ **ABIERTA** — Sin abordar. P1 |
| **OQ-F-99** | Si se **revoca un dispositivo** (robo, despido, sospecha de fraude) que tiene **operaciones sin sincronizar**, ¿qué pasa con ellas: se rechazan, o se aceptan **en cuarentena** para que un administrador las revise una por una? | Surgida en la entrevista técnica (T17). Rechazarlas **destruye registros de dinero que sí ocurrió** — el gestor cobró de verdad y el cliente pagó de verdad. Aceptarlas sin control deja escribir en el libro mayor a un dispositivo ya no confiable. La cuarentena es el punto medio, pero exige pantalla de revisión y una regla de quién decide. **Contradice el espíritu de C-99 (auditoría inmutable) descartar registros en silencio** | ⬜ **ABIERTA** — Sin resolver. `V-36` la hace **más probable**: el administrador debe poder bloquear al cobrador en caliente. **P0** |
| **OQ-F-100** | **Exportación de todos los datos de un titular** (derecho de acceso y portabilidad) | 🆕 2026-08-02 (T21). LGPD art. 18 obliga a entregar al titular todo lo que se guarda sobre él, en formato legible | ⬜ **ABIERTA** — Abierta hoy por `T21`. **Los titulares son los ~1.200 prestatarios, que no son usuarios del sistema** — hace falta también un canal para recibir la solicitud. 🔴 **Funcionalidad que no aparece en ningún requisito del proyecto.** No estaba en el documento de requerimientos, ni en los 3 reportes de NotebookLM, ni en las 117 respuestas del cliente. Toca `clients`, `loans`, `payments`, `ledger_entry`, las **fotos de documento de identidad** en S3 y el registro de auditoría. **Quién es el titular importa**: son los ~1.200 **clientes deudores**, que no son usuarios del sistema y no tienen dónde pedirlo — así que hace falta también **un canal para recibir la solicitud**, no solo el botón que genera el archivo. Define plazo de respuesta, formato y quién la autoriza | **P0** |
| **OQ-F-101** | **Nómina y descuentos al cobrador** | 🆕 2026-08-02 (**V-02**): *"si el descuadre es del cobrador que haya sacado dinero por cuenta de él, **se le debe descontar el día sábado del sueldo**"* | ⬜ **ABIERTA** — Abierta hoy por `V-02`. Funcionalidad que **no aparece en ningún requisito previo**: sueldos de cobradores, ciclo semanal con corte el **sábado**, y descuentos originados por descuadres de caja. Define si el sistema **gestiona nómina** o solo **registra el descuento como movimiento**. Lo segundo es mucho más barato y probablemente suficiente. Toca el ledger (`T14`): un descuento es un asiento más, y como tal **no se edita, se compensa** | P1 |
| **OQ-F-102** | 🔴 **Reingreso manual de operaciones ya enviadas → riesgo de pago duplicado** | 🆕 2026-08-02 (**V-03**): *"los que no quedaron cargados deberá ingresarlos nuevamente, así ese mismo día le ingrese dos o más movimientos al cliente"* | ⬜ **ABIERTA** — Abierta hoy por `V-03`. **P0.** **La idempotencia de T22 y la cola de comandos de T14 protegen contra el reenvío automático de un mismo comando** — misma clave, se detecta y se reproduce. **Pero aquí el reingreso lo hace una persona tecleando de nuevo**, así que **genera una clave de idempotencia distinta y el sistema lo aceptará como un pago nuevo**. Es el camino más directo a un pago duplicado en el ledger, y el ledger **no se edita**: habría que compensarlo. Hace falta un mecanismo de conciliación —mostrar al cobrador qué operaciones del día **sí** llegaron al servidor antes de dejarle reingresar, o detectar candidatos a duplicado por (cliente, monto, fecha) y pedir confirmación explícita | **P0** |
| **OQ-F-103** | **Cartera castigada y bloqueo de cliente** | 🆕 2026-08-02 (**V-17**): *"enviarlo a cartera castigada para generar un **bloqueo en ese cliente** y que más adelante no vuelva a pedir prestado, ya que en muchos casos los cobradores son cambiados y no conocen los clientes que dejaron de prestar"* | ⬜ **ABIERTA** — Abierta hoy por `V-17`. Funcionalidad nueva con una decisión de alcance detrás: **¿el bloqueo es por ruta, por tenant, o entre tenants?** Lo último sería una lista compartida entre empresas competidoras — potente para ellos y **problemático bajo LGPD** (`T21`), porque sería tratar datos de una persona para una finalidad distinta de aquella para la que se recogieron, y a beneficio de un tercero. **Recomendación previa: bloqueo por tenant** | P1 |
| **OQ-F-104** | **Autoservicio de alta contra suscriptores informales** | 🆕 2026-08-02. **V-51**: alta **autoservicio** — la empresa se registra sola, paga y empieza. **V-45**: *"ese usuario debe delegar a un administrador, que es con quien nosotros nos vamos a entender"*. **V-06/V-29**: los suscriptores **no son empresas formales** | ⬜ **ABIERTA** — Abierta hoy por `V-51` contra `V-45` y `V-06`. Las tres no encajan. El autoservicio presupone que alguien puede identificarse y pagar; **V-06 dice que no son empresas registrables** y V-45 describe un alta con intervención humana. Además el cobro es por tarjeta o pasarela (`V-11`), lo que exige un titular identificable. Define **qué se verifica en el alta y con qué medio se cobra** | P1 |

[Answer]:

---

## 6. No funcional — `OQ-N`

### N1 · Volumen y escala

| ID | Pregunta | Evidencia / brecha | Prio |
|---|---|---|---|
| **OQ-N-1** | Volumen objetivo a 12 y 24 meses: nº de tenants, unidades, gestores, clientes, préstamos activos | Ausente. Sin esto ningún NFR es verificable | ⬜ **ABIERTA** — `V-22` **sin responder**. `V-09` da el volumen **actual** (~2.000 clientes), no el objetivo a 12/24 meses. **P0** |
| **OQ-N-2** | Transacciones por día en hora pico (pagos, visitas, fotos subidas) | Ausente | ✅ **CERRADA** — `V-09` + `infraestructura-aws.md` §1.1: ~1.200–2.000 cobros/día ⇒ **~0,04 escrituras/s sostenidas**, **pico ~4 req/s** al cierre. Margen de dos órdenes de magnitud. **P0** |
| **OQ-N-3** | Usuarios concurrentes esperados (web + móvil) | Ausente | ✅ **CERRADA** — `V-09`: ~50 rutas ⇒ ~50 cobradores + ~10 administradores + socios. **Concurrencia real de decenas, no de miles.** **P0** |
| **OQ-N-4** | Tamaño esperado del almacenamiento de fotos (5 fotos/cliente + fotos por venta × N clientes) | Ausente; es el mayor costo recurrente probable | ✅ **CERRADA** — `V-41` (**máx. 5 archivos por venta**) + §1.3: ~900 MB iniciales, **50 GB aprovisionados** ($2,53/mes). `V-41` además permite **borrar al renovar**, lo que acota el crecimiento. P1 |

### N2 · Rendimiento

| ID | Pregunta | Evidencia / brecha | Prio |
|---|---|---|---|
| **OQ-N-5** | Se pide `<200 ms` para "acciones críticas". ¿Cuáles son las acciones críticas, en qué **percentil** (p95/p99) y medido dónde (servidor o dispositivo)? | Reporte 01 §9.3. Sobre red móvil 2G/3G, `<200 ms` extremo a extremo no es alcanzable | 🟡 **PARCIAL** — `V-47`: *"debe ser instantánea… necesitamos velocidad en todo el sistema"*. **No es medible**: no hay número, ni percentil, ni punto de medición. → `OQ-N-44`. **P0** |
| **OQ-N-6** | Tiempo máximo aceptable para: sincronizar la jornada completa, generar el cierre de caja, exportar un reporte a Excel/PDF | Ausente | 🟡 **PARCIAL** — `V-47`: **< 1 minuto** para reportes y exportaciones *(depende del volumen del archivo)*. **Falta el tiempo de sincronización de la jornada y del cierre de caja.** P1 |
| **OQ-N-7** | Tiempo máximo de arranque de la app y de la primera descarga de datos de la unidad | Ausente | ⬜ **ABIERTA** — Sin declarar. P1 |

### N3 · Disponibilidad y continuidad

| ID | Pregunta | Evidencia / brecha | Prio |
|---|---|---|---|
| **OQ-N-8** | SLA de disponibilidad objetivo (99%, 99.5%, 99.9%) y **horario crítico** (la cobranza diaria se concentra en unas horas) | Ausente | 🟡 **PARCIAL** — `V-43`: caída aceptable **< 1 hora, "que no sea repetitivo"**. Es un RTO, no un SLA porcentual. **El horario crítico (cierre 18:00–19:00) no se declaró como ventana protegida.** **P0** |
| **OQ-N-9** | ¿Se aceptan ventanas de mantenimiento programado? ¿En qué franja? | Ausente | ✅ **CERRADA** — `V-44` (B): **domingos**, coherente con `C-12` (no se cobra en domingo). P1 |
| **OQ-N-10** | ¿Qué debe seguir funcionando si la nube cae? El modo offline del móvil, ¿es también el plan de continuidad del negocio? | Ausente | 🟡 **PARCIAL** — `C-65` + `V-03`: el cobrador **sigue trabajando sin señal**, luego el modo offline **sí es el plan de continuidad de campo**. **Pero `V-03` exige señal para cerrar caja**, y las aprobaciones de venta requieren servidor. P1 |

### N4 · Datos, respaldo y retención

| ID | Pregunta | Evidencia / brecha | Prio |
|---|---|---|---|
| **OQ-N-11** | Backups horarios ⇒ **RPO = 1 hora**. ¿Es aceptable perder hasta 1 h de pagos? ¿O el RPO real debe ser ~0? | §12 define la frecuencia pero nunca el objetivo | 🟡 **PARCIAL** — `V-43` responde sobre caída, no sobre pérdida de datos. **El RPO no se declaró.** Con el ledger append-only y la cola local, la pérdida real se limita a lo no sincronizado. **P0** |
| **OQ-N-12** | **RTO**: ¿cuánto puede estar caído el sistema antes de que sea inaceptable? | Ausente | ✅ **CERRADA** — `V-43`: **RTO < 1 hora**. **P0** |
| **OQ-N-13** | Retención: ¿cuántos años se conservan préstamos, comprobantes, fotos y log de auditoría? ¿Hay una obligación legal concreta? | Ausente | 🟡 **PARCIAL** — `V-41`: **fotos borrables al renovar**. `V-20`: **30 días** de retención tras el bloqueo por impago. **Préstamos, comprobantes y auditoría siguen sin plazo** — y `T21` (LGPD) obliga a documentarlo. **P0** |
| **OQ-N-14** | ¿Se ha probado alguna vez una restauración? ¿Se requiere un simulacro periódico documentado? | §12 asume la capacidad | ⬜ **ABIERTA** — Nunca se abordó. Con equipo de una persona (`CX-27`), **una restauración jamás probada es una copia de seguridad no verificada**. P2 |

### N5 · Seguridad

| ID | Pregunta | Evidencia / brecha | Prio |
|---|---|---|---|
| **OQ-N-15** | ¿MFA obligatorio, opcional, o sólo para roles administrativos? | Ver CX-3 | ✅ **CERRADA** — `V-36` (A): **obligatorio para administrador y socios**, no para cobradores — que en cambio quedan atados al dispositivo (`C-70`). **P0** |
| **OQ-N-16** | Política de sesión: duración, cierre por inactividad, ¿sesión persistente en el móvil del gestor? | Ausente | ✅ **CERRADA** — `V-37` (D) + `T17`: sesión persistente con **huella o PIN corto**; el par de claves del dispositivo sustituye al refresh token; contraseña al enrolar y periódicamente estando en línea. P1 |
| **OQ-N-17** | Cifrado en reposo del **dispositivo móvil**: la base local contiene datos financieros y fotos de documentos. ¿Se cifra? ¿Se borra en remoto al desvincular? | §11 habla del servidor, nunca del dispositivo | ✅ **CERRADA** — `T18` = A: **cifrado obligatorio**. `C-71` exige borrado remoto. ⚠️ **La librería sigue sin decidir** — `expo-sqlite` no cifra; es requisito bloqueante de arranque. **P0** |
| **OQ-N-18** | ¿Se requiere prueba de penetración o revisión de seguridad antes de producción? | Ausente | 🟡 **PARCIAL** — `T22` + `T25` incorporan **SAST y DAST** en las puertas. **Una prueba de penetración externa antes de producción no se declaró** — y `V-53` sugiere que el cliente no la exigirá. P1 |
| **OQ-N-19** | Política de contraseñas, bloqueo por intentos fallidos, rotación de credenciales de servicio | Ausente | 🟡 **PARCIAL** — `T17` fija el almacenamiento y la expiración; `V-36` añade que **el administrador puede bloquear al cobrador**. **Política concreta de longitud, intentos y rotación sin declarar.** P1 |
| **OQ-N-20** | ¿Cómo se protege contra el **fraude del propio gestor** (el riesgo real del negocio): pagos no registrados, cobros en efectivo desviados? ¿Qué controles compensatorios se esperan del sistema? | El insumo confía en auditoría y llaves, pero no declara el modelo de amenaza | 🟡 **PARCIAL** — `C-99` nombra los dos fraudes y `V-36` confirma la vinculación de dispositivo contra el **robo de cartera**. 🔴 **Pero los dos controles antifraude dependen de WhatsApp, y `CX-33` dice que los suscriptores no pueden tenerlo.** **P0** |

### N6 · Privacidad y cumplimiento legal

| ID | Pregunta | Evidencia / brecha | Prio |
|---|---|---|---|
| **OQ-N-21** | ¿Qué régimen de protección de datos aplica: **LGPD** (Brasil), Habeas Data (Colombia), GDPR, otro? | Se deriva de OQ-B-2 / CX-8; ninguna fuente lo nombra | ✅ **CERRADA** — `V-01` (Brasil) + `T21`: **LGPD**, más **ISO 27001** por decisión del equipo. **P0** |
| **OQ-N-22** | Se almacenan fotos de documentos de identidad, geolocalización y firmas: son **datos personales sensibles**. ¿Hay base legal, aviso de privacidad y consentimiento del cliente? | Ausente por completo | ⬜ **ABIERTA** — 🔴 `V-29`: **no hay contador ni abogado** — *"no está regulado por ningún país, es algo alegal"*. **La base legal del tratamiento sigue sin definirse**, y es requisito de LGPD art. 7. **P0** |
| **OQ-N-23** | ¿La actividad de préstamo está **regulada** en el país objetivo (licencia, tope de tasa de usura, reporte a la autoridad)? | Ausente. Puede invalidar reglas de negocio completas | ✅ **CERRADA** — `V-29`: la actividad **no está regulada en ningún país** según el cliente. `V-30`: **no hay tope de usura que aplicar** y el sistema **no debe avisar ni bloquear**. **P0** |
| **OQ-N-24** | El reporte 02 menciona "rastreo de lavado de activos". ¿Hay obligación real de reporte de operaciones sospechosas (PLD/AML)? | Mencionado al pasar, sin requisito derivado. **Degradada por D-01**: al no ser medio de pago, el sistema no adquiere obligaciones de PSP. Si la obligación existe, es de **la empresa prestamista**, y al sistema sólo le tocaría **emitir un reporte** | 🟡 **PARCIAL** — `V-29` implica que no hay obligación formal de reporte PLD/AML. **No se confirmó explícitamente**, y la respuesta *"es algo alegal"* no equivale a *"no hay obligación"*. P1 ⬇ |
| **OQ-N-25** | ¿Los datos deben residir en un país específico (residencia de datos)? | Ausente | ✅ **CERRADA** — `V-31`: *"no tenemos preferencia"*. **`sa-east-1` queda fijada por LGPD (`T21`), no por exigencia del cliente.** ✅ **CERRADA 2026-08-02**: `V-01` fija **Brasil** y `V-31` declara *"no tenemos preferencia"* de residencia. **`sa-east-1` queda fijada por LGPD (T21), no por exigencia del cliente.** **P0** |
| **OQ-N-26** | ¿Derecho de supresión del cliente? Choca con la retención contable y de auditoría — ¿cómo se resuelve? | Ausente | ✅ **CERRADA** — Resuelto por diseño en `T14` y confirmado por `V-41`: la foto vive en S3 y la tabla guarda **referencia + hash**, así que **la imagen se borra sin romper el ledger**. `V-41` autoriza el borrado al renovar. P1 |
| **OQ-N-27** | ¿Se requiere una certificación formal (SOC 2, ISO 27001) para vender el SaaS? | T21 sin insumo | ✅ **CERRADA** — `V-53` (A): *"No lo prevemos; nuestros clientes son empresas pequeñas"*. ⚠️ **Contradice la declaración de ISO 27001 de `T21`** → `CX-38`. **Resuelve `OQ-N-46` a favor de "alineado, no certificado".** P1 |

### N7 · Multi-tenancy

| ID | Pregunta | Evidencia / brecha | Prio |
|---|---|---|---|
| **OQ-N-28** | Nivel de aislamiento entre tenants: ¿base de datos por tenant, esquema por tenant, o fila con `tenant_id`? | Ver CX-1; decisión estructural irreversible | ✅ **CERRADA** — `T14` + `T17`: **fila con `tenant_id` y RLS de PostgreSQL** como frontera de aislamiento, con el `tenant_id` tomado del token verificado. **P0** |
| **OQ-N-29** | ¿Un tenant puede exigir su propia instancia, región o backup independiente? | Ausente | ✅ **CERRADA** — `V-52`: *"podría ser, aumentaría los costos, aunque no creo que se vea el caso"* — **no en v1**. P1 |
| **OQ-N-30** | ¿Cómo se aprovisiona un tenant nuevo (autoservicio o manual)? ¿Hay un panel de super-administración? | Ausente aunque el producto se declara SaaS | ✅ **CERRADA** — `V-51` (B): **autoservicio**. ⚠️ Choca con `V-45` y `V-06` → `OQ-F-104`. **P0** |

### N8 · Móvil: dispositivos y red

| ID | Pregunta | Evidencia / brecha | Prio |
|---|---|---|---|
| **OQ-N-31** | Versión mínima de Android/iOS y gama de dispositivo objetivo (los gestores suelen usar gama baja) | §9 dice "Android e iPhone" | ⬜ **ABIERTA** — 🔴 **Sigue sin declararse, y ahora bloquea una decisión técnica**: `T18` fijó **TLS 1.2 mínimo como asunción** precisamente porque **TLS 1.3 obligatorio exige Android 10+** y no se conoce el parque de dispositivos. `C-106` solo dice que el equipo es poco hábil con la tecnología. **P0** |
| **OQ-N-32** | ¿Hay límite de **consumo de datos**? Subir 5 fotos por cliente en plan prepago es un costo real para el gestor | Ausente | ✅ **CERRADA** — `V-48`: **~30 reales de recarga ≈ 10 GB/mes** por cobrador. Holgado frente a los ~2 GB estimados. ⚠️ **La sincronización continua de `V-13` lo consume más rápido.** P1 |
| **OQ-N-33** | Almacenamiento local máximo que puede ocupar la app | Ausente | 🟡 **PARCIAL** — `V-48`: *"el cobrador puede borrar fotos periódicamente para depurar y liberar espacio"*. **No hay límite declarado**, y la gestión queda en manos del usuario. P1 |
| **OQ-N-34** | ¿Distribución por tiendas oficiales (App Store / Play) o instalación gestionada? Las tiendas tienen tiempos de revisión y políticas sobre préstamos | Ausente; **Apple y Google tienen restricciones específicas para apps de préstamos** | ✅ **CERRADA** — `V-49` (A): **Play Store y App Store**, presentándola como herramienta de gestión interna. ⚠️ **Riesgo de rechazo o retirada** → `OQ-N-48`. **P0** |

### N9 · Observabilidad, soporte y usabilidad

| ID | Pregunta | Evidencia / brecha | Prio |
|---|---|---|---|
| **OQ-N-35** | ¿Quién opera y soporta el sistema en producción? ¿Horario de soporte? | Ausente | ✅ **CERRADA** — `V-45`: soporte **24/7** canalizado a través del administrador delegado de cada suscriptor. ⚠️ **Imposible con un equipo de una persona** → `CX-36`. P1 |
| **OQ-N-36** | ¿Qué alertas debe emitir el sistema (sincronización atascada, cierre no cuadrado, envío de WhatsApp fallido)? | Ausente | ✅ **CERRADA** — `V-42`: **las 7 alertas marcadas** — sin sincronizar, caja sin cerrar, cierre descuadrado, fallo de WhatsApp, muchos "no pago" seguidos, intentos de clave fallidos, reclamo de cliente. ⚠️ **Canal contradictorio** → `CX-37`. P1 |
| **OQ-N-37** | Idioma(s) de la interfaz y formato de fecha/moneda | Deriva de OQ-B-2 | ✅ **CERRADA** — `V-01`: **UI en español**, moneda **BRL**. ⚠️ **El idioma de los mensajes al prestatario brasileño queda sin decidir** → `CX-32`. **P0** |
| **OQ-N-38** | ¿Requisito de accesibilidad? ¿Nivel de alfabetización digital del gestor promedio? | Ausente; condiciona todo el diseño de la app | 🟡 **PARCIAL** — `C-106`: equipo poco hábil con la tecnología. `V-50` (B): **guía rápida la primera vez**. **Requisito de accesibilidad formal sin declarar.** P1 |
| **OQ-N-39** | ¿Se requiere capacitación/onboarding dentro del producto? | Ausente | ✅ **CERRADA** — `V-50` (B): guía rápida en la app; el resto lo capacita el equipo. *"la idea es que todo sea sencillo y práctico"*. P2 |

### N10 · Costos operativos

| ID | Pregunta | Evidencia / brecha | Prio |
|---|---|---|---|
| **OQ-N-40** | Presupuesto mensual de infraestructura + WhatsApp (costo por conversación) + IA (costo por consulta) + almacenamiento de fotos | Ausente. Con envíos automáticos por cada pago, el costo de WhatsApp escala con el recaudo | ⬜ **ABIERTA** — Sin declarar. Hoy se conoce el costo (~$210/mes de infraestructura + ~$212 de WhatsApp), **no el presupuesto**. **P0** |
| **OQ-N-41** | ¿Hay un techo de costo por tenant que el precio deba cubrir? | Ausente | ⬜ **ABIERTA** — Sin declarar. Depende de `OQ-B-4` (modelo y precio de cobro), también abierto. P1 |

### N11 · Cumplimiento del cobro del software 🆕 (deriva de D-01)

| ID | Pregunta | Evidencia / brecha | Prio |
|---|---|---|---|
| **OQ-N-42** | **Alcance PCI-DSS.** ¿Se acepta como restricción que **ningún dato de tarjeta toque nunca el sistema** (checkout hospedado del proveedor ⇒ SAQ-A)? Si se quisiera capturar la tarjeta dentro de la propia web, el alcance de cumplimiento se dispara | Nace de D-01. Es una restricción barata de aceptar hoy y carísima de revertir | ⬜ **ABIERTA** — 🔴 `V-54` (C): *"No entiendo bien las implicaciones — explíquenmelo"*. **Requiere explicación en la llamada.** Es barata hoy y cara después. **P0** |
| **OQ-N-43** | ¿Se declara explícitamente ante Google Play y App Store que **la app móvil no procesa ni acepta pagos**? Refuerza `OQ-N-34` y evita las reglas de compras in-app | Deriva de D-01; el material no lo contempla | 🟡 **PARCIAL** — `V-11` (A) mantiene el pago fuera de la app, lo que **sostiene la declaración**. **No se confirmó que se vaya a declarar explícitamente** ante las tiendas → `OQ-N-48`. P1 |
| **OQ-N-44** | ¿Cuál es el **objetivo de rendimiento** contra el que se mide? Concretamente: tiempo máximo aceptable para **sincronizar un lote de 40 operaciones** al recuperar señal, latencia máxima del tablero, y tiempo de respuesta al registrar un pago con conexión | Surgida en la entrevista técnica (T22). El usuario declaró las pruebas de rendimiento **obligatorias**, pero **no existe ningún número declarado**. Sin objetivo la prueba no puede fallar, y una prueba que no puede fallar no es una prueba. Base de partida de T3: 30–40 usuarios, ~1.200 clientes, ~3 pagos/minuto en pico. **El tiempo de sincronización es medio de negocio, no técnico**: es lo que el gestor espera parado en la calle | 🟡 **PARCIAL** — `V-47` da **< 1 minuto** para reportes, pero *"instantáneo"* para la operación del cobrador **no es medible**. **k6 (`T24`) sigue sin poder ejecutarse.** **P1** |
| **OQ-N-45** | **El presupuesto de infraestructura sube ~50 % por la arquitectura de red decidida en T11.** ¿Se acepta? | 🆕 2026-08-02 (T11). La red privada confirmada —tareas Fargate en subred privada, RDS aislada, entrada solo por ALB y CloudFront— **obliga a un NAT Gateway** ($67,89/mes en `sa-east-1`, 2,1× el precio de `us-east-1`), porque las tareas privadas necesitan **salida** a WhatsApp Cloud API, Telegram Bot API, Sentry, FCM y Bedrock. El escenario A de `infraestructura-aws.md` pasa de **~$141 a ~$210/mes**. `infraestructura-aws.md` §8.3 tenía como **regla de costo nº 1** *"nunca contrate un NAT Gateway hasta que algo lo exija de verdad"* — **ahora algo lo exige**, y queda documentado qué. Mitigaciones ya aplicadas en la decisión: **un solo NAT, no dos** ($68 en vez de $136; se acepta perder una AZ a 0,04 req/s) y **VPC Endpoint de tipo Gateway para S3**, que es gratuito y saca el tráfico de fotos del NAT. Descartada conscientemente: **NAT Instance** en `t4g.nano` (~$3/mes) — ahorra $65 al mes a cambio de mantener un aparato de red, mal negocio cuando el recurso escaso del equipo es su tiempo (`CX-27`). Descartados también los endpoints de interfaz para ECR/Secrets/Logs (~$22/mes) porque **no eliminan el NAT**. Enlaza con `OQ-N-40` (presupuesto mensual, sin declarar) | ⬜ **ABIERTA** — Abierta hoy por `T11`. Depende de `OQ-N-40`. P1 |
| **OQ-N-46** | **¿ISO 27001 "alineado" o ISO 27001 "certificado"?** | 🆕 2026-08-02 (T21). El usuario declaró **ISO 27001 + LGPD** sin precisar el alcance | ✅ **CERRADA** — **Resuelta por `V-53`**: el cliente no prevé que le pidan certificaciones ⇒ **"alineado con ISO 27001", no certificado**. Descarga además la presión de `CX-31`: un estándar como guía admite excepciones documentadas; una certificación auditada, no. Son dos proyectos de tamaño muy distinto. **Alineado** = usar el Anexo A como lista de control; es trabajo de ingeniería y buena parte ya está hecha (T17, T18, T20, T25). **Certificado** = SGSI documentado, análisis de riesgos formal, auditoría interna, revisión por la dirección y **auditoría externa** — un proyecto organizativo de meses con costo de auditoría, que además choca de frente con `CX-31` (segregación de funciones imposible con una persona). **Decide si ISO es una guía de diseño o un entregable con fecha.** Enlaza con `OQ-N-40` (presupuesto) | **P0** |
| **OQ-N-47** | **Capacidad de detección de brechas** para poder notificar a la ANPD | 🆕 2026-08-02 (T21). LGPD art. 48 obliga a notificar incidentes de seguridad a la autoridad y a los titulares | ⬜ **ABIERTA** — Abierta hoy por `T21`. `V-42` pide alertar sobre **intentos de clave fallidos**, que es un primer ladrillo, pero **no es detección de brechas**. Hoy hay **registro** (CloudWatch Logs) y **alarmas operativas** (T11), pero **detectar una brecha no es lo mismo que ver un 5xx**. Sin capacidad de detección, la obligación de notificar es incumplible por construcción: no se puede reportar lo que no se sabe que pasó. Enlaza con el plan de respuesta a incidentes que exige ISO 27001 A.5.24–A.5.28, también sin declarar | P1 |
| **OQ-N-48** | **Riesgo de presentar la app ante las tiendas como algo distinto de lo que es** | 🆕 2026-08-02. **V-49**: publicar en Play Store y App Store *"presentándola como herramienta de gestión interna"*, y la idea de *"direccionarla al sector de tiendas… ¿para estos temas legales la podríamos enfocar así?"*. Combinado con **V-29** (*"es algo alegal"*) y **V-30** (el sistema no avisa ni bloquea al superar un tope de usura) | ⬜ **ABIERTA** — Abierta hoy por `V-49`. Google y Apple tienen políticas específicas para aplicaciones de préstamos personales, y ambas exigen declarar tasas, plazos y entidad prestamista. **Presentar una app de gestión de préstamos como otra cosa es motivo de rechazo o de retirada posterior**, y una retirada **después** del lanzamiento deja a ~50 rutas sin herramienta de trabajo de un día para otro. Merece una decisión explícita y documentada, no una interpretación optimista. Enlaza con `OQ-N-34` y `OQ-N-43` | P1 |

[Answer]:

---

## 7. Entorno técnico — `OQ-T`

~~Aquí la cobertura es prácticamente nula~~ — **actualizado 2026-08-01: la entrevista técnica
(Quick pass, 13 preguntas) se completó.** De 26 preguntas, **12 quedan cerradas**, **4 parcialmente
cerradas** y **10 siguen abiertas**. El registro íntegro está en
`interview/technical/tech-env-answers-history.md` y el documento renderizado en
`technical-environment.md`.

Estado: ✅ cerrada · 🟡 parcial (el Quick pass dejó fuera la mitad de la pregunta) · ⬜ abierta.

| ID | Pregunta | Alimenta | Prio | Estado / Resolución |
|---|---|---|---|---|
| **OQ-T-1** | ¿Nube, on-premise o híbrido? ¿Qué proveedor? | T1, T2 | ~~P0~~ | ✅ **Nube exclusivamente · AWS, proveedor único** |
| **OQ-T-2** | Modelo de despliegue | T3 | ~~P0~~ | ✅ **Contenedores en ECS Fargate desde el día 1.** EKS, Lambda y App Runner rechazados explícitamente (App Runner **no existe en `sa-east-1`**, verificado) |
| **OQ-T-3** | Tamaño del equipo y experiencia real por tecnología | T4 | **P0** | ⬜ **Abierta** — T4 quedó fuera del Quick pass. Sigue siendo P0: casi todas las decisiones se justificaron en «dominio del desarrollador», sin que el equipo esté descrito |
| **OQ-T-4** | Lenguajes obligatorios, permitidos y prohibidos | T5, T6, T7 | ~~P0~~ | ✅ **Python ≥3.14 · TypeScript 5.x · PostgreSQL ≥17.** Prohibidos: Java, C#, C/C++, Ruby, Pascal. **Go aplazado, no vetado.** Política por defecto: denegar todo lo que no sean los tres |
| **OQ-T-5** | Framework web | T8 | ~~P0~~ | ✅ **React 19 + Vite** (Next.js evaluado y rechazado: SSR exigiría un segundo runtime Node). **Tailwind + shadcn/ui** elegido frente a Mantine |
| **OQ-T-6** | Framework móvil | T8 | ~~P0~~ | ✅ **React Native + Expo**, sujeto a las 6 reglas vinculantes de `interview/technical/mobile-platform-constraints.md` |
| **OQ-T-7** | Backend | T8 | ~~P0~~ | ✅ **FastAPI + Pydantic v2 + SQLAlchemy 2.0/asyncpg + Alembic + Procrastinate** |
| **OQ-T-8** | Base de datos y patrones de datos | T14 | ~~P0~~ | ✅ **PostgreSQL única para todo.** Documental como columnas `JSONB`, no como segunda base. Sin caché, sin índice de búsqueda, sin streaming. **Libro mayor solo-añadir** (reversas, nunca `UPDATE`/`DELETE`). Fotos de identidad en **S3**, nunca en la base |
| **OQ-T-9** | Estrategia de sincronización offline | T8, T14 | ~~P0~~ | ✅ **Cola de comandos propia.** WatermelonDB / PowerSync / ElectricSQL rechazados: **replican estado**, y este sistema debe transmitir **intenciones que el servidor valida** — dejar que el dispositivo escriba en el libro mayor convierte al gestor en autor del registro contable en vez de sujeto auditado |
| **OQ-T-10** | Estilo de API | T13 | ~~P0~~ | ✅ **REST descrita con OpenAPI**, estilo único. WebSocket/SSE descartados: el tablero se refresca por sondeo |
| **OQ-T-11** | Autenticación | T17 | ~~P0~~ | ✅ **JWT de servicio propio** + **vinculación de dispositivo por par de claves** (privada en Keychain/Keystore). Cognito/Auth0 descartados: la vinculación hay que escribirla igual. Ver `CX-26` |
| **OQ-T-12** | Gestión de secretos | T20 | ~~P0~~ | ✅ **AWS Secrets Manager para todo secreto**; configuración no sensible como variables de entorno. AWS↔AWS siempre por **roles de IAM** |
| **OQ-T-13** | Almacenamiento de archivos/fotos y CDN | T11 | ~~P1~~ | 🟡 **Casi cerrada 2026-08-02 (T11)** — ✅ **Entrega decidida: S3 privado + URL prefirmada de expiración corta (5–15 min)** generada por la API tras comprobar permisos. **CloudFront queda solo para el bundle estático de la SPA.** Motivo: una URL de CDN pública para un documento de identidad es un enlace permanente, compartible y sin autenticación —irrevocable si se filtra— y, más importante, **dejaría las fotos fuera de la única frontera de aislamiento del sistema**, ya que la comprobación de tenant vive en la API que firma la URL. Regla operativa asociada: **el móvil debe cachear las fotos localmente** (re-descargarlas a diario multiplica el egreso por 10: ~2 GB -> ~20 GB/mes). ⬜ **Sigue faltando solo la política de retención** -> depende de `T21` y `CX-11`; estructura propuesta y aceptada: activo -> se conserva · cerrado -> Glacier Instant Retrieval a los 12 meses · borrado a los N años (N lo fija T21) · **ledger nunca se borra**. 🔑 **Hallazgo de diseño registrado**: el conflicto *derecho al olvido (LGPD) contra ledger inmutable (T14)* **ya está resuelto** — la foto vive en S3 y la tabla guarda solo **referencia + hash**, así que la imagen se puede borrar sin romper el ledger, que conserva la prueba de que el documento existió sin conservar el documento. **Debe quedar escrito antes de que alguien 'optimice' guardando la foto en la base** |
| **OQ-T-14** | Proveedor de push y de correo transaccional | T11 | ~~P1~~ | ✅ **CERRADA 2026-08-02 (T11).** **Push: Firebase Cloud Messaging** (Android + iOS vía APNs, integración directa con Expo, $0). **Correo transaccional: AWS SES**, confirmado para v1. El argumento que lo decidió no fue la recuperación de contraseña sino **la suscripción semanal declarada en `CX-30`**: 52 cobros al año por tenant implican facturas, recibos y avisos de pago fallido, así que el correo transaccional deja de ser opcional. Carga de trabajo aceptada y registrada: verificar dominio, publicar **DKIM + SPF + DMARC**, **solicitar salida del sandbox** y **manejar rebotes/quejas vía topic de SNS** (no opcional — AWS suspende cuentas con tasa de rebote alta). ⚠️ **Verificar que SES exista en `sa-east-1`.** Alternativa descartada explícitamente: sin correo, con el administrador restableciendo contraseñas a mano — convierte al administrador en punto único de fallo y **un cobrador bloqueado un sábado a las 7am no trabaja** |
| **OQ-T-15** | Proveedor de LLM para el asistente de IA | T11, `OQ-F-69` | ~~P0~~ → ~~P2~~ → **P0** | 🔺 **REACTIVADA 2026-08-02 por `CX-30`**: si el plan básico de la suscripción incluye IA, el asistente vuelve a la v1 y la elección de proveedor vuelve a ser bloqueante. **Corrección al material**: `infraestructura-aws.md` §7.4 afirma que *"ni Claude ni Nova están en Bedrock `sa-east-1`"* — **el usuario reporta el 2026-08-02 que Claude sí está disponible en São Paulo**. Si se confirma en consola, cae el hallazgo que decidía §7.4 y **sí existe la opción de usar IA dentro de AWS sin romper la residencia de datos** (`OQ-N-25`), que era justo lo que el documento daba por imposible |
| **OQ-T-16** | Estructura del repositorio y convención de capas | T16 | ~~P1~~ | 🟡 **Parcial 2026-08-02** — ✅ **Monorepo con versionamiento por etiquetas con espacio de nombres** (`mobile-v1.4.2`, `backend-v2.1.0`), CI con filtros de ruta, despliegue por etiqueta + entorno. Estructura: `backend/ web/ mobile/ infra/ contracts/`. El usuario propuso primero 5 repos enlazados por submódulos con rama homónima y **cambió de posición tras revisión**: el motivo determinante fue que **la puerta de compatibilidad de contrato de T25 deja de proteger las apps ya instaladas** si el cambio rompedor y su corrección en clientes no pueden viajar en el mismo commit; el segundo, que una rama homónima en 5 repos es coordinación sin coordinador. Criterio decisivo: **reversibilidad** (partir es fácil, unir conservando historial no). ✅ **CERRADA 2026-08-02 con la convención de capas**: **monolito modular · rebanadas verticales · hexagonal acotado por módulo · núcleo funcional**. Cada módulo: `router · service · domain · repository · models`. **Seis puertos, lista cerrada** (reloj, mensajería, archivos, IA, repositorio, push) con la regla *"un puerto por cada cosa que podría cambiar de verdad o que estorba en las pruebas"*; el **repositorio no se comparte**, vive en cada módulo. El usuario **discrepó de la recomendación inicial de omitir hexagonal y tenía razón**: en esta misma sesión la mensajería cambió dos veces (`CX-16`, `CX-29`) y apareció un servicio nuevo (`CX-30`), así que la volatilidad de la infraestructura externa es un hecho observado. ⚠️ **Hexagonal aplica solo a `backend/`** — `web/` y `mobile/` se organizan por pantallas y componentes |
| **OQ-T-17** | Cifrado en tránsito y en reposo | T18 | ~~P1~~ | ✅ **CERRADA 2026-08-02: A · todo cifrado en reposo y en tránsito.** Añade sobre lo ya fijado: **RDS con KMS** (⚠️ **solo activable al crear la instancia** — paso irreversible del `terraform apply` inicial, debe estar en T29), **copias y snapshots cifrados**, y **`sslmode=require` entre ECS y RDS** — no es automático, y sin él el tráfico va en claro **dentro de la VPC**; es lo que más se olvida al declarar "todo cifrado en tránsito". **TLS público mínimo 1.2, preferido 1.3** — ⚠️ **asunción declarada, no respuesta del usuario**: no se conocen los modelos de teléfono y **TLS 1.3 obligatorio exige Android 10+**, cuyo fallo se vería como *"no sincroniza"*. Al ser A el nivel máximo, el cruce de validación con T21 se cumple por construcción. 🔴 **No resuelve la librería de SQLite cifrada** — T18 la convierte en **requisito bloqueante de arranque**: `expo-sqlite` **no cifra** y `op-sqlite` + SQLCipher queda fuera del SDK, contra la regla 2 de `mobile-platform-constraints.md` |
| **OQ-T-18** | Validación de entrada | T19 | ~~P1~~ | ✅ **Esquema en el borde**: Pydantic v2 en el servidor, Zod en el cliente derivado del mismo OpenAPI. Respondida de facto por T8 |
| **OQ-T-19** | Tipos de prueba y objetivo de cobertura | T22, T23 | P2 ⬇ | 🟡 **Parcial — despriorizada 2026-08-02.** Los seis tipos son obligatorios (T22), las herramientas están fijadas y escalonadas (T24) y **los tres flujos E2E son lista cerrada**: pago offline + sync · cierre de caja a cero · aprobación de venta con QR. **Solo falta el número de cobertura** (T23, fuera de alcance por decisión de profundidad). Baja a P2: con el núcleo funcional de T16 aislado y probado, un porcentaje global mediría sobre todo código de infraestructura |
| **OQ-T-20** | Herramientas de prueba y puertas de CI/CD | T24, T25 | ~~P1~~ | ✅ **CERRADA 2026-08-02 (T24).** **pytest** (unitaria backend) · **Vitest** (unitaria web y móvil, nativo de Vite) · **pytest + Testcontainers** (integración contra PostgreSQL real — RLS, transacciones e idempotencia no existen en otro sitio) · **`oasdiff`** en la puerta rápida (contrato; **deliberadamente no Pact**: no hay consumidores independientes, hay un esquema publicado) · **Playwright** (E2E web) · **Maestro** (E2E móvil, menos frágil que Detox en React Native) · **k6** (rendimiento, ⚠️ **no ejecutable hasta `OQ-N-44`**) · **Ruff · Bandit · `pip-audit` · `npm audit` · Trivy** (SAST y dependencias; Trivy cubre también el **Terraform**) · **OWASP ZAP** (DAST, puerta lenta). ⬜ Pendientes junto a esta pregunta: **escalonamiento de adopción** y **lista concreta de flujos E2E** (abierta desde T22) |
| **OQ-T-21** | Entornos y datos de prueba anonimizados | T25 | P1 | ⬜ **Abierta** — T25 fijó las puertas, no los entornos. Gana relevancia: el aviso de T20 (AWS retiene el nombre de un secreto 7–30 días tras borrarlo) **bloquea el ciclo levantar/destruir entornos** |
| **OQ-T-22** | **Ejemplos de código canónicos** | T26–T29 | ~~P0~~ | ✅ **CERRADA 2026-08-02.** Los cuatro escritos por el rol técnico a partir de las 23 respuestas y **aprobados por el usuario** (séptima excepción a la política de no pre-llenado). `payments/router.py` · `shared/money.py` + `payments/domain.py` + `payments/service.py` + `shared/db.py` · dos patrones de prueba (unitaria pura + integración con Testcontainers que **verifica que RLS aísla de verdad y que el ledger rechaza `UPDATE` a nivel de base**) · `infra/rds.tf` + `infra/ecs.tf`. Contenido en `technical-environment.md` §Example Code. **Seis decisiones de diseño nuevas** introducidas por los ejemplos, entre ellas `amount` como cadena (un `number` de JSON es float en TypeScript, así que T10 se rompería en el cliente) y **dos relojes en el asiento** (`occurred_at` del teléfono, no fiable; `recorded_at` del servidor) — sin los dos campos, el escenario obligatorio de T14 *"reloj cambiado a mano"* no se puede ni representar. **Cinco trampas documentadas**, todas silenciosas: `SET LOCAL` contra `SET` (fuga entre tenants vía pool de conexiones), `ssl=require` contra `sslmode` (asyncpg lo ignora sin error y el tráfico va en claro), `amount` como número, `storage_encrypted` solo activable al crear, y 404 contra 403 entre tenants |
| **OQ-T-23** | Infraestructura como código | T29, T16 | ~~P1~~ | ✅ **CERRADA 2026-08-02 (T16): Terraform**, en la carpeta `infra/` del monorepo, con revisión obligatoria y credenciales propias en la CI por su radio de impacto. Buena elección para un equipo que aprende solo: es la herramienta con más ejemplos disponibles. Queda pendiente el **fragmento canónico** (T29) |
| **OQ-T-24** | Idioma del código y de los nombres de dominio | T16 | ~~P1~~ | ✅ **CERRADA 2026-08-02: TODO EN INGLÉS** — código, tablas, API, variables y dominio. **Se recomendó B** (dominio en español, técnico en inglés) porque *caja* y el contador fraccionario de `D-02` no tienen traducción limpia y toda la definición del producto está en español; **el usuario eligió A**. **Mitigación obligatoria del riesgo señalado**: dado que el peligro de A es la ambigüedad de traducción en un sistema que debe ser exacto, se fija un **glosario vinculante** de 19 términos (un concepto del negocio ↔ un único término en el código) en `technical-environment.md` §Project Structure — sin él, el mismo concepto aparecería como `fee`, `quota` e `installment` en tres módulos. **La estructura confirmada en T16 se renombró de inmediato** (`pagos/`→`payments/`, `caja/`→`cash_box/`, `reloj.py`→`clock.py`, `dinero.py`→`money.py`), que es cuando es gratis. ⚠️ **Cuatro términos por confirmar antes de escribir código**: `sale` (¿venta o desembolso de un préstamo?), `client` contra `customer` (la distinción deudor/suscriptor debe ser inequívoca por `D-01`), `partner` (¿socio inversor o comercial?) y si `collector` cubre "cobrador" y "gestor" o son dos roles |
| **OQ-T-25** | Acceso a datos o exportaciones de TryController | TB1, TB4 | P1 | ⬜ **Abierta — bloqueada en el cliente** (`CX-20`). No es problema de código heredado sino de migración de datos |
| **OQ-T-26** | **Pasarela de cobro para la suscripción del software** (D-01) | T11, `OQ-F-93`/`OQ-F-94` | P1 | ⬜ **Abierta — bloqueada en el cliente.** Despriorizada de P0 a P1: `D-03` deja el módulo de facturación SaaS **fuera de la v1** |

[Answer]:

---

## 8. Resumen y ruta mínima

| Bloque | P0 | P1 | P2 | Total | Δ desde D-01 |
|---|---|---|---|---|---|
| Contradicciones `CX` | 5 | 4 | 1 | 10 | — |
| Negocio `OQ-B` | 14 | 2 | 2 | 18 | +1 nueva · `OQ-B-4` P1→P0 |
| Funcional `OQ-F` | 55 | 39 | 4 | 98 | +6 nuevas (F15) · `OQ-F-34` P0→P1 |
| No funcional `OQ-N` | 22 | 19 | 2 | 43 | +2 nuevas (N11) · `OQ-N-24` P0→P1 |
| Técnico `OQ-T` | 15 | 11 | 0 | 26 | +1 nueva |
| **Total** | **111** | **75** | **9** | **195** | **+10 preguntas, 3 repriorizadas** |

### Ruta al 70% de Discovery — los 13 temas que más desbloquean

Si sólo puedes atacar unos pocos, éstos son los que más brecha cierran:

0. ✅ **¿El sistema custodia dinero o sólo lo registra?** — **RESUELTO por D-01**
1. **País, moneda y régimen legal** — `OQ-B-2`, `CX-8`, `OQ-N-21`, `OQ-N-23`
2. **¿Producto propio o SaaS multi-tenant desde el día 1?** — `OQ-B-3`, `CX-1`, `OQ-N-28`
3. **La fórmula del interés y del cronograma** — `OQ-F-13` a `OQ-F-18`
4. **Imputación de pagos parciales y reversos** — `OQ-F-30`, `OQ-F-31`, `OQ-F-33`
5. **Máquina de estados del préstamo + renovación/refinanciación** — `OQ-F-22` a `OQ-F-25`
6. **Modelo de caja: cajas, cierre, descuadres y consignación** — `OQ-F-45` a `OQ-F-51`
7. **El Excel real del cierre actual** — `OQ-F-52` (es un archivo, no una respuesta)
8. **Alcance offline y resolución de conflictos** — `OQ-F-74` a `OQ-F-80`
9. **Roles, permisos y jerarquía de unidades** — `OQ-F-1` a `OQ-F-3`, `CX-6`
10. **WhatsApp: proveedor, plantillas y consentimiento** — `OQ-F-57` a `OQ-F-59`
11. **MVP priorizado y MVP OUT** — `OQ-B-10`, `OQ-B-11`, más la decisión sobre IA (`OQ-F-67`)
12. **Volúmenes, equipo y presupuesto** — `OQ-B-5`, `OQ-B-9`, `OQ-N-1`, `OQ-N-40`, `OQ-T-3`
13. **Cobro del software: modelo, medio y momento** 🆕 — `OQ-B-4`, `OQ-B-18`, `OQ-F-93`, `OQ-F-94`, `OQ-F-95`, `OQ-N-42`, `OQ-T-26`

### Qué queda al 100% funcional y no funcional

Responder **P0 + P1** de las secciones 5 y 6 (94 funcionales + 41 no funcionales = 135 preguntas) cierra por completo
el "qué hace el sistema" y el "cómo debe comportarse". Los `P2` pueden resolverse
durante la fase de Requirements Analysis de AI-DLC sin bloquear el diseño.

---

## 9. Notas de proceso

- Este archivo **se reescribe** (no es append-only) cada vez que corre el colector de open questions.
- La numeración es monotónica por prefijo: si una pregunta se resuelve y se retira, su número no se reutiliza.
- Las respuestas confirmadas se guardan en `interview/business/vision-answers-history.md` y
  `interview/technical/tech-env-answers-history.md`, que sí son append-only.
- **Las decisiones de la §0 no se vuelven a preguntar.** Al regenerar este archivo se mantienen, y
  toda pregunta que las contradiga se retira o se reformula.
- Pendiente: `interview/shared-selection.md` sigue sin responder (tipo de proyecto, profundidad, modo, interacción).

### Historial de cambios

| Fecha | Cambio |
|---|---|
| 2026-07-28T00:31:15Z | Generación inicial: 185 preguntas (106 P0 · 70 P1 · 9 P2) |
| 2026-07-28T16:56:09Z | **D-01 (alcance del manejo de dinero)**: +10 preguntas nuevas (`OQ-B-18`, `OQ-F-93`…`OQ-F-98`, `OQ-N-42`, `OQ-N-43`, `OQ-T-26`), 3 repriorizadas (`OQ-B-4` ⬆, `OQ-F-34` ⬇, `OQ-N-24` ⬇), 4 reformuladas (`OQ-F-35`, `OQ-F-38`, nota en F7, nota en F15). Total: **195** |
