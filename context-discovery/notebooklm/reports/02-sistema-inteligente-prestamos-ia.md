# Sistema Inteligente de Administración de Préstamos con IA

# requirements.md

## 1. Visión Estratégica del Proyecto

El **Sistema Inteligente de Administración de Préstamos con IA** ha sido diseñado como una solución de arquitectura **multi-tenant**, orientada a transformar radicalmente la eficiencia de las microfinanzas. La transición desde entornos fragmentados como Excel o Google Sheets hacia una plataforma SaaS integrada no responde únicamente a una necesidad de velocidad, sino que es una decisión táctica para asegurar la **integridad de los datos, el control de concurrencia y la centralización de registros de auditoría**. Esta infraestructura elimina el riesgo de pérdida de información y proporciona una "Single Source of Truth" (Única Fuente de Verdad), permitiendo que la organización escale operativamente sin las limitaciones de la digitación manual ni la desincronización de saldos, garantizando un entorno robusto para el crecimiento del capital.

## 2. Especificaciones de Módulos Centrales

Los módulos se han estructurado para maximizar el impacto operativo y la transparencia financiera:

| Módulo | Funcionalidades Clave | Valor Agregado |
| :--- | :--- | :--- |
| **Seguridad y Acceso** | RBAC (Control de acceso basado en roles), MFA y Logs de auditoría por IP/Dispositivo. | Blindaje de activos digitales y trazabilidad absoluta de cada transacción. |
| **Dashboard Estratégico** | KPIs en tiempo real: capital en calle, utilidad estimada, mora y comparativos diarios. | Inteligencia de negocio para la toma de decisiones basada en datos, no en intuiciones. |
| **Gestión de Clientes** | Expediente digital con KYC, georreferenciación y segmentación por comportamiento. | Reducción de riesgo crediticio mediante el conocimiento profundo del perfil del deudor. |
| **Ciclo de Vida de Préstamos** | Simulación multizona, refinanciación y cronogramas de pago automatizados. | Flexibilidad de productos financieros (diario, quincenal, mensual) con precisión algorítmica. |
| **Cobranza en Campo** | Sincronización offline, firma digital, registro de visitas y evidencias fotográficas. | Optimización de rutas y supervisión geoposicionada del personal operativo. |
| **Gestión de Caja** | Cierres automáticos, diferenciación de fondos y control de gastos operativos. | **Eliminación de errores de transcripción** y generación de reportes listos para legado (Excel/PDF). |
| **Context-Aware BI (IA)** | Análisis predictivo de fraude y asistente de consultas en lenguaje natural. | Transformación de datos crudos en estrategias de recuperación y ventas. |

## 3. Arquitectura de Movimientos Financieros y Caja

El sistema implementa una lógica de registro dual que segrega los flujos de capital según su naturaleza, asegurando una conciliación contable sin fisuras.

*   **Registro de Pagos en DINERO (Efectivo):**
    *   **Acción de Sistema:** Dispara una actualización simultánea en la **Caja del Gestor** y la **Caja General**.
    *   **Auditoría:** Captura automática de IP, Device ID, Usuario y Timestamp.
    *   **Contabilidad:** Actualización del estado del préstamo y descuento de cuotas en el libro mayor.
*   **Registro de Pagos vía PIX (Digital):**
    *   **Requerimiento Obligatorio:** El sistema exige el **Nombre del Titular** de la cuenta de origen para fines de auditoría y rastreo de lavado de activos.
    *   **Afectación de Fondos:** Los montos se dirigen a una **"Caja PIX"** específica, segregada del efectivo físico para facilitar la conciliación bancaria.

**Cierre de Caja Automático:** Diseñado para reemplazar los flujos de trabajo tradicionales, el sistema procesa todos los movimientos para generar reportes que replican el formato de legado ("Excel-Ready"). Esto incluye el desglose detallado de nombres de titulares PIX, nombres de clientes en efectivo y dinero pendiente, eliminando la necesidad de digitación manual.

## 4. Ecosistema de Integraciones y Automatización

La integración con la **WhatsApp Business API** y el motor de reglas lógico (**SI evento → ENTONCES acción**) automatiza la comunicación transaccional para reducir la carga administrativa.

*   **Triggers de Datos en WhatsApp:**
    *   **Nuevo Préstamo:** Envío automático de: valor prestado, número de cuotas, valor de cuota, fecha de primer pago y fecha de último pago.
    *   **Confirmación de Pago:** Envío de: valor pagado, fecha, cuotas pagadas, cuotas pendientes y saldo restante.
    *   **Alertas de No Pago:** Notificación de aviso de mora, cuotas vencidas, valor pendiente y días de atraso.
    *   **Recordatorios Configurables:** Alertas programadas (T-1 día, día del pago, T+1, T+3, T+7).
*   **Reportes para Socios:** Envío diario automatizado de un resumen ejecutivo que incluye ventas, recaudo (PIX vs. Efectivo), gastos y utilidad neta.

## 5. Capa de Business Intelligence y Seguridad

La Inteligencia Artificial actúa como una **Capa de Inteligencia de Negocio Contextual**, diseñada para responder a interrogantes críticos de la operación:

*   **Consultas de Performance:** "¿Cuál gestor tiene mejor rendimiento?", "¿Cuánto ingresó por PIX hoy?", "¿Qué volumen de ventas tenemos?".
*   **Análisis de Riesgo:** Identificación de clientes candidatos a renovación, detección de patrones de fraude y resúmenes de salud de cartera.
*   **Protocolos de Respaldo:** Política de backups con redundancia horaria, diaria, semanal y mensual para garantizar la continuidad del negocio.
*   **Seguridad de Hardware:** Cada acción se vincula estrictamente a un usuario y un identificador único de hardware, bloqueando accesos desde dispositivos no autorizados.

---

# funcionalidad.md

## 1. Guía de Operatividad y Flujos de Usuario

La estandarización operativa es el pilar fundamental para el éxito de la cobranza. El sistema transforma al gestor de campo en un nodo de datos eficiente, donde cada interacción —desde la visita hasta la firma digital— se rige por flujos lógicos que eliminan la discrecionalidad, asegurando que la realidad del territorio se refleje exactamente en el panel administrativo.

## 2. Gestión de Clientes y Venta Estratégica

Para mantener la integridad del histórico, el sistema establece una jerarquía clara entre el cliente (identidad) y la venta (transacción):

*   **Identidad y KYC (Know Your Customer):**
    *   **Alias/Referencias:** El campo "Alias" se utiliza para referencias comerciales rápidas (ej. "Taller de Juan").
    *   **Fotos de Cliente:** Hasta 5 imágenes que componen la "hoja de vida" (documentos, fotos de fachada). Estas fotos **persisten en las renovaciones**, creando un expediente histórico.
*   **Transacción (Venta Directa):**
    *   **Fotos de Venta:** Imágenes vinculadas únicamente a la transacción actual (garantías específicas del préstamo).
    *   **Flexibilidad Temporal:** Permite definir la frecuencia y, críticamente, seleccionar la **primera fecha de cobro**, lo que permite una planificación financiera personalizada desde el inicio.

## 3. Lógica de Aprobación y Sistema de Llaves (Workflow)

El control financiero se ejerce mediante un sistema de llaves que se activan por límites de monto de venta o por **límites de cuotas adelantadas** (evitando cobros excesivos sin autorización).

**Workflow de Autorización:**
1.  **Activación de Límite:** El **Trabajador** intenta registrar una venta o un pago (ej. pago de 11 cuotas cuando el límite es 10) que supera los parámetros de la unidad.
2.  **Bloqueo de Sistema:** El **Sistema** bloquea la acción y solicita una llave (Manual o Automática).
3.  **Evaluación de Riesgo:** El **Administrador** recibe una alerta en el panel web con los detalles de la solicitud (Unidad, Cliente, Monto, Tipo de Movimiento).
4.  **Generación de Código:** Al aprobar, el **Administrador** genera un código aleatorio (de 3 a 6 dígitos).
5.  **Ejecución:** El **Trabajador** recibe una notificación push con el código, lo ingresa en la App y el **Sistema** libera la transacción.
6.  **Auditoría:** La transacción se graba con un **ID de Llave** único para trazabilidad en el histórico de llaves.

## 4. Control de Cobranza y Limpieza de Cartera

El mantenimiento de una cartera saludable se gestiona mediante herramientas de filtrado y sincronización:

*   **Limpieza de Cobro:** Permite desactivar ventas inactivas para limpiar la ruta del gestor. La venta no se elimina (historial preservado), pero deja de generar ruido visual y administrativo.
*   **Lógica de Sincronización UGI (Unidad Gestión de Ingreso):** Si el **Administrador** reactiva a un cliente mientras la **Caja del Gestor** está abierta, el gestor **debe ejecutar la descarga UGI** en su dispositivo para que el cliente aparezca en su lista de recaudo actual.
*   **Ventas Temporales:** Permiten pre-registrar datos de clientes dudosos. Estas **no afectan el saldo de caja** ni los estados financieros hasta que la venta es confirmada y finalizada.

## 5. Administración de Recursos Humanos y Dispositivos

El sistema implementa un modelo de seguridad basado en el **Binding de Hardware-a-Trabajador**:

*   **Perfil del Trabajador:** Se exige el registro detallado diferenciando el **País Natal** (para verificación de identidad) del **País de Residencia** (donde opera la unidad).
*   **Formalización e Incentivos:** El registro riguroso de datos permite la afiliación de los gestores a convenios de **Seguro de Repatriación**, incentivando la lealtad y formalidad del personal en campo.
*   **Seguridad de Dispositivo Único:** Cada unidad de negocio se vincula a un **único dispositivo móvil**. 
*   **Desvinculación Reactiva:** En caso de robo o falla, el **Administrador** desvincula el equipo desde la web de forma inmediata. A partir de ese segundo, cualquier intento de acceso en el dispositivo antiguo disparará el error **"Dispositivo no coincide"**, bloqueando totalmente la operación y protegiendo los datos financieros.