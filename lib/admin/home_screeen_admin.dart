import 'package:ecommerce/admin/add_food.dart';
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
      body: Container(
        margin: EdgeInsets.only(top: 50, right: 20, left: 20),
        child: Column(
          children: [
            Center(
                child: Text(
              "Home Admin",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            )),
            SizedBox(
              height: 40,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddFood()));
              },
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Image.asset(
                          "assets/images/pexels-maxfrancis-2246476.jpg",
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Text(
                        "Add Food Items",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
