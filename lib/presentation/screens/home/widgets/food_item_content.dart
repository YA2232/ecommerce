import 'package:ecommerce/bissness_logic/firebase/cubit/firebase_cubit.dart';
import 'package:ecommerce/data/model/add_food_item.dart';
import 'package:ecommerce/presentation/screens/home/widgets/horizontal_food_list.dart';
import 'package:ecommerce/presentation/screens/home/widgets/vertical_food_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FoodItemsContent extends StatelessWidget {
  final ValueChanged<String> onCategoryChanged;

  const FoodItemsContent({required this.onCategoryChanged});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FirebaseCubit, FirebaseState>(
      builder: (context, state) {
        if (state is LoadingFirebase) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ErorrFirebase) {
          state.showErorr(context);
          return const SizedBox();
        } else if (state is Pizza ||
            state is Salad ||
            state is Burger ||
            state is Icecream) {
          final items = _getItemsFromState(state);
          return Column(
            children: [
              HorizontalFoodList(items: items),
              VerticalFoodList(items: items),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }

  List<AddFoodItem> _getItemsFromState(FirebaseState state) {
    if (state is Pizza) return state.pizzaList;
    if (state is Salad) return state.saladList;
    if (state is Burger) return state.burgerList;
    if (state is Icecream) return state.icecreamList;
    return [];
  }
}
