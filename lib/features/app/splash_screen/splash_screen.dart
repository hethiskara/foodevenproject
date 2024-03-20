import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  final Widget? child;
  const SplashScreen({Key? key, this.child}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    checkUserLoggedIn();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => widget.child!),
          (route) => false);
    });
    super.initState();
  }

  void checkUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (FirebaseAuth.instance.currentUser != null &&
        prefs.getBool('loggedIn') == true) {
      // User is already logged in, navigate to the main screen
      Navigator.pushReplacementNamed(context, "/bottomnav");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 400,
            ),
            SizedBox(
              width: 200, // Adjust width as needed
              height: 200, // Adjust height as needed
              child: Image.asset(
                "images/logo.png",
                fit: BoxFit.contain,
              ),
            ),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
