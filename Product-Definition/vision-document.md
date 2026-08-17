# Vision Document — *(producto sin nombre — ver `OQ-B-1`)*

Generado por aidlc-discovery el 2026-08-07.
Tipo de proyecto: **Greenfield** — código nuevo. TryController es un producto de terceros que el
cliente no posee: no hay código heredado, solo una **migración de datos** pendiente (`CX-20`).

> **Cómo leer este documento.** Cada afirmación está trazada a su fuente: `C-xx` (cuestionario v2),
> `V-xx` (cuestionario v3), `B-xx` (cuadernillo de negocio), `T-xx` (entrevista técnica) o `D-0x`
> (decisión confirmada). Lo que **no** tiene fuente no está aquí: las lagunas se declaran como
> lagunas, no se rellenan con supuestos.
>
> ⚠️ **Una sección no se pudo completar**: §Success Metrics. Ver el aviso allí.

---

## Executive Summary

Es un **SaaS multi-tenant de gestión de préstamos y cobranza en calle** para financieras pequeñas
que operan en **Brasil**, con moneda **real (BRL)** e interfaz en **español** (`V-01`). Sustituye a
**TryController**, un producto de terceros que hoy usan y del que **no pueden exportar sus propios
datos** (`C-08`, `B-09`).

Su razón de ser **no es gestionar cobranza sino impedir el fraude interno** (`D-02`, `C-99`). El
cliente identifica dos fraudes concretos: el cobrador que **cobra y no registra**, y el **robo de
cartera**. Todo lo demás del producto existe para sostener dos controles contra ellos: un **QR que
libera el dinero de una venta sólo tras la aprobación del administrador** (`C-31`) y un **extracto
enviado al cliente final por WhatsApp** que convierte cada pago en evidencia verificable por un
tercero (`C-99`).

El sistema **nunca custodia dinero** (`D-01`): no recibe, no retiene y no transfiere fondos de la
cobranza. Registra información de efectivo y PIX para representar la gestión. El único flujo de
dinero real es la **suscripción del software**, y ocurre sólo en la web.

Escala inicial: **~2.000 clientes finales, ~50 rutas de cobro y una cartera inferior a 100.000
reales** (`V-09`, `B-03`) — un ticket medio de unos 50 reales por cliente, coherente con cobranza
diaria puerta a puerta.

⚠️ **No existe una medida de éxito acordada.** Se preguntó tres veces y las tres quedó sin cifra
(`C-07`, `V-22`, `B-04`).

---

## Business Context

### Problem Statement

Una financiera pequeña presta cantidades pequeñas a muchas personas y las cobra **a diario, de lunes
a sábado, en la calle** (`D-02`, `C-12`). El dinero pasa por las manos de un cobrador que trabaja
solo, sin supervisión y **a menudo sin señal de móvil** (`C-65`).

Eso crea dos huecos por los que se escapa el dinero, ambos declarados por el cliente en `C-99`:

1. **Cobrar y no registrar.** El cobrador recibe el pago, el cliente queda satisfecho, y el importe
   nunca entra al sistema. Sin un tercero que confirme, la palabra del cobrador es el único registro.
2. **Robo de cartera.** El cobrador se lleva la lista de clientes y la explota por su cuenta.

Hoy el control depende de TryController más hojas de cálculo, y TryController **no tiene ninguno de
los dos controles** y **no deja sacar los datos** (`B-09`). El cliente no ha evaluado ninguna
alternativa (`B-09`).

### Business Drivers

- **Recuperar la propiedad de los datos.** Hoy están cautivos en un producto de un tercero que no
  ofrece exportación (`C-08`, `CX-20`).
- **Cerrar el fraude interno**, que el cliente nombra como el problema nº 1 (`C-99`).
- **Vender el sistema a otras financieras.** El producto se concibe como SaaS multi-tenant, no como
  herramienta interna (`OQ-B-3`).
- **Sin fecha límite dura.** Hay una fecha deseable pero flexible; ningún contrato ni licencia
  vence (`C-09`, `OQ-B-8`).

### Target Users and Stakeholders

| Role | Description | Primary Need |
|---|---|---|
| **Cobrador / gestor** | Recorre una ruta a diario con un teléfono. Poca soltura tecnológica (`C-106`). Una ruta = un dispositivo (`C-70`) | Registrar cobros **sin señal** y que su caja cuadre al cierre |
| **Administrador principal** | Dueño de la suscripción. **Acceso total** a lo que incluya su plan; controla socios y gestores. **Crea administradores secundarios** y **asigna permisos sobre los recursos** (`D-05`) | Delegar sin perder el control, y **aprobar antes de que salga el dinero** |
| **Administrador secundario** | 🆕 `D-05`. Creado por el principal, con permisos asignados. 🟡 **Posiblemente es el "supervisor"** de `C-31`/`V-02`/`V-17` que `V-04` negó → `B-12` | Autorizar dentro del alcance que le den |
| **Socio / dueño de la financiera** | No opera el sistema a diario; recibe un reporte. Por debajo del administrador (`D-05`, con errata → `B-15`) | Saber que el dinero está donde debe (`V-24`) |
| **Cliente final (prestatario)** | No usa el sistema. **Recibe un WhatsApp por cada pago** | Comprobante independiente del cobrador — es la pieza del control antifraude |
| **Proveedor (equipo del producto)** | **Un solo desarrollador** (`CX-27`) | Que el alcance quepa en una persona |

### Business Constraints

- **El sistema no es custodio de fondos** (`D-01`). No es wallet, ni fintech, ni medio de pago.
  Efectivo y PIX se registran como **información**.
- **Equipo: una persona.** `CX-27` establece que el alcance comprometido **no cabe** en un
  desarrollador junior — contradicción abierta.
- **Soporte 24/7 comprometido** (`V-45`), **imposible con un equipo de una persona** (`CX-36`).
- **Presupuesto operativo ~$430–470/mes**, del que **WhatsApp es el 61 %**. ⚠️ El cliente afirma
  haberlo aprobado **en una llamada no registrada** (`B-05`); no hay cifra en el registro escrito.
- **Distribución por Play Store y App Store** (`V-49`), que aplican políticas restrictivas a las
  apps de préstamos.
- **LGPD aplica** (Brasil, `V-01` + `T21`). Se guardan fotos de documentos de identidad.
- **Actividad no regulada** según el cliente: sin licencia ni tope de usura que aplicar (`V-29`,
  `V-30`).
- 🔴 **Dependencia bloqueante**: los dos controles antifraude requieren la **API de WhatsApp
  Business**, que el cliente **no tiene** (`C-75`, `CX-16`).

### Success Metrics

> 🔴 **ESTA SECCIÓN NO SE PUEDE COMPLETAR. Es la laguna más grave del documento.**
>
> Se preguntó **tres veces**:
> - `C-07` (cuestionario v2) → *"por la cantidad de suscriptores"*
> - `V-22` (cuestionario v3) → sin responder
> - `B-04` (cuadernillo de negocio, 2026-08-07) → *"eso depende del cobrador, no tenemos una cifra"*
>
> *"Más suscriptores"* no sirve: no distingue un sistema que **funciona** de uno que **se vende
> bien**. Y *"depende del cobrador"* no es medible.
>
> **Consecuencia concreta: dentro de seis meses no habrá forma comprobable de decidir si el proyecto
> salió bien.** Cada parte tendrá su opinión y ninguna será verificable — que es exactamente la
> situación que un sistema antifraude existe para evitar.

| Metric | Current State | Target State | Measurement Method |
|---|---|---|---|
| ⬜ *sin acordar* | — | — | — |

**Candidatas propuestas y no adoptadas** (de `B-04`, para retomar en llamada): descuadres de caja al
mes · dinero perdido por fraude interno al mes · reclamos por pago mal registrado · tiempo de cierre
diario del administrador · mora de la cartera.

**Recomendación**: la primera es la más barata de medir y la más ligada al problema declarado —
**número de descuadres de caja al mes**. El sistema puede medirla solo desde el día 1, aunque hoy no
se conozca la línea base. Registrar "no lo medimos" como estado actual ya es un punto de partida
válido.

---

## Full Scope Vision

### Product Vision Statement

> Un sistema de registro **inmutable** para la cobranza en calle, donde cada peso cobrado deja
> evidencia verificable por alguien que no es el cobrador — de modo que el dueño de una financiera
> pequeña pueda delegar el cobro sin delegar la confianza.

La formulación deriva de `D-02` y `C-99`: **es un sistema antifraude, no un CRM de cobranza.**

### Feature Areas

1. **Gestión de clientes y préstamos** — alta con fotos de documento, residencia y comercio
   (`C-42`, `C-44`); interés fijo sobre capital; cuota indivisible; sin mora ni descuento por pago
   anticipado (`D-02`).
2. **Cobranza en calle, offline** — registro de pagos y de "no pagos" con motivo y compromiso, sin
   señal (`C-65`), con **contador fraccionado de cuotas** en pagos parciales (`D-02`).
3. **Caja y cierre diario** — tres paneles que deben cerrar **a cero pendiente** (`C-50`).
4. **Aprobaciones y llaves** — venta en 4 pasos con **QR al WhatsApp del cliente para liberar el
   efectivo** (`C-31`); llaves de autorización (`C-61`, `C-63`).
5. **Renovaciones** — regla del 100 % pagado para renovar (`D-02`).
6. **Auditoría inmutable** — libro mayor de solo-añadir; las correcciones son contrapartidas, nunca
   ediciones (`C-99`, `T14`).
7. **Mensajería al cliente final** — extracto por WhatsApp en cada pago; es **evidencia**, no
   cortesía.
8. **Administración multi-tenant** — cada financiera aislada de las demás (`T14`, `T17`).
9. **Alertas** — las siete confirmadas en `V-42`.

### Future Extensions (not committed)

Confirmadas en `B-08` (2026-08-07):

| Capacidad | Decisión |
|---|---|
| Scoring crediticio automático | **Más adelante** — hoy lo hace una persona (`V-12`) |
| Portal para el cliente final | **Más adelante** |
| Seguro de repatriación | **Más adelante** — el cliente no sabe qué es |
| Instancia separada por cliente | **Más adelante** (`V-52`) |
| **Contrato con plantilla legal y firma en el móvil** | ❌ **Descartado** |

---

## MVP Scope — Features IN

Alcance confirmado en `V-05` y `D-03`: **app del cobrador completa + web mínima.**

| Feature | Rationale | Primary User Type |
|---|---|---|
| App de cobranza offline completa | Sin ella no se elimina el Excel: es el objetivo declarado | Cobrador |
| Registro de pago y de "no pago" con contador fraccionado | Núcleo operativo diario | Cobrador |
| Cierre de caja de tres paneles a cero pendiente | Control diario del efectivo (`C-50`) | Cobrador + Administrador |
| **QR de liberación de venta** | **Control antifraude nº 1** (`C-31`) | Administrador |
| **Extracto por WhatsApp al cliente final** | **Control antifraude nº 2** (`C-99`) | Cliente final |
| Libro mayor inmutable | Es la razón de ser del producto | Todos |
| Web mínima: crear/editar clientes, aprobar ventas y gastos, dar llaves | Sin web la app no funciona: el flujo de `C-31` exige aprobación previa | Administrador |
| Alta de cliente con fotos | Requisito de negocio (`C-42`, `C-44`) | Cobrador |
| Aislamiento multi-tenant | El producto nace como SaaS | Proveedor |
| **Alta de dispositivo con PIN y aprobación** | 🆕 `D-05`, cierra `CX-26`: la app genera un PIN que muestra el modelo del aparato, el administrador aprueba y el sistema emite la contraseña. **Un usuario por móvil**; el administrador vincula y desvincula | Cobrador + Administrador |
| **Términos y condiciones versionados** | 🆕 `D-05` (`OQ-F-105`). Aceptación registrada de forma inmutable. Lo pide el cliente **y** lo exige LGPD como base legal (T21). ⚠️ El objetivo que el cliente le atribuye no se logra así → `CX-41` | Todos |
| ⚠️ **Permisos asignables por recurso** | 🔴 `D-05` → **`CX-40` (P0), sin decidir**. Puede ser una excepción puntual o **un módulo entero**. **No planificar hasta `B-13`** | Administrador principal |

> 🔴 **Advertencia sobre este alcance.** `D-05` declara que **la fase 1 = plan piloto = todas las
> funcionalidades del plan básico de 35 reales**. Si el plan básico **no incluye WhatsApp** —única
> lectura en la que el precio cubre el coste, ver `CX-42`— entonces **las dos filas marcadas como
> control antifraude nº 1 y nº 2 no están en la fase 1**, y este cuadro describe un MVP que el
> modelo comercial no financia. **Pendiente de `B-10` y `B-14`.**

### Non-Functional Priorities for MVP

Por orden, derivadas del propósito antifraude:

1. **Integridad del registro** por encima de todo. El libro mayor no se edita; un pago duplicado o
   perdido invalida el producto.
2. **Funcionamiento sin señal.** El cobrador trabaja una mañana entera desconectado (`C-65`).
3. **Aislamiento entre financieras.** Una fuga de datos entre suscriptores mataría el SaaS.
4. **Recuperación rápida**: RTO < 1 hora (`V-43`). Ventana de mantenimiento los domingos (`V-44`).
5. **Sencillez de uso.** El cobrador tiene poca soltura tecnológica (`C-106`); guía rápida la
   primera vez (`V-50`).
6. **Rendimiento**: ⚠️ declarado *"instantáneo"* (`V-47`), **sin número medible** (`OQ-N-44`).

---

## MVP Scope — Features OUT

| Excluded Feature | Reason | Target Phase |
|---|---|---|
| **Módulo de facturación de la suscripción** | `B-07`: *"lo dejamos para después de que la app pase la fase de prueba"*. Se factura por fuera y se activa la cuenta a mano | v2 |
| **Asistente de IA** | ✅ **RESUELTO 2026-08-08 (`D-05`)**: *"En fase futura: Inteligencia Artificial para **F2**"*. **Cierra `CX-30`** a favor de `D-03` y `C-108`; lo que la había abierto era información de segunda mano | **F2** |
| Comparativo mensual de cobranza por gestor | 🆕 `D-05`, **explícitamente diferido**. Nota: el destinatario declarado son **los propios gestores**, no la dirección — es visibilidad de desempeño entre pares. Enlaza con `C-82` | Fase futura |
| Reportes avanzados | `D-03` | v2 |
| Orden geográfico de rutas | `D-03` | v2 |
| Scoring, portal del cliente, seguro de repatriación, instancia dedicada | `B-08` | Más adelante |
| Contrato con firma en el móvil | `B-08` — **descartado, no aplazado** | Nunca |

---

## Risks and Open Questions

### Known Risks

| Risk | Impact | Mitigation |
|---|---|---|
| 🔴 **Sin API de WhatsApp Business** (`CX-16`, `C-75`) | **Los dos controles antifraude desaparecen y el producto pierde su razón de ser.** No es un riesgo de funcionalidad: es existencial | Iniciar el trámite con Meta **antes de escribir código**. Si no se consigue, replantear el producto |
| 🔴 **El alcance no cabe en un desarrollador** (`CX-27`) | Retraso indefinido o entrega incompleta | Reducir alcance o ampliar equipo. `B-06` devolvió esta decisión al desarrollador en vez de tomarla |
| 🔴 **Sin métrica de éxito** (`OQ-B-7`) | Ninguna forma comprobable de declarar el proyecto exitoso | Acordar 2 métricas en llamada. Empezar a medir descuadres desde el día 1 |
| 🔴 **Sin base legal para tratar datos personales** (`OQ-N-22`) | Se guardan fotos de documentos de identidad bajo LGPD sin base legal definida. *"Es algo alegal"* (`V-29`) no es una base legal | Consultar a un abogado. Es el único hueco que no puede cerrar ni el cliente ni el equipo |
| ⚠️ **Rechazo o retirada de las tiendas** (`OQ-N-48`) | Google Play restringe apps de préstamos, incluido el acceso a fotos y ubicación precisa — ambos centrales aquí | Presentarla como herramienta de gestión interna (`V-49`). Plan B: distribución gestionada |
| ⚠️ **Soporte 24/7 comprometido con una persona** (`CX-36`) | Incumplimiento contractual desde el primer suscriptor | Renegociar el compromiso antes de venderlo |
| ⚠️ **Precio sin definir** (`OQ-B-4`) | A ~$43/empresa/mes de coste, un precio mal puesto hace el negocio inviable | Fijar planes y precios antes del primer contrato |
| ⚠️ **Lo que TryController hace bien no está inventariado** (`B-09`) | Funciones que hoy se usan a diario pueden no estar en el reemplazo | Una sesión de observación del uso real |
| ⚠️ **Migración desde TryController sin vía** (`CX-20`) | Sin exportación, la carga inicial es manual | Evaluar extracción por pantalla o carga manual asistida |

### Open Questions

Bloque de negocio — **13 cerradas · 4 parciales · 1 abierta de 18 (83,3 %)**. Detalle en
`open-questions.md` §Negocio.

| ID | Título | Estado | Prio |
|---|---|---|---|
| `OQ-B-7` | **Métricas de éxito** | ⬜ Abierta — tercer intento fallido | **P0** |
| `OQ-B-1` | Nombre del producto | 🟡 El cliente delega en nosotros (`B-01`) | **P0** |
| `OQ-B-4` | Planes y precios de la suscripción | 🟡 Modelo semanal escalonado; sin importes | **P0** |
| `OQ-B-9` | Presupuesto por escrito | 🟡 Acordado en llamada no registrada | **P0** |
| `OQ-B-11` | ¿IA en la v1? | 🟡 `B-06` delega en vez de decidir; `CX-30` sigue abierta | **P0** |

**Dependencias fuera del bloque de negocio que condicionan esta visión**: `CX-16` (WhatsApp),
`CX-27` (capacidad del equipo), `CX-30` (IA en el plan de entrada), `OQ-N-22` (base legal),
`OQ-N-40` (presupuesto).

---

## Nota de proceso

En `B-05` el cliente escribió: *"estamos dándole vueltas a las mismas preguntas que ya resolvimos"*.

Es parcialmente cierto —`B-04` y `B-05` ya se habían preguntado— y se repitieron porque las
respuestas anteriores **no eran utilizables**. Pero la señal es válida y tiene una consecuencia
operativa: **no volver a preguntar por escrito lo que ya falló dos veces.** Las tres decisiones que
faltan —métrica de éxito, presupuesto por escrito y si la IA entra en la v1— deben resolverse **en
una llamada, con alguien tomando nota**, no en otro cuadernillo.
