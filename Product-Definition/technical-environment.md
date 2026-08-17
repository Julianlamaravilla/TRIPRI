# Technical Environment Document — Sistema de gestión y control antifraude de cobranza

Generado por aidlc-discovery el 2026-08-01.
Tipo de proyecto: **Greenfield** — código nuevo. TryController es un producto de terceros que el
cliente no posee: no hay código heredado que condicione, solo una **migración de datos** (`CX-20`).

> **Cómo leer este documento.** Registra **restricciones humanas**, no un diseño de arquitectura.
> Todo lo que aparece aquí fue decidido o aprobado explícitamente por el líder técnico durante la
> entrevista. El registro literal, con la justificación completa de cada decisión, está en
> `interview/technical/tech-env-answers-history.md`.
>
> **Procedencia.** La entrevista se condujo con política de **sin pre-relleno**: no se heredó nada
> de `technical-research/recomendacion-tecnica.md`. Ocho respuestas fueron **propuestas por la IA
> y aprobadas por el usuario** a petición suya —T10, T14, T17, T20, T24, T26–T29 y **T30**— y están
> marcadas como tales. La distinción importa: son recomendaciones aceptadas, no requisitos del
> negocio.
>
> **Sesiones.** Pasada rápida 2026-08-01 (13 preguntas) · ampliación 2026-08-02 (10, rol
> **aprobado**) · **ampliación #2 el 2026-08-07 (5 respondidas: T30, T31, T9-b, T32, T33)**, sobre
> los residuos que la aprobación se había llevado como supuestos declarados.

---

## Project Technical Summary

- **Project Name**: sistema multi-tenant de gestión de préstamos y cobranza en calle
- **Project Type**: Greenfield
- **Primary Runtime Environment**: **Nube exclusivamente** (T1)
- **Cloud Provider**: **AWS**, proveedor único (T2). Región de trabajo: `sa-east-1`
- **Target Deployment Model**: **Contenedores sobre ECS Fargate desde el día 1** (T3).
  EKS descartado (complejidad operativa sin equipo que la sostenga), Lambda descartado (arranques en
  frío y límites de tiempo frente a sincronizaciones por lote), **App Runner descartado por no estar
  disponible en `sa-east-1`** — verificado por el usuario
- **Team Size and Experience** (T4, 2026-08-02): **una persona, perfil junior.** Fuerte en
  **Python + FastAPI** y en **AWS**. **React solo web — sin experiencia móvil.** Sin experiencia
  declarada en React Native, Expo, criptografía en dispositivo ni motores de sincronización.
  **La misma persona opera producción.** → `CX-27` (**P0**): el alcance comprometido no cabe en el
  equipo que existe, y **el riesgo se concentra íntegramente en la mitad móvil**, que es a la vez el
  MVP (`D-03`) y la tecnología sin experiencia previa
- **Versiones mínimas de sistema operativo** (T31, 2026-08-07): **Android 10+ / iOS 13+**, lo que
  hace **TLS 1.3 obligatorio**. Sostenido por `V-36` + `C-70`: **el teléfono lo asigna la empresa**,
  el parque se compra y no es BYOD. ⚠️ El mínimo de Expo sube solo cada año (regla 5); si algún día
  supera a Android 10 / iOS 13, **manda el de Expo**
- **Entornos** (T32, 2026-08-07): **solo producción** + desarrollo local con Docker Compose. Sin
  staging. Incremento de coste $0 → ver §Entornos y datos de prueba
- **Escala inicial declarada** (T3): **30–40 usuarios y ~1.200 clientes finales** ⇒ ~1.200 registros
  de pago al día, ~3 por minuto en pico. Dato aportado en la entrevista técnica que **no estaba en
  ningún material del cliente**; contrastar con `CX-19`

---

## Programming Languages

### Required Languages

| Language | Version | Purpose | Rationale |
|---|---|---|---|
| **Python** | ≥ 3.14 | Backend completo: API HTTP, lógica de negocio, trabajos en segundo plano | Dominio del desarrollador |
| **TypeScript** | 5.x | Web de administración y app móvil | Un solo lenguaje de cliente para las dos superficies; tipos generados desde el contrato OpenAPI |
| **PostgreSQL (SQL)** | ≥ 17 | Base de datos, RLS, consultas del libro mayor | Ver §Data Patterns |

Arquitectura de **dos lenguajes**. Se evaluó y **rechazó** TypeScript en todas partes.

### Permitted Languages

**Ninguno adicional.** Política por defecto: **denegar todo lo que no sean los tres anteriores**
(T7). T6 quedó fuera del Quick pass, de modo que no existe lista de lenguajes admitidos bajo
condiciones.

### Prohibited Languages

| Language | Reason |
|---|---|
| Java | Sin experiencia en el equipo |
| C# | Sin experiencia en el equipo |
| C / C++ | Sin experiencia en el equipo |
| Ruby | Sin experiencia en el equipo |
| Pascal | Sin experiencia en el equipo |

**Go: aplazado, no vetado.** No entra hoy, pero no se prohíbe para el futuro.

---

## Frameworks and Libraries

### Required Frameworks

| Framework | Domain | Rationale |
|---|---|---|
| **FastAPI** | Backend — capa HTTP | Dominio del desarrollador. OpenAPI automático, del que se generan los tipos de TypeScript |
| **Pydantic v2** | Validación en el borde | La validación vive en la frontera — crítico recibiendo datos de ~40 dispositivos |
| **SQLAlchemy 2.0** (async, `asyncpg`) | Acceso a datos | Salida a SQL crudo para el libro mayor. Su sistema de eventos fija el contexto de tenant por transacción, de lo que depende el RLS |
| **Alembic** | Migraciones de esquema | Mismo ecosistema que SQLAlchemy |
| **Procrastinate** | Cola de trabajos y worker | La cola vive en PostgreSQL — ver decisión abajo |
| **React 19 + Vite** | Web de administración | SPA estática a S3 + CloudFront |
| **TanStack Query** | Estado del servidor en la web | El tablero (C-83) depende de refrescos; hacerlo a mano es la fuente principal de errores en paneles |
| **React Hook Form + Zod** | Formularios web | Zod valida en cliente con el esquema derivado del OpenAPI |
| **Tailwind + shadcn/ui** | Estilos y componentes web | Elegido explícitamente frente a Mantine. El código se copia al repositorio: sin bloqueo de versión. Radix por debajo resuelve accesibilidad y teclado |
| **React Native + Expo** | App móvil | Sujeto a las seis reglas vinculantes de §Mobile Platform Constraints |
| **Expo Router** | Navegación móvil | Dentro del SDK ⇒ cumple la regla 2 |
| **SQLite en dispositivo** ⚠️ | Base local del móvil | **Cifrado obligatorio. Librería sin decidir** — ver riesgo abierto |
| **`openapi-typescript`** | Contrato API → tipos TS | Es lo que evita que dos lenguajes cuesten dos contratos |
| **`expo-secure-store`** | Clave privada del dispositivo y credenciales | Keychain / Keystore. Impuesto por T17 |
| **`expo-local-authentication`** | Desbloqueo local (PIN / biometría) | Impuesto por T17 |
| **`PyJWT`** | Emisión y verificación de tokens | `python-jose` prohibido en T10 |

#### Decisión de arquitectura: la cola de trabajos vive en PostgreSQL

Lo vinculante es la propiedad, no la librería. Al registrar un pago hay que escribir en el libro
mayor **y** encolar el mensaje de WhatsApp. Con una cola externa son dos sistemas y aparece la doble
escritura: si la base confirma y la cola falla, el cliente no recibe su extracto y **nadie se
entera**. Con la cola en Postgres, ambas caben en **una sola transacción**.

No es una optimización: **el mensaje al cliente *es* la evidencia** del control antifraude nº 2 de
C-99. Perderlo en silencio rompe el control.

Efecto secundario: **no hace falta Redis**.

*Alternativa admisible*: Celery + SQS **con tabla de outbox propia** que reproduzca la misma
garantía.

#### Decisión de framework web: Vite, no Next.js

La web es **un panel de administración detrás de un login**: sin SEO, sin páginas públicas. SSR
exigiría **un proceso Node en ejecución** — un segundo runtime junto a Python, con sus parches y su
factura. Con Vite se compilan estáticos y se sirven desde S3 + CloudFront: **cero runtime de
frontend**. Además, la propuesta de valor *full-stack* de Next.js quedó descartada en T5 al elegir
Python para el backend.

### Preferred Frameworks

**Declaradas el 2026-08-07 (T9-b).** T9 quedó fuera del Quick pass dos veces por decisión de
profundidad; la ampliación #2 cerró los cinco huecos que quedaban, porque eran **cinco sitios donde
AI-DLC iba a elegir sus propios valores por defecto, y de forma distinta en cada módulo**.

| Hueco | Elección | Regla vinculante |
|---|---|---|
| Cliente HTTP del backend | **`httpx`** async | Cliente único para WhatsApp, Telegram, FCM y SES. **Timeout explícito siempre** — una llamada saliente colgada bloquea un worker de Procrastinate |
| Logging estructurado | **`python-json-logger`** sobre `logging` estándar | 🔴 Ver mitigación obligatoria abajo |
| Fechas y dinero | **stdlib**: `datetime` + `zoneinfo` + `Decimal` (Python); `Intl` nativo (cliente) | Ninguna librería de fechas nueva en cliente ni servidor |
| Gráficas del tablero web (`C-83`) | **Recharts** | ⚠️ Fijar versión compatible con **React 19** y verificarlo al instalar |
| Estado local del móvil | **Zustand** | 🔴 Ver frontera abajo |

> 🔴 **Mitigación obligatoria del logging.** `python-json-logger` da salida JSON pero **no aporta
> enlace de contexto**: cada línea la enriquece quien la escribe con `extra={...}`, y lo que depende
> de recordar se olvida. **Se fija un `logging.Filter` que inyecta `tenant_id`, `request_id` y
> `device_id` desde `contextvars` en toda línea.** Sin él, en un producto cuya razón de ser es la
> auditoría (`C-99`) habría trazas imposibles de atribuir a un tenant.
> **Segunda regla, de LGPD:** **jamás registrar importes, documentos de identidad ni datos del
> prestatario en los logs.** El registro contable es el ledger, no CloudWatch.

> 🔴 **Frontera de Zustand.** Guarda **estado de interfaz y de sesión, nada más**. La cola de
> comandos offline y los datos de negocio viven en la **SQLite cifrada** (§Encryption), nunca en un
> store en memoria. **No se usa el middleware `persist`**: su almacén por defecto es AsyncStorage,
> **prohibido en §Prohibited Libraries**. Un pago que existe solo en un store se pierde cuando el
> sistema operativo mata la app a media mañana — escenario obligatorio de prueba de T14.

> **Por qué stdlib basta para fechas y dinero aquí** (y no bastaría en otro proyecto): toda la
> matemática financiera vive en el **núcleo funcional de Python** (funciones puras, reloj
> inyectado), así que el cliente recibe valores ya calculados. Encaja con `Decimal` frente a la
> prohibición de `float`, y con **`amount` como cadena** en la API.
> 🔑 La zona es `America/Sao_Paulo` y **Brasil abolió el horario de verano en 2019**: no hay
> transiciones DST, lo que elimina una clase entera de errores del contador diario de cuotas y del
> cierre de caja. **Esa propiedad se pierde si el producto se expande a los países de `C-02`**, y la
> aritmética de fechas debe reexaminarse entonces.

### Prohibited Libraries

> ⚠️ **AI-propuesta / usuario-aprobada** (T10). El bloque A se defiende sin reservas; el bloque C es
> opinable y puede recortarse sin dañar el diseño. Criterio de selección: solo entran librerías que
> **se cuelan solas** (tutoriales, hábito, respuesta por defecto de un modelo) **y** rompen algo
> concreto de esta arquitectura.

#### Bloque A — Rompen el sistema

| Prohibited | Reason | Use Instead |
|---|---|---|
| `float` / columnas `REAL`, `DOUBLE PRECISION` para dinero | `0.1 + 0.2 != 0.3`. Con interés fijo sobre capital y **contador fraccionado de cuotas** (D-02) el error se acumula cuota a cuota y el arqueo nunca cuadra | `Decimal` + `NUMERIC(18,2)`, o enteros en centavos |
| `BackgroundTasks` de FastAPI / `asyncio.create_task` como cola | Vive en memoria del proceso: al reciclarse el contenedor **el trabajo se pierde en silencio**. El WhatsApp al cliente *es* la evidencia del control antifraude nº 2 (C-99) | Procrastinate |
| `requests` | Síncrona: en un endpoint `async` **bloquea el event loop**; una llamada lenta a WhatsApp congela a los 40 dispositivos | `httpx.AsyncClient` reutilizado |
| Filtrado de tenant en capa Python | **Ilusión de seguridad**: un `JOIN` mal hecho o SQL crudo se salta el filtro y filtra datos entre financieras | **RLS** + `SET LOCAL app.tenant_id` por transacción |
| `python-jose` | Se cuela del tutorial oficial de FastAPI. Sin mantenimiento activo; CVE-2024-33663, CVE-2024-33664 | `PyJWT` o `authlib` |
| `passlib` | Mismo origen. Última versión 2020; **se rompe con `bcrypt` 4.1+** | `bcrypt` directo, `argon2-cffi` o `pwdlib` |
| `@react-native-async-storage/async-storage` para token o datos de negocio | Archivos **en claro**. Con C-71 (borrado remoto) y fotos de identidad a bordo, un teléfono perdido entrega todo | `expo-secure-store`; SQLite cifrada para datos |

#### Bloque B — Rompen decisiones ya tomadas

| Prohibited | Reason | Use Instead |
|---|---|---|
| `redis`, `celery`, `kombu` | La cola vive en Postgres para que encolar y escribir el libro mayor sean una sola transacción | Procrastinate *(o Celery + SQS **con outbox propia**)* |
| MUI, Ant Design, Chakra, Bootstrap, PrimeReact | Traen su theming y CSS-in-JS: duplican bundle y pelean con Tailwind | shadcn/ui |
| Redux, Zustand, Jotai **para estado de servidor** | Duplican TanStack Query; fuente nº 1 de bugs en tableros (C-83) | TanStack Query; `useState`/context para UI |
| `axios` | Capa de interceptores paralela a TanStack Query, más peso | Cliente generado por `openapi-typescript` sobre `fetch` |
| `redux-persist` y equivalentes en móvil | **Segunda fuente de verdad offline**: dos capas divergen y un pago registrado desaparece | SQLite cifrada + cola de comandos |
| `react-native-camera` | Archivada y deprecada | `expo-camera` |
| `react-native-fs`, `realm`, `react-native-mmkv` | Módulos nativos fuera del SDK de Expo: violan la regla 2 | `expo-file-system`; SQLite cifrada pendiente |

#### Bloque C — Higiene

| Prohibited | Reason | Use Instead |
|---|---|---|
| `datetime.utcnow()`, `datetime.now()` sin tz, `pytz` | *Naive datetimes*. Con frecuencia **lunes–sábado** (D-02) la frontera del día decide si un pago atrasó | `datetime.now(timezone.utc)` + `zoneinfo`. UTC en almacenamiento, zona del tenant en presentación |
| `pandas` | Carga el dataset entero en memoria y **convierte `Decimal` a `float`**: corrompe el dinero de camino al reporte | Agregación en SQL + módulo `csv`; si hace falta, `polars` con decimales explícitos |
| `moment` | En modo mantenimiento por decisión del propio proyecto; ~300 KB y mutable | `date-fns` o `Intl.DateTimeFormat` |
| `lodash` completo (`import _ from 'lodash'`) | Arrastra la librería entera al bundle | Nativos; `lodash-es` con import por función |
| `psycopg2` en el camino de petición | Driver síncrono junto a `asyncpg`: dos pools y bloqueo del loop | `asyncpg`. **Excepción**: `psycopg` v3 en el entorno de Alembic |
| `lazy="select"` en relaciones SQLAlchemy async | Lanza `MissingGreenlet` en producción y no en tests | `lazy="raise"` + `selectinload` explícito |

#### No prohibido a propósito

- **Librerías de gráficas** — ninguna elegida (T9 fuera de alcance). Prohibir sin alternativa dejaría
  a AI-DLC sin salida. Hueco conocido.
- **Almacenamiento del JWT en navegador** — resuelto en §Security, no aquí.
- **`.env` en producción** — resuelto en §Secrets Management.

### Mobile Platform Constraints (vinculante)

Se fusiona aquí el documento `interview/technical/mobile-platform-constraints.md`, producido en T5 a
petición explícita del líder técnico. **Es restricción, no recomendación**: AI-DLC debe honrarla al
generar cualquier código móvil.

**Motivo**: Apple y Google **obligan a actualizar** — Apple exige compilar con un SDK de iOS
reciente para poder **subir actualizaciones**, y Google Play sube el `targetSdkVersion` mínimo cada
año. Incumplir no rompe la app instalada: **impide publicar correcciones**. En un sistema que lleva
la caja de una operación de cobranza, quedarse sin poder desplegar un arreglo es peor que la
actualización que se evitaba. El objetivo no es evitar actualizaciones sino que cada una cueste
**medio día en vez de dos semanas**.

1. **No versionar `ios/` ni `android/`** — van en `.gitignore` y se regeneran con `expo prebuild`.
   Con generación nativa continua, subir de SDK es cambiar un número; con esas carpetas versionadas
   y editadas, es resolver conflictos dentro de proyectos de Xcode y Gradle.
2. **Toda librería nativa debe estar en el SDK de Expo o publicar *config plugin* oficial.** Cada
   módulo nativo sin plugin es un impuesto que se paga en **cada** subida. Afecta directamente a:
   SQLite cifrada, cámara (C-42, C-44), GPS preciso (C-45, C-73), push (C-63) y **lector de QR
   (C-31, control antifraude nº 1)**.
3. **Instalar con `expo install`, nunca `npm install` a secas.** `npx expo-doctor` en CI. Nunca fijar
   a mano `react`, `react-native` ni `react-dom`.
4. **Versión del SDK exacta, sin `^`** — subir de SDK es siempre deliberado, nunca efecto secundario.
5. **Subir de SDK de una versión a la vez** — cada versión trae su guía de migración y su *codemod*.
6. **Pruebas de humo de los cuatro recorridos críticos**: entrar y cargar clientes del día ·
   registrar pago en efectivo **sin señal** verificando el contador fraccionario · registrar un
   "no pago" con motivo y compromiso · cerrar caja con los tres paneles en cero.

**Presupuesto de mantenimiento**: reservar **dos ventanas al año de ~3 días**. No es tiempo perdido:
es el precio de tener una app en dos tiendas, y se paga con Expo, sin Expo o con Flutter.

**Dependencia sin resolver**: todo esto presupone **distribución por las tiendas**, que sigue sin
confirmar (`V-49` del cuestionario v3, donde se advierte que Google Play restringe las apps de
préstamos, incluido el acceso a **fotos y ubicación precisa** que este sistema usa de forma
central). Si se resuelve por distribución gestionada, la regla 1 gana importancia pero la presión de
fechas se reduce.

---

## Cloud Services

**Región: `sa-east-1` (São Paulo) — restricción firme** (T11, 2026-08-02).

### Allow List

| Servicio | Restricciones / Notas |
|---|---|
| **ECS Fargate** | API FastAPI 24/7. Tareas en **subred privada, sin IP pública** |
| **RDS PostgreSQL** ≥ 17 | Base única: ledger, RLS, `JSONB`, cola de trabajos. Subred **aislada**, 5432 solo desde el SG de las tareas. **Aurora descartada** — ver Disallow List |
| **S3** | Fotos de identidad **cifradas y privadas**; bundle estático de la SPA |
| **CloudFront** | **Solo** el bundle estático de la SPA. **No sirve fotos de identidad** |
| **ALB** | **Única entrada desde internet.** Subred pública |
| **NAT Gateway** | **Uno solo, una AZ.** Salida a WhatsApp, Telegram, Sentry, FCM, Bedrock |
| **VPC Endpoint (Gateway) S3** | Gratuito. Saca el tráfico de fotos del NAT |
| **ECR** | Registro de imágenes |
| **Secrets Manager** | 3 secretos: contraseña PostgreSQL, clave de firma JWT, token de WhatsApp |
| **IAM (roles)** | Todo acceso AWS↔AWS. Sin credenciales almacenadas |
| **CloudWatch Logs** | ⚠️ **Retención 14 días · nunca `debug` en producción** ($0,90/GB en `sa-east-1`) |
| **CloudWatch Alarms** | 4–5: CPU y almacenamiento RDS, tareas ECS vivas, 5xx del ALB, profundidad de la cola |
| **Route 53** | DNS de API y panel |
| **SES** | Correo transaccional. ⚠️ Verificar disponibilidad en `sa-east-1`. Requiere DKIM+SPF+DMARC, salida de sandbox y manejo de rebotes |
| **SNS** | **Solo** el topic de rebotes/quejas de SES. **No** como cola de trabajos |
| **Bedrock** | ⚠️ **Condicional a `CX-30`** (¿la IA entra en v1?). Claude disponible en `sa-east-1` según el usuario, 2026-08-02 |

### Servicios externos (no AWS) en v1

| Servicio | Uso | Costo/mes |
|---|---|---:|
| **WhatsApp Cloud API** (Meta) | Los dos controles antifraude, hacia clientes (`CX-16`) | **~$212 — 61 % de la factura** |
| **Telegram Bot API** | Reportes a administradores (`CX-29`) | $0 |
| **Firebase Cloud Messaging** | Push a Android/iOS vía Expo | $0 |
| **Sentry** | Errores en producción: backend + web + móvil | $0–26 |
| **GitHub Actions** | Las dos puertas de T25 | $0 a esta escala |

### Disallow List

| Servicio | Motivo |
|---|---|
| **ElastiCache / Redis** · **SQS** · **EventBridge** | La cola vive en PostgreSQL (T8) |
| **Aurora PostgreSQL** | ~1,8× el costo de RDS en reposo ($91 contra $50 en `sa-east-1`); almacenamiento y E/S aparte. Replicación 6× en 3 AZ, failover rápido y hasta 15 réplicas **no se activan ni una vez** a <1 GB y 0,04 escrituras/s. *Excepción: Serverless v2 con auto-pausa a 0 ACU sí es atractivo para desarrollo y staging* |
| **App Runner** | **No existe en `sa-east-1`** (verificado) |
| **EKS · Lambda** | T3 |
| **Cognito** | La vinculación de dispositivo hay que escribirla igual (T17) |
| **AWS X-Ray** | Monolito de un solo servicio: no hay cadena que trazar. Sentry cubre el trazado de rendimiento, y el costo real es tiempo de instrumentación, no dólares |
| **Segundo NAT Gateway** | $68 adicionales por HA de AZ a 0,04 req/s |
| **NAT Instance** (`t4g.nano`) | Ahorra $65/mes a cambio de mantener un aparato de red — mal negocio con equipo de una persona (`CX-27`) |
| **VPC Endpoints de interfaz** (ECR/Secrets/Logs) | ~$22/mes y **no eliminan el NAT** |
| **API Gateway · malla de servicios · PrivateLink** | No hay microservicios |
| **Supabase · Fly.io · Cloudflare R2** | Superados por la elección de AWS en T2 |

### Arquitectura de red — **vinculante**

```
Internet
   |
   +-- CloudFront ------> S3 (bundle estatico de la SPA)
   |
   +-- ALB  [subred PUBLICA]  <- unica entrada desde internet
          |
          v
      ECS Fargate  [subred PRIVADA, sin IP publica]
          |                    |
          | 5432               +--> NAT Gateway [1 AZ] --> WhatsApp . Telegram . Sentry . FCM . Bedrock
          v                    +--> VPC Endpoint Gateway S3 (gratis)
      RDS PostgreSQL  [subred AISLADA, sin ruta a internet]
```

**RDS no atraviesa el NAT para hablar con ECS** — misma VPC, enrutamiento local; basta el *security
group*. El NAT existe **solo para salida a internet** desde la subred privada, que es lo que exigen
WhatsApp, Telegram, Sentry, FCM y Bedrock.

**Costo:** ~$210/mes (escenario A de `technical-research/infraestructura-aws.md` + NAT) → `OQ-N-45`.

### Entrega de fotos de identidad

**S3 privado + URL prefirmada de expiración corta (5–15 min)**, generada por la API tras comprobar
permisos. **Nunca CloudFront público**: sería un enlace permanente, compartible y sin autenticación a
un documento de identidad, y dejaría las fotos **fuera de la única frontera de aislamiento del
sistema**, porque la comprobación de tenant vive en la API que firma la URL.

**Regla operativa:** el móvil **debe** cachear las fotos localmente — re-descargarlas a diario
multiplica el egreso por 10 (~2 GB → ~20 GB/mes).

**Retención:** pendiente de T21 y `CX-11`. Estructura aceptada: activo → se conserva · cerrado →
Glacier Instant Retrieval a los 12 meses · borrado a los N años del cierre · **ledger nunca se borra**.

> 🔑 **Derecho al olvido contra ledger inmutable — ya resuelto por diseño.** La foto vive en S3 y la
> tabla guarda solo **referencia + hash** (T14). La imagen se puede borrar sin romper el ledger, que
> conserva la prueba de que el documento existió sin conservar el documento. **Esto debe respetarse
> al implementar**: guardar la foto en la base rompería la compatibilidad entre antifraude y LGPD.

---

## Architecture and Patterns

### API Style

**REST descrita con OpenAPI. Estilo único, sin mezcla** (T13).

FastAPI genera el contrato OpenAPI, y de él `openapi-typescript` deriva los tipos de TypeScript de
la web y del móvil: **un contrato, dos lenguajes, sin escritura manual**.

Descartados: **GraphQL** (resuelve escala organizativa inexistente aquí y complica la autorización
— en REST se protege un endpoint, en GraphQL campo por campo, superficie de riesgo añadida bajo
aislamiento multi-tenant); **gRPC** (los navegadores exigen proxy; no hay microservicios internos);
**orientada a eventos como API pública** (el gestor necesita respuesta inmediata — "quedó
registrado, saldo 150" — que un modelo de eventos puro no da; el mecanismo de eventos **interno** ya
existe en la cola de Postgres).

**La subida por lote NO es un segundo estilo**: `POST /sync/operaciones` con un cuerpo que es una
lista sigue siendo REST. El trabajo offline se resuelve con **REST + lote + idempotencia**.

**WebSocket / SSE deliberadamente no adoptados**: el tablero de C-83 se refresca por **sondeo**
(`refetchInterval` de TanStack Query). Con 30–40 usuarios basta y no añade infraestructura. Reabrir
si el requisito de tiempo real endurece.

Los **webhooks entrantes de WhatsApp** no cuentan como segundo estilo: son endpoints REST que este
sistema expone y Meta invoca.

### Data Patterns

> ⚠️ AI-propuesta / usuario-aprobada (T14).

**Relacional exclusivamente: una sola base de datos, PostgreSQL, para todo.**

| Patrón | Veredicto | Motivo |
|---|---|---|
| Relacional / SQL | **Núcleo** | Transacciones ACID, restricciones que sostienen la idempotencia, y **RLS como frontera de aislamiento** |
| Documental | **Como `JSONB`, no como base aparte** | Config por tenant, webhooks crudos de WhatsApp, snapshots de auditoría. Una segunda base reintroduce la doble escritura |
| Clave-valor | **No** | Es Redis; descartado en T8 |
| Índice de búsqueda | **No** | 1.200 clientes; `pg_trgm` cubre la búsqueda difusa. **Reconsiderar a cientos de miles** |
| Caché en memoria | **No** | Para el tablero pesado: **tabla resumen precalculada** por tarea periódica de Procrastinate. Vive en Postgres, se respalda, sobrevive reinicios y es auditable |
| Log de eventos | **Como patrón, no como Kafka** | Ver abajo |

#### Libro mayor solo-añadir (vinculante)

C-99 establece que la auditoría inmutable es la razón de ser del sistema. Traducción técnica:

- La tabla de movimientos **solo recibe `INSERT`**. Nunca `UPDATE`, nunca `DELETE`.
- Un pago mal registrado **no se corrige editando el renglón**: se añade un **movimiento de reversa**
  que lo compensa, y ambos quedan visibles.
- **El saldo es la suma de los movimientos**, no un número que alguien edita.
- Se impone con permisos de PostgreSQL sobre esa tabla.

Es lo que convierte al sistema en antifraude en vez de en un CRM de cobranza.

#### Almacenamiento de objetos

Las **fotos de documentos de identidad no van en la base de datos**: van a **S3 cifrado**; la tabla
guarda referencia y hash. Binarios en Postgres inflan los backups y encarecen cada consulta.

#### Idempotencia de operaciones offline (vinculante)

No es diseño de API sino **identificación de operaciones**. Seis piezas:

1. **Identificar** — UUID generado **en el teléfono** al registrar la operación offline. Que lo
   genere el móvil es lo que hace reconocible el reintento como *la misma* operación.
2. **Encolar localmente** — `pendiente → enviada → confirmada` en la SQLite del dispositivo. **Solo
   se borra al confirmar el servidor.** Sobrevive a cierre de app y batería agotada.
3. **Rechazar el duplicado en la base, no en el código** — `UNIQUE (tenant_id,
   client_operation_id)` dentro de **la misma transacción** que aplica el pago. Un `if ya_existe:`
   en Python deja pasar dos peticiones simultáneas; la restricción no.
4. **Devolver la respuesta guardada** — no basta con "ya lo tenía": hay que devolver **la misma
   respuesta de la primera vez**, que el teléfono necesita para actualizar su pantalla.
5. **Resultado por operación, no por lote** — el lote **no es atómico**; cada operación sí. Devuelve
   un array de resultados. Todo-o-nada tumbaría la mañana entera de un gestor por una sola operación
   inválida.
6. **Dos relojes** — la operación viaja con la hora del **teléfono**, que puede estar **manipulada a
   propósito**: es un sistema antifraude y el gestor controla su dispositivo. El servidor guarda
   `ocurrido_en` (dispositivo, informativo) y `recibido_en` (servidor, confiable). **Divergencia
   grande = señal de auditoría**, no error a corregir en silencio.

#### Motor de sincronización offline: cola de comandos propia (vinculante)

**WatermelonDB, PowerSync y ElectricSQL rechazados.** No por madurez ni precio: **replican estado**,
y este sistema debe transmitir **intenciones que el servidor valida**.

- **El móvil no debe escribir en el libro mayor.** El teléfono manda una intención; el servidor
  decide si es válida (¿préstamo activo?, ¿caja abierta?, ¿venta aprobada?). Un motor de replicación
  deja que el dispositivo escriba directamente: eso convierte al gestor en **autor del registro
  contable en vez de sujeto auditado**.
- **"Gana la última escritura" es catastrófico con dinero**: si el servidor aplicó una reversa y el
  teléfono llega tarde con estado viejo, **el dinero reaparece**.
- **La necesidad no es simétrica**: bajada = ruta del día (pequeña, solo lectura); subida = lista
  ordenada de operaciones. Es una cola, no una replicación bidireccional.

**Reglas de orden:**

- **Orden por agregado, no global.** Cada operación lleva número de secuencia del dispositivo, pero
  el orden es obligatorio **solo entre operaciones que tocan el mismo préstamo o la misma caja**.
  Crítico porque el **contador fraccionado de cuotas (D-02) depende de la secuencia**.
- **Un rechazo no bloquea la cola** — solo esperan las operaciones sobre el mismo préstamo. El
  gestor ve en su teléfono cuáles quedaron pendientes y por qué.

**Escenarios de prueba obligatorios**: modo avión toda la mañana · app cerrada por el sistema a
media subida · **cambio manual del reloj del teléfono** · subida duplicada por corte de red ·
operaciones que llegan desordenadas.

### Messaging / Integration

**No declarado formalmente** — T15 quedó fuera del Quick pass. Lo que sí queda fijado:

- Comunicación cliente↔servidor: **síncrona REST**.
- Trabajo diferido interno: **cola en PostgreSQL vía Procrastinate**, encolada en la misma
  transacción que el hecho de negocio.
- Tareas periódicas (p. ej. recalcular la tabla resumen del tablero): **tareas periódicas de
  Procrastinate**, no un segundo planificador. EventBridge Scheduler evaluado y descartado — no
  puede alcanzar un navegador, y como planificador de backend duplicaría lo que Procrastinate ya
  hace.

### Project Structure

**Monorepo** (T16, 2026-08-02) con **versionamiento independiente por etiquetas**.

```
tripri/
├── backend/     # FastAPI · SQLAlchemy · Alembic · Procrastinate
├── web/         # React 19 · Vite · TanStack Query · Tailwind + shadcn/ui
├── mobile/      # React Native · Expo · Expo Router · SQLite cifrada
├── infra/       # Terraform
├── contracts/   # openapi.json generado + tipos derivados
└── .github/workflows/
```

| Necesidad | Mecanismo |
|---|---|
| Versionamiento independiente por componente | **Etiquetas con espacio de nombres**: `mobile-v1.4.2`, `backend-v2.1.0` |
| CI que no dispare todo por cualquier cambio | **Filtros de ruta** en GitHub Actions (`paths: backend/**`) |
| Despliegue a producción y develop | Por **etiqueta y entorno** |
| Infra con radio de impacto distinto | `infra/` con revisión obligatoria y credenciales propias en CI |

**Multi-repo descartado tras revisión.** El motivo determinante es que **la puerta de compatibilidad
de contrato de T25 solo protege lo que la justifica si el cambio rompedor y su corrección en los
clientes viajan en el mismo commit** — repartidos en repos, la CI del backend no ve a los clientes, y
lo que esa puerta existe para proteger son **las apps ya instaladas en los teléfonos de los
cobradores**. Segundo motivo: una rama del mismo nombre en varios repos es coordinación sin
coordinador — nada impide desplegar un par incompatible.

**Revisar esta decisión si**: equipos u organizaciones distintas pasan a poseer cada pieza con
control de acceso separado · el móvil debe liberarse como código abierto · un cliente exige el
repositorio del backend por separado como entregable contractual. Partir un monorepo es la operación
fácil (`git filter-repo`); unir repos conservando historial, no.

**Herramienta de infraestructura como código: Terraform** (T16 / T29).

### Patrón arquitectónico del backend — **vinculante**

**Monolito modular · rebanadas verticales · hexagonal acotado por módulo · núcleo funcional.**

**Idioma del código: inglés** (`OQ-T-24`) — ver el glosario vinculante más abajo.

```
backend/src/
├── payments/         # router . service . domain . repository . models
├── loans/            # los mismos 5 archivos
├── cash_box/         # los mismos 5 archivos
├── clients/
├── sync/             # cola de comandos offline (patron Command, T14)
├── auth/             # JWT propio + vinculacion de dispositivo (T17)
├── ports/            # enchufes COMPARTIDOS
│   └── clock.py . messaging.py . storage.py . push.py . ai.py
├── adapters/         # implementaciones reales + falsas para pruebas
│   └── system_clock.py . whatsapp_cloud.py . telegram_bot.py
│       s3_storage.py . fcm_push.py . bedrock_ai.py . fake_*.py
└── shared/           # db . config . errors . tenant . money (envuelve Decimal)
```

| Archivo del módulo | Responsabilidad |
|---|---|
| `router.py` | Recibe y valida lo que llega de fuera (FastAPI + Pydantic) |
| `service.py` | Orquesta los pasos. **Cáscara imperativa** |
| `domain.py` | **Núcleo funcional.** Interés, imputación, contador fraccionario. **Sin base de datos, sin red, sin reloj** |
| `repository.py` | **El único que toca la sesión** en ese módulo |
| `models.py` | Tablas SQLAlchemy |

**Reglas vinculantes:**

1. **Un puerto por cada cosa que podría cambiar de verdad o que estorba en las pruebas.** Lista
   **cerrada, seis**: reloj (T22), mensajería (`CX-16` + `CX-29` — ya cambió dos veces), archivos
   (S3), IA (`CX-30`), repositorio, push (FCM). **Todo lo demás va directo, sin interfaz.**
2. **`ports/` no importa librerías externas ni contiene lógica.** Si importa `boto3` o `httpx`, está
   mal ubicado.
3. **El repositorio no se comparte** — vive dentro de cada módulo. Regla general: *un puerto vive
   donde están los que lo usan*.
4. **`shared/` entra por uso, no por previsión**: algo entra cuando **ya** lo usan dos módulos o más.
5. **`shared/dinero.py`** envuelve `Decimal` para que la prohibición de `float` (T10) sea difícil de
   romper por accidente.

⚠️ **Hexagonal aplica SOLO a `backend/`.** La raíz del monorepo no tiene arquitectura, tiene
proyectos. **`web/` y `mobile/` se organizan por pantallas y componentes** — no se les aplica este
patrón.

**Alcance de lo que compra:** los puertos dan flexibilidad para **cambiar infraestructura**, no para
cambiar reglas de negocio ni para escalar. Eso lo dan las rebanadas verticales y el núcleo funcional.

**Descartados:** Clean Architecture completa (DTOs y mappers: ceremonia sin beneficio con equipo de
una persona) · DDD táctico completo (se toma prestado lo útil: `pagos/` es un agregado, `Dinero` es
un objeto de valor) · CQRS (la tabla de resumen precalculado de T14 ya es el único trozo necesario) ·
Event Sourcing completo (**ya se usa acotado al dinero** vía el ledger append-only de T14; extenderlo
sería pagar el costo sin la razón).

### Idioma del código y glosario de dominio — **vinculante**

**Todo en inglés** (`OQ-T-24`, 2026-08-02): código, tablas, API, variables y nombres de dominio.

Como el riesgo de esta opción es la **ambigüedad de traducción en un sistema que debe ser exacto**, el
glosario es obligatorio: **un término del negocio ↔ un único término en el código**. Sin él, el mismo
concepto aparecería como `fee`, `quota` e `installment` en tres módulos distintos.

| Español (negocio / cliente) | Inglés (código, tablas, API) | Nota |
|---|---|---|
| préstamo | `loan` | |
| cuota | `installment` | grafía estadounidense, una sola en todo el código |
| contador fraccionario de cuota | `fractional_installment_counter` | `D-02` |
| caja | `cash_box` | ni *till* ni *cash_register* |
| cierre de caja | `cash_box_closing` | |
| movimiento del ledger | `ledger_entry` | **no** `movement` — es un asiento |
| asiento compensatorio | `reversal_entry` | T14 |
| cobrador / gestor | `collector` | |
| ruta | `route` | |
| cliente (deudor) | `client` | **no** `customer` — el `customer` es el tenant que paga la suscripción |
| tenant (empresa suscrita) | `tenant` | |
| socio | `partner` | destinatario de reportes (`C-81`) |
| mora | `arrears` | |
| abono / pago | `payment` | |
| imputación de pago | `payment_allocation` | |
| venta (aprobación en 4 pasos) | `sale` | ⚠️ verificar — en `D-02` describe el desembolso de un préstamo nuevo |
| desembolso | `disbursement` | |
| interés fijo sobre capital | `flat_interest_on_principal` | `D-02` |
| renovación | `renewal` | `C-28` |

⚠️ **Cuatro términos por confirmar antes de escribir código**: `sale` (¿venta o desembolso?),
`client` contra `customer` (la distinción deudor/suscriptor debe ser inequívoca por `D-01`),
`partner` (¿socio inversor o comercial?), y si `collector` cubre a la vez "cobrador" y "gestor" o son
dos roles distintos.

---

## Security

### Authentication

**JWT emitido por servicio propio** (T17, opción B), con **vinculación de dispositivo por par de
claves**.

Cognito / Auth0 descartados: **la vinculación de dispositivo hay que escribirla en los dos casos**
—ningún proveedor la trae hecha— y engancharla a Cognito exigiría disparadores Lambda, más
superficie que depurar. **Coste asumido**: almacenamiento de contraseñas, recuperación, bloqueo por
intentos y caducidad de sesiones se mantienen en casa.

**Dos mecanismos separados** (la confusión entre ambos es el error habitual):

| Mecanismo | Qué hace | Cuándo |
|---|---|---|
| **Desbloqueo local** — PIN o biometría (`expo-local-authentication`) | **Descifra la SQLite local.** No valida nada contra el servidor | Al abrir la app, **sin red** |
| **Autenticación de servidor** — firma del dispositivo | El teléfono **firma un desafío** con la clave privada del Keystore; el servidor verifica contra la pública registrada y emite un **token de acceso corto** | Al sincronizar |

**El par de claves del dispositivo sustituye al token de renovación.** Consecuencias: **no hay
credencial persistente robable en el teléfono** (la privada nunca sale del almacén seguro del
sistema operativo); **revocar un dispositivo es borrar su clave pública**, con efecto inmediato
(cubre parte de C-71); y **la contraseña se pide al dar de alta el dispositivo y luego
periódicamente con conexión**, no cada mañana — satisface el requisito del cliente sin bloquear el
trabajo de campo.

**Regla innegociable**: el token contiene usuario, `tenant_id`, dispositivo, rol y caducidad, y **el
`tenant_id` se toma siempre del token verificado, jamás de una cabecera o del cuerpo de la
petición**. Es el valor que alimenta el RLS: si el cliente pudiera influir en él, el aislamiento
entre financieras se cae entero.

**Web**: token en cookie **`httpOnly`, `Secure`, `SameSite`** — **nunca `localStorage`**, legible por
cualquier XSS.

**Firma**: **HS256 con `PyJWT`**. Un solo servicio emite y valida.

**Rotación con solapamiento**: sustituir la clave de golpe **invalida todos los tokens emitidos y
expulsa a todos los usuarios a la vez** — para un gestor a media ruta, su sincronización falla sin
explicación. El servidor firma con la nueva y **sigue aceptando la vieja** durante una ventana de
gracia, distinguiéndolas por el campo `kid`. **Esa lógica se escribe en casa**; la rotación
automática no la regala.

> ⚠️ **`CX-26` (P0)**: el requisito del cliente *"vincular el usuario a la IP del celular"* **no es
> implementable** — con CGNAT miles de abonados comparten IP, cambia varias veces por ruta, **no
> existe offline** (que es cuando se crean las operaciones) y un VPN la cambia en segundos. IMEI
> tampoco: Android lo bloqueó desde la v10 e iOS nunca lo expuso. Lo descrito es **vinculación de
> dispositivo**, ya presente como **C-70**. La IP se conserva **como metadato de auditoría**, nunca
> como control de acceso. Pendiente que el cliente confirme la traducción y **decida el flujo de
> reautorización**: reinstalar la app destruye la clave, lo cual es la propiedad deseada, pero sin
> ese flujo un teléfono roto en sábado deja al gestor sin trabajar.

### Encryption

**A · Todo cifrado en reposo Y en tránsito** (T18, 2026-08-02).

| Elemento | Estado |
|---|---|
| **RDS** | Cifrado con **KMS**. ⚠️ **Debe activarse al crear la instancia** — AWS no permite activarlo después sin recrearla y migrar. Paso irreversible del `terraform apply` inicial → debe estar en el fragmento canónico de T29 |
| **Copias de seguridad y snapshots** | Cifrados; heredan la clave de la instancia. Se declara explícito |
| **ECS ↔ RDS** | **`sslmode=require`** en la cadena de conexión. **No es automático**: sin esta opción el tráfico va en claro **dentro de la VPC**. Es lo que más se olvida al declarar "todo cifrado en tránsito" |
| **TLS público** (ALB) | **Solo 1.3** (T31, 2026-08-07) — política `ELBSecurityPolicy-TLS13-1-3-*`. **Sin cambiar la política, el ALB sigue aceptando 1.2 y la decisión no existe** |
| **TLS público** (CloudFront) | ⚠️ **Suelo 1.2 — CloudFront no admite solo-1.3.** Su versión mínima más alta admite 1.2 junto a 1.3. Inofensivo (solo sirve el bundle estático de la SPA, público y sin datos) pero **queda escrito para que nadie lo lea como incumplimiento ni intente "arreglarlo"** |
| **S3** | Cifrado. Fotos de identidad privadas, servidas por URL prefirmada (T11) |
| **SQLite del dispositivo** | Cifrada — obligatoria. **`op-sqlite` + SQLCipher**, base entera, clave en `expo-secure-store` (T30, 2026-08-07). Ver abajo |
| **Clave privada del dispositivo** | Keychain / Keystore, sin salir nunca (T17) |
| **Sesión web** | Cookie `httpOnly` + `Secure` + `SameSite`, nunca `localStorage` (T17) |

> ✅ **El supuesto sobre TLS quedó resuelto el 2026-08-07.** T18 había fijado *"1.2 mínimo"* como
> **asunción declarada**, no como respuesta, porque no se conocían los modelos de teléfono. **T31 los
> acotó** (Android 10+ / iOS 13+) apoyándose en un hecho ya registrado: `V-36` y `C-70` dicen que
> **el teléfono lo asigna la empresa** — el parque se compra, no es BYOD. **TLS 1.3 pasa a ser
> obligatorio en el ALB.**

> ✅ **La librería de SQLite cifrada quedó decidida el 2026-08-07 (T30): `op-sqlite` + SQLCipher**,
> base entera cifrada, clave en `expo-secure-store`. ⚠️ **Propuesta por la IA, aprobada por el
> usuario.** El argumento que decidió: **T17 ya había comprometido** que *"el desbloqueo local (PIN o
> biometría) descifra la SQLite local"* — y el cifrado por campo sobre `expo-sqlite` **no puede
> cumplir esa frase**, porque no existe *la* SQLite que descifrar, solo campos sueltos. Se rechazó
> además porque **funciona solo mientras todos se acuerden**: cada columna nueva sin cifrar es PII en
> claro en un teléfono y **ninguna prueba lo detecta** — inaceptable con `CX-27` y código generado.
> La objeción de la **regla 2** (preferir el SDK de Expo) **ya estaba pagada**: el par de claves de
> dispositivo, el lector de QR, el GPS preciso y FCM **ya obligan a un *development build***, así que
> Expo Go era imposible de todas formas.
>
> ⚠️ **Verificación obligatoria al montar el proyecto, antes de la primera migración**: que
> `op-sqlite` publique **config plugin oficial vigente** para el SDK de Expo que se fije, y **bajo
> qué condiciones de licencia expone SQLCipher**. Si cualquiera falla → plan B: `expo-sqlite` con
> cifrado a nivel de aplicación y **lista cerrada de campos sensibles por escrito**.
> `react-native-quick-sqlite` **no** es alternativa: está descontinuado, es el predecesor de
> `op-sqlite`.
>
> **Tres trampas vinculantes que acompañan a la decisión:**
> 1. 🔴 **El PIN no deriva la clave, la desbloquea.** Un PIN de 4 dígitos (`V-18`) son 10.000
>    combinaciones: derivar de él la clave de la base la rompe fuera de línea en segundos. Correcto:
>    **clave aleatoria de 256 bits generada en el dispositivo**, en Keystore/Keychain vía
>    `expo-secure-store`; el PIN o la biometría **gobiernan el acceso a la clave**, no su contenido.
> 2. **Excluir base y clave de las copias del sistema** — `allowBackup=false` (Android), exclusión de
>    iCloud (iOS), elemento del llavero con `WHEN_UNLOCKED_THIS_DEVICE_ONLY`. Si no, la base cifrada
>    y su clave salen del teléfono por la puerta de atrás.
> 3. **Borrar la clave *es* el borrado remoto de `C-71`** — la base queda ilegible al instante sin
>    que el teléfono coopere. Debe quedar escrito **antes** de que alguien construya un borrado
>    "de verdad".

**Cruce con T21:** al ser **A** el nivel máximo de la pregunta, si T21 resuelve LGPD el cifrado pasa
de buena práctica a exigible **sin cambiar ninguna decisión**. La regla de validación del banco
(T18 debe alinearse con T21) se cumple por construcción.

> 🔴 **IMPACTO PENDIENTE DE `D-05` (2026-08-08) — `CX-40`, P0.** El cliente declaró que el
> administrador principal *"asigna permisos sobre los recursos para los demás usuarios"* y **crea
> administradores secundarios**. Eso convierte a T17 de **servicio de autenticación propio** en
> servicio de **autenticación y autorización**, con permisos configurables **por tenant**.
> Lo que ya está decidido **no se cae**: `tenant_id` sigue viniendo del token verificado y RLS sigue
> siendo la frontera **entre** tenants. Lo que falta es la capa de autorización **dentro** de un
> tenant, que RLS no cubre y hoy **no está diseñada ni presupuestada**.
> **No implementar hasta que `B-13` decida** entre *roles fijos con excepciones puntuales* y *matriz
> completa de permisos por recurso*: entre una y otra hay un `if` y un módulo entero, y `CX-27` sigue
> diciendo que el equipo es una persona.

> ✅ **`CX-26` cerrada por `D-05` — el flujo de alta de dispositivo queda especificado y coincide con
> el diseño de T17 sin cambiarlo**: la app genera un **PIN que muestra el modelo del dispositivo**
> (viable vía `expo-device`; es dato declarado por el aparato, **útil para que un humano lo
> reconozca, no prueba criptográfica**), el **administrador aprueba** —el "evento de auditoría con
> aprobación explícita" que T17 exigía—, y **el sistema genera la contraseña**, lo que además evita
> contraseñas débiles elegidas por un usuario con poca soltura técnica (`C-106`). El administrador
> **vincula y desvincula**; revocar = borrar la clave pública, con efecto inmediato **y** dejando
> ilegible la SQLite local (T30). **Un solo usuario por móvil**: la vinculación es 1:1 estricta en
> ambas direcciones (`C-37`, `C-70`).
> ⚠️ **Sube la urgencia de `OQ-F-99` (P0)**: desvincular deja de ser excepcional y pasa a ser acción
> ordinaria de administración, así que *"qué pasa con las operaciones sin sincronizar de un
> dispositivo revocado"* pasa de caso raro a caso rutinario. Detalle operativo pendiente en
> `OQ-F-107` — **el PIN debe caducar**: un código de enrolamiento sin vencimiento es una credencial
> permanente.

### Input Validation

**Validación por esquema en el borde** — resuelta de facto por T8 aunque T19 quedara fuera de
alcance: **Pydantic v2** en el servidor y **Zod** en el cliente, derivado del mismo contrato
OpenAPI. Es especialmente crítico recibiendo lotes de operaciones desde ~40 dispositivos.

### Secrets Management

**AWS Secrets Manager para todo secreto**, sin dividir con Parameter Store (T20).

- La **configuración no sensible** (nivel de log, región, banderas, URLs) queda como **variables de
  entorno normales**. Regla: *al almacén de secretos va lo que, filtrado, compromete el sistema*. Si
  todo se trata como crítico, nada recibe la atención debida.
- Acceso desde ECS Fargate **mediante rol de IAM**, sin credenciales almacenadas.
- **AWS↔AWS siempre por roles de IAM.** El backend escribiendo en S3 no necesita ningún secreto.
  **El secreto más seguro es el que no existe**: reducir el inventario primero deja solo tres —
  contraseña de PostgreSQL, clave de firma de JWT, token de la API de WhatsApp.
- **Rotación automática activada para la contraseña de PostgreSQL** (AWS trae la función escrita
  para RDS). El resto, rotación manual programada.
- **La clave de firma de JWT se consulta en tiempo de ejecución con caché corta, no se inyecta al
  arrancar.** ECS inyecta secretos al iniciar el contenedor; un secreto rotado no alcanza a un
  contenedor en marcha hasta el siguiente despliegue — aceptable para la base de datos, **no** para
  la clave de firma, cuyo solapamiento debe funcionar sin reiniciar nada.
- **No se dividió con Parameter Store por uniformidad, no por coste** (~4 USD/mes es irrelevante):
  dos almacenes son dos modelos mentales, dos conjuntos de permisos IAM y dos sitios donde mirar
  cuando algo no arranca a las siete de la mañana.

> ⚠️ **Aviso operativo**: al borrar un secreto, AWS **retiene el nombre entre 7 y 30 días** y no
> permite recrearlo. Bloquea el ciclo levantar/destruir entornos con infraestructura como código.
> Existe borrado forzado sin recuperación — **hay que saberlo de antemano**.

### Compliance

**ISO 27001 + LGPD** (T21, 2026-08-02).

#### Alcance de ISO 27001 — **alineado, no certificado** (T33, 2026-08-07)

✅ **Cierra `CX-31` (P0), `CX-38` y `OQ-N-46`.** Lo decidió `CX-38`, que no existía cuando se abrió
`CX-31`: **`V-53` dice que el cliente no prevé que nadie le exija el certificado** (*"nuestros
clientes son empresas pequeñas"*). Sin comprador, certificar es un proyecto organizativo de meses
sin comprador. Y la diferencia práctica es justo la que hacía irresoluble `CX-31`: **un estándar
usado como guía de diseño admite excepciones documentadas; una certificación auditada, no.**

> **Excepción declarada:** **A.5.3 —segregación de funciones— NO se cumple.** El equipo es una
> persona (`CX-27`): la misma escribe el código de la caja, lo aprueba, lo despliega y opera
> producción. Se declara por escrito aquí, que es el equivalente a una Declaración de Aplicabilidad.

**Cuatro controles compensatorios, vinculantes:**

| # | Control | Por qué |
|---|---|---|
| 1 | **La puerta de revisión de código de T25 se reescribe**: deja de significar aprobación humana y pasa a **análisis estático obligatorio (Ruff + Bandit) + lista de comprobación marcada en el PR** | La puerta sigue existiendo y sigue bloqueando; cambia **quién** la satisface. Tal como estaba escrita era incumplible |
| 2 | 🔴 **Aprobación del cliente para cambios en módulos de dinero** (`payments/`, `cash_box/`, `ledger`) | **El único control que produce segregación real**, porque quien aprueba es otra persona. Es lo que evita que esto sea papeleo |
| 3 | 🔴 **No se despliega desde el portátil. Nunca.** Solo desde CI, por etiqueta | **Sostiene a los otros tres.** Si el desarrollador puede desplegar desde su máquina, el registro inmutable no registra nada y el control 2 se salta sin dejar rastro. Si solo uno sobrevive a la prisa, tiene que ser éste |
| 4 | **Acceso a producción auditado y sin permanencia** — sin acceso humano estable a la RDS; entrada de emergencia por rol de IAM, con CloudTrail y **alarma al usarlo** | Un acceso de emergencia que no avisa a nadie es un acceso normal con otro nombre |

**LGPD no se ve afectada por esta decisión** — es obligatoria por ley, no por exigencia de cliente,
y sigue íntegra con todo lo registrado abajo.

> 🔴 **REQUISITO PREVIO AL DESARROLLO — instrucción explícita del usuario.**
> **Antes de escribir el primer módulo, el desarrollador debe formarse en ISO 27001 y LGPD.**
> No es una recomendación: es una condición de entrada. Con equipo de una persona (`CX-27`) **no hay
> nadie más que aporte ese conocimiento**, y ambas normas condicionan decisiones de diseño caras de
> revertir: retención, base legal, exportación de datos y registro de accesos. **AI-DLC debe tratar
> esto como precondición del Requirements Analysis.**

#### Efecto sobre `CX-11`

Declarar LGPD **presupone Brasil** y elimina la incertidumbre sobre *qué marco aplica*, pero **no
cierra `CX-11`**: siguen sin declararse **moneda** e **idioma de interfaz**. Refuerza `sa-east-1`
(T11): LGPD no exige residencia estricta, pero la transferencia internacional requiere salvaguardas,
y no transferir sale más barato que documentarlas — lo que también respalda usar Bedrock en São Paulo
si `CX-30` devuelve la IA al alcance.

#### Ya cubierto por decisiones anteriores

| Exigencia | Estado | Origen |
|---|---|---|
| Cifrado en reposo y en tránsito | ✅ Nivel máximo | T18 = A |
| Trazabilidad y no repudio | ✅ Por encima de lo exigido | T14 ledger append-only · `C-99` |
| Derecho de eliminación contra ledger inmutable | ✅ Resuelto por diseño | T14 (S3 + referencia y hash) |
| Control de acceso e identificación | ✅ | T17 |
| Aislamiento entre tenants | ✅ | RLS · `tenant_id` desde el token verificado |
| Gestión de secretos | ✅ | T20 |
| Desarrollo seguro | ✅ | T25 (SAST · DAST · escaneo de dependencias) |
| Registro y monitorización | 🟡 Parcial | CloudWatch (T11) — falta **detección** de incidentes |

#### Añadido por estas normas, y no estaba en ningún requisito

| Requisito | Norma | Referencia |
|---|---|---|
| **Exportación de datos de un titular** | LGPD art. 18 | 🔴 `OQ-F-100` — **funcionalidad inexistente hasta hoy** |
| Base legal del tratamiento | LGPD art. 7 | Decisión legal, no técnica |
| Encarregado / DPO designado | LGPD art. 41 | Rol organizativo — **no lo ocupa el desarrollador** |
| Notificación de brechas a la ANPD | LGPD art. 48 | `OQ-N-47` — exige **capacidad de detección** |
| Política de retención documentada | Ambas | Cierra el hueco de `OQ-T-13` |
| Inventario de activos | ISO A.5.9 | Documental |
| **Evaluación de riesgo de proveedores** | ISO A.5.19–A.5.22 | **Seis terceros sin evaluar**: AWS, Meta/WhatsApp, Telegram, Sentry, Google/FCM, Expo |
| Plan de respuesta a incidentes | ISO A.5.24–A.5.28 | Sin declarar |
| Revisión periódica de accesos | ISO A.5.18 | Sin declarar |
| Continuidad y recuperación | ISO A.5.29–A.5.30 | Parcial: hay copias, no hay plan probado |

#### ⚠️ Dos cuestiones abiertas que decide esta sección

**`OQ-N-46` — ¿ISO "alineado" o ISO "certificado"?** Usar el Anexo A como lista de control es trabajo
de ingeniería y buena parte ya está hecha. Certificarse es un proyecto organizativo de meses con
auditoría externa. **No se declaró cuál.**

**`CX-31` (P0) — ISO 27001 A.5.3 exige segregación de funciones, y T25 fijó "revisión de código
aprobada" como puerta bloqueante de fusión. Con un solo desarrollador no hay revisor.** La misma
persona escribe el código de la caja, lo aprueba, lo despliega y opera producción — justo lo que ese
control existe para impedir, **en un producto cuya razón de ser es el antifraude**. **La puerta de
T25 no puede cumplirse tal como está escrita.**

---

## Testing

### Test Types

**Los seis tipos son obligatorios** (T22). Posición declarada por el usuario: *el sistema debe ser
altamente testeable*.

| Tipo | Estado | Nota |
|---|---|---|
| **Unitarias** | Obligatorio | El cálculo de dinero es el caso ideal: reglas aritméticas exactas |
| **Integración** | Obligatorio | **Contra un PostgreSQL real.** RLS, transacciones y la restricción de unicidad **solo existen en Postgres** |
| **Contrato** | Obligatorio | Justificación no habitual: **la app se distribuye por las tiendas**, así que versiones viejas siguen instaladas semanas. La API debe seguir siendo compatible con lo que está en la calle, y **ninguna otra prueba detecta romper eso** |
| **Extremo a extremo** | Obligatorio, **acotado** | ✅ **Lista cerrada por diseño, exactamente tres** (T24): pago offline + sincronización · cierre de caja a cero pendiente · aprobación de venta en 4 pasos con QR. Tres flujos intocables valen más que veinte que nadie mira |
| **Rendimiento** | Obligatorio, **sigue sin ser ejecutable** | **No hay objetivo declarado** (`OQ-N-44`, T34 **no respondida**). Una prueba que no puede fallar no es una prueba. Agravado por `CX-39`: sin staging, k6 solo puede correr en local |
| **Seguridad (SAST/DAST)** | Obligatorio | Incluye escaneo de dependencias |

#### "Altamente testeable" traducido a restricciones de diseño (vinculantes)

1. **El cálculo de dinero va en funciones puras.** Interés, amortización y contador fraccionado no
   tocan base de datos, ni red, ni reloj.
2. **El reloj se inyecta, no se invoca.** Si el código llama a la hora del sistema no se puede probar
   la mora, ni el cierre del día, ni la frecuencia lunes–sábado sin cambiar la hora de la máquina.
   Refuerza la prohibición de `datetime.utcnow()`.
3. **Las pruebas de integración necesitan un PostgreSQL real.** Simular la base no sirve.
4. **La cola de comandos del móvil se escribe separada de React Native**, para que los cinco
   escenarios offline sean pruebas normales y no ejecuciones en emulador.

Se cruza con la **regla 6** de §Mobile Platform Constraints (cuatro pruebas de humo móviles).

### Entornos y datos de prueba (T32, 2026-08-07)

Cierra `OQ-T-21`. **Coste adicional: $0** — la infraestructura se queda en el escenario A más el NAT
de T11. No mueve `OQ-N-45`, que sigue abierta y sigue dependiendo de **`OQ-N-40` (presupuesto
mensual, nunca declarado)**.

| Entorno | Qué es |
|---|---|
| **Producción** | Único entorno desplegado en AWS |
| **Local** | Docker Compose: backend + PostgreSQL + base sembrada. **Aquí corre la puerta lenta entera** |
| ~~Staging~~ | **No existe.** Evaluado bajo demanda (~+$20/mes) y permanente compartido (~+$40–50/mes); ambos descartados |

**Datos**: **generador sintético** (día 1) **+ copia anonimizada de producción** (capacidad futura).

> 🔴 **`CX-39` — la puerta lenta de T25 se queda sin ambiente.** T25 hizo **E2E + rendimiento + DAST
> bloqueantes del despliegue** y T24 nombró las herramientas; sin staging solo quedan el portátil o
> producción, y **ZAP contra producción no es una opción**. Es la misma forma que `CX-31`: una puerta
> incumplible tal como está escrita.
> **Mitigación acordada dentro de la decisión**: la puerta lenta corre contra la **pila local
> completa** — Playwright contra el Compose, Maestro sobre un *development build* apuntando a
> `localhost`, ZAP contra el backend local. Ejecutable por una persona y sin coste.
> ⚠️ **Lo que la mitigación NO da es un número de rendimiento válido**: sin ALB, sin NAT y sin la
> latencia de RDS en `sa-east-1`, **k6 en un portátil no mide producción**. Sí detecta lo que de
> verdad rompe a un equipo de una persona: **regresiones algorítmicas** — consultas N+1, índices que
> faltan, consultas que crecen con el número de tenants.

> 🔴 **Trampa de LGPD en la copia anonimizada.** Hoy **no existe producción que copiar** (greenfield):
> el día 1 es solo generador sintético. Y una copia que conserve **importes, fechas y forma de ruta
> es reidentificable** en un conjunto de ~2.000 clientes — eso no es anonimización sino
> **seudonimización**, que bajo LGPD **sigue siendo dato personal** (art. 13), con las mismas
> obligaciones que producción.
> **Regla vinculante: jamás un `pg_dump` de producción a una máquina local.** Si se hace, la
> transformación **se ejecuta dentro de AWS** y solo sale el resultado ya transformado.
> **Camino recomendado que honra ambas opciones sin mover un dato personal**: extraer de producción
> **parámetros estadísticos** (nº de filas, distribución de importes, tamaño de ruta, tasa de mora) y
> alimentar con ellos al generador sintético. Ventaja adicional: **el generador se escala a 10× para
> pruebas de carga**; una copia real está fijada al tamaño real.

### Coverage Targets

**No declarados** — T23 quedó fuera del Quick pass (`OQ-T-19`, parcial). Observación que sigue en
pie y ahora es más exigible, porque T22 puso la matemática financiera en funciones puras: **el
cálculo de dinero debería exigir cobertura alta**.

### Tooling

| Tipo de prueba | Herramienta | Fase |
|---|---|---|
| Unitaria — backend | **pytest** | **1** |
| Unitaria — web y móvil | **Vitest** (nativo de Vite) | **1** |
| Integración | **pytest + Testcontainers** — T22 exige PostgreSQL real: RLS, transacciones y la restricción de unicidad de idempotencia no existen en otro sitio | **1** |
| Contrato | **`oasdiff`** — compara el OpenAPI del cambio contra el publicado. **Deliberadamente no Pact**: no hay consumidores independientes, hay un esquema publicado | **1** |
| SAST + dependencias | **Ruff · Bandit · `pip-audit` · `npm audit` · Trivy** — Trivy cubre también el **Terraform** | **1** |
| E2E web | **Playwright** | 2 |
| E2E móvil | **Maestro** — pensado para React Native, menos frágil que Detox | 2 |
| Rendimiento | **k6** — ⚠️ no ejecutable hasta que `OQ-N-44` fije un objetivo | 2 |
| DAST | **OWASP ZAP** | 2 |

**Escalonamiento (T24).** **Fase 1 = las cuatro de la puerta rápida de T25**, desde el primer commit.
**Fase 2 = cuando existan flujos que probar.** Los seis tipos de T22 siguen siendo **obligatorios**;
esto ordena cuándo aparece cada herramienta, no reduce el alcance. Sin escalonar son 10 herramientas
que instalar y mantener **antes de la primera funcionalidad**, y con `CX-27` eso se paga en semanas.
La partición coincide con los dos niveles de puerta que T25 ya había definido.

### Flujos E2E — lista cerrada

1. **Pago offline + sincronización** — la pieza más difícil del sistema (T14)
2. **Cierre de caja a cero pendiente** — `C-50`; si falla, las cuentas no cuadran (`C-110`)
3. **Aprobación de venta en 4 pasos con QR** — control antifraude nº 2 (`C-99`)

**Cerrada por diseño.** T22 advirtió que el E2E se pudre si cubre todo: lento, frágil, y en tres
semanas el equipo aprende a reintentar hasta que salga verde, momento en que la puerta deja de
significar nada. **Tres flujos intocables valen más que veinte que nadie mira.**

### CI/CD Gates

**Todas obligatorias, en dos niveles** (T25).

| Puerta | Qué corre | Tiempo | Cuándo |
|---|---|---|---|
| **Por cada cambio** — bloquea la **fusión** | Tipos y formato · unitarias · **integración con PostgreSQL real** · SAST + escaneo de dependencias · **compatibilidad del contrato OpenAPI** · **~~revisión de código aprobada~~ → análisis estático (Ruff + Bandit) + lista de comprobación marcada en el PR** (T33) | minutos | Siempre |
| **Antes de publicar** — bloquea el **despliegue**, no la fusión | Extremo a extremo sobre flujos críticos · rendimiento contra `OQ-N-44` · DAST. ⚠️ **Corre contra la pila local**, no contra staging — ver §Entornos y `CX-39` | decenas de minutos | Nocturno y antes de cada versión |

> **Dos correcciones de T33 y T32 sobre lo que T25 escribió el 2026-08-01**, ambas porque la puerta
> era incumplible tal como estaba: la **revisión humana** no existe con un equipo de una persona
> (`CX-31`), y la **puerta lenta no tenía dónde correr** (`CX-39`). En ambos casos la puerta se
> conserva y bloquea igual; lo que cambia es quién la satisface y dónde se ejecuta.
> 🔴 **Añadido por T33: no se despliega desde el portátil, nunca.** Solo desde CI, por etiqueta.
> Es el control que sostiene al registro inmutable de despliegues y a la aprobación del cliente para
> los módulos de dinero.

**Motivo de la separación**: extremo a extremo y rendimiento **fallan a veces sin que nadie haya
roto nada** — un tiempo de espera agotado, un navegador lento, un contenedor que arrancó tarde. Si
eso bloquea cada fusión, en tres semanas el equipo aprende a **reintentar hasta que salga verde** y
la puerta deja de significar nada. Es la forma más común de que la disciplina de pruebas se
disuelva: no por falta de pruebas, sino por puertas que se aprende a ignorar.

**La comprobación de contrato va en la puerta rápida**: se compara el OpenAPI del cambio con el
publicado y **falla si introduce una ruptura**. Es lo único que impide que un cambio inocente deje
sin funcionar **las apps que los gestores ya tienen instaladas**.

---

## Example Code

Escritos por el rol técnico a partir de las 23 respuestas de la entrevista y **aprobados por el
usuario** (séptima excepción a la política de no pre-llenado, T26–T29, 2026-08-02). Cada bloque marca
**de qué respuesta sale cada decisión**, para que sea verificable y no haya que confiar en él.

**Cierra `OQ-T-22` (P0)**, la brecha más cara del documento.

---

### Endpoint — `backend/src/payments/router.py` (T26)

```python
"""Registro de un pago. Patron canonico de endpoint.

T13  REST descrito con OpenAPI          T16  router = borde; no contiene reglas
T17  tenant_id sale del token           T10  prohibido filtrar tenant en Python
T14  el ledger solo admite INSERT       T22  idempotencia por clave unica
"""

from typing import Annotated
from uuid import UUID

from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel, ConfigDict, Field

from shared.money import Money
from .service import PaymentService, LoanNotFound
from .domain import InvalidPayment

router = APIRouter(prefix="/payments", tags=["payments"])


class RegisterPaymentRequest(BaseModel):
    # extra="forbid": un campo desconocido es un error, no algo que se ignora en
    # silencio. Con ~40 dispositivos enviando lotes offline, un campo mal escrito
    # que se ignora es un pago que se pierde sin que nadie se entere.
    model_config = ConfigDict(extra="forbid")

    loan_id: UUID
    amount: Annotated[str, Field(pattern=r"^\d{1,10}(\.\d{1,2})?$")]
    occurred_at: datetime          # cuando lo registro el cobrador (reloj del telefono)
    idempotency_key: Annotated[str, Field(min_length=16, max_length=64)]

    # ────────────────────────────────────────────────────────────────────────
    # NO HAY tenant_id AQUI, Y ES A PROPOSITO (T17).
    # El tenant sale del token verificado. Si el cliente pudiera influir en el,
    # el aislamiento multi-tenant se cae entero y las prohibiciones de T10 dejan
    # de servir para nada: RLS confia en ese valor.
    # ────────────────────────────────────────────────────────────────────────

    # `amount` viaja como cadena, no como float ni como number de JSON.
    # T10 prohibe float para dinero, y un `number` de JSON ES un float en cuanto
    # lo toca un parser de JavaScript: la web y el movil son TypeScript (T8).


class PaymentResponse(BaseModel):
    ledger_entry_id: UUID
    applied: str
    excess: str
    installments_advanced: str     # fraccionario (D-02): "0.70"
    new_balance: str


@router.post("", status_code=status.HTTP_201_CREATED)
async def register_payment(
    body: RegisterPaymentRequest,
    principal: Annotated[Principal, Depends(current_principal)],
    service: Annotated[PaymentService, Depends(get_payment_service)],
) -> PaymentResponse:
    """El router hace tres cosas y ninguna mas: recibir, delegar, traducir errores.

    Ninguna regla de negocio vive aqui. Si aparece un `if` sobre montos o fechas
    en este archivo, esta en el sitio equivocado (T16).
    """
    try:
        result = await service.register_payment(
            loan_id=body.loan_id,
            amount=Money.parse(body.amount),
            occurred_at=body.occurred_at,
            idempotency_key=body.idempotency_key,
            principal=principal,
        )
    except LoanNotFound:
        # 404, no 403: bajo RLS un prestamo de otro tenant sencillamente NO EXISTE
        # para esta sesion. Distinguir "no existe" de "no puedes verlo" filtraria
        # la existencia de datos de otro tenant.
        raise HTTPException(status.HTTP_404_NOT_FOUND, "loan not found")
    except InvalidPayment as exc:
        raise HTTPException(status.HTTP_422_UNPROCESSABLE_ENTITY, str(exc))

    return PaymentResponse(...)
```

---

### Función / módulo — núcleo y cáscara (T27)

#### `backend/src/shared/money.py`

```python
"""Tipo Dinero. Envuelve unidades menores enteras para que `float` sea imposible.

T10 prohibe float para dinero. Guardar centavos como int, y no como Decimal,
elimina la ultima via de sorpresa: no existe fraccion de centavo que perder.

CX-11 SIN RESOLVER: la moneda nunca se declaro, asi que Money todavia no lleva
codigo de moneda. Cuando CX-11 cierre, se anade AQUI — en un sitio, no en
doscientos.
"""

from dataclasses import dataclass
from decimal import Decimal, ROUND_HALF_UP

MINOR_UNITS = Decimal("100")


@dataclass(frozen=True, slots=True, order=True)
class Money:
    minor: int                      # centavos. Nunca float, nunca Decimal suelto

    @classmethod
    def parse(cls, value: str | Decimal) -> "Money":
        amount = Decimal(value)
        return cls(int((amount * MINOR_UNITS).quantize(Decimal("1"), ROUND_HALF_UP)))

    @property
    def as_decimal(self) -> Decimal:
        return Decimal(self.minor) / MINOR_UNITS

    def __add__(self, other: "Money") -> "Money": return Money(self.minor + other.minor)
    def __sub__(self, other: "Money") -> "Money": return Money(self.minor - other.minor)
    def __neg__(self)               -> "Money": return Money(-self.minor)

    def ratio_to(self, other: "Money") -> Decimal:
        """Unica division permitida: produce un RATIO, nunca dinero."""
        return (Decimal(self.minor) / Decimal(other.minor)).quantize(Decimal("0.01"))

    def is_positive(self) -> bool: return self.minor > 0
    def is_zero(self)     -> bool: return self.minor == 0

    # Deliberadamente NO existe __mul__ por float ni __truediv__ que devuelva
    # Money. Multiplicar dinero por un flotante es como se pierden centavos.


ZERO = Money(0)
```

#### `backend/src/payments/domain.py` — **el núcleo funcional**

```python
"""Nucleo funcional de pagos. PURO: sin base de datos, sin red, sin reloj.

Las reglas salen todas de D-02:
  - la cuota es indivisible, pero un pago parcial avanza un CONTADOR FRACCIONARIO
  - el interes es fijo sobre capital y ya esta incorporado al saldo
  - no hay interes de mora ni descuento por pago anticipado, asi que LA FECHA NO
    INTERVIENE EN LA ARITMETICA. Se transporta para el asiento, jamas para calcular.

Este archivo no importa SQLAlchemy, ni httpx, ni datetime.now(). Si algun dia lo
hace, la regla de T22 ("las matematicas de dinero en funciones puras") esta rota y
las pruebas de T28 dejan de poder escribirse.
"""

from dataclasses import dataclass
from decimal import Decimal

from shared.money import Money, ZERO


class InvalidPayment(ValueError):
    """El pago no puede aplicarse. No es un fallo tecnico: es una regla de negocio."""


@dataclass(frozen=True, slots=True)
class PaymentAllocation:
    applied: Money                  # lo que entra al prestamo
    excess: Money                   # lo que sobra si pago de mas
    installments_advanced: Decimal  # D-02: fraccionario. 0.70 es un valor valido
    new_balance: Money


def allocate_payment(
    *,
    outstanding_balance: Money,
    installment_amount: Money,
    amount_paid: Money,
) -> PaymentAllocation:
    """Decide como se reparte un pago. NO GUARDA NADA. NO CONSULTA NADA.

    Todos los argumentos son por nombre, a proposito: `allocate_payment(a, b, c)`
    con tres montos del mismo tipo es un error que el tipador no puede atrapar.
    """
    if not amount_paid.is_positive():
        raise InvalidPayment("amount_paid must be positive")
    if not installment_amount.is_positive():
        raise InvalidPayment("installment_amount must be positive")
    if outstanding_balance.minor < 0:
        raise InvalidPayment("outstanding_balance cannot be negative")

    applied  = min(amount_paid, outstanding_balance)
    excess   = amount_paid - applied
    balance  = outstanding_balance - applied
    advanced = applied.ratio_to(installment_amount)   # D-02: contador fraccionario

    return PaymentAllocation(applied, excess, advanced, balance)
```

#### `backend/src/payments/service.py` — **la cáscara imperativa**

```python
"""Orquesta: leer -> decidir -> escribir. Toda la suciedad vive aqui."""


class PaymentService:
    def __init__(
        self,
        loans: LoanRepository,
        ledger: LedgerRepository,
        clock: Clock,               # ports/clock.py — T22: se inyecta, no se invoca
        messaging: Messaging,       # ports/messaging.py — CX-16/CX-29: intercambiable
    ) -> None:
        self._loans, self._ledger = loans, ledger
        self._clock, self._messaging = clock, messaging

    async def register_payment(self, *, loan_id, amount, occurred_at,
                               idempotency_key, principal) -> PaymentAllocation:

        # 1. IDEMPOTENCIA (T22). Un lote que se reenvia tras caerse la red NO
        #    puede cobrar dos veces. La clave unica esta en la BASE DE DATOS, no
        #    en este `if`: la comprobacion es una optimizacion, la restriccion es
        #    la garantia.
        if (previous := await self._ledger.find_by_idempotency_key(idempotency_key)):
            return previous.allocation                    # reproduccion, no segundo cobro

        # 2. LEER. El saldo es LA SUMA DE LOS ASIENTOS (T14), nunca una columna
        #    editable. No existe `loans.update_balance(...)` en ningun sitio.
        loan = await self._loans.get(loan_id)             # lanza LoanNotFound

        # 3. DECIDIR. Unica linea que decide algo, y es pura.
        allocation = allocate_payment(
            outstanding_balance=loan.outstanding_balance,
            installment_amount=loan.installment_amount,
            amount_paid=amount,
        )

        # 4. ESCRIBIR. Solo INSERT (T14). Corregir un error es un reversal_entry,
        #    nunca un UPDATE. Lo impide un permiso de PostgreSQL, no la disciplina.
        entry = await self._ledger.append(
            LedgerEntry(
                loan_id=loan.id,
                collector_id=principal.user_id,
                amount=allocation.applied,
                installments_advanced=allocation.installments_advanced,
                idempotency_key=idempotency_key,

                # DOS RELOJES, Y LA DISTINCION IMPORTA:
                #   occurred_at  = lo que dijo el telefono. NO es de fiar — T14
                #                  exige probar el escenario "reloj cambiado a mano".
                #   recorded_at  = reloj del servidor. Es el que vale para auditoria.
                occurred_at=occurred_at,
                recorded_at=self._clock.now(),   # T10: nunca datetime.utcnow()
            )
        )

        # 5. AVISAR. Por un puerto, no por WhatsApp directamente: CX-16 sigue sin
        #    confirmar y CX-29 acaba de anadir Telegram.
        await self._messaging.send(...)

        return allocation
```

#### `backend/src/shared/db.py` — **la sesión con RLS** *(el detalle que más se rompe)*

```python
@asynccontextmanager
async def tenant_session(factory, tenant_id: UUID):
    """Abre una transaccion con el tenant fijado para RLS.

    SET LOCAL, NO SET. `SET` persiste en la CONEXION, y las conexiones se reciclan
    en el pool: el siguiente request podria heredar el tenant del anterior. Eso es
    una fuga entre tenants silenciosa, que ninguna prueba unitaria detecta.
    `SET LOCAL` muere con la transaccion.
    """
    async with factory() as session:
        async with session.begin():
            await session.execute(
                text("SET LOCAL app.current_tenant = :t"), {"t": str(tenant_id)}
            )
            yield session
```

---

### Prueba — dos patrones distintos (T28)

#### Unitaria del núcleo — `backend/tests/payments/test_domain.py`

```python
"""Sin base de datos, sin mocks, sin reloj, sin async. Milisegundos.

Asi se ve una prueba del nucleo funcional: entradas -> salidas. Si una prueba de
este archivo necesita un `mock`, el codigo que prueba no es puro.
"""

from decimal import Decimal
import pytest

from payments.domain import allocate_payment, InvalidPayment
from shared.money import Money, ZERO


def test_partial_payment_advances_a_fractional_installment():
    """D-02: la cuota es indivisible, pero el contador avanza en fraccion."""
    result = allocate_payment(
        outstanding_balance=Money.parse("1000.00"),
        installment_amount=Money.parse("100.00"),
        amount_paid=Money.parse("70.00"),
    )
    assert result.installments_advanced == Decimal("0.70")
    assert result.new_balance == Money.parse("930.00")
    assert result.excess == ZERO


def test_overpayment_does_not_produce_a_negative_balance():
    result = allocate_payment(
        outstanding_balance=Money.parse("50.00"),
        installment_amount=Money.parse("100.00"),
        amount_paid=Money.parse("80.00"),
    )
    assert result.applied     == Money.parse("50.00")
    assert result.excess      == Money.parse("30.00")
    assert result.new_balance == ZERO


@pytest.mark.parametrize("amount", ["0.00", "-10.00"])
def test_non_positive_payment_is_rejected(amount):
    with pytest.raises(InvalidPayment):
        allocate_payment(
            outstanding_balance=Money.parse("100.00"),
            installment_amount=Money.parse("10.00"),
            amount_paid=Money.parse(amount),
        )
```

#### Integración con PostgreSQL real — `backend/tests/test_isolation.py`

```python
"""T22 exige PostgreSQL REAL: RLS, transacciones y la restriccion de unicidad de
idempotencia NO EXISTEN en ningun otro sitio. Un SQLite en memoria pasaria estas
pruebas en verde sin probar nada.

Estas dos pruebas verifican los dos controles de los que depende el producto.
"""

import pytest
from sqlalchemy import select, update
from sqlalchemy.exc import ProgrammingError


async def test_rls_isolates_tenants(session_factory, tenant_a, tenant_b):
    """La prueba mas importante del sistema.

    Nota que NO hay `WHERE tenant_id = ...` en la consulta. Es a proposito: T10
    prohibe filtrar tenant en la capa Python. Lo que hace que esto salga vacio es
    RLS. Si esta prueba pasa a fallar, el aislamiento se rompio.
    """
    async with tenant_session(session_factory, tenant_a) as s:
        await s.execute(insert(ledger_entries).values(amount=1000, ...))

    async with tenant_session(session_factory, tenant_b) as s:
        rows = (await s.execute(select(ledger_entries))).all()

    assert rows == []


async def test_ledger_is_append_only_at_the_database_level(session_factory, tenant_a):
    """T14: el ledger no admite UPDATE. Lo impide un permiso de PostgreSQL, no un
    acuerdo del equipo — asi que hay que comprobar que el permiso EXISTE.

    Sin esta prueba, alguien quita el GRANT en una migracion y nadie se entera
    hasta que un saldo cambia sin dejar rastro. Es el producto entero.
    """
    async with tenant_session(session_factory, tenant_a) as s:
        await s.execute(insert(ledger_entries).values(amount=1000, ...))

    with pytest.raises(ProgrammingError):          # insufficient_privilege
        async with tenant_session(session_factory, tenant_a) as s:
            await s.execute(update(ledger_entries).values(amount=1))
```

---

### Infraestructura — `infra/rds.tf` y `infra/ecs.tf` (T29)

**Herramienta: Terraform** (T16).

```hcl
# ─── infra/rds.tf ────────────────────────────────────────────────────────────

resource "aws_kms_key" "rds" {
  description         = "RDS at-rest encryption — T18"
  enable_key_rotation = true
}

resource "aws_db_instance" "main" {
  identifier     = "${var.project}-${var.environment}"
  engine         = "postgres"
  engine_version = "17"
  instance_class = "db.t4g.small"          # T11: NO Aurora — ~1,8x mas cara en reposo

  # ══════════════════════════════════════════════════════════════════════════
  # T18 — CIFRADO EN REPOSO. AWS SOLO PERMITE ACTIVARLO AL CREAR LA INSTANCIA.
  # Encenderlo despues exige RECREAR la instancia y migrar los datos.
  # Esta linea es, en la practica, IRREVERSIBLE tras el primer `terraform apply`.
  # ══════════════════════════════════════════════════════════════════════════
  storage_encrypted = true
  kms_key_id        = aws_kms_key.rds.arn

  # T11 — red: subred aislada, sin ruta a internet, sin IP publica
  db_subnet_group_name   = aws_db_subnet_group.isolated.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible    = false

  multi_az                = false   # OQ-N-45: 0,04 escrituras/s no lo justifican
  backup_retention_period = 7       # T18: los snapshots heredan la clave KMS
  deletion_protection     = true
}

resource "aws_security_group_rule" "rds_from_ecs_only" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds.id
  source_security_group_id = aws_security_group.ecs_tasks.id

  # UNICA regla de entrada a la base. Ni desde el NAT, ni desde el ALB, ni desde
  # internet. Y notese que RDS NO atraviesa el NAT para hablar con ECS: misma
  # VPC, enrutamiento local (correccion registrada en T11).
}


# ─── infra/ecs.tf ────────────────────────────────────────────────────────────

resource "aws_ecs_service" "api" {
  name            = "${var.project}-api"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.api.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = aws_subnet.private[*].id      # T11: SUBRED PRIVADA
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = false                          # T11: sin IP publica
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.api.arn    # T11: unica entrada
    container_name   = "api"
    container_port   = 8000
  }
}

locals {
  # ══════════════════════════════════════════════════════════════════════════
  # T18 — TLS ENTRE ECS Y RDS. NO ES EL COMPORTAMIENTO POR DEFECTO.
  # Sin este parametro el trafico entre la tarea y la base va EN CLARO dentro de
  # la VPC. Es lo que mas se olvida al declarar "todo cifrado en transito".
  #
  # OJO: con asyncpg el parametro es `ssl`, NO `sslmode` como en psycopg.
  #      Escribir `sslmode=require` con asyncpg no da error: LO IGNORA.
  # ══════════════════════════════════════════════════════════════════════════
  database_url = "postgresql+asyncpg://${var.db_user}:${var.db_password}@${aws_db_instance.main.endpoint}/${var.db_name}?ssl=require"
}
```

> ⚠️ **Trampa documentada a proposito** en el bloque de arriba: con `asyncpg`, escribir
> `sslmode=require` **no produce ningun error — se ignora en silencio**, y el trafico sigue en claro.
> Es exactamente el tipo de fallo que no aparece en ninguna prueba y que solo se ve auditando.

---

## Open Questions (Technical)

Detalle completo en `open-questions.md` §7. De 26 preguntas `OQ-T`: **21 cerradas · 2 parciales ·
3 abiertas → 84,6 %**.

**Las tres abiertas están bloqueadas fuera del rol técnico** — ninguna se puede cerrar preguntando
al líder técnico, y por eso se excluyeron a propósito de la ampliación #2:

| ID | Título | Prio | Bloqueada en |
|---|---|---|---|
| `OQ-T-15` | Proveedor de LLM para el asistente | **P0** | `CX-30` — si la IA está en el plan básico de la suscripción, vuelve a la v1. **Requiere confirmación del cliente** |
| `OQ-T-25` | Acceso a datos o exportaciones de TryController | P1 | `CX-20` — el proveedor no ofrece exportación. Es migración de datos, no código heredado |
| `OQ-T-26` | Pasarela de cobro de la suscripción del software | P1 | Cliente. `D-03` deja el módulo de facturación SaaS fuera de la v1 |

**Las dos parciales:**

| ID | Qué falta | Prio |
|---|---|---|
| `OQ-T-13` | Solo la **política de retención** de las fotos (el número de años). Entrega y almacenamiento cerrados en T11 | P1 |
| `OQ-T-19` | Solo el **número de cobertura** (T23, fuera de alcance por profundidad). Tipos, herramientas, escalonamiento y flujos E2E cerrados | P2 |

**Abiertas durante las entrevistas técnicas, fuera del bloque `OQ-T`:**

| ID | Título | Prio | Estado |
|---|---|---|---|
| `CX-27` | El alcance comprometido no cabe en un equipo de una persona | **P0** | ⬜ Abierta — reabre `D-03` |
| `CX-30` | La IA entra en el plan básico, contra `D-03` y contra `C-108` | **P0** | ⬜ Abierta — requiere al cliente |
| `CX-26` | *"Vincular el usuario a la IP del celular"* no es implementable | **P0** | ✅ Traducción confirmada por `V-36`; falta el **flujo de reautorización** |
| `OQ-F-99` | Qué pasa con las operaciones sin sincronizar de un dispositivo revocado | **P0** | ⬜ Abierta — decisión de negocio |
| `CX-39` | La puerta lenta de T25 no tiene ambiente donde ejecutarse | P1 | 🟡 Mitigada en local por T32; **el rendimiento sigue sin resolver** |
| `OQ-N-44` | **Objetivo de rendimiento contra el que medir** | P1 | ⬜ **Abierta — T34 quedó sin responder** al cerrar la sesión del 2026-08-07 |
| `OQ-N-45` | ¿Se acepta la subida de ~50 % del coste por la red privada de T11? | P1 | ⬜ Abierta — depende de `OQ-N-40` |
| `CX-29` · `CX-37` | Telegram para reportes; tres canales de mensajería incompatibles | P1 | ⬜ Abiertas — el puerto `messaging` absorbe el cambio, la planificación no |

⚠️ **`OQ-T-24` deja cuatro términos de glosario sin confirmar** —`sale`, `client` vs `customer`,
`partner`, y si `collector` cubre "cobrador" y "gestor"— **que deben cerrarse antes de escribir
código**. Estaban en la lista de bonus de la ampliación #2 y no se alcanzaron.

---

## Riesgos técnicos abiertos

- ~~SQLite cifrada en el dispositivo~~ — ✅ **CERRADO el 2026-08-07 (T30)**: `op-sqlite` +
  SQLCipher. Queda **una verificación de arranque**, no un riesgo abierto: confirmar el config
  plugin oficial y las condiciones de licencia de SQLCipher antes de la primera migración.
- ~~Librería de gráficas sin declarar~~ — ✅ **CERRADO el 2026-08-07 (T9-b)**: **Recharts**. Queda
  fijar una versión compatible con React 19.
- ⚠️ **El rendimiento no tiene objetivo ni ambiente** — `OQ-N-44` sigue abierta (T34 no respondida) y
  `CX-39` deja a k6 corriendo solo en local, donde el número **no es comparable con producción**.
  Concretamente, el riesgo que nadie está midiendo es el **crecimiento del ledger**: es *append-only*
  y el saldo se define como la **suma de los movimientos**, así que a ~1.200 asientos/día son
  ~1,1 millones en 3 años y el cálculo se degrada de forma continua e invisible. T14 ya previó la
  mitigación —**tabla de resumen precalculada** refrescada por una tarea periódica de Procrastinate—
  pero **nadie ha fijado el umbral que obligaría a activarla**.
- ⚠️ **Calidad de ejecución de la cola de comandos** — el riesgo ya no es qué motor elegir sino que
  ese código se escribe en casa. Los cinco escenarios de prueba son donde se romperá si se hace con
  prisa.

---

## Conflictos con artefactos previos

⚠️ **`technical-research/recomendacion-tecnica.md` necesita revisión 3.** Esta entrevista lo
sobrescribe en tres puntos: proponía **Supabase + Fly.io + Cloudflare R2** (§5.3) frente al **AWS**
elegido, y **TypeScript + NestJS en todas partes** (§4.1, §4.2, §4.13) frente al **Python + FastAPI**
elegido con TypeScript solo del lado cliente. En caso de discrepancia, **manda este documento**.
