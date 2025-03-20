import 'package:ecommerce/bissness_logic/auth/cubit/auth_cubit.dart';
import 'package:ecommerce/bissness_logic/firebase/cubit/firebase_cubit.dart';
import 'package:ecommerce/data/model/shared_prefrence.dart';
import 'package:ecommerce/presentation/screens/login_screen.dart';
import 'package:ecommerce/presentation/screens/onboard_screen.dart';
import 'package:ecommerce/presentation/screens/success.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");

  // ✅ التحقق من مفتاح Stripe قبل تعيينه
  String? publishKey = dotenv.env["PUBLISH_KEY"];
  if (publishKey != null) {
    Stripe.publishableKey = publishKey;
  } else {
    debugPrint("⚠️ تحذير: لم يتم العثور على مفتاح Stripe في .env");
  }

  // ✅ تحميل بيانات SharedPreferences
  SharedPrefrenceHelper sharedPrefrenceHelper = SharedPrefrenceHelper();
  bool? seen = await sharedPrefrenceHelper.getOnboard();
  String? Id = await sharedPrefrenceHelper.getUserId();

  runApp(MultiBlocProvider(providers: [
    BlocProvider<AuthCubit>(create: (context) => AuthCubit()),
    BlocProvider<FirebaseCubit>(create: (context) => FirebaseCubit()),
  ], child: MyApp(seen: seen)));
}

class MyApp extends StatelessWidget {
  final bool? seen;
  const MyApp({super.key, this.seen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: seen == true ? const LoginScreen() : const OnboardScreen(),
    );
  }
}
