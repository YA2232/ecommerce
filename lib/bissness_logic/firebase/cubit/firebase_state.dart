part of 'firebase_cubit.dart';

@immutable
sealed class FirebaseState {}

final class FirebaseInitial extends FirebaseState {}

final class LoadingFirebase extends FirebaseState {}

final class SuccessedFirebase extends FirebaseState {}

final class Pizza extends FirebaseState {
  List<AddFoodItem> pizzaList;
  Pizza({required this.pizzaList});
}

final class Icecream extends FirebaseState {
  List<AddFoodItem> icecreamList;
  Icecream({required this.icecreamList});
}

final class Burger extends FirebaseState {
  List<AddFoodItem> burgerList;
  Burger({required this.burgerList});
}

final class Salad extends FirebaseState {
  List<AddFoodItem> saladList;
  Salad({required this.saladList});
}

final class SuccessedFoodCart extends FirebaseState {
  List<AddToCart> listFoodCart;
  SuccessedFoodCart({required this.listFoodCart});
}

final class SuccessedProfileImage extends FirebaseState {
  File selectedImage;
  SuccessedProfileImage({required this.selectedImage});
}

final class UserDataLoaded extends FirebaseState {
  UserModel userModel;
  UserDataLoaded({required this.userModel});
}

final class UserDataLoading extends FirebaseState {}

final class UserDataError extends FirebaseState {}

final class OrderLoading extends FirebaseState {}

final class OrdersUserLoaded extends FirebaseState {
  List<OrderModel> list;
  OrdersUserLoaded({required this.list});
}

final class AllOrdersLoaded extends FirebaseState {
  List<OrderModel> list;
  AllOrdersLoaded({required this.list});
}

final class OrderError extends FirebaseState {}

final class ErorrFirebase extends FirebaseState {
  String e;
  ErorrFirebase({required this.e});
  showErorr(BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          e,
          style: TextStyle(color: Colors.white),
        )));
  }
}
