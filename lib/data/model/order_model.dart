import 'package:ecommerce/data/model/add_to_cart.dart';

class OrderModel {
  final String orderId;
  final String userId;
  final String name;
  final String address;
  final String phone;
  final double totalPrice;
  final dynamic list;
  final String status;
  final DateTime createdAt;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.name,
    required this.address,
    required this.phone,
    required this.totalPrice,
    required this.list,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      "orderId": orderId,
      "userId": userId,
      "name": name,
      "address": address,
      "list": list,
      "phone": phone,
      "totalPrice": totalPrice,
      "status": status,
      "createdAt": createdAt.toIso8601String(),
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['orderId'],
      userId: json['userId'],
      name: json['name'],
      address: json['address'],
      list: json['list'],
      phone: json['phone'],
      totalPrice: json['totalPrice'].toDouble(),
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
