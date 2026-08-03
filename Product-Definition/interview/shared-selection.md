# Selección Compartida — Configuración de la sesión

Progreso: ░░░░░░░░░░ 0/4 preguntas  ·  ~3 min

Estas 4 preguntas se responden una sola vez, antes de arrancar las entrevistas
de Negocio y Técnica. Rellena las etiquetas `[Answer]:` y responde con una sola
palabra: **ready**.

## Cómo responder

- En las preguntas de opción múltiple, escribe primero la letra y luego una etiqueta corta:
  `B — entrevista completa, es un sistema financiero en producción` es más claro que solo `B`.
- En las preguntas de texto libre, escribe directamente debajo de `[Answer]:`.
- Combina opciones cuando quieras decir ambas: `B and C`.
- Añade un matiz cuando una opción es casi correcta: `A — pero el formato Excel actual es intocable`.
- Usa `X` con libertad. Si ninguna opción encaja, `X` es mejor que forzar una respuesta equivocada.
- Para cambiar una respuesta más adelante, dime "quiero cambiar mi respuesta a la Q{N}" y la reabro.

> **Insumo ya cargado**: leí todo el material de `context-discovery/notebooklm/`
> (documento de requerimientos, 3 reportes de NotebookLM y el historial de chat).
> Cada pregunta trae una **Recomendación** derivada de ese material. Si estás de
> acuerdo, basta con escribir la letra recomendada.

---

## Question 1: ¿Cuál describe mejor este proyecto?

A) **Proyecto nuevo desde cero** — no hay código existente ni un sistema propio
   que debamos preservar o integrar.

B) **Nueva funcionalidad sobre un producto existente** — ya hay un sistema en
   producción y le añadimos una capacidad. El código, esquemas, APIs o usuarios
   actuales deben seguir funcionando.

C) **Migración / modernización de un sistema existente** — hay un sistema en
   marcha y lo estamos reconstruyendo, replataformando o reemplazando en parte.
   Algunos contratos o datos existentes se conservan.

X) Otro — descríbelo después de `[Answer]:`
   (ejemplo: "mayormente nuevo, pero debemos conectarnos a un servicio existente
   para autenticación")

**Recomendación:** **A**, con un matiz. El material describe construir una plataforma
nueva desde cero; TryController es un producto de terceros que se usa hoy como
referencia funcional, no un código nuestro que haya que preservar. Lo único que sí
es un contrato duro heredado es el **formato del cierre de caja en Excel** (el reporte
nuevo debe replicarlo visualmente) y, posiblemente, la **migración de los datos actuales
en hojas de cálculo**. Si consideras que esa migración de datos es parte del alcance,
la respuesta correcta pasa a ser **C**.

[Answer]:

---

## Question 2: ¿Qué profundidad quieres en las entrevistas?

A) **Pasada rápida** (~8 preguntas de Negocio + ~10 Técnicas, ~20 min)
   Solo preguntas núcleo. Sirve para prototipos, POCs o herramientas internas.

B) **Entrevista completa** (~18–20 de Negocio + ~29 Técnicas, ~60 min)
   Cubre todas las secciones: métricas, riesgos, seguridad, testing, patrones de
   código de ejemplo. Recomendada para productos de producción y cargas reguladas.

X) Otro (ej. "Completa pero sin la sección de Código de Ejemplo") — descríbelo

**Recomendación:** **B**. Es un sistema financiero multi-tenant que mueve dinero real,
con auditoría obligatoria (usuario/fecha/hora/IP/dispositivo/acción), control de caja,
integración con WhatsApp Business API y PIX, y app móvil con modo offline. Las secciones
de seguridad, testing y NFRs de la pasada completa no son opcionales aquí. Además, como
ya tengo el insumo cargado, voy a **pre-rellenar** muchas respuestas: tu trabajo será
sobre todo confirmar o corregir, no escribir desde cero.

[Answer]:

---

## Question 3: ¿Cómo quieres recorrer los dos roles?

Discovery produce dos documentos: la **Visión** (rol Negocio: el qué y el porqué) y
el **Entorno Técnico** (rol Técnico: restricciones, stack permitido/prohibido).

A) **Secuencial** — hago Negocio primero y Técnico después, en esta misma sesión
   o en una posterior. La entrevista técnica podrá apoyarse en la visión ya escrita.
B) **Solo un rol** — únicamente Negocio, o únicamente Técnico (indica cuál).
C) **Paralelo** — dos personas distintas llenan cada rol al mismo tiempo.
X) Otro — descríbelo

**Recomendación:** **A (secuencial)**. Vas a llenar todo tú, y la entrevista técnica
mejora bastante cuando ya existe `vision-document.md` (puedo proponer stack y NFRs
alineados con las prioridades del MVP en lugar de preguntarlo a ciegas).

[Answer]:

---

## Question 4: ¿Cómo prefieres responder las preguntas?

A) **batch** (por archivo, por defecto) — escribo lotes de 5–7 preguntas en un
   archivo `.md`, tú rellenas las etiquetas `[Answer]:` a tu ritmo y respondes
   `ready`. Menos idas y vueltas; puedes editar con calma y retomar después.

B) **conversational** (en el chat) — te hago las preguntas de a 1–3 directamente
   aquí, tú respondes en línea. Sin editar archivos.

X) Otro — descríbelo

**Recomendación:** **A (batch)**. Con el material ya cargado, la mayoría de los lotes
te van a llegar **pre-rellenados** con la respuesta extraída del documento de
requerimientos; revisarlos y ajustarlos en un archivo es mucho más rápido que
ir pregunta por pregunta en el chat.

*(La persistencia es idéntica en ambos modos: nada se pierde al cambiar.)*

[Answer]:

---

Cuando termines, responde con una sola palabra: **ready**

(Volveré a leer este archivo desde el disco y validaré tus respuestas.)
