# Especificación de Requerimientos de Software (SRS)

**Proyecto:** Plataforma Móvil de E-Commerce & Marketplace Multi-Vendedor con "Custom Lab" (IA & Mockups) y Drops Exclusi
**Desarrollador:** Mauricio Julián Martínez Rodríguez
**Materia:** Desarrollo de Aplicaciones Móviles / Backend
**Arquitectura:** Frontend en Flutter + Backend Serverless en Firebase (Escalable a Web)

---

## 1. Descripción General y Alcance
El proyecto consiste en el desarrollo de una aplicación móvil nativa multiplataforma en **Flutter** que funciona como un **Marketplace Multi-Vendedor (C2C/B2C)** enfocado en ropa personalizada, joyería y artículos de diseño. Cualquier usuario registrado podrá actuar como comprador o habilitar su perfil de vendedor para publicar y gestionar sus propios artículos.

Para diferenciarse del comercio electrónico tradicional, la aplicación incorpora dos módulos innovadores:
1. **Custom Lab (Personalizador Interactivo + IA):** Permite a los compradores previsualizar prendas en tiempo real subiendo sus propias fotografías desde su galería o generando diseños inéditos mediante Inteligencia Artificial, ajustando la posición y escala del estampado directamente sobre el modelo de la prenda sin requerir software de diseño externo (como Photoshop o Illustrator).
2. **Sistema de "Drops" (Edición Limitada):** Publicaciones especiales de productos en tendencia (anime, cultura pop, joyería exclusiva) con cuenta regresiva en vivo y stock limitado.

Toda la infraestructura de base de datos, autenticación y almacenamiento de archivos residirá de forma desacoplada en **Firebase**, permitiendo que en una fase posterior se conecte una plataforma web oficial exactamente al mismo backend.

---

## 2. Requerimientos Funcionales (RF)

* **RF-01. Autenticación Híbrida (Google Sign-In + Email):**
  * Inicio de sesión y registro mediante correo electrónico y contraseña, además de autenticación federada con un solo toque mediante **Google Sign-In (`google_sign_in`)** conectada a **Firebase Authentication**.
  * Gestión de perfil de usuario con opción para activar el rol de **Vendedor** dentro de la misma cuenta.

* **RF-02. Catálogo Marketplace y Sección de "Drops" en Tiempo Real:**
  * Visualización dinámica de productos consumidos en tiempo real desde **Cloud Firestore**, separados por categorías (*Todo, Ropa/Playeras, Joyería, Accesorios*).
  * Barra de búsqueda por palabras clave y visualización del nombre del vendedor en cada tarjeta de producto.
  * Carrusel destacado de **"Drops Exclusivos"** que muestra artículos de edición limitada con un temporizador en cuenta regresiva (`Timer`) en vivo y contador de piezas disponibles.

* **RF-03. Módulo "Custom Lab" (Personalizador de Prendas + IA):**
  * Lienzo interactivo sobre plantillas de prendas (mockups) donde el usuario puede cargar una imagen desde la galería de su dispositivo (`image_picker`) y manipular su posición, rotación y escala mediante gestos táctiles (`InteractiveViewer`).
  * Integración de un **Generador de Diseños por IA** mediante un prompt de texto para crear estampados personalizados al instante y previsualizarlos sobre la prenda.
  * Captura y exportación automática del resultado visual (`RepaintBoundary`) hacia **Firebase Storage** al agregar al carrito, entregando al vendedor tanto la vista previa de referencia como el archivo original listo para imprenta.

* **RF-04. Panel de Vendedor (Publicación de Artículos):**
  * Formulario dentro de la aplicación para que los vendedores publiquen productos estándar o "Drops" con fecha de expiración.
  * Subida de fotografías del producto directamente a **Firebase Storage**, definiendo título, descripción, precio, stock, categoría, variantes (tallas/materiales) y una bandera booleana que indique si el artículo admite personalización en el *Custom Lab*.

* **RF-05. Carrito de Compras y Pasarela de Pago (Checkout):**
  * Gestión de estado reactivo del carrito de compras, soportando tanto artículos de catálogo general como prendas personalizadas con sus respectivas tallas o variantes.
  * Cálculo automático de subtotales y total de la orden.
  * Integración de flujo de pago (pasarela **Stripe** en modo *Sandbox/Test* o validador de transacción) y registro de la compra en la colección `orders` de Firestore, descontando el stock correspondiente.

---

## 3. Requerimientos No Funcionales y Técnicos (RNF)

* **RNF-01. Arquitectura y Claridad de Código:**
  * Organización modular limpia del proyecto separada por responsabilidades (`models/`, `views/screens/`, `views/widgets/`, `services/`, `providers/`), garantizando la legibilidad, el mantenimiento y la escalabilidad del código.

* **RNF-02. Control de Versiones (GitHub & Conventional Commits):**
  * Publicación del proyecto en un repositorio público de GitHub que incluya un archivo `README.md` detallado (descripción, tecnologías, arquitectura e instrucciones de ejecución).
  * Historial de control de versiones documentado bajo el estándar **Conventional Commits** (`feat:`, `fix:`, `chore:`, `docs:`, `style:`, `refactor:`).

* **RNF-03. Backend Cloud Multiplataforma:**
  * Uso de **Cloud Firestore** (base de datos NoSQL en tiempo real) y **Firebase Storage** (almacenamiento de imágenes en la nube) con un modelado de datos agnóstico para soportar clientes móviles (Flutter) y futuros clientes Web.

* **RNF-04. Tiempo de Desarrollo Efectivo:**
  * Cumplimiento de la meta ideal de **4+ horas de desarrollo efectivo** comprobables a través de la arquitectura implementada y el historial de commits, cubriendo el criterio establecido para exentar la evaluación teórica del jueves 19 de noviembre.

---

## 4. Modelo de Base de Datos (Cloud Firestore)

| Colección | Campos Principales del Documento | Propósito |
| :--- | :--- | :--- |
| **`users`** | `uid`, `displayName`, `email`, `photoUrl`, `isSeller` (bool), `storeName`, `createdAt` | Almacena perfiles de usuarios autenticados con Google/Email y permisos de tienda. |
| **`products`** | `productId`, `sellerId`, `sellerName`, `title`, `description`, `price`, `category` (`ropa`, `joyeria`), `imageUrl`, `variants` (Array), `isCustomizable` (bool), `isDrop` (bool), `dropEndDate` (Timestamp), `stock`, `createdAt` | Catálogo general multi-vendedor, control de temporizadores de Drops y activación del *Custom Lab*. |
| **`orders`** | `orderId`, `buyerId`, `items` (Array con `productId`, `sellerId`, `variant`, `qty`, `customPreviewUrl`, `customDesignUrl`), `totalAmount`, `paymentStatus`, `createdAt` | Registro de transacciones completadas y vinculación de archivos de diseño para producción/imprenta. |

---

## 5. Plan de Desarrollo (Cronograma de 4+ Horas)

1. **Bloque 1 (1 hr) — Inicialización y Autenticación:** Configuración del proyecto con FlutterFire CLI, registro de certificado SHA-1 para Android, estructura de directorios y pantalla de Login/Registro con soporte para Google Sign-In.
2. **Bloque 2 (1 hr) — Marketplace, Categorías y Drops:** Creación de modelos de datos (`Product`, `User`), servicio de subida de imágenes a Firebase Storage y pantalla principal (Home) con filtrado por categorías (Playeras, Joyería) y carrusel con cuenta regresiva para Drops.
3. **Bloque 3 (1 hr) — Módulo "Custom Lab" (Previsualizador + IA):** Desarrollo del lienzo interactivo sobre plantilla de prenda, carga de imagen desde galería, conexión a API de generación de imágenes por IA mediante prompt y captura del diseño personalizado.
4. **Bloque 4 (1 hr+) — Carrito, Checkout y Documentación:** Implementación del estado del carrito de compras, integración de pantalla de pago en modo de prueba, registro de órdenes en Firestore y redacción del `README.md` final en GitHub.