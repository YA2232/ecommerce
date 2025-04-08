import 'package:ecommerce/bissness_logic/firebase/cubit/firebase_cubit.dart';
import 'package:ecommerce/presentation/screens/order/widgets/empty_state.dart';
import 'package:ecommerce/presentation/screens/order/widgets/loading_indicator.dart';
import 'package:ecommerce/presentation/screens/order/widgets/not_data_avilable.dart';
import 'package:ecommerce/presentation/screens/order/widgets/order_list.dart';
import 'package:ecommerce/presentation/screens/order/widgets/order_tracking_view.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderTab extends StatelessWidget {
  final OrderStatus status;
  const OrderTab({required this.status});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FirebaseCubit, FirebaseState>(
      builder: (context, state) {
        if (state is OrderLoading) {
          return const LoadingIndicator();
        } else if (state is OrdersUserLoaded) {
          final orders = state.list
              .where((order) => order.status == status.value)
              .toList();

          if (orders.isEmpty) {
            return EmptyState(status: status.displayName);
          }

          return OrderList(orders: orders);
        }
        return NoDataAvailable();
      },
    );
  }
}
