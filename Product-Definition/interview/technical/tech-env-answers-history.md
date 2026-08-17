# Technical — Answers History (append-only)

Durable record of every validated answer of the Technical role. Never rewrite or truncate.
Control tokens and IDs stay in English; content follows the user's language (Spanish).

**Mode**: conversational · **Depth**: Quick (`[CORE]` only) · **Pre-fill**: none (user's explicit choice)

---

## Section T1 · Project Technical Summary

### T1 [CORE] — Runtime environment

**Timestamp**: 2026-08-01
**Question**: ¿En qué entorno de ejecución va a vivir este sistema?

> **[Answer]: A** — *"A - Va a estar en AWS"*

**Registrado**: **Solo nube** (Cloud only). Sin componente on-premises.

**Consecuencias**:
- Ninguna restricción de despliegue en instalaciones del cliente. El modo offline de la app
  (C-65) es una capacidad del cliente móvil, **no** un plan de continuidad on-prem.
- `OQ-N-25` (residencia de datos) pasa a ser una decisión de **región de AWS**, no de proveedor.
  Sigue bloqueada por `CX-11` (el país nunca se declaró).

---

### T2 [CORE] — Cloud provider

**Timestamp**: 2026-08-01
**Question**: ¿Qué proveedor de nube se va a usar?

> **[Answer]: A — AWS** *(respondida junto con T1: "Va a estar en AWS")*

**Registrado**: **AWS**, proveedor único. No es multi-cloud.

**Consecuencias**:
- Se aparta de la recomendación de `technical-research/recomendacion-tecnica.md` §5.3, que
  proponía Supabase + Fly.io/Railway + Cloudflare R2 por velocidad de un desarrollador solo, y
  situaba AWS como alternativa *"recomendable si el cliente lo exige o al escalar"*.
  **Esta decisión del líder técnico tiene precedencia sobre la recomendación.**
- `technical-research/infraestructura-aws.md` (663 líneas) ya existe y pasa a ser el documento
  de infraestructura vigente.
- Región probable **`sa-east-1` (São Paulo)** si `CX-11` confirma Brasil — pendiente.
- Nota de costo a verificar en su momento: `sa-east-1` es una de las regiones más caras de AWS
  y **no tiene nivel gratuito para varios servicios**, lo que tensiona `C-105` (*"lo más
  económico posible"*). No es una objeción a la decisión, es un dato para el dimensionado.

---

### T3 [CORE] — Deployment model

**Timestamp**: 2026-08-01
**Question**: ¿Cuál es el modelo de despliegue objetivo?

> **[Answer]: B** — *"B) se va a hacer desde el principio ECS"*

**Registrado**: **Contenedores sobre ECS Fargate, desde el inicio.** No hay fase serverless
previa. **EKS queda descartado explícitamente.**

**Contexto aportado por el usuario durante la decisión** (dato nuevo, no estaba en el material):

> **Escala inicial real: 30–40 usuarios y 1.200 clientes finales.**

Esto es información de negocio que **no coincide con la ambigüedad de `CX-19`** (los "5.000" de
C-05). Interpretación: 1.200 clientes es la operación **propia** de hoy; los 5.000 son la
ambición de suscriptores. No lo cierra —`CX-19` sigue abierta y hay que confirmarla con el
cliente— pero da una base concreta para dimensionar la fase 1.

**Carga derivada de ese dato**: ~1.200 registros de pago/día (préstamos diarios lunes–sábado,
C-12), concentrados 14:00–21:00 (C-101) ⇒ **~3 pagos/minuto en pico**. Volumen bajo: la tarea
Fargate más pequeña sobra.

**Alternativas evaluadas y descartadas**:

| Opción | Veredicto |
|---|---|
| **AWS App Runner** | ❌ **Descartada por hecho verificado: no está disponible en `sa-east-1`** (confirmado por el usuario) |
| **Lambda idiomático** (función por endpoint) | ❌ Estorba en los tres puntos donde está el riesgo: pool de conexiones a PostgreSQL en transacciones multi-sentencia del ledger; abanico de ~1.200 mensajes al cierre de caja (SQS + DLQ + concurrencia contra un worker con cola); arranque en frío en la rampa de las 14:00, justo la franja crítica de C-102 |
| **Imagen única portable: Lambda → Fargate** | ❌ Considerada seriamente y descartada. Viable solo con la disciplina de no acoplarse a servicios serverless; el riesgo de deriva con un solo desarrollador sin revisor se juzgó mayor que el ahorro |
| **EKS / Kubernetes** | ❌ ~73 USD/mes de plano de control antes de correr nada, más nodos, versiones, CNI, ingress, cert-manager e IRSA. Para 3 piezas (API, worker, estáticos) y un equipo técnico de **una persona**, el costo en horas se estimó en 20–40% del tiempo disponible |
| **EC2 autogestionado** | ❌ Parches, TLS, respaldos y monitoreo pasan a ser trabajo del único desarrollador |

**Razón decisiva** (no fue la escala ni el costo de cómputo): a este volumen la diferencia entre
Lambda y Fargate se estimó en **~50–80 USD/mes**, frente a una factura de **WhatsApp de
~150–250 USD/mes** con 1.200 clientes recibiendo mensaje diario. **El cómputo no es donde se va
el dinero de este proyecto**, así que no justifica gastar riesgo arquitectónico ahí. La palanca
de costo real es la política de mensajería (`V-19` del cuestionario v3).

**Consecuencias**:
- Un artefacto: imagen Docker con la aplicación completa (monolito modular). Paridad
  desarrollo/producción vía `docker compose`; compatible con Testcontainers para la estrategia
  de pruebas del ledger.
- Aparece un **balanceador de carga como costo fijo** (~20 USD/mes estimado en `sa-east-1`),
  que pesa proporcionalmente mucho durante el piloto de **una sola ruta** (C-111).
- Trabajos en segundo plano en un **worker propio con cola**, no en funciones sueltas.
- ⚠️ **Todas las cifras de costo de esta entrada son estimaciones de orden de magnitud** y deben
  verificarse con precios vigentes de `sa-east-1` antes de comprometerlas con el cliente.

---

## Section T2 · Programming Languages

### T5 [CORE] — Required languages

**Timestamp**: 2026-08-01
**Question**: ¿Qué lenguajes son obligatorios, y para qué?

> **[Answer]:** *"Son obligatorios Python >=3.14; TypeScript 5.x y PostgreSQL >=17."*

**Registrado**:

| Lenguaje | Versión | Propósito | Justificación |
|---|---|---|---|
| **Python** | **>= 3.14** — pinneada exacta en el `Dockerfile` | Backend: API, dominio financiero, libro mayor, worker de trabajos en segundo plano, integraciones (WhatsApp, IA) | Lenguaje del único desarrollador. `decimal.Decimal` nativo para dinero exacto. FastAPI + Pydantic v2 dan validación estricta en el borde y OpenAPI automático. Al desplegar en ECS con `Dockerfile` propio (T3), AWS no impone runtime |
| **TypeScript** | **5.x** | Web de administración (React 19) y app móvil (React Native + Expo) | React Native obliga a TS en móvil; usarlo también en web unifica la mitad cliente. Los tipos del API se generan desde el OpenAPI de FastAPI, así que el contrato no se escribe dos veces |
| **SQL** | **PostgreSQL >= 17** | Esquema, aislamiento multi-tenant vía RLS, migraciones | El aislamiento entre empresas se aplica **en la base de datos**, no en el código de aplicación |

**Verificado por el usuario durante la decisión**: en `sa-east-1`, **PostgreSQL 17 está disponible
tanto en RDS como en Aurora**. La 18 no. Por eso el piso es 17 y no 18.

**Nota sobre versiones**: la recomendación inicial (3.12 / PG 16) era conservadurismo sin
justificación y **el usuario la corrigió con razón**. La regla adoptada es *la estable más
reciente que el entorno permita*: para Python la limita solo la disponibilidad de wheels binarias
(`psycopg`, `pydantic-core`, `cryptography`), a verificar al montar el proyecto; para PostgreSQL
la limita RDS, ya verificado.

**Decisión de arquitectura implícita: DOS lenguajes, no uno.** Se evaluó y descartó
TypeScript-en-todas-las-capas (lo que proponía `technical-research/recomendacion-tecnica.md`
§4.1). Razones:

1. **La experiencia del único desarrollador manda.** El núcleo financiero es donde el proyecto se
   juega el fracaso; escribirlo en un framework que se está aprendiendo es cómo aparecen los
   errores sutiles de dinero.
2. **El argumento de compartir código con el móvil es más débil de lo que parece aquí**, y la
   razón está en **C-65**: el cobrador **no puede crear un préstamo sin señal**. Toda la
   matemática compleja (generar cronograma, calcular interés, repartir residuo) ocurre al crear
   la venta, que siempre es en línea. El móvil offline solo hace aritmética simple contra un
   cronograma ya calculado por el servidor.
3. **`decimal.Decimal` nativo de Python.** JavaScript solo tiene IEEE 754. Pesa por dos requisitos
   del cliente: el **contador fraccionario de cuotas** (C-18, 19,5 de 20) y el **cierre sin
   tolerancia** (C-51, *"no puede faltar ni sobrar"*).
4. Lo que se pierde —tipos compartidos— se recupera **generando tipos TypeScript desde el
   OpenAPI** que FastAPI produce automáticamente.

> ⚠️ **Esto invalida `technical-research/recomendacion-tecnica.md` §4.1, §4.2 y §4.13**, que fijaban
> TypeScript + NestJS. Ese documento necesita **revisión 3**.

**Convención derivada, obligatoria**: en el móvil, **el dinero se maneja en centavos enteros**.
Nunca decimales en JavaScript.

**Constraint derivado**: la elección de React Native + Expo genera una obligación de
mantenimiento recurrente. Documentada aparte en
**`mobile-platform-constraints.md`** (las seis reglas de actualización barata), a petición
explícita del usuario.

---

### T7 [CORE] — Prohibited languages

**Timestamp**: 2026-08-01
**Question**: ¿Qué lenguajes están prohibidos, y por qué?

> **[Answer]: A** — respuesta literal del usuario:
>
> ```
> Java     -> Robusto y lento para el proyecto
> Go       -> No es necesario por ahora
> Angular  -> No entra porque se va a usar React en todo el frontend
> C/C++/C# -> Muy antiguos para el proyecto
> Ruby/Pascal -> Falta de conocimiento
> Otros    -> no están prohibidos pero están fuera por falta de expertise
> ```

**Registrado, con los motivos reformulados** (las prohibiciones no cambian; solo la redacción del
motivo, porque **es el texto que AI-DLC lee para elegir sustitutos**):

| Lenguaje | Motivo registrado | Nota sobre la reformulación |
|---|---|---|
| **Java** | Verboso, arranque y consumo pesados para el tamaño de este sistema, y **sin experiencia en el equipo** | El usuario escribió *"lento"*. Se reformula: la JVM **no** es lenta en ejecución. Dejarlo como "lento" haría que AI-DLC descarte por rendimiento opciones que no debe |
| **C#** | Sin experiencia en el equipo; orientado a otro tipo de solución | El usuario escribió *"muy antiguo"*. **Impreciso**: C# es un lenguaje moderno y en evolución activa. El motivo real es la falta de experiencia |
| **C / C++** | Sin experiencia en el equipo; herramienta para problemas de sistemas, no para un sistema de gestión web + móvil | Igual que arriba. Ver la excepción obligatoria abajo |
| **Ruby** | Falta de conocimiento en el equipo | Sin cambios — motivo correcto y suficiente |
| **Pascal** | Falta de conocimiento en el equipo | Sin cambios |
| **Go** | ⚠️ **NO prohibido — diferido.** *"No es necesario por ahora"* | Se registra como **decisión revisable**, no como veto. La distinción importa: un veto impide reconsiderarlo, un diferimiento no |

> ### ⚠️ Excepción obligatoria a la prohibición de C / C++
>
> La prohibición aplica **al código que escribe este equipo**, no a las dependencias. El
> ecosistema de Python descansa sobre extensiones nativas: `psycopg`, `cryptography` y
> `pydantic-core` (Rust) entre otras. Leer la prohibición como *"ninguna dependencia puede
> contener C"* bloquearía el propio driver de PostgreSQL.
>
> **Redacción vinculante:** *no se escribe C ni C++ en este repositorio; las dependencias de
> terceros que los contengan son admisibles.* Lo mismo aplica a **Rust**, que no fue mencionado
> pero está presente por la misma vía.

**Movido a `T10`**: **Angular**. Es un *framework*, no un lenguaje. La prohibición es válida y se
mantiene (React en todo el frontend), pero su sitio es la tabla de librerías prohibidas, que
además exige la columna *"usar en su lugar"*.

**Política por defecto (respuesta a "Otros")**: **denegación por defecto por falta de
experiencia.** Cualquier lenguaje fuera de los tres obligatorios de T5 queda excluido salvo
decisión explícita. Esto cubre de hecho `T6` (lenguajes permitidos), que estaba fuera del alcance
Quick.

---

## Section T3 · Frameworks and Libraries

### T8 [CORE] — Required frameworks

**Timestamp**: 2026-08-01
**Question**: ¿Qué frameworks son obligatorios, y para qué dominio?

> **[Answer]:** El usuario aportó FastAPI y React/React Native/Expo; el resto de la columna
> vertebral se propuso y el usuario respondió *"Confirmo tabla y shadcn"*.

**Registrado**:

| Framework | Dominio | Justificación |
|---|---|---|
| **FastAPI** | Backend — capa HTTP | Dominio del desarrollador. Ligero. OpenAPI automático, del que se generan los tipos de TypeScript |
| **Pydantic v2** | Validación en el borde | Incluido con FastAPI. La validación vive en la frontera — crítico recibiendo datos de ~40 dispositivos |
| **SQLAlchemy 2.0** (async, driver `asyncpg`) | Acceso a datos | Maduro, con salida a SQL crudo para las consultas del libro mayor. Su sistema de eventos permite fijar el contexto de tenant por transacción, de lo que depende el RLS |
| **Alembic** | Migraciones de esquema | Mismo ecosistema que SQLAlchemy |
| **Procrastinate** | Cola de trabajos y worker | Ver la decisión arquitectónica abajo — la librería es secundaria |
| **React 19 + Vite** | Web de administración | SPA estática a S3 + CloudFront |
| **TanStack Query** | Estado del servidor en la web | El tablero (C-83) depende de refrescos; hacerlo a mano es la fuente principal de errores en paneles |
| **React Hook Form + Zod** | Formularios web | Zod valida en cliente con el mismo esquema derivado del OpenAPI |
| **Tailwind + shadcn/ui** | Estilos y componentes web | **Elegido explícitamente por el usuario frente a Mantine.** El código se copia al repositorio: sin bloqueo de versión, ninguna actualización rompe la interfaz. Radix por debajo resuelve accesibilidad y navegación por teclado |
| **React Native + Expo** | App móvil | Sujeto a `mobile-platform-constraints.md` |
| **Expo Router** | Navegación móvil | Dentro del SDK ⇒ cumple la regla 2 |
| **SQLite en dispositivo** ⚠️ | Base local del móvil | **Cifrado obligatorio.** Librería concreta **sin decidir** — ver riesgo abajo |
| **`openapi-typescript`** | Contrato API → tipos TS | Es lo que evita que dos lenguajes cuesten dos contratos |

#### Decisión de arquitectura: **la cola de trabajos vive en PostgreSQL**, no en Redis ni SQS

Lo vinculante es la propiedad, no la librería. Al registrar un pago hay que escribir en el libro
mayor **y** encolar el mensaje de WhatsApp. Con una cola externa son dos sistemas y aparece el
problema de la doble escritura: si la base confirma y la cola falla, el cliente no recibe su
extracto y **nadie se entera**. Con la cola en Postgres, ambas caben en **una sola transacción**.

Esto no es una optimización: **el mensaje al cliente *es* la evidencia** del control antifraude
nº 2 de C-99. Perderlo silenciosamente rompe el control.

Efecto secundario: **no hace falta Redis** — una pieza menos de infraestructura que pagar y
mantener en `sa-east-1`.

*Alternativa admisible si se prefiere algo más mainstream*: Celery + SQS **con tabla de outbox
propia** que reproduzca la misma garantía. Más conocido, más código propio.

#### Decisión de framework web: **Vite, no Next.js**

Evaluado a petición del usuario. La web es **un panel de administración detrás de un login**:
sin SEO, sin páginas públicas. Todo lo que distingue a Next.js —SSR, componentes de servidor,
generación estática— sirve para contenido público y aquí no aporta.

Costo concreto que sí traería: SSR exige **un proceso Node en ejecución**, o sea un **segundo
runtime** junto a Python, en otro contenedor, con sus parches y su factura. Con Vite se compilan
estáticos y se sirven desde S3 + CloudFront: **cero runtime de frontend**.

Argumento de fondo: la propuesta de valor de Next.js es ser *full-stack*, y **eso quedó descartado
en T5** al elegir Python para el backend. Usar sus rutas de API dejaría lógica de negocio en dos
lenguajes.

#### ⚠️ Riesgo abierto: la base local cifrada del móvil

Hay tensión entre dos requisitos ya registrados:

- La **regla 2** de `mobile-platform-constraints.md` exige librerías del SDK de Expo ⇒ apunta a `expo-sqlite`.
- El **cifrado en reposo** es obligatorio (el dispositivo guarda fotos de documentos de identidad;
  C-71 pide borrado remoto) ⇒ puede empujar hacia `op-sqlite`, que trae SQLCipher.

**No se ha verificado cuál cumple ambos.** Debe comprobarse al montar el proyecto y registrarse
entonces. **No dar por hecho que `expo-sqlite` cifra.**

#### Deliberadamente fuera de T8: la sincronización offline

Es la pieza de mayor riesgo técnico del proyecto y **no es una elección de framework**: es decidir
entre una cola de comandos propia o adoptar WatermelonDB / PowerSync / ElectricSQL. Se trata en
**T14** (patrones de datos).

---

### T10 [CORE] — Librerías prohibidas (motivo + alternativa)

**Timestamp**: 2026-08-01
**Question**: ¿Qué librerías están prohibidas? Incluye el motivo Y la alternativa recomendada.

> **[Answer]:** *"No se, propon un conjunto de librerias que no se deben usar y que normalmente se
> cuelan"* → propuesta de 20 filas presentada por la IA → **"Aprovado"**.

⚠️ **Procedencia — leer antes de tratar esto como restricción de negocio.** Esta tabla es
**AI-propuesta / usuario-aprobada**, no declarada por el usuario. Es la única excepción a la
política de "sin pre-relleno" de esta entrevista, hecha a petición explícita del usuario. El
criterio de selección fue doble: solo entran librerías que **se cuelan solas** (vienen de
tutoriales, del hábito, o de la respuesta por defecto de un modelo) **y** que rompen algo concreto
de esta arquitectura. El **Bloque A** se defiende sin reservas; el **Bloque C** es opinable y puede
recortarse sin dañar el diseño.

**Registrado**:

#### Bloque A — Rompen el sistema (prohibición dura)

| Prohibited | Reason | Use Instead |
|---|---|---|
| `float` / columnas `REAL`, `DOUBLE PRECISION` para dinero | `0.1 + 0.2 != 0.3`. Con **interés fijo sobre capital y contador fraccionado de cuotas** (D-02) el error se acumula cuota a cuota y el arqueo de caja no cuadra nunca. Falla nº 1 de los sistemas de préstamos | `Decimal` en Python + `NUMERIC(18,2)` en Postgres, o enteros en centavos. Nunca `float` en el camino del dinero |
| `BackgroundTasks` de FastAPI / `asyncio.create_task` como cola | Vive en memoria del proceso: si el contenedor Fargate se recicla, el trabajo **se pierde en silencio**. El mensaje de WhatsApp al cliente *es* la evidencia del control antifraude nº 2 (C-99) | **Procrastinate** (T8). `BackgroundTasks` solo para trabajo del que da igual perder el 100% |
| `requests` | Síncrona: dentro de un endpoint `async` **bloquea el event loop**; una llamada lenta a WhatsApp congela a los 40 dispositivos a la vez | `httpx.AsyncClient` reutilizado (no uno por petición) |
| Filtrado de tenant en capa Python (`sqlalchemy-multi-tenant`, mixins `WHERE tenant_id=`) | **Ilusión de seguridad**: un `JOIN` mal hecho o SQL crudo se salta el filtro y filtra datos entre financieras. La frontera de aislamiento es **RLS en Postgres** (T8) | RLS + `SET LOCAL app.tenant_id` por transacción vía eventos de SQLAlchemy. El filtro Python es conveniencia, nunca frontera |
| `python-jose` | Se cuela **del tutorial oficial de FastAPI**, que la usó años. Sin mantenimiento activo; CVE-2024-33663 (confusión de algoritmo), CVE-2024-33664 (DoS en JWE) | `PyJWT` o `authlib` |
| `passlib` | Mismo origen (tutorial FastAPI). Última versión 2020; **se rompe con `bcrypt` 4.1+** (`AttributeError: __about__`) | `bcrypt` directo, `argon2-cffi` o `pwdlib` |
| `@react-native-async-storage/async-storage` para token o datos de negocio | Archivos **en claro** en el dispositivo. Con C-71 (borrado remoto) y fotos de documentos de identidad a bordo, un teléfono perdido entrega todo | `expo-secure-store` (Keychain/Keystore) para credenciales; SQLite **cifrada** para datos |

#### Bloque B — Rompen decisiones ya tomadas

| Prohibited | Reason | Use Instead |
|---|---|---|
| `redis`, `celery`, `kombu` | T8 sacó Redis a propósito: la cola vive en Postgres para que encolar y escribir el libro mayor sean **una sola transacción**. Reintroducirlo devuelve la doble escritura y una pieza más que pagar en `sa-east-1` | Procrastinate. *(Celery + SQS sigue admisible **solo** con tabla de outbox propia, según T8)* |
| MUI, Ant Design, Chakra, Bootstrap, PrimeReact | Se cuelan cuando alguien necesita **un** componente; traen su theming y CSS-in-JS, duplican bundle y pelean con Tailwind | shadcn/ui — el código se copia al repo y se edita |
| Redux, Zustand, Jotai **para estado de servidor** | Duplican TanStack Query. Sincronizar caché de servidor a mano es la fuente nº 1 de bugs en tableros — justo lo que C-83 necesita fiable | TanStack Query para datos de servidor; `useState`/context para estado de UI |
| `axios` | Capa de interceptores paralela a TanStack Query, más peso. Se cuela por costumbre | Cliente generado por `openapi-typescript` sobre `fetch` nativo |
| `redux-persist` y equivalentes en móvil | Segunda fuente de verdad offline junto a SQLite + cola de comandos. Dos capas divergen: se registra un pago que luego desaparece | Una sola capa: SQLite cifrada + cola de comandos (T14) |
| `react-native-camera` | Archivada y deprecada; domina los resultados de búsqueda, por eso se cuela | `expo-camera` (dentro del SDK ⇒ cumple regla 2) |
| `react-native-fs`, `realm`, `react-native-mmkv` | Módulos nativos fuera del SDK de Expo: violan la **regla 2** de `mobile-platform-constraints.md` y encarecen cada actualización de SDK | `expo-file-system`; para base local, la decisión de SQLite cifrada pendiente |

#### Bloque C — Higiene (prohibición blanda)

| Prohibited | Reason | Use Instead |
|---|---|---|
| `datetime.utcnow()`, `datetime.now()` sin tz, `pytz` | Devuelven *naive datetimes*. Con frecuencia **lunes–sábado** (D-02) la frontera del día decide si un pago es de hoy o atrasó. `pytz` exige `localize()` y falla en silencio si se olvida | `datetime.now(timezone.utc)` + `zoneinfo`. Guardar en UTC, presentar en la zona del tenant |
| `pandas` | Se cuela para reportes y exportes. Carga el dataset entero en memoria en Fargate y **convierte `Decimal` a `float`** al construir el DataFrame: corrompe el dinero de camino al reporte | Agregación en SQL + módulo `csv`. Si hace falta dataframe, `polars` con tipos decimales explícitos |
| `moment` | En modo mantenimiento por decisión del propio proyecto; ~300 KB y mutable | `date-fns` o `Intl.DateTimeFormat` nativo |
| `lodash` importado completo (`import _ from 'lodash'`) | Arrastra la librería entera al bundle; casi todo ya es nativo | Métodos nativos; si hace falta, `lodash-es` con import por función |
| `psycopg2` en el camino de petición | Driver síncrono conviviendo con `asyncpg`: dos pools y bloqueo del loop | `asyncpg`. **Excepción admitida:** `psycopg` (v3) dentro del entorno de Alembic si la migración lo requiere |
| `lazy="select"` (por defecto) en relaciones SQLAlchemy async | Configuración, no librería, pero se cuela igual: en async lanza `MissingGreenlet` en producción y no en tests | `lazy="raise"` por defecto; carga explícita con `selectinload` |

#### Deliberadamente NO prohibido, con motivo

- **Librerías de gráficas** — ninguna elegida (T9 quedó fuera de alcance). Prohibir sin alternativa
  declarada dejaría a AI-DLC sin salida. **Hueco conocido**, arrastrado al join.
- **Almacenamiento del JWT en navegador** (`localStorage` vs cookie `httpOnly`) — decisión de **T17**,
  no prohibición de librería.
- **`.env` en producción / `python-dotenv`** — pertenece a **T20** (gestión de secretos).

---

## Section T3 Complete — Frameworks and Libraries

T8 (obligatorios) y T10 (prohibidos) cerrados. T9 (preferidos) fuera de alcance por Quick pass,
reconfirmado por el usuario tras ofrecerle la ampliación. Consecuencia registrada: **las librerías
de segundo orden quedan sin declarar** (cliente HTTP más allá de httpx, logging estructurado,
gráficas, gestión de estado local en móvil) — AI-DLC usará sus valores por defecto salvo que una
fila de T10 lo impida.

---

## Section T5 · Architecture and Patterns

### T13 [CORE] — Estilo de API

**Timestamp**: 2026-08-01
**Question**: ¿Qué estilo(s) de API expondrá el sistema?

> **[Answer]:** *"en cuanto al estilo sería REST"* → **A · REST descrita con OpenAPI**.

**Registrado**: **REST + OpenAPI**, un solo estilo. No hay mezcla.

Coherente con T8: `openapi-typescript` genera los tipos de TypeScript desde el contrato OpenAPI
que FastAPI produce solo. Un contrato, dos lenguajes, sin escritura manual.

Descartados y por qué:
- **GraphQL** — resuelve escala organizativa (muchos consumidores heterogéneos) que este proyecto
  no tiene, y complica la autorización: en REST se protege un endpoint, en GraphQL campo por campo.
  Con aislamiento multi-tenant obligatorio, eso es superficie de riesgo añadida.
- **gRPC** — los navegadores exigen un proxy traductor; no hay microservicios internos que optimizar
  (una sola API en ECS Fargate, T3).
- **Orientada a eventos como API pública** — el gestor necesita respuesta inmediata ("quedó
  registrado, saldo 150"), que un modelo de eventos puro no da. El mecanismo de eventos **interno**
  ya existe: la cola en PostgreSQL de T8.

#### Aclaración registrada: la subida por lote NO es una mezcla de estilos

Se planteó primero como opción E y se corrigió durante la entrevista. Un endpoint que recibe 40
operaciones acumuladas offline sigue siendo REST — es un endpoint cuyo cuerpo es una lista:

```
POST /sync/operaciones     [ {...}, {...}, ... ]
```

El trabajo offline se resuelve con **REST + lote + idempotencia**, sin introducir un segundo estilo.

#### Único candidato real a segundo estilo, dejado fuera

El **tablero en vivo** (C-83). Dos caminos: sondeo periódico desde el navegador (sigue siendo REST,
cero infraestructura nueva) o canal abierto WebSocket/SSE (sí sería un segundo estilo). Con 30–40
usuarios (T3) el sondeo basta. **No se adopta WebSocket/SSE.** Si el requisito de "tiempo real"
de C-83 endurece, reabrir esta decisión.

Los webhooks entrantes de WhatsApp no cuentan como segundo estilo: son endpoints REST que este
sistema expone y Meta invoca. Las notificaciones push al dispositivo van por el servicio de Expo,
fuera de esta API.

---

### T14 [CORE] — Patrones de datos

**Timestamp**: 2026-08-01
**Question**: ¿Qué patrones de datos necesita el sistema?

> **[Answer]:** *"Explicame cada una y dime, según la naturaleza del Proyecto, cuales son las
> mejores"* → propuesta razonada opción por opción → **"approve"**.

⚠️ **Procedencia: AI-propuesta / usuario-aprobada** (segunda excepción a la política de sin
pre-relleno, pedida por el usuario). El usuario declaró no conocer los patrones y pidió
explicación + recomendación.

**Registrado**: **A · Relacional / SQL — una sola base de datos, PostgreSQL, para todo**, con dos
compromisos de diseño incorporados y una pieza fuera de la lista.

| Opción | Veredicto | Motivo |
|---|---|---|
| **A · Relacional** | **Sí — núcleo** | Transacciones ACID (aplicar pago + encolar WhatsApp + marcar UUID visto, o nada), restricciones que imponen la idempotencia, y **RLS como frontera de aislamiento entre financieras** |
| **B · Documental** | **Como `JSONB`, no como base aparte** | Config por tenant, payload crudo de webhooks de WhatsApp y snapshot antes/después de auditoría. Una segunda base (Mongo/DynamoDB) reintroduce la doble escritura que T8 eliminó |
| **C · Clave-valor** | **No** | Es Redis con otro nombre; descartado en T8. Sesiones sin estado vía token (T17); 30–40 usuarios no generan presión |
| **D · Índice de búsqueda** | **No** | 1.200 clientes (T3). `pg_trgm` cubre búsqueda difusa dentro de Postgres. En móvil la búsqueda es local contra SQLite por obligación offline. **Reconsiderar a cientos de miles de registros** |
| **E · Caché en memoria** | **No** | Para el tablero pesado de C-83: **tabla resumen precalculada** por tarea periódica de Procrastinate, no caché. Vive en Postgres, se respalda, sobrevive reinicios y es auditable |
| **F · Log de eventos** | **Sí como patrón, no como infraestructura** | Ver abajo |

#### Compromiso de diseño 1: el libro mayor es solo-añadir (patrón F sin Kafka)

C-99 establece que la auditoría inmutable es la razón de ser del sistema. Traducción técnica
vinculante:

- La tabla de movimientos **solo recibe `INSERT`**. Nunca `UPDATE`, nunca `DELETE`.
- Un pago mal registrado **no se corrige editando el renglón**: se añade un **movimiento de reversa**
  que lo compensa, y ambos quedan visibles.
- El saldo es **la suma de los movimientos**, no un número que alguien edita.
- Se implementa con permisos de PostgreSQL que impiden `UPDATE`/`DELETE` sobre esa tabla.

Kafka/Kinesis resuelven un problema distinto (repartir millones de eventos entre equipos que no se
conocen) y no hacen falta.

#### Compromiso de diseño 2: `JSONB` para lo de forma variable

Config por financiera, webhooks crudos de WhatsApp guardados verbatim para auditoría, y el
antes/después de cada entrada de auditoría. Dentro de Postgres, con transacciones y RLS.

#### Fuera de la lista pero necesario: almacenamiento de objetos

Las **fotos de documentos de identidad no van en la base de datos**: van a **S3 cifrado**, y la
tabla guarda solo la referencia y el hash. Binarios en Postgres inflan los backups y encarecen cada
consulta.

#### Titular

**Una sola base de datos para todo.** Cada opción descartada era una pieza más que provisionar,
respaldar, parchear y pagar en `sa-east-1`, sin resolver ningún problema presente.

#### Aclaración de alcance registrada durante T14

La **idempotencia no es un problema de diseño de API** — el usuario lo señaló correctamente tras
haberse presentado bajo T13. Es un problema de **identificación de operaciones**, y pertenece aquí.
Mecanismo completo, seis piezas:

1. **Identificar** — UUID generado **en el teléfono** al registrar la operación offline. Que lo
   genere el móvil es lo que hace reconocible el reintento como *la misma* operación.
2. **Encolar localmente** — estado `pendiente → enviada → confirmada` en la SQLite del dispositivo.
   **Solo se borra al confirmar el servidor.** Sobrevive a cierre de app y batería agotada.
3. **Rechazar el duplicado en la base, no en el código** — `UNIQUE (tenant_id, client_operation_id)`
   dentro de **la misma transacción** que aplica el pago. Un `if ya_existe:` en Python deja pasar
   dos peticiones simultáneas; la restricción no.
4. **Devolver la respuesta guardada** — no basta con "ya lo tenía": hay que devolver **la misma
   respuesta de la primera vez**, porque el teléfono la necesita para actualizar su pantalla.
5. **Resultado por operación, no por lote** — 40 operaciones, la nº 17 inválida. El lote **no es
   atómico**; cada operación sí. Devuelve array de 40 resultados. Todo-o-nada tumbaría la mañana
   entera de un gestor por una sola operación mala.
6. **Dos relojes** — la operación viaja con la hora del **teléfono**, que puede estar **manipulada a
   propósito** (es un sistema antifraude y el gestor controla su dispositivo). El servidor guarda
   `ocurrido_en` (dispositivo, informativo) y `recibido_en` (servidor, confiable). **Divergencia
   grande = señal de auditoría**, no error a corregir en silencio.

#### ⚠️ Sigue abierto dentro de T14

El **enfoque de sincronización offline** (cola de comandos propia vs WatermelonDB / PowerSync /
ElectricSQL) y el **orden de aplicación** del lote — crítico porque el contador fraccionado de
cuotas (D-02) depende de la secuencia.

---

### T14 (cont.) — Motor de sincronización offline · **RESUELTO**

**Timestamp**: 2026-08-01
**Question**: ¿Cola de comandos propia o adoptar WatermelonDB / PowerSync / ElectricSQL?

> **[Answer]:** propuesta razonada → **"Approve"**.

⚠️ **AI-propuesta / usuario-aprobada.**

**Registrado**: **Cola de comandos propia.** WatermelonDB, PowerSync y ElectricSQL descartados.

#### Motivo del descarte: resuelven un problema distinto

No es madurez ni precio. Las tres **replican estado** — hacen que una fila del teléfono y una del
servidor acaben iguales, y ante conflicto deciden con una regla genérica, normalmente *gana la
última escritura*. Esto es incompatible con el producto por dos razones:

1. **El móvil no debe escribir en el libro mayor.** El teléfono manda una **intención** ("el gestor
   cobró 50") y **el servidor decide si es válida**: ¿préstamo activo?, ¿caja abierta?, ¿venta
   aprobada? Un motor de replicación deja que el dispositivo escriba directamente en la tabla — eso
   convierte al gestor en **autor del registro contable en vez de sujeto auditado**, y vacía de
   sentido el control antifraude (C-99).
2. **"Gana la última escritura" es catastrófico con dinero.** Si el servidor aplicó una reversa y el
   teléfono llega tarde con estado viejo, la regla genérica sobrescribe la reversa y **el dinero
   reaparece**. En un libro mayor no hay conflictos que resolver: hay hechos que se añaden en orden.

Punto práctico añadido: **la necesidad no es simétrica.** Bajada = ruta del día + clientes del
gestor, paquete pequeño y de solo lectura. Subida = lista ordenada de operaciones. Eso es una cola,
no una replicación bidireccional; adoptar una herramienta general sería pagar la complejidad de un
problema que no se tiene para usar una esquina.

#### Reglas de orden (vinculantes)

- **Orden por agregado, no global.** Cada operación lleva número de secuencia del dispositivo. El
  orden es **obligatorio solo entre operaciones que tocan el mismo préstamo o la misma caja**; dos
  pagos de clientes distintos son independientes. Crítico porque el **contador fraccionado de
  cuotas (D-02) depende de la secuencia**: aplicar 30 y luego 20 sobre una cuota no deja el mismo
  rastro que 20 y luego 30, aunque el saldo final coincida.
- **Un rechazo no bloquea la cola.** Si la operación 17 es inválida, las demás siguen — salvo las
  que toquen el mismo préstamo, que se marcan como dependientes y quedan a la espera. El gestor ve
  en su teléfono cuáles quedaron pendientes y por qué.

#### Coste asumido conscientemente

Se escribe y se prueba en casa. **Escenarios de prueba obligatorios** (los que suelen olvidarse):
modo avión toda la mañana · app cerrada por el sistema a media subida · **cambio manual del reloj
del teléfono** · subida duplicada por corte de red · operaciones que llegan desordenadas.

**Lo que se gana:** nada se sincroniza sin pasar por las reglas de negocio del servidor — que es
exactamente lo que el producto vende.

---

## Section T5 Complete — Architecture and Patterns

T13 (REST + OpenAPI) y T14 (PostgreSQL único, ledger solo-añadir, JSONB, S3, cola de comandos
propia) cerrados. T15 y T16 fuera de alcance por Quick pass.

---

## Section T6 · Security

### T17 [CORE] — Método de autenticación

**Timestamp**: 2026-08-01
**Question**: ¿Cómo se autentican usuarios y servicios?

> **[Answer]:** *"B"* → **JWT emitido por servicio propio**. El diseño de sesión que sigue fue
> propuesto por la IA y aprobado (*"Approve"*).

**Registrado**: **B · JWT emitido por nuestro propio servicio de autenticación.**

C y D descartadas de entrada: los usuarios son personas con teléfonos y navegadores, no servicios.
A (Cognito / Auth0) descartada porque **la vinculación de dispositivo hay que escribirla en los dos
casos** — ningún proveedor la trae hecha — y engancharla a Cognito exige disparadores Lambda, más
superficie que depurar. Con servicio propio, la firma del dispositivo encaja en el flujo y el
`tenant_id` que alimenta el RLS lo emite el propio sistema, sin depender del formato de un tercero.
**Coste asumido**: almacenamiento de contraseñas, recuperación, bloqueo por intentos y caducidad de
sesiones se escriben y mantienen en casa; un error ahí es un fallo de seguridad.

#### El problema de la sesión offline, y cómo se desactiva

El esquema habitual (token corto + token de renovación) **exige red para renovar**: un gestor sin
señal desde las 7 quedaría fuera a las 7:15. La observación que lo resuelve: **mientras está
offline, el gestor no necesita hablar con el servidor** — las operaciones se acumulan en su
teléfono y el token solo hace falta **al sincronizar**. Lo que debe funcionar sin red es *abrir la
app*, que no es autenticación de servidor.

#### Diseño registrado — dos mecanismos separados

| Mecanismo | Qué hace | Cuándo |
|---|---|---|
| **Desbloqueo local** — PIN o biometría (`expo-local-authentication`) | **Descifra la SQLite local.** No valida nada contra el servidor | Al abrir la app, **sin red** |
| **Autenticación de servidor** — firma del dispositivo | El teléfono **firma un desafío** del servidor con la clave privada del Keystore; el servidor verifica contra la pública registrada y emite un **token de acceso corto** | Al sincronizar |

**El par de claves del dispositivo sustituye al token de renovación.** Consecuencias:

- **No hay credencial persistente robable en el teléfono** — la clave privada nunca sale del almacén
  seguro del sistema operativo.
- **Revocar un dispositivo = borrar su clave pública en el servidor.** Efecto inmediato, sin esperar
  caducidades. Cubre parte de C-71.
- **La contraseña se pide al dar de alta el dispositivo y luego periódicamente con conexión**, no
  cada mañana. Satisface el requisito del cliente sin bloquear el trabajo de campo.

#### Regla innegociable: el `tenant_id` sale del token

Contenido del token: usuario, `tenant_id`, dispositivo, rol, caducidad. **El `tenant_id` se toma
siempre del token verificado, jamás de una cabecera o del cuerpo de la petición.** Es el valor que
alimenta el RLS de PostgreSQL: si el cliente pudiera influir en él, el aislamiento entre financieras
se cae entero y las prohibiciones de T10 dejan de servir.

#### Web

Token en **cookie `httpOnly`, `Secure`, `SameSite`** — **nunca `localStorage`**, legible por
cualquier XSS. Cierra el punto que T13 dejó pendiente.

#### Firma

**HS256 con `PyJWT`** (T10 prohibió `python-jose`). Simétrica porque un solo servicio emite y
valida. El secreto vive en el gestor de secretos → **T20**.

#### ⚠️ Cabo abierto, es decisión de negocio

Si se revoca un dispositivo con **40 operaciones sin subir**: rechazarlas **destruye registros de
dinero que sí ocurrió**. Lo prudente es **aceptarlas en cuarentena** para revisión de un
administrador. Registrado como `OQ-F-99` para el cliente.

---

### T20 [CORE] — Gestión de secretos

**Timestamp**: 2026-08-01
**Question**: ¿Cómo se almacenan y se acceden los secretos?

> **[Answer]:** *"Qué pasa si quiero manejar todo con AWS Secret Manager?"* → consecuencias
> expuestas → **"Approve"**.

**Registrado**: **A · AWS Secrets Manager para todos los secretos**, sin dividir con Parameter
Store.

- Los **valores de configuración no sensibles** (nivel de log, región, banderas, URLs) quedan como
  **variables de entorno normales** en la definición de tarea. Regla: *a Secrets Manager va lo que,
  filtrado, compromete el sistema*. Si todo se trata como crítico, nada recibe la atención debida.
- Acceso desde **ECS Fargate mediante rol de IAM**, sin credenciales almacenadas.
- **AWS↔AWS siempre por roles de IAM, nunca por credenciales.** El backend escribiendo en S3 no
  necesita ningún secreto: la tarea lleva su rol. **El secreto más seguro es el que no existe** —
  reducir el inventario antes de decidir dónde guardarlo deja solo tres: contraseña de PostgreSQL,
  clave de firma de JWT, token de la API de WhatsApp.
- **Rotación automática activada para la contraseña de PostgreSQL** — AWS trae la función de
  rotación ya escrita para RDS. El resto, rotación manual programada.

#### Decisión de implementación registrada: la clave de firma NO se inyecta al arrancar

ECS inyecta los secretos **al arrancar el contenedor**. Si el secreto rota después, el contenedor en
marcha **sigue con el valor viejo** hasta el siguiente despliegue. Para la contraseña de PostgreSQL
es aceptable (rotar + despliegue progresivo). **Para la clave de firma de JWT no**: la aplicación la
**consulta en tiempo de ejecución con una caché de unos minutos**, de modo que el **solapamiento de
claves de T17** funciona sin reiniciar nada.

Motivo del solapamiento (T17): sustituir la clave de golpe **invalida todos los tokens ya emitidos
y expulsa a todos los usuarios conectados a la vez** — para un gestor a media ruta, su sincronización
falla sin explicación. El servidor firma con la nueva y **sigue aceptando la vieja** durante una
ventana de gracia, distinguiéndolas por el campo `kid` del token. **Esa lógica se escribe en casa,
la rotación automática no la regala.**

#### Aviso operativo registrado

Al borrar un secreto, AWS lo **retiene entre 7 y 30 días** y durante ese tiempo **no permite crear
otro con el mismo nombre**. Bloquea el ciclo levantar/destruir entornos con infraestructura como
código. Se resuelve con borrado forzado sin recuperación — **hay que saberlo de antemano**.

#### Por qué no se dividió con Parameter Store

Parameter Store estándar es gratis y Secrets Manager cuesta del orden de 0,40 USD por secreto al
mes — con 3 secretos por 3 entornos, unos **4 USD/mes**. El coste no era el argumento. **Dos
almacenes son dos modelos mentales, dos conjuntos de permisos IAM y dos sitios donde mirar cuando
algo no arranca a las siete de la mañana.** Mismo criterio que quitó Redis en T8 y el segundo
planificador en T13.

---

## Section T6 Complete — Security

T17 (JWT propio + vinculación de dispositivo por par de claves) y T20 (Secrets Manager único)
cerrados. T18, T19 y T21 fuera de alcance por Quick pass.

⚠️ **Nota de alcance**: T21 (marco de cumplimiento) quedó fuera, pero el producto maneja **fotos de
documentos de identidad** y datos financieros de terceros. Si el país resulta ser Brasil (`CX-11`
sin resolver), **LGPD aplica**. Arrastrar al join.

---

## Section T7 · Testing

### T22 [CORE] — Tipos de prueba obligatorios

**Timestamp**: 2026-08-01
**Question**: ¿Qué tipos de prueba son obligatorios?

> **[Answer]:** *"A, B, C, D, E, F. el sistema debe ser altamente testeable"*

**Registrado**: **los seis tipos son obligatorios** — unitarias, integración, contrato, extremo a
extremo, rendimiento y seguridad (SAST/DAST). Posición declarada por el usuario: **el sistema debe
ser altamente testeable.**

#### Justificación específica de C (contrato), que aquí no es la habitual

Su caso clásico son equipos separados, que no es este. Lo que sí lo exige: **la app móvil se
distribuye por las tiendas** y no se puede actualizar a todos los gestores a la vez — una versión
vieja seguirá instalada durante semanas. La API **tiene que seguir siendo compatible con versiones
de app que ya están en la calle**, y romper esa compatibilidad **no lo detecta ninguna otra prueba**.
`openapi-typescript` verifica tipos al compilar, pero solo protege el código que se compila hoy, no
el que un gestor tiene instalado desde hace tres semanas.

#### Condiciones registradas para D y E

- **D (extremo a extremo) debe acotarse a una lista corta e intocable de flujos críticos**, o se
  pudre: son lentas y frágiles, y si se intenta cubrirlo todo el equipo acaba ignorando los fallos
  rojos. Candidatos: registro de pago offline + sincronización · cierre de caja · aprobación de
  venta en 4 pasos con QR. **Lista concreta pendiente de fijar.**
- **E (rendimiento) no es ejecutable sin un objetivo declarado.** Hay datos de partida (T3: 30–40
  usuarios, ~1.200 clientes, ~3 pagos/minuto en pico) pero **ningún objetivo de latencia ni de
  tiempo de sincronización**. Sin ese número la prueba no puede fallar, y **una prueba que no puede
  fallar no es una prueba**. Registrado como `OQ-N-44`.

#### "Altamente testeable" traducido a restricciones de diseño (vinculantes)

Valen más que la lista de tipos:

1. **El cálculo de dinero va en funciones puras.** Interés, amortización y contador fraccionado de
   cuotas no tocan base de datos, ni red, ni reloj. Función que recibe datos y devuelve datos ⇒
   probar veinte casos límite cuesta minutos.
2. **El reloj se inyecta, no se invoca.** Si el código llama directamente a la hora del sistema no
   se puede probar la mora, ni el cierre del día, ni la frecuencia lunes–sábado sin cambiar la hora
   de la máquina. Refuerza la prohibición de `datetime.utcnow()` de T10.
3. **Las pruebas de integración necesitan un PostgreSQL real.** Simular la base no sirve: RLS,
   transacciones y la restricción de unicidad que sostiene la idempotencia **solo existen en
   Postgres**. Hay que levantar una instancia real en CI.
4. **La cola de comandos del móvil se escribe separada de React Native.** Mezclada con componentes
   de interfaz, probar los cinco escenarios de T14 exigiría un emulador; separada, son pruebas
   normales y rápidas.

#### Ampliación de alcance

El usuario aceptó **recuperar T25 (puertas de CI/CD)** al alcance, sobre el argumento de que
declarar seis tipos de prueba sin declarar la puerta es la forma más común de que la disciplina se
diluya. Quick pass pasa de 12 a **13 preguntas**.

---

### T25 — Puertas de CI/CD  *(recuperada al alcance a petición del usuario)*

**Timestamp**: 2026-08-01
**Question**: ¿Qué puertas deben pasar antes de que un cambio se fusione o se despliegue?

> **[Answer]:** *"E con la separación de los dos niveles"* → **E · todas, en dos niveles.**

**Registrado**: **todas las puertas son obligatorias, repartidas en dos niveles.**

| Puerta | Qué corre | Tiempo | Cuándo |
|---|---|---|---|
| **Por cada cambio** — bloquea la **fusión** | Tipos y formato · unitarias · **integración con PostgreSQL real** · SAST + escaneo de dependencias · **comprobación de compatibilidad del contrato OpenAPI** · **revisión de código aprobada** | minutos | Siempre |
| **Antes de publicar** — bloquea el **despliegue**, no la fusión | Extremo a extremo sobre flujos críticos · rendimiento contra el objetivo de `OQ-N-44` · DAST | decenas de minutos | Nocturno y antes de cada versión |

#### Motivo de la separación

**No todas las pruebas pueden ser puerta de fusión.** Extremo a extremo y rendimiento tardan
decenas de minutos y, sobre todo, **fallan a veces sin que nadie haya roto nada** — un tiempo de
espera agotado, un navegador lento, un contenedor que arrancó tarde. Si eso bloquea cada fusión, en
tres semanas el equipo aprende a **reintentar hasta que salga verde**, y la puerta deja de
significar nada. Es la forma más común de que la disciplina de pruebas se disuelva: no por falta de
pruebas, sino por puertas que el equipo aprende a ignorar.

#### La comprobación de contrato va en la puerta rápida

Se compara el OpenAPI del cambio con el publicado y **falla si introduce una ruptura**. Es barata y
es lo único que impide que un cambio inocente deje sin funcionar **las apps que los gestores ya
tienen instaladas** — que no se pueden actualizar a la vez porque se distribuyen por las tiendas.

---

## Section T7 Complete — Testing

T22 (seis tipos obligatorios + cuatro restricciones de diseño) y T25 (puertas en dos niveles)
cerrados. T23 (objetivo de cobertura) y T24 (herramienta por tipo) fuera de alcance por Quick pass
— arrastrados como `OQ-T-19` y `OQ-T-20` parciales.

---

# ENTREVISTA TÉCNICA COMPLETA — 13/13

Secciones cerradas: T1 · T2 · T3 · T5 · T6 · T7.
Fuera de alcance por Quick pass: T4, T6, T9, T11, T12, T15, T16, T18, T19, T21, T23, T24, T26–T29.
No aplicables (Greenfield): TB1–TB4.

⚠️ **La brecha más cara del documento**: T26–T29 (ejemplos de código canónicos) quedaron fuera, así
que **no existe ni un solo ejemplo de referencia**. Subida a P0 como `OQ-T-22`.

---

# AMPLIACIÓN DE ALCANCE — 2026-08-02 (10 preguntas: T4, T11, T16, T18, T21, T24, T26–T29)

El Quick pass (13/13) quedó respondido pero **sin aprobar**. En lugar de cerrar la puerta, el usuario
eligió **ampliar alcance y aprobar una sola vez al final**, delegando la selección de las 10
preguntas. Justificación de la selección en `state/technical-state.md`. Modo `conversational`,
política de pre-llenado `none` sin cambios.

---

## Section T1 (continuación) — Resumen Técnico del Proyecto

### Question T4: Describe el equipo que va a construir y mantener este sistema.

**[Answer]:** *(verbatim, 2026-08-02)*

> El equipo técnico es una persona, mi persona, soy un desarrollador junior con experiencia en
> Python + FastAPI ; React solo en entornos web no mobile. Experiencia previa en servicios de AWS,
> incluyendo los servicios de IA AWS.

**Registrado como restricción:**

| Dimensión | Valor |
|---|---|
| Tamaño del equipo | **1 persona** — desarrollo y operación |
| Nivel | **Junior** (autodeclarado) |
| Fortalezas declaradas | **Python + FastAPI** · **AWS**, incluidos los servicios de IA |
| Web | **React sí**, solo en entorno web |
| Móvil | **Sin experiencia** — React Native / Expo es tecnología nueva para el equipo |
| Sin experiencia declarada | React Native · Expo · criptografía en dispositivo (Keystore/Keychain) · motores de sincronización offline · pipelines de CI/CD multinivel |
| Operación en producción | **La misma persona** (no hay equipo de operaciones separado) |

**Consecuencia inmediata → `CX-27` (P0).** Lo que ya estaba comprometido por respuestas anteriores:
motor de sincronización offline propio (T14), servicio de autenticación propio con firma por par de
claves (T17), seis tipos de prueba obligatorios y puertas en dos niveles (T22 + T25), y un MVP que
según **D-03** es la **app completa del cobrador**. El backend cae dentro de la fortaleza declarada;
**el riesgo se concentra íntegramente en la mitad móvil**, que es a la vez el MVP y la tecnología sin
experiencia previa, y que carga las dos piezas más difíciles del sistema.

**El registro no revierte ninguna decisión técnica.** T14 y T17 se argumentaron sobre arquitectura y
ese argumento sigue en pie; lo que nunca se verificó fue la capacidad de ejecutarlas. La variable a
ajustar es el **alcance**, y esa es una decisión de negocio → se traslada al join y reabre `D-03`.

**Efecto lateral sobre T9:** el usuario declinó T9 (frameworks preferidos) dos veces, dejando sin
declarar las librerías de segundo orden (cliente HTTP, logging, fechas/dinero, gráficas, estado local
móvil). Con un equipo senior eso es barato — alguien corrige una mala elección en revisión. **Con una
persona junior y sin revisor, los defaults que tome AI-DLC se quedan.** No se reabre T9 aquí (la
decisión del usuario se respeta), pero queda anotado como consecuencia.


---

## Section T4 — Servicios Cloud

### Question T11: ¿Qué servicios cloud están permitidos, y con qué restricciones?

**Método (excepción aprobada a la política de no pre-llenado, la quinta):** a petición explícita del
usuario —*"necesito que busques qué servicios se nombraron para usar en este proyecto"*— la lista se
compiló a partir del material y se presentó como propuesta. El usuario respondió con **cinco
preguntas de fondo, cuatro aclaraciones y una arquitectura de red**, y cerró con **"Confirmo todos"**.
Registro por partes.

#### Descubrimiento: `technical-research/infraestructura-aws.md`

Documento de 48 KB fechado 2026-07-28 que **no estaba en el índice de la sesión**. Contiene
dimensionamiento real, precios de `sa-east-1` verificados contra la API pública de precios de AWS y
cinco escenarios de arquitectura costeados. Recomendaba **Lightsail** (~$59) sobre **ECS Fargate**
(~$141) — contra lo decidido en T3 — argumentando que ECS consume *"2–4 semanas de configuración de
VPC/IAM/ALB que un desarrollador con 16 h/semana no tiene"*, premisa que **T4 confirmó ese mismo
día**. Abierto como `CX-28` y **cerrado en la misma sesión a favor de ECS**, no por preferencia sino
porque la arquitectura de red que el usuario declaró **es técnicamente imposible en Lightsail**.

#### Q11 — RDS PostgreSQL contra Aurora PostgreSQL

**Decisión: RDS.** Aurora Serverless v2 en `sa-east-1` cuesta $0,25/ACU-hora; el piso de 0,5 ACU son
**$91,25/mes solo de cómputo en reposo**, contra **$50,37** de `db.t4g.small` — **~1,8× más caro
estando ociosa**, más almacenamiento y **cobro por E/S** aparte. Lo que Aurora compra (almacenamiento
replicado 6 veces en 3 AZ, failover ~30 s, hasta 15 réplicas de lectura, backtrack) **no se activa ni
una vez** a **< 1 GB el año 1**, ~3 GB el año 3, **0,04 escrituras/s** sostenidas y pico de ~4 req/s.
`infraestructura-aws.md` ya tipificaba el escenario D —*"el error clásico"*— como **Aurora + 2 NAT +
logs verbosos = $475/mes**. **No es un argumento de dificultad operativa**: Aurora no es más difícil
de operar que RDS; es costo/beneficio puro a esta escala.
**Matiz registrado a favor de Aurora**: Serverless v2 escala a **0 ACU con auto-pausa**, lo que sí lo
hace atractivo para **desarrollo y staging** (apagados ~20 h/día). **Reconsiderar RDS→Aurora** cuando
hagan falta réplicas de lectura reales, failover rápido por contrato, o decenas de GB.

#### Q11 — Procedencia de los precios

El encabezado de `infraestructura-aws.md` declara: *"Precios verificados contra la API pública de
precios de AWS (`pricing.us-east-1.amazonaws.com`), región `sa-east-1`, on-demand, USD. Fecha:
2026-07-28"*. ⚠️ **Salvedad registrada**: quien conduce esta entrevista **no generó ese documento y
no puede confirmar que la consulta se ejecutara correctamente**, ni verificar precios de AWS de
memoria con fiabilidad. **Antes de comprometer presupuesto, verificar en consola tres líneas** —
NAT Gateway ($0,093/h), RDS `t4g.small` ($0,069/h) y CloudWatch ingesta ($0,90/GB) — que son las que
mueven la factura.

#### Q11 — Observabilidad: ¿CloudWatch + X-Ray además de Sentry?

**Decisión: Sentry + CloudWatch Logs + CloudWatch Alarms. X-Ray FUERA de v1.**
X-Ray es **trazado distribuido**: su valor es localizar qué servicio de una cadena está lento, y esto
es un **monolito modular de un solo servicio** — no hay cadena que trazar. El costo real no son los
~$5/millón de trazas sino **el tiempo de instrumentación y una consola más que aprender**; con un
equipo de una persona (`CX-27`) el recurso escaso es el tiempo, no el dinero. Además **Sentry ya trae
trazado de rendimiento**, que cubre la mayor parte de lo que X-Ray aportaría aquí. **Reconsiderar si
el monolito se parte alguna vez.**

#### Q11 — Corrección del usuario: Claude SÍ está en Bedrock `sa-east-1`

`infraestructura-aws.md` §7.4 afirma que *"ni Claude ni Nova están en Bedrock `sa-east-1`"* y sobre
ese hallazgo construye su conclusión de que **no existe** la opción de usar IA dentro de AWS sin
romper la residencia de datos. **El usuario reporta el 2026-08-02 que Claude sí está disponible en
São Paulo.** Corrección aceptada y registrada en `OQ-T-15`. **Consecuencia**: esa opción sí existe —
relevante ahora que `CX-30` devuelve la IA a la v1. **Verificar los IDs exactos de modelo en la
consola de la región.**

---

### `[Answer]` T11 — LISTA DE SERVICIOS v1 (confirmada 2026-08-02)

#### Allow list

| Servicio | Restricciones / Notas | Origen |
|---|---|---|
| **ECS Fargate** | API FastAPI 24/7. Tareas en **subred privada, sin IP pública** | T3 · `CX-28` |
| **RDS PostgreSQL ≥ 17** | Base única: ledger, RLS, `JSONB`, cola de trabajos. **Aurora descartada** (~1,8× más cara en reposo, capacidades no utilizables a esta escala). Subred **aislada**, puerto 5432 solo desde el SG de las tareas | T5, T8, T14, T11 |
| **S3** | Fotos de identidad **cifradas y privadas**; bundle estático de la SPA. **Entrega por URL prefirmada (5–15 min)**, nunca pública | T14, T11 |
| **CloudFront** | **Solo** el bundle estático de la SPA. **No sirve fotos de identidad** | T14, T11 |
| **ALB** | **Única entrada desde internet.** Subred pública | T11 |
| **NAT Gateway** | **Uno solo, una AZ** ($68 en vez de $136). Salida a WhatsApp, Telegram, Sentry, FCM, Bedrock | T11 · `OQ-N-45` |
| **VPC Endpoint (Gateway) para S3** | **Gratuito.** Saca el tráfico de fotos del NAT | T11 |
| **ECR** | Registro de imágenes | T11 |
| **Secrets Manager** | 3 secretos reales: contraseña PostgreSQL, clave de firma JWT, token de WhatsApp | T20 |
| **IAM (roles)** | Todo acceso AWS↔AWS. **Sin credenciales almacenadas** | T20 |
| **CloudWatch Logs** | ⚠️ **Retención 14 días** y **nunca nivel `debug` en producción** — $0,90/GB en `sa-east-1` | T11 |
| **CloudWatch Alarms** | 4–5: CPU y almacenamiento de RDS, tareas ECS vivas, 5xx del ALB, **profundidad de la cola de trabajos** | T11 |
| **Route 53** | DNS de la API y del panel | T11 |
| **SES** | **Correo transaccional, v1.** Decidido por la suscripción semanal (`CX-30`), no por la recuperación de contraseña. ⚠️ Verificar disponibilidad en `sa-east-1`; requiere DKIM+SPF+DMARC, salida de sandbox y manejo de rebotes vía SNS | T11 · `OQ-T-14` |
| **SNS** | **Solo** para el topic de rebotes y quejas de SES. **No** como cola de trabajos (eso vive en PostgreSQL, T8) | T11 |
| **Bedrock** | ⚠️ **Condicional a `CX-30`.** Fuera si la IA sigue fuera de v1; dentro si el plan básico la incluye. **Claude disponible en `sa-east-1`** según el usuario | `CX-30` · `OQ-T-15` |
| **Región `sa-east-1`** | **Restricción firme confirmada** | T11 |

#### Servicios externos (no AWS) en v1

| Servicio | Uso | Costo |
|---|---|---:|
| **WhatsApp Cloud API** (Meta) | Los dos controles antifraude, hacia **clientes**. `CX-16` | **~$212/mes — 61 % de la factura** |
| **Telegram Bot API** | **Reportes a administradores** (`CX-29`). Canal nuevo, sin precedente en el material | **$0** |
| **Firebase Cloud Messaging** (Google) | Push a Android/iOS vía Expo | $0 |
| **Sentry** | Errores en producción, backend + web + móvil. *"Con un desarrollador, enterarse de los errores por el usuario es inaceptable"* | $0–26/mes |
| **GitHub Actions** | Las dos puertas de T25 | $0 a esta escala |

#### Disallow list

| Servicio | Motivo |
|---|---|
| **ElastiCache / Redis** | La cola vive en PostgreSQL (T8) |
| **SQS / EventBridge** | Misma razón |
| **Aurora PostgreSQL** | ~1,8× el costo de RDS en reposo; capacidades no utilizables a esta escala |
| **App Runner** | **No existe en `sa-east-1`** (verificado) |
| **EKS · Lambda** | T3 |
| **Cognito** | La vinculación de dispositivo hay que escribirla igual (T17) |
| **AWS X-Ray** | Monolito de un solo servicio: no hay cadena que trazar. Sentry cubre el trazado de rendimiento |
| **Segundo NAT Gateway** | $68 adicionales por alta disponibilidad de AZ a 0,04 req/s |
| **NAT Instance** | Ahorra $65/mes a cambio de mantener un aparato de red — mal negocio con equipo de una persona |
| **VPC Endpoints de interfaz** (ECR/Secrets/Logs) | ~$22/mes y **no eliminan el NAT** |
| **API Gateway · malla de servicios · PrivateLink** | No hay microservicios |
| **Supabase · Fly.io · Cloudflare R2** | Superados por la elección de AWS en T2 |

#### Arquitectura de red — **VINCULANTE** (declarada por el usuario, con una corrección aceptada)

```
Internet
   |
   +-- CloudFront ------> S3 (bundle estático de la SPA)
   |
   +-- ALB  [subred PÚBLICA]  <- única entrada desde internet
          |
          v
      ECS Fargate  [subred PRIVADA, sin IP pública]
          |                    |
          | 5432               +--> NAT Gateway [1 AZ] --> WhatsApp · Telegram · Sentry · FCM · Bedrock
          v                    +--> VPC Endpoint Gateway S3 (gratis)
      RDS PostgreSQL  [subred AISLADA, sin ruta a internet]
```

⚠️ **Corrección aceptada por el usuario**: la formulación original decía que *"la base de datos solo
se va a poder comunicar por un NAT o un Internet Gateway con el ECS"*. **RDS no necesita NAT ni IGW
para hablar con ECS** — están en la misma VPC y el enrutamiento es local; basta con que el *security
group* de RDS permita 5432 desde el SG de las tareas. **El NAT es para salida a internet**, no para
tráfico interno; ponerlo en medio sería pagar $68/mes por un salto que no ocurre. La intención
—aislamiento— se cumple íntegra con el diagrama de arriba.

**El NAT sí es obligatorio**, con justificación registrada: las tareas privadas necesitan **salir** a
WhatsApp Cloud API, Telegram Bot API, Sentry, FCM y Bedrock. `infraestructura-aws.md` §8.3 tenía como
regla de costo nº 1 *"nunca contrate un NAT hasta que algo lo exija"* — queda documentado qué lo exige.

**Costo:** el escenario A pasa de **~$141 a ~$210/mes** → `OQ-N-45`.

#### Política de fotos de identidad

**S3 privado + URL prefirmada (5–15 min)** generada por la API tras comprobar permisos. Nunca
CloudFront público: sería un enlace **permanente, compartible y sin autenticación** a un documento de
identidad, irrevocable si se filtra — y, sobre todo, **dejaría las fotos fuera de la única frontera de
aislamiento del sistema**, porque la comprobación de tenant vive en la API que firma la URL.
**Regla operativa: el móvil debe cachear las fotos localmente** (re-descarga diaria = egreso ×10).

**Retención — pendiente de T21 y `CX-11`.** Estructura aceptada: activo -> se conserva · cerrado ->
Glacier Instant Retrieval a los 12 meses · borrado a los N años del cierre · **ledger nunca se borra**.
🔑 **El conflicto derecho al olvido (LGPD) contra ledger inmutable (T14) ya está resuelto por diseño**:
la foto vive en S3 y la tabla guarda solo **referencia + hash**, así que la imagen se borra sin romper
el ledger, que conserva la prueba de que el documento existió sin conservar el documento. **Debe
quedar escrito antes de que alguien 'optimice' guardando la foto en la base.**

#### Información nueva de negocio surgida durante T11

1. **Los reportes a administradores van por Telegram, no por WhatsApp** -> `CX-29` (P1). Telegram no
   aparece **ni una vez** en los ~180 KB de material. No cierra `CX-16` ni baja la factura de
   WhatsApp (esos ~$212 son mensajería a 1.200 **clientes**); añade una **segunda integración**.
2. **Suscripción semanal con planes escalonados; el plan básico incluye IA** -> `CX-30` (**P0**).
   Contradice `D-03` (IA fuera de v1) **y la respuesta del propio cliente en C-108** (*"puede
   esperar: la IA"*). Información de **segunda mano** (*"por lo que me dieron a entender"*) que
   responde de facto `OQ-F-97` sin fuente autorizada. **Agranda el alcance justo después de que
   `CX-27` estableciera que no cabe en el equipo**, y mete en el plan de entrada una funcionalidad
   **cuyo comportamiento nunca se especificó** (`OQ-F-68`, `OQ-F-70`, `OQ-F-72`, todas P0 abiertas).

---

## Section T4 Complete — Servicios Cloud

T11 cerrado. T12 (disallow list) **respondido de paso** — la lista de exclusiones quedó completa
arriba, con motivo por fila.

---

---

## Section T5 (continuación) — Arquitectura y Patrones

### Question T16: ¿Qué convenciones estructurales debe seguir el código?

**[Answer] — declarada por el usuario, 2026-08-02 (X, revisión invitada):** *(verbatim)*

> X) Un repositorio principal que en estructura contenga a Backend, Web, Mobile e Infra (archivos
> Terraform). pero en versionamiento el principal versiona los archivos y carpetas excluyendo
> Backend, Web, Mobile e Infra. estos tienes su propio versionamiento. Adicionalmente fuera de la
> pregunta te respondo una decisión que se va a tomar más adelante; para poder hacer un deploy tanto
> a producción como develop; en cada repositorio una rama con el mismo nombre para los 5 repos.
>
> Esa es mi recomendación. aunque si tienes una opinión podemos revisarla.

**Estado: DECLARADA, en revisión a petición explícita del usuario.** No confirmada todavía.
Contenido técnico: **5 repositorios** (principal + Backend + Web + Mobile + Infra) enlazados como
**submódulos de Git**, con una **rama del mismo nombre en los 5** como mecanismo de despliegue a
producción y develop. **Terraform confirmado como herramienta de IaC** (adelanta parte de T29 y
cierra `OQ-T-23`).

**RESOLUCIÓN 2026-08-02 — el usuario revisó y cambió de posición:**

> Sigo tu recomendación un solo repositorio con versionamiento independiente por etiquetas en vez
> de por repos

### ✅ T16 CERRADA — Monorepo con versionamiento por etiquetas

```
tripri/
├── backend/     # FastAPI · SQLAlchemy · Alembic · Procrastinate
├── web/         # React 19 · Vite · TanStack Query · Tailwind + shadcn/ui
├── mobile/      # React Native · Expo · Expo Router · SQLite cifrada
├── infra/       # Terraform
├── contracts/   # openapi.json generado + tipos derivados (openapi-typescript)
└── .github/workflows/
```

| Necesidad | Mecanismo |
|---|---|
| Versionamiento independiente por componente | **Etiquetas con espacio de nombres**: `mobile-v1.4.2`, `backend-v2.1.0` |
| CI que no dispare todo por cualquier cambio | **Filtros de ruta** en GitHub Actions (`paths: backend/**`) |
| Despliegue a producción y develop | Por **etiqueta y entorno**, no por ramas paralelas en varios repos |
| Infra con radio de impacto distinto | Carpeta `infra/` con revisión obligatoria y credenciales propias en la CI |

**Propuesta original del usuario y por qué se descartó tras revisión.** El usuario propuso 5
repositorios (principal + Backend + Web + Mobile + Infra) enlazados como **submódulos**, con una
**rama del mismo nombre en los 5** para desplegar. Su instinto acertaba en dos puntos que el monorepo
**preserva íntegros**: el móvil tiene calendario de versiones propio (se distribuye por tiendas — es
la razón por la que T22 exigió pruebas de contrato) y la infraestructura merece trato aparte por
radio de impacto. Tres problemas lo desaconsejaron:

1. **El contrato OpenAPI —el acoplamiento principal del sistema— empeoraba.** Añadir un campo
   obligatorio pasaba a ser 5+ commits en 4 repos moviendo punteros. Y **la puerta de compatibilidad
   de contrato de T25 dejaba de proteger lo que la justificaba**: en un solo repo el cambio rompedor
   y su corrección en los clientes **viajan en el mismo commit**, así que la puerta ve el conjunto;
   repartido en repos, la CI del backend no puede ver a los clientes, y lo que la puerta existía para
   proteger eran **las apps ya instaladas en los teléfonos de los cobradores**.
2. **La rama del mismo nombre en 5 repos es un protocolo de coordinación sin coordinador.** No hay
   atomicidad: `develop` en Backend con el endpoint nuevo y `develop` en Mobile sin él **despliega un
   par incompatible y nada lo impide**. El estado "qué hay en develop" son 5 punteros que pueden
   desincronizarse. En un solo repositorio el problema no existe: un commit **es** el estado
   consistente.
3. **`CX-27`** — 5 repos son 5 CI, 5 flujos de dependencias, 5 juegos de permisos, más el impuesto
   conocido de los submódulos (HEAD desacoplado, clones con carpetas vacías, commits que solo mueven
   punteros). Se paga en tiempo de depuración, el recurso escaso del equipo.

**El argumento que decidió: reversibilidad.** Partir un monorepo en varios repos después es fácil
(`git filter-repo` conserva el historial); unir repos en un monorepo conservando historial es
notablemente más difícil. Es el mismo criterio ya aplicado en T14 y en `infraestructura-aws.md` §2.4.

**Cuándo revisar esta decisión** (registrado para que no se olvide el matiz): el multi-repo sería lo
correcto si equipos u organizaciones distintas poseyeran cada pieza con control de acceso separado,
si el móvil debiera liberarse como código abierto, o si un cliente exigiera **recibir el repositorio
del backend por separado como entregable contractual**. La primera puede llegar a aplicar — y para
entonces, partir es la operación fácil.

**Decisión adicional registrada:** **Terraform** confirmado como herramienta de infraestructura como
código → cierra `OQ-T-23` y adelanta parte de T29.

⬜ **Pendiente de T16**: la convención de **capas** del backend (parte C de la pregunta) y el
**idioma del código** (`OQ-T-24`).

---

### Question T16-C: Convención de capas / patrón arquitectónico

**Recorrido de la respuesta.** El usuario reformuló la pregunta como *"es una decisión sobre el patrón
arquitectónico"* y pidió recomendación con explicación. Tras una primera explicación técnica pidió
**"explícamelo otra vez como si yo fuera un niño de 15 años"**, y sobre la versión simplificada
**discrepó parcialmente**: aceptó la organización por módulos pero **rechazó descartar hexagonal /
clean architecture**, argumentando pérdida de flexibilidad real. Preguntó después si hexagonal aplica
al repositorio raíz del monorepo. Confirmado el 2026-08-02.

**La discrepancia del usuario estaba fundada, y se corrigió la recomendación.** El argumento que la
sostiene no es genérico: **en esta misma sesión la capa de mensajería cambió dos veces y apareció un
servicio nuevo** — `CX-16` (WhatsApp Business API sigue sin confirmar), `CX-29` (Telegram aparece sin
precedente en el material) y `CX-30` (Bedrock pasa de fuera a condicional). La volatilidad de la
infraestructura externa es un **hecho observado**, no una especulación sobre el futuro, y ahí los
puertos se pagan solos.

### ✅ T16-C CERRADA — Monolito modular · rebanadas verticales · hexagonal por módulo

**Nivel 1 — Monolito modular.** Un solo proceso desplegable con fronteras internas explícitas. Ya
fijado de hecho por T3, T13 y T14. Justificado por la escala: 0,04 escrituras/s sostenidas, pico ~4
req/s.

**Nivel 2 — Rebanadas verticales.** Agrupación por capacidad de negocio, **no por tipo de archivo**.
Motivo específico del proyecto: con equipo de una persona (`CX-27`), la organización que minimiza
cuánto hay que recordar al volver a un módulo semanas después es la que gana. Además, las rebanadas
**son** las fronteras del monolito modular si algún día algo debe separarse.

**Nivel 3 — Núcleo funcional / cáscara imperativa** (*Functional Core / Imperative Shell*). **Ya
estaba comprometido por T22 sin nombre**: matemáticas de dinero en funciones puras, reloj inyectado.
Se le da nombre para que exista literatura y ejemplos que consultar.

**Nivel 4 — Puertos y adaptadores (hexagonal), acotado.** Adoptado a petición del usuario, con la
regla que impide que degenere.

#### Estructura final

```
backend/src/
├── pagos/            # router · service · domain · repository · models
├── prestamos/        # los mismos 5 archivos
├── caja/             # los mismos 5 archivos
├── clientes/
├── sync/             # cola de comandos offline (patrón Command, T14)
├── auth/             # JWT propio + vinculación de dispositivo (T17)
├── ports/            # enchufes COMPARTIDOS
│   ├── reloj.py
│   ├── mensajeria.py
│   ├── archivos.py
│   └── push.py
├── adapters/         # implementaciones reales + falsas para pruebas
│   ├── reloj_sistema.py · whatsapp_cloud.py · telegram_bot.py
│   ├── s3.py · fcm.py · bedrock.py
│   └── *_falso.py
└── shared/           # db · config · dinero · errors · tenant
```

| Archivo del módulo | Responsabilidad |
|---|---|
| `router.py` | Recibe y valida lo que llega de fuera (FastAPI + Pydantic) |
| `service.py` | Orquesta los pasos. **Cáscara imperativa** |
| `domain.py` | **Núcleo funcional.** Reglas puras: interés, imputación, contador fraccionario. Sin base de datos, sin red, sin reloj |
| `repository.py` | **El único que toca la sesión** en ese módulo |
| `models.py` | Tablas SQLAlchemy |

#### Reglas vinculantes

1. **Un puerto por cada cosa que (a) podría cambiar de verdad, o (b) estorba en las pruebas.**
   La lista es **cerrada, seis** y cada una tiene justificación registrada: **reloj** (exigido por
   T22 — sin él no se puede probar mora, cierre diario ni frecuencia lunes–sábado), **mensajería**
   (`CX-16` + `CX-29`, ya cambió dos veces), **archivos** (S3 con URLs firmadas; en pruebas no se
   sube nada a AWS), **IA** (`CX-30` + `OQ-T-15` abiertos), **repositorio** (probar `service.py` sin
   PostgreSQL), **push** (FCM). **Todo lo demás va directo, sin interfaz.** La lista puede crecer
   cuando aparezca una séptima necesidad real — no se llena "por si acaso".
2. **`ports/` no importa librerías externas ni contiene lógica.** Si un archivo ahí importa `boto3`
   o `httpx`, está mal ubicado.
3. **El repositorio NO se comparte.** `pagos/repository.py` y `prestamos/repository.py` son archivos
   distintos dentro de su módulo. Centralizarlos produciría un archivo que conoce todas las tablas y
   anularía la rebanada vertical. **Regla general: un puerto vive donde están los que lo usan.**
4. **`shared/` entra por uso, no por previsión** — algo entra cuando **ya** lo usan dos módulos o
   más. Es la carpeta que se pudre si se usa como cajón de sastre.
5. **`shared/dinero.py`** envuelve `Decimal` en un tipo propio, para que la prohibición de `float`
   de T10 sea difícil de romper por accidente.

#### Alcance de la decisión

⚠️ **Hexagonal aplica SOLO a `backend/`.** La raíz del monorepo **no tiene arquitectura, tiene
proyectos**. `web/` y `mobile/` se organizan por pantallas y componentes, como corresponde a React —
**no se les debe aplicar este patrón**.

#### Lo que el patrón compra, y lo que no (advertencia registrada)

Los puertos dan flexibilidad para **cambiar infraestructura** — proveedor de mensajes, de archivos,
de IA. **No dan flexibilidad para cambiar reglas de negocio ni para escalar**; eso lo dan las
rebanadas verticales y el núcleo funcional. Se deja escrito porque "flexibilidad" es la palabra con
que se vende arquitectura, y conviene saber qué se está comprando.

#### Patrones evaluados y descartados

| Patrón | Motivo |
|---|---|
| **Clean Architecture completa** (DTOs, mappers, interfaz para todo) | Se toma la idea (puertos) sin la ceremonia. Un enchufe por clase produce decenas de interfaces con una sola implementación; con `CX-27` ese presupuesto se gasta mejor en el motor de sincronización |
| **DDD táctico completo** | Se toma prestado lo útil — `pagos/` es un agregado, `Dinero` es un objeto de valor — sin adoptar el vocabulario formal entero |
| **CQRS** | Resuelve un desbalance lectura/escritura inexistente aquí. **La tabla de resumen precalculado que T14 aprobó ya es el único trozo de CQRS necesario** |
| **Event Sourcing completo** | **Ya se usa, acotado y a propósito**: T14 fijó que el saldo es la suma de los movimientos y que un error se corrige con asiento compensatorio. Está bien donde está —en el dinero, donde la inmutabilidad *es* el producto— y extenderlo a clientes, rutas o configuración sería pagar el costo sin la razón |

#### Patrones ya presentes, ahora nombrados

- **Command** — la cola offline de T14: el dispositivo no replica estado, **transmite intenciones que
  el servidor valida**. Define la forma de `sync/`: cada operación es un objeto con tipo, carga,
  identificador de idempotencia y agregado destino; se aplican **en orden por agregado, no global**.
- **Event log acotado** — el ledger append-only de T14.
- **Functional Core / Imperative Shell** — las cuatro restricciones de diseño de T22.

---

### `OQ-T-24`: Idioma del código y de los nombres de dominio

**[Answer] 2026-08-02:** **A · Todo en inglés** — código, tablas, API, variables y nombres de dominio.

**Recomendación no seguida, y queda constancia de por qué se recomendó lo contrario.** Se había
propuesto **B** (dominio en español, técnico en inglés) sobre la base de que algunos conceptos de este
negocio no tienen traducción limpia —"caja" no es exactamente *cash register*, y el contador
fraccionario de cuota de `D-02` no tiene equivalente estándar— y de que toda la definición del
producto, las 117 respuestas del cliente y esta entrevista están en español, de modo que el código en
español eliminaba un salto de traducción en cada revisión. **El usuario eligió inglés**; decisión
registrada y aplicada.

**Mitigación obligatoria del riesgo que la recomendación señalaba.** Como el riesgo de A era
precisamente la **ambigüedad de traducción en un sistema que debe ser exacto**, se fija un
**glosario vinculante** — un término español del negocio ↔ un único término inglés en el código.
Sin glosario, el mismo concepto aparecería como `fee`, `quota` e `installment` en tres módulos.

| Español (negocio / cliente) | Inglés (código, tablas, API) | Nota |
|---|---|---|
| préstamo | `loan` | |
| cuota | `installment` | grafía estadounidense, una sola en todo el código |
| contador fraccionario de cuota | `fractional_installment_counter` | `D-02` |
| caja | `cash_box` | ni *till* ni *cash_register* |
| cierre de caja | `cash_box_closing` | |
| movimiento (del ledger) | `ledger_entry` | **no** `movement` — es un asiento, no un desplazamiento |
| asiento compensatorio | `reversal_entry` | T14 |
| cobrador / gestor | `collector` | |
| ruta | `route` | |
| cliente (deudor) | `client` | **no** `customer`: el `customer` es el tenant que paga la suscripción |
| tenant (empresa suscrita) | `tenant` | |
| socio | `partner` | destinatario de los reportes (`C-81`) |
| mora | `arrears` | |
| abono / pago | `payment` | |
| imputación de pago | `payment_allocation` | |
| venta (aprobación en 4 pasos) | `sale` | ⚠️ verificar: en `D-02` describe el **desembolso** de un préstamo nuevo |
| desembolso | `disbursement` | |
| interés fijo sobre capital | `flat_interest_on_principal` | `D-02` |
| renovación | `renewal` | `C-28` |

⚠️ **Cuatro términos por confirmar con el cliente o con el usuario** antes de escribir código:
`sale` (¿es realmente una venta o el desembolso de un préstamo?), `client` contra `customer` (la
distinción deudor/suscriptor debe ser inequívoca por `D-01`), `partner` (¿socio inversor o socio
comercial?), y si `collector` cubre a la vez "cobrador" y "gestor" o son dos roles distintos.
Registrado como continuación de `OQ-T-24`.

#### Corrección aplicada a T16 (la estructura confirmada estaba en español)

Los ejemplos que el usuario confirmó en T16 usaban nombres en español. **Se renombran ahora**, que es
cuando es gratis: más adelante tocaría tablas, migraciones de Alembic, el esquema OpenAPI y los tipos
generados en web y móvil.

```
backend/src/
├── payments/         # antes pagos/
├── loans/            # antes prestamos/
├── cash_box/         # antes caja/
├── clients/          # antes clientes/
├── sync/
├── auth/
├── ports/
│   ├── clock.py      # antes reloj.py
│   ├── messaging.py  # antes mensajeria.py
│   ├── storage.py    # antes archivos.py
│   ├── push.py
│   └── ai.py
├── adapters/
│   ├── system_clock.py · whatsapp_cloud.py · telegram_bot.py
│   ├── s3_storage.py · fcm_push.py · bedrock_ai.py
│   └── fake_*.py
└── shared/
    ├── db.py · config.py · errors.py · tenant.py
    └── money.py      # antes dinero.py — envuelve Decimal (T10 prohíbe float)
```

Función de ejemplo renombrada: `imputar_pago(...)` → **`allocate_payment(...)`** en
`payments/domain.py`.

---

## Section T6 (continuación) — Seguridad

### Question T18: Requisitos de cifrado

**[Answer] 2026-08-02:** **A · Todo cifrado en reposo Y en tránsito.**

#### Lo que ya era obligatorio por respuestas anteriores

| Elemento | Origen |
|---|---|
| SQLite del dispositivo cifrada | T8 (`C-71` pide borrado remoto) |
| S3 cifrado para las fotos de identidad | T14 |
| Clave privada del dispositivo en Keychain/Keystore, sin salir nunca | T17 |
| Cookie `httpOnly` + `Secure` + `SameSite` en web, nunca `localStorage` | T17 |

#### Lo que A añade y queda fijado

1. **RDS cifrado con KMS.** ⚠️ **Debe activarse al crear la instancia** — AWS no permite activarlo
   después sin recrearla y migrar los datos. **Es un paso irreversible del `terraform apply` inicial**
   y debe quedar en el fragmento canónico de T29.
2. **Copias de seguridad y snapshots cifrados** — heredan la clave de la instancia; se declara
   explícito para que no se asuma.
3. **TLS entre ECS y RDS: `sslmode=require` en la cadena de conexión.** **No es automático**: sin
   esta opción el tráfico entre la tarea y la base va en claro **dentro de la VPC**. Es el punto que
   más se olvida al declarar "todo cifrado en tránsito".
4. **TLS público (ALB y CloudFront): mínimo 1.2, preferido 1.3.**
   ⚠️ **Asunción declarada, no respuesta del usuario.** No se declararon los modelos de teléfono de
   los cobradores. **TLS 1.3 obligatorio exige Android 10+**; con gama baja o teléfonos viejos podría
   dejar usuarios fuera, y el fallo se vería como *"no sincroniza"*, no como un error de TLS.
   **1.2 como mínimo es la opción segura**; se sube a 1.3 obligatorio si se confirma que el parque de
   dispositivos lo soporta. → `OQ-N-45b`.
5. **Cifrado de la SQLite del dispositivo: LIBRERÍA AÚN SIN DECIDIR.** Riesgo abierto desde T8 y **no
   resuelto por esta respuesta**. Tensión real: `mobile-platform-constraints.md` regla 2 prefiere
   librerías del SDK de Expo (→ `expo-sqlite`), pero **`expo-sqlite` no cifra**; la alternativa es
   `op-sqlite` + SQLCipher, fuera del SDK. **Declarar "todo cifrado en reposo" convierte esto en
   requisito bloqueante del arranque del proyecto, no en una preferencia.** **Verificar antes de la
   primera línea de código móvil. No asumir que `expo-sqlite` cifra.**

#### Cruce con T21

Con **A** declarado, si `T21` resuelve **LGPD** el cifrado deja de ser buena práctica y pasa a ser
exigible — pero no cambia ninguna de las decisiones de arriba, porque A ya es el nivel más alto de
la pregunta. La regla de validación del banco de preguntas (T18 debe alinearse con T21) **se cumple
por construcción**.

---

### Question T21: Marco de cumplimiento

**[Answer] 2026-08-02:** **X · ISO 27001 + LGPD** (acumulados).

> *"Debes anotar en el contexto que es necesario que el desarrollador se empape del contexto de
> ISO 27001 Y LGPD antes de desarrollar los módulos"* — **instrucción explícita del usuario,
> registrada como requisito previo al desarrollo.**

#### 🔴 REQUISITO PREVIO AL DESARROLLO (instrucción directa del usuario)

**Antes de escribir el primer módulo, el desarrollador debe formarse en ISO 27001 y LGPD.** No es una
recomendación: es una condición de entrada declarada por el usuario. Con equipo de una persona
(`CX-27`) **no hay nadie más que aporte ese conocimiento**, y las dos normas condicionan decisiones
de diseño que son caras de revertir (retención, base legal, exportación de datos, registro de
accesos). AI-DLC debe tratar esto como precondición del Requirements Analysis.

#### Efecto sobre `CX-11`

Declarar LGPD **presupone Brasil** y elimina la incertidumbre de *qué marco aplica*, pero **no cierra
`CX-11`**: siguen sin declararse **moneda** e **idioma de la interfaz**. `CX-11` baja de "bloqueante
total" a "pendiente de dos campos".
**Refuerza `sa-east-1`** (T11) como decisión correcta: LGPD no exige residencia estricta, pero la
transferencia internacional requiere salvaguardas, y no transferir es más barato que documentarlas.
**Refuerza también la corrección del usuario sobre Claude en Bedrock `sa-east-1`** — si la IA vuelve
por `CX-30`, procesarla fuera de Brasil habría sido una transferencia internacional que documentar.

#### Lo que YA está cubierto por decisiones anteriores

| Exigencia | Estado | Origen |
|---|---|---|
| Cifrado en reposo y en tránsito | ✅ Nivel máximo | T18 = A |
| Trazabilidad y no repudio | ✅ Por encima de lo que piden ambas normas | T14 ledger append-only + `C-99` |
| Derecho de eliminación contra ledger inmutable | ✅ Resuelto por diseño | T14 (foto en S3, tabla con referencia + hash) |
| Control de acceso e identificación | ✅ | T17 (JWT propio + vinculación de dispositivo) |
| Aislamiento entre tenants | ✅ | RLS en PostgreSQL, `tenant_id` desde el token verificado |
| Gestión de secretos | ✅ | T20 |
| Desarrollo seguro | ✅ | T25 (SAST, DAST, escaneo de dependencias) |
| Registro y monitorización | 🟡 Parcial | CloudWatch Logs + Alarms (T11); falta detección de incidentes |

#### Lo que ESTAS DOS NORMAS AÑADEN y no estaba en ningún requisito

| Nuevo requisito | Norma | Naturaleza |
|---|---|---|
| **Exportación de datos de un titular** (derecho de acceso y portabilidad) | LGPD art. 18 | 🔴 **Funcionalidad que no existe en ningún requisito hasta hoy.** El sistema debe poder entregar todo lo que guarda sobre un cliente concreto → nueva `OQ-F-100` |
| **Base legal del tratamiento** | LGPD art. 7 | Decisión legal, no técnica. La toma el cliente o un abogado |
| **Encarregado / DPO designado** | LGPD art. 41 | Rol organizativo. **No lo puede ocupar el desarrollador** |
| **Notificación de brechas a la ANPD** | LGPD art. 48 | Exige **capacidad de detección**, no solo de registro |
| **Política de retención documentada** | Ambas | Cierra el hueco que `OQ-T-13` dejó pendiente |
| **Inventario de activos** | ISO 27001 A.5.9 | Documental |
| **Evaluación de riesgo de proveedores** | ISO 27001 A.5.19–A.5.22 | AWS, Meta/WhatsApp, Telegram, Sentry, Google/FCM, Expo — **seis terceros con acceso a datos o a la operación**, ninguno evaluado |
| **Plan de respuesta a incidentes** | ISO 27001 A.5.24–A.5.28 | Sin declarar |
| **Revisión periódica de accesos** | ISO 27001 A.5.18 | Sin declarar |
| **Continuidad de negocio y recuperación** | ISO 27001 A.5.29–A.5.30 | Parcial: hay copias (T18), no hay plan probado |

#### ⚠️ Distinción que decide el costo, y que hay que confirmar

**"Alineado con ISO 27001"** (usar el Anexo A como lista de control, sin auditor) y **"certificado
ISO 27001"** (SGSI documentado, análisis de riesgos formal, auditoría interna, revisión por la
dirección y **auditoría externa de certificación**) son cosas muy distintas: la primera es trabajo de
ingeniería, la segunda es un proyecto organizativo de meses con costo de auditoría. **No se declaró
cuál de las dos.** → `OQ-N-46`.

#### 🔴 Contradicción estructural detectada: ISO 27001 contra equipo de una persona

**ISO 27001 A.5.3 exige segregación de funciones.** Y **T25 fijó como puerta bloqueante de fusión la
"revisión de código aprobada"**. **Con un solo desarrollador no hay revisor.** No es un detalle
formal: la persona que escribe el código de la caja es la misma que lo aprueba, lo despliega y opera
la producción — exactamente lo que ese control existe para impedir, **en un producto cuya razón de ser
es el antifraude**. Abierto como `CX-31`.

---

## Section T7 (continuación) — Testing

### Question T24: Herramienta por tipo de prueba

**[Answer] 2026-08-02:** *"Estoy de acuerdo con los tipos de test para cada una"* — **propuesta
aceptada íntegra** (excepción aprobada a la política de no pre-llenado; la sexta).

| Tipo de prueba | Herramienta | Justificación |
|---|---|---|
| Unitaria — backend | **pytest** | Estándar en Python. El núcleo funcional (`domain.py`, T16) se prueba sin nada más: entradas → salidas |
| Unitaria — web y móvil | **Vitest** | Nativo de Vite (T8). Un solo runner para `web/` y `mobile/` |
| Integración | **pytest + Testcontainers** | T22 exige **PostgreSQL real**: RLS, transacciones y la restricción de unicidad que sostiene la idempotencia **no existen en ningún otro sitio**. Testcontainers levanta el contenedor desde la propia prueba |
| Contrato | **`oasdiff` / `openapi-diff`** en la puerta rápida | Compara el OpenAPI del cambio contra el publicado y falla ante una ruptura. **Deliberadamente NO es Pact**: no hay consumidores independientes negociando, hay **un esquema publicado** y clientes generados desde él |
| E2E — web | **Playwright** | |
| E2E — móvil | **Maestro** | Pensado para React Native; notablemente menos frágil que Detox |
| Rendimiento | **k6** | ⚠️ **No ejecutable todavía** — `OQ-N-44`: no existe objetivo contra el que medir. *Una prueba que no puede fallar no es una prueba* |
| SAST + dependencias | **Ruff · Bandit · `pip-audit`** (Python) · **`npm audit`** (JS) · **Trivy** (imagen y IaC) | Trivy cubre además el **Terraform** de T16 — el IaC es código y entra en la misma puerta |
| DAST | **OWASP ZAP** en la puerta lenta | Gratuito y automatizable en CI |

**Cierra `OQ-T-20`** (herramienta por tipo). `OQ-T-19` sigue parcial: falta el **objetivo de
cobertura** (T23, fuera de alcance por decisión de profundidad).

⬜ **Dos puntos planteados junto a T24 y NO respondidos todavía**: el **escalonamiento de adopción**
(arrancar por las herramientas de la puerta rápida) y la **lista concreta de flujos E2E**, pendiente
desde T22.

---

## Section T8 — Ejemplos de Código

### Questions T26 · T27 · T28 · T29

**[Answer] 2026-08-02:** opción **1 — el rol técnico escribe los cuatro ejemplos a partir de las
respuestas de la entrevista; el usuario revisa. APROBADOS.**

Séptima excepción aprobada a la política de no pre-llenado (tras T10, T14, T17, T20, T11 y T24).
Justificación registrada: el repositorio está vacío, no hay código previo del que extraer patrones, y
con `CX-27` (una persona, sin experiencia en varias de las tecnologías) **un ejemplo revisable ayuda
más que una página en blanco**. Los ejemplos **no inventan**: hacen explícito lo que ya estaba
decidido, y cada bloque marca de qué respuesta sale cada decisión.

**Contenido completo en `technical-environment.md` §Example Code.**

| Ejemplo | Archivo | Decisiones que encarna |
|---|---|---|
| **T26** | `payments/router.py` | T13 REST+OpenAPI · T17 `tenant_id` desde el token · T16 el router no contiene reglas · T22 idempotencia |
| **T27** | `shared/money.py` · `payments/domain.py` · `payments/service.py` · `shared/db.py` | T16 núcleo/cáscara · T10 sin `float` · T22 reloj inyectado · T14 ledger append-only y saldo como suma · T16 puertos |
| **T28** | `tests/payments/test_domain.py` · `tests/test_isolation.py` | T22 unitaria pura + integración contra PostgreSQL real · T10 RLS como frontera · T14 append-only verificado |
| **T29** | `infra/rds.tf` · `infra/ecs.tf` | T16 Terraform · T18 KMS y `ssl=require` · T11 red privada · T11 RDS no Aurora |

#### Decisiones de diseño introducidas por los ejemplos (nuevas, no derivadas)

1. **`amount` viaja como cadena, no como `number` de JSON.** T10 prohíbe `float` para dinero, pero un
   `number` de JSON **es** un float en cuanto lo procesa un parser de JavaScript, y web y móvil son
   TypeScript (T8). Con el campo como número, la prohibición se rompe en el cliente sin que el
   backend se entere.
2. **`Money` guarda unidades menores enteras**, no `Decimal` suelto — no existe fracción de centavo
   que perder. **No se define `__mul__` por float ni división que devuelva `Money`**; solo
   `ratio_to`, que devuelve un ratio. ⚠️ **`Money` no lleva código de moneda porque `CX-11` sigue
   abierto**; cuando cierre se añade **en un solo sitio**.
3. **Dos relojes en el asiento del ledger: `occurred_at` (lo que dijo el teléfono, no fiable) y
   `recorded_at` (reloj del servidor, el que vale para auditoría).** Sin dos campos separados **el
   escenario obligatorio de T14 "reloj del dispositivo cambiado a mano" no se puede ni representar**,
   y un cobrador con el reloj adelantado podría fabricar la hora de un pago.
4. **404 y no 403 cuando el recurso pertenece a otro tenant.** Bajo RLS ese préstamo no existe para
   la sesión; un 403 confirmaría su existencia.
5. **No existe `loans.update_balance(...)`.** El saldo es la suma de los asientos (T14); no hay
   columna editable que actualizar. Los ejemplos lo hacen visible por ausencia.
6. **`extra="forbid"` en Pydantic**: un campo desconocido es error, no algo que se ignora. Con ~40
   dispositivos enviando lotes offline, un campo mal escrito que se ignora **es un pago que se pierde
   sin que nadie se entere**.

#### Cinco trampas documentadas deliberadamente

Ninguna produce un error visible; todas se detectan solo auditando o cuando ya ocurrió el daño.

| # | Trampa | Consecuencia |
|---|---|---|
| 1 | **`SET LOCAL`, no `SET`**, para fijar el tenant de RLS | `SET` persiste en la **conexión** y el pool las recicla: el siguiente request hereda el tenant anterior. **Fuga entre tenants silenciosa** |
| 2 | **`ssl=require`, no `sslmode`**, con asyncpg | `sslmode` **se ignora sin error**. Tráfico ECS↔RDS en claro dentro de la VPC, con ISO 27001 declarado |
| 3 | `amount` como cadena | Un `number` de JSON es float en TypeScript |
| 4 | `storage_encrypted` solo al crear la instancia | Activarlo después exige recrear y migrar |
| 5 | 404 en vez de 403 para otro tenant | 403 confirma la existencia del recurso |

**✅ Cierra `OQ-T-22` (P0)** — la brecha más cara del documento. §Example Code deja de decir
*"No aportado"* cuatro veces.

---

# ENTREVISTA TÉCNICA AMPLIADA COMPLETA — 23/23

Quick pass (13) + ampliación (10: T4, T11, T16, T18, T21, T24, T26, T27, T28, T29).
**Respondidas de regalo**: T12 (disallow list), `OQ-T-24` (idioma del código), T16-C (capas).
Fuera de alcance: T6, T9, T15, T19, T23.

---

### T24 (a) — Escalonamiento de adopción de herramientas

**[Answer] 2026-08-02:** **A · confirmado.**

**Fase 1 — desde el primer commit** (las cuatro de la **puerta rápida** de T25, las que bloquean cada
fusión): **pytest** · **Testcontainers** · **oasdiff** · **Ruff + Bandit**.

**Fase 2 — cuando existan flujos que probar** (puerta lenta, bloquea el despliegue no la fusión):
**Playwright** · **Maestro** · **k6** *(no antes de que `OQ-N-44` fije un objetivo)* · **OWASP ZAP**.

**Los seis tipos de prueba de T22 siguen siendo obligatorios.** El escalonamiento ordena **cuándo
aparece cada herramienta**, no reduce el alcance. Motivo registrado: sin escalonar son 10
herramientas que instalar, configurar y mantener **antes de escribir la primera funcionalidad**, y
con `CX-27` eso se paga en semanas de calendario. La partición coincide exactamente con los dos
niveles de puerta que T25 ya había definido, así que no introduce un criterio nuevo.

⬜ **Pendiente todavía**: la lista concreta de flujos E2E (T24 punto b), abierta desde T22.

---

### T24 (b) — Lista de flujos E2E

**[Answer] 2026-08-02:** **confirmado — exactamente tres, y ninguno más.**

| # | Flujo | Por qué está en la lista |
|---|---|---|
| 1 | **Pago offline + sincronización** | La pieza más difícil del sistema (T14, motor propio), escrita desde cero por un equipo sin experiencia previa en ello (`CX-27`) |
| 2 | **Cierre de caja a cero pendiente** | `C-50`. Si falla, las cuentas no cuadran — el miedo nº 1 declarado por el cliente en `C-110` |
| 3 | **Aprobación de venta en 4 pasos con QR** | Control antifraude nº 2. Es la razón de existir del producto (`C-99`) |

**Cierra el pendiente que T22 había dejado abierto el 2026-08-01.** La lista es **cerrada por
diseño**: T22 ya advertía que el E2E se pudre si cubre todo — lento, frágil, y en tres semanas el
equipo aprende a reintentar hasta que salga verde, momento en el que la puerta deja de significar
nada. Tres flujos intocables valen más que veinte que nadie mira.

**✅ T24 COMPLETA** — herramientas, escalonamiento y flujos.


---

# EXTENSIÓN #2 — 2026-08-07 (sesión técnica corta)

Alcance seleccionado por el rol técnico a petición del usuario, sobre lo que quedó abierto tras la
aprobación del 2026-08-02: **T30, T31, T9-b, T32, T33, T34**. Bonus si da tiempo: T23 y los cuatro
términos de glosario sin confirmar.

Criterio de selección: **solo lo decidible sin el cliente**. Excluidos por estar bloqueados en él:
`OQ-T-15` (proveedor de LLM → `CX-30`), `OQ-T-25` (exportación de TryController → `CX-20`),
`OQ-T-26` (pasarela del SaaS) y el número `N` de retención de `OQ-T-13`.

Política de no pre-llenado vigente. Explicación y recomendación solo a petición explícita.

---

### T30 — Librería de SQLite cifrada en el dispositivo

**[Answer] 2026-08-07:** **A · `op-sqlite` + SQLCipher**, base entera cifrada, clave en
`expo-secure-store`. ⚠️ **AI-proposed / user-approved** — octava excepción a la política de
no pre-llenado, a petición explícita del usuario (*"¿cuál me recomiendas y por qué?"*).

🔴 **Cierra el requisito bloqueante de arranque que T18 abrió el 2026-08-02** y el último de los tres
supuestos con los que se aprobó el rol técnico que dependía solo del equipo.

**El argumento que decidió**: **T17 ya había comprometido** *"el desbloqueo local (PIN o biometría)
descifra la SQLite local"* — el mecanismo que permite al cobrador arrancar a las 7am sin señal.
**La opción B no puede cumplir esa frase**: no existe "la SQLite" que descifrar, solo campos sueltos.
La C tampoco: ahí no hay descifrado, hay confianza en el sistema operativo. **A es la única
consistente con una decisión ya aprobada.**

**Rechazadas, con motivo:**

- **B · cifrado por campo con `expo-sqlite`** — la objeción **no es el rendimiento** (a ~40 clientes
  por ruta, descifrar en memoria y filtrar en JS es irrelevante). Es que **funciona solo mientras
  todos se acuerden**: cada columna nueva que alguien olvide cifrar es PII en claro en un teléfono,
  **y ninguna prueba lo detecta**. Con un desarrollador junior (`CX-27`) y código generado por
  AI-DLC, un mecanismo que depende de recordar falla — y falla en silencio. Con A, olvidarse es
  imposible: el cifrado es propiedad del archivo, no de la disciplina. **Queda como plan B** si falla
  la verificación de abajo.
- **C · cifrado de disco del SO** — protege un teléfono robado **y apagado**. Tras el primer
  desbloqueo posterior al arranque, FBE (Android) y Data Protection (iOS) dejan los datos legibles,
  que es el estado en el que un teléfono de campo pasa toda su jornada. Contradice además la
  respuesta A de T18 (nivel máximo).
- **D · no persistir localmente** — choca con `C-65` (jornada completa sin señal) y con la cola de
  comandos de T14: si la app muere a media mañana los pagos no pueden desaparecer. **No es
  alternativa, es complemento**: se adopta dentro de A la purga de fotos ya subidas y datos del día
  al cerrar caja.

**La objeción de la regla 2 (`mobile-platform-constraints.md`) ya estaba pagada**: Expo Go es
imposible en este proyecto — el par de claves del dispositivo (T17), el lector de QR, el GPS preciso
y FCM ya obligan a un *development build*. El impuesto real de la regla 2 no es el dev build, es la
**calidad del config plugin en cada subida de SDK**.

⚠️ **Verificación obligatoria al montar el proyecto, antes de la primera migración**: que
`op-sqlite` publique **config plugin oficial vigente** para el SDK de Expo que se fije, y **bajo qué
condiciones de licencia expone SQLCipher**. Si cualquiera de las dos falla → plan B (opción B) con la
lista de campos sensibles cerrada por escrito. `react-native-quick-sqlite` **no** es alternativa:
está descontinuado, es el predecesor de `op-sqlite`.

**Tres trampas fijadas junto con la decisión (vinculantes para AI-DLC):**

1. 🔴 **El PIN no deriva la clave, la desbloquea.** Un PIN de 4 dígitos (`V-18`) son 10.000
   combinaciones: si la clave de la base se deriva de él, se rompe fuera de línea en segundos.
   Correcto: **clave aleatoria de 256 bits generada en el dispositivo**, guardada en Keystore /
   Keychain vía `expo-secure-store`; el PIN o la biometría **gobiernan el acceso a la clave**, no su
   contenido.
2. **Excluir base y clave de las copias del sistema** — `allowBackup=false` en Android, exclusión de
   iCloud en iOS, y el elemento del llavero con `WHEN_UNLOCKED_THIS_DEVICE_ONLY`. Sin esto, la base
   cifrada y su clave salen del teléfono por la puerta de atrás.
3. **Borrar la clave *es* el borrado remoto de `C-71`.** La base queda ilegible al instante sin que
   el teléfono coopere. Propiedad regalada de A, que debe quedar escrita antes de que alguien
   construya un borrado "de verdad".

**Efecto sobre T8**: `SQLite (encrypted, lib TBD)` deja de estar abierta. **Cierra el residuo 🔴 de
`OQ-T-17`.**

---

### T31 — Versiones mínimas de Android e iOS soportadas

**[Answer] 2026-08-07:** **A · Android 10+ / iOS 13+ — TLS 1.3 obligatorio.**

**Convierte en respuesta el supuesto declarado de T18** (*"TLS 1.2 mínimo, 1.3 preferido"*), que era
uno de los tres con los que se aprobó el rol técnico el 2026-08-02. El supuesto queda **superado**:
el mínimo público pasa a **TLS 1.3**.

**Hecho que sostiene la decisión, ya registrado y no advertido al preguntar**: `V-36` declara que
*"el sistema solo se pueda abrir en el **celular asignado por la empresa**"*, y `C-70` fija un
dispositivo por ruta. **El parque no es BYOD: se compra.** Un corte en Android 10 (2019) no excluye
nada que una empresa suscriptora pueda comprar hoy — la gama baja del mercado brasileño sale de
fábrica muy por encima. El riesgo del corte se limita a reutilizar terminales viejos ya existentes.

**Consecuencias que hay que llevar a la infraestructura (T29 / `infra/`):**

- **ALB: política de seguridad solo-TLS 1.3** (familia `ELBSecurityPolicy-TLS13-1-3-*`). Es la que
  hace real la decisión; sin cambiarla, el ALB sigue aceptando 1.2 y el corte no existe.
- ⚠️ **CloudFront no puede ir a solo-1.3.** Su versión mínima de protocolo más alta admite TLS 1.2
  junto a 1.3, así que **el suelo efectivo del bundle estático de la SPA se queda en 1.2**. No es un
  problema —el bundle es público y no lleva datos— pero **debe quedar escrito para que nadie lo lea
  como un incumplimiento** de esta decisión ni intente "arreglarlo".
- **La regla 5 de `mobile-platform-constraints.md` sigue mandando**: el mínimo de Expo sube solo cada
  año. Si algún día supera a Android 10 / iOS 13, **el corte efectivo es el de Expo**, no éste.
- Modo de fallo a vigilar: un teléfono por debajo del corte **no dice "incompatible"**, dice
  *"no sincroniza"* — y llega como incidencia de soporte un sábado por la mañana.

---

### T9-b — Librerías de segundo orden (los cinco huecos sin declarar)

**[Answer] 2026-08-07:** **1a · 2b · 3a · 4a · 5a.** Cierra el hueco que T9 había dejado abierto dos
veces por decisión de profundidad, y con él la frase *"AI-DLC recurrirá a sus defaults ahí"*.

| # | Hueco | Elección | Regla vinculante que la acompaña |
|---|---|---|---|
| 1 | Cliente HTTP del backend | **`httpx`** async | Un único cliente para WhatsApp, Telegram, FCM y SES. Timeout explícito **siempre** — el default de `httpx` es 5 s pero un `AsyncClient` mal construido puede quedar sin él, y una llamada saliente colgada bloquea un worker de Procrastinate |
| 2 | Logging estructurado | **`python-json-logger`** sobre el `logging` estándar | Ver la mitigación obligatoria de abajo |
| 3 | Fechas y dinero | **stdlib**: `datetime` + `zoneinfo` + `Decimal` en Python; `Intl` nativo en el cliente | Ninguna librería nueva de fechas en cliente ni servidor |
| 4 | Gráficas del tablero web (`C-83`) | **Recharts** | ⚠️ Fijar una versión compatible con **React 19** (T8) y verificarlo al instalar |
| 5 | Estado local del móvil | **Zustand** | Ver la frontera de abajo |

**🔴 Mitigación obligatoria de la fila 2.** `python-json-logger` da salida en JSON, pero **no aporta
enlace de contexto**: cada línea la enriquece quien la escribe con `extra={...}`, y lo que depende de
recordar se olvida — el mismo modo de fallo que decidió T30. **Por eso se fija un `logging.Filter`
que inyecta `tenant_id`, `request_id` y `device_id` desde `contextvars` en toda línea**, sin que el
desarrollador tenga que acordarse. Sin ese filtro, en un producto cuya razón de ser es la auditoría
(`C-99`) habría trazas imposibles de atribuir a un tenant.
**Segunda regla, de LGPD (T21): jamás registrar importes, documentos de identidad ni datos del
prestatario en los logs.** El registro contable es el ledger (T14), no CloudWatch.

**Por qué la fila 3 es segura con stdlib** (y no lo sería en otro proyecto): **toda la matemática
financiera vive en el núcleo funcional de Python** (T22 — funciones puras, reloj inyectado), así que
el cliente casi no hace aritmética de fechas; recibe valores ya calculados. Encaja además con dos
decisiones previas: `Decimal` con la prohibición de `float` (T10) y **`amount` como cadena**
(`OQ-T-22`), porque un `number` de JSON es `float` en TypeScript.
🔑 **Hecho a favor, verificable**: la zona es `America/Sao_Paulo` y **Brasil abolió el horario de
verano en 2019** — no hay transiciones DST, lo que elimina una clase entera de errores del contador
diario de cuotas y del cierre de caja. **Si el producto se expande a los países de `C-02` (México,
Chile, Paraguay…), esa propiedad se pierde** y la aritmética de fechas debe reexaminarse.

**🔴 Frontera de la fila 5, vinculante.** **Zustand guarda estado de interfaz y de sesión, nada
más.** La cola de comandos offline y los datos de negocio viven **en la SQLite cifrada de T30**,
nunca en un store en memoria. Y **no se usa el middleware `persist` de Zustand**, porque su
almacenamiento por defecto es AsyncStorage, **prohibido en T10** para tokens y datos de negocio.
Un pago que existe solo en un store se pierde cuando el sistema operativo mata la app a media
mañana — el escenario obligatorio de prueba de T14.

---

### T32 — Entornos y datos de prueba (`OQ-T-21`)

**[Answer] 2026-08-07:** **Parte (a) = A · solo producción + desarrollo local con Docker Compose.**
**Parte (b) = A + B · generador sintético *y* copia anonimizada de producción.**

**Efecto en costes**: incremento **$0**. La infraestructura se queda en el ~$210/mes del escenario A
más el NAT de T11. No mueve `OQ-N-45`, que sigue abierta y sigue dependiendo de `OQ-N-40`
(**presupuesto mensual nunca declarado** — conviene no volver a hablar de coste sin cerrar esa).

**🔴 Consecuencia estructural: la puerta lenta de T25 se queda sin dónde ejecutarse.** T25 fijó
**E2E + rendimiento + DAST como bloqueantes del despliegue**. Sin staging, los cuatro
instrumentos de T24 —Playwright, Maestro, k6 y OWASP ZAP— solo tienen dos destinos posibles: el
Docker Compose local o producción. **ZAP contra producción no es una opción** en un sistema con datos
financieros de terceros. Queda registrado como **`CX-39`**.

**Mitigación acordada dentro de la decisión — la puerta lenta corre contra la pila local completa**:
Docker Compose levanta backend + PostgreSQL + base sembrada; Playwright apunta ahí; Maestro corre
sobre un *development build* apuntando a `localhost`; ZAP escanea el backend local. Es ejecutable por
una persona y no cuesta nada.
⚠️ **Lo que esta mitigación NO da**: un número de rendimiento válido. **k6 contra un portátil no mide
producción** — no hay ALB, ni NAT, ni la latencia de RDS en `sa-east-1`. Lo que sí detecta, que es
donde de verdad viven los fallos de rendimiento de un equipo de una persona, son las **regresiones
algorítmicas**: consultas N+1, índices que faltan, un `SELECT` que crece con el número de tenants.
**Esto condiciona directamente a T34**: el objetivo que se fije debe ser medible en ese entorno, o no
será medible en ninguno.

**Parte (b): el orden importa, y la anonimización tiene una trampa de LGPD.**

1. 🔴 **Hoy no existe producción que copiar.** El proyecto es *greenfield*: el día 1 hay **solo** el
   generador sintético (A). La copia anonimizada (B) es una capacidad **futura**, que se construye
   cuando haya producción y solo si el generador se demuestra insuficiente.
2. 🔴 **Una copia "anonimizada" que conserve importes, fechas y estructura de ruta es
   reidentificable** en un conjunto de ~2.000 clientes. Eso no es anonimización, es
   **seudonimización** — y bajo LGPD **sigue siendo dato personal** (art. 13), con las mismas
   obligaciones que producción. Si acaba en el portátil del desarrollador, es una fuga con forma de
   herramienta de trabajo.
3. **Regla vinculante**: **jamás un `pg_dump` de producción a una máquina local.** Si se hace B, la
   transformación **se ejecuta dentro de AWS** y solo sale el resultado ya transformado.
4. **Camino recomendado que honra A y B sin mover un solo dato personal**: extraer de producción
   **parámetros estadísticos** (nº de filas, distribución de importes, tamaño de ruta, tasa de mora)
   y alimentar con ellos al **generador sintético**. Se obtiene el realismo que motiva B sin que
   ningún dato de un prestatario salga nunca. **Ventaja adicional sobre la copia**: el generador se
   puede escalar a 10× para pruebas de carga; una copia real está fijada al tamaño real.

---

### T33 — Alcance de ISO 27001 y la puerta de revisión de código (`CX-31`)

**[Answer] 2026-08-07:** **B · "alineado con ISO 27001", no certificado.**

✅ **Cierra `CX-31`** (P0, abierta desde el 2026-08-02), ✅ **cierra `CX-38`** y ✅ **cierra
`OQ-N-46`** — la distinción *alineado* contra *certificado*, que T21 había dejado sin hacer.

**Lo que sostiene la decisión** es `CX-38`, que no existía cuando se abrió `CX-31`: **`V-53` dice
que el cliente no prevé que nadie le exija el certificado** (*"nuestros clientes son empresas
pequeñas"*). Sin comprador que lo exija, certificar es un proyecto organizativo de meses **sin
comprador**. Y la diferencia práctica es exactamente la que hacía irresoluble `CX-31`: **un estándar
usado como guía de diseño admite excepciones documentadas; una certificación auditada, no.**

**La excepción que hay que documentar (y dónde):** A.5.3 —segregación de funciones— **no se cumple**
y se declara así por escrito, en `technical-environment.md` §Compliance. Declararlo es parte del
método, no una trampa: es el equivalente a la Declaración de Aplicabilidad.

**Los cuatro controles compensatorios, vinculantes:**

1. **La puerta de T25 se reescribe.** *"Revisión de código aprobada"* deja de significar aprobación
   humana —imposible con una persona— y pasa a ser **análisis estático obligatorio (Ruff + Bandit,
   ya fijados en T24) + una lista de comprobación marcada en el PR**. La puerta sigue existiendo y
   sigue bloqueando; cambia quién la satisface.
2. 🔴 **Aprobación del cliente para cambios en módulos de dinero** (`payments/`, `cash_box/`,
   `ledger`). **Es el único control que produce segregación real**: la aprobación la da una persona
   distinta del desarrollador. Es lo que hace que B no sea papeleo.
3. 🔴 **No se despliega desde el portátil. Nunca.** Solo desde CI, por etiqueta. **Este control
   sostiene a los otros tres**: si el desarrollador puede desplegar desde su máquina, el registro
   inmutable de despliegues no registra nada y la aprobación del punto 2 se puede saltar sin dejar
   rastro. Si solo un control de esta lista sobrevive a la prisa, tiene que ser éste.
4. **Acceso a producción auditado y sin permanencia**: nada de acceso humano estable a la RDS de
   producción; entrada de emergencia por rol de IAM, con CloudTrail y **alarma al usarlo**. Un
   acceso de emergencia que no avisa a nadie es un acceso normal con otro nombre.

**LGPD no se ve afectada** — es obligatoria por ley, no por exigencia de cliente, y sigue íntegra
con todo lo que T21 registró (`OQ-F-100` exportación de datos del titular, `OQ-N-47` detección de
brechas, base legal, DPO, evaluación de los seis proveedores).

---

### T34 — Objetivo de rendimiento (`OQ-N-44`) — ⬜ **NO RESPONDIDA**

**Sesión cerrada por el usuario el 2026-08-07 antes de responderla.** `OQ-N-44` sigue **abierta**,
y con ella la prueba de rendimiento de T22 sigue sin ser ejecutable.

**Lo que se había puesto sobre la mesa al plantearla, para no perderlo:**

La carga declarada —**~1.200 pagos/día, ~3/minuto en pico** (T3), 30–40 usuarios— es **0,05 req/s**:
un objetivo de *throughput* no mediría nada. **El riesgo real de rendimiento de este sistema no es
la concurrencia, es el crecimiento del ledger.** T14 lo hizo *append-only* y definió el saldo como
**la suma de los movimientos**: a 1.200 asientos/día son **~1,1 millones en 3 años**, y calcular un
saldo sumando esa tabla se degrada de forma **continua e invisible** hasta que un sábado no cierra
la caja. T14 ya previó la mitigación —**tabla de resumen precalculada** refrescada por una tarea
periódica de Procrastinate— pero **nadie ha fijado el umbral que obligaría a activarla**.

Opciones presentadas: **(a)** latencia sobre volumen envejecido —sembrar ~1,5 M de asientos y fijar
`p95` en subida de lote de sincronización, cierre de caja y resumen del tablero— · **(b)** solo
guardarraíles algorítmicos (consultas por petición acotadas, cero N+1, cero escaneos completos) ·
**(c)** ambas · **(d)** diferir hasta que exista producción. Umbrales propuestos para (a)/(c):
**p95 500 ms** lote de 40 comandos · **300 ms** cierre de caja · **1 s** tablero.

⚠️ Restricción heredada de `CX-39`: **medido en local es comparable consigo mismo, no con
producción**. Sirve para detectar **regresiones**, no para prometer un SLA.

---

## FIN DE LA AMPLIACIÓN #2 — 5 de 6

**Respondidas**: T30, T31, T9-b, T32, T33. **Sin responder**: T34.
**No alcanzados los bonus**: T23 (número de cobertura) y los **cuatro términos de glosario sin
confirmar** (`sale`, `client`/`customer`, `partner`, `collector`) — estos últimos siguen siendo
**precondición para escribir código**.
