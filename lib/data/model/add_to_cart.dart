class AddToCart {
  final String id;
  final String name;
  final String price;
  final String image;
  final String details;
  final String quantity;

  AddToCart({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.details,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'price': price,
      'image': image,
      'details': details,
      'quantity': quantity,
    };
  }

  factory AddToCart.fromJson(Map<String, dynamic> json) {
    return AddToCart(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      image: json['image'],
      details: json['details'],
      quantity: json['quantity'],
    );
  }
}
