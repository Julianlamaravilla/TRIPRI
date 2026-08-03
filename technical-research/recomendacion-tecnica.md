# Recomendación Técnica — Sistema Inteligente de Administración de Préstamos

> **Documento de investigación y recomendación.** Arquitectura, patrones de diseño, tecnologías y lenguajes, e infraestructura.
> Fecha: 2026-07-28 · **Revisión 2** (16:56Z) · Estado: propuesta para revisión · Fuente: `context-discovery/notebooklm/` + `Product-Definition/open-questions.md`

> ### 🔄 Revisión 2 — decisión **D-01 · el sistema no maneja dinero real de la cobranza**
>
> El usuario confirmó que **el sistema no recibe, retiene ni transfiere dinero de los cobros**:
> no es wallet, ni fintech, ni entidad bancaria. Efectivo y PIX se **registran como información**
> para representar la gestión de cobranza; el dinero se mueve por fuera. **El único flujo de
> dinero real dentro del aplicativo es el cobro por el uso del propio software, y sólo en la web.**
>
> **Qué cambió en este documento:** §1 (N1 reescrita, N8 nueva), diagrama de §2.1, §2.3, §2.6,
> §4.13 (nueva: facturación), §4.12, §5.2, §5.6, §5.7, §7 y §8.
> **Qué NO cambió, y conviene subrayarlo:** el **libro mayor inmutable, la idempotencia, el
> cuadre de caja y la auditoría siguen siendo obligatorios e igual de estrictos.** El sistema no
> custodia el dinero, pero **es la única evidencia de que ese dinero existió**.

---

## 0. Cómo leer este documento

Cada sección presenta **una recomendación principal**, las **alternativas serias** que se evaluaron, y **por qué se descartaron**. No hay empates: donde hay una decisión, está tomada, y donde falta un dato para tomarla, está marcado explícitamente como **🔒 BLOQUEADA** con la pregunta que la desbloquea.

Al final (§8) está la lista consolidada de las 9 respuestas que faltan para cerrar el diseño.

---

## 1. La naturaleza del proyecto (lo que condiciona todo lo demás)

Antes de recomendar nada hay que ser explícito sobre qué clase de sistema es este, porque ocho características lo definen y **cada recomendación posterior se deriva de ellas**:

| # | Característica | Consecuencia técnica |
|---|---|---|
| **N1** | **Es un sistema de registro financiero (*system of record*), NO un custodio de fondos** (decisión `D-01`). No recibe ni mueve el dinero de los cobros: registra la información de transacciones en efectivo y PIX para representarlas en la gestión de cobranza. El dinero circula fuera del sistema. | **La exigencia de corrección no baja: sube de sitio.** Al ser la única evidencia de un dinero que la plataforma no toca, el registro debe ser **irrefutable**: libro mayor inmutable, transacciones ACID, idempotencia y auditoría total siguen siendo obligatorios. Lo que sí desaparece es la superficie regulatoria de medio de pago: **no hay licencia de PSP, ni PCI-DSS en el núcleo, ni obligación de integración bancaria.** |
| **N2** | **El modo offline del móvil no es una feature, es el modelo operativo.** El gestor cobra en la calle, sin señal, y sincroniza después. | Este es **el driver arquitectónico #1**. La arquitectura se diseña alrededor de la sincronización, no se le añade después. Determina el modelo de datos, la API y el diseño de la app. |
| **N3** | **Dos clientes muy distintos sobre un mismo dominio:** consola web densa en datos (admin/socio) y app móvil de campo, con un solo dedo, pantalla pequeña, gama baja y batería limitada. | Un backend, dos frontends. Justifica compartir el lenguaje y los tipos entre las tres piezas. |
| **N4** | **Multi-tenant declarado pero no confirmado** (contradicción `CX-1`: el doc fuente dice "preparado para convertirse en SaaS", el reporte 02 dice "multi-tenant ya"). | Es la decisión estructural **más cara de revertir**. Se resuelve con una estrategia que cuesta poco hoy y no cierra puertas mañana (§2.4). |
| **N5** | **El equipo es 1 desarrollador, ~16 h/semana, apalancado en agentes de IA** (turno 4 del chat de NotebookLM; sin confirmar como decisión — `OQ-B-9`). | **Esta es la restricción dominante del proyecto.** Elimina de plano microservicios, políglota, infraestructura autogestionada y cualquier stack que exija operar más de una cosa. Favorece agresivamente un solo lenguaje y servicios gestionados. |
| **N6** | **Integraciones externas con costo por uso y política propia:** WhatsApp Business API, PIX, proveedor de LLM, push, almacenamiento de fotos. | Cada una es un riesgo de costo y de cambio de contrato. Todas deben quedar detrás de puertos (patrón *Ports & Adapters*, §3.9). |
| **N7** | **Datos personales sensibles y actividad regulada:** fotos de documentos de identidad, geolocalización del domicilio, firmas digitales, y préstamos de dinero como actividad económica. PIX ⇒ Brasil ⇒ **LGPD**. *(La regulación aplicable es la del **préstamo** y la de **datos**; por `D-01`, no la de servicios de pago.)* | Condiciona la **región de despliegue** (residencia de datos), el cifrado, la retención y la política de borrado. No es opcional ni postergable. |
| **N8** | **Existe exactamente un flujo de dinero real, y está en la periferia:** el **cobro por el uso del software** (suscripción del SaaS), **sólo en la consola web**, nunca en el móvil (`D-01`). | Un **módulo aparte, aislado del dominio de cobranza**, con pasarela de pagos detrás de un puerto. Es el único punto con alcance PCI-DSS, y **reducible a SAQ-A** si los datos de tarjeta nunca tocan el sistema (§4.13). Que el móvil no procese pagos es además un **argumento de cumplimiento ante las tiendas** (§5.7). |

### Un dato adicional que cambia el peso de las recomendaciones

El material describe como "MVP" un alcance que incluye: web + móvil offline + WhatsApp API + PIX + motor de reglas + asistente de IA + reportes Excel/PDF + multi-tenant. La validación de la propia entrevista de Discovery marca **>12 features como "probablemente demasiado"** para un MVP, y este alcance ronda las 25.

> **Esto no es un problema técnico, es un problema de alcance** — y no es mío resolverlo. Pero sí condiciona la recomendación: **todo el stack que sigue está elegido para maximizar la velocidad de un solo desarrollador**, porque la ecuación alcance/equipo no admite ninguna decisión que cueste tiempo de operación.

---

## 2. Arquitectura

### 2.1 Recomendación principal: **Monolito Modular** (*Modular Monolith*) con núcleo transaccional de libro mayor

Una sola aplicación desplegable, dividida internamente en **módulos con fronteras explícitas** (bounded contexts de DDD), comunicándose entre sí por interfaces públicas y eventos internos, sobre una única base de datos PostgreSQL transaccional.

```
┌──────────────────────────────────────────────────────────────────┐
│                     CLIENTES                                     │
│  ┌──────────────────┐          ┌───────────────────────────┐     │
│  │  Consola Web     │          │  App Móvil (gestor)       │     │
│  │  (admin/socio)   │          │  SQLite local + cola de   │     │
│  │  online          │          │  comandos offline         │     │
│  └────────┬─────────┘          └────────────┬──────────────┘     │
└───────────┼─────────────────────────────────┼────────────────────┘
            │ REST/JSON                       │ REST/JSON + sync
┌───────────▼─────────────────────────────────▼────────────────────┐
│              BACKEND — MONOLITO MODULAR                          │
│  ┌────────────────────────────────────────────────────────────┐  │
│  │ Capa de aplicación (casos de uso, idempotencia, tx)        │  │
│  └────────────────────────────────────────────────────────────┘  │
│  ┌──────────┬──────────┬───────────┬──────────┬──────────────┐  │
│  │ Identidad│ Clientes │ Créditos  │ Cobranza │ Caja &       │  │
│  │ & Acceso │ (KYC)    │ (motor    │ (rutas,  │ Contabilidad │  │
│  │ (RBAC,   │          │ financiero│ visitas, │ (LIBRO MAYOR │  │
│  │ llaves,  │          │ estados,  │ pagos)   │  INMUTABLE)  │  │
│  │ device)  │          │ cronogr.) │          │              │  │
│  ├──────────┼──────────┼───────────┼──────────┼──────────────┤  │
│  │ Sincroni-│ Notifica-│ Reportes  │ Asistente│ Administra-  │  │
│  │ zación   │ ciones   │ & BI      │ IA       │ ción tenants │  │
│  └──────────┴──────────┴───────────┴──────────┴──────────────┘  │
│  ┌────────────────────────────────────────────────────────────┐  │
│  │ Facturación y Suscripciones del SaaS (SOLO WEB, aislado)   │  │
│  │ único punto con dinero real · nunca llega a la app móvil   │  │
│  └────────────────────────────────────────────────────────────┘  │
│  ┌────────────────────────────────────────────────────────────┐  │
│  │ Puertos → Adaptadores: WhatsApp · LLM · S3 · Push · Cobro  │  │
│  └────────────────────────────────────────────────────────────┘  │
└────────────────┬─────────────────────────────────────────────────┘
                 │
      ┌──────────▼──────────┐   ┌─────────────┐   ┌──────────────┐
      │ PostgreSQL          │   │ Object      │   │ Cola de      │
      │ (RLS multi-tenant,  │   │ Storage     │   │ trabajos     │
      │  PITR, ledger)      │   │ (fotos KYC) │   │ (en Postgres)│
      └─────────────────────┘   └─────────────┘   └──────────────┘
```

**Por qué monolito modular:**

1. **Un desarrollador no puede operar un sistema distribuido.** Microservicios multiplican por N el costo de despliegue, observabilidad, versionado de contratos y depuración de fallos parciales. Con 16 h/semana, ese overhead consume el proyecto entero.
2. **El dominio exige transacciones ACID que cruzan módulos.** El flujo de registro de pago del §3.1 del documento fuente son **9 pasos que deben pasar o fallar juntos**: registrar ingreso → actualizar préstamo → descontar cuota → afectar caja del gestor → afectar caja general → escribir auditoría → generar asiento contable → emitir comprobante → notificar. En un monolito eso es `BEGIN … COMMIT`. En microservicios es una saga distribuida con compensaciones — la fuente #1 de descuadres de caja en sistemas financieros mal repartidos.
3. **Los módulos son la unidad de disciplina, no el despliegue.** Fronteras claras hoy permiten extraer un servicio mañana **si y cuando** un módulo justifique escalar por separado. La probabilidad de que eso pase antes de tener tracción real es baja.
4. **Un despliegue = un rollback.** Crítico cuando no hay equipo de guardia.

### 2.2 Alternativas evaluadas

| Alternativa | Veredicto | Por qué |
|---|---|---|
| **Microservicios** | ❌ Descartada | Costo operativo prohibitivo para 1 desarrollador. Convierte una transacción de 9 pasos en una saga distribuida. Ningún requisito de escala lo justifica: el MVP opera con 1–2 gestores. |
| **Serverless puro (Lambda/Cloud Functions por endpoint)** | ⚠️ Descartada como base | Arranques en frío hostiles para el SLA de <200 ms; conexiones a Postgres requieren *pooler* obligatorio; depurar un flujo transaccional repartido en funciones es lento. **Sí recomendable para piezas puntuales**: envío de WhatsApp, generación de reportes pesados, jobs programados. |
| **Backend-as-a-Service puro (todo en Supabase/Firebase, sin backend propio)** | ❌ Descartada | Atractivo por velocidad, pero la lógica financiera (cálculo de interés, imputación de pagos, cierre de caja, motor de llaves) **no puede vivir en políticas de base de datos ni en el cliente**. Necesita un lugar propio, testeable y auditable. Sí se puede usar Supabase como *infraestructura* de Postgres + Auth + Storage (§5), sin renunciar al backend. |
| **Monolito clásico en capas (sin módulos)** | ❌ Descartada | Es lo que se degrada primero. Con auditoría transversal, multi-tenancy y 9 áreas funcionales, sin fronteras internas el acoplamiento llega en el mes 3. |
| **Event Sourcing completo en todo el dominio** | ⚠️ Parcial | Excelente para el dinero, **excesivo para todo lo demás**. Se adopta solo en el módulo de Caja/Contabilidad (§2.3). Aplicarlo a clientes, fotos o configuración multiplica la complejidad sin beneficio. |

### 2.3 La decisión de diseño más importante: **el dinero es un libro mayor inmutable**

> **Precisión tras `D-01`:** este libro mayor **no custodia fondos, los constata**. Registra
> movimientos de dinero que ocurrieron físicamente en la calle o por PIX entre terceros. Eso
> **no debilita el argumento: lo refuerza.** Cuando el sistema es la única prueba de un dinero
> que él no toca, un registro mutable o incompleto no es un bug de contabilidad — es la
> desaparición de la evidencia. El diseño se mantiene íntegro.

No modelar saldos como columnas que se actualizan. Modelar **movimientos** como filas que solo se insertan, y derivar los saldos.

```
movimientos_caja  (append-only, jamás UPDATE ni DELETE)
├── id, tenant_id, unidad_id, gestor_id
├── tipo            (INGRESO_EFECTIVO | INGRESO_PIX | GASTO | CONSIGNACION | APERTURA | ...)
├── monto_centavos  (BIGINT, entero, jamás float)
├── prestamo_id, cuota_id, cliente_id  (opcionales, según tipo)
├── caja_destino    (CAJA_GESTOR | CAJA_GENERAL | CAJA_PIX)
├── idempotency_key (UUID generado en el dispositivo — clave anti-duplicado)
├── titular_pix     (obligatorio si tipo = INGRESO_PIX)
└── auditoría: usuario_id, ts_servidor, ip, device_id, device_modelo, accion
```

**Qué resuelve esto, concretamente:**

- **El cierre de caja automático (§4 del documento fuente)** deja de ser un cálculo frágil sobre estados mutables y se convierte en un `SUM()` sobre un rango de fechas. El requisito de "cero digitación manual" se cumple por construcción.
- **Los descuadres se vuelven diagnosticables.** Si la caja no cuadra, se lee la secuencia de movimientos y se ve exactamente dónde. Con saldos mutables, un descuadre es un misterio permanente.
- **Los reversos no borran, compensan.** Un pago mal registrado genera un movimiento inverso enlazado, no un `DELETE`. El histórico sobrevive — que es justo lo que exige la política de auditoría total.
- **La auditoría deja de ser una tabla paralela que hay que recordar escribir.** Los 6 metadatos obligatorios (usuario, fecha, hora, IP, dispositivo, acción) son columnas del propio movimiento. **Es imposible mover dinero sin dejar rastro**, porque son la misma fila.
- **El fraude interno del gestor** (`OQ-N-20`, el riesgo real del negocio) se vuelve detectable: la secuencia inmutable con timestamp de servidor, GPS y device ID permite detectar patrones anómalos que un modelo mutable esconde.

> **Regla no negociable:** todo importe monetario es un **entero en la unidad menor** (centavos). Nunca `float`, nunca `double`. En Postgres, `BIGINT`; en TypeScript, `number` entero o `bigint`. Los errores de redondeo en punto flotante son la causa clásica de descuadres de céntimos que se acumulan y destruyen la confianza en el sistema.

### 2.4 Multi-tenancy: **fila con `tenant_id` + Row-Level Security de PostgreSQL, desde el día 1**

Aunque hoy se opere una sola empresa (`CX-1` sin resolver), **cada tabla lleva `tenant_id` desde la primera migración** y PostgreSQL aplica políticas RLS que filtran automáticamente por el tenant de la sesión.

**Por qué esta y no las otras:**

| Estrategia | Aislamiento | Costo operativo | Veredicto |
|---|---|---|---|
| **Fila + `tenant_id` + RLS** | Fuerte si RLS está bien puesto: la base de datos filtra aunque el código de la aplicación olvide el `WHERE` | 1 migración, 1 base de datos, 1 backup | ✅ **Recomendada** |
| Esquema por tenant | Mayor; export por tenant trivial | N migraciones por despliegue; se cae a pedazos con cientos de esquemas | Solo si un cliente grande lo exige contractualmente |
| Base de datos por tenant | Máximo | Inviable para 1 desarrollador | ❌ |

Es el patrón por defecto del B2B SaaS en 2026, y la clave está en la **defensa en profundidad**: el código de aplicación filtra por tenant *y* RLS lo vuelve a filtrar en la base de datos. Un `WHERE` olvidado en un endpoint es un bug; con RLS activo **no es una fuga de datos entre clientes**.

**El costo de hacerlo hoy es una columna y una política por tabla. El costo de retrofitearlo después de tener datos en producción es una migración de riesgo alto sobre un sistema financiero vivo.** Por eso se hace desde el inicio, independientemente de cómo se resuelva `CX-1`.

### 2.5 La segunda decisión más importante: **el móvil sincroniza comandos, no estado**

Este es el punto donde la mayoría de las apps offline de cobranza fracasan, y merece ser explícito.

**El enfoque ingenuo** es replicar el estado: el móvil tiene una copia de los préstamos y saldos, los modifica offline, y al sincronizar hay que reconciliar dos versiones divergentes. Eso genera conflictos irresolubles: si el gestor registró un pago de R$50 offline y el administrador registró otro de R$30 en la web, ¿cuál gana? Ninguna respuesta es correcta — **ambos pagos ocurrieron**.

**El enfoque correcto** para dinero es sincronizar **intenciones**:

```
El dispositivo NO dice:  "el saldo del préstamo 123 ahora es R$450"
El dispositivo SÍ dice:  "cobré R$50 al préstamo 123, a las 14:32,
                          en GPS -23.55/-46.63, con idempotency_key abc-123"
```

El servidor recibe el comando, **recalcula el estado autoritativo** y responde con el resultado. Consecuencias:

- **Los conflictos casi desaparecen.** Los cobros son aditivos: dos cobros al mismo préstamo desde dos orígenes no se pisan, se suman. El único conflicto real es la sobrecobranza (pagar más que el saldo), que es una **regla de negocio** a decidir (`OQ-F-30`), no un problema técnico de merge.
- **La idempotencia es trivial.** El `idempotency_key` lo genera el dispositivo. Si la red falla y el móvil reintenta 5 veces, el servidor procesa una vez. Sin esto, un reintento en mala señal **duplica un cobro** — el peor bug posible en este dominio.
- **El servidor sigue siendo la única fuente de verdad del dinero.** El móvil nunca calcula saldos autoritativos; solo muestra su proyección local optimista y la corrige al sincronizar.
- **La lógica financiera vive en un solo lugar.** No hay que reimplementar el cálculo de interés y la imputación de pagos en Dart/TypeScript del cliente y mantenerlos sincronizados con el backend para siempre.

Para lo que **no es dinero** (catálogo de clientes, configuración de la unidad, rutas), el móvil sí replica estado en modo lectura, con *pull* incremental por `updated_at` — que es exactamente lo que la plataforma de referencia llama **descarga UGI**.

### 2.6 Contextos delimitados (*bounded contexts*)

| Módulo | Responsabilidad | Nota |
|---|---|---|
| **Identidad y Acceso** | Usuarios, roles (RBAC), permisos, sesiones, vinculación dispositivo↔unidad, sistema de llaves de autorización | El "binding de hardware" y las llaves viven aquí, no dispersos |
| **Clientes (KYC)** | Expediente, alias, referencias, GPS, fotos permanentes, deduplicación por documento | |
| **Créditos** | Producto financiero, cálculo de interés, generación de cronograma, máquina de estados del préstamo, renovación y refinanciación | 🔒 **Bloqueado**: falta la fórmula de interés (`OQ-F-13`) |
| **Cobranza** | Ruta del día, visitas, pagos, "no pago", promesas, firma digital, limpieza de cartera | Es lo que consume la app móvil |
| **Caja y Contabilidad** | Libro mayor inmutable, cajas (gestor/general/PIX), gastos, consignaciones, cierre automático | El núcleo crítico (§2.3) |
| **Notificaciones** | Motor de reglas evento→acción, plantillas, envío WhatsApp/push, reintentos, control de costo | Detrás de un puerto (§3.9) |
| **Sincronización** | Ingesta de comandos offline, idempotencia, *pull* incremental, resolución de conflictos | Módulo propio, no código disperso |
| **Reportes y BI** | Vistas materializadas de KPIs, exportación Excel/PDF replicando el formato heredado | Lee del ledger, no del estado mutable |
| **Asistente IA** | Consultas en lenguaje natural sobre datos propios, con alcance acotado por tenant y rol | §4.8 |
| **Administración de Tenants** | Alta, configuración, límites, panel de super-admin | Mínimo hoy, existe desde el día 1 |
| **Facturación y Suscripciones** 🆕 | Planes, suscripción del tenant, cobro del software, facturas, estado de cuenta, suspensión por impago | **Único módulo con dinero real (`D-01`, N8). Sólo web.** Aislado del dominio de cobranza: no comparte tablas ni ledger, y se comunica por eventos (`tenant.suspendido`). §4.13 · 🔒 Bloqueado por `OQ-B-4`, `OQ-B-18`, `OQ-F-94` |

---

## 3. Patrones de diseño

Solo se listan patrones que **resuelven un problema concreto y verificable de este proyecto**. Cada uno está anclado a un requisito específico del material de entrada.

### 3.1 Libro mayor inmutable / *Append-only ledger*
- **Dónde:** módulo Caja y Contabilidad.
- **Problema que resuelve:** cierre de caja sin digitación (§4 del doc fuente), auditoría total (§11), descuadres diagnosticables, reversos sin perder histórico.
- **Detalle:** ver §2.3. Los saldos son proyecciones, no verdad primaria.

### 3.2 Clave de idempotencia (*Idempotency Key*)
- **Dónde:** todo endpoint que mueva dinero o cree entidades desde el móvil.
- **Problema que resuelve:** **el duplicado de cobros por reintento en mala red.** El dispositivo genera un UUID por operación; el servidor tiene un índice único sobre él y devuelve el resultado original si ya lo procesó.
- **Sin este patrón el sistema duplicará pagos en producción.** No es opcional en una app offline de cobranza.

### 3.3 Bandeja de salida transaccional (*Transactional Outbox*)
- **Dónde:** notificaciones WhatsApp, push de aprobación de llaves, comprobantes.
- **Problema que resuelve:** la tabla de disparadores del §5 del doc fuente exige notificar en cada pago, cada venta y cada "no pago". Si se llama a la API de WhatsApp dentro de la transacción del pago y WhatsApp está caído, **o se pierde la notificación o se cae el cobro**. Ambas son inaceptables.
- **Detalle:** la transacción que registra el pago inserta también una fila en `outbox`. Un worker lee `outbox` y entrega. Garantiza *al menos una vez* con reintentos y backoff, sin acoplar el cobro a la disponibilidad de Meta.

### 3.4 Máquina de estados explícita (*Finite State Machine*)
- **Dónde:** ciclo de vida del préstamo y de la caja.
- **Problema que resuelve:** el material menciona estados dispersos (venta temporal, activo, mora, cartera castigada, renovado, cancelado) sin definir las transiciones válidas (`OQ-F-22` a `OQ-F-25`). Modelarlos con banderas booleanas (`es_activo`, `esta_en_mora`, `fue_castigado`) genera **combinaciones imposibles** que llegan a producción.
- **Detalle:** un `enum` de estado + una tabla de transiciones permitidas. Toda transición inválida es un error explícito, no un estado corrupto silencioso.

### 3.5 Estrategia (*Strategy*) para la matemática financiera
- **Dónde:** módulo Créditos — cálculo de interés y generación de cronograma.
- **Problema que resuelve:** hay 5 modalidades (diaria, semanal, quincenal, mensual, libre) y **ninguna fuente da la fórmula** (`OQ-F-13` a `OQ-F-18`) — es el mayor vacío del insumo.
- **Detalle:** una interfaz `CalculadoraDeCronograma` con una implementación por modalidad. Aísla la incertidumbre: cuando el cliente responda la fórmula real, se toca **una clase**, no el sistema entero. También permite construir el resto del sistema hoy con una implementación provisional documentada como tal.

### 3.6 Especificación / Política (*Specification*) para las llaves de autorización
- **Dónde:** módulo Identidad y Acceso.
- **Problema que resuelve:** el sistema de llaves se activa por límite de monto de venta **y** por límite de cuotas adelantadas, y probablemente por más reglas a futuro.
- **Detalle:** cada regla es un objeto componible que evalúa una operación y devuelve *permitida* / *requiere llave*. Añadir una regla nueva no toca el flujo de venta.

### 3.7 Saga / Gestor de proceso (*Process Manager*) para el flujo de llaves
- **Dónde:** módulo Identidad y Acceso.
- **Problema que resuelve:** el workflow de aprobación (§3 del reporte 02) atraviesa dos aplicaciones y tiempo real: trabajador solicita → sistema bloquea → admin recibe alerta web → admin genera código → push al móvil → trabajador digita → sistema libera → auditoría registra el ID de llave. **Eso no es una función, es un proceso con estado y timeouts.**
- **Detalle:** entidad `SolicitudDeLlave` con estados propios, expiración e ID de auditoría — lo que la plataforma de referencia llama "histórico de llaves".

### 3.8 CQRS ligero (solo lectura separada)
- **Dónde:** dashboard de KPIs, reportes, asistente de IA.
- **Problema que resuelve:** el dashboard pide "tiempo real" sobre capital prestado, recuperado, mora, utilidad, recaudo por método. Calcular eso agregando el ledger completo en cada carga de página no escala.
- **Detalle:** vistas materializadas o tablas de proyección refrescadas por evento. **Sin CQRS completo** — no hay dos bases de datos, no hay bus de eventos externo. Solo lecturas precalculadas en el mismo Postgres.

### 3.9 Puertos y Adaptadores (*Hexagonal* / *Anti-Corruption Layer*)
- **Dónde:** WhatsApp, proveedor de LLM, almacenamiento de fotos, push y **pasarela de cobro del SaaS**. *(PIX sale de esta lista con `D-01`: no es una integración, es un campo de datos.)*
- **Problema que resuelve:** cinco proveedores externos, cada uno con su modelo de precios y su ritmo de cambios de API. Meta cambió el modelo de facturación de WhatsApp de conversación a mensaje. Si el dominio conoce el JSON de Meta, **cada cambio de Meta es una cirugía en el núcleo financiero**.
- **Detalle:** el dominio define `NotificadorDeCliente.notificarPagoRegistrado(...)`. El adaptador traduce a la Cloud API. Cambiar de proveedor (Meta directo → 360dialog → Twilio) es escribir un adaptador nuevo, no tocar el dominio. **Además hace testeable el dominio sin red.**

### 3.10 Contexto de tenant ambiental + RLS
- **Dónde:** transversal.
- **Problema que resuelve:** fuga de datos entre tenants — el fallo más grave posible en un SaaS financiero.
- **Detalle:** middleware que fija `SET LOCAL app.tenant_id` al inicio de cada transacción; las políticas RLS lo leen. El desarrollador **no puede olvidarlo**, porque no lo escribe.

### 3.11 Repositorio + Unidad de Trabajo (*Repository + Unit of Work*)
- **Dónde:** capa de aplicación.
- **Problema que resuelve:** los 9 pasos del registro de pago deben ser una sola transacción. Sin un objeto que gobierne el límite transaccional, se cuelan escrituras fuera de la transacción y aparecen estados a medias.

### 3.12 Bandera de funcionalidad (*Feature Flag*) — ligera
- **Dónde:** IA, notificaciones automáticas, módulo de facturación del SaaS.
- **Problema que resuelve:** poder **apagar el asistente de IA o las notificaciones automáticas sin desplegar** si el costo se dispara o un proveedor falla. Con costos por consulta y por mensaje, un interruptor es un control financiero, no un lujo.
- **Detalle:** una tabla de configuración por tenant. No hace falta LaunchDarkly.

### Patrones deliberadamente **no** recomendados

| Patrón | Por qué no |
|---|---|
| **Microservicios / API Gateway / Service Mesh** | §2.2. Costo operativo sin beneficio a esta escala. |
| **Event Sourcing global** | Solo en Caja (§2.2). En clientes y configuración multiplica complejidad sin ganancia. |
| **CQRS con dos bases de datos** | Sincronizar dos almacenes es un problema nuevo que este proyecto no necesita. |
| **Repositorio genérico `Repository<T>`** | Abstracción vacía: acaba filtrando el ORM igual, con una capa más de indirección. |
| **Inyección de dependencias con contenedor pesado** | Composición manual en el arranque es suficiente y más legible para un equipo de uno. |

---

## 4. Tecnologías y lenguajes

### 4.0 El criterio que ordena todas estas decisiones

**Un solo lenguaje en todo el stack.** Con 1 desarrollador y 16 h/semana, cada lenguaje adicional es un costo permanente: otro conjunto de herramientas, otro gestor de paquetes, otro pipeline de CI, otro cuerpo de conocimiento que mantener fresco. Y, más importante: los **tipos del dominio y las reglas de validación se comparten** entre backend, web y móvil en lugar de reimplementarse tres veces y desincronizarse.

Ese lenguaje es **TypeScript**.

### 4.1 Lenguaje principal: **TypeScript**

| Opción | A favor | En contra | Veredicto |
|---|---|---|---|
| **TypeScript** | Único lenguaje viable para backend + web + móvil. Tipado estático que atrapa errores de dominio en compilación. Ecosistema enorme. Excelente soporte de agentes de IA. Tipos compartidos extremo a extremo. | El tipado es borrado en runtime (se mitiga validando en el borde, §4.7) | ✅ **Recomendado** |
| **Python (FastAPI/Django)** | Excelente para la parte de datos/IA; Django trae admin y ORM maduros | **Rompe el criterio de un solo lenguaje**: obliga a TS o Dart en los clientes de todos modos. El móvil offline no tiene camino en Python. | Alternativa si el desarrollador ya es fuerte en Python **y acepta dos lenguajes** |
| **Java / Kotlin (Spring Boot)** | El más sólido para dominios financieros; transaccionalidad de primera | Verbosidad y ciclo de iteración lento para 1 persona part-time; sobredimensionado para el MVP | ❌ para este equipo |
| **Go** | Rendimiento y despliegue simple (un binario) | Ecosistema más pobre para reportes Excel/PDF y para el resto del stack; menos apalancamiento con agentes de IA | ❌ |
| **PHP (Laravel)** | Muy productivo, ecosistema maduro para CRUD | Rompe el criterio de un solo lenguaje; el móvil offline queda fuera | ❌ |

> **Sobre el lenguaje del dominio en el código:** usar **español para los términos del negocio** (`Prestamo`, `Cuota`, `Mora`, `Caja`, `Llave`, `Gestor`, `Unidad`) e inglés para el andamiaje técnico (`Repository`, `Service`, `Controller`, `Handler`). El dominio es hispanohablante, los usuarios son hispanohablantes, y el material de requerimientos está en español. Traducir `préstamo→loan`, `mora→arrears`, `llave→key` introduce una capa de traducción mental permanente y errores sutiles (¿`key` es la llave de autorización o una clave de base de datos?). Esto es *ubiquitous language* de DDD aplicado literalmente. **Un glosario en el repositorio y consistencia absoluta** — lo peor es mezclar.

### 4.2 Backend: **NestJS** (TypeScript) sobre Node.js

| Opción | Veredicto | Razón |
|---|---|---|
| **NestJS** | ✅ **Recomendado** | Impone estructura modular por diseño — que es exactamente el monolito modular de §2.1. Módulos, inyección de dependencias, interceptores (perfectos para el contexto de tenant y la auditoría), *guards* (perfectos para RBAC), soporte transaccional de primera. **La estructura que impone es la disciplina que un desarrollador solo necesita para no degradar el código en el mes 3.** |
| **Fastify / Express minimalista** | ⚠️ Alternativa | Más ligero y rápido de arrancar, pero **no impone estructura**. Con 10 módulos, auditoría transversal y multi-tenancy, la falta de convenciones se paga. Viable si el desarrollador tiene criterio arquitectónico fuerte. |
| **Hono / Elysia** | ❌ | Excelentes y modernos, pero ecosistema aún inmaduro para un sistema financiero con requisitos de auditoría. |

### 4.3 Base de datos: **PostgreSQL** — sin alternativa seria

Es la única elección defendible, y por razones específicas de este proyecto, no por popularidad:

- **Transacciones ACID reales** — no negociable para los 9 pasos del registro de pago.
- **Row-Level Security nativo** — el mecanismo de aislamiento multi-tenant de §2.4. MySQL no lo tiene.
- **Tipos numéricos exactos** (`NUMERIC`, `BIGINT`) — sin errores de punto flotante en dinero.
- **PITR (Point-in-Time Recovery)** — cumple directamente el requisito §12 del doc fuente.
- **JSONB** para el payload flexible de auditoría, sin renunciar al esquema relacional del núcleo.
- **PostGIS** disponible si la geolocalización crece a consultas espaciales reales (geocercas para validar que el gestor está donde dice, `OQ-F-10`).
- **Extensible a cola de trabajos** — evita añadir Redis (§4.9).

**MongoDB queda descartado** de forma tajante: un dominio financiero con integridad referencial estricta, transacciones multi-documento y agregaciones contables es exactamente el caso donde un modelo documental cuesta más de lo que ahorra.

**ORM:** **Drizzle ORM** (SQL-first, tipado, migraciones explícitas, se aparta cuando hace falta SQL crudo para los reportes contables) o **Prisma** (mejor DX y ecosistema, menos control fino sobre el SQL generado). Recomiendo **Drizzle** para este caso: en un sistema donde hay que auditar exactamente qué SQL se ejecuta y escribir agregaciones contables no triviales, el control gana sobre la comodidad.

### 4.4 Frontend web: **React + TypeScript + Vite**, con **TanStack Query** y **shadcn/ui + Tailwind CSS**

- **React + Vite** en lugar de Next.js: la consola es una **aplicación interna autenticada**. No necesita SEO, ni renderizado en servidor, ni generación estática — que es donde Next.js aporta. A cambio, Next.js añade complejidad de despliegue y un modelo mental (Server Components, límites cliente/servidor) que no paga aquí. Una SPA con Vite despliega como archivos estáticos, es más simple de razonar y más barata de servir. *(Elegir Next.js si en el futuro se agrega un portal público para el cliente final.)*
- **TanStack Query** para el estado del servidor: caché, revalidación, reintentos y estados de carga resueltos. Elimina la mayor parte del código de estado que suele escribirse a mano.
- **shadcn/ui + Tailwind CSS**: el requisito §9.3 pide explícitamente la estética de **Stripe / Linear / Notion / HubSpot** — SaaS empresarial moderno con densidad de datos controlada. shadcn/ui es literalmente ese lenguaje visual, y como el código de los componentes vive en el repositorio (no es una dependencia opaca), se puede ajustar sin pelear con la librería. **Es el camino más corto entre el requisito estético declarado y el resultado.**
- **TanStack Table** para las cuadrículas densas (reporte de ventas, cartera, movimientos de caja), que son el corazón de la consola.

### 4.5 Móvil: **React Native + Expo**

Esta es la decisión más discutible del documento, así que va con el razonamiento completo.

| Opción | A favor | En contra |
|---|---|---|
| **React Native + Expo** | **Mismo lenguaje y mismos tipos que backend y web.** Un desarrollador solo no cambia de contexto mental entre proyectos. Expo resuelve builds, actualizaciones OTA, permisos, cámara y GPS sin tocar código nativo. Arranque ~200 ms más rápido y ~12 % menos consumo de batería que Flutter con la arquitectura Fabric — ambos relevantes para un gestor en calle todo el día. | Rendimiento de UI ligeramente inferior en interfaces muy animadas (irrelevante aquí: son formularios y listas). Mayor costo de mantenimiento anual por cambios de librerías de terceros. |
| **Flutter** | Rendimiento de renderizado superior (58–60 fps con Impeller vs 51 con Fabric); UI idéntica entre plataformas; `drift` es excelente para SQLite local | **Introduce Dart como segundo lenguaje.** Rompe el criterio de §4.0: nada de tipos compartidos, otro ecosistema, otro pipeline. Para un equipo de uno, ese costo supera la ventaja de renderizado en una app de formularios. |
| **Nativo (Kotlin + Swift)** | Máximo control | **Dos aplicaciones más que mantener.** Descartado sin discusión. |

**Veredicto:** React Native + Expo, **salvo que el desarrollador ya sea competente en Flutter/Dart** — en cuyo caso Flutter es una elección igualmente defendible, y la familiaridad existente supera al argumento del lenguaje unificado. La brecha de rendimiento entre ambos se ha estrechado hasta ser irrelevante para el 90 % de las aplicaciones, y esta está claramente en ese 90 %.

🔒 **Bloqueada parcialmente por `OQ-N-31`** (versión mínima de Android y gama de dispositivo objetivo). Si los gestores usan gama muy baja con Android antiguo, el análisis debe rehacerse con datos reales de los equipos.

### 4.6 Sincronización offline: **implementación propia sobre SQLite + cola de comandos**

| Opción | Veredicto | Razón |
|---|---|---|
| **Implementación propia** (SQLite local + tabla de comandos pendientes + *pull* incremental) | ✅ **Recomendada** | Por §2.5, el problema real **no es replicación bidireccional de estado, es una cola de comandos con idempotencia y un pull incremental de solo lectura** — dos piezas que se implementan en días, no semanas. Cero costo, cero dependencia crítica, control total sobre la lógica de negocio de conflictos (que es específica de este dominio y ninguna librería puede adivinar). |
| **PowerSync** | ⚠️ Alternativa seria | El único con soporte offline de primera clase y SDKs oficiales para React Native y Flutter, con reglas de sincronización y manejo de conflictos maduros. **Pero:** es un servicio de pago (o autohospedado, lo que reintroduce operación), y resuelve la replicación de estado — que es precisamente el enfoque que §2.5 descarta para el dinero. |
| **WatermelonDB** | ⚠️ Viable | Base local reactiva sobre SQLite, con protocolo de sincronización, estándar de facto en React Native. Buena opción si se prefiere una base ya construida. Aún así hay que escribir la lógica de sincronización del lado del servidor. |
| **ElectricSQL** | ❌ | Por definición **no cubre persistencia del lado del cliente** — el offline queda fuera de su alcance y hay que implementarlo igual. |

**Recomendación concreta:** SQLite local (vía `expo-sqlite` o `op-sqlite`), con:
1. Tabla `comandos_pendientes` — cola FIFO con `idempotency_key`, reintentos y backoff.
2. *Pull* incremental por `updated_at` para el catálogo de solo lectura (la "descarga UGI").
3. Un indicador de sincronización siempre visible en la app — **el gestor debe saber en todo momento si su trabajo ya llegó al servidor.** Es un requisito de confianza operativa, no de UI.
4. **Cifrado de la base local obligatorio** (SQLCipher): contiene datos financieros y fotos de documentos de identidad (`OQ-N-17`).

### 4.7 Validación: **Zod**, con esquemas compartidos

Un único esquema Zod por entidad, compartido por backend, web y móvil vía paquete interno del monorepo. Valida en el borde, infiere tipos TypeScript automáticamente, y **elimina la clase entera de bugs de "el móvil manda un campo que el backend no espera"**. En un sistema donde los datos llegan desde un dispositivo offline que pudo quedar en una versión antigua, la validación estricta en el borde no es opcional.

### 4.8 Asistente de IA: **Claude vía Anthropic API, con herramientas sobre una API de consulta acotada**

**El patrón correcto — y esto importa mucho:** el modelo **no genera SQL contra la base de datos**. El modelo dispone de un conjunto acotado de **herramientas de solo lectura** (`consultarRecaudoDelDia`, `listarClientesEnMora`, `rendimientoPorGestor`, `carteraPorZona`, …) que ejecutan consultas parametrizadas y ya filtradas por tenant y por rol.

**Por qué no *text-to-SQL* directo:**
- Un LLM generando SQL libre contra una base financiera multi-tenant es una **superficie de fuga de datos entre clientes y de inyección** de primer orden.
- Las respuestas son verificables y auditables: cada herramienta es código testeado, no SQL improvisado.
- El costo por consulta es predecible y acotado.

**Configuración recomendada:**
- **Modelo:** `claude-opus-5` como opción por defecto (US$5 / US$25 por millón de tokens de entrada/salida). Para una carga de consultas operativas de alto volumen, `claude-sonnet-5` (US$3 / US$15, con precio introductorio de US$2 / US$10 hasta el 2026-08-31) es una palanca de costo legítima — pero es **decisión de negocio, no técnica**, y depende del presupuesto de `OQ-N-40`.
- **SDK oficial de Anthropic** para TypeScript (`@anthropic-ai/sdk`), con el *tool runner* que gestiona el ciclo de llamada a herramientas.
- **Pensamiento adaptativo** (`thinking: { type: "adaptive" }`) — el modelo decide cuánta deliberación amerita cada consulta.
- **Caché de prompts** sobre el prompt de sistema y el catálogo de herramientas: reduce hasta ~90 % el costo de la porción repetida en cada consulta. Con un asistente que se llama muchas veces al día con el mismo contexto de esquema, esto es la diferencia entre un costo trivial y uno molesto.
- **Salidas estructuradas** (`output_config.format`) donde la respuesta alimenta un componente de la UI en lugar de mostrarse como texto.

🔒 **Bloqueada por `OQ-T-15` y `OQ-N-25`:** si LGPD o el cliente exigen que **ningún dato salga del país**, el asistente de IA no puede usar una API externa tal cual. La mitigación es enviar solo agregados y metadatos, nunca filas con datos personales identificables — lo cual el patrón de herramientas acotadas ya facilita, porque cada herramienta controla exactamente qué se expone.

**Recomendación de alcance:** el asistente es la funcionalidad con **mayor relación coste/beneficio desfavorable del MVP**. Es lo primero a mover a Fase 2 si hay que recortar (`OQ-B-10`).

### 4.9 Cola de trabajos: **pg-boss** (sobre el mismo PostgreSQL)

Notificaciones, reportes pesados, recordatorios programados (T-1, T+1, T+3, T+7), cierre diario y reporte a socios necesitan ejecución diferida y programada.

**pg-boss** usa PostgreSQL como sustrato: **cero infraestructura adicional**, transaccionalidad compartida con los datos del negocio (esencial para el patrón outbox de §3.3), y persistencia y reintentos incluidos. BullMQ + Redis es más potente pero introduce **otro servicio que operar** — precisamente lo que §4.0 evita. A este volumen, pg-boss es holgadamente suficiente.

### 4.10 Reportes Excel y PDF

- **Excel:** `ExcelJS`. El requisito §4 exige **replicar visualmente la estructura de las hojas actuales** para que los socios las lean sin reaprender. ExcelJS controla formato, fórmulas, anchos y estilos con el detalle necesario.
- **PDF:** renderizar HTML+CSS con **Puppeteer** en un job en segundo plano. Permite reutilizar los mismos componentes visuales de la web, en lugar de mantener un motor de maquetación paralelo.

🔒 **Bloqueada por `OQ-F-52`:** hace falta **el archivo Excel real** del cierre de caja actual. No es una respuesta, es un adjunto — y sin él, "replicar el formato" no es implementable.

### 4.11 Estructura del repositorio: **monorepo** con pnpm workspaces + Turborepo

```
tripri/
├── apps/
│   ├── api/          # NestJS
│   ├── web/          # React + Vite
│   └── mobile/       # React Native + Expo
├── packages/
│   ├── dominio/      # tipos, esquemas Zod, cálculos financieros puros
│   ├── contratos/    # contratos de la API compartidos
│   └── ui/           # componentes compartidos (donde aplique)
└── infra/            # Terraform / IaC
```

El paquete **`dominio`** es la pieza clave: contiene los cálculos financieros como **funciones puras sin dependencias**, testeadas exhaustivamente, y usadas tanto por el backend (autoritativo) como por el móvil (proyección local optimista). **Una sola fórmula de interés en todo el sistema, imposible de desincronizar.**

### 4.12 Facturación del SaaS: **checkout hospedado, cero datos de tarjeta en el sistema** 🆕

Nace de `D-01`/N8: es el único punto donde el aplicativo mueve dinero real, y **sólo en la web**.

**La regla que gobierna todo este módulo:** *ningún dato de tarjeta entra jamás en el sistema.*
El usuario se redirige al **checkout hospedado del proveedor** (o a un componente embebido que
tokeniza en el navegador contra el proveedor, nunca contra nuestro backend), y lo único que
guardamos es un **identificador de suscripción y de cliente** del proveedor. Con eso el alcance
PCI-DSS colapsa de un cuestionario completo a **SAQ-A**, el más liviano que existe.

> Capturar la tarjeta en la propia web para "que se vea más integrado" es la decisión que
> convierte un módulo de dos semanas en un proyecto de cumplimiento anual. **No se hace**
> (`OQ-N-42` lo eleva a decisión explícita del negocio, no a un supuesto del desarrollador).

| Decisión | Recomendación | Razón |
|---|---|---|
| **Pasarela** | 🔒 **Bloqueada por `OQ-T-26` y `OQ-B-2`** (depende del país de facturación). Si es Brasil: **Asaas**, **Pagar.me** o **Iugu** — soportan PIX recurrente y boleto, que es como se paga B2B allí. Si hay entidad internacional: **Stripe Billing**. En Colombia/LatAm mixto: **Mercado Pago**. | Un proveedor que no soporte PIX/boleto en Brasil obliga a la tarjeta, y la penetración de tarjeta corporativa allí es baja |
| **Modelo de integración** | Suscripciones gestionadas por el proveedor + **webhooks** hacia el backend | No reimplementar ciclos de facturación, reintentos ni dunning: es un problema resuelto y aburrido |
| **Webhooks** | Verificación de firma obligatoria · **idempotencia por `event_id`** · procesamiento asíncrono vía `pg-boss` | Los proveedores reenvían eventos. Sin idempotencia, un tenant queda suspendido dos veces o reactivado por un evento viejo |
| **Estado de la suscripción** | Máquina de estados propia (`trial → activa → en_gracia → solo_lectura → suspendida → cancelada`), alimentada por los webhooks | El sistema debe saber decir *por qué* un tenant está bloqueado sin llamar a la API del proveedor |
| **Aislamiento** | Módulo separado, **sin acceso al ledger de cobranza** ni a datos de clientes finales; comunicación por eventos internos | Que un fallo de facturación no pueda corromper el registro de la operación de cobranza — ni al revés |
| **Superficie móvil** | **Ninguna.** Cero endpoints de facturación expuestos a la app | Decisión explícita del usuario, y además evita las reglas de compras in-app de las tiendas (§5.7) |
| **Documento fiscal** | 🔒 `OQ-F-96`. Si hay que emitir nota fiscal en Brasil, se integra un emisor (**NFE.io**, **eNotas**) o lo asume la propia pasarela | Emitir documentos fiscales a mano dentro del sistema es un proyecto en sí mismo |

**Esfuerzo estimado:** ~2 semanas con checkout hospedado y planes simples. **Si `OQ-B-18` dice
que en la fase 1 la facturación se maneja por fuera** (factura manual y transferencia), el módulo
se reduce a *una tabla de suscripciones y un interruptor de suspensión manual* — unas horas — y
esas dos semanas se van íntegras al núcleo de cobranza. **Es la recomendación por defecto para el MVP.**

### 4.13 Resumen del stack

| Capa | Recomendación | Alternativa seria |
|---|---|---|
| Lenguaje | TypeScript | Python (rompe el criterio de un lenguaje) |
| Backend | NestJS | Fastify |
| Base de datos | PostgreSQL + RLS | — |
| ORM | Drizzle | Prisma |
| Web | React + Vite + TanStack Query | Next.js |
| UI | shadcn/ui + Tailwind | Mantine |
| Móvil | React Native + Expo | Flutter (si ya hay experiencia) |
| Base local móvil | SQLite (cifrada) + cola de comandos | WatermelonDB, PowerSync |
| Validación | Zod (esquemas compartidos) | — |
| Cola de trabajos | pg-boss | BullMQ + Redis |
| Autenticación | Ver §5.4 | — |
| IA | Claude (`claude-opus-5`) + herramientas | `claude-sonnet-5` por costo |
| **Cobro del SaaS** (solo web) | **Checkout hospedado + webhooks** (Asaas/Pagar.me/Iugu en Brasil · Stripe Billing internacional) 🔒 `OQ-T-26` | Facturación manual fuera del sistema en la fase 1 — **recomendado para el MVP** |
| Excel / PDF | ExcelJS / Puppeteer | — |
| Pruebas | Vitest + Testcontainers + Playwright | Jest |
| Repositorio | Monorepo (pnpm + Turborepo) | Multi-repo |

---

## 5. Infraestructura

### 5.1 El criterio: **PaaS gestionado, no infraestructura autogestionada**

Un desarrollador con 16 h/semana **no puede ser también administrador de sistemas**. Cada hora dedicada a parchear un servidor, rotar certificados o depurar Kubernetes es una hora que no se dedica a la lógica financiera. La recomendación completa está sesgada, deliberada y explícitamente, hacia **maximizar lo gestionado**.

### 5.2 Recomendación principal

| Componente | Recomendación | Por qué |
|---|---|---|
| **Región** | **Brasil (São Paulo — `sa-east-1` / equivalente)** | PIX ⇒ operación en Brasil ⇒ **LGPD**. La residencia de datos deja de ser una preferencia y pasa a ser probable requisito legal (`OQ-N-25`). Además reduce la latencia — relevante para el objetivo de <200 ms. |
| **Backend** | **Contenedor gestionado**: Railway, Render, Fly.io o AWS App Runner | Despliegue desde Git, escalado automático, TLS, sin gestión de servidores. Un `Dockerfile` y listo. |
| **Base de datos** | **PostgreSQL gestionado con PITR**: Supabase, Neon o AWS RDS | PITR cubre el requisito §12 directamente. Supabase suma Auth y Storage integrados y tiene región en São Paulo. |
| **Almacenamiento de fotos** | **Cloudflare R2** (compatible S3) con subida por URL prefirmada | **Sin cargos de egreso** — el ahorro decisivo cuando gestores y administradores ven fotos constantemente desde móvil. `OQ-N-4` lo señala como el mayor costo recurrente probable, y R2 lo neutraliza en buena medida. |
| **CDN** | Cloudflare | Incluido con R2; sirve también los estáticos de la web. |
| **Push** | Firebase Cloud Messaging (Android + iOS vía APNs) | Estándar de facto, gratuito, integración directa con Expo. |
| **WhatsApp** | **Meta Cloud API directo**, detrás del puerto de §3.9 | Sin intermediario, sin margen de un BSP. El adaptador permite migrar a 360dialog o Twilio sin tocar el dominio. |
| **Pasarela de cobro del SaaS** 🆕 | **Checkout hospedado** del proveedor (§4.12), sólo alcanzable desde la web | Único punto con dinero real (`D-01`). Alcance PCI-DSS reducido a **SAQ-A** porque ningún dato de tarjeta toca la infraestructura. 🔒 `OQ-T-26` |
| **CI/CD** | GitHub Actions | Gratuito para repositorio privado a esta escala; lint + tipos + pruebas + migraciones + despliegue. |
| **Observabilidad** | **Sentry** (errores) + logs estructurados (Axiom/Better Stack) + métricas del proveedor | Sentry es la pieza no negociable: con un desarrollador, enterarse de los errores por el usuario es demasiado tarde. |
| **Gestión de secretos** | Gestor de secretos del PaaS + Doppler o AWS Secrets Manager | **Nunca en el repositorio.** (`OQ-T-12`) |
| **IaC** | Terraform, **a partir de la Fase 2** | En Fase 1 la configuración por consola es más rápida. Cuando se estabilice, codificarla. Adoptar Terraform el día 1 con 1 desarrollador retrasa el arranque sin beneficio inmediato. |

### 5.3 Alternativas de proveedor

| Opción | Veredicto |
|---|---|
| **Supabase + Fly.io/Railway + Cloudflare R2** | ✅ **Recomendada.** Máxima velocidad para un desarrollador solo. Postgres gestionado con RLS y PITR, Auth y Storage listos, región en São Paulo, costo inicial bajo. |
| **AWS completo** (App Runner/ECS + RDS + S3 + Cognito) | ⚠️ Alternativa. Mayor credibilidad ante clientes empresariales y mejor historia de cumplimiento. **Costo:** más configuración, IAM, VPC y curva de aprendizaje — tiempo que este equipo no tiene. Recomendable **si el cliente lo exige** o al escalar. |
| **Google Cloud / Azure** | Sin ventaja diferencial aquí. Descartadas por simplicidad. |
| **VPS autogestionado (Hetzner/DigitalOcean + Docker Compose)** | ❌ El más barato en dinero y el más caro en tiempo. Backups, parches, TLS, monitoreo y recuperación pasan a ser trabajo del desarrollador. **Falso ahorro** para un sistema financiero con requisitos de RPO/RTO. |

### 5.4 Autenticación: **servicio propio sobre el backend**, no un IdP externo

Contraintuitivo, y la razón es concreta: **los requisitos de autenticación de este sistema no son estándar.**

- Vinculación estricta **1 dispositivo ↔ 1 unidad** con desvinculación remota inmediata y error "dispositivo no coincide".
- Sistema de llaves de autorización con códigos temporales.
- Sesión persistente en el móvil que debe sobrevivir días sin conexión.
- Roles y permisos con jerarquía de unidades propia.

Un IdP gestionado (Auth0, Clerk, Cognito) resuelve el 60 % genérico y **estorba en el 40 % específico**, que es justo el que da valor. La recomendación: JWT de acceso corto + *refresh token* rotativo ligado al `device_id`, con Argon2id para contraseñas. Si se usa Supabase, su Auth cubre el registro y las contraseñas, y la lógica de dispositivo y llaves vive en el backend propio.

🔒 **Bloqueada por `CX-3`:** el doc fuente no menciona MFA; el reporte 02 sí. Si MFA entra en alcance, la balanza se inclina hacia un IdP gestionado.

### 5.5 Respaldos, RPO y RTO

El material especifica **frecuencia** de respaldos (horaria, diaria, semanal, mensual) pero **nunca el objetivo** (`OQ-N-11`, `OQ-N-12`). Y ahí está el problema:

> **Respaldos horarios implican un RPO de 1 hora — es decir, aceptar perder hasta una hora de cobros registrados.** Para una operación de cobranza diaria en efectivo, eso puede significar decenas de pagos irrecuperables y clientes que juran haber pagado sin que el sistema lo registre. **Casi con certeza el RPO real necesario es ~0.**

**Recomendación:** PostgreSQL gestionado con **PITR** (recuperación a un punto en el tiempo), que da RPO de segundos, no de una hora — y cubre el requisito con mejor garantía que la especificada. Adicionalmente:
- Respaldo lógico diario (`pg_dump`) exportado a almacenamiento independiente del proveedor de base de datos.
- **Un simulacro de restauración documentado antes de salir a producción** (`OQ-N-14`). Un respaldo que nunca se restauró no es un respaldo, es una suposición.
- Los datos del móvil son un respaldo natural adicional: mientras la cola de comandos no se confirme como sincronizada, el trabajo del gestor sigue en el dispositivo.

### 5.6 Costo mensual estimado (orden de magnitud, MVP)

| Concepto | Estimado (USD/mes) | Nota |
|---|---|---|
| Backend (contenedor gestionado) | 10 – 25 | |
| PostgreSQL gestionado con PITR | 25 – 50 | |
| Almacenamiento R2 + CDN | 5 – 15 | Sin cargos de egreso |
| Sentry + logs | 0 – 30 | Planes gratuitos alcanzan al inicio |
| **WhatsApp Business API** | **Ver abajo** | **El costo que escala con la operación** |
| Anthropic API (asistente IA) | 10 – 60 | Depende del volumen; caché de prompts lo reduce fuertemente |
| **Pasarela de cobro del SaaS** | 0 fijo + **~3–5 % por transacción** (tarjeta) o **~1 % / tarifa fija** (PIX y boleto en Brasil) | Sólo si `OQ-B-18` mete la facturación en el MVP. **No es un costo de infraestructura, es un descuento sobre el ingreso**: entra en el precio de lista, no en este presupuesto |
| **Total infraestructura base** | **~50 – 180** | Excluyendo WhatsApp y la comisión de la pasarela |

**WhatsApp merece cálculo aparte, porque es el único costo que crece con el éxito del negocio.** Desde 2026 Meta cobra **por mensaje**, no por conversación de 24 h. Tarifas en Brasil (2026): mensaje de *utilidad* ≈ **US$0.0068**, *autenticación* ≈ US$0.0068, *marketing* ≈ **US$0.0625** — unas **9 veces más caro**. Los mensajes de *servicio* (respuestas dentro de la ventana de 24 h iniciada por el cliente) son gratuitos.

> **Implicación de diseño directa:** la **clasificación de las plantillas** es la mayor palanca de costo del proyecto. Confirmaciones de pago, avisos de mora y recordatorios deben registrarse como plantillas de **utilidad**, no de marketing. Una plantilla mal clasificada multiplica la factura por 9.

Ejemplo: 500 préstamos activos con cobro diario ⇒ ~500 confirmaciones/día ⇒ ~15 000 mensajes/mes ⇒ **~US$100/mes** solo en confirmaciones de pago. Sumando recordatorios (T-1, T+1, T+3, T+7) y avisos de mora, puede duplicarse.

> 🔒 **Este cálculo es la razón por la que `OQ-N-40` (presupuesto) es P0.** Si el negocio no tolera ~US$200/mes de mensajería, hay que decidir **cuáles notificaciones son automáticas y cuáles opcionales** — y esa es una decisión de producto que cambia el diseño del motor de reglas.

### 5.7 Distribución de la app móvil — el riesgo regulatorio menos evidente

**Google Play y Apple aplican políticas específicas y restrictivas a las aplicaciones de préstamos personales**, y este es un riesgo que el material de entrada no contempla en absoluto:

- **Google Play prohíbe a las apps de préstamos personales acceder a datos sensibles del usuario: fotos, vídeos, contactos, ubicación precisa y registro de llamadas.** El sistema diseñado **usa fotos y ubicación precisa de forma central**.
- Se exige declaración financiera con documentación del prestamista y, en varios países, **prueba de licencia válida** emitida por la autoridad correspondiente.
- Se exige divulgar tasa máxima anual (APR), esquema de pagos, comisiones y un ejemplo representativo del costo total.
- No se permiten préstamos con devolución total en 60 días o menos — **lo cual afecta directamente a las modalidades diaria y semanal.**

**Mitigación:** la app del gestor es una **herramienta interna de empleados**, no una app de préstamos de cara al consumidor, lo cual cambia la categoría aplicable. Pero eso hay que **argumentarlo ante la tienda**, y la alternativa es distribución gestionada (MDM / Play Store gestionado / enterprise), que evita la revisión pública.

> **`D-01` refuerza ese argumento con dos hechos verificables**, y conviene ponerlos por escrito en la declaración a la tienda (`OQ-N-43`):
> 1. **La app no procesa ni acepta pagos de ningún tipo.** No hay compras in-app, no hay suscripciones en el móvil, no hay captura de medios de pago. Queda fuera de las reglas de facturación de Apple y Google.
> 2. **La app no origina ni desembolsa préstamos al consumidor final.** Registra la gestión de cobranza de una cartera ya existente, operada por empleados de la empresa.
>
> Sigue en pie el problema de fondo, que es **el acceso a fotos y ubicación precisa** en un contexto de préstamos personales. `D-01` no lo resuelve — sólo elimina una de las tres objeciones posibles.

> 🔒 **`OQ-N-34` es P0 y probablemente más urgente de lo que su prioridad sugiere.** Un rechazo de tienda descubierto en el mes 4 bloquea el lanzamiento entero. **Recomiendo validar la vía de distribución en la Fase 0, antes de escribir la primera línea de la app.**

---

## 6. Estrategia de pruebas

Con un desarrollador, una app offline y dinero de por medio, **las pruebas no son una buena práctica: son la única red de seguridad que existe.** Pero hay que ser selectivo — cobertura uniforme del 90 % es un desperdicio de las 16 h/semana.

| Área | Tipo de prueba | Cobertura objetivo |
|---|---|---|
| **Matemática financiera** (interés, cronograma, imputación de pagos, mora) | Unitarias sobre funciones puras del paquete `dominio` | **≥ 95 %, no negociable** |
| **Cierre de caja y cuadre** | Unitarias + de integración sobre el ledger | **≥ 95 %** |
| **Flujos transaccionales** (los 9 pasos del pago) | Integración con Postgres real vía **Testcontainers** | Alta |
| **Sincronización e idempotencia** | Integración, simulando reintentos, duplicados y desorden | **Alta — aquí viven los peores bugs** |
| **Aislamiento multi-tenant (RLS)** | Integración: intentar leer datos de otro tenant **debe fallar** | 100 % de las tablas |
| **API REST** | Contrato / integración | Media |
| **UI web y móvil** | Playwright para los 3–4 recorridos críticos únicamente | Baja y selectiva |

Las pruebas de aislamiento entre tenants merecen mención aparte: son **rápidas de escribir, se ejecutan en segundos y previenen la clase de fallo más grave del sistema.** Una prueba por tabla que verifica que el tenant A no puede leer nada del tenant B.

---

## 7. Ruta de implementación sugerida

Ordenada por **riesgo descendente**, no por facilidad. La lógica: lo que puede matar el proyecto se prueba primero, cuando cambiar de rumbo todavía es barato.

| Fase | Contenido | Por qué en este orden |
|---|---|---|
| **0 — Desbloqueo** (1–2 sem) | Responder los P0 de §8. Validar vía de distribución móvil. Obtener el Excel real del cierre. Confirmar país, moneda y régimen legal. | **Cinco decisiones aquí evitan meses de reescritura.** Ninguna requiere código. |
| **1 — Esqueleto vertical** (2–3 sem) | Monorepo, PostgreSQL con RLS, autenticación, un módulo completo extremo a extremo (Clientes) atravesando web + API + móvil + sincronización. CI/CD desplegando a producción desde el día 1. | Prueba la arquitectura completa con la funcionalidad más simple. Si la sincronización no funciona con clientes, tampoco va a funcionar con dinero. |
| **2 — Núcleo financiero** (4–6 sem) | Créditos + cronogramas + libro mayor + registro de pagos + cierre de caja. | **El corazón del sistema y el mayor riesgo técnico.** Con máxima cobertura de pruebas. |
| **3 — Operación de campo** (3–4 sem) | App móvil completa: ruta, cobros offline, "no pago", fotos, firma, vinculación de dispositivo. | Depende de que la Fase 2 sea correcta. |
| **4 — Control y gobernanza** (2–3 sem) | Sistema de llaves, límites, aprobaciones, auditoría consultable, limpieza de cartera. | |
| **5 — Comunicación** (2 sem) | WhatsApp con outbox, motor de reglas, plantillas, recordatorios, reporte a socios. | Detrás de bandera de funcionalidad, para controlar el costo desde el primer día. |
| **6 — Reportes** (2 sem) | Exportación Excel/PDF replicando el formato heredado, dashboard de KPIs. | |
| **7 — Inteligencia** (2 sem) | Asistente de IA con herramientas acotadas. | **Lo último. Lo primero en recortarse** si el tiempo aprieta. |
| **8 — Facturación del SaaS** (0 – 2 sem) 🆕 | Suscripciones, checkout hospedado, webhooks, suspensión por impago (§4.12). | **Sólo si `OQ-B-18` la mete en el MVP.** Por defecto: **0 semanas** — se factura por fuera y basta una tabla de suscripciones con suspensión manual. No hay un solo cliente pagando hasta que el producto funcione, así que construir la caja registradora antes que la tienda es invertir en el orden equivocado. |

**Total estimado: 18–24 semanas a 16 h/semana** — coherente con la estimación de 13–17 semanas del chat de NotebookLM, pero **más conservadora**, porque aquella no contemplaba multi-tenancy, cumplimiento LGPD, ni la profundidad real del cierre de caja.

---

## 8. Decisiones bloqueadas — lo que hace falta para cerrar el diseño

Diez respuestas. Cada una bloquea una decisión técnica concreta y **cara de revertir**.

> ✅ **Una se cayó de esta lista con `D-01`:** *"¿el sistema custodia dinero o sólo lo registra?"*
> Estaba implícita y contaminaba regulación, seguridad, integración bancaria y distribución móvil.
> **Ya está respondida: sólo registra.**

| # | Pregunta | Ref. | Qué bloquea exactamente |
|---|---|---|---|
| 1 | **¿País, moneda y régimen legal?** (PIX⇒Brasil vs. formato monetario colombiano) | `CX-8`, `OQ-B-2`, `OQ-N-21`, `OQ-N-23` | **Región de despliegue, residencia de datos, LGPD vs. Habeas Data, idioma de la interfaz, viabilidad legal del asistente de IA.** Es la pregunta más transversal del documento. *(`D-01` acota su lado regulatorio: aplica la regulación del préstamo y de datos, no la de medios de pago.)* |
| 2 | **¿Multi-tenant desde el día 1, o producto para una sola empresa?** | `CX-1`, `OQ-B-3`, `OQ-N-28` | Modelo de datos y estrategia de aislamiento. *(La recomendación de §2.4 es robusta a ambas respuestas — pero confirmar cambia el alcance del panel de administración.)* |
| 3 | **¿Cuál es la fórmula de interés y cómo se genera el cronograma?** | `OQ-F-13` a `OQ-F-18` | **El núcleo del producto.** Ninguna fuente la contiene. Sin ella, el módulo de Créditos no es implementable — solo simulable. |
| 4 | **¿Cómo se imputan pagos parciales y cómo se revierte un pago?** | `OQ-F-30`, `OQ-F-31`, `OQ-F-33` | El diseño del libro mayor y la regla de conflictos de la sincronización. |
| 5 | **¿Distribución en tiendas oficiales o gestionada?** | `OQ-N-34` | **Puede bloquear el lanzamiento completo.** Las restricciones de Google Play sobre fotos y ubicación precisa chocan de frente con el diseño. Validar en Fase 0. |
| 6 | **¿Presupuesto mensual de infraestructura + WhatsApp + IA?** | `OQ-N-40` | Qué notificaciones son automáticas, qué modelo de IA, y si el asistente entra en el MVP. |
| 7 | **El archivo Excel real del cierre de caja actual** | `OQ-F-52` | El requisito "replicar el formato" es inimplementable sin el archivo. **No es una respuesta, es un adjunto.** |
| 8 | **¿Equipo real y dedicación?** (¿se confirma 1 dev junior, 16 h/sem?) | `OQ-B-9`, `OQ-T-3` | **Este documento entero.** Con 3 desarrolladores sénior, varias decisiones cambiarían — especialmente móvil y arquitectura. |
| 9 | **¿RPO real: se acepta perder 1 hora de pagos?** | `OQ-N-11`, `OQ-N-12` | Estrategia de respaldos y el diseño de durabilidad de la cola offline. |
| 10 | **¿El cobro del software entra en el MVP, y cómo se cobra?** 🆕 | `OQ-B-18`, `OQ-B-4`, `OQ-F-93`, `OQ-F-94`, `OQ-T-26`, `OQ-N-42` | **Si existe o no el módulo de §4.12 en la fase 1** (0 vs. 2 semanas), qué pasarela se integra y qué pasa con un tenant moroso. Con `D-01`, es el único sitio del producto donde se mueve dinero real: **la respuesta por defecto recomendada es "fuera del MVP"**, pero es decisión de negocio. |

---

## 9. Síntesis

| Dimensión | Recomendación | Motivo en una línea |
|---|---|---|
| **Naturaleza** | **Sistema de registro financiero, no custodio de fondos** (`D-01`) | Máximo rigor contable con mínima superficie regulatoria: sin licencia de medio de pago y sin PCI-DSS en el núcleo |
| **Arquitectura** | Monolito modular + libro mayor inmutable + sincronización por comandos | Transacciones ACID que cruzan módulos, auditoría por construcción, y cero conflictos de merge en el dinero |
| **Patrones** | Ledger, idempotencia, outbox, máquina de estados, estrategia, puertos y adaptadores, RLS | Cada uno resuelve un fallo concreto y verificable de este dominio |
| **Lenguaje** | TypeScript en todo el stack | Un solo desarrollador no puede pagar dos ecosistemas ni tres copias de la misma regla de negocio |
| **Tecnologías** | NestJS · PostgreSQL+RLS · React+Vite · React Native+Expo · SQLite cifrada · Zod · Claude | Máxima velocidad para un equipo de uno, sin sacrificar la corrección donde hay dinero |
| **Infraestructura** | PaaS gestionado en región Brasil, PITR, R2, Sentry, GitHub Actions | Cero administración de sistemas; cumplimiento de residencia de datos por diseño |

**Las dos decisiones que más importan y menos obvias resultan:**

1. **El dinero se modela como un libro mayor inmutable, no como saldos mutables.** Convierte el cierre de caja, la auditoría y los reversos de problemas difíciles en propiedades gratuitas del modelo.
2. **El móvil sincroniza comandos, no estado.** Elimina de raíz la clase de conflictos que hunde las apps offline de cobranza, y mantiene la lógica financiera en un solo lugar.

Todo lo demás es reemplazable. Estas dos, no — o al menos, no sin reescribir el sistema.

---

*Documento generado a partir del material en `context-discovery/notebooklm/` y del registro de preguntas abiertas en `Product-Definition/open-questions.md`. Las recomendaciones marcadas 🔒 se revisarán cuando se resuelvan las preguntas correspondientes.*

**Fuentes consultadas (verificación de estado del arte, julio 2026):**
- [Multi-tenant SaaS: RLS vs schema-per-tenant vs database-per-tenant](https://aliasghar.me/blog/multi-tenant-saas-data-isolation) · [Shipping multi-tenant SaaS using Postgres RLS](https://www.thenile.dev/blog/multi-tenant-rls)
- [ElectricSQL vs PowerSync](https://powersync.com/blog/electricsql-vs-powersync) · [Best Offline-First Tech Stack for 2026](https://cssauthor.com/offline-first-tech-stack/)
- [WhatsApp Business API Pricing Brazil 2026](https://www.messagecentral.com/blog/whatsapp-business-api-pricing-brazil) · [WhatsApp Business API Pricing 2026: Per-Message Rates](https://setsmart.io/blog/whatsapp-business-api-pricing)
- [Google Play — Financial features declaration](https://support.google.com/googleplay/android-developer/answer/13849271?hl=en) · [Google Play policy announcement, July 2026](https://support.google.com/googleplay/android-developer/answer/17134731?hl=en)
- [React Native vs Flutter 2026: A Production Engineering Comparison](https://www.bolderapps.com/blog-posts/react-native-vs-flutter-2026) · [Flutter vs React Native in 2026: An Honest Comparison](https://foresightmobile.com/blog/flutter-vs-react-native-2026)
