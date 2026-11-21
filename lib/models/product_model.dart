import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String sellerId;
  final String storeName;
  final String title;
  final String description;
  final double price;
  final String category; // 'ropa', 'joyeria', 'accesorios'
  final String imageUrl;
  final int stock;
  final List<String> sizes;
  final bool isDrop;
  final DateTime? dropEndTime;
  final bool isCustomizable;
  final DateTime createdAt;

  ProductModel({
    required this.id,
    required this.sellerId,
    required this.storeName,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.stock,
    this.sizes = const [],
    this.isDrop = false,
    this.dropEndTime,
    this.isCustomizable = false,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'sellerId': sellerId,
      'storeName': storeName,
      'title': title,
      'description': description,
      'price': price,
      'category': category,
      'imageUrl': imageUrl,
      'stock': stock,
      'sizes': sizes,
      'isDrop': isDrop,
      'dropEndTime':
          dropEndTime != null ? Timestamp.fromDate(dropEndTime!) : null,
      'isCustomizable': isCustomizable,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory ProductModel.fromMap(String id, Map<String, dynamic> map) {
    return ProductModel(
      id: id,
      sellerId: map['sellerId'] ?? '',
      storeName: map['storeName'] ?? 'Tienda',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      category: map['category'] ?? 'ropa',
      imageUrl: map['imageUrl'] ?? '',
      stock: map['stock'] ?? 0,
      sizes: List<String>.from(map['sizes'] ?? []),
      isDrop: map['isDrop'] ?? false,
      dropEndTime: (map['dropEndTime'] as Timestamp?)?.toDate(),
      isCustomizable: map['isCustomizable'] ?? false,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
