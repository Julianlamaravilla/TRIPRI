# Diagnóstico de alcance

Asignatura: Arquitectura de Software, Universidad Ean
Producto: ROYEXA
Integrantes: Julian Andres Restrepo Castaño y Jeison David Tibaduiza Sanchez

Este documento evalúa el proyecto frente a los criterios de la Guía para definir tu proyecto y sustenta la delimitación de alcance que adoptamos. Sigue el orden y la numeración de la guía: el apartado 1 recorre sus nueve criterios, el 2 revisa las señales de proyecto demasiado grande y presenta la reformulación, el 3 comprueba las señales de proyecto demasiado pequeño, el 4 aplica la prueba rápida de validación y el 5 remite a la ficha de propuesta, que se entrega como documento aparte.

# 1. Guía para definir tu proyecto

## 1.1 Debe partir de un problema identificable

El proyecto parte de un problema del negocio y no de una tecnología.

Quién tiene el problema: el dueño de una financiera pequeña que presta cantidades reducidas y las cobra a diario en la calle, de lunes a sábado. En qué contexto ocurre: un cobrador recorre su ruta solo, sin supervisión y buena parte de la jornada sin señal de móvil. Qué consecuencias genera: dos formas concretas de pérdida de dinero, que son que el cobrador reciba el pago y no lo registre, y que reporte un desembolso que nunca entregó. Cómo se resuelve actualmente: con un producto de terceros apoyado en hojas de cálculo, que permite modificar registros ya creados, no incorpora ningún control sobre esas dos situaciones y no ofrece exportación de los datos propios. Qué valor aportaría la solución: un registro en el que cada movimiento de dinero deja evidencia verificable por alguien distinto de quien lo registró, de modo que el dueño pueda delegar el cobro sin delegar la confianza.

El propósito del sistema no es gestionar la cobranza, que la financiera ya gestiona, sino impedir el fraude interno. Esa distinción es la que gobierna todas las decisiones de arquitectura que aparecen más adelante.

## 1.2 Debe tener interesados reconocibles

La propuesta reconoce tres interesados con intereses distintos y en tensión.

El cobrador necesita registrar rápido y poder demostrar que entregó todo lo que recibió. El administrador necesita aprobar antes de que salga el dinero y verificar al cierre que lo registrado coincide con lo entregado. El cliente final necesita un comprobante que no dependa de la palabra del cobrador.

El par formado por el cobrador y el administrador reproduce la relación entre solicitante y aprobador que la guía propone como ejemplo, y genera requisitos que compiten: uno quiere el mínimo número de pasos, el otro quiere que ningún paso ocurra sin dejar rastro. El cliente final añade una tercera perspectiva que no es redundante, porque es el único que puede verificar un pago desde fuera de la empresa, y esa verificación externa es la que sostiene el control sobre la primera de las dos formas de pérdida.

## 1.3 Debe contener reglas de negocio

El dominio impone seis reglas no triviales, que la ficha detalla en su sección 5.7.

La cuota es indivisible, pero el pago parcial se acepta y avanza el contador de forma fraccionaria, de modo que una entrega de 25 sobre una cuota de 50 deja 19,5 cuotas restantes de 20. La caja del cobrador solo puede cerrarse cuando no quedan clientes pendientes de visita, y una vez cerrada es irreversible. Un desembolso aprobado no libera el dinero hasta que el cliente final confirma la recepción con un código que caduca. El libro de movimientos solo admite inserciones, de modo que un error se corrige con un asiento que lo compensa y ambos quedan visibles. La renovación de un préstamo exige que el anterior esté pagado en su totalidad, salvo autorización expresa del administrador, que queda registrada como excepción. Y quien origina una operación no puede aprobarla.

Ninguna de las seis es una operación de registro, consulta, modificación o borrado. Todas condicionan un cambio de estado, y varias de ellas obligan a decidir dónde vive la regla, que es una de las preguntas que la guía plantea en su criterio 1.8.

## 1.4 Debe tener un flujo principal completo

El proceso de desembolso de un préstamo se recorre de principio a fin y consta de nueve pasos, que la ficha describe en su sección 5.5.

Comprende el registro de la solicitud, la validación de las reglas, la autorización cuando el monto supera el límite del cobrador, la aprobación del administrador, la generación de un código de confirmación con caducidad, su envío al cliente final, la confirmación del cliente, el asiento en el libro de movimientos con la generación del calendario de cuotas, y la consulta posterior de la operación con la identidad de quien la solicitó y de quien la aprobó.

Es un proceso con puntos de decisión reales, un estado que avanza y un camino alternativo definido: si el cliente no confirma dentro del plazo, la operación caduca, el dinero no se descuenta de la caja y queda registrado el intento con su motivo.

## 1.5 Debe incluir persistencia

El sistema requiere persistencia y la organiza sobre ocho conceptos de dominio: cliente, préstamo, cuota, pago, no pago, caja, desembolso y asiento del libro de movimientos.

La persistencia no es aquí un almacén pasivo, sino parte del diseño. La separación entre dominio y persistencia se sostiene manteniendo el cálculo de intereses, la imputación de pagos y el contador fraccionario en un núcleo sin acceso a base de datos, al que la capa de persistencia entrega los datos ya cargados. El acceso a datos se concentra en un repositorio por módulo, de modo que ninguna otra parte del código toca la sesión. La integridad se apoya en restricciones de la propia base y no en comprobaciones de la aplicación, y en particular la inmutabilidad del libro de movimientos se impone con permisos que solo permiten inserción, para que la restricción no dependa de que la aplicación se comporte correctamente. Y el manejo de transacciones tiene un caso claro, porque el asiento y el registro de la notificación deben confirmarse juntos o no confirmarse.

## 1.6 Debe incluir al menos una integración

El sistema se integra con un servicio externo de notificación al cliente final, que transporta el comprobante de pago y el código de confirmación del desembolso.

La integración se implementa como componente reemplazable: la aplicación define una interfaz de notificación, la lógica de negocio solo conoce esa interfaz y durante el curso se construye un adaptador simulado, más un adaptador falso para las pruebas automáticas. La ficha explica en su sección 5.9 por qué el proveedor real no se conecta.

Esta forma de resolverla es la que produce las decisiones que la guía busca en este criterio: qué contrato expone la interfaz, qué ocurre cuando el envío falla, si ese fallo debe impedir que la operación de negocio se complete, y cómo se prueba todo ello sin depender de un servicio externo.

## 1.7 Debe tener atributos de calidad relevantes

Priorizamos tres atributos: auditabilidad, seguridad y capacidad de prueba. La ficha los justifica uno a uno en su sección 5.8.

La auditabilidad es la primera porque sostiene el propósito del sistema: si un registro puede alterarse, el producto deja de resolver el problema que lo justifica, ya que el fraude se ocultaría editando el pasado. La seguridad es la segunda porque el sistema maneja dinero y una cadena de aprobación en la que el abuso de permisos es exactamente el riesgo que se combate. La capacidad de prueba es la tercera porque es lo que permite demostrar las dos anteriores de forma objetiva.

No priorizamos la disponibilidad ni la escalabilidad. El volumen previsto no las justifica, y exigirlas desplazaría el esfuerzo desde el diseño hacia la infraestructura, que es precisamente lo que la guía advierte al señalar que en un sistema pequeño suele importar más la modificabilidad, la seguridad o la capacidad de auditoría.

## 1.8 Debe permitir comparar alternativas

El proyecto obliga a decidir en varios frentes donde no existe una solución evidente.

Sobre dónde ubicar las reglas de negocio: el cálculo de intereses, la imputación de pagos y el contador fraccionario pueden vivir en la base de datos, en el servicio de aplicación o en un núcleo aislado. Optamos por el núcleo aislado, sin base de datos, sin red y sin reloj, con el reloj inyectado desde fuera, porque es la única de las tres opciones que permite probar el cálculo de forma determinista.

Sobre cómo desacoplar la integración externa: la notificación puede invocarse directamente desde el servicio o entrar por una interfaz con adaptadores intercambiables. Optamos por la interfaz, porque el canal definitivo no está decidido y porque permite sustituir el proveedor por una implementación falsa durante las pruebas.

Sobre cómo garantizar la consistencia entre el asiento y la notificación: puede enviarse el mensaje dentro de la misma operación, delegarse a un proceso en segundo plano del propio servidor, o encolarse en un sistema externo. Las tres tienen consecuencias distintas cuando algo falla, y la decisión determina si un comprobante puede perderse sin que nadie se entere.

Sobre cómo imponer la inmutabilidad: puede confiarse en que la aplicación nunca actualice ni borre, o restringirse con permisos de la base de datos. La primera es una convención y la segunda una garantía.

Sobre qué probar de forma unitaria y qué mediante integración: las reglas de cálculo admiten prueba unitaria pura, mientras que la inmutabilidad y el aislamiento entre rutas solo pueden verificarse contra una base real.

## 1.9 Debe ser implementable por dos estudiantes

El producto completo, tal como está definido, no es implementable por dos estudiantes en el periodo del curso. Comprende una aplicación móvil con operación sin conexión, un motor de sincronización propio, vinculación criptográfica entre usuario y dispositivo, aislamiento entre varias empresas sobre una misma instalación y un despliegue automatizado en nube pública.

Esa es la razón por la que la propuesta distingue entre el producto y lo que se construye durante el curso, y por la que las secciones 5.11 y 5.12 de la ficha son explícitas y verificables.

Lo que se construye se ajusta a las magnitudes que la guía plantea como orientativas. Un flujo principal, el de desembolso, recorrido de principio a fin. Ocho conceptos de dominio. Nueve funcionalidades priorizadas, de las cuales seis son esenciales. Una interfaz web funcional sobre una API REST. Una integración externa simulada. Persistencia relacional con la inmutabilidad impuesta desde la base. Seis reglas de negocio no triviales. Pruebas unitarias sobre el núcleo de cálculo y pruebas de integración sobre el acceso a datos y sobre el flujo completo. Y empaquetado con contenedores con una canalización básica de integración continua.

# 2. Señales de que el proyecto es demasiado grande

En su formulación completa, el producto dispara ocho de las doce señales que la guía enumera. Depende de múltiples servicios externos reales. Involucra dinero real y su conciliación. Requiere procesamiento en tiempo real complejo por la sincronización sin conexión. Contempla cinco roles. Acumula un volumen de historias que excede el periodo disponible. Exige autenticación, mensajería, reportes, analítica y aplicación móvil de forma simultánea. Su primera versión no cabe en tres o cuatro semanas de trabajo parcial. Y la carga funcional no dejaría tiempo para el diseño, las pruebas y la arquitectura, que es lo que la asignatura evalúa.

Reconocer esto es lo que motiva la reformulación de los apartados siguientes y la delimitación de las secciones 5.11 y 5.12 de la ficha.

## 2.1 Ejemplo demasiado amplio

Sistema multiempresa de gestión de préstamos y cobranza en calle, con aplicación móvil de operación sin conexión, motor de sincronización propio, vinculación criptográfica de dispositivo, permisos asignables por recurso, notificación automática a clientes finales y despliegue automatizado en nube pública.

## 2.2 Reformulación adecuada

Módulo de registro y conciliación de cobranza diaria, con libro de movimientos inmutable, cierre de caja del cobrador que debe cuadrar a cero y aprobación de desembolsos en dos pasos con código de confirmación del cliente final, con notificación mediante un servicio externo simulado y registro auditable de cada decisión.

Es el mismo dominio reducido a una rebanada, con la profundidad de diseño intacta. Conserva el libro de movimientos de solo inserción con asientos compensatorios, el cierre de caja con detección de descuadre, el contador fraccionario de cuotas, el núcleo de cálculo aislado con el reloj inyectado, la representación exacta del dinero y la integración desacoplada por interfaz.

# 3. Señales de que el proyecto es demasiado pequeño

Ninguna de las ocho señales aplica a la propuesta reformulada.

No es el registro y consulta de una sola entidad, porque el modelo tiene ocho conceptos relacionados entre sí. No es una lista de tareas sin reglas adicionales, porque conserva seis reglas de negocio de las cuales al menos cuatro condicionan cambios de estado. No es un catálogo sin proceso, porque el flujo de desembolso recorre nueve pasos con puntos de decisión y un camino alternativo. No es una aplicación que consume una interfaz externa y muestra resultados, porque el cálculo de dinero es propio. No es un sistema sin interesados diferentes, porque mantiene tres con intereses contrapuestos. No carece de integración ni de atributos de calidad relevantes. Y no puede completarse razonablemente en una o dos sesiones de trabajo.

# 4. Prueba rápida para validar el alcance

La propuesta responde afirmativamente a las doce preguntas de validación.

Existe un problema y un beneficiario claramente identificados, y hay tres tipos de interesados con necesidades distintas. Existe un flujo principal completo, de nueve pasos, con su camino alternativo. Contiene seis reglas de negocio no triviales. Requiere persistencia sobre ocho conceptos de dominio, con la inmutabilidad impuesta desde la base de datos. Incluye una integración externa, resuelta como componente reemplazable. Prioriza tres atributos de calidad, que son auditabilidad, seguridad y capacidad de prueba, y descarta explícitamente la disponibilidad y la escalabilidad con su justificación. Obliga a tomar decisiones de diseño y arquitectura que no son triviales, recogidas en el criterio 1.8. Puede implementarse parcialmente sin construir todo el producto, que es exactamente lo que declaran las secciones 5.11 y 5.12. Entre los dos podemos demostrar una versión funcional al finalizar el curso, sobre el alcance delimitado. Permite escribir pruebas unitarias sobre el núcleo de cálculo y pruebas de integración sobre el acceso a datos y sobre el flujo completo. Y puede empaquetarse con contenedores y pasar por una canalización básica de integración continua.

# 5. Ficha de propuesta del proyecto

La ficha se entrega como documento aparte, en el archivo `ficha-propuesta.md`, con las doce secciones que exige este apartado de la guía y conservando su numeración.

Sus secciones 5.2 a 5.10 describen el producto tal como está definido, porque es lo que da sentido a las decisiones de arquitectura y a los riesgos. Sus secciones 5.11 y 5.12 delimitan el compromiso del semestre: la primera enumera lo que se construirá y la segunda lo que queda excluido, con la razón de cada exclusión.

Esta separación es deliberada. Un alcance no queda bien definido solo por lo que incluye, sino también por lo que excluye de forma explícita, y en un proyecto cuyo producto completo excede el periodo disponible, esa exclusión es la pieza que hace verificable el compromiso.
