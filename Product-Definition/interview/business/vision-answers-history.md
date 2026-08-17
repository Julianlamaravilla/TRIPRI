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

## [Batch] D-04 · Cuadernillo "Negocio y Visión" respondido — 2026-08-07

### Método

Archivo devuelto: `context-discovery/notebooklm/04-client/Negocio/Negocio_respuestas.docx`.
**9 preguntas** (`B-01`…`B-09`). Extracción por parseo de `word/document.xml`: **15 marcas de
resaltado, todas verdes** (`w:highlight val="green"`). **Un solo color ⇒ un solo respondiente**, sin
la ambigüedad de autoría que tuvo `D-02` (verde 191 / cian 8).

Los campos `[Answer]:` en prosa quedaron **casi todos vacíos**: solo `B-04` y `B-05` traen texto.

### Respuestas registradas

| ID | Pregunta | Respuesta | Efecto |
|---|---|---|---|
| **B-01** | Nombre del producto | **C — "propongan ustedes 3 opciones y elegimos"** | 🟡 No cierra: delega. Acción nuestra |
| **B-02** | Modelo de cobro del software | **C — semanal, por planes escalonados** | 🟡 Modelo fijado; **precios y planes sin indicar** |
| **B-03** | Monto de cartera actual | **A — menos de 100.000 reales** | ✅ Cierra el volumen |
| **B-04** | Métricas de éxito | **X** — *"eso depende del cobrador, no tenemos una cifra"* | ⬜ **Tercer intento fallido** |
| **B-05** | Presupuesto mensual | **X** — *"ya definimos el presupuesto por llamada, estamos dándole vueltas a las mismas preguntas que ya resolvimos"* | 🟡 Existe, **fuera del registro** |
| **B-06** | ¿IA en la primera entrega? | **X** — *"si usted puede tener todo en la primera entrega garantizando que todo queda bien sin error, si no va paso a paso respetando su estructura y conocimiento"* | 🟡 **Delega, no decide** |
| **B-07** | Cobro del software en v1 | **X** — *"ya lo definimos, lo dejamos para después de que la app pase la fase de prueba"* | ✅ **Cierra `OQ-B-18`** |
| **B-08** | Capacidades no comprometidas | Scoring **más adelante** · Portal cliente **más adelante** · Seguro de repatriación **más adelante** · **Contrato con firma en móvil: NO** · Instancia separada **más adelante** | ✅ Cierra `OQ-B-16` |
| **B-09** | ¿Por qué no seguir con TryController? | **A — solo TryController evaluado; falta el control antifraude y poder sacar los datos** | ✅ Cierra `OQ-B-17` |

### Lo que este lote deja cerrado

1. **Cartera < 100.000 reales** (`B-03`). Con `V-09` (~2.000 clientes, ~50 rutas) el
   dimensionamiento de negocio queda completo. **Ticket medio ≈ 50 reales por cliente** — préstamos
   muy pequeños, coherente con cobranza diaria puerta a puerta.
2. **El módulo de facturación no entra en la v1** (`B-07`). Se factura por fuera y se activa la
   cuenta a mano. **Resuelve la contradicción con `V-51`** (autoservicio), que exigía cobrar dentro
   del sistema desde el día 1.
3. **Cinco capacidades quedan explícitamente fuera de la v1** (`B-08`), y **una queda descartada
   del todo**: generación de contrato con plantilla legal y firma en el móvil → **No**.
4. **No se evaluó ninguna alternativa a TryController** (`B-09`). Lo que falta es exactamente lo ya
   sabido: control antifraude y exportación de datos.

### Riesgos que el lote destapa

1. 🔴 **No hay métrica de éxito, al tercer intento** (`C-07` → `V-22` → `B-04`). *"Depende del
   cobrador, no tenemos una cifra"* no es medible. **Consecuencia real: dentro de seis meses no
   habrá forma comprobable de decidir si el proyecto salió bien.** No se puede cerrar
   `vision-document.md` §Success Metrics con contenido válido.
2. 🔴 **El presupuesto se acordó en una llamada que no está registrada** (`B-05`). El cliente lo da
   por resuelto; **el registro escrito no lo tiene**, y `OQ-N-40` sigue sin cifra. Riesgo de
   desacuerdo posterior sobre quién absorbe los ~$430–470/mes, de los cuales **WhatsApp es el 61 %**.
3. 🔴 **`B-06` no decide: delega.** *"Si usted puede tener todo… si no, paso a paso"* devuelve al
   desarrollador una decisión de alcance que sólo el cliente puede tomar, y lo hace justo donde
   `CX-27` ya estableció que **el alcance comprometido no cabe en un desarrollador**. La
   contradicción `CX-30` (IA en el plan de entrada vs. IA fuera de la v1) **sigue abierta**.
4. ⚠️ **`B-02` fija el modelo pero no el precio.** Semanal + planes escalonados, sin importes. Con
   costes de ~$43/empresa/mes a 10 empresas, **no se puede saber si el precio cubre el coste**.
   Enlaza con `OQ-N-41` (techo de coste por tenant).
5. ⚠️ **`B-09` dejó sin responder la pregunta más valiosa**: *"¿qué hace bien TryController que no
   se puede perder?"*. Lo que hoy funciona a diario y no se nombre, **corre el riesgo de no estar**.

### Señal de proceso, registrada literal

> *"estamos dándole vueltas a las mismas preguntas que ya resolvimos"* (`B-05`)

El cliente percibe repetición. Es en parte cierto —`B-04` y `B-05` sí se habían preguntado antes—
pero se repitieron **porque las respuestas anteriores no eran utilizables** (*"por la cantidad de
suscriptores"*, sin cifra). **Consecuencia operativa: no volver a preguntar por escrito lo que ya
falló dos veces.** Las tres pendientes reales —métrica de éxito, presupuesto por escrito y la
decisión de `B-06`— deben resolverse **en llamada, con alguien tomando nota**, no en otro
cuadernillo.

---

---

# D-05 — Aclaraciones del cliente en llamada, 2026-08-08

**Procedencia**: 11 puntos transmitidos por el usuario tras una conversación con el cliente. **No es
un cuestionario respondido**: son notas de una llamada, así que **lo literal es la nota, no la
palabra del cliente**. Donde la nota es ambigua se registra la ambigüedad en vez de resolverla.

## Lo que cierra

### ✅ `CX-30` — CERRADA. La IA es fase 2, no el plan de entrada

> *"En fase futura: Inteligencia Artificial para F2."*

Cierra la contradicción **P0** abierta el 2026-08-02 durante T11, **a favor de `D-03` y de `C-108`**
(*"la IA puede esperar"*). Lo que la había abierto era información **de segunda mano** —el usuario
declaró *"por lo que me dieron a entender"*—, y ahora la fuente autoritativa la desmiente.

**Consecuencias**: `OQ-T-15` (proveedor de LLM) **vuelve a P2**, fuera de v1. Las siete preguntas de
IA (`OQ-F-67`…`OQ-F-73`) dejan de ser bloqueantes y pasan a diferidas — **una de las tres
agrupaciones que hundían la cobertura funcional deja de estar bloqueada**. Y el alcance **se reduce**
justo donde `CX-27` decía que no cabía.

### ✅ `CX-26` — CERRADA del todo. El flujo de reautorización existe y está descrito

> *"La aplicación para las descargas de los gestores genera un PIN del app y el administrador lo
> aprueba y genera una contraseña."* · *"El PIN del App muestra el modelo del dispositivo."* ·
> *"El Administrador tiene la capacidad de desvincular o vincular."*

`CX-26` quedó **confirmada** el 2026-08-02 por `V-36` en cuanto a la *intención* (vinculación de
dispositivo contra robo de cartera), pero seguía con un pendiente explícito: **el flujo de
reautorización**, sin el cual *"un teléfono roto en sábado deja al gestor sin trabajar"*. **Ese
pendiente queda cerrado**, y el flujo que describe el cliente **encaja exactamente con el diseño de
T17**, sin cambiarlo:

| Paso del cliente | Traducción técnica ya decidida (T17 / T30) |
|---|---|
| El gestor instala la app; la app **genera un PIN** | Alta de dispositivo: el teléfono **genera su par de claves** y presenta un código de enrolamiento corto |
| El PIN **muestra el modelo del dispositivo** | La solicitud viaja con metadatos del aparato para que el administrador **vea qué teléfono está aprobando**. ✅ Técnicamente viable —a diferencia del IMEI— vía `expo-device`; es dato declarado por el dispositivo, útil para que un humano reconozca el aparato, **no una prueba criptográfica** |
| El **administrador lo aprueba** | Es literalmente el *"evento de auditoría con aprobación explícita de un administrador"* que T17 exigía |
| El sistema **genera una contraseña** | La contraseña que `C-70`/T17 pedían en el alta, emitida por el servidor en vez de elegida por el gestor — **mejor**: elimina contraseñas débiles elegidas por un usuario con poca soltura técnica (`C-106`) |
| El administrador **vincula o desvincula** | Revocar = borrar la clave pública. Efecto inmediato (T17) **y además deja la SQLite local ilegible** (T30, trampa 3) |

> 🔑 **Hallazgo**: el cliente describió, sin saberlo, el mismo mecanismo que el rol técnico había
> diseñado el 2026-08-01 para traducir su requisito no implementable de *"vincular el usuario a la
> IP del celular"*. **La traducción queda validada por la fuente**, no solo aceptada por el equipo.

### ✅ `C-111` reconfirmado — el piloto arranca con una ruta

> *"El plan piloto solo va a tener pero no limitado a una ruta."*

Coincide con `C-111` (*"arranque con una sola ruta piloto"*). La segunda mitad de la frase se lee
como **restricción de diseño**: el piloto **opera** una ruta, pero el sistema **no debe quedar
limitado** a una. ⚠️ Lectura del analista, no del cliente → se pregunta (`B-11`).

**Es la mejor noticia del lote para `CX-27`**: una ruta ≈ 1 gestor y ~40 clientes (`V-09`) reduce el
v1 real a una fracción de lo dimensionado.

### 🟡 `CX-14` y `CX-34` — candidatas a cerrar: el "supervisor" podría ser el administrador secundario

`CX-14` y `CX-34` giran alrededor de un rol fantasma: `C-31` dice *"el supervisor autoriza el
valor"*, `V-02` y `V-17` lo vuelven a nombrar, y `V-04` lo negó (*"nos equivocamos al escribir
'supervisor'"*). **La figura del administrador secundario encaja en ese hueco**: alguien por debajo
del administrador principal, con permisos asignados, que autoriza. **No se cierran aquí** porque el
cliente no hizo la conexión — se pregunta explícitamente (`B-12`).

## Lo que abre

### 🔴 `CX-40` (P0) — El modelo de roles deja de ser tres roles fijos

> *"El Administrador Principal tiene control sobre socios y sobre gestores."* · *"El Administrador
> puede crear administradores secundarios y hacer asignaciones."* · *"El Administrador principal va
> a tener acceso total al sistema de su suscripción. Tiene la capacidad de poder asignar permisos
> sobre los recursos para los demás usuarios."*

**`C-36` cerró `CX-6` declarando exactamente tres roles con permisos ya delimitados.** Esto lo
rompe en dos direcciones a la vez, y la segunda es la cara:

1. **Aparece un cuarto nivel** — administrador secundario, creado por el principal. Cuatro niveles
   jerárquicos donde había tres planos.
2. 🔴 **Los permisos dejan de estar fijados en el código y pasan a ser configurables por tenant.**
   *"asignar permisos sobre los recursos para los demás usuarios"* no es un rol: es un **sistema de
   autorización por recurso**, administrado por el cliente, distinto en cada suscripción.

**Por qué esto es lo más caro del lote.** Tres roles fijos son tres constantes y un `if`. Permisos
asignables por recurso son: un modelo de datos de permisos, una interfaz de administración para
concederlos, comprobación en **cada** endpoint, y —lo que de verdad cuesta— **una matriz de prueba
que ya no es de 3 casos sino combinatoria**. Toca directamente decisiones ya cerradas: **T17**
(servicio de autenticación propio — ahora también de *autorización*), el aislamiento por **RLS**
(que resuelve *entre* tenants, no *dentro* de uno) y **T13**, que descartó GraphQL en parte por
*"el riesgo añadido de la autorización a nivel de campo"* — riesgo que ahora entra por otra puerta.

**Choca de frente con `CX-27`.** Es exactamente el patrón de `CX-30`: el alcance **crece** justo
después de establecer que no cabe. La diferencia es que aquí la fuente **sí** es autoritativa.

**Lo que hay que decidir antes de planificar** (`B-13`): ¿roles fijos **con excepciones puntuales**
—el 90 % del valor por el 10 % del coste— o **matriz completa** de permisos por recurso?

### 🔴 `CX-42` (P0) — El precio declarado no cubre el coste, salvo en una única lectura

> *"En la fase 1 = plan piloto todas las funcionalidades del plan de 35 reales, básico."*

**Es el primer precio que aparece en todo el Discovery.** `OQ-B-4` y `OQ-N-41` llevaban abiertas
desde el principio precisamente por esto. Cruzado con el coste ya conocido (~$430–470/mes para 10
empresas ⇒ **~$43–47 por empresa/mes**, del cual **WhatsApp es el 61 %**):

| Lectura de "35 reales" | Ingreso/empresa/mes | Coste con WhatsApp | Coste sin WhatsApp |
|---|---:|---:|---:|
| **Mensual** | ~$6 | 🔴 pierde ~$37 | 🔴 pierde ~$11 |
| **Semanal** (lo que fijó `B-02`) | ~$28 | 🔴 pierde ~$15 | ✅ margen ~+$10 |

*(Conversión aproximada a ~5,5 BRL/USD; el orden de magnitud no depende del tipo de cambio exacto.)*

**Solo una casilla de cuatro es viable: semanal y sin WhatsApp en el plan básico.** Y esa casilla es
consistente con la escala de planes que se reportó en `CX-30` (*"el plan siguiente tiene AI +
mensajes de WhatsApp"*), o sea: **el básico no lleva WhatsApp**.

### 🔴 Y de ahí sale el hallazgo mayor del lote

**Si la fase 1 = plan básico, y el plan básico no incluye WhatsApp, entonces la fase 1 sale sin los
dos controles antifraude** — el QR que libera el dinero y el extracto al cliente final (`C-99`).

`D-03` ya advirtió eso mismo, pero como *consecuencia de `CX-33`* (los suscriptores no pueden
obtener la API de Meta). **Ahora se llega al mismo agujero por un camino independiente: la
segmentación de precios.** Dos causas distintas, el mismo resultado — **el producto cuya razón de
ser es el antifraude arranca sin antifraude**, y esta vez por diseño comercial, no por un obstáculo
externo.

**Esto no se resuelve en el registro: es una decisión de producto** (`B-14`).

### ⚠️ `CX-41` (P1) — Los términos y condiciones no logran lo que el cliente espera de ellos

> *"El aplicativo debe manejar términos y condiciones de uso de la plataforma, para evitar que nos
> puedan vincular con acciones delictivas."*

**El requisito es válido y se acepta**: aceptación de términos versionada, con registro de quién
aceptó qué versión y cuándo, en el libro de auditoría. Es además **necesario para LGPD** — T21 ya
había listado *"base legal"* como exigencia sin cubrir, y esto es parte de esa pieza. Se registra
como `OQ-F-105`.

**Pero el motivo declarado no se consigue así, y conviene decirlo una vez.** Unos términos de uso
regulan la relación entre la plataforma y sus usuarios; **no determinan la responsabilidad frente a
terceros ni frente a una autoridad**, y las tiendas de aplicaciones evalúan **la actividad real**,
no el texto legal. El contexto lo hace concreto y no teórico: `V-29` declara que la actividad *"no
está regulada por ningún país, es algo alegal"*, `CX-33` que los suscriptores **no son empresas
formales**, y `mobile-platform-constraints.md` §Relación con el cuestionario ya avisaba de que
**Google Play aplica políticas restrictivas a las apps de préstamos**, incluido el acceso a fotos y
ubicación precisa —que este sistema usa de forma central— con `V-49` **todavía sin resolver**.

**Esto no es una pregunta de producto: necesita asesoría legal en Brasil.** Se suma a los cuatro
desconocimientos legales que el propio cliente ya declaró (`C-93`, `C-94`, `C-95`, `C-98`).

### 🟡 Fase futura: comparativo mensual de cobranza por gestor

> *"En fase futura: comparativos de las cobranzas de los gestores por mes para los gestores de
> cobranza."*

Nueva funcionalidad, **explícitamente diferida**. Nota de lectura: el destinatario declarado son
**los propios gestores** (no el administrador), lo que la convierte en visibilidad de desempeño
entre pares, no en un reporte de dirección. Enlaza con `C-82` (definición de indicadores, diferida a
llamada). Se registra en §Future Extensions, no en el MVP.

### 🟡 `OQ-F-99` sube de prioridad, no de estado

> *"El Administrador tiene la capacidad de desvincular o vincular."* · *"Solo se puede un usuario por
> mobile."*

`OQ-F-99` (**P0, abierta**) pregunta qué pasa con las operaciones **sin sincronizar** de un
dispositivo revocado. Hasta hoy desvincular era un evento excepcional; **ahora es una acción
ordinaria de administración**, así que el caso deja de ser raro y **se vuelve rutinario**. La
propuesta técnica registrada (cuarentena para revisión del administrador, en vez de rechazar y
destruir el registro de dinero que sí se movió) sigue en pie y sigue sin decidirse.

*"Solo un usuario por móvil"* añade la **dirección inversa** de `C-37`/`C-70`: no solo un cobrador
tiene un teléfono, sino que **un teléfono aloja exactamente un usuario**. Ambas direcciones quedan
declaradas y el modelo de vinculación es 1:1 estricto.

## Preguntas que este lote deja abiertas — se plantean como `B-10`…`B-15`

Ver `open-questions.md`. Las tres que bloquean planificación: **`B-10`** (¿35 reales semanal o
mensual?), **`B-13`** (¿roles fijos con excepciones o matriz de permisos?) y **`B-14`** (¿la fase 1
sale sin controles antifraude?).
