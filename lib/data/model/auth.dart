import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future getCurruntUser() async {
    await _firebaseAuth.currentUser;
  }

  Future signOut() async {
    await _firebaseAuth.signOut();
  }

  Future deleteAccount() async {
    User? user = await _firebaseAuth.currentUser;
    user?.delete();
  }
}
