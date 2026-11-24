# Módulo 02: Tema Visual y Componentes UI Reutilizables

## ¿Qué hace y para qué sirve?
Centraliza la identidad visual minimalista de la aplicación (colores, tipografías editoriales, estilos de botones e inputs) y provee widgets reutilizables para mantener consistencia en todas las pantallas.

## Archivos involucrados

| Archivo | Propósito |
| :--- | :--- |
| `lib/theme/app_theme.dart` | Define `AppColors` (incluyendo tonos **Gris Platinado**), `AppTheme.platinumCardDecoration`, `AppTheme.editorialTitle` y `AppTheme.lightTheme`. |
| `lib/widgets/glass_container.dart` | Contenedor reutilizable con desenfoque (*glassmorphism*) para barras flotantes y badges. |
| `lib/widgets/product_card.dart` | Tarjeta vertical 3:4 en acabado platinado con marco blanco y cápsula oscura de precio. |
| `lib/widgets/logout_button.dart` | Botón reutilizable de cierre de sesión con modal de confirmación traducido con `LocaleProvider`. |

## Detalle técnico
- **`AppColors`**: Paleta clara (`#FFFFFF`, `#F3F4F6`, `#111111`), acentos funcionales (`dropAccent` naranja `#FF4D1C` para Drops y `aiAccent` índigo `#6366F1` para Custom Lab IA) y tonos **Gris Platinado** (`platinumLight`, `platinum`, `platinumBorder`, `cardShadow`).
- **`AppTheme.platinumCardDecoration`**: Decoración reutilizable con degradado platinado, borde sutil y sombra suave (`elevated`) aplicada en tarjetas de producto y perfil.
- **`AppTheme.lightTheme`**:
  - Usa Material 3 y `Plus Jakarta Sans` para textos generales y `Bebas Neue` para títulos editoriales.
  - Mapea los 15 estilos de `GoogleFonts.plusJakartaSansTextTheme()` a un `TextTheme` estándar de `flutter/material.dart` para compatibilidad con `google_fonts: ^9.0.0`.
- **`GlassContainer`**: Combina `ClipRRect` + `BackdropFilter(ImageFilter.blur)` + borde semitransparente.
- **`ProductCard`**:
  - Contenedor con `AppTheme.platinumCardDecoration(radius: 22)` y marco blanco para `CachedNetworkImage`.
  - Muestra badge flotante traducido (`badge_drop`) si `product.isDrop` es `true`.
  - Muestra título, nombre de tienda y precio formateado en `$MXN` con `intl` dentro de una cápsula oscura (`AppColors.primary`).
- **`LogoutButton`**: Encapsula el `IconButton` de salida y el `AlertDialog` de confirmación para reutilizarse en todas las pestañas principales (`ExploreScreen`, `ProfileScreen` y pestañas de `HomeScreen`).

## Comandos utilizados
```bash
# Paquetes para tipografía, caché de imágenes y formato de moneda
flutter pub add google_fonts cached_network_image intl

# Verificación de estilos y errores estáticos
dart analyze
```
