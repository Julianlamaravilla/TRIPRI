# Requirements (Google Doc)

_Source ID: `f4ce1739-bfb8-4a2a-a78a-844e2dc55aaf` · 7142 caracteres · extraído de NotebookLM (TryPRI)_

---

Tab 1

DOCUMENTO DE REQUERIMIENTOS DEL PROYECTO



Proyecto



Sistema Inteligente de Administración de Préstamos con Inteligencia Artificial



(Versión Beta – Documento de Requerimientos Funcionales)



⸻



1. OBJETIVO GENERAL



Desarrollar una plataforma web y móvil para administrar una empresa de préstamos de dinero, reemplazando completamente el uso de hojas de cálculo y mejorando las funcionalidades existentes en TryController.



El sistema debe ser rápido, intuitivo, seguro y escalable, permitiendo administrar desde una sola plataforma:



* Clientes.

* Préstamos.

* Cobranza.

* Caja.

* Reportes.

* Gestores.

* Inteligencia Artificial.

* Integración con WhatsApp.

* Integración con PIX.



El sistema debe desarrollarse desde el inicio con arquitectura preparada para convertirse en un SaaS (Software como Servicio).



⸻



2. OBJETIVOS DEL MVP



La primera versión deberá permitir operar completamente el negocio con uno o dos gestores de cobranza.



Debe eliminar la necesidad de utilizar:



* Excel.

* Google Sheets.

* Reportes manuales.

* Mensajes manuales por WhatsApp.



Toda la operación deberá realizarse desde una sola aplicación.



⸻



3. MÓDULOS DEL SISTEMA



3.1 Inicio de sesión



El sistema deberá permitir:



* Login seguro.

* Recuperación de contraseña.

* Roles.

* Permisos.

* Registro de auditoría.



⸻



3.2 Dashboard



Mostrar en tiempo real:



* Capital prestado.

* Capital recuperado.

* Intereses cobrados.

* Clientes activos.

* Clientes morosos.

* Recaudo del día.

* Caja del día.

* PIX recibido.

* Dinero en efectivo.

* Gastos.

* Utilidad estimada.

* Préstamos nuevos.

* Renovaciones.

* Comparativos diarios.



⸻



3.3 Clientes



Registrar:



* Nombre.

* Documento.

* Teléfono.

* Dirección.

* Ubicación GPS.

* Referencias.

* Fotografías.

* Documentos.

* Observaciones.



Cada cliente deberá tener un historial completo.



⸻



3.4 Préstamos



Permitir:



* Crear préstamo.

* Renovar.

* Refinanciar.

* Simular cuotas.

* Cancelar.

* Historial.



Modalidades:



* Diario.

* Semanal.

* Quincenal.

* Mensual.

* Libre.



⸻



3.5 Cobranza



Cada gestor visualizará únicamente:



* Clientes asignados.

* Ruta.

* Cobros pendientes.

* Clientes en mora.



Registrar:



* Pago.

* No pago.

* Visitas.

* Fotografías.

* GPS.

* Firma digital.

* Observaciones.

* Promesas de pago.



⸻



3.6 Caja



Controlar:



* Caja inicial.

* Ingresos.

* Egresos.

* Gastos.

* Consignaciones.

* Caja final.



⸻



3.7 Reportes



Generar automáticamente:



* Ventas.

* Cobranza.

* Mora.

* Caja.

* PIX.

* Dinero en efectivo.

* Flujo de caja.

* Rentabilidad.

* Comparativos.



⸻



4. REGISTRO DE PAGOS



Cuando el gestor registre un pago deberá seleccionar:



Método de pago



○ Dinero



○ PIX



⸻



Si selecciona DINERO



El sistema deberá automáticamente:



* Registrar el pago.

* Actualizar el préstamo.

* Descontar la cuota.

* Actualizar caja del gestor.

* Actualizar caja general.

* Registrar auditoría.

* Registrar el movimiento contable.

* Generar comprobante.

* Enviar comprobante por WhatsApp.



⸻



Si selecciona PIX



El sistema deberá solicitar adicionalmente:



Nombre del titular de la cuenta que realizó el PIX.



Posteriormente deberá:



* Registrar el pago.

* Actualizar el préstamo.

* Actualizar caja PIX.

* Registrar auditoría.

* Generar comprobante.

* Enviar comprobante por WhatsApp.



⸻



5. CIERRE DE CAJA AUTOMÁTICO



Actualmente la empresa utiliza hojas de cálculo.



El nuevo sistema deberá generar automáticamente un reporte idéntico al formato utilizado actualmente.



El reporte deberá contener:



Pagos por PIX



* Nombre del titular.

* Valor recibido.



Pagos en Dinero



* Nombre del cliente.

* Valor recibido.



El sistema calculará automáticamente:



* Total PIX.

* Total Dinero.

* Caja.

* Gastos.

* Dinero pendiente.

* Caja final.



No deberá existir digitación manual.



La hoja Excel será reemplazada por el sistema.



Sin embargo, deberá existir la opción de exportar el reporte en Excel y PDF con el mismo formato actual.



⸻



6. INTEGRACIÓN CON WHATSAPP



El sistema deberá integrarse con WhatsApp Business API.



⸻



Cuando se registre un préstamo



Enviar automáticamente:



* Valor prestado.

* Número de cuotas.

* Valor cuota.

* Fecha primer pago.

* Fecha último pago.



⸻



Cuando el cliente pague



Enviar automáticamente:



* Valor pagado.

* Fecha.

* Cuotas pagadas.

* Cuotas pendientes.

* Saldo restante.



⸻



Cuando el cliente no pague



Enviar automáticamente:



* Aviso de no pago.

* Cuotas vencidas.

* Valor pendiente.

* Días de atraso.



⸻



Recordatorios automáticos



Configurable.



Ejemplo:



* Un día antes.

* El mismo día.

* Un día después.

* Tres días después.

* Siete días después.



⸻



Reportes automáticos para socios



Todos los días.



Enviar automáticamente por WhatsApp:



* Ventas.

* Cobrado.

* PIX.

* Dinero.

* Clientes que no pagaron.

* Clientes en mora.

* Caja.

* Gastos.

* Utilidad.



⸻



7. MOTOR DE AUTOMATIZACIÓN



El sistema deberá incluir un Motor de Automatización configurable.



Funcionará mediante reglas:



SI ocurre un evento → ENTONCES ejecutar acciones.



Ejemplos:



SI el cliente paga



ENTONCES



* Actualizar préstamo.

* Actualizar caja.

* Registrar auditoría.

* Enviar WhatsApp.

* Actualizar Dashboard.



⸻



SI el cliente no paga



ENTONCES



* Registrar mora.

* Enviar WhatsApp.

* Notificar gestor.

* Programar nueva visita.



⸻



SI se aprueba un préstamo



ENTONCES



* Crear cronograma.

* Generar contrato.

* Enviar WhatsApp.

* Registrar auditoría.



⸻



8. INTELIGENCIA ARTIFICIAL



El sistema deberá incorporar un asistente inteligente.



La IA deberá responder preguntas como:



* ¿Cuánto vendimos hoy?

* ¿Cuánto cobró cada gestor?

* ¿Qué clientes están en mora?

* ¿Qué clientes puedo renovar?

* ¿Cuál gestor tiene mejor rendimiento?

* ¿Cuánto dinero ingresó por PIX?

* ¿Cuánto dinero ingresó en efectivo?



La IA también deberá:



* Detectar riesgo.

* Detectar fraude.

* Generar reportes.

* Resumir cartera.

* Recomendar estrategias de cobranza.



⸻



9. APLICACIÓN MÓVIL



Para gestores.



Debe funcionar en Android e iPhone.



Funciones:



* Login.

* Clientes.

* Cobranza.

* GPS.

* Fotografías.

* Firma digital.

* Registro de pagos.

* Registro de PIX.

* Modo Offline.

* Sincronización automática.



⸻



10. PANEL ADMINISTRATIVO



Dashboard completo.



Clientes.



Préstamos.



Cobranza.



Caja.



Reportes.



Usuarios.



Configuración.



Motor de automatización.



Inteligencia Artificial.



⸻



11. SEGURIDAD



Registrar toda acción realizada.



Guardar:



* Usuario.

* Fecha.

* Hora.

* IP.

* Dispositivo.

* Acción.



⸻



12. RESPALDOS



Copias automáticas.



* Cada hora.

* Diarias.

* Semanales.

* Mensuales.



Con posibilidad de restaurar la información.



⸻



13. DISEÑO



Inspirado en:



* Stripe.

* Linear.

* Notion.

* HubSpot.

* Salesforce.



Debe ser:



* Muy rápido.

* Muy intuitivo.

* Responsive.

* Claro.

* Moderno.
