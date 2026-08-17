# Demo Feedback — Cliente (16 agosto 2026)

**Contexto**: Sesión de review de demostraciones web (admin) y móvil (gestor). Cliente presentó feedback directo sobre los flujos mostrados.

**Formato**: 12 comentarios mapeados a módulos y reglas de negocio.

---

## Feedback Estructurado

### 1. Ver historial del cliente en momento de aprobación — `M4 · Ventas`
**Comentario original**: "en el momento de aprobar la venta, tenga la opcion de ver el hisotiral del cliente, para mirar cuantas veces presto y como pago."

**Impacto**: 
- **Módulo**: M4 (Ventas) · Detalle de venta, pantalla de aprobación
- **Acción**: Agregar panel con extracto del cliente (últimos 3–5 préstamos, estado, pagos)
- **Estado**: Abierta en `OQ-F-` (especificación de qué mostrar en el extracto previo a aprobación)
- **Regla**: El administrador debe poder verificar historial **antes de aprobar**, no después

---

### 2. Aprobar venta con deuda existente — `M4 · Ventas`
**Comentario original**: "cuando se haga una venta con algún cliente ya registrado, se tenga la opcion de que el administrador pueda aprobar otra venta con ese mismo numero de documento. Cuando se quiera hacer una nueva venta y él adminstrador quiera hacer la venta a un usuario y ya tiene una deduda, debe aprobar con un botón de autorización para aceptar la venta sin importar la deuda."

**Impacto**:
- **Módulo**: M4 (Ventas) · flujo de nueva venta
- **Regla**: SUSTITUYE a `OQ-F-41` (100% paid rule = hard block). Ahora es: *"Si el cliente tiene deuda, mostrar advertencia con botón `Autorizar venta con deuda pendiente`"*. El admin puede sobrescribir la regla.
- **Acción**: Cambiar de bloqueo duro a bloqueo suave con autorización
- **Estado**: Parcial en `OQ-F-41` (se conocía la regla, no la excepción)

---

### 3. Admin no puede auto-aprobarse, ni editar pagos ajenos — `M6 · Aprobaciones` / `M5 · Caja`
**Comentario original**: "el administrador no puede enviarse ventas el mismo para aprobar, tampoco puede modificar los pagos que el cobrador ingreso, tampoco modificarlos"

**Impacto**:
- **Módulo**: M6 (Aprobaciones) y M5 (Caja)
- **Regla #1**: Admin **no puede originar una venta y aprobarla él mismo**. La venta debe venir del gestor.
- **Regla #2**: Admin **nunca puede editar un pago ya registrado** (solo anular antes del cierre, lo que ya está en el diseño).
- **Estado**: Parcial en permisos — `OQ-F-46` (matriz de permisos) toca esto de forma general
- **Acción**: Hacer explícito que las aprobaciones nunca son "autor = ejecutor"

---

### 4. Bloqueo de caja por gestor, NO por empresa — `M5 · Caja`
**Comentario original**: "cuando un trabajador deja una caja abierta, en el trycontroller al otro dia no deja abrir las otras cajas, hasta que esa caja que quedo abrierta sea cerrada ( bloquea todas las cajas de todos los socios). la idea es que solo bloque las caja de ese socio."

**Regla de Negocio**: "Cuando un trabajardor (Gestor de cobranza) no cierre la caja, se debe bloquear solo la caja del gesto, no todo el sistema."

**Impacto**:
- **Módulo**: M5 (Caja)
- **Regla**: Si gestor **Marcos** cierra abierta, cierra **SOLO la caja de Marcos**. Los otros gestores pueden abrir sus propias cajas.
- **Estado**: Cerrada — cliente confirma que es una regla, no una alternativa
- **Acción**: Ninguna. Se refleja en el diseño existente (M5 del prompt es por gestor, no global).

---

### 5. Admin debe abrir todas las rutas — `M5 · Caja`
**Regla de Negocio**: "Administrador debe abrir todas las rutas, si el adminstrador no abre ruta 'sistema', ningún gestor puede abrir ruta"

**Impacto**:
- **Módulo**: M5 (Caja)
- **Regla**: Existe una ruta especial **`sistema`**. El admin **debe abrir explícitamente todas las rutas** (incluyendo `sistema`) antes de que cualquier gestor pueda abrir su caja.
- **Regla corolario**: Si admin no abre `sistema`, **ningún gestor** puede trabajar.
- **Estado**: Nueva — no aparece en `OQ-F-` con este nivel de detalle
- **Acción**: Requerimiento P0 para M5. Modelo de datos: rutas tienen estado (abierta/cerrada).

---

### 6 & 9. Código de identificación del cliente — `M3 · Clientes`
**Comentario original**: "cada cliente debe tener un codigo de identifiacion" y "Cada cliente debe tener un código"

**Impacto**:
- **Módulo**: M3 (Clientes)
- **Dato**: Cada cliente debe llevar un **código único** generado por el sistema (no el documento, que es PII).
- **Formato**: TBD — ¿secuencial? ¿UUID? ¿prefijo+número?
- **Visibilidad**: Debe aparecer en la ficha del cliente, en el móvil y en la web.
- **Estado**: Nueva — no estava en los requisitos
- **Acción**: Agregar campo `client_id` a M3

---

### 7. Permiso temporal de auto-aprobación — `M6 · Aprobaciones`
**Comentario original**: "que el adminisrtrador pueda dar permiso de forma momentanea para que el dia XXX todas las ventas que se suban queden aprobradas automaticamente, luego de ese dia el adinistrador bloquee esa opcion."

**Impacto**:
- **Módulo**: M6 (Aprobaciones) / M2 (Tablero)
- **Características**: 
  - Admin puede activar "auto-aprobación de ventas" para una fecha futura específica
  - Todas las ventas registradas **ese día** se aprueban automáticamente
  - Al finalizar el día (o manualmente), se desactiva
  - Cada activación se registra en el libro mayor
- **Estado**: Abierta — probablemente `OQ-F-43` (flujo de aprobación alternativo)
- **Acción**: Detallar condiciones — ¿solo para un día? ¿hasta qué hora? ¿requiere confirmación?

---

### 8. Código asociado a la venta — `M4 · Ventas`
**Comentario original**: "Cada venta debe teenr un código asociado a la venta y al cliente."

**Impacto**:
- **Módulo**: M4 (Ventas)
- **Datos**: Cada venta debe llevar un **código único** (tipo `VT-20260816-001` o similar).
- **Relación**: El código debe incluir o referenciar el `client_id`.
- **Visibilidad**: Aparece en confirmación, en el QR, en el libro mayor.
- **Estado**: Nueva — solo se menciona `sale_id` interno
- **Acción**: Definir formato y dónde aparece

---

### 10. Alias del cliente en momento de registrar venta — `M4 · Ventas`
**Comentario original**: "cuando de registre la venta tenga la opcion de ponerler un ALIAS para que el cobrador lo pueda idenficiar mejor"

**Impacto**:
- **Módulo**: M4 (Ventas) / M7 (Nueva venta, móvil)
- **Dato**: Campo opcional `alias` en la venta (no en el cliente).
- **Usos**: Permite que el cobrador identifique diferente ("Doña Margarita" vs nombre legal).
- **Visualización**: El alias aparece en la lista de clientes del gestor (M3, móvil).
- **Estado**: Parcial — existe en el modelo (`D-05` menciona "alias"), pero no está especificado dónde se captura
- **Acción**: Precisar flujo en M7 (nueva venta, móvil)

---

### 12. Alias asignado por gestor — `M4 · Cliente`
**Comentario original**: "El gestor le puede asignar un alías al cliente. este no solo es visible para el gestor."

**Impacto**:
- **Módulo**: M4 (Ficha del cliente, móvil)
- **Dato**: Campo editable `alias_by_collector` en el cliente.
- **Visibilidad**: El alias **no es privado** — aparece en la web (para el admin) y en otros gestores.
- **Diferencia con #10**: Aquí el alias es **del cliente** (data del cliente), no de la venta.
- **Estado**: Nueva — propone un campo separado
- **Acción**: ¿Fusionar con #10 o mantener dos tipos de alias?

---

### 11. Ordenar clientes por cercanía y último cobro — `M3 · Mi ruta` (móvil)
**Comentario original**: "que los clientes en el momento de hacer la cobranza, sean organizados por cercania. en la sección del Mapa de los gestores tienen para con sus clientes. se debe organizar organizar por dos opciones. Por cercanía y por Orden del último cobro (Día de la última sincronización)"

**Impacto**:
- **Módulo**: M3 (Mi ruta, móvil)
- **Datos necesarios**: GPS de cliente, fecha del último pago (o último sincronización).
- **Vistas**: Dos formas de ordenar:
  1. **Por cercanía** (distancia desde ubicación actual del gestor)
  2. **Por orden del último cobro** (más antiguo primero)
- **Estado**: Parcial — el diseño menciona "por cercanía", no el segundo criterio
- **Acción**: Implementar segundo criterio de ordenamiento

---

### 13. Ficha del cliente — mostrar datos básicos al tocar ícono — `M3 · Mi ruta` (móvil)
**Comentario original**: "En el mapa, en el ícono del a persona (Cliente) al tocar el ícono del cliente debe aparece la informacion básica del cliente."

**Impacto**:
- **Módulo**: M3 (Mi ruta, mapa, móvil)
- **Interacción**: Tap en marcador del mapa → popover con nombre, teléfono, cuota del día, saldo, estado.
- **Estado**: Lógica de UX — probablemente ya está diseñada
- **Acción**: Confirmar en el prototipo móvil

---

## Resumen de Impactos

| Área | Comentarios | Estado | Urgencia |
|---|---|---|---|
| **Modelo de datos** | #6, #8, #9, #10, #12 | Nuevos campos | P0 |
| **Aprobaciones & Permisos** | #2, #3, #7 | Abierto/Parcial | P0 |
| **Caja** | #4, #5 | Nuevas reglas | P0 |
| **Visualización/Orden** | #11, #13 | UI/UX | P1 |
| **Historial previo** | #1 | UI | P1 |

---

## Relación con open-questions.md

- **Abre**: `OQ-F-108`…`OQ-F-114` (7 nuevas funcionales — aliasing, códigos, permisos, auto-aprobación)
- **Cierra/Parciales**: `OQ-F-41` (actualiza regla de renovación), `OQ-F-46` (permisos), `OQ-F-50`…`OQ-F-52` (ordenamiento de clientes)
- **Reglas de negocio**: Confirma D-02, agrega detalles a D-05

---

## Próximas acciones (Discovery)

1. ✅ **Registrar este feedback** como D-06 (decisión del cliente, post-demo)
2. **Integrar en open-questions.md** — agregar 7 filas funcionales nuevas
3. **Iniciar sesión tech-discovery** — responder las 3 preguntas técnicas abiertas (`OQ-T-15`, `OQ-T-25`, `OQ-T-26`)
4. **Cerrar brechas funcionales** — antes del join, completar `OQ-F-108`…`OQ-F-114`

