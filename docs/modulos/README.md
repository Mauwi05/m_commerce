# Documentación por Módulos — M-Commerce Marketplace

Índice general de la documentación técnica de **M-Commerce**, separada por módulo funcional.

## Índice de Módulos

| # | Módulo | Archivo | Resumen |
| :-: | :--- | :--- | :--- |
| 01 | Arranque y Firebase | [01_arranque_y_firebase.md](./01_arranque_y_firebase.md) | Inicialización de Flutter/Firebase, `MultiProvider` y `AuthWrapper`. |
| 02 | Tema y Componentes UI | [02_tema_y_componentes_ui.md](./02_tema_y_componentes_ui.md) | Paleta de colores, tipografía, `GlassContainer` y `ProductCard`. |
| 03 | Autenticación y Sesión | [03_autenticacion_y_sesion.md](./03_autenticacion_y_sesion.md) | Login/Registro por correo y Google (Web/Móvil) y cierre de sesión completo. |
| 04 | Internacionalización (ES/EN) | [04_internacionalizacion.md](./04_internacionalizacion.md) | Cambio de idioma en tiempo real con `LocaleProvider`. |
| 05 | Navegación y Catálogo | [05_navegacion_y_catalogo.md](./05_navegacion_y_catalogo.md) | Barra flotante cristal, Hero Banner, filtros y feed en vivo. |
| 06 | Productos y Cloudinary | [06_productos_y_cloudinary.md](./06_productos_y_cloudinary.md) | Modelo de producto, subida de fotos por bytes y CRUD en Firestore. |
| 07 | Perfil y Modo Vendedor | [07_perfil_y_vendedor.md](./07_perfil_y_vendedor.md) | Activación de tienda, edición de perfil/avatar, publicaciones y modal de salida. |
| 08 | Pruebas y Comandos | [08_pruebas_y_comandos.md](./08_pruebas_y_comandos.md) | Tests automatizados y referencia rápida de comandos Flutter, Firebase y Git. |

## Flujo de Capas

```text
Screens / Widgets  ──►  Providers (ChangeNotifier)  ──►  Services (Firebase / Cloudinary)  ──►  Models
```
