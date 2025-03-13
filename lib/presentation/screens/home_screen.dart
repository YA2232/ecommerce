import 'package:ecommerce/bissness_logic/firebase/cubit/firebase_cubit.dart';
import 'package:ecommerce/data/model/add_food_item.dart';
import 'package:ecommerce/presentation/screens/details.dart';
import 'package:ecommerce/presentation/widgets/category_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  bool iceCream = false;
  bool pizza = false;
  bool salad = false;
  bool burger = false;
  late FirebaseCubit firebaseCubit;

  final List categories = [
    {"name": "pizza", "path": "assets/images/pizza.jpeg"},
    {"name": "burger", "path": "assets/images/burger.jpeg"},
    {"name": "salad", "path": "assets/images/salad.jpeg"},
    {"name": "icecream", "path": "assets/images/icecream.jpeg"},
  ];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    firebaseCubit.getFoodItem(categories[selectedIndex]['name']!);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseCubit = BlocProvider.of<FirebaseCubit>(context);
    firebaseCubit.getFoodItem('pizza');
  }

  Widget buildFoodItem(List list) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
          itemCount: list.length,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: (context, i) {
            AddFoodItem foodItem = list[i];
            return GestureDetector(
              onTap: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Details(
                              details: foodItem.details,
                              name: foodItem.name,
                              price: foodItem.price,
                              image: foodItem.image!,
                            )));
                firebaseCubit.getFoodItem('pizza');
              },
              child: Container(
                margin: const EdgeInsets.all(10),
                child: Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          (foodItem.image != null && foodItem.image!.isNotEmpty)
                              ? Image.network(
                                  foodItem.image!,
                                  width: 200,
                                  height: 150,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  "assets/images/welcome.jpg",
                                  width: 200,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                          Text(
                            foodItem.name,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            "frech and healthy",
                            style: TextStyle(color: Colors.grey, fontSize: 11),
                          ),
                          Text(
                            "\$" + foodItem.price,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget foodItemVertically(List list) {
    return ListView.builder(
      itemCount: list.length,
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, i) {
        AddFoodItem foodItem = list[i];
        return GestureDetector(
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
            firebaseCubit.getFoodItem('pizza');
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                        child: (foodItem.image != null &&
                                foodItem.image!.isNotEmpty)
                            ? Image.network(
                                foodItem.image!,
                                width: 200,
                                height: 150,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                "assets/images/welcome.jpg",
                                width: 200,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              foodItem.name,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              "Honey for eating",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "\$${foodItem.price}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildAllItems() {
    return BlocBuilder<FirebaseCubit, FirebaseState>(builder: (context, state) {
      if (state is LoadingFirebase) {
        return Container(child: Center(child: CircularProgressIndicator()));
      } else if (state is ErorrFirebase) {
        state.showErorr(context);
      } else if (state is Pizza) {
        return buildFoodItem(state.pizzaList);
      } else if (state is Salad) {
        return buildFoodItem(state.saladList);
      } else if (state is Burger) {
        return buildFoodItem(state.burgerList);
      } else if (state is Icecream) {
        return buildFoodItem(state.icecreamList);
      }
      return Container();
    });
  }

  Widget buildAllItemsVertical() {
    return BlocBuilder<FirebaseCubit, FirebaseState>(builder: (context, state) {
      if (state is LoadingFirebase) {
        return Container(child: Center(child: CircularProgressIndicator()));
      } else if (state is ErorrFirebase) {
        state.showErorr(context);
      } else if (state is Pizza) {
        return foodItemVertically(state.pizzaList);
      } else if (state is Salad) {
        return foodItemVertically(state.saladList);
      } else if (state is Burger) {
        return foodItemVertically(state.burgerList);
      } else if (state is Icecream) {
        return foodItemVertically(state.icecreamList);
      }
      return Container();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Hi Ecommerce",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Delicies Food",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 24),
              ),
              const Text(
                "Discover and get ceat food",
                style: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w500,
                    fontSize: 18),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: CategoryItem(
                        pathFoto: categories[index]['path']!,
                        isSelected: selectedIndex == index,
                        onTap: () {
                          setState(() {
                            firebaseCubit
                                .getFoodItem(categories[index]['name']!);
                            selectedIndex = index;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(height: 250, child: buildAllItems()),
              const SizedBox(
                height: 20,
              ),
              buildAllItemsVertical(),
            ],
          ),
        ),
      ),
    );
  }
}
