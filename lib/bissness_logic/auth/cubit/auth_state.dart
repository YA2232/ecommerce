part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class LoadingAuth extends AuthState {}

final class SuccssedAuth extends AuthState {}

final class ErorrAuth extends AuthState {
  FirebaseAuthException erorr;
  ErorrAuth({required this.erorr});

  void showErorr(BuildContext context) {
    if (erorr.code == "user-not-found") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        content: Text("Not User Found"),
      ));
    } else if (erorr.code == "wrong-password") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        content: Text("Wrong password provided by user"),
      ));
    } else if (erorr.code == "email-already-in-use") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        content: Text("The email is already in use"),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text("Error: ${erorr.message}"),
      ));
    }
  }
}
