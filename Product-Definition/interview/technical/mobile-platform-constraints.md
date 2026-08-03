# Mobile Platform Constraints — React Native + Expo

**Origen**: derivado de `T5` (2026-08-01), a petición explícita del líder técnico.
**Estado**: **constraint vinculante**, no recomendación. Se fusiona en
`Product-Definition/technical-environment.md` §Frameworks al cerrar la entrevista técnica.
**Consumidor**: AI-DLC debe honrar estas reglas al generar cualquier código de la app móvil.

---

## Por qué existe este documento

La app móvil se construye con **React Native + Expo** (decidido en T5: el equipo sabe React,
y Flutter implicaría aprender Dart desde cero). Esa elección trae una obligación de
mantenimiento que **no es opcional y no la impone Expo**:

> **Apple y Google obligan a actualizar.** Apple exige compilar con un SDK de iOS reciente para
> poder **subir actualizaciones**; Google Play sube el `targetSdkVersion` mínimo cada año, tanto
> para apps nuevas como para actualizaciones. Incumplir no rompe la app instalada — **impide
> publicar correcciones**. En un sistema que lleva la caja de una operación de cobranza, quedarse
> sin poder desplegar un arreglo es peor que la actualización que se estaba evitando.

Las fechas límite cambian cada año y **deben consultarse al arrancar el proyecto**. El patrón es
estable: **una subida al año como mínimo, obligatoria.**

Por lo tanto el objetivo **no es evitar las actualizaciones**, sino que cada una cueste **medio
día en vez de dos semanas**. Eso depende casi por completo de las seis reglas siguientes, que se
aplican al montar el proyecto — no después.

---

## Las seis reglas

### 1. No versionar `ios/` ni `android/`

La más importante, con diferencia. Expo genera los proyectos nativos desde `app.json` más
*config plugins* en cada compilación (*Continuous Native Generation*).

- ✅ `ios/` y `android/` en `.gitignore`; se regeneran con `expo prebuild`.
- ❌ Nunca editar código nativo a mano y versionarlo.

**Por qué**: con CNG, subir de SDK es cambiar un número y regenerar. Si esas carpetas están
versionadas y editadas, cada subida se convierte en resolver conflictos dentro de proyectos de
Xcode y Gradle — exactamente la dificultad de la que Expo saca al equipo.

### 2. Toda librería nativa debe tener *config plugin*

Antes de adoptar cualquier dependencia con código nativo, comprobar que esté **en el SDK de Expo**
o que publique un *config plugin* oficial.

**Por qué**: cada módulo nativo sin plugin es un impuesto que se paga en **cada** subida de SDK.

**Afecta directamente a lo que este proyecto necesita** — elegir estas mirando el plugin primero,
no la popularidad:

| Necesidad | Requisito del proyecto |
|---|---|
| SQLite **cifrada** en el dispositivo | Fotos de documentos de identidad y datos financieros locales; borrado remoto pedido en C-71 |
| Cámara | Fotos de documento, residencia y comercio (C-42, C-44) |
| GPS preciso | Ubicación del cliente y orden geográfico de ruta (C-45, C-73) |
| Notificaciones push | Aprobación de llaves de autorización (C-63, solo automática) |
| Lector de QR | Liberación del dinero de una venta aprobada (C-31) — control antifraude nº 1 |

### 3. Instalar siempre con `expo install`, nunca con `npm install` a secas

- ✅ `expo install <paquete>` — resuelve la versión compatible con el SDK activo.
- ✅ `npx expo-doctor` en CI, para detectar desviaciones del conjunto compatible.
- ❌ Nunca fijar a mano las versiones de `react`, `react-native` o `react-dom` del móvil.

**Por qué**: la cadena `Expo SDK → React Native → React` es rígida. React Native tiene su propio
renderizador acoplado a las tripas de React, así que cada versión de RN solo funciona con una
versión concreta de React. Fijar React a una versión que Expo no bendijo produce fallos sutiles.

### 4. Fijar la versión del SDK exacta, sin `^`

En `package.json`, `expo` va con versión exacta.

**Por qué**: que subir de SDK sea siempre una decisión deliberada y nunca un efecto secundario de
un `npm install`.

### 5. Subir de SDK de una versión a la vez

Nunca saltar varias versiones de golpe.

**Por qué**: cada versión trae su propia guía de migración y, a menudo, un *codemod* que hace la
mayor parte del trabajo. Cuatro saltos secuenciales son mucho más baratos que uno de cuatro.

### 6. Mantener pruebas de humo de los recorridos críticos

Es lo que convierte una actualización de aterradora a rutinaria. Con un solo desarrollador, lo
que da miedo no es el cambio: es **no saber si algo se rompió**.

Mínimo exigido — los cuatro recorridos que, si fallan, paran la operación:

1. Entrar y cargar la lista de clientes del día
2. Registrar un pago en efectivo **sin señal** y verificar el contador fraccionario de cuotas
3. Registrar un "no pago" con motivo y compromiso de fecha
4. Cerrar caja con los tres paneles en cero pendientes

Se cruza con `T22` (tipos de prueba requeridos).

---

## Calendario y presupuesto de mantenimiento

| Cadencia | Qué | Esfuerzo estimado |
|---|---|---|
| **2 veces al año** | Subir de SDK para no salirse de la ventana de soporte de EAS Build | 2–3 días, **si se siguen las seis reglas** |
| **1 vez al año, obligatorio** | El SDK que exijan Apple o Google para poder publicar | Incluido en lo anterior si se va al día |

**Reservar dos ventanas al año en la hoja de ruta, de unos 3 días cada una.** No es tiempo
perdido: es el precio de tener una app en dos tiendas, y se paga con Expo, sin Expo o con Flutter.

> **Consecuencia si se queda atrás**: se pierde el acceso a las compilaciones en la nube de EAS y
> hay que compilar en local — lo que para iOS exige macOS con Xcode. El equipo está en macOS, así
> que es viable, pero es más lento.

---

## Alternativas evaluadas y descartadas

| Opción | Veredicto |
|---|---|
| **React Native sin Expo** | ❌ Más dolor, no menos. La curación de versiones de Expo es justo lo que ahorra el trabajo |
| **Flutter** | ❌ Su propia rueda de actualizaciones, **más** aprender Dart desde cero, tirando el conocimiento de React |
| **Nativo (Swift + Kotlin)** | ❌ Dos bases de código para un equipo de una persona |
| **PWA / web en un contenedor** | ❌ Incompatible con los requisitos: SQLite offline real, sincronización en segundo plano, push, cámara y GPS preciso. iOS es débil justo en esos puntos |

**Conclusión**: para los requisitos de este proyecto, **Expo es la opción de menor mantenimiento
que existe**. La rueda de actualizaciones es del ecosistema móvil, no de Expo.

---

## Relación con el cuestionario del cliente

Este documento **presupone que la app se distribuye por las tiendas**. Esa vía sigue **sin
confirmar**: es la pregunta `V-49` del cuestionario v3, donde se advierte que Google Play aplica
políticas restrictivas a las apps de préstamos —incluida la prohibición de acceder a **fotos y
ubicación precisa**, que este sistema usa de forma central.

> Si `V-49` se resuelve por **distribución gestionada** (MDM / Play Store gestionado, sin revisión
> pública), la **regla 1 se vuelve todavía más importante** —seguirá habiendo que recompilar— pero
> **la presión de las fechas límite de las tiendas desaparece en gran parte**, y las dos ventanas
> anuales podrían reducirse a una.
