import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final String buyerId;
  final String buyerName;
  final String buyerEmail;
  final String shippingAddress;
  final String phone;
  final String paymentMethod;
  final List<Map<String, dynamic>> items;
  final double total;
  final String status;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.buyerId,
    required this.buyerName,
    required this.buyerEmail,
    required this.shippingAddress,
    required this.phone,
    required this.paymentMethod,
    required this.items,
    required this.total,
    this.status = 'confirmed',
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'buyerId': buyerId,
      'buyerName': buyerName,
      'buyerEmail': buyerEmail,
      'shippingAddress': shippingAddress,
      'phone': phone,
      'paymentMethod': paymentMethod,
      'items': items,
      'total': total,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory OrderModel.fromMap(String id, Map<String, dynamic> map) {
    return OrderModel(
      id: id,
      buyerId: map['buyerId'] ?? '',
      buyerName: map['buyerName'] ?? '',
      buyerEmail: map['buyerEmail'] ?? '',
      shippingAddress: map['shippingAddress'] ?? '',
      phone: map['phone'] ?? '',
      paymentMethod: map['paymentMethod'] ?? 'card',
      items: List<Map<String, dynamic>>.from(map['items'] ?? []),
      total: (map['total'] ?? 0).toDouble(),
      status: map['status'] ?? 'confirmed',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
