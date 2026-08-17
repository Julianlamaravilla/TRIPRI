# Conventional Commits — TRIPRI

Convención de mensajes de commit para el proyecto TRIPRI. Basada en [Conventional Commits 1.0.0](https://www.conventionalcommits.org/).

**Objetivo**: Commits legibles, automáticamente procesables, y que faciliten el generación de CHANGELOGs y versionamiento semántico.

---

## Formato

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Type
Tipo de cambio. **Obligatorio**.

| Type | Significado | Impacto en versión |
|---|---|---|
| **feat** | Nueva funcionalidad | Minor (0.x.0) |
| **fix** | Corrección de bug | Patch (0.0.x) |
| **docs** | Cambios en documentación | Ninguno |
| **style** | Formateo, sin cambio lógico (espacios, comillas, etc.) | Ninguno |
| **refactor** | Cambio estructural, sin cambio lógico ni fix | Ninguno |
| **perf** | Mejora de rendimiento | Patch |
| **test** | Agregar o actualizar pruebas | Ninguno |
| **chore** | Tareas de mantenimiento (deps, build, tooling) | Ninguno |
| **ci** | Cambios en CI/CD | Ninguno |
| **revert** | Revertir un commit anterior | Depende del revert |

### Scope
Módulo o área afectada. **Recomendado**.

**Módulos principales** (de `backend/`, `mobile/`, `web/`, `infra/`):

**Backend** (`backend/`):
- `auth` — Autenticación y sesiones
- `client` — Modelo y operaciones de cliente
- `sale` — Modelo y flujo de venta/préstamo
- `payment` — Registro y procesamiento de pagos
- `cash` — Operaciones de caja y cierre
- `ledger` — Libro mayor e inmutabilidad
- `key` — Llaves de autorización
- `device` — Vinculación y gestión de dispositivos
- `alert` — Sistema de alertas
- `whatsapp` — Integración WhatsApp Business API
- `sync` — Motor de sincronización
- `auth-api` — API y middleware de autenticación
- `tenant` — Lógica multi-tenant y RLS

**Mobile** (`mobile/`):
- `ui` — Componentes y pantallas
- `offline` — Modo offline y sincronización local
- `camera` — Captura de fotos y documentos
- `gps` — Localización y mapas
- `auth` — Autenticación en app
- `payment-form` — Formulario de registro de pago
- `new-sale` — Flujo de nueva venta
- `cash-box` — Cierre de caja móvil
- `qr` — Escaneo de QR

**Web** (`web/`):
- `dashboard` — Tablero principal
- `client-mgmt` — Gestión de clientes
- `sale-approval` — Flujo de aprobación de ventas
- `cash-mgmt` — Gestión de cajas
- `expense` — Aprobación de gastos
- `key-mgmt` — Emisión de llaves
- `device-mgmt` — Gestión de dispositivos
- `reports` — Generación de reportes
- `audit` — Vista de auditoría

**Infra** (`infra/`):
- `terraform` — Infraestructura IaC
- `docker` — Contenedores
- `ci-cd` — Pipeline de CI/CD
- `monitoring` — Observabilidad y alertas
- `backup` — Estrategia de respaldos
- `security` — Políticas y configuraciones de seguridad

**Cross-cutting**:
- `contracts` — Cambios en OpenAPI/schemas compartidos
- `docs` — Documentación general del proyecto
- `deps` — Actualización de dependencias
- `config` — Configuración general

### Subject
Descripción breve. **Obligatorio**. 

- Máximo **50 caracteres**
- Imperativo presente: `add` no `added` ni `adds`
- Sin punto al final
- Sin mayúscula inicial
- En **español** o **inglés** (consistente con el proyecto)

**Ejemplos válidos**:
- `add fractional instalment counter to payment allocation`
- `fix race condition in cash closure sync`
- `refactor tenant isolation to use RLS policies`

**Ejemplos inválidos**:
- ❌ `Added new payment form` — pasado, mayúscula
- ❌ `Improve the performance of queries.` — punto al final
- ❌ `fix: pequeña corrección` — mezcla idiomas

### Body
Descripción detallada (opcional pero recomendado para cambios no triviales).

- Explica **qué** cambió y **por qué**, no **cómo** (el código ya lo dice)
- Máximo 72 caracteres de ancho
- Separado del subject con una línea en blanco
- Puede incluir múltiples párrafos

**Ejemplo**:
```
The payment allocation algorithm previously assumed
all partial payments would round to whole cuotas.
With fractional cuota support (OQ-F-30), a payment
of 25 against a 50-cuota now correctly produces 0.5
cuota and leaves 19.5 of 20 pending.

Fixes the cash box rounding errors reported in
OQ-F-47 where differences appeared at closure.
```

### Footer
Metadatos y referencias (opcional).

**Tokens soportados**:

| Token | Uso | Ejemplo |
|---|---|---|
| `Fixes #123` | Cierra issue | `Fixes #42` |
| `Closes #123` | Sinónimo de Fixes | `Closes OQ-F-30` |
| `Refs #123` | Referencia sin cerrar | `Refs CX-33` |
| `BREAKING CHANGE: description` | Cambio que rompe compatibilidad | `BREAKING CHANGE: payment amounts now immutable` |
| `Co-Authored-By: Name <email>` | Coautoría | `Co-Authored-By: Claude Haiku <noreply@anthropic.com>` |

**Ejemplo de footer**:
```
Fixes OQ-F-30
Refs CX-12
Co-Authored-By: Claude Haiku <noreply@anthropic.com>
```

---

## Ejemplos Completos

### Ejemplo 1: Nueva funcionalidad

```
feat(payment): add fractional cuota counter for partial payments

Implement OQ-F-30 requirement: when a payment of 25 lands against
a 50-cuota, the system now records 0.5 cuota and leaves 19.5 of
20 cuotas pending, instead of blocking or rounding.

Uses Decimal arithmetic for all monetary calculations to avoid
floating-point errors. Affects payment allocation and cash box
reconciliation.

Fixes OQ-F-30
Refs OQ-F-47
```

### Ejemplo 2: Corrección de bug

```
fix(ledger): prevent double-write of synchronization events

The sync engine was recording each payment twice: once when the
mobile device queued it, and again when the server confirmed.
This caused discrepancies in the immutable ledger and false
descuadres in cash closure.

Now the mobile device records a provisional entry with
recorded_at = null; the server replaces it with a final entry
when the sync arrives.

Fixes #127
```

### Ejemplo 3: Refactoring

```
refactor(auth): extract session validation into shared middleware

Move the JWT signature check and tenant extraction from
individual route handlers into a single Express middleware.
Reduces duplication and makes audit logging consistent across
all endpoints.

No functional changes. All tests pass.

Refs docs/architecture/auth
```

### Ejemplo 4: Actualización de dependencias

```
chore(deps): upgrade pydantic from 2.0 to 2.5

Picks up 5 security patches and improved performance on large
model validation. All test suites pass with no code changes.

No functional impact.
```

### Ejemplo 5: Cambio que rompe compatibilidad

```
feat(client-app)!: remove support for Android < 10

TLS 1.3 is now mandatory for all connections. Older Android
versions do not support TLS 1.3 and will fail to connect.

Aligns with technical requirement OQ-N-31 and improves
security posture.

BREAKING CHANGE: Android 9 and earlier no longer supported.
Update min SDK to 29 (Android 10).

Refs OQ-N-31
```

---

## Reglas de Validación

### Commits que NO deben hacerse

❌ **No usar tipos incorrectos**:
- `bugfix` → usa `fix`
- `feature` → usa `feat`
- `WIP` → usa `chore` o no commitees aún

❌ **No hacer commits sin contexto**:
- `fix` (sin scope ni explicación)
- `.` o `update` (sin descripción)

❌ **No mezclar temas no relacionados**:
- Un commit = un cambio lógico
- Si necesitas 3 cambios, son 3 commits

❌ **No hacer commits a producción sin approval**:
- Los commits de `payment`, `ledger`, `cash`, `auth` al main deben pasar code review
- Ramas `feature/*` pueden tener commits sin reviews durante el desarrollo

### Commits permitidos sin PR

- `docs` — actualizar documentación
- `chore(deps)` — actualizar dependencias menores
- `style` — formateo y linting automático
- `ci` — actualizar configuración de CI/CD (si eres DevOps)

---

## Integración en CI/CD

### Pre-commit Hook

Si usas `husky`, valida commits localmente antes de pushrear:

```bash
npm install husky commitlint --save-dev
npx husky install
npx commitlint --install-hook
```

### commitlint.config.js

```javascript
module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'type-enum': [
      2,
      'always',
      [
        'feat',
        'fix',
        'docs',
        'style',
        'refactor',
        'perf',
        'test',
        'chore',
        'ci',
        'revert',
      ],
    ],
    'scope-case': [2, 'always', 'lower-case'],
    'subject-case': [2, 'always', 'lower-case'],
    'subject-full-stop': [2, 'never', '.'],
    'subject-empty': [2, 'never'],
    'type-case': [2, 'always', 'always-lowercase'],
  },
};
```

### En GitHub Actions

Valida commits en cada PR:

```yaml
name: Commit Lint
on: [pull_request]
jobs:
  commitlint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          fetch-depth: 0
      - uses: commitlint-action@latest
```

---

## Generación de CHANGELOG

Con [`standard-version`](https://github.com/conventional-changelog/standard-version):

```bash
npm install standard-version --save-dev
npx standard-version
```

Genera automáticamente:
- `CHANGELOG.md` con grouped features, fixes, breaking changes
- Versión siguiente (major.minor.patch) según commits
- Git tag anotado

**Ejemplo de CHANGELOG generado**:

```markdown
# [0.2.0](https://github.com/tripri/tripri/compare/v0.1.0...v0.2.0) (2026-08-20)

### Features
- **payment**: add fractional cuota counter for partial payments ([abc1234](https://github.com/tripri/tripri/commit/abc1234))
- **cash**: implement three-panel closure UI ([def5678](https://github.com/tripri/tripri/commit/def5678))

### Bug Fixes
- **ledger**: prevent double-write of synchronization events ([ghi9012](https://github.com/tripri/tripri/commit/ghi9012))

### BREAKING CHANGES
- **client-app**: Android < 10 no longer supported

---

## Preguntas Frecuentes

**P: ¿Y si el commit es tan pequeño que no merece scope?**

R: Usa el scope más general que aplique. Si no aplica ninguno, omítelo — la scope es recomendada, no obligatoria.

```
fix: typo in error message
```

**P: ¿Puedo hacer commits en español?**

R: Sí, pero elige idioma y mantén consistencia. El proyecto usa inglés, así que recomendamos inglés.

**P: ¿Qué pasa si cometo un error en el mensaje?**

R: Enmienda el último commit con `git commit --amend`. Si ya está en remote, usa un nuevo commit `fix:` o `revert:`.

**P: ¿Commitlint me obliga a esto?**

R: Sí, si lo instalas. Pero puedes desactivarlo por commit con `git commit --no-verify` si es un caso excepcional. **No lo hagas habitualmente.**

**P: ¿El tipo `revert` es automático?**

R: No. Si necesitas deshacer un commit anterior, haz manualmente:

```
revert(payment): undo fractional cuota implementation

This reverts commit abc1234. The fractional cuota logic
introduced rounding errors we didn't anticipate.
Will reimplement with better test coverage.

Refs OQ-F-30
```

---

## Referencias

- [Conventional Commits](https://www.conventionalcommits.org/)
- [Semantic Versioning](https://semver.org/)
- [commitlint](https://commitlint.js.org/)
- [standard-version](https://github.com/conventional-changelog/standard-version)

