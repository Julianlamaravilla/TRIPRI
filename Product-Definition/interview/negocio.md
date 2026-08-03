# Negocio y Visión — Preguntas para cerrar el Discovery

**Fecha**: 2026-08-02 · **9 preguntas** · ~20 minutos

Este cuadernillo cierra el bloque de **Negocio y Visión**, que hoy está al **66,7 %**. Son las
últimas 9 de 18: las otras 9 ya quedaron resueltas con los cuestionarios anteriores.

## Cómo responder

- En las preguntas con opciones, escriba la letra y una etiqueta corta:
  `B — cobramos por ruta activa` es más claro que solo `B`.
- Use el campo **Descripción** para argumentar, matizar o proponer una opción que no esté.
- Combine letras cuando quiera decir ambas: `A y C`.
- Si ninguna encaja, `X` es mejor que forzar una respuesta equivocada.
- Si algo no lo sabe, escríbalo. *"No lo sé"* es una respuesta útil; una inventada no.

---

## B-01 · ¿Cómo se llama el producto?

**Contexto**

Es la tercera vez que se pregunta y sigue sin nombre. Hoy conviven tres: el repositorio se llama
`TRIPRI`, el cuaderno de notas `TryPRI`, y el documento de requisitos lo llama *"Sistema Inteligente
de Administración de Préstamos"*. En la v3 respondieron *"aún no hemos definido"*.

Esto ya no es cosmética. El nombre entra en la ficha de Play Store y App Store, en el dominio, en el
remitente de los mensajes al cliente final, en las facturas de la suscripción y en el contrato. Y
`TryPRI` se parece demasiado a **TryController**, que es el producto de un tercero al que van a
reemplazar: usar un nombre parecido invita a un problema de marca que sale caro y tarde.

**Pregunta**

¿Con qué nombre sale el producto a producción?

**Opciones de respuesta**

A) Ya tenemos el nombre — lo escribo abajo
B) No lo tenemos, pero lo decidimos nosotros antes de la primera entrega — indico para cuándo
C) Preferimos que ustedes propongan 3 opciones y elegimos
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

`[Answer]:`

---

## B-02 · El modelo de cobro del software: tres respuestas que no encajan

**Contexto**

Sobre cómo se cobra la suscripción tenemos **tres declaraciones que no pueden ser verdad a la vez**:

| Dónde | Qué dice |
|---|---|
| **C-04** (cuestionario v2) | Se cobra **por ruta o unidad de cobro activa** |
| Conversación del 2 de agosto | Suscripción **semanal**, con **plan básico (con IA)** y plan superior (IA + WhatsApp) |
| **V-20** (cuestionario v3) | La factura **vence el día 30 del mes** y al día siguiente se bloquea |

Semanal y "vence el 30 del mes" son incompatibles. Y **el precio nunca se ha dicho**, en ninguna de
las tres rondas.

Esto no es un detalle comercial: decide si hay que construir prorrateo, cambios de plan a mitad de
ciclo, y **52 cobros al año por cliente en vez de 12** — que es cuatro veces más trabajo de
facturación, reintentos y avisos de pago fallido.

**Pregunta**

¿Cuál es el modelo definitivo: qué se cobra, cada cuánto, y cuánto?

**Opciones de respuesta**

A) **Mensual**, por ruta o unidad de cobro activa — indico el precio por ruta
B) **Mensual**, por planes escalonados — indico los planes y sus precios
C) **Semanal**, por planes escalonados — indico los planes y sus precios
D) Mensual con un precio base + un cargo por ruta adicional — lo detallo abajo
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

Por favor incluya: **el precio**, y si hay **planes**, qué incluye cada uno.

`[Answer]:`

---

## B-03 · El volumen actual: falta el monto de cartera

**Contexto**

En **V-09** quedó claro el tamaño en número de personas: **~10 empresas, ~5 rutas cada una, ~40
clientes por ruta ≈ 2.000 clientes**. Con eso ya pudimos dimensionar la infraestructura y confirmar
que sobra capacidad por mucho margen.

Lo que falta es el **dinero**: cuánto vale la cartera que el sistema va a administrar.

No es curiosidad. Define el tamaño de los campos de importe, cuántos decimales guardar, si los
totales caben en los reportes, y sobre todo **cuánto dinero está en juego si el sistema calcula
mal**. Un error de redondeo sobre 50.000 reales es un ajuste; sobre 5 millones, es un problema.

**Pregunta**

¿Cuál es el monto aproximado de cartera activa hoy, sumando todas las rutas?

**Opciones de respuesta**

A) Menos de 100.000 reales
B) Entre 100.000 y 500.000 reales
C) Entre 500.000 y 2 millones de reales
D) Más de 2 millones de reales
X) Prefiero dar la cifra exacta / no la sé — lo explico

**Descripción** *(argumente la respuesta o añada otra opción)*

Útil también: **el préstamo más grande** que se ha dado y el **promedio**.

`[Answer]:`

---

## B-04 · ¿Cómo sabremos que el sistema funcionó?

**Contexto**

Esta pregunta se hizo en la v2 (**C-07**) y en la v3 (**V-22**). En la v2 la respuesta fue *"por la
cantidad de suscriptores"*, y en la v3 quedó **sin responder**.

"Más suscriptores" no sirve como medida porque no distingue entre un sistema que funciona y uno que
se vende bien. Y sin una medida, dentro de seis meses no habrá forma de decidir si el proyecto salió
bien: cada uno tendrá su opinión y ninguna será comprobable.

En **C-99** dijeron que el problema nº 1 es el **fraude interno**. Ahí hay una medida natural.

**Pregunta**

Elija **2 o 3 medidas** y, para cada una, díganos **cómo está hoy** y **a cuánto quieren llegar**.

**Opciones de respuesta**

A) **Descuadres de caja al mes** — hoy: ____ / meta: ____
B) **Dinero perdido por fraude interno al mes** — hoy: ____ / meta: ____
C) **Clientes que reclaman por un pago mal registrado** — hoy: ____ / meta: ____
D) **Tiempo que tarda el administrador en cerrar el día** — hoy: ____ / meta: ____
E) **Mora de la cartera (%)** — hoy: ____ / meta: ____
F) **Nº de empresas suscritas** — hoy: ____ / meta a 12 meses: ____
X) Otra medida — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

Si no tienen el dato de hoy, escriba *"no lo medimos"*. **Saber que no se mide ya es información
útil** — significa que el sistema tendrá que empezar a medirlo.

`[Answer]:`

---

## B-05 · El presupuesto

**Contexto**

Ya sabemos el equipo: **una persona**. Lo que no sabemos es el presupuesto, y hay cifras concretas
sobre la mesa que alguien tiene que aprobar antes de arrancar:

| Concepto | Costo mensual estimado |
|---|---:|
| Infraestructura AWS (São Paulo, con red privada) | **~$210** |
| WhatsApp Business API (mensajes a ~2.000 clientes) | **~$212** |
| Sentry (avisos de error en producción) | $0 – 26 |
| Asistente de IA, si entra en el alcance | $4 – 16 |
| **Total aproximado** | **~$430 – 470 / mes** |

Más un pago único de **$25** (Google Play) y **$99/año** (Apple), si se publica en iPhone.

El dato que más llama la atención: **WhatsApp cuesta más que toda la infraestructura junta**, y es
el 61 % de la factura.

**Pregunta**

¿Hay un presupuesto mensual aprobado para operar el sistema? ¿De cuánto?

**Opciones de respuesta**

A) Sí, y es suficiente para lo de arriba — indico la cifra
B) Sí, pero es menor — indico la cifra y ajustamos el alcance
C) No hay presupuesto asignado todavía; hay que definirlo
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

**¿Ese costo lo absorbe la empresa, o se repercute al suscriptor?** Si se repercute, el precio de
B-02 tiene que cubrirlo: a 10 empresas, son ~$43 por empresa solo en costos.

`[Answer]:`

---

## B-06 · Qué queda fuera de la primera entrega

**Contexto**

En **V-05** confirmaron el alcance: **app del cobrador completa + web mínima** (crear y editar
clientes, aprobar ventas, aprobar gastos, dar llaves). Con eso quedaba fuera de la v1: el asistente
de IA, los reportes avanzados, el módulo de facturación y el orden geográfico de rutas.

**Pero hay una contradicción sin resolver.** Después nos transmitieron que la suscripción tendría
**un plan básico que incluye IA**. Si la IA es el plan de entrada, entonces **la IA no puede estar
fuera de la primera entrega**: sería vender un plan que no existe.

Y en el cuestionario v2, en **C-108**, ustedes mismos habían marcado que **"la IA puede esperar"**.

**Pregunta**

¿La primera entrega incluye el asistente de IA, sí o no?

**Opciones de respuesta**

A) **No.** La v1 sale sin IA; el plan básico incluye otra cosa — la describo abajo
B) **Sí.** La IA entra en la v1 porque es el plan de entrada, y aceptamos que eso alarga el plazo
C) La v1 sale sin IA y **el plan básico se vende sin ella**; la IA llega en la v2 como plan superior
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

Si responde **B**, necesitamos saber **qué hace exactamente el asistente**: ¿solo responde
preguntas sobre los datos, o también ejecuta acciones como registrar un pago o aprobar una llave?
Es la diferencia entre una funcionalidad de semanas y una de meses.

`[Answer]:`

---

## B-07 · El cobro del software, ¿en la primera entrega o después?

**Contexto**

Aquí hay dos decisiones suyas que chocan:

- El alcance de la v1 **deja el módulo de facturación fuera**.
- Pero en **V-51** eligieron **autoservicio**: *"la empresa se registra sola, paga y empieza a
  usarlo"*.

**No se puede tener las dos.** Si la empresa se registra y paga sola, hace falta cobrar dentro del
sistema desde el primer día — y eso es pasarela de pago, facturas, reintentos, avisos y bloqueo por
impago. Es de las cosas más caras de construir.

La alternativa es cobrar por fuera al principio: ustedes emiten la factura, cobran por transferencia
o PIX, y activan la cuenta a mano. A 10 empresas eso son 10 gestiones al mes, perfectamente
manejable.

**Pregunta**

¿Cómo se cobra la suscripción en la primera entrega?

**Opciones de respuesta**

A) **Por fuera del sistema**: nosotros facturamos y activamos la cuenta a mano. El autoservicio
   llega después *(la más rápida, y a 10 empresas es sostenible)*
B) **Autoservicio desde el día 1**: la empresa se registra, paga con tarjeta o PIX y se activa sola
C) Mixto: alta a mano, pero la renovación mensual sí se cobra automática
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

Si elige **B**, tenga en cuenta lo que nos dijeron en **V-06**: la mayoría de los suscriptores **no
son empresas formales**. Un cobro automático necesita un titular identificable con medio de pago a
su nombre. ¿Quién firma y quién paga?

`[Answer]:`

---

## B-08 · Lo que se ha pensado pero no se compromete

**Contexto**

Hay tres capacidades que aparecieron en algún documento o conversación y **nunca se cerró si entran
o no**. Conviene decirlo explícitamente ahora, porque "no dijimos que no" se interpreta como "sí"
cuando alguien empieza a construir.

**Pregunta**

Para cada una, ¿entra en el alcance o queda descartada por ahora?

**Opciones de respuesta**

Marque una opción por fila:

| Capacidad | ¿Entra? |
|---|---|
| **Scoring crediticio automático** — que el sistema recomiende cuánto prestar según el historial | Sí en v1 / Sí más adelante / **No** |
| **Portal para el cliente final** — que el prestatario entre a ver su saldo y sus pagos | Sí en v1 / Sí más adelante / **No** |
| **Seguro de repatriación** — aparece en los documentos y nunca se explicó qué es | Sí en v1 / Sí más adelante / **No** / *No sé qué es* |
| **Generación de contrato** con plantilla legal y firma en el móvil | Sí en v1 / Sí más adelante / **No** |
| **Instancia separada por cliente** (`V-52`: *"podría ser, aumentaría los costos"*) | Sí en v1 / Sí más adelante / **No** |

**Descripción** *(argumente la respuesta o añada otra opción)*

En **V-12** dijeron que el historial de pago del cliente sirve para **subir o bajar el monto del
siguiente préstamo**. Eso es scoring hecho por una persona. La pregunta es si quieren que el sistema
lo **sugiera solo**.

`[Answer]:`

---

## B-09 · ¿Por qué no seguir con TryController?

**Contexto**

Esta nunca se respondió directamente. Sabemos que TryController **no permite exportar los datos**
(`C-08`) y que no tiene los controles antifraude que ustedes necesitan, pero nunca nos dijeron **qué
más les falta** ni si han mirado otras alternativas.

Importa por dos motivos. Primero, porque lo que hoy funciona bien en TryController **hay que
replicarlo**, y si no sabemos qué es, se pierde. Y segundo, porque si existe otro producto en el
mercado que ya hace el 80 % de esto, **construir desde cero puede no ser la mejor decisión** — y es
mejor saberlo ahora que dentro de seis meses.

**Pregunta**

¿Qué les falta TryController, y han evaluado alguna otra alternativa?

**Opciones de respuesta**

A) Solo TryController; lo que falta es el control antifraude y poder sacar nuestros datos
B) Hemos mirado otras opciones — las nombro abajo y digo por qué no sirvieron
C) No hemos mirado nada más
X) Otra — la explico

**Descripción** *(argumente la respuesta o añada otra opción)*

Y una pregunta que vale mucho: **¿qué es lo que TryController hace bien y no se puede perder?**
Cualquier cosa que hoy usen a diario y funcione, si no la nombran, corre el riesgo de no estar.

`[Answer]:`

---

Cuando termine, devuelva el archivo o responda con una sola palabra: **listo**
