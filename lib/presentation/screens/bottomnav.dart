import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:ecommerce/presentation/screens/home_screen.dart';
import 'package:ecommerce/presentation/screens/order.dart';
import 'package:ecommerce/presentation/screens/profile.dart';
import 'package:flutter/material.dart';

class Bottomnav extends StatefulWidget {
  const Bottomnav({super.key});

  @override
  State<Bottomnav> createState() => _BottomnavState();
}

class _BottomnavState extends State<Bottomnav> {
  int currentTapIndex = 0;
  late HomeScreen homeScreen;
  late Widget curruntPage;
  late List<Widget> pages;
  late Profile profile;
  late Order order;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    homeScreen = const HomeScreen();
    profile = Profile();
    order = Order();
    pages = [homeScreen, order, profile];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
          height: 60,
          backgroundColor: Colors.white,
          color: Colors.blue,
          animationDuration: const Duration(milliseconds: 500),
          onTap: (int index) {
            setState(() {
              currentTapIndex = index;
            });
          },
          items: const [
            Icon(
              Icons.home_outlined,
              color: Colors.white,
            ),
            Icon(
              Icons.shopping_bag_outlined,
              color: Colors.white,
            ),
            Icon(
              Icons.person_outline_outlined,
              color: Colors.white,
            ),
          ]),
      body: pages[currentTapIndex],
    );
  }
}
