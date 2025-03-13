import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/admin/home_screeen_admin.dart';
import 'package:ecommerce/data/model/add_food_item.dart';
import 'package:ecommerce/data/model/add_to_cart.dart';
import 'package:ecommerce/data/model/shared_prefrence.dart';
import 'package:ecommerce/data/model/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:random_string/random_string.dart';

part 'firebase_state.dart';

class FirebaseCubit extends Cubit<FirebaseState> {
  FirebaseCubit() : super(FirebaseInitial());
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final SharedPrefrenceHelper pref = SharedPrefrenceHelper();
  ImagePicker picker = ImagePicker();
  File? selectedImage;

  Future<void> getImage() async {
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      print("no foto");
    } else {
      selectedImage = File(image.path);
      emit(SuccessedFirebase());
    }
  }

  Future<void> addUserData(UserModel userData, String userId) async {
    await firestore.collection('user').doc(userId).set(userData.toJson());
  }

  Future<void> updateDeviceToken(String deviceToken, String userId) async {
    await firestore
        .collection('user')
        .doc(userId)
        .set({"deviceToken": deviceToken});
  }

  Future<void> updateUserWallet(String amount, String UserId) async {
    await firestore.collection("user").doc(UserId).update({'wallet': amount});
    emit(SuccessedFirebase());
  }

  Future<void> addFoodItem(
      AddFoodItem foodData, BuildContext context, String collectionName) async {
    emit(LoadingFirebase());
    try {
      // Reference reference = firebaseStorage.ref().child("belong").child(id);
      // final TaskSnapshot snapshot = await reference.putFile(selectedImage!);
      // var downloadUrl = await snapshot.ref.getDownloadURL();
      await firestore
          .collection(collectionName)
          .doc(foodData.id)
          .set(foodData.toJson());

      emit(SuccessedFirebase());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.orange,
          content: Text(
            "Successed",
            style: TextStyle(color: Colors.white),
          )));
    } catch (e) {
      emit(ErorrFirebase(e: e.toString()));
    }
  }

  Future<void> addToCart(AddToCart addToCart, String userId, String productId,
      BuildContext context) async {
    emit(LoadingFirebase());
    try {
      await firestore
          .collection('user')
          .doc(userId)
          .collection("cart")
          .doc(productId)
          .set(addToCart.toJson());
      emit(SuccessedFirebase());
    } catch (e) {
      emit(ErorrFirebase(e: e.toString()));
    }
  }

  void getFoodItem(String collection) {
    emit(LoadingFirebase());
    try {
      firestore.collection(collection).snapshots().listen((snapshot) {
        List<AddFoodItem> listFoodItem = snapshot.docs
            .map((doc) => AddFoodItem.fromJson(doc.data()))
            .toList();
        if (collection == 'icecream') {
          emit(Icecream(icecreamList: listFoodItem));
        } else if (collection == 'salad') {
          emit(Salad(saladList: listFoodItem));
        } else if (collection == 'burger') {
          emit(Burger(burgerList: listFoodItem));
        } else if (collection == 'pizza') {
          emit(Pizza(pizzaList: listFoodItem));
        }
      });
    } catch (e) {
      emit(ErorrFirebase(e: e.toString()));
    }
  }

  void getFoodCart(String userId) {
    emit(LoadingFirebase());
    try {
      firestore
          .collection('user')
          .doc(userId)
          .collection("cart")
          .snapshots()
          .listen((snapshot) {
        List<AddToCart> listFoodCart =
            snapshot.docs.map((doc) => AddToCart.fromJson(doc.data())).toList();
        emit(SuccessedFoodCart(listFoodCart: listFoodCart));
      });
    } catch (e) {
      emit(ErorrFirebase(e: e.toString()));
    }
  }

  void removeFromCart(String userId, String productId) {
    firestore
        .collection("user")
        .doc(userId)
        .collection("cart")
        .doc(productId)
        .delete();
    emit(SuccessedFirebase());
  }

  Future<void>? loginAdmin(
      String userName, String password, BuildContext context) {
    emit(LoadingFirebase());
    try {
      firestore.collection("Admin").get().then((snapshot) {
        snapshot.docs.forEach((doc) {
          if (doc['userName'] != userName) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red,
                content: Text("userName is not found")));
          } else if (doc['password'] != password) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red,
                content: Text("password is wrong")));
          } else {
            emit(SuccessedFirebase());
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => HomeScreeenAdmin()));
          }
        });
      });
    } catch (e) {
      emit(ErorrFirebase(e: e.toString()));
    }
  }
}
