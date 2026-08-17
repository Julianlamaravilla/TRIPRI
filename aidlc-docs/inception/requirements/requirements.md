# Requirements Document — ROYEXA v1 MVP

**Generado**: 2026-08-16
**Fase**: Inception - Requirements Analysis
**Profundidad**: Comprehensive
**Estado**: ✅ APROBADO POR EL CLIENTE

---

## 1. Executive Summary

**ROYEXA** es un **sistema SaaS multi-tenant de gestión de cobranza y control antifraude** para pequeñas financieras que operan en Brasil. Sustituye a TryController, consolidando el registro inmutable de cobros y los dos controles antifraude específicos que el cliente ha identificado como su razón de ser.

| Atributo | Valor |
|---|---|
| **Tipo de Proyecto** | Greenfield |
| **Mercado** | Brasil (BRL) — UI en Español |
| **Escala Inicial** | ~2.000 clientes finales, ~50 rutas, <100.000 BRL en cartera |
| **Equipo** | 1 desarrollador junior (Python/FastAPI) |
| **MVP Fecha Objetivo** | No especificada (flexible) |

---

## 2. Decisiones Finales Confirmadas (D-01 a D-05)

### D-01: El sistema NO custodia dinero

- No es wallet, fintech, ni medio de pago
- Efectivo y PIX son **información** (registros), no flujo de fondos
- Único flujo real: facturación del software (web only)
- ✅ **Cierra regulación**: no requiere licencia PSP, solo LGPD + ISO 27001

### D-02: 12 Reglas de Negocio Ejecutables

1. **Interés fijo** sobre monto prestado (ej: 1.000 BRL a 24 cuotas = 1.200 total)
2. **Cuota indivisible** (no se descompone en interés + capital)
3. **Sin mora** (es estado a los 3 días, no cargo que crece)
4. **Sin descuento** por pago anticipado o cancelación total
5. **Frecuencia lunes–sábado** (domingo corre al siguiente)
6. **Pago parcial aceptado** con contador fraccionario (ej: cuota 50 → entrega 25 → quedan 19,5 de 20 cuotas)
7. **Renovación exige 100%** pagado (bloquea envío de venta si hay atraso)
8. **Refinanciación** recalcula interés sobre saldo, cliente arranca en 0
9. **Flujo de aprobación en 4 pasos**: cobrador → supervisor → admin → **QR al WhatsApp del cliente** (libera dinero)
10. **Caja en 3 paneles** (pendientes / pagaron / no pagaron) — cierra solo con pendientes = 0
11. **Reversible**: una vez cerrada caja es irreversible
12. **Dos fraudes a combatir** (C-99):
    - Venta sin entrega → Control: **QR**
    - Cobrador cobra y no registra → Control: **Extracto por WhatsApp al cliente final**

### D-03: MVP Scope (Confirmado)

**IN**: App del cobrador completa + Web mínima (crear clientes, aprobar ventas, dar llaves)

**OUT**: Portal del cliente final, scoring automático, facturación SaaS (manual por ahora), reportes avanzados

### D-04: Roles y Permisos

**Tres roles base** + matriz de permisos por recurso (NEW — resuelve CX-40):

| Rol | Responsabilidades | Permisos en v1 |
|---|---|---|
| **Cobrador** | Recorre ruta, registra cobros, cierra caja | Crear clientes, registrar pagos, cierre de caja |
| **Admin Principal** | Dueño suscripción, aprueba ventas, crea secundarios, asigna permisos | Todos (con matriz de delegación) |
| **Admin Secundario** | Creado por principal, permisos asignados (NEW) | Subconjunto configurable por admin principal |
| **Socio** | Recibe reportes (lectura solo) | Ver reportes agregados |
| **Cliente Final** | No usa sistema | Recibe extracto WhatsApp por pago |

✅ **Matriz de permisos** (Q6 respuesta B): Feature completo en v1, no diferir a v2.

### D-05: Decisiones de Diseño Cerradas (2026-08-08)

- **No IA en v1** (Q5 respuesta B): Scoring 100% manual. IA → v2+
- **Dispositivo por PIN enviado por admin** (no contraseña débil del usuario)
- **Términos y condiciones versionados** (LGPD base legal)
- **Permisos asignables por recurso** (Q6) — matriz completa, no exceptions-based

---

## 3. Requisitos Funcionales

### 3.1 Módulo: Gestión de Clientes

**Actores**: Cobrador (crear), Admin (ver todas)

**Funcionalidades**:
- Crear cliente con:
  - Nombre, teléfono, dirección (opcional)
  - **Fotos**: documento de identidad, residencia, comprobante de ingresos (C-42, C-44)
  - Email (para reporte de ingresos futuros)
  - Datos de contacto secundario
- Editar cliente (nombre, teléfono, dirección)
- Listar clientes asignados a la ruta
- Búsqueda difusa por nombre o teléfono (pg_trgm, T14)
- Estado cliente: Activo / Suspendido / Clausurado

**Restricciones**:
- Solo cobrador de la ruta puede verlos (T17 RLS)
- Admin puede ver todos los clientes del tenant

**No en v1**: Scoring automático (diferido a v2)

---

### 3.2 Módulo: Préstamos y Cuotas

**Actores**: Admin (crear), Cobrador (ver), Sistema (calcular)

**Funcionalidades**:
- Crear préstamo con:
  - Monto principal, plazo (días o # cuotas), interés fijo (%)
  - Cliente asociado, ruta asociada
  - Fecha de inicio (hoy o futuro)
  - Estado: Activo / Pausado / Cerrado / Refinanciado
- Cálculo automático de cuota = (principal + interés) / # cuotas
- Lista de cuotas: monto, fecha vencimiento (lunes–sábado), estado (pendiente / pagada / parcial)
- Imputación de pago a cuota (FIFO por defecto, o manual)
- Contador fraccionario: si pago < cuota, registra porcentaje avanzado (ej: 19,5 de 20)

**Restricciones**:
- Cuota indivisible (no interés + capital separados) — D-02#2
- Sin descuento por anticipado — D-02#4
- Sin interés ni cargo de mora — D-02#3
- Solo 100% pagado permite renovar — D-02#7
- Frecuencia obligatoria lunes–sábado — D-02#5

**No en v1**: Scoring automático, automatización de refinanciación

---

### 3.3 Módulo: Cobranza (Offline-First)

**Actores**: Cobrador (principal)

**Funcionalidades Críticas**:
1. **Modo offline completo**:
   - App funciona sin señal (C-65)
   - Colas de comandos locales en SQLite cifrada
   - Sincronización cuando hay señal (REST + lote de operaciones)
   - Idempotencia por UUID generado en el móvil

2. **Registro de pago**:
   - Seleccionar cliente y préstamo
   - Ingresar monto (Decimal, nunca float)
   - Registrar medio: Efectivo / PIX
   - Timestamp del dispositivo + servidor (T14)
   - Sistema calcula: monto aplicado, exceso, cuotas avanzadas (fraccionario)

3. **Registro de "No pago"**:
   - Motivo: Cliente no estaba / No tiene dinero / [otros]
   - Compromiso de pago (fecha próxima)
   - Comentarios libres

4. **Estado de la ruta** (dashboard diario):
   - Clientes visitados / pendientes
   - Total cobrado (BRL)
   - Total pendiente
   - Número de "no pagos" con motivo

**Restricciones**:
- Operación debe llevar UUID generado en móvil
- Encola localmente con estado: pendiente → enviada → confirmada
- Solo se borra de cola tras confirmación del servidor
- Tolera cambio manual del reloj del dispositivo (registra ambas horas)

**No en v1**: IA para sugerir clientes en ruta óptima, geolocalización, captura de firma

---

### 3.4 Módulo: Caja (Cierre Diario)

**Actores**: Cobrador (abre/cierra), Admin (supervisa)

**Funcionalidades**:
1. **Apertura**:
   - Admin abre caja para el cobrador (autorización explícita)
   - Registro: quién, cuándo, monto inicial (si hay)

2. **Durante el día**:
   - Tres paneles (C-50):
     - **Pendientes**: Clientes sin visita del día
     - **Pagaron**: Total efectivo + PIX acumulado
     - **No pagaron**: Total con motivos agrupados

3. **Cierre**:
   - Caja cierra **solo si pendientes = 0** (C-50)
   - Cobrador ingresa dinero en caja (efectivo)
   - Sistema reconcilia: dinero físico vs. dinero registrado
   - **Descuadre = dinero registrado - dinero físico**
     - Descuadre positivo: dinero faltante (posible robo/fraude — C-99)
     - Descuadre negativo: dinero extra (poco probable, pero registra igual)
   - **Métrica de éxito #1 (Q3 prioridad)**: "Descuadres de caja por mes"
     - Registra cada descuadre automáticamente
     - Admin ve trending en tablero

4. **Post-cierre**:
   - Caja irreversible (C-58)
   - Reporte generado (listado de operaciones del día)
   - Extracto enviado a cliente final por WhatsApp (C-99 — ver abajo)

**Restricciones**:
- Caja solo puede estar abierta para un cobrador por ruta
- Una vez cerrada es inmutable (audit trail)

---

### 3.5 Módulo: Aprobaciones (4 Pasos + QR)

**Actores**: Cobrador (solicita), Supervisor (autoriza monto), Admin (aprueba), Cliente (escanea QR)

**Flujo de Venta** (C-31):

```
Paso 1: Cobrador registra pago en la app
        → App genera "venta" con monto
        
Paso 2: Supervisor autoriza venta
        → Si monto > límite, supervisor debe autorizar
        → Si ≤ límite, pasa automático
        
Paso 3: Admin aprueba la venta
        → Revisa (puede rechazar por motivo)
        → Si aprueba, sistema genera QR único
        
Paso 4: QR enviado al WhatsApp del cliente final
        → Cobrador muestra QR en móvil
        → Cliente escanea QR para confirmar recibo
        → Sistema libera dinero de la caja
```

**Restricciones**:
- QR **sustituye firma digital** (no contrato escrito, C-31)
- QR caduca en 10 minutos (o al cerrar caja)
- Admin puede rechazar venta (rechaza el dinero que se quedó el cobrador sin entregar)

---

### 3.6 Módulo: Mensajería al Cliente Final (WhatsApp)

**Actores**: Sistema (envía), Cliente final (recibe)

**Funcionalidades**:
1. **Extracto por pago** (C-99 — Control antifraude #2):
   - Enviado automáticamente al cerrar caja
   - Contenido:
     - Monto pagado hoy
     - Cuotas avanzadas (fraccionario)
     - Saldo restante (próximas cuotas)
     - Fecha próximo vencimiento
   - **Propósito**: Cliente tiene comprobante independiente del cobrador
   - **Evidencia**: Si cobrador dice que cobró y cliente no recibe extracto, hay fraude

2. **Alertas** (configurables por tenant):
   - Atraso detectado (3+ días sin pago en vencimiento)
   - Cuota próxima a vencer (1 día antes)
   - Renovación aprobada
   - Descuadre de caja registrado (solo si es grave)

**Restricciones**:
- WhatsApp Cloud API requerida (CX-16 — bloqueante actual)
- Sin WhatsApp, los dos controles antifraude desaparecen
- Mensajes en español (plantillas versión v1)

**No en v1**: Telegram para admin (diferido), SMS fallback

---

### 3.7 Módulo: Auditoría Inmutable (Ledger)

**Actores**: Sistema (escribe), Admin/Auditor (consulta)

**Funcionalidades**:
1. **Libro mayor de solo-INSERT**:
   - Tabla `ledger_entry`: nunca UPDATE, nunca DELETE
   - Cada operación = asiento contable
   - Asientos compensatorios para correcciones (reversa visibles)

2. **Campos registrados**:
   - `id`: UUID
   - `tenant_id`: Aislamiento multi-tenant
   - `operation_type`: payment / no_payment / cash_box_closing / sale_approval / reversal
   - `occurred_at`: Hora del dispositivo (informativa)
   - `received_at`: Hora del servidor (confiable)
   - `amount`: Decimal (nunca float)
   - `client_id`, `loan_id`, `cash_box_id`: Referencias
   - `metadata`: JSONB (datos adicionales)
   - `created_at`: Timestamp del sistema

3. **Consultas**:
   - Historial completo de operaciones (filtrable por cliente, ruta, fecha)
   - Saldo en cualquier fecha histórica
   - Trazabilidad de descuadres (quién registró qué, cuándo)

4. **Derecho al olvido vs. Ledger**:
   - **Foto**: Se borra de S3 (RGPD/LGPD art. 18)
   - **Referencia en ledger**: Se mantiene (evidencia de que existió)
   - **Hash de foto**: Se mantiene (verificación sin exponer dato)

**Restricciones**:
- Permisos PostgreSQL: tabla solo acepta INSERT para aplicación
- RLS: cada tenant solo ve sus propios asientos
- Retención: ledger **nunca se borra** (D-02 antifraude)

---

### 3.8 Módulo: Administración Multi-Tenant

**Actores**: Admin principal (gestiona), Desarrollador (operación)

**Funcionalidades**:
1. **Aislamiento por tenant**:
   - Cada financiera es un tenant aislado
   - RLS a nivel PostgreSQL (`SET LOCAL app.tenant_id`)
   - `tenant_id` extraído del JWT verificado (T17)

2. **Creación de tenant**:
   - Nombre, dominio, plan (Básico / Profesional)
   - Fecha activación, período de prueba
   - Contacto principal (email)

3. **Gestión de usuarios** (dentro del tenant):
   - Crear cobrador (link a dispositivo)
   - Crear admin secundario (asignar permisos)
   - Crear socio (lectura de reportes)
   - Revocar acceso (inmediato, borra clave del dispositivo)

4. **Configuración del tenant**:
   - Límites de caja por ruta
   - Zona horaria (América/São_Paulo — fijo, sin DST)
   - Límites de autorización (montante máximo sin supervisor)
   - Plantillas de WhatsApp (textos personalizados)

**No en v1**: Branding por tenant (logo, colores), facturación automatizada

---

### 3.9 Módulo: Reportes y Tablero Web

**Actores**: Admin, Socio (lectura)

**Funcionalidades**:
1. **Resumen diario**:
   - Total cobrado (BRL)
   - Cuotas avanzadas
   - # descuadres de caja (métrica #1 — Q3)
   - Tasa de mora (métrica #2 — Q3)
   - Latencia promedio de cierre (métrica #3 — Q3)

2. **Tablero por ruta**:
   - Cobrador asignado
   - # clientes en ruta
   - # clientes visitados hoy
   - Total cobrado vs. meta
   - Descuadres (si hay)

3. **Tablero por cliente**:
   - Historial de pagos (con fechas)
   - Saldo restante
   - Próxima cuota y vencimiento
   - Estado: Activo / Atrasado / Renovado

4. **Alertas configurables**:
   - Descuadre registrado
   - Cliente atrasado 3+ días
   - Caja sin cerrar (5+ horas después del cierre de ruta)
   - Dispositivo sin sincronizar (12+ horas)

**Tecnología**: React 19 + Vite + TanStack Query (SPA estática)

**No en v1**: Exportación a Excel, gráficas de tendencias, API para terceros

---

## 4. Requisitos No-Funcionales

### 4.1 Integridad y Auditoría

| Requisito | Implementación |
|---|---|
| **Integridad de datos** | Ledger append-only (T14) · Restricciones UNIQUE en operaciones idempotentes (T14) |
| **Trazabilidad** | Timestamp servidor + dispositivo (T14) · tenant_id en todo asiento (T17) · audit trail inmutable |
| **No repudio** | JWT con firma HS256 (T17) · token contiene user_id + device_id |
| **Detección de fraude** | Descuadres de caja registrados (C-99) · Extracto WhatsApp como testigo (C-99) |

**Métrica de éxito**: Cero pérdida de datos en operaciones online. Cero descuadres no detectados (Q3).

---

### 4.2 Funcionamiento Sin Señal

| Requisito | Implementación |
|---|---|
| **Offline completo** | SQLite cifrada en dispositivo (T30) · Cola de comandos local (T14) |
| **Sincronización al regresar** | REST + POST de lote de operaciones (T14) · Resultado por operación, no all-or-nothing |
| **Idempotencia** | UUID generado en móvil (T14) · UNIQUE(tenant_id, client_operation_id) en BD (T14) |
| **Resiliencia** | App tolera cierre inesperado · Batería agotada · Cambio manual de reloj (T14) |
| **Pruebas obligatorias** (E2E #1) | Modo avión toda la mañana · Sincronización posterior · Escenarios E2E críticos (T22) |

**SLA**: Cobradores trabajan 6–8 horas sin señal. Sistema debe registrar todo.

---

### 4.3 Aislamiento Multi-Tenant

| Requisito | Implementación |
|---|---|
| **Separación de datos** | RLS a nivel PostgreSQL (T10) · Clave (`app.tenant_id`) en contextvars por transacción (T10) |
| **No percolation** | Ningún JOIN sin filtro tenant_id (T10) · SQL crudo requiere verificación |
| **Tokens** | JWT contiene tenant_id · Verificado, nunca del cuerpo de la petición (T17) |
| **Secretos** | Cada tenant puede tener clave WhatsApp única (futuro) · Hoy, un solo endpoint (v1) |

**Riesgo**: Una fuga de datos entre financieras mata el SaaS. Máxima prioridad.

---

### 4.4 Recuperabilidad

| Requisito | Valor | Implementación |
|---|---|---|
| **RTO** (tiempo de recuperación) | < 1 hora (V-43) | Snapshots automáticos de RDS · Copias diarias a S3 Glacier |
| **RPO** (pérdida de datos permitida) | < 5 minutos | Copias de RDS cada 5 min (AWS default) |
| **Ventana de mantenimiento** | Domingos 22:00–23:00 (V-44) | Tareas programadas de Procrastinate (no interrumpen cobranza) |
| **Rollback** | Automático en fallos de deploy | Blue/Green o Canary (futuro) · Hoy: manual si es necesario |

**Prueba anual**: Restaurar desde backup, verificar integridad.

---

### 4.5 Rendimiento y Escalabilidad

| Requisito | Declarado | Objetivo | Medida |
|---|---|---|---|
| **Latencia API** | *"Instantáneo"* (V-47) — **sin número** | < 200 ms (p99) | k6 local (CX-39) |
| **Capacidad de usuarios** | 30–40 cobradores simultáneos (Q3) | Soportar 100 sin degradación | Load test en staging |
| **Operaciones/día** | ~1.200 registros de pago (~3 por min pico) | 10x = 12.000/día sin lags | k6 online |
| **Throughput RDS** | ~0,04 escrituras/s (estimado, T12) | Soportar 0,1 escrituras/s | Monitoreo CloudWatch |

**Nota**: Sin staging (Q8 respuesta B), latencia real no se mide en preproducción. k6 local es aproximado.

---

### 4.6 Usabilidad y Accesibilidad

| Requisito | Implementación |
|---|---|
| **Cobrador poca tecnología** | UI simple, guía rápida al primer uso (V-50) · Máximo 3 toques por operación |
| **Idioma** | Español (BRL, Q7 respuesta A) · Sin i18n en v1 |
| **Accesibilidad** | WCAG 2.1 AA en web (Radix UI) · Mobile: botones grandes, contraste alto |
| **Teclado** | Navegación completa sin ratón (Radix UI + shadcn/ui) |

---

### 4.7 Seguridad

| Área | Requerimiento | Implementación |
|---|---|---|
| **Autenticación** | JWT propio + vinculación de dispositivo (T17) | Par de claves en Keystore/Keychain · PIN local (4 dígitos) no es clave |
| **Cifrado en tránsito** | TLS 1.3 obligatorio (T18, T31) | ALB solo 1.3 · Client genera certificados autofirmados en dev |
| **Cifrado en reposo** | Todo cifrado (T18, T30) | RDS con KMS · SQLite con SQLCipher · S3 con KMS |
| **Gestión de secretos** | AWS Secrets Manager (T20) | 3 secretos: BD password, JWT key, WhatsApp token · Rotación automática BD |
| **Acceso a producción** | Sin acceso humano permanente (T33) | IAM roles solo · CloudTrail + alarmas (CX-31) |
| **Validación de entrada** | Pydantic v2 (T8) + Zod (T8) | Frontera del API (contraataques N+1, injection) |
| **Tokens de cliente** | httpOnly cookies, nunca localStorage (T17) | SameSite + Secure + HttpOnly |
| **Fotos de identidad** | S3 privado + URLs prefirmadas (T11) | 5–15 min expiración · Hash + referencia en BD · Cacheadas en SQLite local |

---

### 4.8 Conformidad Legal y Normativa

| Norma | Requerimiento | Estado |
|---|---|---|
| **LGPD** (Brasil) | Cifrado + consentimiento + derecho del olvido + DPO | ✅ Parcialmente cubierto por diseño (fotos en S3, referencia en BD) · DPIA → v1.1 (Q9 respuesta C) |
| **ISO 27001** | Alineado (no certificado, Q1 respuesta "alineado") | ✅ Controles compensatorios (T33) · Matriz de A.5.3 (segregación) → solo 1 dev |
| **Datos personales** | Base legal para tratamiento de fotos | ⚠️ Pendiente consulta legal (CX-11) — cliente dice "es alegal" |
| **Cumplimiento LGPD** | Formación requerida antes de escribir código | 🔴 **REQUISITO PREVIO**: Dev debe completar certificación LGPD + ISO 27001 antes de Inception → Construction |

---

## 5. Restricciones Técnicas (Vinculantes)

### 5.1 Stack Tecnológico

| Capa | Tecnología | Rationale |
|---|---|---|
| **Backend** | Python ≥3.14 · FastAPI · SQLAlchemy 2.0 · Pydantic v2 | Dominio dev · async nativo · OpenAPI automático |
| **BD** | PostgreSQL ≥17 · RLS · JSONB · Procrastinate | ACID · aislamiento tenant · cola en Postgres (no Redis) |
| **Web** | React 19 · Vite · TanStack Query · Tailwind + shadcn/ui | SPA estática (S3 + CloudFront) · tipos desde OpenAPI |
| **Móvil** | React Native · Expo · SQLite cifrada (op-sqlite) | Cross-platform · offline-first · SDK Expo rules (T31) |
| **Infraestructura** | AWS sa-east-1 · ECS Fargate · RDS · S3 · ALB | Region bloqueada LGPD · no Lambda (cold starts) · no EKS (complejidad) |
| **IaC** | Terraform | Versión del stack, automatización drift, CI/CD |
| **CI/CD** | GitHub Actions · 2 puertas (rápida + lenta) | Lint + unit · Integration + contract · E2E + DAST contra local stack |

### 5.2 Prohibiciones Explícitas (T10, T7)

| Prohibición | Razón | Alternativa |
|---|---|---|
| `float` para dinero | 0.1 + 0.2 ≠ 0.3 → descuadres | `Decimal` + `NUMERIC(18,2)` |
| `BackgroundTasks` FastAPI | Se pierde al reciclar contenedor | Procrastinate (cola en Postgres) |
| `requests` (sync) | Bloquea event loop en async | `httpx.AsyncClient` reutilizado |
| Filtrado tenant en Python | Ilusión de seguridad | RLS + `SET LOCAL app.tenant_id` |
| `python-jose` | Sin mantenimiento, CVEs | `PyJWT` |
| AsyncStorage para tokens | Archivos en claro | `expo-secure-store` |
| Redis | Doble escritura (BD + Redis) | Procrastinate (transacción única) |
| Redux para estado de servidor | Duplica TanStack Query | TanStack Query + useState/context |

### 5.3 Reglas de Versionamiento y Distribución

| Decisión | Implementación |
|---|---|
| **Monorepo** (T16) | `backend/` · `web/` · `mobile/` · `infra/` · etiquetas namespace (`mobile-v1.4.2`) |
| **Versionamiento** | Independiente por componente · gitops por etiqueta |
| **IOS / Android** | Play Store + App Store (C-70 BYOD negado — empresa asigna dispositivos) |
| **Mínima SO** | Android 10+ / iOS 13+ (T31) → TLS 1.3 obligatorio |
| **Prebuild Expo** | `ios/` y `android/` en `.gitignore` · regenerados con `expo prebuild` (T31 regla 1) |
| **Librerías nativas** | Solo SDK Expo o config plugins oficiales (T31 regla 2) · Afecta: QR, GPS, cámara, push, SQLite cifrada |

---

## 6. Decisiones Finales del Cliente

### Confirmaciones de Q1–Q12

| Pregunta | Respuesta | Implicación |
|---|---|---|
| **Q1: Nombre** | ROYEXA | Nombre formal para branding, tiendas, documentación |
| **Q2: Precios** | Plan Básico: $35 BRL · Plan Profesional: $55 BRL (incl. WhatsApp) | Presupuesto cubierto por operativo de $555/mes |
| **Q3: Métricas** | Descuadres (P1) · Fraude interno (P2) · Latencia (P3) | Sistema registra descuadres desde día 1 |
| **Q4: Presupuesto** | $555/mes aprobado por escrito | ✅ Suficiente: ~$43 AWS + $212 WhatsApp + $100 otros + $200 margen |
| **Q5: IA en v1** | No — v2+ solo | Scoring 100% manual en v1 · Ahorra complejidad |
| **Q6: Permisos** | Matriz completa (B) | Feature completo en v1 · Riesgo: 1 mes de trabajo · Dev ha confirmado |
| **Q7: Moneda/Idioma** | BRL + Español fijo (A) | Sin i18n en v1 · Simplifica · Expansión → v2 |
| **Q8: Testing** | Staging $40–50/mes agregado (B) | Presupuesto sube a ~$595–605/mes · Aprobado |
| **Q9: DPIA/LGPD** | Post-launch (v1.1 / v2) | Desarrollo puede comenzar · Consulta legal antes de primo cliente |
| **Q10: Release** | On-demand, 24/7 (A) | Sin ventana fija · Despliegue desde CI solo (T33) |
| **Q11: Antifraude** | Ambos controles no-negociables | QR + WhatsApp extracto = núcleo del MVP |
| **Q12: Offline** | Sí, sync cuando hay señal | Requisito fundamental · Pruebas obligatorias (T22 E2E #1) |

---

## 7. Métricas de Éxito

| # | Métrica | Baseline | Target | Cadencia | Propietario |
|---|---|---|---|---|---|
| **1** | Descuadres de caja / mes | Desconocida (registrar día 1) | 50% reducción en 3 meses | Diaria | Admin tenant |
| **2** | Fraude interno detectado / mes | Desconocida | < 2 casos/mes en 6 meses | Mensual | Cliente |
| **3** | Latencia cierre de caja (min) | Desconocida | < 10 minutos promedio | Diaria | Sistema |

---

## 8. Dependencias Externas (Bloqueantes)

| Dependencia | Estado | Bloqueante | Mitigación |
|---|---|---|---|
| **API de WhatsApp Business** (CX-16) | ❌ No iniciado | ✅ SÍ — los dos controles desaparecen sin ella | Iniciar trámite con Meta **YA** antes de escribir código |
| **Licencia App Store / Play Store** (CX-18) | ⏳ Pendiente evaluación | ⚠️ CRÍTICA — distribución bloqueada | Google Play restringe apps de préstamos · Plan B: distribución gestionada |
| **Base legal LGPD** (OQ-N-22) | ⏳ Pendiente consulta legal | ✅ SÍ — fotos de identidad sin base = riesgo legal | Abogado especializado LGPD antes de primer cliente |
| **Presupuesto escrito** (OQ-B-9) | ✅ Confirmado $555/mes | ⚠️ Operativo — si presupuesto se corta, WhatsApp se va | Cliente debe formalizar por escrito cada mes |
| **Capacidad del equipo** (CX-27) | ⏳ Junior developer, 1 persona | ✅ CRÍTICA — alcance no cabe en 1 dev | Reducir alcance O ampliar equipo antes de Inception → Construction |

---

## 9. Riesgos y Mitigaciones

| Riesgo | Impacto | Probabilidad | Mitigación |
|---|---|---|---|
| **Sin API WhatsApp** (CX-16) | Producto pierde razón de ser | Alta (~3 meses de lag típico) | Iniciar trámite 48 horas · Documento formal de requerimientos para Meta |
| **Alcance > 1 desarrollador** (CX-27) | Retraso indefinido o entrega incompleta | Alta | Reducir scope (ej: diferir matriz de permisos a v1.1) O contratar 2do dev |
| **Rechazo App Store** (OQ-N-48) | Distribución móvil bloqueada | Media (Google Play restricción conocida) | Distribucion gestionada · Test en sandbox antes de submit oficial |
| **Sin métrica de éxito** (antes Q3) | Imposible decidir si proyecto salió bien en 6 meses | Resuelto | Implementar dashboard de descuadres en Requirements → Construction |
| **Conflicto de permisos** (Q6 matriz) | Módulo más grande de Inception | Media | Design iterativo · start con 3–5 permisos core · expandir en v1.1 |
| **Testing sin staging** (CX-39) | E2E/DAST no miden producción | Media | Mitigado: k6/ZAP en local detectan regresiones algorítmicas |
| **LGPD sin consulta legal** | Riesgo legal de no-conformidad | Alta | Abogado certificado LGPD ANTES de primer cliente · DPIA formal |

---

## 10. Próximas Fases de Inception

✅ **Requirements Analysis**: COMPLETO

**Procedimiento automático a**:
1. ✅ **User Stories** — Crear historias por rol (Cobrador, Admin, Socio, Cliente)
2. ✅ **Workflow Planning** — Flujos de las 6 fases de Inception
3. ✅ **Application Design** — Arquitectura de componentes y módulos
4. ✅ **Units Generation** — Descomposición en work units para Construction

---

## Changelog

| Fecha | Evento | Autor |
|---|---|---|
| 2026-08-16 | Generado desde requirement-verification-questions.md (12 P0s) | AI-DLC Inception |
| 2026-08-07 | Vision Document finalizado (D-01 a D-05) | Discovery |
| 2026-08-01 | Technical Environment finalizado (T1–T33) | Tech Lead |
