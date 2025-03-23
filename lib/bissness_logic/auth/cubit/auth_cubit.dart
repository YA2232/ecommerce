import 'package:bloc/bloc.dart';
import 'package:ecommerce/data/model/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  FirebaseAuth _auth = FirebaseAuth.instance;

  // Future<void> login(
  //     String email, String password, BuildContext context) async {
  //   emit(LoadingAuth());
  //   try {
  //     await _auth.signInWithEmailAndPassword(email: email, password: password);
  //     emit(SuccssedAuth());
  //   } on FirebaseAuthException catch (e) {
  //     emit(ErorrAuth(erorr: e));
  //   }
  // }
  Future<void> login(String email, String password) async {
    emit(LoadingAuth());
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      emit(SuccessAuth());
    } on FirebaseAuthException catch (e) {
      emit(ErrorAuth(errorMessage: e.message ?? "Authentication failed"));
    }
  }

  Future<void> signup(
      String email, String password, BuildContext context) async {
    emit(LoadingAuth());
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      emit(SuccessAuth());
    } on FirebaseAuthException catch (e) {
      emit(ErrorAuth(errorMessage: e.message ?? "Authentication failed"));
    }
  }

  Future<void> signout() async {
    emit(LoadingAuth());
    try {
      await _auth.signOut();
      emit(SuccessAuth());
    } on FirebaseAuthException catch (e) {
      emit(ErrorAuth(errorMessage: e.toString()));
    }
  }

  Future<void> delete() async {
    User? user = await _auth.currentUser;
    user?.delete();
  }
}
