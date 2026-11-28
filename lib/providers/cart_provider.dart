import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, CartItemModel> _items = {};

  List<CartItemModel> get items => _items.values.toList();

  bool get isEmpty => _items.isEmpty;

  int get itemCount =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);

  double get totalAmount =>
      _items.values.fold(0.0, (sum, item) => sum + item.subtotal);

  bool addItem(ProductModel product, {String? size, int quantity = 1}) {
    if (product.stock <= 0) return false;

    final key = '${product.id}_${size ?? 'default'}';

    if (_items.containsKey(key)) {
      final current = _items[key]!;
      if (current.quantity + quantity > product.stock) {
        return false;
      }
      current.quantity += quantity;
    } else {
      if (quantity > product.stock) return false;
      _items[key] = CartItemModel(
        product: product,
        selectedSize: size,
        quantity: quantity,
      );
    }

    notifyListeners();
    return true;
  }

  bool incrementQuantity(String key) {
    final item = _items[key];
    if (item == null) return false;
    if (item.quantity >= item.product.stock) return false;

    item.quantity += 1;
    notifyListeners();
    return true;
  }

  void decrementQuantity(String key) {
    final item = _items[key];
    if (item == null) return;

    if (item.quantity > 1) {
      item.quantity -= 1;
    } else {
      _items.remove(key);
    }
    notifyListeners();
  }

  void removeItem(String key) {
    _items.remove(key);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
