import 'dart:io';
import 'package:ecommerce/bissness_logic/auth/cubit/auth_cubit.dart';
import 'package:ecommerce/bissness_logic/firebase/cubit/firebase_cubit.dart';
import 'package:ecommerce/data/shared_pref/shared_prefrence.dart';
import 'package:ecommerce/data/model/user_model.dart';
import 'package:ecommerce/presentation/screens/profile/widgets/profile_header.dart';
import 'package:ecommerce/presentation/screens/profile/widgets/profile_item_list.dart';
import 'package:ecommerce/presentation/screens/auth/login_screen.dart';
import 'package:ecommerce/presentation/screens/auth/signup.dart';
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
  File? _selectedImage;
  String? _profileImageUrl;
  final ImagePicker _imagePicker = ImagePicker();
  final AuthCubit _authCubit = AuthCubit();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      context.read<FirebaseCubit>().getUserData(currentUser.uid);
    }
  }

  Future<void> _pickAndUploadImage() async {
    final pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() => _selectedImage = File(pickedImage.path));
      await _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) return;

    try {
      final imageId = randomAlphaNumeric(10);
      final storageRef =
          FirebaseStorage.instance.ref().child("profileImages").child(imageId);

      final uploadTask = storageRef.putFile(_selectedImage!);
      final downloadUrl = await (await uploadTask).ref.getDownloadURL();

      await SharedPrefrenceHelper().saveUserProfile(downloadUrl);
      setState(() => _profileImageUrl = downloadUrl);
    } catch (e) {
      _showErrorSnackbar("Failed to upload image");
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _handleLogout() {
    _authCubit.signout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void _handleDeleteAccount() {
    _authCubit.delete();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Signup()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<FirebaseCubit, FirebaseState>(
        builder: (context, state) {
          if (state is UserDataLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UserDataLoaded) {
            return _buildProfileContent(state.userModel);
          }

          return const Center(child: Text("No user data available"));
        },
      ),
    );
  }

  Widget _buildProfileContent(UserModel user) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ProfileHeader(
            profileImageUrl: _profileImageUrl,
            selectedImage: _selectedImage,
            userName: user.name,
            userEmail: user.email,
            onImagePressed: _pickAndUploadImage,
          ),
          const SizedBox(height: 20),
          ProfileItemList(
            user: user,
            onLogout: _handleLogout,
            onDeleteAccount: _handleDeleteAccount,
          ),
        ],
      ),
    );
  }
}
