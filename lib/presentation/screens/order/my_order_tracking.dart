import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:ecommerce/bissness_logic/firebase/cubit/firebase_cubit.dart';
import 'package:ecommerce/data/model/order_model.dart';
import 'package:ecommerce/presentation/screens/order/details_order.dart';
import 'package:ecommerce/presentation/screens/order/widgets/order_tracking_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class MyOrderTracking extends StatelessWidget {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  MyOrderTracking({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          FirebaseCubit()..getOrderUser(_firebaseAuth.currentUser?.uid ?? ''),
      child: OrderTrackingView(),
    );
  }
}
