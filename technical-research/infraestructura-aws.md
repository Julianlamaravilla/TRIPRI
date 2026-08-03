# Infraestructura — Viabilidad y costo real de AWS

> **Complemento al §5 de [recomendacion-tecnica.md](recomendacion-tecnica.md).** Dimensionado con datos reales de operación: **~30–40 usuarios** (≈30 gestores móviles + ≈8 admin/socios web) y **~1.200 clientes**.
> Fecha: 2026-07-28 · Precios verificados contra la **API pública de precios de AWS** (`pricing.us-east-1.amazonaws.com`), región **`sa-east-1` (São Paulo)**, on-demand, USD.

---

## 0. Respuesta corta

**¿Es viable AWS? Técnicamente sí, sin discusión — y por un margen enorme.** La carga real de este sistema es aproximadamente **1 % de lo que soporta el escalón más pequeño de cualquier servicio de AWS**. Nada aquí se acerca a un límite técnico.

**¿Es costoso? Depende enteramente de *cómo* se arme, no de AWS en sí.** El mismo sistema, en la misma región, cuesta entre **$59 y $475 al mes** según la arquitectura. La diferencia no la produce la carga: la producen tres o cuatro componentes de **costo fijo** que se contratan sin necesitarlos.

**Pero el hallazgo que importa es otro:** a esta escala, **la infraestructura no es su problema de costo. WhatsApp sí.** Con 1.200 clientes y cobro diario, la mensajería sola cuesta **~$212–350/mes** — más que cualquiera de los escenarios de infraestructura razonables. Optimizar de $140 a $59 ahorra $81; clasificar mal una plantilla de WhatsApp cuesta $1.900 al año.

| Escenario | USD/mes | Veredicto |
|---|---:|---|
| **D — AWS "por defecto"** (Aurora + 2 NAT + logs verbosos) | **~475** | El error clásico. Evitable por completo. |
| **C — AWS empresarial** (ECS Multi-AZ + NAT + WAF) | **~311** | Correcto, pero sobredimensionado hoy. |
| **A — AWS mínimo defendible** (ECS single-AZ, sin NAT) | **~141** | Viable. ~$117 con compromiso a 1 año. |
| **B — AWS Lightsail** (contenedor + PostgreSQL gestionado) | **~59** | ✅ **Recomendado para la Fase 1.** |
| **E — Fuera de AWS** (Fly.io GRU + Neon + R2) | **~35–110** | Más barato, pero pierde el argumento "estamos en AWS". |
| — *WhatsApp Business API (referencia)* | *~212–350* | *Mayor que todos los anteriores.* |

### Total mensual, todo incluido

Infraestructura + WhatsApp + tiendas móviles + asistente de IA + observabilidad (desglose completo en **§8.5**):

| | USD/mes |
|---|---:|
| **Mínimo defendible** (Lightsail Small, Nova Pro, solo Android, WhatsApp optimizado) | **~$185** |
| **Recomendado, solo Android** (Lightsail Medium, `claude-sonnet-5`, Sentry Team) | **~$340** |
| ✅ **Recomendado + iOS / App Store** | **~$348** |
| **Todo contratado** (ECS+RDS, `claude-opus-5`, iOS, EAS Starter, WhatsApp completo) | **~$575** |

**Costo único año 0: $124** con iOS ($25 Google Play + $99 Apple Developer) — o **$25** si es solo Android.

**De los ~$348 con iPhone incluido, $212 (61 %) son WhatsApp y $10 (3 %) son las dos tiendas juntas.**

> 🔴 **Añadir iOS cuesta $8,25/mes — pero abre un riesgo que sí puede bloquear el lanzamiento.** La regla **3.2.2(ix)** de Apple prohíbe apps de préstamos con TAE > 36 % **o reembolso total en ≤ 60 días** — las modalidades diaria, semanal y quincenal caen de lleno. El programa Enterprise que evitaría la revisión **exige 100+ empleados y esta empresa no califica**, y las Custom Apps privadas **pasan por la misma revisión**. Detalle completo y las vías que sí funcionan en **§8.4**.

---

## 1. Dimensionamiento real de la carga

Antes de discutir precios hay que establecer qué tan grande es esto realmente. La respuesta es: **muy pequeño.**

### 1.1 Carga de escritura

| Métrica | Cálculo | Resultado |
|---|---|---|
| Cobros/día (peor caso: modalidad diaria, 100 % de la cartera) | 1.200 clientes × 1 cobro | **1.200/día** |
| Promedio sostenido en jornada de 8 h | 1.200 ÷ 8 h | **~0,04 escrituras/s** |
| Pico real: sincronización simultánea al cierre | 30 gestores × 40 comandos, en ~5 min | **~4 req/s** |
| Capacidad de 1 proceso Node con 0,5 vCPU sobre PostgreSQL | — | **cientos de req/s** |

**Margen: dos órdenes de magnitud.** El "pico" de este sistema es lo que un servidor ocioso hace sin notarlo. Y ese pico está *concentrado y es predecible* (18:00–19:00), lo que además significa que no hay ningún argumento para autoescalado.

### 1.2 Volumen de datos — año 1

| Tabla | Filas/año | Bytes/fila | Total |
|---|---:|---:|---:|
| `movimientos_caja` (300 días hábiles × 1.200) | 360.000 | ~600 | ~320 MB (con índices) |
| `visitas` / eventos de ruta | 360.000 | ~400 | ~150 MB |
| `cuotas` (3.600 préstamos × 30) | 108.000 | ~200 | ~25 MB |
| Auditoría, `outbox`, `pg-boss` (con retención) | — | — | ~200 MB |
| Clientes, config, tenants | 1.200 | — | despreciable |
| **Total año 1** | | | **< 1 GB** |
| **Proyección año 3** | | | **~3 GB** |

> **Consecuencia directa:** una instancia PostgreSQL de **2 GB de RAM mantiene el 100 % del conjunto de trabajo en memoria durante los primeros tres años.** Aprovisionar 50 GB de disco es 15× de holgura, y cuesta $11/mes. La base de datos de este sistema no es un problema de escala; es un problema de *corrección*.

### 1.3 Fotos y almacenamiento

| Concepto | Cálculo | Resultado |
|---|---|---|
| KYC: documento (2 caras) + vivienda | 1.200 × 3 × 250 KB | **~900 MB** |
| Firmas digitales | 1.200 × ~15 KB | ~18 MB |
| Crecimiento anual (renovaciones, nuevos, comprobantes) | — | ~+1–2 GB/año |
| **Aprovisionar** | | **50 GB** ($2,03/mes en S3 `sa-east-1`) |

### 1.4 Transferencia de datos de salida

| Concepto | Cálculo | GB/mes |
|---|---|---:|
| API JSON — sincronización móvil | 30 gestores × ~2 MB/día × 26 días | ~1,6 |
| Consola web (8 usuarios, tablas densas) | 8 × ~50 MB/día × 22 días | ~9 |
| Fotos, **si el móvil cachea localmente** | — | ~2 |
| Fotos, **si el móvil las re-descarga cada día** | 30 × 40 × 3 × 250 KB × 22 | ~20 |
| **Total realista** | | **15–35 GB/mes** |

### 1.5 Qué implica el **monolito modular** para el dimensionamiento

**Decisión confirmada: la arquitectura es un monolito modular** (§2.1 del documento base). Todos los escenarios de costo de este documento ya están calculados sobre esa premisa, y conviene ser explícito sobre por qué eso importa tanto:

| Consecuencia | Efecto en la factura |
|---|---|
| **Un solo contenedor desplegable** contiene los 11 módulos | Se paga **una** unidad de cómputo, no N |
| Sin malla de servicios, API Gateway interno, PrivateLink ni descubrimiento de servicios | **$0** de red interna |
| Los 9 pasos del registro de pago son `BEGIN … COMMIT` sobre **una** base | **Una** instancia PostgreSQL, no 2–3 |
| `pg-boss` sobre el mismo Postgres (§4.9) | **$0** en Redis, SQS o EventBridge |
| Un despliegue = un rollback = un flujo de CI | **$0** en orquestación adicional |

**Cuánto vale esa decisión, en dinero:**

| Concepto (sobre el escenario ECS single-AZ) | Monolito modular | 6 microservicios |
|---|---:|---:|
| Tareas Fargate ARM 24/7 | 1 × 24,80 = **24,80** | 6 × 24,80 = 148,80 |
| Balanceo interno (ALB interno o Cloud Map) | 0,00 | ~27,00 |
| NAT Gateway (las subredes privadas se vuelven obligatorias) | 0,00 | 67,89 |
| Bases de datos | 1 × 50,37 = **50,37** | 2–3 × 50,37 = 101–151 |
| Redis / SQS para eventos entre servicios | 0,00 | ~15–40 |
| CloudWatch Logs (1 flujo vs 6) | 9,41 | ~30,00 |
| Resto (ALB público, S3, secretos, egreso) | ~56,00 | ~60,00 |
| **Total** | **~$141** | **~$390–465** |

**La decisión de arquitectura vale ~$300/mes a esta escala** — antes de contar las horas de operación que el §2.1 ya descarta por el equipo de una sola persona.

#### ⚠️ El ajuste que sí introduce el monolito modular: memoria

En un monolito, la API y el *worker* de trabajos comparten proceso y contenedor. Eso es correcto para la transaccionalidad (§3.3, patrón *outbox*), pero **elimina el aislamiento de radio de impacto**:

| Componente | RAM en reposo | Pico |
|---|---:|---:|
| NestJS (API + 11 módulos) | ~200 MB | ~300 MB |
| Worker `pg-boss` en el mismo proceso | ~50 MB | ~100 MB |
| **Puppeteer / Chromium** para PDF (§4.10) | 0 | **~400–500 MB** |
| ExcelJS sobre un reporte grande (§4.10) | 0 | ~150 MB |
| **Pico combinado** | | **~0,9–1,0 GB** |

Un contenedor de **1 GB queda exactamente en el límite**. Y si Chromium provoca un OOM, **se lleva la API de cobranza con él** — precisamente en la ventana de 18:00 en la que 30 gestores sincronizan el día.

> **Recomendación concreta: 2 GB, no 1 GB.** Lightsail Container **Medium** (1 vCPU / 2 GB, **$39,27/mes**) en lugar de Small ($14,75). Los $24,52 adicionales compran el margen para que generar un PDF no tumbe el registro de cobros.
>
> *Alternativa si se quiere conservar el Small:* mantener 1 GB y encolar los trabajos de Puppeteer/Excel con `concurrency: 1` en `pg-boss`, o moverlos a un segundo contenedor pequeño. Funciona, pero añade una pieza que operar — justo lo que el §5.1 evita.

---

## 2. 🔴 Corrección al documento base: `OQ-N-4` está mal planteada

El §5.2 de `recomendacion-tecnica.md` afirma que el egreso de fotos es *"el mayor costo recurrente probable"* y recomienda Cloudflare R2 principalmente para neutralizarlo.

**A esta escala, eso es falso, y por bastante margen.** Con los precios reales:

| | S3 `sa-east-1` | Cloudflare R2 | Diferencia |
|---|---:|---:|---:|
| Almacenamiento 50 GB | $2,03 | $0,75 | $1,28 |
| Egreso 35 GB (peor caso) | $5,25 | $0,00 | $5,25 |
| **Total** | **$7,28** | **$0,75** | **$6,53/mes** |

R2 sigue siendo la elección correcta — es más barato, y la ventaja crece si el negocio escala a 10.000 clientes. **Pero no es una decisión de $100/mes; es una de $6.** No debe consumir tiempo de diseño ni justificar añadir un proveedor si eso complica el despliegue.

> **Además:** poner **CloudFront delante de S3** elimina casi todo el egreso de todas formas — el *free tier* de CloudFront es de **1 TB/mes**, unas 30× el consumo proyectado. Es decir, dentro de AWS el egreso de fotos ya es prácticamente $0 sin necesidad de R2.

**El verdadero mayor costo recurrente es WhatsApp (§6), y en segundo lugar el piso fijo de la base de datos.** `OQ-N-4` debería reformularse hacia el presupuesto de mensajería.

---

## 3. Tres hallazgos que condicionan cualquier diseño en AWS

### 3.1 🔴 App Runner **no existe** en São Paulo

El §5.2 del documento base recomienda *"contenedor gestionado: Railway, Render, Fly.io o **AWS App Runner**"* y, en la fila inmediatamente anterior, exige **región Brasil (`sa-east-1`)** por LGPD.

**Esas dos recomendaciones son incompatibles.** App Runner está disponible en ~11 regiones (Virginia, Ohio, Oregón, Tokio, Singapur, Sídney, Bombay, Londres, París, Fráncfort…) y **São Paulo no está entre ellas**. Ninguno de los anuncios de expansión de AWS ha incluido Sudamérica.

**Consecuencia:** si la residencia de datos en Brasil se confirma como requisito (`OQ-N-25`), la opción "contenedor gestionado sin gestionar nada" dentro de AWS **no es App Runner**. Las alternativas reales son **Lightsail Containers** (§5.2) o **ECS Fargate** (§5.1, con el costo de VPC/ALB que eso implica).

> ⚠️ *Verificar antes de decidir* — la lista de regiones de App Runner puede haber cambiado. Es una consulta de 30 segundos en la consola de AWS, y bloquea la elección de cómputo.

### 3.2 🔴 Railway y Render **tampoco tienen región en Brasil**

El §5.3 recomienda como opción principal *"Supabase + Fly.io/**Railway** + Cloudflare R2"*.

- **Railway** despliega en cuatro regiones: US West, US East, Europe West, Asia Southeast. **No hay Sudamérica.**
- **Render** tiene Oregón, Ohio, Virginia, Fráncfort y Singapur. La región de São Paulo lleva años como *feature request* abierto. **No existe.**
- **Fly.io sí tiene `gru` (São Paulo)** — es la única de las tres que sobrevive al requisito.

**Consecuencia:** la recomendación del §5.3 debe recortarse a **Fly.io**, o aceptar que los datos salgan de Brasil.

### 3.3 🔴 Supabase con PITR cuesta **$125/mes**, no $25

El §5.5 declara PITR **no negociable** ("un respaldo que nunca se restauró no es un respaldo, es una suposición") y el §5.2 estima "$25–50" para PostgreSQL gestionado citando a Supabase.

Pero en Supabase, **PITR es un complemento de pago aparte**:

| Retención PITR | Costo adicional |
|---|---:|
| 7 días | **+$100/mes** |
| 14 días | +$200/mes |
| 28 días | +$400/mes |

Supabase Pro ($25) + PITR 7 días ($100) = **$125/mes**, y requiere además el add-on de cómputo *Small*. **Eso es más caro que RDS `db.t4g.small` Single-AZ en São Paulo ($50,37 con PITR incluido)**, y más del doble de Lightsail.

**Alternativa que sí funciona:** **Neon** está disponible en `sa-east-1` (São Paulo) y su restauración instantánea / historial de ramas cubre el requisito de PITR desde el plan Launch (~$19/mes). Es la opción PaaS honesta si se descarta AWS.

---

## 4. Precios reales de `sa-east-1` (verificados)

São Paulo es de las regiones más caras de AWS. **Cualquier estimación que encuentre en internet está calculada sobre `us-east-1` y subestima este proyecto en ~2×.**

| Recurso | `sa-east-1` | `us-east-1` (ref.) | Sobreprecio |
|---|---:|---:|---:|
| RDS PostgreSQL `db.t4g.small` Single-AZ | **$0,0690/h** = $50,37/mes | $0,032/h | **2,2×** |
| RDS PostgreSQL `db.t4g.small` Multi-AZ | **$0,1370/h** = $100,01/mes | — | — |
| RDS PostgreSQL `db.t4g.medium` Single-AZ | **$0,1370/h** = $100,01/mes | — | — |
| RDS PostgreSQL `db.m7g.large` Single-AZ (2 vCPU / 8 GB) | **$0,2210/h** = $161,33/mes | — | — |
| RDS almacenamiento gp3 | **$0,219/GB-mes** | $0,115 | 1,9× |
| RDS gp3 Multi-AZ | **$0,438/GB-mes** | — | — |
| RDS backup más allá del asignado | **$0,095/GB-mes** | — | — |
| Aurora Serverless v2 | **$0,25/ACU-hora** | $0,12 | 2,1× |
| Fargate x86 | **$0,0696/vCPU-h** + $0,0076/GB-h | $0,04048 | 1,7× |
| **Fargate ARM (Graviton)** | **$0,0557/vCPU-h** + $0,00612/GB-h | — | **−20 % vs x86** |
| Application Load Balancer | **$0,034/h** = $24,82/mes + $0,011/LCU-h | $0,0225/h | 1,5× |
| **NAT Gateway** | **$0,093/h** = **$67,89/mes** + $0,093/GB | $0,045/h | **2,1×** |
| S3 Standard | **$0,0405/GB-mes** | $0,023 | 1,8× |
| S3 PUT / GET (por millón) | $7,00 / $0,56 | — | — |
| Egreso a internet (primeros 10 TB) | **$0,150/GB** | $0,090 | 1,7× |
| **CloudWatch Logs (ingesta)** | **$0,90/GB** | $0,50 | 1,8× |
| CloudWatch Logs (almacenamiento) | $0,0408/GB-mes | — | — |
| Secrets Manager | $0,40/secreto-mes | igual | 1,0× |
| IPv4 pública | $0,005/h = $3,65/mes c/u | igual | 1,0× |
| **Lightsail Container Small** (0,5 vCPU / 1 GB, **LB + TLS incluidos**) | **$0,0202/h** = $14,75/mes | igual | 1,0× |
| **Lightsail Container Medium** (1 vCPU / 2 GB) | $0,0538/h = $39,27/mes | igual | 1,0× |
| **Lightsail PostgreSQL 2 GB** (1 vCPU) | **$0,0403/h** = $29,42/mes | igual | 1,0× |
| Lightsail PostgreSQL 2 GB **HA** | $0,0806/h = $58,84/mes | igual | 1,0× |
| Lightsail PostgreSQL 4 GB (2 vCPU) | $0,0806/h = $58,84/mes | igual | 1,0× |

> **Dos observaciones que valen dinero:**
> 1. **Lightsail tiene precio plano en todas las regiones.** Es el único servicio de AWS que no cobra el sobreprecio de São Paulo — lo que lo hace desproporcionadamente atractivo aquí.
> 2. **`db.m7g.large` (8 GB, no ráfaga) cuesta $161/mes, menos que `db.t4g.large` ($200/mes).** Si algún día hace falta escalar, saltar de `t4g` a `m7g` es más barato *y* elimina el problema de créditos de CPU de las instancias ráfaga.

---

## 5. Los cinco escenarios, con números

### 5.1 Escenario A — AWS ECS Fargate, mínimo defendible

Single-AZ, tareas Fargate en subred pública con *security groups* estrictos, **sin NAT Gateway**, CloudFront delante para los estáticos y las fotos.

| Componente | Cálculo | USD/mes |
|---|---|---:|
| Fargate **ARM** 0,5 vCPU / 1 GB, 1 tarea 24/7 | (0,5 × 0,0557 + 1 × 0,00612) × 730 | 24,80 |
| Application Load Balancer | 24,82 + ~1,60 LCU | 26,42 |
| RDS `db.t4g.small` Single-AZ + PITR | 0,069 × 730 | 50,37 |
| Almacenamiento gp3 50 GB | 50 × 0,219 | 10,95 |
| Backup PITR excedente ~20 GB | 20 × 0,095 | 1,90 |
| S3 50 GB + peticiones | 2,03 + 0,50 | 2,53 |
| CloudFront (dentro del *free tier* de 1 TB) | — | 0,00 |
| Egreso directo desde ALB ~25 GB | 25 × 0,15 | 3,75 |
| CloudWatch Logs 10 GB ingesta + retención | 9,00 + 0,41 | 9,41 |
| Secrets Manager × 5 | 5 × 0,40 | 2,00 |
| ECR 5 GB | 5 × 0,10 | 0,50 |
| IPv4 pública × 2 | 2 × 3,65 | 7,30 |
| Route 53 (zona + consultas) | — | 1,00 |
| **Total** | | **≈ $141** |

**Con compromiso a 1 año** (Reserved Instance sin pago inicial en RDS, ~−35 %; Compute Savings Plan en Fargate, ~−20 %): **≈ $117/mes**.

### 5.2 Escenario B — AWS Lightsail ✅ **recomendado para Fase 1**

Lightsail Containers incluye **balanceador y certificado TLS en el precio** y no requiere VPC, subredes, IAM fino, *target groups* ni NAT. Está disponible en `sa-east-1`.

| Componente | Cálculo | USD/mes |
|---|---|---:|
| Lightsail Container **Small** (0,5 vCPU / 1 GB) — incluye LB + TLS + endpoint HTTPS | 0,0202 × 730 | 14,75 |
| Lightsail **PostgreSQL 2 GB** gestionado, con backups automáticos | 0,0403 × 730 | 29,42 |
| S3 50 GB para fotos (o bucket de Lightsail) | — | 2,53 |
| CloudWatch Logs 10 GB (o Better Stack en plan gratuito) | — | 9,41 |
| Route 53 + Secrets | — | 3,00 |
| **Total** | | **≈ $59** |
| *Variante con base de datos en alta disponibilidad* | +29,42 | *≈ $89* |

**Lo que gana:** cuenta AWS, factura AWS, región São Paulo, contrato AWS — es decir, **conserva íntegro el argumento comercial de "estamos en AWS"** — sin pagar el ALB ($26), el NAT ($68), ni las 2–4 semanas de configuración de VPC/IAM/ECS que un desarrollador con 16 h/semana no tiene.

**Lo que cuesta:** Lightsail es deliberadamente limitado. No hay integración nativa con VPC más allá del *peering*, el control de IAM es grueso, las versiones de PostgreSQL van por detrás de RDS, y no hay réplicas de lectura más allá de una. **A esta escala, ninguna de esas limitaciones se toca.**

**La salida está garantizada:** migrar Lightsail → ECS + RDS es *un `Dockerfile` que ya existe* + un `pg_dump`/`pg_restore`. No es una decisión difícil de revertir — que es exactamente el criterio del §2.4 del documento base.

> 🔒 **Un punto a verificar antes de comprometerse.** El §5.5 declara PITR no negociable. Las bases gestionadas de Lightsail ofrecen backups automáticos con restauración a un punto en el tiempo dentro de la ventana de retención (7 días) en los planes Standard y HA — **pero confirme esto en la consola antes de decidir.** Si resulta que solo hay *snapshots* diarios, Lightsail queda descartado por RPO y el escenario A pasa a ser el mínimo.

### 5.3 Escenario C — AWS "como lo pediría un cliente empresarial"

Multi-AZ, tareas en subred privada con NAT, WAF, dos tareas para alta disponibilidad.

| Componente | Cálculo | USD/mes |
|---|---|---:|
| Fargate ARM × 2 tareas | 2 × 24,80 | 49,60 |
| Application Load Balancer | — | 26,42 |
| RDS `db.t4g.small` **Multi-AZ** | 0,137 × 730 | 100,01 |
| gp3 Multi-AZ 50 GB | 50 × 0,438 | 21,90 |
| Backups | — | 1,90 |
| **NAT Gateway × 1** + 50 GB procesados | 67,89 + 4,65 | **72,54** |
| WAF (Web ACL + 3 reglas + peticiones) | — | 9,00 |
| S3 + CloudFront + egreso | — | 6,30 |
| CloudWatch Logs 20 GB | — | 18,81 |
| Secrets, ECR, Route 53, KMS | — | 5,00 |
| **Total** | | **≈ $311** |
| *Con 2 NAT Gateway (HA real por AZ)* | +67,89 | *≈ $379* |

**Note el desglose:** el **NAT Gateway ($73) y el ALB ($26) son un tercio del total** y no procesan un solo byte de lógica de negocio. El NAT existe únicamente para que tareas en subred privada puedan alcanzar internet — y es **completamente evitable** con VPC Endpoints para S3/ECR/Secrets, o poniendo las tareas en subred pública con *security groups* cerrados (que es lo que hace el escenario A).

### 5.4 Escenario D — el error clásico

Lo que ocurre si se sigue un tutorial genérico de "arquitectura serverless en AWS":

| Componente | USD/mes |
|---|---:|
| Aurora Serverless v2, 1 ACU promedio (mínimo 0,5 ACU = $91 de piso) | 182,50 |
| 2 × NAT Gateway | 145,00 |
| ALB + Fargate × 2 + WAF | 85,00 |
| CloudWatch Logs 50 GB (nivel `debug` en producción) | 47,00 |
| Resto | 15,00 |
| **Total** | **≈ $475** |
| *Con una réplica lectora de Aurora* | *≈ $650+* |

**Aurora Serverless v2 es la trampa más cara de esta lista.** A $0,25/ACU-hora en São Paulo, el mínimo de 0,5 ACU corriendo 24/7 son **$91/mes de piso** — casi el doble que una `db.t4g.small` que sobra para 1.200 clientes. El auto-pausado a 0 ACU no ayuda: una API que atiende gestores en calle nunca se pausa. **Aurora está diseñado para cargas que este sistema no tiene y no tendrá.**

### 5.5 Escenario E — fuera de AWS, respetando Brasil

| Componente | USD/mes |
|---|---:|
| Fly.io máquina en `gru` (São Paulo), 1 vCPU / 2 GB | ~15 |
| Neon PostgreSQL en `sa-east-1` (Launch $19 / Scale $69) | 19–69 |
| Cloudflare R2 50 GB, egreso $0 | ~1 |
| Cloudflare DNS + CDN | 0 |
| Sentry (gratuito → Team) | 0–26 |
| **Total** | **≈ $35–110** |

Es la opción más barata y de arranque más rápido. Lo que pierde es el argumento contractual ante un cliente empresarial que exige "nuestro proveedor está en AWS", y añade tres proveedores con tres facturas y tres soportes distintos.

---

## 6. 🔴 El costo que sí debe preocuparle: WhatsApp a 1.200 clientes

El §5.6 del documento base calculó la mensajería sobre **500 préstamos activos**. Con **1.200 clientes**, la cifra se multiplica por 2,4:

| Concepto | Cálculo | USD/mes |
|---|---|---:|
| Confirmación de pago (plantilla de **utilidad**) | 1.200 × 26 días × $0,0068 | **212** |
| Recordatorios T‑1 / T+1 / T+3 / T+7 (estimado +40 %) | — | **~85** |
| Avisos de mora y comprobantes | — | **~50** |
| **Total mensajería** | | **~$350/mes** |
| ⚠️ **Si una plantilla se clasifica como *marketing*** ($0,0625 vs $0,0068) | ×9,2 | **hasta $3.200/mes** |

**Comparación directa:**

| | USD/mes | % del total |
|---|---:|---:|
| Infraestructura (escenario B recomendado) | 59 | 13 % |
| Asistente de IA (§7) | ~20 | 4 % |
| **WhatsApp** | **350** | **77 %** |
| Sentry / observabilidad | 26 | 6 % |
| **Total operativo** | **~455** | |

> **Esto reordena las prioridades del proyecto.** Discutir si usar RDS o Lightsail mueve $80/mes. **Decidir qué notificaciones son automáticas y cuáles opcionales mueve $200–300/mes**, y clasificar bien las plantillas evita una factura 9× mayor. `OQ-N-40` (presupuesto) no es P0 por la infraestructura — es P0 por WhatsApp.
>
> **Palancas concretas, en orden de impacto:**
> 1. **Clasificar todas las plantillas transaccionales como *utilidad*, nunca *marketing*.** Diferencia: $212 vs $1.950/mes.
> 2. **Confirmación de pago opcional por cliente** (opt-in). Si solo el 40 % la quiere, son $85 en vez de $212.
> 3. **Agrupar recordatorios**: un mensaje T‑1 en lugar de la cadena T‑1/T+1/T+3/T+7 recorta ~$60.
> 4. **Bandera de funcionalidad por tenant** (§3.12) — ya está en el diseño. Úsela como control financiero desde el día 1, no como añadido.

---

## 7. Asistente de IA — `claude-sonnet-5` vs Amazon Nova Pro

### 7.1 Carga supuesta (idéntica para ambos modelos)

| Supuesto | Valor |
|---|---|
| Consultas/mes (40 usuarios, ~25/día hábil) | ~650 |
| Prompt de sistema + catálogo de herramientas (cacheado) | ~8.000 tokens |
| Entrada fresca por consulta | ~1.000 tokens |
| Salida por consulta | ~800 tokens |
| Reescrituras de caché (TTL 5 min, uso a ráfagas) | ~150/mes |

### 7.2 Precios por millón de tokens

| Modelo | Plataforma | Entrada | Salida | Lectura de caché |
|---|---|---:|---:|---:|
| `claude-sonnet-5` | Anthropic API | $3,00 | $15,00 | $0,30 |
| `claude-sonnet-5` *(precio introductorio hasta 2026‑08‑31)* | Anthropic API | $2,00 | $10,00 | $0,20 |
| `claude-opus-5` | Anthropic API | $5,00 | $25,00 | $0,50 |
| **Amazon Nova Pro** | Bedrock `us-east-1` | **$0,80** | **$3,20** | **$0,20** |
| Amazon Nova 2.0 Pro | Bedrock `us-east-1` | $1,38 | $11,00 | — |
| Amazon Nova Lite | Bedrock `us-east-1` | $0,06 | $0,24 | — |

### 7.3 Costo mensual resultante

| Modelo | Lect. caché | Entrada | Salida | Escr. caché | **Total/mes** |
|---|---:|---:|---:|---:|---:|
| **Amazon Nova Pro** | 1,04 | 0,52 | 1,66 | 0,96 | **$4,18** |
| `claude-sonnet-5` *(intro)* | 1,04 | 1,30 | 5,20 | 3,00 | **$10,54** |
| `claude-sonnet-5` *(precio regular)* | 1,56 | 1,95 | 7,80 | 4,50 | **$15,81** |
| `claude-opus-5` | 2,60 | 3,25 | 13,00 | 7,50 | **$26,35** |

**La diferencia entre Nova Pro y Sonnet 5 es de $6 a $12 al mes.** A 40 usuarios, la elección de modelo mueve menos dinero que el plan de Sentry, y **~3 % de lo que mueve WhatsApp.**

### 7.4 🔴 El hallazgo que decide la comparación

**Amazon Nova no está disponible en Bedrock São Paulo.** El catálogo de Bedrock en `sa-east-1` contiene modelos de peso abierto y de terceros — Mistral, Qwen, DeepSeek, GLM, Gemma, Nemotron, gpt-oss, Kimi, MiniMax, Titan Image — pero **ni un solo modelo Nova, ni un solo modelo Claude.** Ambas familias sí están en `us-east-1`.

Esto **anula el único argumento estructural a favor de Nova Pro.** La razón para preferirlo sobre la API de Anthropic sería que, al estar "dentro de AWS", no rompe la residencia de datos en Brasil. **No es cierto:** usar Nova Pro desde São Paulo exige inferencia entre regiones hacia Estados Unidos — exactamente la misma salida de datos del país que el §4.8 marca con 🔒 (`OQ-T-15`, `OQ-N-25`) para la API de Anthropic.

| | API de Anthropic | Nova Pro vía Bedrock |
|---|---|---|
| ¿Los datos salen de Brasil? | **Sí** | **Sí** (inferencia entre regiones a `us-east-1`) |
| ¿Disponible en `sa-east-1`? | N/A (SaaS externo) | **No** |
| Costo mensual a esta escala | $10,54–15,81 | $4,18 |
| Factura | Proveedor aparte | Consolidada en AWS |

**Con la residencia de datos igualada, la elección deja de ser de cumplimiento y pasa a ser de calidad por $12/mes.** Y ahí importa un detalle del diseño: el §4.8 no usa el modelo para generar texto libre, sino para **llamar herramientas acotadas de solo lectura** (`consultarRecaudoDelDia`, `listarClientesEnMora`, …). La fiabilidad del *tool calling* y de las salidas estructuradas es el requisito dominante, no el precio del token.

> **Recomendación: `claude-sonnet-5`.** El delta de $12/mes no justifica asumir riesgo en el mecanismo del que depende todo el módulo. Si el presupuesto de `OQ-N-40` resulta ser muy ajustado, la palanca correcta **no es cambiar de modelo por $12 — es recortar notificaciones de WhatsApp por $200** (§6).
>
> **Nova Pro se vuelve defendible en dos escenarios:** (a) si el cliente exige factura única de AWS por política de compras, o (b) si `OQ-N-25` se resuelve como *"los datos no pueden salir del país"*, en cuyo caso **ambas opciones quedan descartadas** y el asistente pasa a un modelo de peso abierto en Bedrock `sa-east-1` (Qwen, Mistral, GLM) — con una caída de calidad que hay que validar antes de comprometerse.

### 7.5 Conclusión sobre el alcance

El §4.8 recomienda mover el asistente a Fase 2. **Esa recomendación sigue siendo correcta — pero por alcance y tiempo de desarrollo, no por costo.** A 40 usuarios el asistente cuesta entre $4 y $16 al mes. Si se recorta, que sea porque son 2 semanas de las 18–24 disponibles, no porque la factura duela.

---

## 8. Recomendación

### 8.1 Decisión principal: **Fase 1 en AWS Lightsail (`sa-east-1`)** — ~$59/mes

**Por qué, en una línea:** conserva íntegro el argumento comercial de estar en AWS y la residencia de datos en Brasil, a un tercio del costo de ECS y **sin consumir las 2–4 semanas de configuración de VPC/IAM/ALB que el presupuesto de 16 h/semana no puede pagar.**

El razonamiento que lo ordena todo es el mismo del §5.1 del documento base: *"un desarrollador con 16 h/semana no puede ser también administrador de sistemas"*. Ese criterio, aplicado con precios reales, no lleva a ECS + RDS + VPC — lleva a Lightsail.

**Y la puerta de salida está abierta:** migrar a ECS + RDS es un redespliegue de contenedor más un `pg_dump`/`pg_restore`. Se hace cuando un cliente lo exija por contrato, cuando la carga lo justifique, o en la Fase 2 junto con Terraform. **No antes.**

### 8.2 Alternativas evaluadas

| Opción | Veredicto | Por qué |
|---|---|---|
| **Lightsail (`sa-east-1`)** | ✅ **Recomendada** | ~$59/mes, LB y TLS incluidos, sin VPC/IAM/NAT, precio plano por región, migración de salida trivial |
| **ECS Fargate single-AZ sin NAT** | ⚠️ Fase 2 | ~$141 ($117 con compromiso). Correcta, más flexible, pero cuesta semanas de configuración que hoy no sobran |
| **Fly.io `gru` + Neon** | ⚠️ Alternativa seria | Más barata ($35–110) e igual de rápida de montar. Se elige **solo si estar en AWS no aporta valor comercial** |
| **ECS Multi-AZ + NAT + WAF** | ❌ Hoy no | ~$311–379. Correcta para el año 3 o para un cliente que la exija por contrato. Hoy es pagar HA para 0,04 req/s |
| **Aurora Serverless v2** | ❌ Descartada | $91/mes de piso, ~$182 realista. Diseñada para una elasticidad que este sistema no tiene |
| **Supabase + PITR** | ❌ Descartada por costo | $125/mes — más caro que RDS Single-AZ y más del doble que Lightsail |
| **Railway / Render** | ❌ Descartadas | **Sin región en Sudamérica.** Incompatibles con el requisito de residencia de datos |
| **AWS App Runner** | ❌ No disponible | **No existe en `sa-east-1`** |

### 8.3 Reglas de costo, sin importar el escenario

1. **Nunca contrate un NAT Gateway** hasta que algo lo exija de verdad. Son $68/mes por permitir salida a internet desde subred privada — resoluble con VPC Endpoints o subred pública + *security groups*.
2. **Use Fargate ARM (Graviton), no x86.** Mismo rendimiento a esta carga, **20 % menos**, cambiando una línea del `Dockerfile`.
3. **Ponga CloudFront delante de todo lo estático.** El *free tier* de 1 TB/mes es ~30× su consumo: el egreso se vuelve $0.
4. **Fije retención de CloudWatch Logs en 7–14 días y no registre en `debug` en producción.** La ingesta cuesta **$0,90/GB** en São Paulo. Un NestJS locuaz genera 30 GB/mes sin esfuerzo = $27, más que la base de datos de Lightsail.
5. **Configure un AWS Budget con alerta al 80 %** el mismo día que cree la cuenta. Cinco minutos que evitan la factura sorpresa.
6. **Aproveche el *free tier* de cuenta nueva.** Los créditos iniciales de AWS cubren buena parte de los primeros meses — pero **no diseñe sobre ellos**: expiran, y lo que quede es el costo real.
7. **Espere a la Fase 2 para los compromisos a 1 año** (Reserved Instances / Savings Plans). Ahorran ~30 %, pero congelan una decisión de arquitectura que todavía puede cambiar.

### 8.4 Distribución móvil — costo de las tiendas

| Concepto | Costo | Mensualizado |
|---|---:|---:|
| **Google Play Console** — registro, **pago único**, sin cuota anual | $25 una vez | **$2,08** (año 1) · $0 después |
| **Apple Developer Program** — $99/año, cubre App Store + TestFlight | $99/año | **$8,25** |
| *Apple Developer Enterprise Program* — solo distribución interna, **no** App Store | *$299/año* | *$24,92* |
| **Expo EAS Build** — plan gratuito: 15 builds Android + 15 iOS/mes | $0 | **$0** |
| *Expo EAS Starter* — si 15 builds/mes se quedan cortos en semanas de release | *$19/mes* | *$19,00* |
| *Expo EAS Production* | *$199/mes* | *$199,00* |
| Firebase Cloud Messaging (push, §5.2) | gratis | **$0** |

#### 💡 La palanca: **¿hace falta iOS?**

El §N3 del documento base separa con claridad los dos clientes: **consola web** para admin/socios, **app móvil de campo** para gestores. La app móvil **no la usa nadie más que los gestores**, y `OQ-N-31` plantea que trabajan con **gama baja** — es decir, Android.

**Si la app es solo Android:**
- Se ahorran **$99/año** de Apple Developer Program.
- Se puede compilar con `eas build --local` o Gradle en CI **sin costo**, porque no se necesita un Mac ni la cola de builds de iOS.
- Desaparece la revisión de la App Store — y con ella **la mitad del riesgo regulatorio del §5.7**, que es el `OQ-N-34` marcado como P0.

**Costo de distribución móvil, según el camino:**

| Camino | Único | Recurrente/mes |
|---|---:|---:|
| **Solo Android, builds locales** ✅ | **$25** | **$0** |
| Solo Android + EAS Starter | $25 | $19,00 |
| Android + iOS, EAS gratuito | $25 | $8,25 |
| Android + iOS + EAS Starter | $25 | $27,25 |
| Distribución interna iOS (Enterprise, evita revisión) | $25 | $24,92 |

> 🔒 **`OQ-N-31` deja de ser una pregunta menor.** Confirmar que los gestores usan exclusivamente Android no ahorra mucho dinero ($99/año), pero **elimina un proceso de revisión de tienda para una app de préstamos con acceso a fotos y ubicación precisa** — el riesgo que el §5.7 identifica como capaz de bloquear el lanzamiento entero. Es la respuesta más barata de conseguir y la de mayor impacto.

#### 🍎 iOS / App Store — desglose completo

**El costo directo de tener la app en iPhone es $99/año ($8,25/mes). Ese número es el menor de los problemas.**

| Concepto | Costo | Nota |
|---|---:|---|
| **Apple Developer Program** | **$99/año = $8,25/mes** | Obligatorio para **cualquier** vía de distribución iOS, incluida la privada |
| Apple Business Manager | $0 | Necesario si se distribuye como Custom App |
| **Expo EAS Build — plan gratuito** | **$0** | 15 builds iOS/mes; suficiente salvo semanas de release |
| Expo EAS Build — Starter | $19/mes | Si 15 builds/mes se quedan cortos |
| Mac mini (alternativa a EAS: Xcode y builds locales) | ~$599 único | Solo si se prefiere no depender de EAS. **iOS no se puede compilar sin macOS** |
| TestFlight | $0 | Incluido con el ADP |
| **Total recurrente iOS** | **$8,25/mes** | **$27,25/mes** con EAS Starter |

##### 🔴 Los tres bloqueos que el §5.7 no contempla

**1. La regla 3.2.2(ix) de Apple prohíbe directamente este modelo de negocio.**

> *"Las apps de préstamos no pueden cobrar una TAE máxima superior al 36 %, incluidos costos y comisiones, y **no pueden exigir el reembolso total en 60 días o menos**."*

Las modalidades **diaria, semanal y quincenal** del §4 del documento base **se reembolsan íntegramente en mucho menos de 60 días**. Y una operación de microcrédito de cobranza en calle rara vez opera por debajo del 36 % TAE. **Clasificada como "app de préstamos", esta app no pasa la revisión de Apple** — y la regla es *más* estricta que la de Google Play, que al menos permite declaración financiera caso por caso.

**2. El programa Enterprise —la salida obvia— no es elegible.**

El Apple Developer Enterprise Program ($299/año) permite distribución interna sin revisión de App Store. Pero exige **100 o más empleados**, entidad legal verificada y entrevista con Apple. **Con 30–40 usuarios, esta empresa no califica.** Esa puerta está cerrada, y conviene saberlo antes de diseñar alrededor de ella.

**3. Las Custom Apps de Apple Business Manager tampoco esquivan la revisión.**

Distribuir privadamente a organizaciones designadas suena a la solución — pero **cada Custom App pasa por el mismo proceso de revisión y contra las mismas guías**. Ser privada no relaja 3.2.2(ix).

##### Las vías reales para iOS

| Vía | Costo/año | ¿Revisión de Apple? | Límite | Veredicto |
|---|---:|---|---|---|
| **App Store público** | $99 | Sí, completa | — | ⚠️ Alto riesgo bajo 3.2.2(ix) |
| **Custom App (Apple Business Manager)** | $99 | **Sí, mismas guías** | — | ⚠️ Mismo riesgo, sin ventaja regulatoria |
| **Ad Hoc** | $99 | **No** | **100 dispositivos/año** por tipo | ✅ **Viable con 30–40 gestores** |
| **TestFlight interno** | $99 | No (hasta 100 testers internos) | Builds caducan a 90 días | ⚠️ Recompilar cada 90 días |
| **Enterprise** | $299 | No | — | ❌ **No elegible (<100 empleados)** |

> **La única vía iOS que no depende de ganar un argumento con Apple es Ad Hoc:** hasta 100 dispositivos al año registrados por UDID, sin revisión alguna. Encaja de sobra con 30–40 gestores, y el costo sigue siendo los mismos $99/año.
>
> **Su costo oculto es operativo, no económico:** los perfiles de aprovisionamiento **caducan a los 12 meses**, y cuando eso ocurre **la app deja de abrir en todos los dispositivos a la vez**. Hay que re-firmar y redistribuir a los 40 equipos. Un día de trabajo cada año, en una fecha que nadie recuerda hasta que 30 gestores llaman el mismo lunes.

##### El argumento que sí puede ganar la revisión

`D-01` aporta dos hechos verificables que sacan la app de la categoría "app de préstamos":

1. **No procesa ni acepta pagos de ningún tipo** — no hay compras in-app, ni suscripciones, ni captura de medios de pago en el móvil.
2. **No origina ni desembolsa préstamos al consumidor final** — registra la gestión de cobranza de una cartera existente, operada por empleados de la empresa.

Si eso se sostiene, **3.2.2(ix) no aplica**: no es una app de préstamos, es una herramienta interna de gestión de fuerza de campo. Pero **ese argumento hay que construirlo a propósito**, no esperar que el revisor lo deduzca:

- Categoría **Negocios**, nunca Finanzas.
- Descripción, capturas y metadatos que muestren **rutas, visitas y registro de gestión** — no solicitud ni originación de crédito.
- Notas para el revisor explicando explícitamente el modelo y quién usa la app.
- Etiquetas de privacidad que justifiquen **fotos de documentos y ubicación precisa** — que es el problema de fondo del §5.7 y que `D-01` **no** resuelve.

> 🔒 **Recomendación de secuencia — vale más que cualquier ahorro de este documento.** Subir una build mínima a **TestFlight en la Fase 0** y ver si pasa la *beta app review*. Cuesta **$99 y dos días**, y responde en la semana 1 una pregunta que descubierta en el mes 4 bloquea el lanzamiento entero (`OQ-N-34`, marcado P0). Lo mismo aplica a la declaración financiera de Google Play.

---

### 8.5 💰 Costo total mensual — Fase 1

Tres columnas: **mínimo defendible**, **realista recomendado**, y **si todo se contrata**.

| Concepto | Mínimo<br>(Android) | Recomendado<br>(Android) | ✅ **Recomendado<br>+ iOS** | Todo<br>contratado |
|---|---:|---:|---:|---:|
| **INFRAESTRUCTURA** | | | | |
| Cómputo | Lightsail Small **14,75** | Lightsail Medium **39,27** | Lightsail Medium **39,27** | ECS Fargate + ALB **51,22** |
| PostgreSQL gestionado | Lightsail 2 GB **29,42** | Lightsail 2 GB **29,42** | Lightsail 2 GB **29,42** | RDS `t4g.small` + gp3 **63,22** |
| Almacenamiento de fotos (S3 50 GB) | 2,53 | 2,53 | 2,53 | 2,53 |
| CloudWatch Logs (10 GB, retención 14 días) | 9,41 | 9,41 | 9,41 | 9,41 |
| Route 53 + Secrets Manager | 3,00 | 3,00 | 3,00 | 5,00 |
| Egreso / CloudFront / IPv4 / ECR | 0,00 | 0,00 | 0,00 | 11,55 |
| *Subtotal infraestructura* | *59,11* | *83,63* | ***83,63*** | *142,93* |
| **OBSERVABILIDAD Y CI** | | | | |
| Sentry | 0 *(plan gratuito)* | 26,00 *(Team)* | **26,00** | 26,00 |
| GitHub Actions (repo privado, esta escala) | 0 | 0 | **0** | 0 |
| **DISTRIBUCIÓN MÓVIL** | | | | |
| Google Play ($25 único ÷ 12, solo año 1) | 2,08 | 2,08 | **2,08** | 2,08 |
| **Apple Developer Program** ($99/año) | 0 | 0 | **8,25** | 8,25 |
| Expo EAS Build | 0 *(build local)* | 0 *(build local)* | **0** *(plan gratuito, 15 builds iOS/mes)* | 19,00 *(Starter)* |
| **INTELIGENCIA ARTIFICIAL** | | | | |
| Asistente (§7) | Nova Pro **4,18** | `claude-sonnet-5` **15,81** | `claude-sonnet-5` **15,81** | `claude-opus-5` 26,35 |
| **MENSAJERÍA** | | | | |
| WhatsApp Business API (§6) | **120** *(opt-in 40 % + solo T‑1)* | **212** *(confirmaciones)* | **212** | **350** *(cadena completa)* |
| | | | | |
| **TOTAL MENSUAL** | **≈ $185** | **≈ $340** | **≈ $348** | **≈ $575** |

> **Añadir iPhone al alcance cuesta $8,25/mes.** Es el 2,4 % de la factura — menos que la diferencia entre `claude-sonnet-5` y `claude-opus-5`. **El costo económico de iOS es trivial; el costo real es de riesgo y de calendario** (§8.4, bloqueos de Apple).

**Costos únicos, año 0:**

| Concepto | USD |
|---|---:|
| Registro Google Play Console (pago único, sin cuota anual) | 25 |
| **Apple Developer Program** (primer año) | **99** |
| Verificación de WhatsApp Business (Meta Cloud API directo, sin BSP) | 0 |
| Número D‑U‑N‑S para cuenta de organización en Google Play | 0 |
| Apple Business Manager (si se distribuye como Custom App) | 0 |
| **Total único — solo Android** | **$25** |
| **Total único — Android + iOS** | **$124** |
| *Opcional: Mac mini para compilar iOS sin depender de EAS* | *~$599* |

**Dónde va realmente el dinero (escenario recomendado + iOS, ~$348/mes):**

| Categoría | USD/mes | % |
|---|---:|---:|
| **WhatsApp** | **212** | **61 %** |
| Infraestructura AWS | 84 | 24 % |
| Observabilidad (Sentry) | 26 | 7 % |
| Asistente de IA | 16 | 5 % |
| **Tiendas móviles (Google Play + Apple)** | **10** | **3 %** |

> **La conclusión no cambia con las cifras nuevas: WhatsApp es el 62 % de la factura.** Las tiendas son el 1 % — literalmente ruido. La elección de modelo de IA es el 5 %, y el debate Sonnet 5 vs Nova Pro mueve $12. **La única decisión que mueve la aguja es la política de notificaciones automáticas** (`OQ-N-40`).

**Rangos de sensibilidad, para presupuestar:**

| Si… | Efecto |
|---|---|
| La modalidad diaria es solo la mitad de la cartera | **−$105/mes** |
| Se confirma solo Android (sin App Store) | −$8/mes, **y desaparece el riesgo de bloqueo de `OQ-N-34`** |
| La residencia de datos en Brasil resulta ser preferencia, no requisito | **−$35/mes** (infra en `us-east-1` cuesta ~45 % menos) |
| El asistente de IA sale del MVP (recomendación del §4.8) | −$16/mes |
| Una plantilla de WhatsApp se clasifica como *marketing* | **+$1.700/mes** ⚠️ |
| Se escala a 3.000 clientes | +$320/mes (casi todo WhatsApp; la infraestructura no se mueve) |

---

## 9. 🔒 Lo que falta para cerrar esta recomendación

| # | Pregunta | Qué bloquea | Ref. |
|---|---|---|---|
| 1 | **¿La residencia de datos en Brasil es requisito legal confirmado o preferencia?** | Si es preferencia, `us-east-1` reduce la factura ~45 % y reabre App Runner, Railway y Render. Es la palanca de costo individual más grande del documento. | `OQ-N-25`, `CX-8` |
| 2 | **¿Algún cliente exige contractualmente "infraestructura en AWS"?** | Si no, el escenario E (Fly + Neon) es más barato y más rápido de montar. Si sí, Lightsail cumple. | `OQ-B-3` |
| 3 | **Confirmar que Lightsail PostgreSQL ofrece restauración a punto en el tiempo (7 días)** | Si solo hay snapshots diarios, el RPO no cumple §5.5 y el mínimo pasa a ser el escenario A ($141). **Es una consulta de 5 minutos en la consola.** | `OQ-N-11`, `OQ-N-12` |
| 4 | **¿Cuál es el presupuesto mensual tolerable, en total?** | Con ~$350 de WhatsApp sobre la mesa, la respuesta determina **cuántas notificaciones son automáticas** — que es una decisión de producto que cambia el diseño del motor de reglas. | `OQ-N-40` |
| 5 | **¿Qué proporción de la cartera es modalidad diaria?** | El cálculo de WhatsApp asume el peor caso (100 % diaria). Si la mitad es semanal o quincenal, la mensajería baja a ~$150/mes. | `OQ-F-13`–`OQ-F-18` |
| 6 | **¿Los gestores usan exclusivamente Android?** | Ahorra $99/año, elimina EAS de pago, y sobre todo **quita del camino la revisión de la App Store para una app de préstamos con fotos y GPS** — el riesgo que puede bloquear el lanzamiento. Es la respuesta más barata de conseguir y la de mayor impacto de esta lista. | `OQ-N-31`, `OQ-N-34` |
| 7 | **Si los datos NO pueden salir de Brasil, ¿el asistente de IA sigue en el alcance?** | **Ni Claude ni Nova están en Bedrock `sa-east-1`** (§7.4). Con residencia estricta, ambos quedan descartados y el asistente pasa a un modelo de peso abierto (Qwen, Mistral, GLM) con caída de calidad por validar — o sale del MVP. | `OQ-T-15`, `OQ-N-25` |
| 8 | **¿Cuál es la TAE efectiva y el plazo mínimo de reembolso de cada modalidad?** | **Determina si iOS es viable en absoluto.** La regla 3.2.2(ix) de Apple prohíbe TAE > 36 % o reembolso total en ≤ 60 días. Si el producto cae en cualquiera de las dos, la única vía iOS es **Ad Hoc** (sin revisión, 100 dispositivos/año). Depende de la fórmula de interés que aún falta. | `OQ-F-13`–`OQ-F-18`, `OQ-N-34` |
| 9 | **¿Cuántos empleados tiene la empresa legalmente?** | El Apple Developer Enterprise Program ($299/año, sin revisión de App Store) **exige 100 o más empleados**. Con 30–40 no califica — conviene confirmarlo antes de diseñar alrededor de esa vía. | `OQ-B-9`, `OQ-N-34` |

---

## 10. Cambios que este documento introduce sobre `recomendacion-tecnica.md`

| § afectado | Cambio |
|---|---|
| **§5.2** | **AWS App Runner debe salir de la lista** de contenedores gestionados: no existe en `sa-east-1`, que la misma tabla exige. |
| **§5.2** | La estimación de "$25–50" para PostgreSQL gestionado **subestima Supabase con PITR ($125)**. RDS Single-AZ ($50) y Lightsail ($29) sí caben. |
| **§5.2 / `OQ-N-4`** | El egreso de fotos **no es el mayor costo recurrente** (~$6/mes). La pregunta debe reformularse hacia el presupuesto de WhatsApp. |
| **§5.3** | **Railway y Render deben salir** de las opciones recomendadas: no tienen región en Sudamérica. La recomendación se reduce a Fly.io. |
| **§5.3** | Añadir **AWS Lightsail** como opción recomendada para Fase 1 — no figuraba en el documento y es la mejor relación costo/tiempo dentro de AWS. |
| **§5.6** | La estimación de "$50–180" de infraestructura base **es correcta en rango**, pero el punto medio real en São Paulo bien configurado es **~$59–141**, no $115. El cálculo de WhatsApp debe rehacerse sobre 1.200 clientes (~$350, no ~$100–200). |
| **§7, Fase 1** | Añadir a la Fase 0/1 tres verificaciones de minutos que bloquean decisiones caras: **PITR en Lightsail**, **residencia de datos confirmada** y **¿solo Android?**. |
| **§4.8** | Añadir el hallazgo de que **Bedrock `sa-east-1` no ofrece Nova ni Claude**: la alternativa "usar un modelo dentro de AWS para no romper la residencia de datos" **no existe** en São Paulo. El 🔒 de `OQ-T-15`/`OQ-N-25` aplica por igual a ambas opciones. |
| **§2.1** | Cuantificar la decisión de monolito modular: **~$300/mes menos** que 6 microservicios a esta escala (§1.5) — y añadir la advertencia de memoria por Puppeteer compartiendo contenedor con la API. |
| **§4.10** | Puppeteer necesita ~400–500 MB de pico. En un monolito modular eso comparte contenedor con la API de cobranza: **dimensionar 2 GB**, o encolar con `concurrency: 1`. |
| **§5.7** | El §5.7 solo analiza **Google Play**. Falta App Store, que es **más restrictiva**: la regla **3.2.2(ix)** prohíbe TAE > 36 % o reembolso total en ≤ 60 días — incompatible con las modalidades diaria/semanal/quincenal. Además, el **programa Enterprise exige 100+ empleados** (no elegible) y las **Custom Apps privadas pasan la misma revisión**. Única vía iOS sin revisión: **Ad Hoc**, 100 dispositivos/año. Ver §8.4. |

---

*Precios extraídos de la API pública de precios de AWS (`AmazonRDS`, `AmazonECS`, `AWSELB`, `AmazonS3`, `AmazonEC2`, `AmazonCloudWatch`, `AWSSecretsManager`, `AmazonLightsail`, `AWSDataTransfer` — índices de `sa-east-1`) el 2026-07-28. Precios de Anthropic desde la referencia oficial de la API. Los precios de AWS cambian; valide con la [Calculadora de precios de AWS](https://calculator.aws) antes de comprometer presupuesto.*

**Fuentes consultadas:**
- [AWS App Runner — regiones disponibles](https://www.aws-services.info/apprunner.html) · [Anuncio de expansión de regiones (nov. 2023)](https://aws.amazon.com/about-aws/whats-new/2023/11/aws-app-runner-london-mumbai-paris-regions/)
- [Railway — Regions (docs)](https://docs.railway.com/deployments/regions) · [Render — solicitud de región Brasil](https://feedback.render.com/features/p/brazil-sau-paulo-region)
- [Supabase — costo del complemento PITR](https://revivedb.dev/blog/supabase-pitr-cost) · [Supabase Pricing 2026](https://makerkit.dev/blog/saas/supabase-pricing)
- [Neon — disponibilidad en São Paulo (`sa-east-1`)](https://neon.com/docs/introduction/roadmap)
- [Amazon RDS Pricing](https://aws.amazon.com/rds/pricing/) · [AWS Fargate Pricing](https://aws.amazon.com/fargate/pricing/) · [Amazon S3 Pricing](https://aws.amazon.com/s3/pricing/)
