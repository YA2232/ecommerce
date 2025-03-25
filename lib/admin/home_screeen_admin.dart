import 'package:ecommerce/admin/add_food.dart';
import 'package:ecommerce/admin/admin_login.dart';
import 'package:ecommerce/admin/admin_products.dart';
import 'package:ecommerce/admin/order_tracking.dart';
import 'package:flutter/material.dart';

class HomeScreeenAdmin extends StatefulWidget {
  const HomeScreeenAdmin({super.key});

  @override
  State<HomeScreeenAdmin> createState() => _HomeScreeenAdminState();
}

class _HomeScreeenAdminState extends State<HomeScreeenAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Admin Dashboard",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            ),
          ),
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF5F7FA), Color(0xFFE4E7EB)],
          ),
        ),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          shrinkWrap: true,
          children: [
            _buildFeatureCard(
              icon: Icons.add_circle_outline,
              title: "Add Food",
              color: const Color(0xFF6A11CB),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddFood()),
              ),
            ),
            _buildFeatureCard(
              icon: Icons.fastfood,
              title: "Products",
              color: const Color(0xFF2575FC),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminProducts()),
              ),
            ),
            _buildFeatureCard(
              icon: Icons.shopping_bag,
              title: "Orders",
              color: const Color(0xFF4CAF50),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OrderTracking()),
              ),
            ),
            _buildFeatureCard(
              icon: Icons.analytics,
              title: "Analytics",
              color: const Color(0xFFFF9800),
              onTap: () {
                // Add analytics screen navigation
              },
            ),
            _buildFeatureCard(
              icon: Icons.admin_panel_settings_outlined,
              title: "Log Out",
              color: const Color(0xFF9C27B0),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => AdminLogin()));
              },
            ),
            _buildFeatureCard(
              icon: Icons.settings,
              title: "Settings",
              color: const Color(0xFF607D8B),
              onTap: () {
                // Add settings screen navigation
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.8), color],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: Colors.white,
              ),
              const SizedBox(height: 15),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
