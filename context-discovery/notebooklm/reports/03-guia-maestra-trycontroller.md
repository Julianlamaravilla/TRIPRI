# Guía Maestra de Operación y Control Estratégico: Plataforma TryController

## 1. Gestión Integral de Clientes y Proceso de Registro de Ventas

La base de una cartera saludable y escalable reside en la calidad de la información capturada durante el primer contacto. Desde una perspectiva de consultoría estratégica, la captura de datos fidedignos en la fase de prospección no es solo un trámite administrativo, sino una medida crítica para minimizar el riesgo operativo. Al documentar con precisión la identidad y ubicación del cliente, la organización fortalece el historial crediticio interno, permitiendo una toma de decisiones informada y garantizando una trazabilidad absoluta ante cualquier eventualidad en el proceso de recaudo.

### Parámetros de Registro y Captura de Datos
Para la creación de un cliente nuevo en el sistema, es fundamental distinguir entre la información crítica de control y los datos de apoyo operativo:
*   **Datos Obligatorios (Marcados con asterisco *):** Incluyen número de documento, primer nombre, primer apellido, celular, ciudad y dirección. Estos campos activan la creación del perfil en la base de datos.
*   **Datos Opcionales:** El campo "Alias" es vital para la identificación comercial (ej. "Restaurante", "Lavandería"), mientras que el barrio y datos secundarios robustecen la hoja de vida sin bloquear el flujo de registro.

### Valor Estratégico de la Documentación Visual
La funcionalidad de **"Adjuntar Fotos"** permite integrar hasta cinco imágenes directamente a la hoja de vida del cliente. Sus beneficios estratégicos incluyen:
*   **Historial Inalterable:** A diferencia de las fotos de venta, estas imágenes permanecen ancladas al perfil permanente, facilitando el control de identidad en renovaciones futuras.
*   **Verificación de Identidad y Residencia:** Permite el almacenamiento digital de documentos oficiales y comprobantes de domicilio.
*   **Control de Garantías:** Facilita la auditoría visual del negocio o bienes del cliente desde el primer día de la relación comercial.

### Mecanismos de Control Táctico: Referencias y Venta Temporal
El sistema permite añadir **"Referencias"** (contactos de conocidos o codeudores) para ampliar la red de recuperación. Por otro lado, la **"Venta Temporal"** funciona como un "sandbox" o modo de prueba: permite salvaguardar la información recopilada cuando el cierre de la venta es incierto. **Importante:** Bajo este modo, no se ingresa el cliente a la base de datos definitiva ni se afecta la cuenta de caja, evitando así el "ruido" de datos de prospectos no convertidos.

Este rigor en el registro inicial establece el fundamento necesario para aplicar mecanismos de control financiero avanzados, como la gestión de montos y autorizaciones especiales.

---

## 2. Sistema de Llaves y Control de Límites de Venta

El sistema de llaves actúa como una arquitectura de gobernanza financiera, diseñada para que los administradores mantengan la supervisión directa sobre transacciones de alto valor. Esta herramienta permite delegar la operación de campo sin ceder el control total sobre el capital, asegurando que cualquier operación que exceda los parámetros de riesgo establecidos deba ser validada en tiempo real bajo criterios de prudencia administrativa.

### Gestión de Límites y Activación de Llaves
El **"Límite de Unidad"** define el monto máximo que un trabajador puede registrar de forma autónoma. Cuando una venta supera este umbral (ej. una venta de $200,000 en una unidad limitada a $150,000), el sistema bloquea automáticamente la transacción y activa la solicitud de una llave de aprobación.

### Comparativa de Flujos de Aprobación
| Característica | Llave Manual | Llave Automática |
| :--- | :--- | :--- |
| **Definición** | Código proporcionado directamente por el administrador. | Solicitud digital enviada desde la App a la consola web. |
| **Proceso del Trabajador** | Digita el código entregado por el supervisor. | Presiona "Solicitar Llave" y espera la validación. |
| **Proceso del Administrador** | Genera y comunica el código externamente. | Aprueba desde el módulo de "General/Aprobaciones/Llaves". |
| **Resultado** | Habilita el registro tras validación manual. | El sistema genera un código aleatorio y notifica al móvil. |
| **Caso de Uso Ideal** | Supervisores presentes físicamente en el sitio. | Gestión remota y centralizada de múltiples rutas. |

### Continuidad Operativa vía Notificaciones
Una vez que el administrador aprueba la solicitud en la web, el sistema dispara una notificación móvil al dispositivo del trabajador. Este mecanismo garantiza la fluidez operativa, informando al operario en tiempo real que puede proceder con el registro final utilizando el código aleatorio generado, eliminando tiempos muertos en la calle.

Además del control de montos, el sistema permite auditar estas aprobaciones mediante el acceso al histórico, garantizando transparencia total en cada excepción autorizada.

---

## 3. Auditoría de Operaciones y Mantenimiento de Cartera

La visibilidad administrativa es el pilar de una gestión de cartera eficiente. El seguimiento de movimientos y la depuración constante de la lista de cobro optimizan la claridad del capital en calle, permitiendo a la gerencia enfocar los esfuerzos del equipo únicamente en los activos productivos.

### Uso del Histórico de Llaves
El **"Histórico de Llaves"** es la herramienta de auditoría principal. Es vital distinguir que el **ID de la llave** visualizado en los reportes es un identificador administrativo único del registro, el cual no debe confundirse con el **código aleatorio** de varios dígitos que el trabajador ingresa físicamente en su dispositivo para desbloquear la venta.

### Procedimiento de Limpieza de Cobro (Cartera Castigada)
Esta funcionalidad permite activar o desactivar ventas que han pasado a ser **cartera castigada** (inactivas o incobrables temporalmente) sin eliminarlas del sistema:
*   **Optimización de Ruta:** Al desactivar estos clientes, el trabajador visualiza una lista de cobro depurada, enfocándose solo en clientes vigentes.
*   **Recuperación de Activos:** Si un cliente en cartera castigada decide retomar sus pagos, el administrador puede reactivarlo desde la web para que reaparezca inmediatamente en la ruta de recaudo.

### Sincronización técnica (UGI)
Para que los cambios de limpieza de cobro se reflejen en la aplicación móvil, el sistema utiliza la **UGI (Unidad de Gestión de Ingreso)**:
1.  **Caja Abierta:** El trabajador debe ir a "Configuración" y realizar las descargas de "Información de la unidad, configuración y clientes de la UGI".
2.  **Caja Cerrada:** Las actualizaciones se sincronizan automáticamente al abrir la nueva jornada laboral.

Esta gestión de mantenimiento asegura que la base de datos sea un reflejo fiel de la operación, facilitando la transición hacia procesos de recaudo avanzado y renovaciones.

---

## 4. Recaudo Avanzado, Renovaciones y Gestión de Fotos

El control de los pagos adelantados es una salvaguarda esencial para mitigar riesgos de liquidez y prevenir posibles fraudes operativos. Bajo esta lógica, las renovaciones se posicionan como el motor de crecimiento, permitiendo capitalizar la relación con clientes existentes bajo un esquema de control riguroso.

### Control de Pagos Adelantados (Límite de Cuotas)
La funcionalidad de **"Pago de Cuotas con Límite"** es un mecanismo de control de **pagos por adelantado**, no una restricción sobre el plazo total del contrato inicial. Si un administrador configura un límite de 10 cuotas, y un trabajador intenta ingresar 11 pagos en una sola transacción, el sistema exigirá una llave de autorización. Esto evita ingresos masivos de capital sin la debida validación jerárquica.

### Renovación de Ventas y Actualización de Perfiles
El proceso de **"Renovación de Venta"** constituye el momento ideal para el mantenimiento de datos. El sistema permite al operario actualizar direcciones o teléfonos antes de registrar el nuevo ciclo de crédito, asegurando que la "Hoja de Vida" del cliente evolucione junto con la relación comercial.

### Gestión Especializada de Archivos Fotográficos
Es crucial diferenciar el propósito y ubicación de cada captura para una auditoría efectiva:

*   **Fotos de Cliente (Hoja de Vida):**
    *   Ancladas permanentemente al perfil del cliente (identidad/domicilio).
    *   **Visualización Web:** Módulo de Clientes -> Hoja de Vida -> Sección Imágenes.
*   **Fotos de Venta (Transaccionales):**
    *   Ancladas a una transacción o contrato específico.
    *   **Visualización Web:** Reporte de Ventas (desplazar columna a la derecha).
    *   **Visualización App:** Clic en el nombre del cliente -> Seleccionar "Ver Fotos".

Una vez consolidada la gestión operativa del cliente, el siguiente paso es asegurar la estructura administrativa y la seguridad de los terminales de acceso.

---

## 5. Estructura Administrativa: Trabajadores y Seguridad de Dispositivos

La seguridad perimetral de la plataforma se fundamenta en una relación unívoca entre la unidad de negocio, el trabajador y el dispositivo móvil autorizado. Este trinomio actúa como un método de control de acceso infranqueable, garantizando que solo el hardware y personal autorizados operen los activos de la empresa.

### Creación de Trabajadores y Mitigación de Riesgos
La creación del trabajador es un paso crítico de cumplimiento. Además del control operativo, este registro habilita el **"Seguro de Repatriación"**. En un entorno de consultoría senior, esto se define como una estrategia de responsabilidad corporativa y mitigación de riesgos legales para empresas que operan con fuerza laboral migrante o en territorios transfronterizos.

### Gestión y Seguridad de Dispositivos Móviles
Cada unidad operativa permite un único dispositivo vinculado. El procedimiento de **"Desvincular Dispositivo"** es una acción de seguridad inmediata ante fallas técnicas, pérdida del terminal o cambios de ruta. Una vez ejecutada desde la web, cualquier intento de movimiento en el móvil generará un error de coincidencia, bloqueando el acceso a la información.

### Pasos para la Vinculación Exitosa de un Nuevo Dispositivo
1.  **Registro Previo:** El trabajador debe estar creado y asignado a su unidad correspondiente.
2.  **Identificación de Hardware:** Ingresar el **PIN o Código de Dispositivo** (identificador único del terminal) en el módulo de administración web para bloquear el acceso a ese hardware específico.
3.  **Configuración de Acceso:** Seleccionar al trabajador y asignar la contraseña de seguridad.
4.  **Activación:** Ejecutar la acción de vinculación para autorizar el inicio de operaciones.

---

## 6. Resolución de Situaciones Operativas Frecuentes (FAQ Estratégico)

La eficiencia de una plataforma depende de la capacidad del equipo para resolver contingencias con celeridad basándose en el conocimiento técnico del sistema.

*   **¿Es posible editar una venta realizada con llave?**
    Sí, siempre que la venta sea del día actual y **no presente movimientos** (pago o no pago). Si el nuevo monto editado también supera el límite configurado, el sistema solicitará una **nueva llave de autorización** para validar el cambio de riesgo.
*   **¿Quién tiene visibilidad sobre las imágenes capturadas?**
    La visibilidad es omnicanal. Los administradores auditan desde la web (Ventas/Hoja de Vida), y los trabajadores consultan en la App a través del perfil del cliente en la opción "Ver Fotos".
*   **¿Cuál es el tiempo de respuesta tras activar un cliente en "Limpieza de Cobro"?**
    Depende del estado de la caja de la unidad. Si la caja está **cerrada**, el cambio se refleja al iniciar la siguiente jornada. Si está **abierta**, el trabajador debe forzar la actualización mediante las descargas de la **UGI** en el menú de Configuración.

**Conclusión:** El éxito en la escalabilidad de su modelo de negocio depende del uso disciplinado y estratégico de estas herramientas. La correcta implementación de límites, auditorías y controles administrativos no solo protege su capital, sino que profesionaliza la operación de cobro a gran escala.