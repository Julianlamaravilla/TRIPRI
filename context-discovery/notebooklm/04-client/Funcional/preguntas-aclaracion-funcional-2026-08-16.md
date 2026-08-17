# Cuestionario de Aclaraciones Funcionales — 2026-08-16

**Contexto**: Sesión de completamiento funcional post-demo. Estas 6 preguntas resuelven los bloqueos P0 que impiden la planificación de v1.

**Instrucciones**: Marca con una **A)**, **B)**, **C)**, etc. la opción que mejor describe tu respuesta. Si ninguna opción encaja exactamente, escribe libremente al final de la pregunta en la sección `[Respuesta libre]:`.

**Método de entrega**: Devuelve este archivo con las opciones marcadas y cualquier aclaración adicional.

---

## PARTE 0 · Contexto Técnico

### 0.1 · Flujo offline del cobrador

**Contexto**: El cobrador trabaja sin señal de móvil la mayor parte del día. Cuando recupera señal, sincroniza sus operaciones del día (pagos, no pagos, visitas, fotos).

**Operaciones SIN señal que SÍ funcionan** (confirmado en V-03):
- Registrar un pago en efectivo
- Registrar un pago por PIX (manual, tecleando datos)
- Registrar un "no pago" con motivo y compromiso
- Registrar una visita (sin foto)

**Operaciones que REQUIEREN señal**:
- Tomar fotos de documentos
- Crear un préstamo nuevo
- Pedir una llave de autorización
- Sincronizar operaciones al servidor

---

## PARTE 1 · Operación Base (P0 Bloqueantes)

### 1.1 · Circuito del dinero en la caja

**Pregunta**: ¿Cómo fluye el efectivo entre el cobrador, la empresa y el administrador?

**Contexto**: Hoy el sistema registra dónde está el dinero pero no describe:
- ¿La caja es por gestor, por unidad, o consolidada por empresa?
- ¿Cómo se registra cuando el cobrador entrega su efectivo recaudado al administrador?
- ¿Puede un cobrador prestar dinero (hacer un nuevo préstamo) sin tener efectivo en mano? ¿Quién le envía el dinero?
- ¿Qué significa exactamente "dinero pendiente" en el cierre?

**Opciones**:

**A)** Caja por gestor solamente. El cobrador registra qué tiene en mano al final del día. Si necesita dinero para un préstamo nuevo, el administrador le transfiere desde la caja central. No existe "consignación formal"; el administrador ve que el gestor tiene menos efectivo y sabe que la diferencia se debió a que pagó clientes.

**B)** Cajas en cascada: caja del gestor → caja de la unidad → caja general. El cobrador cierra su caja (lo que tiene en mano vs. lo que debería tener). Esa información sube a la caja de la unidad. Existe un proceso formal de "consignación" donde el cobrador entrega el efectivo al administrador, quien confirma el monto y registra la entrega.

**C)** Caja única por empresa. El cobrador registra cada pago a medida que ocurre; la caja es un consolidado de todos los gestor. El cobrador nunca "tiene dinero en mano"; el efectivo fluye directamente a la caja de la empresa.

**D)** No estoy seguro. Necesitaré una llamada para explicar el circuito completo.

**[Respuesta libre]:**

---

### 1.2 · Archivo de cierre de caja actual

**Pregunta**: ¿Cuál es el formato exacto del cierre de caja que usan hoy?

**Contexto**: El requisito dice *"el reporte debe ser idéntico al formato actual"*. Sin la plantilla no se puede construir la funcionalidad. Se pidió dos veces (C-57, V-25) y aún no llegó.

**Opciones**:

**A)** Sí, adjunto Excel real del cierre del día (con datos anónimos o reales, como prefieran).

**B)** Sí, pero necesito prepararlo — dame 24 horas y te lo paso por correo.

**C)** No tengo el archivo a mano, pero te lo describo: [describe aquí el formato, columnas y estructura]

**D)** No es crítico. El nuevo sistema puede tener su propio formato; la plantilla actual es solo referencia.

**[Respuesta libre]:**

---

### 1.3 · Llave de autorización sin señal (IMPOSIBILIDAD LÓGICA)

**Pregunta**: ¿Qué hace el cobrador si está sin señal y necesita una llave?

**Contexto**: El sistema tiene dos reglas que colisionan:
- **Regla 1** (V-03, C-65): El cobrador trabaja **sin señal todo el día**. Puede registrar pagos, no pagos, visitas.
- **Regla 2** (V-18): A partir de la **cuota 5 o superior**, registrar un pago **requiere una llave de autorización** del administrador.

Si el cobrador está sin señal y llega a un cliente cuya cuota es 5, no puede pedir la llave (requiere conexión) y no puede registrar el pago (requiere llave).

**¿Cómo se resuelve?**

**Opciones**:

**A)** La llave offline: el sistema genera llaves "offline" de corta duración (30 min) cada vez que se conecta, y el cobrador puede usarlas sin señal después.

**B)** Cambiar la regla: solo las primeras 4 cuotas requieren llave; a partir de la 5 en adelante, no. (Menos protección, más flujo.)

**C)** Cambiar la regla: la llave se pide del lado de la web (administrador genera una lista de "llaves anticipadas" cada mañana), y el cobrador las consume a lo largo del día sin necesidad de conexión.

**D)** Cambiar la regla: el cobrador PUEDE registrar pagos sin llave offline; al sincronizar, el servidor valida retroactivamente si la llave es necesaria. Si no la tiene, marca la operación en "cuarentena" para que el administrador la revise.

**E)** No se resolverá en v1. Los pagos de cuota 5+ sin conexión se registran "pendientes de validación" y se validan cuando vuelve la conexión.

**F)** Otra — describe aquí:

**[Respuesta libre]:**

---

## PARTE 2 · Alcance de v1 (P0 Decisiones)

### 2.1 · Motor de reglas de alertas

**Pregunta**: ¿Las 7 alertas se configuran dentro de la aplicación o son fijas en el código?

**Contexto**: El sistema debe emitir 7 alertas (dispositivo sin sincronizar, caja sin cerrar, cierre descuadrado, fallo de WhatsApp, muchos "no pago" seguidos, intentos de clave fallidos, reclamo de cliente).

**¿Quién decide qué alertas se activan, con qué umbrales y en qué canal?**

**Opciones**:

**A)** El administrador configura TODO dentro de la aplicación web. Puede encender/apagar alertas, cambiar umbrales (ej. "más de 5 no pagos seguidos" o "más de 3"), elegir canal (WhatsApp, email, etc.).

**B)** Las alertas y canales son configurables, pero los umbrales los define el equipo técnico en el código. El administrador solo encende/apaga.

**C)** Todo es fijo en v1. El equipo define qué alertas se emiten, con qué umbrales, en qué canal. En v2 se vuelve configurable.

**D)** Las alertas no son críticas en v1. La web muestra el estado actual (cajas abiertas, dispositivos sin sincronizar, etc.) pero el sistema no emite notificaciones automáticas.

**[Respuesta libre]:**

---

### 2.2 · Modelo de permisos asignables

**Pregunta**: ¿Qué control tiene el administrador principal sobre los permisos de otros usuarios?

**Contexto**: El cliente pidió que *"el administrador principal pueda asignar permisos sobre los recursos para los demás usuarios"*. Hay dos enfoques posibles: muy simple (roles fijos) o muy complejo (matriz de permisos).

**Opciones**:

**A)** Roles fijos + excepciones puntuales. Existen 3 roles estándar (Administrador, Socio, Cobrador) con permisos predefinidos. El administrador principal puede crear **administradores secundarios** con los mismos permisos que él, pero **sin poder** hacer ciertas acciones (ver Usuarios, Dispositivos, Llaves — con candado visible).

**B)** Matriz completa de permisos por recurso. El administrador crea usuarios y elige para cada uno: ¿puede aprobar ventas? ¿Puede emitir llaves? ¿Puede ver socios? ¿Puede crear usuarios? Cada permiso es una casilla independiente. Altamente flexible.

**C)** Plantillas de rol. Hay 3 roles estándar, pero el administrador principal puede crear plantillas personalizadas (ej. "Supervisor de ruta 1: aprueba ventas, cierra cajas, ve reportes de su ruta"). Los usuarios se asignan a plantillas.

**D)** No necesitamos permisos granulares en v1. Basta con: administrador (acceso total) vs. no-administrador (acceso limitado). Los permisos finos pueden esperar a v2.

**[Respuesta libre]:**

---

### 2.3 · Versión mínima de dispositivos Android/iOS

**Pregunta**: ¿Qué modelo mínimo de teléfono debe soportar la app?

**Contexto**: El parque de dispositivos determina si se puede usar TLS 1.3 (requiere Android 10+, iPhone 13+) o hay que usar TLS 1.2. También impacta qué librerías de cifrado se pueden usar en SQLite.

**¿Cuál es la versión mínima que ustedes aceptan?**

**Opciones**:

**A)** Android 10+ / iOS 13+. (Permite TLS 1.3 y las mejores prácticas de seguridad.)

**B)** Android 8+ / iOS 12+. (Requiere TLS 1.2 como mínimo; reduce seguridad moderna pero amplía compatibilidad.)

**C)** Android 6+ / iOS 10+. (Compatibilidad máxima; requiere workarounds de seguridad significativos.)

**D)** No tengo dato. Cuéntame qué marcas y modelos usan los cobradores hoy y me doy una idea.

**[Respuesta libre]:**

---

## PARTE 3 · Aclaraciones Secundarias (P1)

### 3.1 · Refinanciación vs. Renovación

**Pregunta**: ¿En qué se diferencia refinanciar de renovar un préstamo?

**Contexto**: 
- **Renovación** (V-12): Cliente paga 100% del saldo. Se crea un préstamo NUEVO con nuevas condiciones (cliente elige cuotas e interés dentro del rango).
- **Refinanciación**: El cliente NO paga el saldo pendiente. El sistema ¿recalcula el interés sobre el saldo que debe? ¿O sobre un monto nuevo que el cliente pide? ¿La duración es nueva o se hereda?

**Opciones**:

**A)** La refinanciación es renovación con saldo pendiente. El cliente sigue debiendo lo viejo, pero se negocia una estructura de pago nueva (menos cuotas, más pequeñas, etc.). El interés se recalcula **solo sobre el saldo pendiente**, no sobre un monto nuevo.

**B)** La refinanciación es un préstamo nuevo que **paga la deuda anterior**. El cliente pide dinero nuevo, ese dinero liquida lo viejo, y el cliente queda con un préstamo nuevo (de nuevo monto, nuevas condiciones).

**C)** No existe refinanciación en nuestro negocio. Solo renovación o cobro.

**D)** La refinanciación la explico mejor en una llamada.

**[Respuesta libre]:**

---

### 3.2 · Catálogo de motivos de "no pago"

**Pregunta**: ¿Cuál es la lista exacta de motivos que el cobrador elige cuando un cliente NO paga?

**Contexto**: Estos motivos se usan para:
- Entrenar alertas ("si hay 5 "no pago" de tipo X seguidos, alertar")
- Generar reportes ("X % de no pagos por enfermedad vs. no estaba en casa")
- Dar seguimiento ("clientes que dijeron "se niega" vs. "no tenía dinero hoy"")

**¿Cuál es la lista?**

**Opciones**:

**A)** Lista fija estándar: No hizo ventas · No estaba en casa · Se niega · Enfermedad · Otro

**B)** Lista extendida personalizada por empresa. (Describe aquí cuál es la lista para tu caso específico.)

**C)** No tenemos categorías fijas. El cobrador escribe libremente el motivo.

**D)** No es crítico en v1. El cobrador solo registra "no pago" con un comentario; los reportes se arman después.

**[Respuesta libre]:**

---

### 3.3 · Expiración y unicidad de la llave

**Pregunta**: Una llave de autorización, ¿puede usarse una sola vez o varias veces?

**Contexto**: La llave existe para autorizar operaciones excepcionales (venta a nuevo cliente, pago de cuota 5+, etc.). 

**¿Cuánto dura la llave y cuántas veces se puede usar?**

**Opciones**:

**A)** De un solo uso. Toda llave se consume en la primera operación y caduca automáticamente. Si el cobrador necesita otra, solicita nuevamente.

**B)** Reutilizable el mismo día. La llave válida hasta las 23:59 de ese día; el cobrador la usa cuantas veces necesite para ese cliente.

**C)** Reutilizable 24 horas desde la emisión. Caduca a las 24 h, independientemente del día del calendario.

**D)** No caduca dentro del mismo cliente. Una llave para "cliente X" es válida indefinidamente hasta que el cliente se cierre.

**E)** No estoy seguro. Explícame qué riesgo intentas proteger y yo te digo qué modelo funciona.

**[Respuesta libre]:**

---

## PARTE 4 · Confirmación y Siguiente Paso

### 4.1 · ¿Hay algo más que debería aclarar?

Escribe aquí cualquier duda sobre las preguntas, aclaraciones adicionales o puntos que preocupen:

**[Comentario libre]:**

---

### 4.2 · Disponibilidad para una llamada

Si las respuestas dejan ambigüedades, ¿podemos agendar 30 min para profundizar?

**A)** Sí, preferentemente el [inserta día/hora]

**B)** Mejor después — devuelvo el cuestionario y ustedes lo procesan

**C)** Esto requiere que hablemos todos (yo, Pablo, César) — coordinamos después

**[Fecha/hora disponible]:**

---

## Envío

**Devuelve este archivo** a julianrestrepo012@gmail.com con:
- Opciones marcadas
- [Respuestas libres] completadas
- Fecha de llamada (si aplica)

**Plazo**: 48 horas idealmente, para agendar la llamada antes del fin de semana.

**Resultado esperado**: Este documento cerrado + 30 min de llamada = **cierre de las 6 preguntas P0** → listo para roadmap de v1.

