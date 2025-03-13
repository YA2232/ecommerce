import 'package:flutter/material.dart';

class AdminProducts extends StatelessWidget {
  AdminProducts({super.key});
  List<String> items = ["Ice Cream", "Burger", "Pizza", "Salad"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "My Products",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 5),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return itemCard(items[index]);
          },
        ),
      ),
    );
  }

  void navigateTo(String nameOfItem) {
    if (nameOfItem == "Ice Cream") {}
  }

  Widget itemCard(String nameItem) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black,
      ),
      child: Center(
        child: Text(
          nameItem,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
