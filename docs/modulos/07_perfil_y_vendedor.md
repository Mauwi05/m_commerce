# Módulo 07: Perfil, Modo Vendedor y Edición de Perfil

## ¿Qué hace y para qué sirve?
Permite al usuario consultar su información, activar su tienda para convertirse en vendedor (modelo multi-vendedor), administrar sus publicaciones, editar sus datos personales/avatar y cerrar sesión con confirmación.

## Archivos involucrados

| Archivo | Propósito |
| :--- | :--- |
| `lib/screens/profile_screen.dart` | Vista de perfil en acabado platinado, activación de Modo Vendedor, listado/borrado de publicaciones y `LogoutButton`. |
| `lib/screens/edit_profile_screen.dart` | Formulario para editar foto de perfil, nombre, tienda (si es vendedor), teléfono, dirección y bio. |
| `lib/widgets/logout_button.dart` | Widget reutilizable de cierre de sesión con confirmación integrado en el `AppBar`. |

## Funcionamiento interno
- **Acabado Gris Platinado**:
  - La tarjeta de usuario (`radius: 24`, aro blanco alrededor del avatar y recuadro translúcido para la bio), la tarjeta de invitación a vendedor (`radius: 22`) y cada elemento de **Mis Publicaciones** (`radius: 18`) usan `AppTheme.platinumCardDecoration`.
- **Activación de Modo Vendedor (`_showActivateSellerDialog`)**:
  - Solicita el nombre de la tienda y llama a `AuthProvider.activateSellerMode(storeName)`.
  - Al actualizar Firestore y recargar `_user`, la UI cambia automáticamente de la tarjeta promocional al panel de vendedor.
- **Panel de Vendedor**:
  - Botón para abrir `AddProductScreen`.
  - `StreamBuilder` con `ProductService.getSellerProductsStream(user.uid)` para listar y eliminar publicaciones propias.
- **Edición de Perfil (`EditProfileScreen`)**:
  - Permite elegir un nuevo avatar desde galería (previsualizado con `MemoryImage` y subido a `m_commerce/avatars` en Cloudinary).
  - Llama a `AuthProvider.updateProfile(...)`, que sincroniza Firestore y Firebase Auth.
- **Cierre de sesión con confirmación (`LogoutButton`)**:
  - Usa `const LogoutButton()` en el `AppBar`, mostrando un `AlertDialog` traducido antes de ejecutar `AuthProvider.signOut()` y limpiar la pila de navegación (`popUntil`).

## Comandos utilizados
```bash
# Reutiliza provider, image_picker, http y cloud_firestore
flutter run -d chrome
```
