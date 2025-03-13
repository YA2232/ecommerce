class AddFoodItem {
  final String name;
  final String id;
  final String price;
  final String? image;
  final String details;

  AddFoodItem({
    required this.name,
    required this.id,
    required this.price,
    this.image,
    required this.details,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'price': price,
      'image': image,
      'details': details,
    };
  }

  factory AddFoodItem.fromJson(Map<String, dynamic> json) {
    return AddFoodItem(
      name: json['name'],
      id: json['id'],
      price: json['price'],
      image: json['image'],
      details: json['details'],
    );
  }
}
