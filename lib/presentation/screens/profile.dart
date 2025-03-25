import 'dart:io';

import 'package:ecommerce/bissness_logic/auth/cubit/auth_cubit.dart';
import 'package:ecommerce/bissness_logic/firebase/cubit/firebase_cubit.dart';
import 'package:ecommerce/data/model/shared_prefrence.dart';
import 'package:ecommerce/data/model/user_model.dart';
import 'package:ecommerce/presentation/screens/login_screen.dart';
import 'package:ecommerce/presentation/screens/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? profile, name, email;
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  AuthCubit authCubit = AuthCubit();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage = File(image.path);
      setState(() {
        uploadItem();
      });
    }
  }

  uploadItem() async {
    if (selectedImage != null) {
      String addId = randomAlphaNumeric(10);
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child("blogImages").child(addId);
      final UploadTask task = firebaseStorageRef.putFile(selectedImage!);
      var downloadUrl = await (await task).ref.getDownloadURL();
      await SharedPrefrenceHelper().saveUserProfile(downloadUrl);
      setState(() {
        profile = downloadUrl;
      });
    }
  }

  getUserData() async {
    BlocProvider.of<FirebaseCubit>(context)
        .getUserData(firebaseAuth.currentUser!.uid);
    setState(() {});
  }

  onthisload() async {
    await getUserData();
    setState(() {});
  }

  @override
  void initState() {
    onthisload();
    super.initState();
  }

  Widget _buildProfileHeader(UserModel user) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 220,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
        Positioned(
          top: 50,
          child: Column(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: ClipOval(
                  child: selectedImage != null
                      ? Image.file(selectedImage!, fit: BoxFit.cover)
                      : profile == null
                          ? IconButton(
                              icon: const Icon(Icons.person,
                                  size: 50, color: Colors.white),
                              onPressed: getImage,
                            )
                          : Image.network(
                              profile!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => IconButton(
                                icon: const Icon(Icons.person,
                                    size: 50, color: Colors.white),
                                onPressed: getImage,
                              ),
                            ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                user.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                user.email,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileItem(IconData icon, String title, String? subtitle,
      {VoidCallback? onTap}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<FirebaseCubit, FirebaseState>(
        builder: (context, state) {
          if (state is UserDataLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserDataLoaded) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildProfileHeader(state.userModel),
                  const SizedBox(height: 20),
                  _buildProfileItem(
                    Icons.person,
                    "Name",
                    state.userModel.name,
                  ),
                  _buildProfileItem(
                    Icons.email,
                    "Email",
                    state.userModel.email,
                  ),
                  _buildProfileItem(
                    Icons.description,
                    "Terms and Conditions",
                    null,
                  ),
                  _buildProfileItem(
                    Icons.delete,
                    "Delete Account",
                    null,
                    onTap: () {
                      authCubit.delete();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Signup()),
                      );
                    },
                  ),
                  _buildProfileItem(
                    Icons.logout,
                    "Logout",
                    null,
                    onTap: () {
                      authCubit.signout();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
