# Brechas Funcionales — Sesión de Completamiento 2026-08-16

**Objetivo**: Consolidar todo lo funcional abierto/parcial en base a lo recolectado (business v3, technical completo, feedback de demostraciones). Determinar qué se puede cerrar hoy y qué requiere respuesta del cliente.

**Estado actual**: 
- Funcional global: **44,4 %** (34 cerradas, 27 parciales, 46 abiertas de 107 totales)
- Con el feedback del cliente se abren **7 filas nuevas** → 54 abiertas
- **P0 bloqueantes**: 17 filas que frenan la planificación de v1

---

## 1. Nuevas Funcionales del Feedback de Demo (D-06)

Estos comentarios del cliente generan 7 nuevas líneas funcionales que se integran en `open-questions.md`:

| OQ-F | Pregunta | Módulo | Prio | Estado |
|---|---|---|---|---|
| **OQ-F-108** 🆕 | **Código único del cliente** — cada cliente debe llevar un identificador único generado por el sistema (no el documento) | M3 Clientes | P0 | ⬜ Abierta |
| **OQ-F-109** 🆕 | **Código único de la venta** — cada venta debe identificarse con un código único (ej. `VT-20260816-001`) | M4 Ventas | P0 | ⬜ Abierta |
| **OQ-F-110** 🆕 | **Alias del cliente** — gestor puede asignar alias editable, visible para todos (admin + otros gestores) | M4 Ficha cliente | P0 | ⬜ Abierta |
| **OQ-F-111** 🆕 | **Alias por venta** — al registrar venta, capturar alias opcional para que cobrador identifique mejor al cliente en esa transacción | M7 Nueva venta (móvil) | P1 | ⬜ Abierta |
| **OQ-F-112** 🆕 | **Ordenamiento de clientes por múltiples criterios** — En Mi ruta (móvil), permitir ordenar por (1) cercanía, (2) fecha del último cobro | M3 Mi ruta (móvil) | P1 | ⬜ Abierta |
| **OQ-F-113** 🆕 | **Aprobar venta con deuda existente** — Sistema muestra advertencia si cliente tiene saldo pendiente; admin puede sobrescribir con botón "Autorizar venta con deuda" | M4 Ventas | P0 | 🟡 Parcial — `OQ-F-41` debe cambiar de hard block a soft block con autorización |
| **OQ-F-114** 🆕 | **Ver historial del cliente al aprobar** — Panel con extracto (últimos 3–5 préstamos, estado, pagos) visible en pantalla de aprobación de venta | M4 Ventas | P1 | ⬜ Abierta |

**Más dos cambios a reglas existentes:**

| Cambio | Afecta | Prio | Estado |
|---|---|---|---|
| **Bloqueo de caja por gestor, no global** — Si un gestor deja caja abierta, solo su caja se bloquea; otros gestores pueden trabajar | `OQ-F-46` | P0 | ✅ Confirmada por cliente — ajusta el diseño existente |
| **Admin debe abrir todas las rutas** — Existe ruta especial "sistema"; admin debe abrir explícitamente todas las rutas antes de que cualquier gestor pueda abrir la suya | `OQ-F-46` | P0 | ⬜ Nueva regla de negocio |
| **Permiso temporal de auto-aprobación** — Admin puede activar un día específico para que todas las ventas se aprueben automáticamente; se desactiva al final del día | M6 Aprobaciones | P1 | ⬜ Abierta |
| **Admin no puede auto-aprobarse, ni editar pagos ajenos** — Segregación de funciones: quien origina la venta no puede aprobarla; admin nunca edita pago (solo anula pre-cierre) | Permisos | P0 | 🟡 Parcial — `OQ-F-1` (matriz de permisos) |

---

## 2. P0 Funcionales Abiertos — Bloqueantes de v1

Estas 12 líneas frenan la planificación de la v1. **Responder estas 12 cierra el ~70% global.**

### F3 · Matemática Financiera

| OQ-F | Pregunta | Decisión Requerida | Impacto |
|---|---|---|---|
| **OQ-F-24** | **Refinanciación** — ¿en qué se diferencia de la renovación? ¿Qué pasa con los intereses ya causados? | Clientes con préstamo anterior → ¿recalcular interés sobre saldo o sobre monto nuevo? | Alto (flujo de refinanciación) |
| **OQ-F-31** | **Abono extraordinario a capital** — ¿existe? ¿Reduce cuotas o el valor de cada cuota? | Probablemente NO (interés fijo sobre capital), pero hay que confirmar con cliente | Medio (clarificación) |

### F5 · Registro de Pagos

| OQ-F | Pregunta | Decisión Requerida | Impacto |
|---|---|---|---|
| **OQ-F-33** | **Anulación de pago** — ¿Quién puede hacerlo, hasta cuándo, y qué se le dice al cliente que ya recibió el WhatsApp? | Asiento compensatorio (técnica fija) pero operatoria abierta | Alto (gestión de excepciones) |
| **OQ-F-36** | **Catálogo de motivos de "no pago"** — ¿Cuál es la lista exacta? (no hizo ventas, no estaba, se niega, enfermedad, otro, etc.) | Necesario para: (a) entrenar alertas (`V-42`), (b) generar reportes | Medio (datos para soporte) |
| **OQ-F-37** | **Promesa de pago** — ¿Genera tarea de seguimiento, cambia estado, se rastrea hasta el día prometido? | El cliente registra "compromiso de fecha" al no pago; hay que saber si eso es suficiente o si requiere seguimiento automático | Medio (orquestación) |

### F6 · Llaves y Autorizaciones

| OQ-F | Pregunta | Decisión Requerida | Impacto |
|---|---|---|---|
| **OQ-F-40** | **Expiración y unicidad de llave** — ¿De cuánto es el vencimiento? ¿Es de un solo uso o reutilizable el mismo día? ¿Sirve para otra venta distinta? | Control crítico contra el fraude; impacta la UX del cobrador en campo | Alto (seguridad) |
| **OQ-F-41** | **Quién puede aprobar, y si puede auto-aprobarse** — El cliente comenta ahora que "admin no puede enviarse ventas el mismo para aprobar" | Segregación de funciones P0 | Alto (permisos) |
| **OQ-F-42** | **🔴 Llave offline** — Si el gestor está sin conexión y necesita una llave para pagar cuota 5+, ¿qué hace? | `C-65` exige offline; `V-18` exige llave; son incompatibles | **BLOQUEANTE** (imposibilidad lógica) |

### F7 · Caja, Gastos y Consignaciones

| OQ-F | Pregunta | Decisión Requerida | Impacto |
|---|---|---|---|
| **OQ-F-45** | **Relación entre cajas: gestor, unidad, PIX** — `V-26` diferida a llamada | El circuito completo del dinero es la operación nº 1 del negocio | **BLOQUEANTE** |
| **OQ-F-48** | **Consignación** — ¿Cómo se registra la entrega de efectivo del gestor a la empresa? ¿Requiere comprobante y confirmación? | `V-26` diferida; necesario para cerrar caja | **BLOQUEANTE** |
| **OQ-F-50** | **"Dinero pendiente"** — ¿Qué es exactamente en el contexto del cierre? | `V-26` diferida; aparece en el reporte pero sin definición | **BLOQUEANTE** |
| **OQ-F-51** | **Fondeo de efectivo** — ¿El cobrador puede prestar sin tener efectivo en mano? ¿El admin puede enviar fondos? | `V-26` diferida; impacta el flujo de desembolso | **BLOQUEANTE** |

### F8 · Cierre de Caja

| OQ-F | Pregunta | Decisión Requerida | Impacto |
|---|---|---|---|
| **OQ-F-52** | **🔴 Archivo Excel de cierre actual** — Cliente prometió entregarlo dos veces y no llegó | Requisito es *"idéntico al formato actual"* — sin la plantilla no se puede construir | **BLOQUEANTE** (`V-25`, `V-26` diferidas a llamada) |
| **OQ-F-54** | **Nivel de consolidación del cierre** — ¿Por gestor, por unidad, consolidado por empresa? | `V-09` da la jerarquía pero no declara el nivel de corte del cierre | Medio (consolidación) |

**Total P0 bloqueantes en F**: 5 (`OQ-F-42`, `OQ-F-45`, `OQ-F-48`, `OQ-F-50`, `OQ-F-51`, `OQ-F-52`)

---

## 3. P0 Funcionales Parciales — Necesitan Aclaración

### Reglas de Negocio Que Cambian

| OQ-F | Cambio | Estado Anterior | Nuevo (Cliente) | Impacto |
|---|---|---|---|---|
| **OQ-F-23** (Renovación) | Bloqueo 100% pagado | Hard block | Soft block + autorización (comentario #2 demo) | Flujo debe permitir excepción |
| **OQ-F-77** | Fecha del pago offline | Sin declarar | "Pendiente de definir" (banner en diseño) | Crítico para caja |

### Permisos (OQ-F-1, Matriz Completa)

El cliente introduce en `D-05` un modelo de permisos **asignables por recurso**:

| Nivel | Estado | Necesario para |
|---|---|---|
| **Roles fijos** (3 actuales: Admin, Socio, Cobrador) | ✅ Cerrado | v1 |
| **Administradores secundarios** | 🟡 Parcial en `OQ-F-1`, `OQ-F-4` | Delegar permisos |
| **Matriz de permisos por recurso** | ⬜ Abierta (`CX-40`, `OQ-F-106`, `B-13`) | **P0 — es el mayor motor de alcance** |

Decisión pendiente: ¿**roles fijos con excepciones puntuales** (simple, ~1 semana) o **matriz completa de permisos** (complejo, ~3 semanas)?

---

## 4. P0 No Funcionales — Afectan el Design

| OQ-N | Pregunta | Estado | Bloqueante de |
|---|---|---|---|
| **OQ-N-20** 🔴 | **Fraude interno: los dos controles antifraude dependen de WhatsApp** | Sin resolver | v1 completa — si no hay WhatsApp, ¿hay antifraude? |
| **OQ-N-22** | **Base legal del tratamiento de datos** (fotos de identidad, GPS) | ⬜ Abierta | LGPD / cumplimiento |
| **OQ-N-31** | **Versión mínima de Android/iOS** | ⬜ Abierta | Arquitectura móvil (TLS 1.3 depende de esto) |
| **OQ-F-64** | **Motor de reglas: ¿configurable o fijo?** | ⬜ Abierta | Impacta 10x esfuerzo |

---

## 5. Que SÍ se Puede Cerrar Hoy (Síntesis)

### Deducibles del Material + Feedback + Decisions

| OQ-F | Pregunta | Respuesta Implícita | Fuente | Acción |
|---|---|---|---|---|
| **OQ-F-108 a 114** | Códigos, alias, ordenamiento | Confirmadas por cliente (demo comments) | D-06 | Escribir especificación |
| **OQ-F-22** | **Estados del préstamo** | Temporal, Activo, En mora, Castigado, Cancelado, Renovado, Refinanciado | `C-27`, `V-12`, `V-17` | Escribir máquina de estados |
| **OQ-F-74/75** | **Operaciones offline** | Registrar pago, no pago, visita, foto — NO crear venta nueva sin llave | `C-65`, `V-03`, `V-18` | Escribir lista y excepciones |
| **OQ-F-79** | **1 dispositivo por ruta** | ✅ Confirmado como requisito de negocio | `C-70`, `V-36` | Cerrar |
| **OQ-F-80** | **Sincronización manual** | ✅ Eliminar (cliente pide automática) | `V-13` | Cerrar |
| **OQ-F-81** | **Firma digital** | Probable: imagen (no electrónica legal) | `V-29` (*"alegal"*) + `V-35` (QR sustituye) | Cerrar como imagen simple |
| **OQ-F-89/90** | **Qué se audita** | Solo cambios, sin valor anterior (porque montos no se editan) | `V-32`, `V-33` | Cerrar |
| **OQ-F-91/92** | **Acceso a auditoría** | Admin + socios, inalterable para todos | `V-34`, `V-35` | Cerrar |

---

## 6. Preguntas Críticas para Cliente (Prioridad)

**Urgencia P0** — Responder estas detiene el planning de v1:

1. **`OQ-F-45/48/50/51`** — Circuito del dinero (fondeo, consignación, "dinero pendiente") → cliente prometió `V-26` en llamada
2. **`OQ-F-52`** — Excel de cierre actual (ya pedido dos veces, no entregó)
3. **`OQ-F-42`** — 🔴 Llave offline — **es imposible lógico**, necesita resolución de producto
4. **`OQ-F-64`** — Motor de reglas ¿configurable o fijo? (diferencia de esfuerzo 10x)
5. **`OQ-F-106`** — Permisos asignables: ¿matriz completa o roles fijos con excepciones?
6. **`OQ-N-31`** — Versión mínima Android/iOS (bloquea decisión de TLS)

**Urgencia P1** — Completan el producto pero no frenan v1:

7. `OQ-F-24` — Refinanciación vs renovación
8. `OQ-F-36` — Catálogo de motivos de no pago
9. `OQ-F-40` — Expiración y unicidad de llave
10. `OQ-N-22` — Base legal del tratamiento de datos

---

## 7. Plan de Completamiento (Hoy)

### Fase 1 — Escribir lo Cerrado (1–2 horas)
Documentar sin respuesta del cliente:

- ✅ `OQ-F-108 a 114` — Integrar especificaciones del feedback (códigos, alias, ordenamiento)
- ✅ `OQ-F-22` — Máquina de estados del préstamo
- ✅ `OQ-F-74/75` — Lista de operaciones offline
- ✅ `OQ-F-79/80/81` — Confirmar: 1 dispositivo, sin sincronización manual, firma = imagen
- ✅ `OQ-F-89/90/91/92` — Auditoría: solo cambios, acceso controlado, inalterable

### Fase 2 — Aclarar Bloqueantes (Antes de Llamada)
Preparar preguntas concretas para el cliente:

```markdown
## Llamada de Aclaraciones — Preguntas Prioritarias

### P0 — Operación Base
1. **Circuito del dinero** (`OQ-F-45/48/50/51`):
   - ¿Cajas por gestor, por unidad, global?
   - ¿Cómo se registra la consignación (entrega de efectivo)?
   - ¿Qué es "dinero pendiente"?
   - ¿Puede un gestor prestar sin tener efectivo en mano?

2. **Cierre de caja actual** (`OQ-F-52`):
   - Compartir el Excel de cierre del día (con datos reales o anónimos)

3. **Llave offline** (`OQ-F-42` — IMPOSIBILIDAD LÓGICA):
   - "El cobrador en cuota 5+ necesita llave para registrar pago"
   - "El cobrador sin señal debe poder trabajar todo el día"
   - ¿Si no hay señal y necesita llave, qué hace?

### P0 — Alcance
4. **Motor de reglas** (`OQ-F-64`):
   - ¿Las reglas de alertas (7 configurables) se definen dentro de la app por admin, o las programa el equipo?

5. **Permisos asignables** (`OQ-F-106`):
   - ¿Roles fijos (3) con excepciones puntuales, o matriz completa por recurso?
   - ¿Sobre qué recursos? (aprobar ventas, llaves, ver socios, crear usuarios, etc.)

### P0 — Técnico
6. **Versión mínima Android/iOS** (`OQ-N-31`):
   - ¿El parque tiene dispositivos Android < 10? ¿iPhone < 13?
```

### Fase 3 — Integrar en open-questions.md
Una vez respondidas, actualizar el registro de preguntas y cerrar cobertura.

---

## 8. Cobertura Proyectada

**Hoy (Fase 1 + Fase 2 respuestas):**
- Funcional: **~60 %** (34 cerradas + ~14 nuevas deducibles)
- No funcional: **~70 %**
- Global: **~65 %** → **listo para join**

**Después del join (business + technical + funcional integrados):**
- **85–90 %** global → **listo para scope de v1**

---

## Resumen Ejecutivo

| Bloque | Cerrado | Abierto | Parcial | % |
|---|---|---|---|---|
| **Funcional** | 34 | 46 | 27 | 44% |
| + D-06 (feedback) | +7 que se pueden cerrar | -7 abiertos | | |
| **Proyectado hoy** | **41** | **39** | **27** | **59%** |
| **No funcional** | 23 | 11 | 14 | 63% |
| **Technical** (completo) | 21 | 2 | 2 | 85% |
| **Business** | 13 | 1 | 4 | 83% |
| **GLOBAL PROYECTADO** | **98** | **53** | **47** | **65%** |

**Bloqueantes de v1**: 6 preguntas (OQ-F-42, 45, 48, 50, 51, 52 + OQ-F-106 + OQ-N-31)

**Siguientes pasos**:
1. ✅ Documentar lo cerrado (hoy, ~2 h)
2. 📞 Llamada de aclaraciones con cliente (6 preguntas P0)
3. 🔗 **Join stage** — reconciliar business + technical + funcional
4. 📋 Roadmap v1 + v2

