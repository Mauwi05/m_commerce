# Módulo 01: Arranque, Configuración de Firebase e Inyección de Estado

## ¿Qué hace y para qué sirve?
Inicializa el motor de Flutter y la conexión con Firebase antes de renderizar la interfaz, inyecta los proveedores globales de estado (`AuthProvider` y `LocaleProvider`) y controla el acceso inicial mostrando `HomeScreen` o `LoginScreen` según exista una sesión activa.

## Archivos involucrados

| Archivo | Propósito |
| :--- | :--- |
| `lib/main.dart` | Punto de entrada (`main()`), `MCommerceApp` (`MultiProvider` + `MaterialApp`) y `AuthWrapper`. |
| `lib/firebase_options.dart` | Configuración automática por plataforma (Web, Android, etc.) generada por FlutterFire. |
| `android/app/google-services.json` | Credenciales nativas de Firebase para Android. |
| `pubspec.yaml` | Registro de dependencias del proyecto. |

## Funcionamiento interno
1. `WidgetsFlutterBinding.ensureInitialized()` asegura que los bindings nativos estén listos antes de llamadas asíncronas.
2. `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)` conecta la app con el proyecto de Firebase.
3. `MultiProvider` registra `AuthProvider` y `LocaleProvider` en la raíz del árbol de widgets.
4. `AuthWrapper` observa `AuthProvider`:
   - Si `isInitializing == true`, muestra un `CircularProgressIndicator`.
   - Si `isAuthenticated == true`, abre `HomeScreen`.
   - De lo contrario, muestra `LoginScreen`.

## Comandos utilizados
```bash
# Instalar dependencias base de Firebase y estado
flutter pub add firebase_core provider

# Generar lib/firebase_options.dart y vincular google-services.json
flutterfire configure

# Instalar todas las dependencias declaradas en pubspec.yaml
flutter pub get
```
