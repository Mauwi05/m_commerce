# Módulo 08: Pruebas y Referencia de Comandos

## ¿Qué hace y para qué sirve?
Agrupa las pruebas base del proyecto y sirve como guía rápida de todos los comandos de Flutter, Dart, Firebase y Git utilizados durante el desarrollo.

## Archivos involucrados

| Archivo | Propósito |
| :--- | :--- |
| `test/widget_test.dart` | Prueba de humo (`MCommerceApp smoke test`) que valida la construcción del widget raíz `MCommerceApp`. |

## Referencia de Comandos

### Dependencias y configuración
```bash
# Instalar dependencias del proyecto
flutter pub get

# Instalar paquetes del MVP
flutter pub add firebase_core firebase_auth cloud_firestore google_sign_in provider image_picker http cached_network_image intl google_fonts

# Vincular el proyecto con Firebase (Web y Android)
flutterfire configure
```

### Ejecución, análisis y pruebas
```bash
# Correr la aplicación en Chrome (Web)
flutter run -d chrome

# Correr la aplicación en emulador o dispositivo Android
flutter run

# Analizar errores y advertencias de Dart/Flutter
flutter analyze
dart analyze

# Ejecutar pruebas automatizadas
flutter test
```

### Control de versiones (Git)
```bash
# Revisar archivos modificados
git status

# Agregar un archivo al último commit local (antes de hacer push)
git add test/widget_test.dart
git commit --amend --no-edit

# Subir cambios al repositorio remoto
git push
```
