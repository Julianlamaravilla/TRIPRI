# Ficha de propuesta del proyecto

Asignatura: Arquitectura de Software, Universidad Ean
Integrantes: Julian Andres Restrepo Castaño y Jeison David Tibaduiza Sanchez

La numeración de las secciones corresponde a la del apartado 5 de la Guía para definir tu proyecto.

## 5.1 Identificación

Nombre provisional: ROYEXA.

Integrantes: Julian Andres Restrepo Castaño y Jeison David Tibaduiza Sanchez.

Dominio o sector: tecnología financiera aplicada a la gestión de cobranza en calle. El sistema se dirige a financieras pequeñas que prestan cantidades reducidas y las cobran a diario, puerta a puerta.

## 5.2 Problema

Situación actual. Una financiera pequeña presta cantidades reducidas a muchas personas y las cobra a diario, de lunes a sábado, en la calle. El dinero pasa por las manos de un cobrador que recorre su ruta solo, sin supervisión y buena parte de la jornada sin señal de móvil. El control se lleva hoy con un producto de terceros apoyado en hojas de cálculo, donde los registros pueden editarse después de haberse creado.

Personas afectadas. El dueño de la financiera, que no puede verificar lo que se cobró; el administrador, que aprueba desembolsos sin información suficiente; el cobrador, que no tiene forma de demostrar que hizo su trabajo y queda expuesto a sospechas; y el cliente final, que paga en efectivo y no recibe ningún comprobante independiente de la palabra del cobrador.

Consecuencias. Se abren dos huecos por los que se escapa el dinero. El primero es que el cobrador reciba el pago y no lo registre: el cliente queda satisfecho, el importe nunca entra al sistema y, sin un tercero que lo confirme, la palabra del cobrador es el único registro que existe. El segundo es que se reporte un desembolso que nunca se entregó, quedándose con el efectivo. A esto se suma que los descuadres de caja se detectan tarde, cuando ya no es posible reconstruir qué ocurrió.

Solución actual. El producto que usan hoy no incorpora ninguno de los dos controles, permite modificar registros ya creados y no ofrece exportación de los datos propios, de modo que la información queda cautiva. La conciliación se hace a mano, en hojas de cálculo, y depende de llamadas telefónicas entre el cobrador y el administrador.

## 5.3 Solución propuesta

Propósito. Construir un sistema de registro de cobranza en el que cada movimiento de dinero deje evidencia que pueda verificar alguien distinto de quien lo registró, de modo que el dueño de la financiera pueda delegar el cobro sin delegar la confianza. El objetivo no es gestionar la cobranza, que ya se gestiona, sino impedir el fraude interno.

Beneficiarios. El dueño y el administrador de la financiera, que obtienen un registro que no puede alterarse y una detección de descuadres el mismo día; el cobrador, que obtiene una prueba de su propio trabajo; y el cliente final, que recibe un comprobante que no depende de la buena fe del cobrador.

Valor esperado. Reducir los descuadres de caja mensuales, que es la métrica que el cliente declaró como prioritaria, y convertir cada pago en un hecho verificable por dos partes independientes.

Límites iniciales. El sistema no custodia dinero en ningún momento: no recibe, no retiene y no transfiere fondos. El efectivo y las transferencias se registran como información sobre una gestión que ocurre fuera del sistema. Tampoco sustituye el criterio humano en la concesión de préstamos, que sigue siendo una decisión del administrador.

## 5.4 Interesados

Cobrador. Su necesidad es registrar cobros de forma rápida durante la ruta y que ese registro quede firme aunque no tenga conexión en el momento. Su preocupación principal es poder demostrar que entregó todo lo que recibió, porque hoy cualquier diferencia en la caja se interpreta en su contra sin que pueda probar lo contrario.

Administrador. Su necesidad es aprobar los desembolsos antes de que salga el dinero y revisar al cierre del día que lo registrado coincide con lo entregado. Su preocupación principal es que un registro pueda modificarse después de creado, porque eso permitiría ocultar una diferencia editando el pasado.

Cliente final. Su necesidad es saber cuánto pagó y cuánto le queda por pagar. Su preocupación principal es no tener ninguna prueba de sus propios pagos, de modo que ante una discrepancia con el cobrador su versión no puede sostenerse. No opera el sistema: solo recibe la notificación, y esa notificación es precisamente lo que convierte el pago en un hecho verificable por un tercero.

Los intereses de los tres se contraponen de forma útil para el diseño. El cobrador quiere el mínimo de pasos posible, el administrador quiere que ningún paso ocurra sin dejar rastro, y el cliente final necesita que el rastro le llegue a él y no solo a la empresa.

## 5.5 Flujo principal

El proceso más importante es el de desembolso de un préstamo, porque es donde se combina el dinero real con la cadena de aprobación.

1. El cobrador registra en el sistema una solicitud de desembolso para un cliente de su ruta, indicando el monto, el plazo y el número de cuotas.
2. El sistema valida las reglas de negocio: comprueba que el cliente exista, que no tenga un préstamo anterior sin liquidar y que el monto esté dentro de los límites configurados para esa ruta.
3. Si el monto supera el límite del cobrador, la solicitud queda en espera de autorización; si no lo supera, avanza directamente al paso siguiente.
4. El administrador revisa la solicitud junto con el historial del cliente y la aprueba o la rechaza indicando el motivo. No puede aprobar una solicitud que él mismo haya originado.
5. Si la aprueba, el sistema genera un código de confirmación único, con caducidad, asociado a esa operación y a ese cliente.
6. El sistema envía el código al cliente final por el canal de notificación configurado.
7. El cliente confirma la recepción del dinero presentando el código, que el cobrador valida desde la aplicación.
8. El sistema registra el desembolso como asiento en el libro de movimientos, genera el calendario de cuotas y descuenta el importe de la caja del cobrador.
9. La operación queda consultable por el administrador, con la hora del dispositivo y la del servidor, y con la identidad de quien la solicitó y de quien la aprobó.

Si el cliente no confirma dentro del plazo del código, la operación caduca, el dinero no se descuenta de la caja y queda un asiento del intento con su motivo.

## 5.6 Funcionalidades iniciales

Esenciales.

1. Registro de pago y de no pago durante la ruta, con motivo y compromiso de pago en el segundo caso, y con contador fraccionario de cuotas cuando el pago es parcial.
2. Cierre diario de caja en tres paneles, que muestra clientes pendientes, clientes que pagaron y clientes que no pagaron, y que calcula la diferencia entre lo registrado y lo entregado.
3. Aprobación de desembolsos con código de confirmación del cliente final, según el flujo de la sección 5.5.
4. Libro de movimientos inmutable, donde toda operación de dinero queda asentada y las correcciones se hacen mediante asientos compensatorios visibles.
5. Alta y consulta de clientes y préstamos, con el calendario de cuotas derivado del monto, el plazo y el interés.
6. Notificación de comprobante al cliente final tras cada pago, indicando el importe recibido, el saldo restante y la fecha del próximo vencimiento.

Deseables.

7. Tablero de administración con el número de descuadres del periodo y su evolución.
8. Gestión de usuarios con roles y límites de autorización configurables por ruta.
9. Alertas automáticas por atraso del cliente y por caja que lleva demasiadas horas sin cerrarse.

Fuera del alcance inicial.

10. Aplicación móvil nativa con operación completa sin conexión y sincronización posterior.
11. Aislamiento entre varias empresas sobre una misma instalación, portal de consulta para el cliente final, evaluación crediticia automática y asistente de inteligencia artificial.

## 5.7 Reglas de negocio

1. La cuota es indivisible, pero el pago parcial se acepta y avanza el contador de forma fraccionaria. Una entrega de 25 sobre una cuota de 50 deja 19,5 cuotas restantes de 20, no 20 ni 19.
2. La caja del cobrador solo puede cerrarse cuando no quedan clientes pendientes de visita, y una vez cerrada es irreversible: cualquier ajuste posterior exige un asiento nuevo.
3. Un desembolso aprobado no libera el dinero hasta que el cliente final confirma la recepción con el código, y el código caduca pasado su plazo.
4. El libro de movimientos solo admite inserciones. Un error no se edita ni se borra: se corrige con un asiento que lo compensa, y ambos quedan visibles.
5. La renovación de un préstamo exige que el anterior esté pagado en su totalidad, salvo que el administrador autorice expresamente la excepción, que queda registrada como tal.
6. Quien origina una operación no puede aprobarla. Un administrador no puede crear una solicitud de desembolso y aprobársela a sí mismo.

## 5.8 Atributos de calidad

Auditabilidad. Es el atributo que sostiene el propósito del sistema. Si el registro puede alterarse, el producto deja de resolver el problema que lo justifica, porque un fraude se oculta editando el pasado. Se traduce en el libro de movimientos de solo inserción, en la doble marca de tiempo del dispositivo y del servidor, y en que toda operación conserve la identidad de quien la ejecutó.

Seguridad. El sistema maneja dinero, datos personales y una cadena de aprobación donde el abuso de permisos es exactamente el riesgo que se combate. Se traduce en control de acceso por rol, en la regla de que quien origina no aprueba, y en que los límites de autorización se verifiquen en el servidor y nunca en el cliente.

Capacidad de prueba. Es lo que permite demostrar los dos anteriores. Se traduce en aislar la lógica de dinero en un núcleo sin base de datos, sin red y sin reloj, de modo que el cálculo de intereses, la imputación de pagos y el contador fraccionario puedan probarse de forma unitaria y determinista, y en que las dependencias externas entren por interfaces que admiten una implementación falsa durante las pruebas.

No se priorizan la alta disponibilidad ni la escalabilidad, porque el volumen previsto no las justifica y su exigencia desplazaría el esfuerzo desde el diseño hacia la infraestructura.

## 5.9 Integraciones

El sistema se integra con un servicio externo de notificación al cliente final, que es el canal por el que se envía el comprobante de pago y el código de confirmación del desembolso.

La integración se implementa como componente reemplazable. La aplicación define una interfaz de notificación y la lógica de negocio solo conoce esa interfaz, nunca al proveedor. Durante el curso se construye un adaptador simulado que registra los mensajes emitidos, más un adaptador falso para las pruebas automáticas, de modo que el proveedor real pueda conectarse después sin tocar la lógica.

El canal definitivo no está decidido. El proveedor previsto originalmente exige que quien contrata el servicio sea una empresa formalmente registrada y verificada, y las financieras a las que se dirige el producto no cumplen ese requisito, de modo que la elección del canal sigue abierta. Tratar la notificación como componente reemplazable es la respuesta a esa incertidumbre: permite avanzar sin comprometer la arquitectura con un proveedor que puede cambiar.

Esta forma de resolver la integración concentra las decisiones de diseño en la interfaz y no en el proveedor: qué contrato expone, qué ocurre cuando un envío falla, si ese fallo debe impedir que la operación de negocio se complete, y cómo se verifica el comportamiento sin depender de un servicio externo.

## 5.10 Riesgos

Riesgo técnico. La consistencia entre el asiento en el libro de movimientos y el envío de la notificación. Si el asiento se confirma y la notificación se pierde, el cliente no recibe su comprobante y nadie se entera, con lo que el control antifraude queda roto en silencio. Mitigación: encolar la notificación dentro de la misma transacción que el asiento, de modo que ambas cosas ocurran o ninguna, y registrar el estado de cada envío.

Riesgo funcional o de requisitos. El diseño gira alrededor del efectivo, pero una parte creciente de los pagos llega por transferencia bancaria, caso en el que el cobrador no visita al cliente y la caja física deja de describir la operación. Si esa proporción es mayor de lo previsto, el modelo centrado en la caja explica solo una fracción del negocio y el primero de los dos fraudes deja de ser el problema principal. Mitigación: cerrar la duda antes de diseñar el modelo de datos, y mantener el libro de movimientos independiente del medio de pago para que ambos casos quepan.

Riesgo de tiempo y dependencia externa. El alcance completo del producto excede la capacidad del equipo en el periodo disponible, y una de sus piezas centrales depende de un servicio externo cuya contratación no está garantizada. Mitigación: las secciones 5.11 y 5.12, que delimitan lo que efectivamente se construye, y la implementación de la integración como componente reemplazable, que desacopla el avance del proyecto de la disponibilidad del proveedor.

## 5.11 Alcance de implementación

Durante el curso se construirá el módulo de registro y conciliación de cobranza diaria, que comprende el libro de movimientos inmutable, el cierre de caja con detección de descuadre y la aprobación de desembolsos con código de confirmación.

En concreto, se implementará una API REST sobre una base de datos relacional, con el libro de movimientos restringido a inserciones mediante permisos de la propia base, de modo que la restricción no dependa de que la aplicación se comporte bien. La lógica de dinero vivirá en un núcleo sin acceso a base de datos, sin red y sin reloj, con el reloj inyectado desde fuera, y el importe se representará con un tipo propio sobre decimal exacto que impida el uso de coma flotante. Se implementarán el contador fraccionario de cuotas, el cierre de caja que solo procede con pendientes en cero y el flujo de aprobación en dos pasos. La interfaz será web y responsive, y cubrirá los dos roles operativos. La notificación al cliente final entrará por la interfaz descrita en la sección 5.9, con adaptador simulado. Y se entregarán pruebas unitarias sobre el núcleo de cálculo, pruebas de integración sobre el acceso a datos y sobre el flujo completo, empaquetado con contenedores y una canalización básica de integración continua.

El modelo de dominio queda en ocho conceptos: cliente, préstamo, cuota, pago, no pago, caja, desembolso y asiento del libro de movimientos. Los roles implementados son dos, cobrador y administrador; el cliente final aparece como destinatario de la notificación, sin acceso al sistema.

## 5.12 Fuera de alcance

No se construirá la aplicación móvil nativa, y con ella queda fuera la operación sin conexión: el motor de sincronización propio, la cola local de operaciones, la base de datos cifrada en el dispositivo y el tratamiento de los casos límite asociados. Se sustituye por la interfaz web responsive.

No se construirá la vinculación criptográfica entre el usuario y su dispositivo mediante par de claves almacenado en el teléfono.

No se construirá el aislamiento entre varias empresas sobre una misma instalación. Se trabajará con una sola empresa, y el aislamiento quedará documentado y justificado como decisión de diseño, sin implementarse.

No se construirá la matriz de permisos asignables por recurso. Se sustituye por dos roles fijos con límites de autorización configurables.

No se desplegará en una nube pública ni se automatizará la infraestructura. El entorno será local mediante contenedores, con una canalización básica de integración continua.

No se conectará el proveedor real de notificaciones, por la razón expuesta en la sección 5.9.

Quedan igualmente fuera la evaluación crediticia automática, el asistente de inteligencia artificial, el portal de consulta para el cliente final, los reportes a socios, la analítica avanzada y la ordenación geográfica de rutas.

Por último, queda fuera la obtención de las certificaciones de protección de datos y de seguridad de la información que el producto exigiría en un despliegue real. El sistema se diseñará de forma compatible con ellas, y esa compatibilidad se documentará, pero la certificación no es alcanzable dentro del periodo del curso.
