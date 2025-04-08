import 'package:ecommerce/bissness_logic/firebase/cubit/firebase_cubit.dart';
import 'package:ecommerce/data/model/add_food_item.dart';
import 'package:ecommerce/data/model/category.dart';
import 'package:ecommerce/presentation/screens/details_product/details.dart';
import 'package:ecommerce/presentation/screens/home/widgets/app_bar_header.dart';
import 'package:ecommerce/presentation/screens/home/widgets/category_selector.dart';
import 'package:ecommerce/presentation/screens/home/widgets/food_item_content.dart';
import 'package:ecommerce/presentation/screens/order/my_order_tracking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategoryIndex = 0;
  late final FirebaseCubit _firebaseCubit;

  final List<Category> _categories = [
    Category(name: "men", path: "assets/images/men.webp", color: Colors.blue),
    Category(
        name: "women", path: "assets/images/women.webp", color: Colors.pink),
    Category(
        name: "unisex",
        path: "assets/images/unisex.webp",
        color: Colors.purple),
    Category(
        name: "children",
        path: "assets/images/unisex.webp",
        color: Colors.orange),
  ];

  @override
  void initState() {
    super.initState();
    _firebaseCubit = BlocProvider.of<FirebaseCubit>(context);
    _loadInitialData();
  }

  void _loadInitialData() {
    _firebaseCubit.getFoodItem(_categories[_selectedCategoryIndex].name);
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
              const AppBarHeader(),
              CategorySelector(
                categories: _categories,
                selectedIndex: _selectedCategoryIndex,
                onCategorySelected: _handleCategorySelection,
              ),
              const SizedBox(height: 16),
              FoodItemsContent(
                onCategoryChanged: (category) =>
                    _firebaseCubit.getFoodItem(category),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleCategorySelection(int index) {
    setState(() => _selectedCategoryIndex = index);
    _firebaseCubit.getFoodItem(_categories[index].name);
  }
}
