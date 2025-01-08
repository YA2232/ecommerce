class UserModel {
  String name;
  String email;
  String id;
  String wallet;
  String deviceToken;
  UserModel(
      {required this.email,
      required this.id,
      required this.name,
      required this.deviceToken,
      required this.wallet});
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        email: json['email'],
        id: json['id'],
        name: json['name'],
        deviceToken: json['deviceToken'],
        wallet: json['wallet']);
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'wallet': wallet,
      'deviceToken': deviceToken,
    };
  }
}
