import 'package:ecommerce/bissness_logic/auth/cubit/auth_cubit.dart';
import 'package:ecommerce/bissness_logic/firebase/cubit/firebase_cubit.dart';
import 'package:ecommerce/bissness_logic/notification.dart';
import 'package:ecommerce/constants/strings.dart';
import 'package:ecommerce/data/model/shared_prefrence.dart';
import 'package:ecommerce/generated/l10n.dart';
import 'package:ecommerce/presentation/screens/bottomnav.dart';
import 'package:ecommerce/presentation/screens/login_screen.dart';
import 'package:ecommerce/presentation/screens/onboard_screen.dart';
import 'package:ecommerce/presentation/screens/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_localization/flutter_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load();
  Stripe.publishableKey = dotenv.env["PUBLISH_KEY"]!;

  final NotificationsHelper notificationsHelper = NotificationsHelper();
  await notificationsHelper.initNotifications();
  notificationsHelper.handleBackgroundNotifications();
  late bool? seen;
  SharedPrefrenceHelper sharedPrefrenceHelper = SharedPrefrenceHelper();

  Future<bool?> getseemOnboard() async {
    return seen = await sharedPrefrenceHelper.getOnboard();
  }

  String? Id;
  Future<void> getthesharedref() async {
    Id = await SharedPrefrenceHelper().getUserId();
  }

  void sendNotify(String? Id) async {
    if (Id != null) {
      String? fcmToken = notificationsHelper.deviceToken;

      if (fcmToken == null) {
        print("Error: device token is null");
        return;
      }

      print('-----------------------------------------');
      print(fcmToken);
      print('-----------------------------------------');

      String? title = " يوسف";
      String? body = " عامل اي ";
      String? userId = Id;
      String? type;

      await notificationsHelper.sendNotification(
          fcmToken: fcmToken, title: title!, body: body!, userId: userId!);
    } else {
      print("Error: User ID is null");
    }
  }

  await getthesharedref();

  sendNotify(Id);

  runApp(MultiBlocProvider(providers: [
    BlocProvider<AuthCubit>(create: (context) => AuthCubit()),
    BlocProvider<FirebaseCubit>(create: (context) => FirebaseCubit()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool?> _getSeenOnboarding() async {
    SharedPrefrenceHelper sharedPrefrenceHelper = SharedPrefrenceHelper();
    return await sharedPrefrenceHelper.getOnboard();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool?>(
        future: _getSeenOnboarding(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasData && snapshot.data == true) {
            return const LoginScreen();
          } else {
            return const OnboardScreen();
          }
        },
      ),
    );
  }
}
