# Especificación de Requerimientos: Sistema Inteligente de Administración de Préstamos

## 1. Introducción y Objetivos del Proyecto

El presente documento define las especificaciones técnicas y funcionales para el desarrollo de una plataforma integral de administración de préstamos con arquitectura **Software as a Service (SaaS)**. El sistema tiene como objetivo primordial la transición tecnológica de procesos basados en hojas de cálculo (Excel/Google Sheets) hacia un ecosistema digital centralizado, eliminando la redundancia operativa y el error humano mediante la automatización y el análisis predictivo.

### Objetivos del MVP (Producto Mínimo Viable)
*   **Centralización Operativa:** Consolidar la gestión de clientes, créditos, cobranza y flujos de caja en una única interfaz unificada.
*   **Eliminación de Procesos Manuales:** Automatizar el envío de notificaciones vía WhatsApp Business API y la generación de reportes financieros, suprimiendo la digitación manual.
*   **Optimización de Cobranza:** Facilitar la operación eficiente de carteras complejas con una estructura de personal mínima (1-2 gestores).
*   **Integridad de Datos:** Implementar un modelo de auditoría riguroso y una lógica de cierre de caja con intervención manual cero.

---

## 2. Arquitectura de Módulos Funcionales

### 2.1 Gestión de Acceso y Seguridad
Se implementará un esquema de Seguridad de Nivel Empresarial que proveerá la capacidad de:
*   **Control de Acceso (RBAC):** Definición de roles (Administrador, Socio, Gestor) con permisos granulares.
*   **Registro de Auditoría (Audit Log):** Trazabilidad total de cada transacción, capturando metadatos de origen para garantizar la integridad referencial.

### 2.2 Dashboard de Control Estratégico
Visualización en tiempo real de indicadores críticos de rendimiento (KPIs):
*   **Métricas Financieras:** Capital prestado, capital recuperado, intereses devengados, utilidad estimada y gastos operativos.
*   **Estado de Cartera:** Clientes activos, morosidad, préstamos nuevos y renovaciones.
*   **Liquidez:** Recaudo diario total, desglose por método (Efectivo vs. PIX) y saldo de caja actual.

### 2.3 Gestión de Clientes y Prospección
El sistema mantendrá un histórico pormenorizado de cada sujeto de crédito:
*   **Atributos de Identificación:** Nombre, documento, teléfono, dirección y el uso obligatorio de **"Alias"** (ej. "Restaurante", "Lavandería") para facilitar búsquedas rápidas en campo.
*   **Geolocalización:** Registro de coordenadas GPS precisas del domicilio y negocio.
*   **Lógica de Almacenamiento Multimedia:** 
    *   **Archivo Permanente (KYC):** Hasta 5 fotos vinculadas al perfil del cliente (documentos, fachada, comprobantes de residencia) que persisten en renovaciones.
    *   **Evidencia de Crédito:** Fotos vinculadas exclusivamente a un préstamo específico para registro de garantías.
*   **Venta Temporal (Estado de Pre-aprobación):** Capacidad de registrar prospectos sin generar un ID de préstamo ni afectar el balance de caja hasta su activación definitiva.

### 2.4 Ciclo de Vida de Préstamos y Autorizaciones
Administración de créditos en modalidades diaria, semanal, quincenal, mensual y libre.
*   **Sistema de Llaves de Autorización (Two-Tier Auth):**
    *   **Llave Automática:** El sistema detecta si una venta supera el límite configurado para la unidad y genera una solicitud de aprobación.
    *   **Llave Manual:** Código alfanumérico entregado por el administrador para desbloquear operaciones restringidas.
    *   **Trazabilidad:** Registro obligatorio del **"ID de Llave"** (identificador único del sistema) y el código de aprobación de 5 dígitos para auditoría posterior.

### 2.5 Módulo de Cobranza y Gestión de Rutas
Diseñado para la eficiencia del gestor de campo:
*   **Interacciones:** Registro de pago, "No Pago", visitas realizadas y promesas de pago con firma digital.
*   **Limpieza de Cobro (Route Optimization):** Funcionalidad para **desactivar** ventas inactivas de la vista del gestor. La lógica dicta que los datos no se eliminan, sino que se ocultan para optimizar la ruta. La recuperación de estas ventas requiere una descarga de actualización manual de la base de datos (UGI).

### 2.6 Control de Caja y Reportes Contables
*   **Gestión de Flujos:** Control estricto de caja inicial, ingresos, egresos por gastos y consignaciones.
*   **Generación de Reportes:** Automatización total de informes de ventas, mora y rentabilidad, eliminando la digitación manual.

---

## 3. Lógica Detallada de Registro de Pagos

El procesamiento de ingresos debe seguir una secuencia lógica estricta para asegurar la consistencia del libro mayor.

### 3.1 Flujo Dinero en Efectivo
Tras la validación del monto, el sistema ejecutará secuencialmente:
1.  Registro del ingreso en la base de datos.
2.  Actualización del estado del préstamo y cronograma de pagos.
3.  Descuento de la cuota pactada.
4.  Afectación positiva de la caja individual del gestor.
5.  Afectación positiva de la caja general de la unidad de negocio.
6.  Escritura en el Log de Auditoría.
7.  Generación del asiento contable automático.
8.  Emisión de comprobante digital.
9.  Disparo de notificación automática vía WhatsApp.

### 3.2 Flujo PIX (Gate de Validación)
Antes de procesar, el sistema presenta un **gate de validación obligatorio**:
*   **Requisito:** Solicitar y registrar el **Nombre del titular de la cuenta** emisora.

Posteriormente, ejecuta:
1.  Registro del pago con referencia al titular.
2.  Actualización del estado del préstamo.
3.  Afectación de la Caja Específica de PIX.
4.  Registro en Auditoría.
5.  Generación de comprobante digital.
6.  Envío de notificación automática vía WhatsApp.

---

## 4. Proceso de Cierre de Caja Automático

El sistema proveerá una transición transparente desde el formato Excel, garantizando la **ausencia total de digitación manual**.
*   **Cálculo Autónomo:** El motor financiero consolidará totales de PIX (por titular), Efectivo (por cliente), Gastos y Dinero Pendiente para determinar la Caja Final.
*   **Integridad de Diseño:** Los reportes generados deben replicar visualmente la estructura de las hojas de cálculo actuales para facilitar la lectura de los socios.
*   **Exportación:** Soporte mandatorio para formatos **Excel y PDF**.

---

## 5. Integración y Notificaciones (WhatsApp Business API)

| Evento | Momento de Envío | Datos Incluidos (Payload) |
| :--- | :--- | :--- |
| **Registro de Préstamo** | Inmediato | Valor prestado, # cuotas, valor cuota, fecha inicio y fin. |
| **Confirmación de Pago** | Post-registro | Valor pagado, fecha, cuotas pagadas/pendientes, saldo restante. |
| **Aviso de No Pago** | Al marcar incidencia | Valor pendiente, cuotas vencidas, días de atraso. |
| **Recordatorios** | Configurable (T-1, T+1, etc.) | Mensaje de cortesía, monto y fecha de vencimiento. |
| **Reporte para Socios** | Cierre de jornada diario | Ventas, Cobrado (Efectivo/PIX), No Pagos, Mora, Caja, Gastos y Utilidad. |

---

## 6. Motor de Automatización y Reglas de Negocio

Se define un motor de reglas lógicas basado en disparadores (triggers) y acciones:

| Evento de Entrada | Condición | Acciones de Salida (Output) |
| :--- | :--- | :--- |
| **Pago Registrado** | Monto > 0 | Actualizar saldo, enviar WhatsApp, refrescar Dashboard, asentar en caja. |
| **Incumplimiento** | Marcación "No Pago" | Incrementar contador de mora, notificar gestor, reprogramar visita. |
| **Aprobación Venta** | Con Llave validada | Generar contrato, crear cronograma, disparar auditoría, enviar notificación. |

---

## 7. Inteligencia Artificial y Análisis Predictivo

El sistema integrará un asistente de lenguaje natural capaz de procesar consultas complejas y análisis de datos:
*   **Consultas Operativas:** "¿Cuál gestor tiene mejor rendimiento?", "¿Qué clientes están listos para renovación?", "¿Cuánto ingresó hoy por PIX?".
*   **Capacidades Avanzadas:** 
    *   Detección proactiva de patrones de fraude y riesgo crediticio.
    *   Resúmenes ejecutivos de cartera por zonas geográficas.
    *   Recomendaciones estratégicas de gestión de cobranza basadas en el comportamiento histórico del cliente.

---

## 8. Especificaciones Técnicas de la Aplicación Móvil

La aplicación para gestores (Android/iOS) debe garantizar la continuidad operativa:
*   **Sincronización Bidireccional:** Los datos se sincronizan automáticamente al detectar conexión.
*   **Capacidad Offline:** Registro de cobranza y visitas sin conexión a red, con almacenamiento local seguro hasta la sincronización.
*   **Validación de Dispositivo:** Cada unidad está vinculada a un único dispositivo (UUID); cualquier cambio requiere desvinculación administrativa previa.

---

## 9. Requerimientos No Funcionales y Seguridad

### 9.1 Seguridad y Auditoría Técnica
Cada acción ejecutada en el sistema debe persistir los siguientes 6 metadatos obligatorios:
1. **Usuario** responsable.
2. **Fecha** exacta del servidor.
3. **Hora** con precisión de milisegundos.
4. **Dirección IP** de origen.
5. **Dispositivo** (ID y modelo).
6. **Acción** específica realizada.

### 9.2 Política de Respaldos
Esquema de copias de seguridad automáticas y redundantes:
*   **Incremental:** Cada hora.
*   **Completo:** Diario, Semanal y Mensual.
*   **Restauración:** Capacidad de Point-in-Time Recovery (PITR).

### 9.3 Atributos de Diseño (UI/UX)
El frontend debe adherirse a una estética de **Enterprise SaaS Moderno**, tomando como referencia visual a:
*   **Stripe / Linear:** Por su limpieza y velocidad.
*   **Notion:** Por su jerarquía de información.
*   **HubSpot / Salesforce:** Por su densidad de datos controlada.
*   **Atributos clave:** Interfaz responsive, carga asíncrona de datos y tiempos de respuesta inferiores a 200ms para acciones críticas.