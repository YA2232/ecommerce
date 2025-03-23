import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/bissness_logic/auth/cubit/auth_cubit.dart';
import 'package:ecommerce/bissness_logic/firebase/cubit/firebase_cubit.dart';
import 'package:ecommerce/bissness_logic/notification.dart';
import 'package:ecommerce/data/model/auth.dart';
import 'package:ecommerce/data/model/shared_prefrence.dart';
import 'package:ecommerce/data/model/user_model.dart';
import 'package:ecommerce/presentation/screens/bottomnav.dart';
import 'package:ecommerce/presentation/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final SharedPrefrenceHelper sharedprefCubit = SharedPrefrenceHelper();
  final AuthCubit auth = AuthCubit();
  final FirebaseCubit firebaseCubit = FirebaseCubit();
  String name = "", email = "", password = "";
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final NotificationsHelper notificationsHelper = NotificationsHelper();
  final _formkey = GlobalKey<FormState>();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool isLoading = false;

  void registration() async {
    setState(() {
      isLoading = true;
    });

    try {
      await auth.signup(
          _emailController.text, _passwordController.text, context);

      User? user = await firebaseAuth.authStateChanges().first;
      if (user == null) {
        throw FirebaseAuthException(code: "user-not-found");
      }

      // تهيئة الإشعارات
      await notificationsHelper.initNotifications();

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.orange,
        content: Text("Registered Successfully"),
      ));

      // إضافة بيانات المستخدم إلى قاعدة البيانات
      firebaseCubit.addUserData(
        UserModel(
          email: _emailController.text,
          id: user.uid,
          name: _nameController.text,
          deviceToken: notificationsHelper.deviceToken ?? "",
          wallet: '0',
        ),
        user.uid,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Bottomnav()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == "weak-password") {
        errorMessage = "كلمة المرور ضعيفة جدًا";
      } else if (e.code == "email-already-in-use") {
        errorMessage = "الحساب موجود بالفعل";
      } else {
        errorMessage = "حدث خطأ أثناء التسجيل";
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.orange,
        content: Text(errorMessage),
      ));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: SingleChildScrollView(
          child: Container(
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFff5c30), Color(0xFFe74b1a)])),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 3),
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40))),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 60, left: 40, right: 40),
                  child: Column(
                    children: [
                      Center(
                        child: Image.asset(
                          "assets/images/restaurant.webp",
                          width: MediaQuery.of(context).size.width / 3,
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.only(right: 20, left: 30),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 2,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: Form(
                            key: _formkey,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 30,
                                ),
                                const Text(
                                  "Sign up",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  cursorColor: Colors.grey,
                                  controller: _nameController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter the name";
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.orange, width: 2)),
                                      hintText: "Name",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      prefixIcon: Icon(Icons.person)),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  cursorColor: Colors.grey,
                                  controller: _emailController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter the email";
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.orange, width: 2)),
                                      hintText: "Email",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      prefixIcon: Icon(Icons.email)),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  cursorColor: Colors.grey,
                                  controller: _passwordController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter the password";
                                    }
                                    return null;
                                  },
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.orange, width: 2)),
                                    hintText: "Password",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    prefixIcon: Icon(Icons.lock),
                                  ),
                                ),
                                const SizedBox(
                                  height: 50,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    if (_formkey.currentState!.validate()) {
                                      setState(() {
                                        email = _emailController.text;
                                        name = _nameController.text;
                                        password = _passwordController.text;
                                      });
                                    }
                                    registration();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    width: 200,
                                    decoration: BoxDecoration(
                                        color: const Color(0xFFff5c30),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: const Center(
                                      child: Text(
                                        "SIGN UP",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 70,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                        },
                        child: const Text(
                          "Already have an account? login",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
