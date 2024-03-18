import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:foodevenproject/features/app/splash_screen/splash_screen.dart';
import 'package:foodevenproject/features/user_auth/presentation/admin/home_admin.dart';
import 'package:foodevenproject/features/user_auth/presentation/pages/home_page.dart';
import 'package:foodevenproject/features/user_auth/presentation/pages/login_page.dart';
import 'package:foodevenproject/features/user_auth/presentation/pages/onboard.dart';
import 'package:foodevenproject/features/user_auth/presentation/pages/bottomnav.dart';
import 'package:foodevenproject/features/user_auth/presentation/pages/sign_up_page.dart';
import 'package:foodevenproject/firebase_options.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart'; // Import Razorpay SDK
import 'package:foodevenproject/features/user_auth/presentation/service/shared_pref.dart'; // Import your SharedPreferenceHelper class

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Razorpay with your actual Razorpay Key ID
  Razorpay razorpay = Razorpay();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Fetch userId from SharedPreferences
  String? userId = await SharedPreferenceHelper()
      .getUserId(); // Get userId using SharedPreferenceHelper

  runApp(MyApp(userId: userId, razorpay: razorpay)); // Pass userId to MyApp
}

class MyApp extends StatelessWidget {
  final String? userId; // Declare userId as a property
  final Razorpay razorpay; // Declare Razorpay instance as a property

  MyApp(
      {required this.userId,
      required this.razorpay}); // Constructor to receive userId and Razorpay instance

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FoodEven',
      routes: {
        '/': (context) => SplashScreen(
              child: Onboard(),
            ),
        '/login': (context) => LoginPage(),
        '/signUp': (context) => SignUp(),
        '/home': (context) => Home(),
        '/bottomnav': (context) =>
            BottomNav(userId: userId ?? ''), // Add a null check to userId
// Assert that userId is not null
      },
    );
  }
}
