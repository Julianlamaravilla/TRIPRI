# Business — Answers History (append-only)

Durable record of every validated answer of the Business role. Never rewrite or truncate.
Control tokens and IDs stay in English; content follows the user's language (Spanish).

---

## [Pre-interview Decision] D-01 · Alcance del manejo de dinero

**Timestamp**: 2026-07-28T16:56:09Z
**Origen**: respuesta directa del usuario (fuera de lote, antes de iniciar la entrevista de negocio)
**Estado**: CONFIRMADA — restricción de alcance de nivel producto
**Afecta a**: `OQ-F-34`, `OQ-F-35`, `OQ-B-4`, `OQ-N-24`, `OQ-N-34`, `OQ-F-38`, `OQ-F-70`, y toda la §1 de `technical-research/recomendacion-tecnica.md`

### Entrada literal del usuario

> "no se va a manejar dinero real en cuento a mover transacciones o que el sistema reciva dinero, como lo haría una wallet o fintecht o entidad bancaría, la aplicación tanto web como móvil utiliza la información de transacciones moneda o PIX para representar la en las gestiónes y flujos de cobranza, no es que reciba dinero de los cobros de los gestores de cobranza.
>
> El único dinero que se podría mover a travez del aplicativo (ni siquiera en el móvil solo en la web) es la gestión de cobros para usar el software a crear independientemente del modelo de cobranza."

### Decisión normalizada

1. **El sistema NO es custodio de fondos.** No recibe, no retiene, no transfiere ni liquida dinero de los cobros. No es wallet, no es fintech, no es entidad bancaria, no es medio de pago.
2. **Efectivo y PIX son datos, no flujos de fondos.** Tanto la web como el móvil registran la *información* de la transacción (monto, medio, titular, fecha, comprobante) para **representarla** en la gestión y en los flujos de cobranza. El dinero físico o el PIX se mueven **fuera del sistema**, entre el cliente final, el gestor y la empresa.
3. **Único flujo de dinero real dentro del aplicativo:** el **cobro por el uso del software** (facturación/suscripción del propio producto), **solo en la aplicación web** — nunca en la app móvil —, e **independiente del modelo de cobranza** del negocio de préstamos.

### Consecuencias declaradas (derivadas, no dichas por el usuario)

| Ámbito | Consecuencia |
|---|---|
| Regulatorio | No se requiere licencia de medio de pago / IP (instituição de pagamento) / PSP para la operación de cobranza. La regulación aplicable sigue siendo la de **la actividad de préstamo** (`OQ-N-23`) y la de **protección de datos** (`OQ-N-21`), no la de servicios de pago. |
| PCI-DSS | Fuera de alcance para el núcleo operativo. Solo aplica al módulo de facturación del SaaS, y **reducible a SAQ-A** si los datos de tarjeta nunca tocan el sistema (checkout hospedado del proveedor). |
| Integración bancaria | No hay obligación de integración con banco para los cobros. Una conciliación de PIX en **modo lectura** sigue siendo posible como mejora, pero es opcional (`OQ-F-34` residual). |
| Ledger / libro mayor | **No cambia.** Sigue siendo obligatorio: es el registro contable de operaciones y el mecanismo antifraude interno (`OQ-N-20`). Un descuadre sigue siendo dinero real perdido para la empresa, aunque el sistema no lo custodie. |
| App móvil | Al no procesar pagos, la app queda fuera de las reglas de compras/pagos in-app de las tiendas — argumento adicional a favor en `OQ-N-34`. |
| Nuevo alcance | Aparece un módulo de **Facturación y Suscripciones** (web-only) que antes no existía en ningún documento: preguntas nuevas `OQ-B-18`, `OQ-F-93` a `OQ-F-98`, `OQ-N-42`, `OQ-N-43`, `OQ-T-26`. |

### Lo que esta decisión NO resuelve

- El modelo de cobro del software (`OQ-B-4`, ahora **P0**) y si entra en el MVP (`OQ-B-18`).
- Si el registro de PIX es 100 % manual o admite conciliación de solo lectura (`OQ-F-34`, degradada a P1).
- Si el cobro del software es autoservicio con pasarela o factura manual fuera del sistema (`OQ-F-94`).

---

## [Batch] D-02 · Cuestionario v2 respondido por los interesados

**Timestamp**: 2026-08-01T15:27:21Z
**Origen**: `interview/respuesta-cuestionario-cliente.docx`, entregado por el usuario
**Estado**: INCORPORADO — 117 preguntas procesadas
**Registro literal**: `client-answers-2026-08-01.md` (en esta misma carpeta)

### Método

El documento volvió **con las respuestas resaltadas**, no escritas en `[Answer]:`. Se leyó
`word/document.xml` detectando `w:highlight` sobre cada opción. Donde la opción marcada y el
texto libre de `SU RESPUESTA:` discrepan, **prevalece el texto libre** y la discrepancia se
registra como contradicción.

**Dos manos**: 191 marcas en verde y 8 en cian (C-44, C-51, C-53, C-54, C-58, C-61, C-63,
C-64 — todas en caja y autorizaciones). En C-51, C-58 y C-61 la marca cian contradice a la
verde. Sin regla de desempate declarada; se pregunta en V-00 del cuestionario v3.

### Resultado

| | Antes | Después |
|---|---|---|
| Preguntas abiertas | 195 | **124** |
| Contradicciones | 10 | **18** |
| Cobertura global | ~37% | **~65%** |

- **78** preguntas resueltas directamente, **11** más al cruzar dos respuestas.
- **Cerradas**: `CX-4`, `CX-5`, `CX-6`, `CX-7`, `CX-9`, `CX-10`; 8/18 `OQ-B`; 62/98 `OQ-F`;
  9/43 `OQ-N`. `CX-8` **sustituida** por `CX-11`. `CX-1` resuelta con reserva (`CX-19`).
- **Abiertas nuevas**: `CX-11` … `CX-25` (11 de ellas P0).
- **Sin abrir**: los 26 `OQ-T` — el cuestionario era de negocio.

### Lo que este lote deja cerrado y ya no se vuelve a preguntar

Las 12 reglas ejecutables están enumeradas en `open-questions.md` §0 D-02. Las tres que más
cambian el diseño:

1. **Interés fijo sobre lo prestado, cuota indivisible, sin mora y sin descuento por
   anticipo** (C-10, C-14, C-19, C-21, C-30). El cliente aportó un ejemplo numérico que cuadra:
   1.000 → 24 cuotas diarias de 50 → 1.200. Toda la aritmética financiera queda definida.
2. **Pago parcial con contador fraccionario de cuotas** (C-18): 25 sobre una cuota de 50 deja
   **19,5 de 20 cuotas**. Es el requisito de cálculo más singular y no aparecía en ninguna fuente.
3. **El producto es un sistema antifraude**, no un CRM de cobranza (C-99). Los dos fraudes están
   nombrados con su control: **QR al WhatsApp del cliente para liberar el dinero** de una venta,
   y **extracto por WhatsApp a cada cliente al cierre de caja** con canal de reclamo al supervisor.
   Esto reordena la prioridad de todo lo demás.

### Riesgos que el lote destapa

- **`CX-16` es el más grave**: los dos controles antifraude del punto 3 dependen de la **API de
  WhatsApp Business**, y en C-75 declararon tener solo la app normal. El trámite tarda semanas.
- **`CX-11`**: el país nunca se declaró. Todo indica Brasil (PIX, "reales") pero Brasil no está
  en su lista de expansión y el idioma quedaría en portugués. Bloquea las 4 respuestas legales
  (C-93, C-94, C-95, C-98) y la nota fiscal (C-115).
- **`CX-20`**: piden migrar todo el histórico de TryController, que no permite exportar.
- **`CX-12` + `CX-13`**: entre el descuadre de caja y la fecha de los pagos offline, hoy el
  cierre diario **no puede cuadrar** con las reglas tal como quedaron.

### Derivados

- `interview/client-questionnaire-v3.md` + `.docx` — **54 preguntas** (V-00 + V-01…V-54):
  14 contradicciones, 10 respuestas a medias, 7 pendientes, y **23 que nunca se preguntaron
  en la v2** — auditoría (`OQ-F-89`…`OQ-F-92`), seguridad y sesión (`CX-3`, `OQ-N-15`,
  `OQ-N-16`, `OQ-F-5`), reportes MVP (`OQ-F-55`, `OQ-F-88`), alertas y continuidad (`OQ-N-9`,
  `OQ-N-10`, `OQ-N-12`, `OQ-N-35`, `OQ-N-36`), rendimiento percibido (`OQ-N-5`, `OQ-N-6`,
  `OQ-N-32`, `OQ-N-33`), distribución en tiendas (`OQ-N-34`, `OQ-N-39`) y el bloque SaaS
  (`OQ-N-27`, `OQ-N-29`, `OQ-N-30`, `OQ-N-42`).
  Cobertura proyectada si se responde completo: **~90%**; lo restante es la entrevista técnica.

---

## [Team Position] D-03 · Alcance del MVP — app completa + web mínima

**Timestamp**: 2026-08-01T15:27:21Z
**Origen**: sesión corta con el líder de Discovery, tras procesar D-02
**Estado**: **RECOMENDACIÓN DEL EQUIPO — pendiente de confirmación del cliente** en `V-05`
**Resuelve**: `CX-15` (C-107 «primero la app» vs C-108 «la app puede esperar»)
**Base**: C-109, donde el cliente delega explícitamente esta decisión — *"eso lo tendríamos
que definir con usted, que tiene el conocimiento"*

### Decisión

La primera entrega es **la app del cobrador completa más una web mínima**, no una de las dos.

**En la v1:**

| Plataforma | Alcance |
|---|---|
| **App (cobrador)** | Completa: lista de ruta del día, registro de pagos con contador fraccionario (C-18), medios DINERO / TRANSFERENCIA con comprobante (C-23), «no pago» con motivo y compromiso (C-26), caja de 3 paneles con cierre a pendientes = 0 (C-50), trabajo sin señal (C-65), escaneo del QR de liberación (C-31), gastos con soporte (C-54) |
| **Web (administrador)** | Mínima, solo lo que la app necesita para funcionar: crear/editar clientes, aprobar ventas, aprobar gastos, emitir llaves de autorización (C-61), abrir cajas (C-50), ver el cierre diario y consolidado (C-56) |

**Fuera de la v1** (todo ya aceptado por el cliente o coherente con su propia secuencia):
asistente de IA (C-87, C-108), reportes avanzados y comparativos (C-108), módulo de
facturación del software (C-112 lo pone explícitamente en una fase posterior), mapa con
orden geográfico de ruta (C-73).

### Razonamiento

1. **Los dos fraudes de C-99 ocurren en la calle.** Una web sin app no ataca ninguno de los
   dos, y son lo que el cliente describió como el problema central del negocio.
2. **Una web sola no elimina el Excel.** El objetivo declarado no se cumple sin la app.
3. **Pero una app sola tampoco funciona.** El flujo de C-31 tiene al administrador aprobando
   antes de liberar el dinero; sin web, la app queda inutilizable. Lo mismo con las llaves
   (C-61) y la apertura de caja (C-50).

### Riesgo asociado

Este alcance **depende por completo de `CX-16`**: el QR de liberación (C-31) y el extracto al
cierre de caja (C-99) requieren la **API de WhatsApp Business**, que el cliente no tiene
(C-75). Si el trámite con Meta no arranca de inmediato, **la v1 se entrega sin ninguno de los
dos controles antifraude** y el producto pierde su razón de ser. Se escala al cliente como
**bloqueante nº 1** en `V-06`.

---
