# Módulo 04: Internacionalización (Español / Inglés)

## ¿Qué hace y para qué sirve?
Permite alternar toda la interfaz entre español (**ES**) e inglés (**EN**) en tiempo real mediante un botón compacto en el encabezado, centralizando todos los textos en un único archivo.

## Archivos involucrados

| Archivo | Propósito |
| :--- | :--- |
| `lib/providers/locale_provider.dart` | `ChangeNotifier` con diccionarios `_es` y `_en` (enfoque multi-categoría), propiedad `languageCode`, `toggleLanguage()` y método `t(key)`. |
| `lib/main.dart` | Registra `LocaleProvider` dentro de `MultiProvider`. |
| `lib/screens/login_screen.dart` | Traduce el subtítulo general del Marketplace (`login_subtitle`). |
| `lib/screens/explore_screen.dart` | Incluye el botón `ES`/`EN` en el `AppBar` y traduce categorías, Hero Banner y estado vacío. |
| `lib/screens/home_screen.dart` | Traduce pestañas y etiquetas de la barra flotante. |
| `lib/screens/profile_screen.dart` | Traduce perfil, panel de vendedor y textos de publicaciones. |
| `lib/screens/edit_profile_screen.dart` | Traduce campos y mensajes del formulario de edición de perfil. |
| `lib/widgets/product_card.dart` | Traduce la insignia de edición limitada (`EXCLUSIVO` / `LIMITED`). |
| `lib/widgets/logout_button.dart` | Traduce tooltip, título, mensaje y acciones del modal de cierre de sesión. |

## Funcionamiento interno
1. Las pantallas leen textos con `final loc = context.watch<LocaleProvider>();` y `loc.t('llave')`.
2. Al presionar el botón de idioma, `context.read<LocaleProvider>().toggleLanguage()` invierte `_isEnglish` y llama a `notifyListeners()`, redibujando automáticamente las vistas suscritas.

## Comandos utilizados
```bash
# Utiliza Provider (ya instalado en el Módulo 01)
flutter pub add provider
```
