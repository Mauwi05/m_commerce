import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _productsRef =>
      _firestore.collection('products');

  // Publicar un producto nuevo
  Future<void> createProduct(ProductModel product) async {
    await _productsRef.add(product.toMap());
  }

  // Stream de todo el catálogo en tiempo real (ordenado por más reciente)
  Stream<List<ProductModel>> getProductsStream({String? category}) {
    Query<Map<String, dynamic>> query = _productsRef.orderBy(
      'createdAt',
      descending: true,
    );

    if (category != null && category != 'todo') {
      query = query.where('category', isEqualTo: category);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => ProductModel.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  // Stream solo de Drops activos
  Stream<List<ProductModel>> getDropsStream() {
    return _productsRef
        .where('isDrop', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ProductModel.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  // Stream de los productos publicados por un vendedor específico
  Stream<List<ProductModel>> getSellerProductsStream(String sellerId) {
    return _productsRef
        .where('sellerId', isEqualTo: sellerId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ProductModel.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  // Eliminar producto
  Future<void> deleteProduct(String productId) async {
    await _productsRef.doc(productId).delete();
  }
}
