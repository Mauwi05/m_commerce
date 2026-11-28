import 'product_model.dart';

class CartItemModel {
  final ProductModel product;
  final String? selectedSize;
  int quantity;

  CartItemModel({
    required this.product,
    this.selectedSize,
    this.quantity = 1,
  });

  String get key => '${product.id}_${selectedSize ?? 'default'}';

  double get subtotal => product.price * quantity;

  Map<String, dynamic> toOrderItemMap() {
    return {
      'productId': product.id,
      'sellerId': product.sellerId,
      'storeName': product.storeName,
      'title': product.title,
      'imageUrl': product.imageUrl,
      'unitPrice': product.price,
      'selectedSize': selectedSize,
      'quantity': quantity,
      'subtotal': subtotal,
    };
  }
}
