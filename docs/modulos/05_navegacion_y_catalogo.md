# Módulo 05: Navegación Principal y Catálogo en Tiempo Real

## ¿Qué hace y para qué sirve?
Provee el cascarón principal de la app con barra de navegación flotante estilo cristal y la pantalla de exploración donde los compradores ven los productos publicados en tiempo real y los filtran por categoría.

## Archivos involucrados

| Archivo | Propósito |
| :--- | :--- |
| `lib/screens/home_screen.dart` | Contenedor con `IndexedStack` (4 pestañas) y barra flotante `Floating Glass Pill`. |
| `lib/screens/explore_screen.dart` | Catálogo principal con Hero Banner editorial, filtros en píldoras y cuadrícula 2 columnas. |

## Funcionamiento interno
- **`HomeScreen`**:
  - Mantiene 4 pestañas vivas con `IndexedStack`: Explorar (`ExploreScreen`), Exclusivos/Drops (`_PlaceholderTab` con `AppBar` y `LogoutButton`), Diseñar/Lab IA (`_PlaceholderTab` con `AppBar` y `LogoutButton`) y Perfil (`ProfileScreen`).
  - Superpone la barra flotante con `GlassContainer` y animaciones suaves (`AnimatedContainer`) en el ítem activo.
- **`ExploreScreen`**:
  - `AppBar` con botón `ES`/`EN`, ícono de carrito y `LogoutButton`.
  - Se suscribe a `ProductService.getProductsStream()` mediante `StreamBuilder<List<ProductModel>>`.
  - Filtra por categoría (`todo`, `ropa`, `joyeria`, `accesorios`) en memoria para evitar errores de índices compuestos en Firestore.
  - Muestra un Hero Banner con botón directo a la pestaña de Drops (`onGoToDrops`) y una cuadrícula `SliverGrid` con `ProductCard`.

## Comandos utilizados
```bash
# Probar navegación y feed en tiempo real en navegador
flutter run -d chrome
```
