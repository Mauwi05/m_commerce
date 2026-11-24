# Módulo 06: Gestión de Productos, Firestore y Cloudinary

## ¿Qué hace y para qué sirve?
Permite a los vendedores publicar productos con fotografías almacenadas en Cloudinary y registrar sus metadatos (precio, stock, categoría, tallas, modo Drop y Custom Lab) en Cloud Firestore con sincronización en tiempo real.

## Archivos involucrados

| Archivo | Propósito |
| :--- | :--- |
| `lib/models/product_model.dart` | Modelo de producto con serialización `toMap()` / `fromMap()` y soporte para `Timestamp`. |
| `lib/services/cloudinary_service.dart` | Sube imágenes por bytes (`Uint8List`) a Cloudinary (`wi5mei7f` / `m_commerce_uploads`) organizadas en `m_commerce/<categoria>`. |
| `lib/services/product_service.dart` | CRUD y streams en tiempo real sobre la colección `products` en Firestore. |
| `lib/screens/add_product_screen.dart` | Formulario para publicar productos con selector de imagen, tallas y switches de Drop / Custom Lab. |

## Detalle técnico
- **Compatibilidad Web + Móvil en imágenes**:
  - `AddProductScreen` lee los bytes de `XFile` y muestra la vista previa con `Image.memory`.
  - `CloudinaryService.uploadXFile` envía los bytes mediante `http.MultipartRequest` para evitar dependencias de `dart:io` (`File`).
- **Validaciones en `AddProductScreen`**:
  - Exige foto seleccionada, nombre, descripción, precio y stock numéricos válidos.
  - Si la categoría es `'ropa'`, muestra chips de tallas (`S`, `M`, `L`, `XL`, `Oversize`) y exige seleccionar al menos una.
  - Si se activa **Drop**, asigna automáticamente `dropEndTime` a 72 horas (`Duration(days: 3)`).
- **Streams en `ProductService`**:
  - `getProductsStream({category})`: catálogo general ordenado por `createdAt` descendente.
  - `getDropsStream()`: solo productos con `isDrop == true`.
  - `getSellerProductsStream(sellerId)`: productos de un vendedor específico.
  - `deleteProduct(productId)`: elimina el documento en Firestore.

## Comandos utilizados
```bash
# Paquetes para selección de fotos, subida HTTP y Firestore
flutter pub add image_picker http cloud_firestore
```
