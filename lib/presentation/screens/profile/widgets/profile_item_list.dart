import 'package:ecommerce/data/model/user_model.dart';
import 'package:ecommerce/presentation/screens/profile/widgets/profile_item.dart';
import 'package:flutter/material.dart';

class ProfileItemList extends StatelessWidget {
  final UserModel user;
  final VoidCallback onLogout;
  final VoidCallback onDeleteAccount;

  const ProfileItemList({
    required this.user,
    required this.onLogout,
    required this.onDeleteAccount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileItem(
          icon: Icons.person,
          title: "Name",
          subtitle: user.name,
        ),
        ProfileItem(
          icon: Icons.email,
          title: "Email",
          subtitle: user.email,
        ),
        ProfileItem(
          icon: Icons.description,
          title: "Terms and Conditions",
        ),
        ProfileItem(
          icon: Icons.delete,
          title: "Delete Account",
          onTap: onDeleteAccount,
        ),
        ProfileItem(
          icon: Icons.logout,
          title: "Logout",
          onTap: onLogout,
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
