# Módulo 03: Autenticación y Gestión de Sesión

## ¿Qué hace y para qué sirve?
Permite a los usuarios crear cuenta, iniciar sesión con correo/contraseña o con Google (en Web y Móvil), guardar su perfil en Firestore y cerrar sesión destruyendo por completo las credenciales y caché de cuenta.

## Archivos involucrados

| Archivo | Propósito |
| :--- | :--- |
| `lib/models/user_model.dart` | Modelo de usuario (`uid`, `name`, `email`, `photoUrl`, `phone`, `bio`, `address`, `isSeller`, `storeName`, `createdAt`). |
| `lib/services/auth_service.dart` | Comunicación directa con Firebase Auth, Google Sign-In v7.x y la colección `users` en Firestore. |
| `lib/providers/auth_provider.dart` | Estado reactivo de sesión (`_user`, `_isLoading`, `_isInitializing`, `_errorMessage`) y manejo de errores. |
| `lib/screens/login_screen.dart` | Interfaz de inicio de sesión y registro con validaciones, subtítulo bilingüe (`login_subtitle`) y botón de Google. |
| `lib/widgets/logout_button.dart` | Botón reutilizable con modal de confirmación para cerrar sesión desde cualquier pestaña. |

## Flujo y métodos clave
- **Correo y contraseña**: `registerWithEmail` crea la cuenta en Firebase Auth, actualiza `displayName` y guarda el documento en `users/{uid}`; `signInWithEmail` autentica y lee los datos desde Firestore.
- **Google Sign-In**:
  - **Web**: Usa `signInWithPopup` con `prompt: select_account` para permitir elegir cuenta en cada inicio.
  - **Android/iOS**: Inicializa `GoogleSignIn.instance` (v7.x) y autentica con `idToken`. Si el usuario es nuevo, crea su documento en Firestore.
- **Cierre de sesión completo (`signOut`)**:
  - En `AuthService`: en móvil ejecuta `GoogleSignIn.instance.signOut()` y `disconnect()` dentro de `try/catch`, y luego `FirebaseAuth.instance.signOut()`.
  - En `AuthProvider`: garantiza en el bloque `finally` que `_user = null` y notifica a la UI para regresar al Login.

## Comandos utilizados
```bash
# Paquetes de autenticación y base de datos de usuarios
flutter pub add firebase_auth google_sign_in cloud_firestore
```
