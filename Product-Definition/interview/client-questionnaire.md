> ## ⛔ VERSIÓN SUPERADA — no responder aquí
>
> **Este cuestionario (v2, 117 preguntas) ya fue respondido** por los interesados el
> **2026-08-01** y está cerrado. Se conserva solo para trazabilidad.
>
> - Las respuestas, pregunta por pregunta: **`business/client-answers-2026-08-01.md`**
> - Lo que sigue abierto: **`client-questionnaire-v3.md`** — 28 preguntas
>
> De las 117, **89 quedaron cerradas**. La cobertura del Discovery pasó de ~37% a ~65%.

---

# Cuestionario para el cliente — Cómo debe funcionar el sistema

Este documento reúne **solo las preguntas que nadie más que tú puede responder**: las que
dependen de cómo funciona tu negocio de préstamos y de cómo quieres que se comporte el
sistema. Las decisiones técnicas (qué tecnología, qué servidores, cómo se programa) no
están aquí: esas las resuelve el equipo de desarrollo.

**Cómo responder:**

- Debajo de cada pregunta hay opciones. Escribe la letra en `[Answer]:` y, si quieres,
  añade una explicación en tus propias palabras. Ejemplo: `B — pero solo para la ruta norte`.
- Si ninguna opción encaja, usa `X` y explícalo. Es mejor una `X` bien explicada que
  una letra forzada.
- Si no sabes o no está decidido, escribe `NO SÉ` o `LO DECIDIMOS DESPUÉS`. Eso también
  es información útil: nos dice dónde no podemos avanzar todavía.
- No hace falta llenarlo de una sola vez. Está dividido en 16 bloques; puedes ir por partes.

**Por qué importa tanto:** cada pregunta sin responder aquí se convierte más adelante en
una suposición del desarrollador. Y en un sistema que **lleva la cuenta** del dinero, una
suposición equivocada sobre intereses o sobre la caja se paga cara y se descubre tarde.

---

> ## ⚠️ Algo que ya quedó decidido — léelo antes de empezar
>
> **El sistema NO recibe ni mueve el dinero de tus cobros.** No es una billetera, ni una
> fintech, ni un banco. Cuando el cobrador registra un pago en efectivo o un PIX, lo que
> hace es **anotar la información** de ese pago (cuánto, cómo, quién, cuándo) para que
> quede reflejado en la gestión y en los flujos de cobranza. **La plata sigue moviéndose
> por fuera**, entre tu cliente, tu cobrador y tú.
>
> **La única excepción:** el cobro por usar el software. Ese sí podría pasar por el
> aplicativo, **solo en la versión web** — nunca en el celular.
>
> **Esto no relaja ninguna de las preguntas sobre caja, cuadre o intereses.** Al contrario:
> como el sistema es la **única evidencia** de que ese dinero existió, tiene que cuadrar
> perfecto. Lo que sí hace es simplificar el lado legal (no hay que tramitar permisos de
> medio de pago) y evitar una integración cara con tu banco.
>
> *Si algo de esto no es lo que tenías en mente, dínoslo ahora: cambia el diseño completo.*

**Prioridad:**

- 🔴 **Crítica** — sin esto no se puede empezar a construir esa parte del sistema.
- 🟡 **Importante** — se puede empezar, pero hay que resolverla antes de terminar.
- ⚪ **Puede esperar** — se puede decidir sobre la marcha.

---

## Índice

| Bloque | Tema | Preguntas |
|---|---|---|
| 0 | Lo esencial | C-01 a C-09 |
| 1 | Las cuentas: intereses y cuotas | C-10 a C-17 |
| 2 | Cuando el cliente paga | C-18 a C-26 |
| 3 | La vida del préstamo | C-27 a C-35 |
| 4 | Tu equipo y tu estructura | C-36 a C-41 |
| 5 | Los clientes que reciben el préstamo | C-42 a C-48 |
| 6 | El dinero: cajas y cierre | C-49 a C-58 |
| 7 | Autorizaciones (las "llaves") | C-59 a C-64 |
| 8 | La calle: cobranza y trabajo sin señal | C-65 a C-74 |
| 9 | WhatsApp y avisos | C-75 a C-81 |
| 10 | Reportes y tablero | C-82 a C-86 |
| 11 | Inteligencia artificial | C-87 a C-91 |
| 12 | Automatizaciones | C-92 |
| 13 | Lo legal y lo delicado | C-93 a C-99 |
| 14 | Tamaño y expectativas | C-100 a C-106 |
| 15 | Prioridades: qué va primero | C-107 a C-111 |
| 16 | 🆕 Cómo te pagan a ti por el software | C-112 a C-117 |

---

# BLOQUE 0 · Lo esencial

Nueve preguntas que condicionan todo lo demás. Si solo puedes responder un bloque hoy, que sea este.

---

### C-01 · ¿Cómo se va a llamar? 🟡

Hemos visto tres nombres distintos en los documentos: "TryPRI", "TRIPRI" y "Sistema
Inteligente de Administración de Préstamos". Además está "TryController", que es el
programa que usas hoy y que no es tuyo. Necesitamos un nombre para el producto.

* Pregunta ------
¿Cuál es el nombre del producto que vamos a construir?

*-- Opciones de respuesta ---
A) Ya tengo el nombre definitivo — lo escribo abajo
B) Tengo un nombre provisional, lo cambiaremos después — lo escribo abajo
C) No hay nombre todavía, usen uno temporal

[Answer]:

*Origen: OQ-B-1*

---

### C-02 · ¿En qué país operas y con qué moneda? 🔴

Esto no es un detalle. De la respuesta dependen: la moneda y cómo se escriben las cifras,
el idioma del sistema, qué leyes de protección de datos aplican, si hay un tope legal de
interés que no se puede pasar, y si el pago por PIX (que es un sistema brasileño) tiene
sentido o hay que usar otro medio.

En los documentos hay una mezcla que no cuadra: se habla de **PIX**, que solo existe en
Brasil; pero los ejemplos de dinero están escritos como `$200.000`, que parece formato
colombiano; y se menciona un "seguro de repatriación" para trabajadores, lo que sugiere
que tu personal trabaja fuera de su país de origen.

* Pregunta ------
¿En qué país o países opera el negocio, con qué moneda cobras, y en qué idioma debe estar el sistema?

*-- Opciones de respuesta ---
A) Un solo país, una sola moneda, un solo idioma — los escribo abajo
B) Un país por ahora, pero planeamos expandirnos a otros — indico cuáles
C) Varios países desde el inicio, con monedas distintas — los escribo abajo
X) Otra situación — la explico

[Answer]:

*Origen: OQ-B-2, CX-8, OQ-N-21, OQ-N-37*

---

### C-03 · ¿El sistema es solo para tu empresa, o se lo vas a vender a otras? 🔴

Esta decisión cambia por completo la forma de construir el sistema, y cambiarla después
cuesta muchísimo. Los documentos dicen las dos cosas en sitios distintos.

- Si es **solo para ti**: el sistema es más simple, más barato y más rápido de construir.
- Si vas a **vendérselo a otras empresas de préstamos**: hay que separar los datos de cada
  empresa desde el primer día, para que ninguna vea la información de otra. Eso encarece
  todo, pero hacerlo después es prácticamente rehacer el sistema.

* Pregunta ------
¿Para quién es este sistema?

*-- Opciones de respuesta ---
A) Solo para mi empresa. No pienso venderlo
B) Solo para mi empresa por ahora, pero quiero venderlo más adelante (en 1-2 años)
C) Desde el principio quiero venderlo a otras empresas de préstamos
X) Otra — la explico

[Answer]:

*Origen: OQ-B-3, CX-1, OQ-N-28*

---

### C-04 · Si lo vas a vender: ¿cómo cobrarías? 🔴

*Solo responde si en C-03 elegiste B o C.*

**Esta pregunta subió de prioridad.** Como el sistema no maneja el dinero de tus cobros,
el cobro por el uso del software se convirtió en **el único sitio del producto donde se
mueve dinero de verdad**. Eso significa que hay que construir una parte específica de la
web para ello, y su forma depende por completo de tu respuesta: no es lo mismo una tarifa
fija al mes (sencillo) que un porcentaje de lo recaudado (hay que calcularlo con datos de
la operación de cada cliente todos los meses).

* Pregunta ------
¿Cómo le cobrarías a otra empresa por usar el sistema, y cuánto más o menos?

*-- Opciones de respuesta ---
A) Una tarifa fija al mes por empresa
B) Por ruta o unidad de cobro que tengan activa
C) Por cada gestor o cobrador que use la app
D) Un porcentaje de lo que recauden
E) Una combinación (ej. base fija + algo por gestor) — la explico
F) No lo he pensado todavía
X) Otra — la explico

[Answer]:

*Origen: OQ-B-4*

---

### C-05 · ¿De qué tamaño es la operación hoy? 🔴

Necesitamos números reales, aunque sean aproximados. Sin esto no podemos saber si el
sistema tiene que aguantar 50 pagos al día o 5.000, y eso cambia mucho el diseño.

* Pregunta ------
Escribe los números de tu operación actual: ¿cuántos clientes tienes?, ¿cuántos préstamos
están activos ahora mismo?, ¿cuántos cobradores trabajan en la calle?, ¿cuántas rutas o
unidades manejas?, ¿cuánto dinero tienes prestado en total?, ¿cuántos pagos se registran
en un día normal?

*-- Opciones de respuesta ---
A) Tengo los números exactos — los escribo abajo
B) Tengo aproximados — los escribo abajo
C) Puedo sacarlos del Excel actual, dame unos días

[Answer]:

*Origen: OQ-B-5, OQ-N-1, OQ-N-2*

---

### C-06 · ¿Cuánto te cuesta hoy hacerlo a mano? 🔴

El objetivo del sistema es eliminar el Excel y la digitación manual. Para saber si lo
logramos, necesitamos saber de dónde partimos. Sin un número de partida, no hay forma
de demostrar que el sistema sirvió.

* Pregunta ------
¿Cuántas horas a la semana se van hoy en llenar Excel, cuadrar cuentas y mandar mensajes
a mano? ¿Cuántos errores de digitación aparecen al mes, más o menos? ¿Hay plata que se
haya perdido o descuadrado por esos errores?

*-- Opciones de respuesta ---
A) Te doy los números aproximados — los escribo abajo
B) Nunca lo he medido, pero puedo estimarlo
C) Nunca lo he medido y no sabría por dónde empezar

[Answer]:

*Origen: OQ-B-6, OQ-B-7*

---

### C-07 · ¿Cómo sabrás dentro de un año que esto valió la pena? 🔴

Piensa en 3 a 5 cosas concretas que quieras ver mejor. No vale "que sea más eficiente":
tiene que ser algo que se pueda medir, con un número.

Ejemplos de cómo se ve una buena respuesta:
- "Que el cierre de caja pase de 2 horas diarias a 10 minutos"
- "Bajar la mora del 18% al 12%"
- "Que un solo cobrador pueda manejar 150 clientes en lugar de 90"
- "Cero descuadres de caja al mes"

* Pregunta ------
¿Qué 3 a 5 resultados medibles quieres lograr, y en cuánto tiempo?

*-- Opciones de respuesta ---
A) Los escribo abajo
B) Necesito pensarlo con mis socios

[Answer]:

*Origen: OQ-B-7*

---

### C-08 · ¿Qué pasa con TryController? 🔴

Hoy usas TryController. No sabemos si el sistema nuevo lo reemplaza, convive con él o
solo lo mejora en algunas cosas. También necesitamos saber si hay que traer los datos
que ya están ahí dentro: clientes, préstamos vivos, saldos, historial.

Traer los datos es un proyecto en sí mismo. Y si TryController no permite exportar,
puede que la única salida sea empezar con los préstamos nuevos y dejar los viejos
terminando en el sistema antiguo.

* Pregunta ------
¿Qué relación tendrá el sistema nuevo con TryController y con tus Excel actuales?

*-- Opciones de respuesta ---
A) Lo reemplaza por completo, y hay que pasar TODOS los datos históricos al nuevo
B) Lo reemplaza, pero solo hay que pasar los clientes y los préstamos que estén activos
C) Lo reemplaza, y empezamos de cero: los préstamos viejos terminan en el sistema antiguo
D) Van a convivir un tiempo — explico cómo
X) Otra — la explico

[Answer]:

**Pregunta adicional:** ¿TryController te deja exportar tus datos (a Excel, por ejemplo)?
¿Has intentado sacarlos alguna vez?

[Answer]:

*Origen: OQ-B-12, OQ-B-13, OQ-T-25*

---

### C-09 · ¿Hay una fecha límite? 🔴

* Pregunta ------
¿Hay algún motivo por el que esto tenga que estar listo para una fecha concreta?

*-- Opciones de respuesta ---
A) Sí, hay fecha límite dura — la escribo abajo y explico por qué
B) Hay una fecha deseable, pero es flexible
C) No hay fecha; se entrega cuando esté bien hecho
X) Otra — la explico

[Answer]:

*Origen: OQ-B-8*

---

# BLOQUE 1 · Las cuentas: intereses y cuotas

**Este es el bloque más importante del cuestionario.** Los documentos que nos diste
describen muy bien qué pantallas debe tener el sistema, pero **en ningún lado dicen cómo
se calculan los números**. Y esa es justamente la parte que el sistema tiene que hacer
sola, sin equivocarse, miles de veces.

Si algo de este bloque queda mal entendido, el sistema va a calcular mal desde el primer
día y nadie se va a dar cuenta hasta que la caja no cuadre.

---

### C-10 · ¿Cómo sacas el valor de la cuota? 🔴

Ejemplo: prestas $1.000.000 a 20 cuotas diarias. ¿Cómo llegas al valor de cada cuota?

* Pregunta ------
¿Cuál de estas formas se parece más a como calculas tú?

*-- Opciones de respuesta ---
A) **Interés fijo sobre lo prestado.** Ejemplo: 20% sobre el millón = $1.200.000 en total,
   dividido entre 20 cuotas = $60.000 cada una. El interés no cambia aunque el cliente
   pague antes o después
B) **Interés sobre el saldo que va quedando.** Cada cuota tiene una parte de interés y
   una de capital; a medida que baja la deuda, baja el interés (como un crédito bancario)
C) **Cuota fija que yo defino a ojo**, según el cliente y el monto, sin fórmula
D) Depende del tipo de préstamo — explico cada caso abajo
X) Otra forma — la explico con un ejemplo numérico

[Answer]:

**Muy importante:** si puedes, ponnos un ejemplo real con números.
*"Presté ___, a ___ cuotas, de frecuencia ___, y el cliente terminó pagando ___ en total, en cuotas de ___ cada una."*

[Answer]:

*Origen: OQ-F-13*

---

### C-11 · ¿Quién decide la tasa de interés? 🔴

* Pregunta ------
¿El interés se define caso por caso, o está fijado de antemano?

*-- Opciones de respuesta ---
A) El administrador fija una tasa para toda la empresa y nadie la cambia
B) Cada ruta o unidad tiene su propia tasa
C) El cobrador la negocia con cada cliente, dentro de un rango permitido
D) El cobrador la pone libremente, sin límite
X) Otra — la explico

[Answer]:

*Origen: OQ-F-14, OQ-F-21*

---

### C-12 · Los préstamos diarios: ¿se cobra todos los días? 🔴

Un préstamo "diario" a 20 cuotas puede significar cosas muy distintas según si se cobran
o no los domingos y los festivos. El sistema tiene que calcular la fecha de cada cuota,
y necesita saber la regla exacta.

* Pregunta ------
En un préstamo de frecuencia diaria, ¿qué días se cobra?

*-- Opciones de respuesta ---
A) Todos los días, incluidos sábados, domingos y festivos
B) De lunes a sábado. Domingos y festivos no se cobra, se corre al día siguiente
C) De lunes a viernes solamente
D) Depende de la ruta — explico abajo
X) Otra — la explico

[Answer]:

**Pregunta adicional:** cuando cae un día que no se cobra, ¿la cuota se corre al día
siguiente (y el préstamo termina más tarde) o se junta con la cuota siguiente?

[Answer]:

*Origen: OQ-F-15*

---

### C-13 · ¿Qué es exactamente la modalidad "Libre"? 🔴

En tu documento aparecen cinco frecuencias: diaria, semanal, quincenal, mensual y
**libre**. Las cuatro primeras se entienden. La quinta no está explicada en ningún lado.

* Pregunta ------
¿Qué significa un préstamo "libre" en tu negocio?

*-- Opciones de respuesta ---
A) No hay cuotas fijas: el cliente abona cuando puede y el interés corre sobre el saldo
B) Hay una fecha límite única para pagar todo, sin cuotas intermedias
C) Las cuotas existen pero las fechas las define el cobrador manualmente, una por una
D) Es una opción que en realidad no usamos — se puede quitar
X) Otra — la explico

[Answer]:

*Origen: OQ-F-16, CX-7*

---

### C-14 · ¿Cobras interés por mora? 🔴

El sistema registra los días de atraso y avisa por WhatsApp, pero en ningún documento se
dice si además se **cobra** algo por atrasarse.

* Pregunta ------
Cuando un cliente se atrasa, ¿la deuda crece?

*-- Opciones de respuesta ---
A) No. Debe lo mismo, solo que tarde
B) Sí, se cobra un recargo fijo por cuota atrasada — indico cuánto
C) Sí, se cobra un porcentaje diario o mensual sobre lo vencido — indico cuánto y desde qué día
D) Depende, lo decide el administrador caso por caso
X) Otra — la explico

[Answer]:

*Origen: OQ-F-17*

---

### C-15 · ¿Desde cuándo un cliente "está en mora"? 🔴

El sistema tiene que marcar clientes en mora automáticamente, mostrarlos en el tablero y
avisar. Para eso necesita un número exacto de días.

* Pregunta ------
¿A partir de cuántos días de atraso consideras que un cliente está en mora?

*-- Opciones de respuesta ---
A) Desde el primer día que no paga
B) Después de ___ días sin pagar (escribe el número)
C) Después de ___ cuotas vencidas sin pagar (escribe el número)
D) Es distinto según la frecuencia del préstamo — lo explico abajo
X) Otra — la explico

[Answer]:

**Pregunta adicional:** ¿y a partir de cuándo lo das por perdido ("cartera castigada")?

[Answer]:

*Origen: OQ-F-18, OQ-F-28*

---

### C-16 · ¿Cobras algo además del interés? 🟡

* Pregunta ------
¿Hay cargos adicionales al momento de prestar?

*-- Opciones de respuesta ---
A) No, solo el interés
B) Sí: comisión de apertura o estudio — indico cuánto
C) Sí: seguro — indico cuánto y de qué tipo
D) Sí: papelería o gastos administrativos — indico cuánto
E) Varios de los anteriores — los detallo abajo
X) Otra — la explico

[Answer]:

**Pregunta adicional:** esos cargos, ¿se descuentan del dinero que le entregas al cliente,
o se le suman a la deuda?

[Answer]:

*Origen: OQ-F-20*

---

### C-17 · ¿Cómo redondeas? 🟡

Si prestas $1.000.000 al 20% en 21 cuotas, la cuota exacta da $57.142,857... Alguien tiene
que decidir qué hacer con esos centavos. Si el sistema redondea distinto a como lo haces
tú, la caja no va a cuadrar por unos pesos todos los días, y eso genera desconfianza.

* Pregunta ------
¿Cómo manejas las cifras que no dan exactas?

*-- Opciones de respuesta ---
A) Redondeo la cuota hacia arriba a la unidad más cercana (al mil, al cien...) — indico cuál
B) Redondeo hacia abajo — indico a qué unidad
C) Todas las cuotas iguales y la última ajusta con la diferencia
D) Nunca lo he pensado, hazlo como sea más lógico
X) Otra — la explico

[Answer]:

*Origen: OQ-F-19*

---

# BLOQUE 2 · Cuando el cliente paga

Aquí están las reglas del día a día del cobrador. Los documentos describen qué pasa
cuando el cliente paga la cuota completa, pero en la calle eso no siempre ocurre.

---

### C-18 · ¿Aceptas que te paguen menos de la cuota? 🔴

**Esta es la segunda pregunta más importante del cuestionario.** El documento que nos
diste asume siempre que el cliente paga la cuota completa. En la realidad, el cliente
dice "hoy solo tengo la mitad".

* Pregunta ------
Si la cuota es $50.000 y el cliente solo tiene $30.000, ¿qué hace el cobrador?

*-- Opciones de respuesta ---
A) Se recibe. Quedan $20.000 pendientes de esa cuota y se sigue cobrando el resto
B) Se recibe, pero la cuota se marca como no pagada hasta que complete
C) No se recibe nada: o paga la cuota completa o queda como "no pago"
D) Depende del cliente, lo decide el cobrador
X) Otra — la explico

[Answer]:

*Origen: OQ-F-30*

---

### C-19 · Cuando entra dinero, ¿qué se paga primero? 🔴

Si un cliente debe mora, interés y capital, y llega con una cantidad que no alcanza para
todo, el sistema tiene que decidir a qué se aplica primero. Esta regla es la que hace que
las cuentas cuadren o no.

* Pregunta ------
¿En qué orden se aplica el dinero que entra?

*-- Opciones de respuesta ---
A) Primero los recargos por mora, después el interés, y de último el capital
B) Primero la cuota más vieja pendiente, completa, y luego la siguiente
C) Primero el capital, para bajar la deuda
D) No aplica: en mi negocio no separo interés de capital, la cuota es una sola cosa
X) Otra — la explico

[Answer]:

*Origen: OQ-F-30*

---

### C-20 · Si el cliente abona una suma grande, ¿qué prefiere? 🔴

Un cliente con 20 cuotas de $50.000 llega con $400.000 de golpe.

* Pregunta ------
¿Qué hace el sistema con ese abono grande?

*-- Opciones de respuesta ---
A) Le adelanta cuotas: quedan 12 cuotas de $50.000 y termina antes
B) Baja el valor de todas las cuotas restantes, manteniendo la misma fecha final
C) El cliente elige entre las dos opciones anteriores
D) No permitimos abonos grandes, solo cuotas
X) Otra — la explico

[Answer]:

*Origen: OQ-F-31*

---

### C-21 · ¿Das descuento si el cliente paga antes? 🟡

* Pregunta ------
Si el cliente adelanta cuotas o cancela antes de tiempo, ¿le rebajas algo?

*-- Opciones de respuesta ---
A) No, paga el total pactado sin importar cuándo
B) Sí, se le descuenta el interés que aún no se ha causado
C) Se negocia caso por caso
X) Otra — la explico

[Answer]:

*Origen: OQ-F-32, OQ-F-25*

---

### C-22 · ¿Se puede corregir un pago mal registrado? 🔴

Situación real: el cobrador registra $50.000 en el cliente equivocado. El sistema ya
descontó la cuota, ya afectó la caja y **ya le mandó un WhatsApp de confirmación al
cliente equivocado**. ¿Ahora qué?

* Pregunta ------
¿Quién puede corregir o anular un pago ya registrado, y hasta cuándo?

*-- Opciones de respuesta ---
A) El cobrador puede corregirlo él mismo, pero solo el mismo día y antes de cerrar caja
B) Solo el administrador puede anularlo, desde la web, en cualquier momento
C) El cobrador lo solicita y el administrador lo autoriza (como una llave)
D) No se anula nunca: se registra un movimiento contrario que lo compensa
X) Otra — la explico

[Answer]:

**Pregunta adicional:** ¿se le debe avisar al cliente por WhatsApp que el pago se anuló?

[Answer]:

*Origen: OQ-F-33*

---

### C-23 · PIX: ¿cómo se registra? 🟡

**Ya está decidido lo más importante:** el sistema **no recibe** el PIX. La plata le llega a
tu cuenta como siempre; el sistema solo **anota que ese PIX ocurrió** para descontarlo de la
deuda del cliente. Eso quita de la mesa la parte cara de esta pregunta.

Lo que queda por decidir es cómo se anota. La opción sencilla es que el cobrador vea el
comprobante en el celular del cliente y lo escriba a mano. La opción avanzada es que el
sistema **lea el extracto de tu banco** (solo lectura, sin tocar el dinero) y cruce los PIX
recibidos con los pagos anotados, para avisarte si algo no coincide. Esto último sigue
siendo un proyecto aparte que depende de lo que tu banco permita, pero ya no es obligatorio.

* Pregunta ------
¿Cómo quieres que se registren los pagos por PIX?

*-- Opciones de respuesta ---
A) Manual: el cobrador escribe el nombre del titular y el monto
B) Manual, pero con foto del comprobante obligatoria
C) Manual ahora, y más adelante que el sistema cruce contra el extracto del banco
D) Desde el inicio quiero el cruce automático contra el extracto del banco
X) Otra — la explico

[Answer]:

*Origen: OQ-F-34 · acotada por la decisión D-01*

---

### C-24 · ¿Hay otras formas de pago? 🟡

*Recuerda: se trata de qué formas de pago debe **poder anotar** el sistema. El cobro en sí
sigue ocurriendo por fuera.*

* Pregunta ------
Además de efectivo y PIX, ¿cómo más te pueden pagar?

*-- Opciones de respuesta ---
A) Solo efectivo y PIX
B) También transferencia bancaria normal
C) También pagos en corresponsales, giros o puntos de pago
D) También tarjeta
X) Otra — la explico

[Answer]:

*Origen: OQ-F-35*

---

### C-25 · El comprobante que recibe el cliente 🟡

* Pregunta ------
Cuando el cliente paga, ¿qué debe recibir?

*-- Opciones de respuesta ---
A) Un mensaje de WhatsApp con los datos del pago, sin documento adjunto
B) Un recibo en PDF con número consecutivo, enviado por WhatsApp
C) Un recibo impreso en el momento (requiere impresora portátil para el cobrador)
D) Nada, con que quede registrado basta
X) Otra — la explico

[Answer]:

**Pregunta adicional:** ¿ese recibo tiene alguna validez legal o fiscal en tu país, o es
solo un soporte interno?

[Answer]:

*Origen: OQ-F-38*

---

### C-26 · Cuando el cliente NO paga 🟡

* Pregunta ------
Cuando el cobrador marca "no pago", ¿qué debe exigirle el sistema?

*-- Opciones de respuesta ---
A) Nada, solo el registro
B) Que elija un motivo de una lista (no estaba, no tenía, se negó, negocio cerrado...)
C) Que elija motivo y además tome una foto como evidencia
D) Que elija motivo y registre una promesa de pago con fecha
E) Varias de las anteriores — las indico abajo
X) Otra — la explico

[Answer]:

**Pregunta adicional:** si el cliente promete pagar el jueves, ¿qué debe hacer el sistema
ese jueves? ¿Recordarle al cobrador? ¿Avisarle al cliente? ¿Nada?

[Answer]:

*Origen: OQ-F-36, OQ-F-37*

---

# BLOQUE 3 · La vida del préstamo

Desde que se aprueba hasta que se cierra, se renueva o se da por perdido.

---

### C-27 · ¿En qué estados puede estar un préstamo? 🔴

El sistema necesita una lista cerrada de situaciones posibles, para saber qué se permite
hacer en cada una. En tus documentos aparecen sueltos: temporal, activo, en mora,
castigado, cancelado, renovado, refinanciado.

* Pregunta ------
¿Esta lista está completa y correcta? ¿Falta alguno? ¿Sobra alguno?

*-- Opciones de respuesta ---
A) La lista está completa y correcta
B) Falta alguno — lo agrego abajo
C) Alguno de esos no existe en mi negocio — lo indico abajo
X) Otra — la explico

[Answer]:

*Origen: OQ-F-22*

---

### C-28 · Renovación: ¿qué pasa con la deuda vieja? 🔴

Un cliente debe $300.000 de un préstamo y quiere uno nuevo de $1.000.000.

* Pregunta ------
¿Cómo se hace esa renovación?

*-- Opciones de respuesta ---
A) Se cancela la deuda vieja con el préstamo nuevo: el cliente recibe $700.000 en mano
   y queda debiendo el millón completo
B) El cliente recibe el millón entero y sigue debiendo los dos préstamos por separado
C) Depende del caso, lo decide el administrador
X) Otra — la explico

[Answer]:

**Pregunta adicional:** ¿le renuevas a un cliente que está en mora? ¿O exiges que haya
pagado un mínimo (por ejemplo, el 70% del préstamo anterior) antes de renovarle?

[Answer]:

*Origen: OQ-F-23*

---

### C-29 · Renovar vs. refinanciar: ¿en qué se diferencian? 🔴

Tu documento lista las dos como opciones distintas, pero no explica la diferencia.

* Pregunta ------
¿Qué es "refinanciar" en tu negocio y en qué se diferencia de "renovar"?

*-- Opciones de respuesta ---
A) Refinanciar es reestructurar una deuda que el cliente no puede pagar: se alarga el
   plazo o se bajan las cuotas, sin entregarle plata nueva
B) Refinanciar es lo mismo que renovar, con otro nombre — se puede dejar solo una
C) Es otra cosa — la explico abajo

[Answer]:

**Si es A:** cuando refinancias, ¿el interés se recalcula sobre el saldo, se condona
parte, o se mantiene el pactado?

[Answer]:

*Origen: OQ-F-24*

---

### C-30 · Cancelación anticipada 🔴

* Pregunta ------
Un cliente con 20 cuotas quiere pagar todo en la cuota 5. ¿Cuánto le cobras?

*-- Opciones de respuesta ---
A) El total pactado. El interés era fijo desde el principio y no se rebaja
B) El capital que falta más el interés hasta hoy. Se le perdona el interés futuro
C) Se negocia con el administrador cada vez
X) Otra — la explico

[Answer]:

*Origen: OQ-F-25*

---

### C-31 · "Venta temporal" y "enviar a estudio": ¿son lo mismo? 🟡

En los videos de TryController aparecen dos cosas distintas: guardar los datos de un
cliente indeciso ("venta temporal") y mandar una solicitud a que alguien la estudie
("preventa"). No sabemos si tú usas las dos.

* Pregunta ------
¿Cómo funciona en tu negocio el paso previo a aprobar un préstamo?

*-- Opciones de respuesta ---
A) No hay paso previo: el cobrador presta ahí mismo si está dentro del límite
B) Solo guardamos datos de clientes indecisos, sin que nadie los estudie
C) Hay un estudio real: alguien revisa y aprueba antes de entregar la plata — explico quién
D) Las dos cosas: guardamos indecisos Y hay estudio para montos altos
X) Otra — la explico

[Answer]:

*Origen: OQ-F-26*

---

### C-32 · ¿Cuánto dura guardada una venta temporal? ⚪

* Pregunta ------
Si el cliente indeciso nunca vuelve, ¿qué pasa con esos datos guardados?

*-- Opciones de respuesta ---
A) Se borran solos después de ___ días (escribe el número)
B) Se quedan ahí para siempre hasta que alguien los borre
C) Se quedan pero dejan de aparecerle al cobrador después de un tiempo
X) Otra — la explico

[Answer]:

*Origen: OQ-F-27*

---

### C-33 · Dar por perdido un préstamo 🟡

En TryController esto se llama "limpieza de cobro": se desactiva el cliente para que no
le aparezca al cobrador en la ruta, pero no se borra nada. Si el cliente reaparece, se
reactiva.

* Pregunta ------
¿Cuándo se saca un cliente de la ruta de cobro por incobrable?

*-- Opciones de respuesta ---
A) Manualmente: el administrador decide cuándo, uno por uno
B) Automáticamente después de ___ días sin pagar (escribe el número)
C) Automático, pero el administrador lo puede revertir
X) Otra — la explico

[Answer]:

**Pregunta adicional:** mientras está dado por perdido, ¿le sigue creciendo la deuda por
intereses o mora, o se congela?

[Answer]:

*Origen: OQ-F-28*

---

### C-34 · Corregir una venta ya registrada 🟡

En TryController se puede editar una venta solo el mismo día y solo si no tiene pagos.

* Pregunta ------
¿Mantenemos esa regla?

*-- Opciones de respuesta ---
A) Sí, igual: mismo día y sin movimientos
B) Más flexible: el administrador puede corregir cuando sea, con registro de auditoría
C) Más estricto: nada se corrige, se anula y se vuelve a crear
X) Otra — la explico

[Answer]:

**Pregunta adicional:** ¿y si la venta YA tiene pagos registrados y está mal? ¿Quién la
puede anular?

[Answer]:

*Origen: OQ-F-29*

---

### C-35 · El contrato 🔴

Tu documento dice que al aprobar un préstamo el sistema debe "generar contrato". Es la
única mención en todo el material, y no sabemos qué significa exactamente.

* Pregunta ------
¿Qué debe pasar con el contrato del préstamo?

*-- Opciones de respuesta ---
A) No hay contrato escrito; el registro en el sistema es suficiente
B) Se genera un documento en PDF con una plantilla fija y se le manda al cliente
C) Se genera, el cliente lo firma en la pantalla del celular y queda guardado
D) El contrato se hace en papel, aparte del sistema
X) Otra — la explico

[Answer]:

**Si eliges B o C:** ¿tienes ya el texto del contrato que se usa hoy? Si es así,
compártelo — es la forma más rápida de resolver esto.

[Answer]:

*Origen: OQ-F-82*

---

# BLOQUE 4 · Tu equipo y tu estructura

---

### C-36 · ¿Quiénes usan el sistema y qué puede hacer cada uno? 🔴

En los documentos aparecen mencionados: Administrador, Socio, Gestor y Trabajador. No
sabemos si "Gestor" y "Trabajador" son lo mismo, ni qué puede hacer cada uno.

* Pregunta ------
Enumera los tipos de usuario de tu operación y qué hace cada uno.

*-- Opciones de respuesta ---
A) Son exactamente tres: Administrador, Socio y Cobrador — describo qué hace cada uno
B) Son esos tres más otros — los agrego abajo
C) Son menos — indico cuáles abajo
X) Otra — la explico

[Answer]:

**Para cada tipo de usuario, dinos qué NO debe poder hacer.** Por ejemplo: "el cobrador
no puede ver cuánto gana la empresa", "el socio no puede modificar préstamos", "solo el
administrador puede autorizar montos altos".

[Answer]:

*Origen: OQ-F-1, CX-6*

---

### C-37 · ¿Cómo está organizada la operación? 🔴

En los videos de TryController se habla de "unidad" y de "ruta" como si fueran lo mismo,
y se asume que cada unidad tiene un solo cobrador con un solo celular.

* Pregunta ------
¿Cómo se organiza tu operación?

*-- Opciones de respuesta ---
A) Una ruta = un cobrador = un celular. Simple y así se queda
B) Una ruta puede tener varios cobradores que se turnan
C) Un cobrador puede atender varias rutas
D) Hay varias empresas o sucursales, cada una con sus rutas — lo explico abajo
X) Otra — la explico

[Answer]:

*Origen: OQ-F-2*

---

### C-38 · ¿Cómo se le asignan los clientes a un cobrador? 🔴

El documento dice que "cada gestor visualizará únicamente sus clientes asignados", pero
no dice cómo se asignan.

* Pregunta ------
¿Cómo decides qué clientes le tocan a cada cobrador?

*-- Opciones de respuesta ---
A) El cliente pertenece a la ruta donde se creó, y ahí se queda
B) El administrador los asigna manualmente uno por uno
C) Se asignan por zona geográfica o barrio
X) Otra — la explico

[Answer]:

**Pregunta adicional:** ¿se puede pasar un cliente de un cobrador a otro? ¿Quién lo
autoriza? ¿Se lleva su historial y su deuda?

[Answer]:

*Origen: OQ-F-3*

---

### C-39 · ¿Hay jefes de zona o supervisores? ⚪

* Pregunta ------
¿Existe alguien entre el administrador y el cobrador?

*-- Opciones de respuesta ---
A) No, solo administrador y cobradores
B) Sí, hay supervisores que manejan varias rutas — explico qué pueden hacer
X) Otra — la explico

[Answer]:

*Origen: OQ-F-4*

---

### C-40 · ¿Qué es un "Socio" y qué ve? 🟡

Tu documento dice que todos los días se les debe mandar un reporte por WhatsApp con
ventas, recaudo, mora, caja, gastos y utilidad. Pero no dice si entran al sistema.

* Pregunta ------
¿Los socios usan el sistema?

*-- Opciones de respuesta ---
A) No. Solo reciben el reporte diario por WhatsApp y nada más
B) Sí, entran a ver el tablero, pero no pueden modificar nada
C) Sí, y tienen casi los mismos permisos que el administrador
X) Otra — la explico

[Answer]:

**Pregunta adicional:** si hay varios socios, ¿cada uno ve solo lo suyo (su porcentaje,
sus rutas) o todos ven todo?

[Answer]:

*Origen: OQ-B-14*

---

### C-41 · Los datos del cobrador y el seguro de repatriación 🟡

En los videos aparece que al crear un trabajador se piden datos de su país de origen y su
país de residencia, y que eso sirve para afiliarlo a un seguro de repatriación. Esto no
aparece en tu documento de requerimientos, así que no sabemos si te interesa.

* Pregunta ------
¿Quieres esa funcionalidad del seguro de repatriación?

*-- Opciones de respuesta ---
A) No, no aplica a mi operación
B) Solo quiero guardar los datos del trabajador, sin ninguna conexión con aseguradoras
C) Sí, y quiero que el sistema se conecte con la aseguradora — indico cuál
D) Sí, pero para más adelante, no para la primera versión
X) Otra — la explico

[Answer]:

*Origen: OQ-F-83*

---

# BLOQUE 5 · Los clientes que reciben el préstamo

---

### C-42 · ¿Qué datos son obligatorios para crear un cliente? 🔴

Los documentos dan dos listas distintas. La de los videos de TryController es: documento,
primer nombre, primer apellido, celular, ciudad y dirección. La de tu documento agrega:
ubicación GPS, referencias, fotografías, documentos y observaciones.

* Pregunta ------
¿Qué datos deben ser obligatorios (sin ellos no se puede crear el cliente) y cuáles opcionales?

*-- Opciones de respuesta ---
A) La lista de TryController está bien: documento, nombre, apellido, celular, ciudad, dirección
B) Esa lista más otros que agrego abajo
C) Menos datos: quiero que crear un cliente sea lo más rápido posible — indico el mínimo
X) Otra — la explico

[Answer]:

*Origen: OQ-F-6*

---

### C-43 · ¿Un mismo cliente puede estar en dos rutas? 🔴

Es decir: la misma persona, con el mismo documento, con préstamos de dos cobradores distintos.

* Pregunta ------
¿Eso se permite?

*-- Opciones de respuesta ---
A) No. Un cliente pertenece a una sola ruta. El sistema debe impedirlo y avisar
B) Sí se permite, pero el sistema debe avisar que ya existe en otra ruta
C) Sí, sin restricción — son operaciones independientes
X) Otra — la explico

[Answer]:

**Pregunta adicional:** ¿un mismo cliente puede tener dos préstamos activos al tiempo en
la misma ruta?

[Answer]:

*Origen: OQ-F-7*

---

### C-44 · Las fotos 🟡

El sistema distingue dos tipos: las de la hoja de vida del cliente (documento de identidad,
fachada del negocio, comprobante de residencia), que se quedan para siempre, y las de cada
préstamo (garantías, evidencia de un pago), que van pegadas a esa venta.

* Pregunta ------
El límite de 5 fotos por cliente que existe en TryController, ¿te sirve?

*-- Opciones de respuesta ---
A) Sí, 5 está bien
B) Necesito más — indico cuántas
C) Con menos basta

[Answer]:

**Preguntas adicionales:**
- ¿Cuántas fotos se pueden tomar por préstamo? ¿Hay límite?
- ¿Quién puede borrar una foto? ¿El cobrador o solo el administrador?
- Las fotos de documentos de identidad, ¿por cuánto tiempo hay que guardarlas?

[Answer]:

*Origen: OQ-F-9, CX-9*

---

### C-45 · El GPS 🟡

* Pregunta ------
¿Para qué quieres la ubicación GPS?

*-- Opciones de respuesta ---
A) Solo para guardar dónde vive y dónde trabaja el cliente, y poder llegar
B) Además, para verificar que el cobrador estuvo físicamente donde dice que estuvo
C) Además, para armar la ruta del día en orden geográfico
D) Todas las anteriores
X) Otra — la explico

[Answer]:

**Si eliges B:** ¿qué pasa si el cobrador registra un pago estando lejos del cliente?
¿Se bloquea, se permite con advertencia, o solo queda registrado para que lo revises?

[Answer]:

*Origen: OQ-F-10*

---

### C-46 · Las referencias y codeudores 🟡

* Pregunta ------
Las referencias que se guardan del cliente (familiares, conocidos, codeudores), ¿para qué
se usan?

*-- Opciones de respuesta ---
A) Solo se guardan por si hay que ubicar al cliente. Nadie las contacta desde el sistema
B) Son codeudores reales: responden por la deuda y hay que poder notificarlos
C) Se les avisa por WhatsApp solo si el cliente entra en mora
X) Otra — la explico

[Answer]:

*Origen: OQ-F-11*

---

### C-47 · ¿Se puede borrar un cliente? 🟡

Aquí hay una tensión: tu documento exige que quede registro de absolutamente todo, pero
las leyes de protección de datos suelen darle a la persona el derecho a que borres su
información.

* Pregunta ------
¿Qué debe pasar cuando quieres eliminar un cliente?

*-- Opciones de respuesta ---
A) No se borra nunca. Se puede desactivar, pero el historial se queda
B) Se borra solo si nunca tuvo un préstamo
C) Se borra, pero se conserva el histórico financiero sin sus datos personales
X) Otra — la explico

[Answer]:

*Origen: OQ-F-12, OQ-N-26*

---

### C-48 · ¿Verificas al cliente contra alguna fuente externa? ⚪

* Pregunta ------
¿Consultas a los clientes en alguna central de riesgo o buró de crédito antes de prestar?

*-- Opciones de respuesta ---
A) No, la decisión es del cobrador y del administrador
B) Sí, consultamos en ___ (indico cuál) y me gustaría que el sistema lo hiciera solo
C) Sí, pero manualmente y así se queda
X) Otra — la explico

[Answer]:

*Origen: OQ-F-8*

---

# BLOQUE 6 · El dinero: cajas y cierre

Este bloque decide si la plata cuadra o no. Tu documento describe el resultado que
quieres (un cierre automático idéntico al Excel), pero no las reglas para llegar ahí.

---

### C-49 · ¿Cuántas cajas hay y cómo se relacionan? 🔴

En los documentos aparecen tres: la caja del cobrador, la caja general de la unidad y la
caja de PIX. No se explica cómo se conectan entre ellas.

* Pregunta ------
Explícanos con tus palabras cómo funciona el dinero en tu operación: dónde entra, dónde
se acumula y a dónde va.

*-- Opciones de respuesta ---
A) Lo escribo abajo con mis palabras
B) Prefiero explicarlo en una llamada o reunión

[Answer]:

*Origen: OQ-F-45*

---

### C-50 · ¿Cuándo se abre y se cierra la caja? 🔴

* Pregunta ------
¿Cómo es el ciclo de la caja de un cobrador?

*-- Opciones de respuesta ---
A) Abre en la mañana y cierra en la tarde, una vez al día
B) Puede estar abierta varios días seguidos
C) Se cierra cuando entrega el dinero, que no siempre es diario
X) Otra — la explico

[Answer]:

**Preguntas adicionales:**
- ¿El cobrador abre su propia caja o se la abre el administrador?
- ¿Puede haber dos cajas abiertas al tiempo en la misma ruta?
- ¿Qué pasa si se le olvida cerrar la caja?

[Answer]:

*Origen: OQ-F-46*

---

### C-51 · ¿Qué pasa cuando la plata no cuadra? 🔴

**Esta es la pregunta más importante del bloque, y no aparece en ningún documento.** El
cobrador cierra caja: el sistema dice que recogió $850.000 pero él tiene $840.000 en el
bolsillo. Faltan $10.000.

* Pregunta ------
¿Qué debe hacer el sistema con esa diferencia?

*-- Opciones de respuesta ---
A) No dejar cerrar la caja hasta que cuadre exactamente
B) Dejar cerrar, registrando el faltante como una deuda del cobrador
C) Dejar cerrar solo si el administrador autoriza la diferencia
D) Dejar cerrar y ya, solo registrarlo para revisarlo después
X) Otra — la explico

[Answer]:

**Preguntas adicionales:**
- ¿Y si sobra plata en vez de faltar?
- ¿Hay un margen de tolerancia? (por ejemplo, diferencias menores a $5.000 pasan solas)
- ¿El faltante se le descuenta al cobrador de su sueldo o comisión?

[Answer]:

*Origen: OQ-F-47*

---

### C-52 · ¿Cómo entrega el cobrador la plata? 🔴

Tu documento menciona "consignaciones" como un concepto, pero no explica el flujo.

* Pregunta ------
¿Qué hace el cobrador con el efectivo que recogió?

*-- Opciones de respuesta ---
A) Lo consigna en el banco y sube la foto del comprobante al sistema
B) Se lo entrega en mano al administrador, que confirma en el sistema que lo recibió
C) Lo guarda y financia con eso los préstamos nuevos del día siguiente
D) Varias de las anteriores, depende — lo explico abajo
X) Otra — la explico

[Answer]:

**Pregunta adicional:** ¿la entrega debe quedar confirmada por las dos partes (el que
entrega y el que recibe) para que cuente?

[Answer]:

*Origen: OQ-F-48*

---

### C-53 · ¿De dónde sale la plata que se presta? 🔴

* Pregunta ------
Cuando el cobrador hace un préstamo nuevo en la calle, ¿de dónde sale ese efectivo?

*-- Opciones de respuesta ---
A) De lo que ha recogido ese día: sale de su propia caja
B) De un fondo que le entrega el administrador en la mañana
C) El cliente recibe la plata por transferencia, no del cobrador
X) Otra — la explico

[Answer]:

**Pregunta adicional:** si el cobrador no tiene efectivo suficiente en la caja, ¿el
sistema debe impedirle registrar el préstamo?

[Answer]:

*Origen: OQ-F-51*

---

### C-54 · Los gastos 🟡

* Pregunta ------
¿Qué gastos se registran y quién puede registrarlos?

*-- Opciones de respuesta ---
A) Solo el administrador registra gastos, desde la web
B) El cobrador también puede (gasolina, comida, transporte), sin límite
C) El cobrador puede, pero hasta un tope diario; por encima necesita autorización
X) Otra — la explico

[Answer]:

**Preguntas adicionales:**
- ¿Quieres una lista fija de categorías de gasto? ¿Cuáles?
- ¿Se exige foto del recibo?

[Answer]:

*Origen: OQ-F-49*

---

### C-55 · ¿Qué es exactamente el "dinero pendiente"? 🔴

En tu documento, el cierre de caja debe calcular: Total PIX, Total Dinero, Caja, Gastos,
**Dinero pendiente** y Caja final. Los cinco primeros se entienden. El sexto no está definido.

* Pregunta ------
¿Qué significa "dinero pendiente" en tu cierre?

*-- Opciones de respuesta ---
A) Plata que el cobrador recogió pero todavía no ha entregado
B) Cuotas que se debían cobrar hoy y no se cobraron
C) Plata que un cliente prometió traer y no llegó
X) Otra — la explico

[Answer]:

*Origen: OQ-F-50*

---

### C-56 · El cierre: ¿de quién y de qué? 🔴

* Pregunta ------
¿El cierre de caja se hace por cobrador, por ruta o de toda la empresa?

*-- Opciones de respuesta ---
A) Uno por cobrador, y aparte uno consolidado de toda la empresa
B) Solo uno consolidado por ruta
C) Solo uno general de toda la empresa
X) Otra — la explico

[Answer]:

*Origen: OQ-F-54*

---

### C-57 · 📎 Necesitamos tu Excel actual 🔴

**Esta no es una pregunta, es una petición — y es de las más valiosas que puedes atender.**

Tu documento pide que el sistema genere "un reporte idéntico al formato utilizado
actualmente" en Excel. Sin ver ese archivo, ese requisito es imposible de cumplir y de
verificar: no sabemos qué columnas tiene, en qué orden, ni cómo se calcula cada total.

* Pregunta ------
¿Nos puedes compartir el archivo de Excel que usan hoy para el cierre de caja, con datos
de un día real (aunque cambies los nombres de los clientes)?

*-- Opciones de respuesta ---
A) Sí, lo adjunto
B) Sí, pero necesito quitarle datos sensibles primero
C) No lo puedo compartir, pero puedo mandar una foto o captura de pantalla
D) No lo puedo compartir de ninguna forma

[Answer]:

*Origen: OQ-F-52*

---

### C-58 · ¿Se puede corregir un cierre ya hecho? 🟡

* Pregunta ------
Si el cierre de ayer quedó mal, ¿qué se hace?

*-- Opciones de respuesta ---
A) Solo el administrador lo puede reabrir y corregir, y queda registrado quién lo hizo
B) No se toca. Se corrige con un ajuste en el día de hoy
C) Nadie lo puede corregir
X) Otra — la explico

[Answer]:

*Origen: OQ-F-53*

---

# BLOQUE 7 · Autorizaciones (las "llaves")

El sistema de llaves es el control que te permite delegar la operación en la calle sin
perder el control del capital. En TryController funciona así: si el cobrador intenta algo
que pasa un límite, el sistema lo bloquea y le pide un código que solo tú puedes dar.

---

### C-59 · ¿Qué operaciones deben pedir autorización? 🔴

En los videos aparecen dos casos: vender por encima del monto límite, y recibir más
cuotas adelantadas de las permitidas.

* Pregunta ------
¿Qué debe requerir tu autorización? (puedes marcar varias)

*-- Opciones de respuesta ---
A) Préstamos por encima de un monto límite
B) Recibir más de X cuotas adelantadas
C) Anular o corregir un pago ya registrado
D) Dar un descuento o condonar una deuda
E) Registrar un gasto alto
F) Reactivar un cliente dado por perdido
G) Prestarle a un cliente que está en mora
X) Otras — las explico

[Answer]:

*Origen: OQ-F-39*

---

### C-60 · ¿Los códigos vencen? 🔴

* Pregunta ------
Un código de autorización que le diste al cobrador, ¿hasta cuándo sirve?

*-- Opciones de respuesta ---
A) Solo para esa operación exacta y por un tiempo corto (indico cuántos minutos)
B) Solo para esa operación, sin límite de tiempo
C) Sirve para cualquier operación del día
X) Otra — la explico

[Answer]:

**Pregunta adicional:** ¿un mismo código se puede usar dos veces?

[Answer]:

*Origen: OQ-F-40*

---

### C-61 · ¿Quién puede autorizar? 🔴

* Pregunta ------
¿Quién puede dar los códigos de autorización?

*-- Opciones de respuesta ---
A) Solo el administrador principal
B) El administrador y los supervisores
C) Cualquiera con permiso de administración
X) Otra — la explico

[Answer]:

**Pregunta adicional importante:** ¿debe existir un tope tan alto que ni siquiera el
administrador lo pueda aprobar solo? (Es un control clásico contra el fraude interno.)

[Answer]:

*Origen: OQ-F-41*

---

### C-62 · ¿Y si el cobrador no tiene señal? 🔴

Aquí hay un choque entre dos requisitos de tu documento: la app debe funcionar sin
internet, pero pedir una llave requiere que el celular hable con el servidor.

* Pregunta ------
¿Qué debe pasar si el cobrador necesita autorización y no tiene señal?

*-- Opciones de respuesta ---
A) No puede hacer la operación. Punto. Que espere a tener señal
B) Te llama por teléfono, le dictas un código y lo ingresa (esto es la "llave manual")
C) Puede hacerla y queda pendiente de tu aprobación cuando sincronice
X) Otra — la explico

[Answer]:

*Origen: OQ-F-42, OQ-F-39*

---

### C-63 · Llave manual y llave automática: ¿las dos? 🟡

En TryController hay dos formas: la **automática** (el cobrador pide desde la app, tú
apruebas desde la web, le llega el código al celular) y la **manual** (tú le das el
código por fuera del sistema, por teléfono o en persona).

* Pregunta ------
¿Cuáles quieres?

*-- Opciones de respuesta ---
A) Las dos, igual que en TryController
B) Solo la automática. Es más ordenada y deja mejor rastro
C) Solo la manual. Es más simple
X) Otra — la explico

[Answer]:

*Origen: CX-10, OQ-F-43*

---

### C-64 · Los límites: ¿quién los pone y de qué tamaño? 🟡

* Pregunta ------
Los límites que disparan una autorización (monto máximo de préstamo, máximo de cuotas
adelantadas), ¿cómo se configuran?

*-- Opciones de respuesta ---
A) Uno solo para toda la empresa
B) Uno distinto por cada ruta o unidad
C) Uno distinto por cada cobrador, según su confianza
X) Otra — la explico

[Answer]:

**Pregunta adicional:** ¿nos das los valores que usas hoy, como referencia?

[Answer]:

*Origen: OQ-F-39, OQ-F-32*

---

# BLOQUE 8 · La calle: cobranza y trabajo sin señal

Tu documento pide que la app funcione sin internet y sincronice sola cuando haya señal.
Eso suena simple pero es la parte más delicada del sistema, porque abre la puerta a que
dos personas cambien lo mismo al tiempo.

---

### C-65 · ¿Qué debe poder hacer el cobrador sin señal? 🔴

* Pregunta ------
Marca todo lo que el cobrador debe poder hacer sin internet:

*-- Opciones de respuesta ---
A) Ver su lista de clientes del día
B) Registrar pagos en efectivo
C) Registrar "no pago" y visitas
D) Tomar fotos
E) Recoger la firma del cliente
F) Registrar un pago por PIX
G) **Crear un préstamo nuevo completo**
H) Todas las anteriores
X) Otra combinación — la explico

[Answer]:

*Origen: OQ-F-74*

---

### C-66 · ¿Cuánto tiempo puede estar sin sincronizar? 🔴

Mientras el celular no sincroniza, tú no ves nada de lo que está pasando en la calle, y
el riesgo crece.

* Pregunta ------
¿Cuánto tiempo puede pasar un cobrador sin conectarse antes de que le bloquees la app?

*-- Opciones de respuesta ---
A) Debe sincronizar al menos una vez al día, o se bloquea
B) Hasta ___ días sin sincronizar (escribe el número)
C) Sin límite, la señal es mala y no quiero bloquear a nadie
X) Otra — la explico

[Answer]:

*Origen: OQ-F-76*

---

### C-67 · ¿Con qué fecha quedan los pagos hechos sin señal? 🔴

Un cobrador registra un pago el martes a las 3 de la tarde, pero su celular solo
sincroniza el miércoles en la mañana.

* Pregunta ------
¿De qué día es ese pago?

*-- Opciones de respuesta ---
A) Del martes, con la hora en que el cobrador lo registró
B) Del miércoles, cuando entró al sistema
C) Del martes para el cliente, pero afecta la caja del miércoles
X) Otra — la explico

[Answer]:

*Origen: OQ-F-77*

---

### C-68 · Si tú y el cobrador cambian lo mismo al tiempo 🔴

Situación real: tú, desde la web, cancelas un préstamo por un acuerdo con el cliente.
Al mismo tiempo, el cobrador —que está sin señal— le registra un pago a ese mismo préstamo.
Cuando sincroniza, el sistema tiene dos verdades que se contradicen.

* Pregunta ------
¿Quién debe ganar?

*-- Opciones de respuesta ---
A) Siempre lo que hizo el administrador desde la web
B) Siempre lo que hizo el cobrador, porque él estuvo con el cliente
C) Ninguno: el sistema marca el conflicto y alguien lo resuelve a mano
X) Otra — la explico

[Answer]:

*Origen: OQ-F-75*

---

### C-69 · Actualizar la información en el celular 🔴

En TryController existe algo llamado "descargas de la UGI": si tú reactivas un cliente
desde la web mientras el cobrador tiene la caja abierta, él no lo ve hasta que entra a
Configuración y descarga la actualización a mano.

Tu documento de requerimientos, en cambio, pide "sincronización automática". Son dos
cosas distintas y hay que elegir.

* Pregunta ------
¿Cómo quieres que funcione?

*-- Opciones de respuesta ---
A) Automático: los cambios de la web llegan solos al celular apenas hay señal.
   Se elimina el paso manual
B) Como TryController: el cobrador descarga cuando lo necesita. Prefiero que él
   controle cuándo cambia su lista
C) Automático, pero avisándole al cobrador que su lista cambió
X) Otra — la explico

[Answer]:

*Origen: OQ-F-80, CX-4*

---

### C-70 · Un celular por ruta 🟡

TryController exige que cada ruta tenga un solo celular vinculado. Si se daña o se pierde,
tú lo desvinculas desde la web y ese teléfono queda bloqueado al instante.

* Pregunta ------
¿Mantenemos esa regla?

*-- Opciones de respuesta ---
A) Sí, un solo celular por ruta. Es un control de seguridad que me sirve
B) No, que el cobrador pueda entrar desde cualquier celular con su usuario y clave
C) Un celular, pero que se pueda cambiar rápido sin depender de mí
X) Otra — la explico

[Answer]:

*Origen: OQ-F-79*

---

### C-71 · ⚠️ Desvincular un celular con información sin sincronizar 🔴

Este es un riesgo real de perder plata y no está resuelto en ningún documento.

Situación: el cobrador registró 30 pagos en la mañana, no ha tenido señal, y a mediodía
te dice que perdió el celular. Tú lo desvinculas desde la web para proteger la información.
**Esos 30 pagos nunca llegaron al servidor.**

* Pregunta ------
¿Qué debe pasar con esa información?

*-- Opciones de respuesta ---
A) El sistema debe advertirme antes de desvincular: "este equipo tiene 30 movimientos
   sin sincronizar, si continúas se pierden"
B) Se pierden y ya. Se vuelven a registrar a mano
C) Debe existir alguna forma de recuperarlos después
X) Otra — la explico

[Answer]:

**Pregunta adicional:** al desvincular, ¿quieres que se borre la información guardada en
ese celular, en caso de robo?

[Answer]:

*Origen: OQ-F-78*

---

### C-72 · La firma del cliente 🔴

Tu documento pide "firma digital". Esa palabra significa dos cosas muy distintas:

- **Firma dibujada:** el cliente firma con el dedo en la pantalla y se guarda como imagen.
  Sencillo y barato. Sirve como constancia interna.
- **Firma electrónica certificada:** con un proveedor autorizado, certificados y sello de
  tiempo. Tiene validez legal plena ante un juez. Cuesta dinero por cada firma y es más
  complejo.

* Pregunta ------
¿Cuál necesitas?

*-- Opciones de respuesta ---
A) La dibujada en pantalla. Con eso me basta
B) La certificada con validez legal — es importante para cobrar judicialmente
C) No sé cuál necesito legalmente; necesito asesoría
X) Otra — la explico

[Answer]:

*Origen: OQ-F-81*

---

### C-73 · ¿La ruta del día se ordena sola? 🟡

Un reporte que generamos describe la "limpieza de cobro" como optimización de ruta, pero
en realidad esa función solo **oculta** clientes inactivos: no ordena las visitas por
cercanía geográfica.

* Pregunta ------
¿Quieres que el sistema le arme la ruta al cobrador?

*-- Opciones de respuesta ---
A) No. Con que vea su lista de clientes basta; él sabe su recorrido
B) Sí, quiero que le ordene las visitas del día por cercanía en el mapa
C) Sí, y además que le muestre el mapa con todos sus clientes ubicados
D) Más adelante, no en la primera versión
X) Otra — la explico

[Answer]:

*Origen: CX-5*

---

### C-74 · ¿El administrador también usa la app del celular? ⚪

* Pregunta ------
¿Quién usa la app móvil?

*-- Opciones de respuesta ---
A) Solo los cobradores. El administrador trabaja desde el computador
B) También el administrador, para consultar cuando está fuera de la oficina
C) También los socios, para ver el resumen del día
X) Otra — la explico

[Answer]:

*Origen: OQ-F-84*

---

# BLOQUE 9 · WhatsApp y avisos

Tu documento pide que el sistema mande mensajes automáticos por WhatsApp cuando se
registra un préstamo, cuando se paga, cuando no se paga, como recordatorio, y un reporte
diario a los socios.

**Algo importante que debes saber:** WhatsApp para empresas no funciona como WhatsApp
normal. Hay que tener una cuenta de empresa aprobada, los mensajes automáticos deben usar
**plantillas que Meta aprueba una por una** (no se puede mandar cualquier texto), y **cada
conversación tiene un costo**. Además, hay que tener permiso del cliente para escribirle.

---

### C-75 · ¿Ya tienes cuenta de WhatsApp Business API? 🔴

* Pregunta ------
¿En qué punto estás con WhatsApp?

*-- Opciones de respuesta ---
A) Ya tengo cuenta de WhatsApp Business API con un número verificado
B) Tengo WhatsApp Business normal (la app), pero no la versión API
C) No tengo nada, uso WhatsApp personal
D) No sé la diferencia

[Answer]:

*Origen: OQ-F-57*

---

### C-76 · ¿Quién escribe los mensajes? 🔴

Cada tipo de mensaje automático necesita un texto exacto, aprobado previamente por Meta.
Ese proceso toma días.

* Pregunta ------
¿Tienes ya los textos de los mensajes que quieres mandar?

*-- Opciones de respuesta ---
A) Sí, los tengo o los escribo yo — los mando abajo o después
B) No, prefiero que ustedes los propongan y yo los apruebo
C) Quiero que se parezcan a los que mando hoy a mano — les comparto ejemplos

[Answer]:

*Origen: OQ-F-58*

---

### C-77 · El permiso del cliente 🔴

Antes de mandarle mensajes automáticos a alguien, tanto Meta como las leyes de datos
exigen que esa persona haya dado permiso, y que quede registrado cuándo lo dio.

* Pregunta ------
¿Cómo vas a pedir ese permiso?

*-- Opciones de respuesta ---
A) Que quede en el contrato o pagaré que el cliente firma al pedir el préstamo
B) Que el cobrador se lo pregunte y lo marque en la app al crear el cliente
C) Que el primer mensaje que reciba sea justamente pidiéndole permiso
D) No lo había pensado; necesito orientación

[Answer]:

**Pregunta adicional:** si un cliente pide que le dejen de escribir, ¿el sistema debe
dejar de mandarle todo, o seguir mandándole los avisos de cobro?

[Answer]:

*Origen: OQ-F-59*

---

### C-78 · ¿Qué mensajes son de verdad necesarios? 🟡

Cada mensaje cuesta plata. En un préstamo diario de 20 cuotas, avisar cada pago son 20
mensajes por préstamo, por cliente.

* Pregunta ------
Marca los avisos que consideras indispensables:

*-- Opciones de respuesta ---
A) Al registrar un préstamo nuevo (valor, cuotas, fechas)
B) Cada vez que el cliente paga
C) Cuando el cliente no paga
D) Recordatorio antes del vencimiento
E) Recordatorios después del vencimiento (a los 1, 3, 7 días)
F) Resumen diario a los socios
G) Todos

[Answer]:

**Si marcaste B:** en préstamos diarios, ¿de verdad quieres un mensaje por cada cuota, o
prefieres un resumen semanal?

[Answer]:

*Origen: OQ-F-62, OQ-N-40*

---

### C-79 · ¿Y si el cliente no tiene WhatsApp? 🟡

* Pregunta ------
¿Qué hace el sistema si el mensaje no se puede entregar?

*-- Opciones de respuesta ---
A) Nada, solo lo registra como fallido para que alguien lo revise
B) Lo intenta de nuevo varias veces
C) Manda un SMS como respaldo (tiene costo aparte)
D) Le avisa al cobrador para que llame al cliente
X) Otra — la explico

[Answer]:

*Origen: OQ-F-60*

---

### C-80 · ¿Alguien lee lo que responden los clientes? 🟡

Si le mandas un mensaje a un cliente, él puede responder. Esa respuesta llega a algún lado.

* Pregunta ------
¿Qué pasa con las respuestas de los clientes?

*-- Opciones de respuesta ---
A) Nadie las lee. Es un canal de solo salida
B) Quiero una bandeja dentro del sistema donde el administrador las vea y responda
C) Que le lleguen al cobrador asignado a ese cliente
X) Otra — la explico

[Answer]:

*Origen: OQ-F-61*

---

### C-81 · El reporte diario a los socios 🟡

* Pregunta ------
¿A qué hora debe salir el reporte diario, y qué pasa si a esa hora todavía hay cajas sin cerrar?

*-- Opciones de respuesta ---
A) A una hora fija (indico cuál), con lo que haya hasta ese momento
B) Cuando cierren todas las cajas del día, sin hora fija
C) A una hora fija, pero indicando en el mensaje qué rutas faltan por cerrar
X) Otra — la explico

[Answer]:

*Origen: OQ-F-62*

---

# BLOQUE 10 · Reportes y tablero

---

### C-82 · Los números del tablero 🔴

Tu documento pide 13 indicadores en el tablero principal: capital prestado, capital
recuperado, intereses cobrados, clientes activos, clientes morosos, recaudo del día,
caja del día, PIX recibido, dinero en efectivo, gastos, utilidad estimada, préstamos
nuevos y renovaciones.

El problema es que varios de esos nombres significan cosas distintas según a quién le
preguntes. "Utilidad estimada", por ejemplo, puede ser el interés que se causó, el
interés que ya se cobró, o lo cobrado menos los gastos.

* Pregunta ------
¿Nos puedes definir cómo se calcula cada uno? Empieza por los que más te importan.

*-- Opciones de respuesta ---
A) Los defino abajo, uno por uno
B) Prefiero explicarlo en una reunión mirando el Excel actual
C) Con que se parezcan al Excel de hoy me sirve

[Answer]:

**Si tuvieras que ver solo 3 números al abrir el sistema en la mañana, ¿cuáles serían?**

[Answer]:

*Origen: OQ-F-85*

---

### C-83 · ¿Qué tan al instante necesitas los números? 🔴

"Tiempo real" es caro. Si el tablero puede actualizarse cada 5 minutos en vez de al
instante, el sistema es bastante más simple y barato.

* Pregunta ------
¿Qué tan actualizado necesitas el tablero?

*-- Opciones de respuesta ---
A) Al instante: si el cobrador registra un pago, quiero verlo ya
B) Cada pocos minutos está bien
C) Con que esté al día de ayer me sirve para decidir
X) Otra — la explico

[Answer]:

*Origen: OQ-F-86*

---

### C-84 · ¿Quién ve qué? 🟡

* Pregunta ------
¿Qué debe ver cada quien en el tablero?

*-- Opciones de respuesta ---
A) El administrador ve todo; el socio ve todo menos gastos internos; el cobrador solo lo suyo
B) Todos ven lo mismo
C) Cada uno ve solo su ruta o su porcentaje — lo detallo abajo
X) Otra — la explico

[Answer]:

*Origen: OQ-F-87*

---

### C-85 · ¿Qué reportes usas de verdad? 🟡

Tu documento lista 9 reportes: ventas, cobranza, mora, caja, PIX, efectivo, flujo de caja,
rentabilidad y comparativos. Construirlos todos toma tiempo.

* Pregunta ------
¿Cuáles necesitas desde el primer día, y cuáles pueden esperar?

*-- Opciones de respuesta ---
A) Los indico abajo, separando "desde el día uno" de "después"
B) Todos son indispensables
C) Con el cierre de caja diario y el de mora me arranco

[Answer]:

*Origen: OQ-F-55*

---

### C-86 · ¿Necesitas contabilidad de verdad? 🔴

Tu documento dice que cada pago debe "registrar el movimiento contable", y uno de los
reportes lo llama "asiento contable automático". Esas dos frases pueden significar cosas
muy distintas, y la diferencia de esfuerzo entre una y otra es enorme.

* Pregunta ------
¿Qué necesitas exactamente?

*-- Opciones de respuesta ---
A) Solo un registro ordenado de entradas y salidas de plata. No es contabilidad formal
B) Contabilidad formal de partida doble, con plan de cuentas, para entregarle al contador
C) Que el sistema exporte la información en un formato que mi contador pueda cargar en
   su programa — indico cuál usa
X) Otra — la explico

[Answer]:

*Origen: OQ-F-56*

---

# BLOQUE 11 · Inteligencia artificial

Tu documento pide un asistente que responda preguntas como "¿cuánto vendimos hoy?" o
"¿qué clientes puedo renovar?", y que además detecte fraude y riesgo.

Es la parte más llamativa del proyecto y también la más cara. Es la única funcionalidad
que, si no existe, no impide operar el negocio ni un solo día.

---

### C-87 · ¿La quieres en la primera versión? 🔴

* Pregunta ------
¿Cuándo necesitas el asistente de IA?

*-- Opciones de respuesta ---
A) En la primera versión. Es parte de lo que hace especial al producto
B) En una segunda etapa. Primero que la operación funcione bien
C) Es un "estaría bien", no una prioridad
X) Otra — la explico

[Answer]:

*Origen: OQ-F-67*

---

### C-88 · ¿Solo consulta o también hace cosas? 🔴

* Pregunta ------
¿Qué debe poder hacer el asistente?

*-- Opciones de respuesta ---
A) Solo responder preguntas sobre los datos. No modifica nada
B) También ejecutar acciones: registrar pagos, aprobar autorizaciones, mandar mensajes
C) Responder, y proponer acciones que yo confirmo antes de que se ejecuten
X) Otra — la explico

[Answer]:

*Origen: OQ-F-68*

---

### C-89 · Los números que dé, ¿pueden estar aproximados? 🔴

Las inteligencias artificiales a veces se equivocan al dar cifras, y lo hacen con
total seguridad. En un sistema de dinero eso es grave: si el asistente dice que recaudaste
$4.200.000 cuando fueron $4.020.000, y tú tomas una decisión con ese número, el problema
es real.

Se puede construir de forma que las cifras salgan siempre de una consulta exacta a la base
de datos, y no de lo que el modelo "cree". Es más trabajo, pero es lo correcto para plata.

* Pregunta ------
¿Qué nivel de exactitud exiges?

*-- Opciones de respuesta ---
A) Exactitud total. Las cifras deben venir de la base de datos, siempre
B) Aproximaciones sirven para tener una idea rápida
C) Que dé el número exacto y también me deje ver de dónde lo sacó

[Answer]:

*Origen: OQ-F-70*

---

### C-90 · ¿Los datos pueden salir de tus servidores? 🔴

Los asistentes de IA más capaces funcionan enviando la información a servidores de
empresas como OpenAI, Google o Anthropic, que normalmente están fuera de tu país. Existen
alternativas que corren en tu propia infraestructura, pero son menos capaces y más caras
de operar.

Tu documento exige mucha seguridad y auditoría, así que hay que ser explícitos aquí.

* Pregunta ------
¿Aceptas que los datos de tus clientes (nombres, montos, deudas) se procesen en servidores
de un proveedor externo?

*-- Opciones de respuesta ---
A) Sí, si el proveedor es serio y no usa mis datos para entrenar sus modelos
B) Solo si la información va anonimizada, sin nombres ni documentos
C) No. Todo tiene que quedarse en mi infraestructura
D) No sé qué implica; necesito que me lo expliquen mejor

[Answer]:

*Origen: OQ-F-69*

---

### C-91 · ¿Quién puede preguntarle y sobre qué datos? 🔴

* Pregunta ------
¿Quién tiene acceso al asistente?

*-- Opciones de respuesta ---
A) Solo el administrador, y ve datos de toda la empresa
B) El administrador y los socios
C) También los cobradores, pero solo sobre sus propios clientes
X) Otra — la explico

[Answer]:

**Sobre detección de fraude:** ¿qué comportamientos concretos te gustaría que el sistema
detectara? Piensa en cosas que ya te han pasado. Por ejemplo: un cobrador que registra
muchos "no pago" y luego el cliente aparece al día, pagos siempre registrados a la misma
hora, clientes que pagan puntual y de repente desaparecen.

[Answer]:

*Origen: OQ-F-72, OQ-F-71*

---

# BLOQUE 12 · Automatizaciones

---

### C-92 · El "motor de automatización": ¿quién lo configura? 🔴

Tu documento pide un motor de reglas del tipo "SI pasa esto → ENTONCES haz aquello", y lo
llama *configurable*. Pero todos los ejemplos que da son reglas fijas.

La diferencia es enorme:

- **Reglas fijas:** nosotros programamos los comportamientos que tú nos digas. Funcionan
  perfecto, pero cambiarlos requiere pedirnos un cambio.
- **Reglas configurables:** tú entras a una pantalla y armas tus propias reglas sin
  depender de nadie. Es mucho más potente y también mucho más caro de construir.

* Pregunta ------
¿Cuál necesitas?

*-- Opciones de respuesta ---
A) Reglas fijas. Te digo cuáles quiero y ustedes las dejan funcionando
B) Configurables. Quiero poder cambiar las reglas yo mismo
C) Fijas al principio, configurables más adelante
X) Otra — la explico

[Answer]:

*Origen: OQ-F-64, OQ-F-65*

---

# BLOQUE 13 · Lo legal y lo delicado

Tu sistema va a guardar fotos de documentos de identidad, ubicaciones exactas de las casas
de las personas, firmas y su historial de deudas. Eso son datos personales sensibles, y en
casi todos los países hay leyes que regulan cómo se manejan.

No esperamos que seas abogado. Pero necesitamos saber qué sabes y qué no, porque hay
requisitos legales que cambian cómo se construye el sistema y que salen carísimos si se
descubren después.

---

### C-93 · ¿Tu actividad está regulada? 🔴

* Pregunta ------
Prestar dinero en tu país, ¿requiere licencia o registro ante alguna autoridad?

*-- Opciones de respuesta ---
A) Sí, y ya la tenemos
B) Sí, y estamos en trámite
C) No, es una actividad libre
D) No lo sé con certeza

[Answer]:

*Origen: OQ-N-23*

---

### C-94 · ¿Hay un tope legal de interés? 🔴

En muchos países existe una tasa máxima (tasa de usura) por encima de la cual el préstamo
es ilegal. Si existe en el tuyo, el sistema debería avisar o directamente impedir que se
pase de ahí.

* Pregunta ------
¿Existe un tope legal de interés que aplique a tu negocio?

*-- Opciones de respuesta ---
A) Sí, y quiero que el sistema no me deje pasarme de ahí
B) Sí, pero solo quiero que me avise, no que me bloquee
C) No existe tope en mi país
D) No lo sé

[Answer]:

*Origen: OQ-N-23, OQ-F-14*

---

### C-95 · Protección de datos de tus clientes 🔴

* Pregunta ------
¿Qué tan al día estás con la ley de protección de datos personales de tu país?

*-- Opciones de respuesta ---
A) Al día: tenemos aviso de privacidad y pedimos autorización a los clientes por escrito
B) Sabemos que existe pero no hemos hecho nada formal
C) No sabía que aplicaba a mi negocio
D) No sé qué ley aplica

[Answer]:

*Origen: OQ-N-21, OQ-N-22*

---

### C-96 · ¿Tienes que reportar operaciones sospechosas? 🟡

Uno de los reportes menciona "rastreo de lavado de activos". En varios países, quien
maneja efectivo tiene obligación de reportar operaciones inusuales a una autoridad.

**Ojo con quién tiene la obligación:** como el sistema no recibe dinero, esa obligación
—si existe— es **tuya como empresa prestamista**, no del software. Lo único que
cambiaría es que el sistema tendría que **sacarte el reporte** que la autoridad pide.

* Pregunta ------
¿Tienes esa obligación?

*-- Opciones de respuesta ---
A) Sí, reportamos a ___ (indico la autoridad) y necesito que el sistema genere ese reporte
B) Sí, pero el reporte lo armo yo por fuera; el sistema solo debe darme los datos
C) No aplica a mi tamaño de operación
D) No lo sé

[Answer]:

*Origen: OQ-N-24 · acotada por la decisión D-01*

---

### C-97 · ¿Cuántos años hay que guardar todo? 🔴

* Pregunta ------
¿Por cuánto tiempo debes conservar los registros de préstamos, pagos y comprobantes?

*-- Opciones de respuesta ---
A) ___ años por obligación legal (escribe el número)
B) Para siempre, por decisión propia
C) No lo sé

[Answer]:

*Origen: OQ-N-13*

---

### C-98 · ¿Dónde pueden estar guardados los datos? 🔴

* Pregunta ------
¿Existe alguna exigencia de que la información se guarde físicamente en tu país?

*-- Opciones de respuesta ---
A) Sí, los datos deben quedarse en el país
B) No hay restricción
C) No lo sé

[Answer]:

*Origen: OQ-N-25*

---

### C-99 · El fraude interno 🔴

Hablemos claro: en este negocio, el riesgo más grande no suele ser el cliente que no paga,
sino el cobrador que recibe la plata y no la reporta. Tu documento pide muchísima auditoría,
lo que sugiere que esto te preocupa.

Contarnos qué te ha pasado nos permite diseñar controles que sirvan de verdad.

* Pregunta ------
¿Qué formas de pérdida o fraude interno has vivido o te preocupan?

*-- Opciones de respuesta ---
A) Cobrar y no registrar el pago
B) Registrar "no pago" cuando el cliente sí pagó
C) Prestar a clientes inventados
D) Cobrar más de lo que dice el sistema y quedarse con la diferencia
E) Demorar la entrega del dinero recogido
F) Varias de las anteriores — lo explico abajo
G) Nunca me ha pasado, pero quiero prevenirlo

[Answer]:

**¿Cómo lo controlas hoy? ¿Qué te gustaría que hiciera el sistema para ayudarte?**

[Answer]:

*Origen: OQ-N-20*

---

# BLOQUE 14 · Tamaño y expectativas

Estas preguntas parecen técnicas pero solo tú las puedes responder, porque dependen de
cómo funciona tu negocio y de cuánto estás dispuesto a invertir.

---

### C-100 · ¿A dónde quieres llegar? 🔴

* Pregunta ------
Dentro de un año y dentro de dos, ¿cuántos clientes, cobradores y rutas esperas tener?

*-- Opciones de respuesta ---
A) Los escribo abajo
B) Quiero crecer pero no tengo cifras
C) No pienso crecer, quiero ordenar lo que tengo

[Answer]:

*Origen: OQ-N-1*

---

### C-101 · ¿Cuándo se usa más el sistema? 🟡

Saber en qué horas se concentra el trabajo nos ayuda a dimensionar el sistema.

* Pregunta ------
¿En qué momento del día trabajan todos los cobradores al tiempo?

*-- Opciones de respuesta ---
A) Toda la mañana, entre ___ y ___ (escribe el horario)
B) Todo el día parejo
C) Hay dos picos: mañana y tarde
X) Otra — la explico

[Answer]:

*Origen: OQ-N-3*

---

### C-102 · Si el sistema se cae, ¿qué tan grave es? 🔴

Ningún sistema está disponible el 100% del tiempo. La diferencia entre "casi siempre
disponible" y "prácticamente siempre disponible" puede multiplicar varias veces el costo
mensual de operación.

* Pregunta ------
¿Cuánto tiempo caído puedes tolerar?

*-- Opciones de respuesta ---
A) Nada. Si se cae 10 minutos en la mañana de cobro, es un problema serio
B) Un par de horas se manejan, siempre que no sea en horario de cobro
C) Un día completo se aguanta; los cobradores trabajan sin señal de todas formas

[Answer]:

**Pregunta adicional:** ¿hay alguna franja horaria en la que el sistema no se puede caer
bajo ninguna circunstancia?

[Answer]:

*Origen: OQ-N-8, OQ-N-9, OQ-N-12*

---

### C-103 · Si algo falla, ¿cuánta información puedes permitirte perder? 🔴

Tu documento pide copias de seguridad cada hora. Eso significa que, en el peor caso, se
perdería hasta una hora de trabajo: los pagos de esa hora habría que volverlos a registrar.

* Pregunta ------
¿Es aceptable perder hasta una hora de información en el peor de los casos?

*-- Opciones de respuesta ---
A) Sí, es aceptable
B) No. No se puede perder ni un pago, cueste lo que cueste
C) Aceptable si es algo que pasa muy rara vez

[Answer]:

*Origen: OQ-N-11*

---

### C-104 · ¿Qué celulares tienen tus cobradores? 🔴

Esto define para qué tipo de teléfono hay que construir la app. Los cobradores no suelen
tener equipos de gama alta, y una app pensada para teléfonos caros se vuelve inusable en
los baratos.

* Pregunta ------
¿Con qué trabajan tus cobradores?

*-- Opciones de respuesta ---
A) La empresa les da el celular — indico marca y modelo
B) Usan el suyo propio, Android de gama baja o media
C) Hay de todo, Android y iPhone
D) No lo sé con certeza

[Answer]:

**Preguntas adicionales:**
- ¿Los datos móviles los paga la empresa o el cobrador?
- ¿La señal en las zonas donde trabajan es buena, regular o mala?

[Answer]:

*Origen: OQ-N-31, OQ-N-32*

---

### C-105 · ¿Cuánto puedes invertir al mes en operar el sistema? 🔴

Además de construirlo, un sistema así tiene un costo mensual de funcionamiento: servidores,
almacenamiento de fotos, mensajes de WhatsApp (que se cobran por conversación) y consultas
de IA (que se cobran por uso).

Ese costo crece con tu operación. Si mandas un WhatsApp por cada pago y tienes 500 clientes
con préstamos diarios, son miles de mensajes al mes.

* Pregunta ------
¿Qué presupuesto mensual tienes en mente para mantener el sistema funcionando?

*-- Opciones de respuesta ---
A) Tengo un techo claro — lo escribo abajo
B) No tengo cifra, pero quiero que sea lo más económico posible
C) El costo no es problema si el sistema me hace ganar más
D) No lo había pensado; necesito que me den un estimado primero

[Answer]:

*Origen: OQ-N-40, OQ-B-9*

---

### C-106 · ¿Qué tan hábiles son tus cobradores con el celular? 🟡

Esto define cuánto se puede pedir en pantalla y cuánto hay que simplificar.

* Pregunta ------
¿Cómo describirías el manejo de tecnología de tu equipo en la calle?

*-- Opciones de respuesta ---
A) Se defienden bien, ya usan TryController todos los días sin problema
B) Les cuesta. Necesitan pantallas muy simples y pocos pasos
C) Hay de todo, desde muy hábiles hasta muy básicos
X) Otra — la explico

[Answer]:

*Origen: OQ-N-38*

---

# BLOQUE 15 · Prioridades: qué va primero

Última sección, y de las más importantes. Lo que describe tu documento es un producto
grande: web, app móvil con modo sin señal, WhatsApp, PIX, motor de reglas, inteligencia
artificial, auditoría completa y respaldos. Todo eso está listado como "primera versión".

Construirlo todo de una vez tarda mucho y es riesgoso. Es mejor tener funcionando lo
esencial pronto, y agregar el resto sobre algo que ya está en uso.

---

### C-107 · ¿Qué es lo mínimo con lo que ya podrías dejar el Excel? 🔴

* Pregunta ------
Si tuvieras que elegir SOLO 5 cosas para la primera entrega, ¿cuáles serían?

*-- Opciones de respuesta ---
A) Las escribo abajo, en orden de importancia
B) No puedo recortar nada, todo es indispensable

[Answer]:

*Origen: OQ-B-10*

---

### C-108 · ¿Qué puede esperar? 🔴

Nombrar ahora lo que NO va en la primera versión es la mejor protección contra que el
proyecto crezca sin control y no termine nunca.

* Pregunta ------
¿Qué cosas de las que pediste aceptas que queden para una segunda etapa?

*-- Opciones de respuesta ---
A) Las escribo abajo
B) El asistente de inteligencia artificial puede esperar
C) La app móvil puede esperar; arranquemos con la web
D) Los reportes avanzados y comparativos pueden esperar
E) Varias de las anteriores — las marco abajo

[Answer]:

*Origen: OQ-B-11*

---

### C-109 · Si hay que sacrificar algo, ¿qué prefieres? 🟡

* Pregunta ------
Cuando toque decidir entre estas tres cosas, ¿cuál sacrificas primero?

*-- Opciones de respuesta ---
A) Sacrifico funcionalidades, pero la fecha se cumple
B) Sacrifico la fecha, pero quiero todo lo pedido
C) Sacrifico presupuesto: pago más para tener todo a tiempo

[Answer]:

*Origen: OQ-B-8, OQ-B-10*

---

### C-110 · ¿Qué te preocupa de este proyecto? 🟡

* Pregunta ------
¿Qué es lo que más miedo te da de meterte en esto?

*-- Opciones de respuesta ---
A) Que los cobradores no lo usen y se devuelvan al papel
B) Que las cuentas no cuadren y perder plata en la transición
C) Que se demore demasiado o se salga de presupuesto
D) Que dependa de una sola persona que lo construyó
E) Que se caiga en un momento crítico
F) Varias — las marco abajo
X) Otra — la explico

[Answer]:

*Origen: OQ-B-15*

---

### C-111 · ¿Cómo vas a arrancar? 🟡

Pasar de Excel a un sistema nuevo con la operación andando no es trivial: hay préstamos
vivos, saldos a mitad de camino y cobradores que tienen que aprender algo nuevo mientras
siguen trabajando.

* Pregunta ------
¿Cómo te imaginas la puesta en marcha?

*-- Opciones de respuesta ---
A) Con una sola ruta de prueba primero, y si funciona, las demás
B) Todos al tiempo, desde un lunes
C) Los préstamos nuevos en el sistema y los viejos terminan en Excel
D) No lo he pensado

[Answer]:

*Origen: OQ-B-13, OQ-B-12*

---

# BLOQUE 16 · Cómo te pagan a ti por el software 🆕

*Responde este bloque **solo si en C-03 dijiste que vas a vender el sistema a otras
empresas** (opciones B o C). Si el sistema es solo para ti, salta al Cierre.*

Este bloque es nuevo y nace de algo que tú mismo aclaraste: **el único dinero que se mueve
dentro del aplicativo es el cobro por usar el software**, y solo en la web. Como no hay
absolutamente nada escrito sobre este tema en los documentos que nos diste, hay que
definirlo desde cero. Son seis preguntas.

---

### C-112 · ¿Esto va en la primera versión? 🔴

Hay dos caminos muy distintos. Si el cobro va dentro del sistema desde el principio, hay
que construir toda una sección de la web: planes, facturas, medios de pago, avisos de
vencimiento. Si al principio le cobras a tus clientes por fuera (les pasas una factura y te
transfieren), esa sección puede esperar y ganamos varias semanas de trabajo para lo que sí
es urgente: la cobranza.

* Pregunta ------
¿El cobro del software entra en la primera versión o se maneja por fuera al principio?

*-- Opciones de respuesta ---
A) Por fuera al principio: yo facturo y cobro por mi cuenta; el módulo llega después
B) Dentro del sistema desde la primera versión, porque pienso vender rápido
C) Una versión mínima: que el sistema me diga a quién hay que cobrarle y cuánto, pero el cobro lo hago yo
D) No lo he pensado

[Answer]:

*Origen: OQ-B-18*

---

### C-113 · ¿Cómo te pagarían el software? 🔴

Aquí hay una diferencia importante entre "el cliente mete su tarjeta en la web y se cobra
solo todos los meses" (cómodo, pero hay que integrar una pasarela de pagos y aceptar su
comisión) y "yo le mando la factura y me transfiere" (cero tecnología, pero alguien tiene
que perseguir el cobro cada mes).

* Pregunta ------
¿Cómo quieres que te paguen por el uso del sistema?

*-- Opciones de respuesta ---
A) Autoservicio: el cliente registra su tarjeta y se le cobra automático cada mes
B) El cliente paga por PIX / transferencia / boleto y alguien marca en el sistema que ya pagó
C) Las dos: autoservicio para los pequeños, factura manual para los grandes
D) No lo he pensado

[Answer]:

*Nota: si eliges A o C, hace falta decidir con qué pasarela (Stripe, Mercado Pago, Asaas,
Pagar.me...). Esa parte la resuelve el equipo de desarrollo, pero necesitamos saber en qué
país está constituida la empresa que va a facturar.*

*Origen: OQ-F-93, OQ-F-94, OQ-T-26*

---

### C-114 · ¿Qué pasa si una empresa cliente no te paga? 🔴

Esta pregunta es delicada, porque del otro lado hay cobradores en la calle trabajando. Si
cortas el acceso de golpe, dejas a una operación entera parada a mitad de jornada —y con
información sin sincronizar en los celulares. Hay que definir la escalera con calma.

* Pregunta ------
Si un cliente se atrasa en el pago del software, ¿qué debe hacer el sistema?

*-- Opciones de respuesta ---
A) Avisar unos días, y si no paga, dejar el sistema en solo lectura (puede ver, no registrar)
B) Avisar y suspender todo, incluida la app de los cobradores
C) Solo avisarme a mí; yo decido caso por caso
D) No lo he pensado

*También necesitamos saber:* ¿cuántos días de gracia? ¿Y por cuánto tiempo le guardas sus
datos si se va definitivamente?

[Answer]:

*Origen: OQ-F-95*

---

### C-115 · ¿Factura fiscal o recibo? 🟡

En Brasil sería *nota fiscal*; en Colombia, factura electrónica. Emitir documentos fiscales
de verdad exige conectarse con un proveedor autorizado y es un proyecto en sí mismo. Un
recibo simple no.

* Pregunta ------
¿Qué documento tienes que entregarle a la empresa que te paga el software?

*-- Opciones de respuesta ---
A) Un recibo simple, sin validez fiscal
B) Factura o nota fiscal de verdad, pero la emito por fuera con mi contador
C) Factura o nota fiscal, y quiero que el sistema la emita solo
D) No lo sé todavía

[Answer]:

*Origen: OQ-F-96*

---

### C-116 · ¿Planes y prueba gratis? 🟡

* Pregunta ------
¿Piensas ofrecer distintos planes o una prueba gratuita?

*-- Opciones de respuesta ---
A) Un solo plan para todos, sin prueba gratis
B) Un solo plan, con prueba gratuita de ___ días
C) Varios planes con límites distintos (ej. cuántos cobradores o cuántas rutas) — los describo abajo
D) No lo he pensado

[Answer]:

*Origen: OQ-F-97*

---

### C-117 · ¿Quién ve la facturación? ⚪

* Pregunta ------
Dentro del sistema, ¿quién debe poder ver el tema de pagos del software?

*-- Opciones de respuesta ---
A) Solo yo (dueño del producto), en un panel aparte
B) Yo, y además cada empresa cliente ve sus propias facturas y su estado de cuenta
C) No lo he pensado

[Answer]:

*Origen: OQ-F-98*

---

# Cierre

**Gracias.** Sabemos que son muchas preguntas. La razón es simple: cada respuesta que nos
des aquí es una decisión que no tendrá que adivinar el desarrollador, y una corrección que
no habrá que hacer después con el sistema ya funcionando.

**Si solo puedes atender unas pocas, estas son las que más desbloquean:**

| Prioridad | Preguntas |
|---|---|
| 1 | **C-10** — cómo se calcula la cuota (con un ejemplo numérico real) |
| 2 | **C-57** — el archivo Excel del cierre de caja actual |
| 3 | **C-18** y **C-19** — pagos parciales y en qué orden se aplica el dinero |
| 4 | **C-51** — qué pasa cuando la caja no cuadra |
| 5 | **C-02** y **C-03** — país/moneda, y si es solo para ti o para vender |
| 6 | **C-107** y **C-108** — qué va en la primera versión y qué puede esperar |
| 7 | **C-04** y **C-112** — cómo cobras el software y si eso va en la primera versión |

**Cómo devolverlo:** puedes escribir directamente en este archivo debajo de cada
`[Answer]:`, o responder por cualquier otro medio indicando el número de la pregunta
(C-10, C-51...). Cuando termines un bloque, avísanos y lo procesamos.

---

*Documento generado a partir de `Product-Definition/open-questions.md`. Cubre las
preguntas de negocio y funcionamiento (prefijos OQ-B, OQ-F, más las OQ-N que son
decisiones de negocio). Las preguntas puramente técnicas —tecnologías, servidores,
pruebas, estructura del código— no están aquí: las resuelve el equipo de desarrollo.*

*Versión 2 · 2026-07-28 — 117 preguntas en 16 bloques. Cambios respecto a la versión 1
(111 preguntas, 15 bloques), tras la decisión **D-01 · el sistema no maneja dinero real de
la cobranza**: bloque 16 nuevo (C-112 a C-117, cobro del software); C-04 pasa a crítica;
C-23, C-24 y C-96 reformuladas y acotadas.*
