import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cart_item_model.dart';
import '../models/order_model.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createOrder({
    required OrderModel order,
    required List<CartItemModel> cartItems,
  }) async {
    final batch = _firestore.batch();
    final orderRef = _firestore.collection('orders').doc();

    batch.set(orderRef, order.toMap());

    for (final item in cartItems) {
      final productRef =
          _firestore.collection('products').doc(item.product.id);
      batch.update(productRef, {
        'stock': FieldValue.increment(-item.quantity),
      });
    }

    await batch.commit();
    return orderRef.id;
  }

  Stream<List<OrderModel>> getUserOrdersStream(String buyerId) {
    return _firestore
        .collection('orders')
        .where('buyerId', isEqualTo: buyerId)
        .snapshots()
        .map((snapshot) {
      final orders = snapshot.docs
          .map((doc) => OrderModel.fromMap(doc.id, doc.data()))
          .toList();
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return orders;
    });
  }
}
