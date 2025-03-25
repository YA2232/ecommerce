import 'package:ecommerce/bissness_logic/firebase/cubit/firebase_cubit.dart';
import 'package:ecommerce/data/model/add_food_item.dart';
import 'package:ecommerce/presentation/screens/details.dart';
import 'package:ecommerce/presentation/screens/my_order_tracking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  late FirebaseCubit firebaseCubit;

  final List categories = [
    {"name": "men", "path": "assets/images/men.webp", "color": Colors.blue},
    {"name": "women", "path": "assets/images/women.webp", "color": Colors.pink},
    {
      "name": "unisex",
      "path": "assets/images/unisex.webp",
      "color": Colors.purple
    },
    {
      "name": "children",
      "path": "assets/images/unisex.webp",
      "color": Colors.orange
    },
  ];

  @override
  void initState() {
    super.initState();
    firebaseCubit = BlocProvider.of<FirebaseCubit>(context);
    firebaseCubit.getFoodItem('men');
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello,",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                ),
              ),
              const Text(
                "Find Your Perfume",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ],
          ),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyOrderTracking()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ChoiceChip(
              label: Text(
                categories[index]['name'],
                style: TextStyle(
                  color: selectedIndex == index ? Colors.white : Colors.black,
                ),
              ),
              selected: selectedIndex == index,
              selectedColor: categories[index]['color'],
              backgroundColor: Colors.grey.shade200,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              onSelected: (selected) {
                setState(() {
                  selectedIndex = index;
                  firebaseCubit.getFoodItem(categories[index]['name']);
                });
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildFoodItemCard(AddFoodItem foodItem) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Details(
                details: foodItem.details,
                name: foodItem.name,
                price: foodItem.price,
                image: foodItem.image!,
              ),
            ),
          );
          firebaseCubit.getFoodItem(categories[selectedIndex]['name']);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: AspectRatio(
                aspectRatio: 1.5,
                child: foodItem.image != null && foodItem.image!.isNotEmpty
                    ? Image.network(
                        foodItem.image!,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        "assets/images/welcome.jpg",
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    foodItem.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    foodItem.details,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "\$${foodItem.price}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.teal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalFoodList(List<AddFoodItem> items) {
    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          return SizedBox(
            width: 180,
            child: _buildFoodItemCard(items[index]),
          );
        },
      ),
    );
  }

  Widget _buildVerticalFoodList(List<AddFoodItem> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _buildFoodItemCard(items[index]);
      },
    );
  }

  Widget _buildContent() {
    return BlocBuilder<FirebaseCubit, FirebaseState>(
      builder: (context, state) {
        if (state is LoadingFirebase) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ErorrFirebase) {
          state.showErorr(context);
          return Container();
        } else if (state is Pizza) {
          return Column(
            children: [
              _buildHorizontalFoodList(state.pizzaList),
              _buildVerticalFoodList(state.pizzaList),
            ],
          );
        } else if (state is Salad) {
          return Column(
            children: [
              _buildHorizontalFoodList(state.saladList),
              _buildVerticalFoodList(state.saladList),
            ],
          );
        } else if (state is Burger) {
          return Column(
            children: [
              _buildHorizontalFoodList(state.burgerList),
              _buildVerticalFoodList(state.burgerList),
            ],
          );
        } else if (state is Icecream) {
          return Column(
            children: [
              _buildHorizontalFoodList(state.icecreamList),
              _buildVerticalFoodList(state.icecreamList),
            ],
          );
        }
        return Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(),
              _buildCategoryChips(),
              const SizedBox(height: 16),
              _buildContent(),
            ],
          ),
        ),
      ),
    );
  }
}
