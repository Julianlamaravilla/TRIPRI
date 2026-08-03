# TRIPRI

Sistema de gestión y **control antifraude** de cobranza diaria, multi-tenant, con app móvil para
cobradores en campo y panel web de administración.

Este repositorio contiene la **fase de Discovery** del producto: la definición de qué se va a
construir y bajo qué restricciones técnicas, **antes** de escribir código de aplicación.

> ⚠️ **El código de la aplicación todavía no existe.** Lo que hay aquí son los artefactos que lo
> definen. El Discovery está al **56 %** de cobertura medida.

---

## Qué es el producto

Un prestamista informal opera **rutas de cobro**: un cobrador recorre a diario una lista de clientes
que pagan cuotas fijas en efectivo o por transferencia. El problema que resuelve este sistema **no es
gestionar la cobranza** —eso ya lo hacen— sino **impedir el fraude interno**, que el cliente declaró
como su problema número uno.

Los dos fraudes concretos que ataca:

1. **Cobrar y no registrar** — el cobrador recibe el dinero y no lo anota.
2. **Desviar el efectivo de una venta** — el cobrador reporta un préstamo que nunca desembolsó.

De ahí salen las dos decisiones que gobiernan toda la arquitectura:

- **El registro de movimientos es inmutable.** Nunca se edita ni se borra: un error se corrige con un
  asiento que lo compensa, y los dos quedan visibles. El saldo es la **suma de los movimientos**, no
  una columna editable.
- **El dispositivo queda vinculado al usuario** mediante un par de claves criptográficas que nunca
  sale del teléfono, de modo que una cuenta prestada a otra persona no sirve.

---

## Estructura del repositorio

```
TRIPRI/
├── Product-Definition/        # ← los artefactos del Discovery
│   ├── technical-environment.md   # entorno técnico: stack, restricciones, ejemplos de código
│   ├── open-questions.md          # registro de brechas: 234 filas con estado y evidencia
│   ├── state/                     # estado de la sesión y de cada rol
│   ├── interview/                 # cuestionarios al cliente y entrevista técnica
│   └── audit/                     # bitácora completa, append-only
│
├── context-discovery/         # material de partida aportado por el cliente
├── technical-research/        # investigación de stack e infraestructura, con costos verificados
├── sample-aidlc-discovery/    # referencia de terceros — NO versionada, ver abajo
└── .claude/                   # skills y protocolos del proceso de Discovery
```

`sample-aidlc-discovery/` es un clon de [aws-samples/sample-aidlc-discovery](https://github.com/aws-samples/sample-aidlc-discovery)
y **no se versiona aquí**. Si lo necesitas:

```bash
git clone https://github.com/aws-samples/sample-aidlc-discovery.git
```

---

## Estado actual

| Bloque | Cobertura | Estado |
|---|---:|---|
| **Entorno técnico** | **82,7 %** | ✅ Entrevista completa y aprobada — 23/23 |
| Negocio y Visión | 66,7 % | 🟡 Tres rondas de cuestionario respondidas |
| No funcional | 62,5 % | 🟡 |
| Contradicciones | 53,9 % | 🟡 14 sin resolver |
| Funcional | 45,2 % | 🟡 |
| **Global** | **56,0 %** | Medido fila por fila, no estimado |

La cobertura se calcula como `(cerradas + 0,5 × parciales) / total` sobre las **234 filas** del
registro de brechas. **Cada fila lleva la evidencia que sustenta su estado**, citada a la respuesta
concreta que la cierra.

### Entregables del Discovery

| Documento | Estado |
|---|---|
| `technical-environment.md` | ✅ Completo |
| `open-questions.md` | ✅ Reconciliado fila por fila |
| `vision-document.md` | ❌ **No existe todavía** |

---

## Decisiones técnicas fijadas

Recogidas en `Product-Definition/technical-environment.md`, con la justificación de cada una.

**Stack**

| Capa | Tecnología |
|---|---|
| Backend | Python 3.14 · FastAPI · Pydantic v2 · SQLAlchemy 2.0 + asyncpg · Alembic |
| Base de datos | PostgreSQL 17 — **una sola**, incluida la cola de trabajos |
| Web | TypeScript · React 19 · Vite · TanStack Query · Tailwind + shadcn/ui |
| Móvil | React Native · Expo · Expo Router · SQLite cifrada |
| Infraestructura | AWS `sa-east-1` · ECS Fargate · RDS · S3 · Terraform |

**Arquitectura**

Monolito modular en **rebanadas verticales**, con **hexagonal acotado** por módulo y un **núcleo
funcional** puro donde viven las matemáticas de dinero.

```
backend/src/
├── payments/     # router · service · domain · repository · models
├── loans/
├── cash_box/
├── clients/
├── sync/         # cola de comandos offline
├── auth/
├── ports/        # 6 enchufes: clock, messaging, storage, ai, repository, push
├── adapters/     # implementaciones reales + falsas para pruebas
└── shared/       # db · config · money · tenant
```

**Reglas vinculantes**

- `domain.py` es **puro**: sin base de datos, sin red, sin reloj. El reloj **se inyecta**.
- El aislamiento entre empresas lo garantiza **RLS de PostgreSQL**, nunca un filtro en Python.
  El `tenant_id` sale **del token verificado**, jamás del cuerpo de la petición.
- **Nunca `float` para dinero.** Existe un tipo `Money` sobre unidades menores enteras.
- El registro de movimientos **solo admite `INSERT`**, impuesto por permisos de PostgreSQL.
- Un puerto por cada cosa que puede cambiar de verdad o que estorba en las pruebas. **Ni uno más.**

**Cumplimiento**: LGPD (obligatoria, Brasil) + ISO 27001 como guía de diseño.

---

## El proceso

El Discovery se condujo con **AI-DLC Discovery**, que separa dos roles:

- **Negocio** — qué se construye y por qué → cuestionarios al cliente
- **Técnico** — bajo qué restricciones → entrevista al equipo técnico

Ambos alimentan un **registro único de brechas** donde cada pregunta abierta queda con su
identificador, su prioridad y su evidencia. Nada se cierra sin una respuesta que lo respalde, y
**ninguna etapa avanza sin aprobación explícita**.

Todo el recorrido —cada pregunta, cada respuesta, cada decisión y su motivo— está en
`Product-Definition/audit/session-audit.md`, que es **append-only**.

---

## Qué falta

Tres bloqueantes en `Product-Definition/open-questions.md`, todos en P0:

1. **`CX-33`** — Los suscriptores **no pueden obtener WhatsApp Business API**: Meta exige empresa
   registrada y verificada. Los dos controles antifraude dependen de ese canal.
2. **`CX-35`** — Si la mayoría de los pagos son por transferencia y no en efectivo, el modelo
   centrado en caja describe una parte pequeña de la operación.
3. **`CX-27`** — El alcance comprometido no cabe en el equipo disponible.

Los cuestionarios para cerrar el resto están en `Product-Definition/interview/`:
`Negocio.docx`, `Contradicciones.docx` y `Funcional.docx`.

---

## Licencia

Sin licencia declarada. Todos los derechos reservados.
