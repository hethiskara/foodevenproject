import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodevenproject/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:foodevenproject/features/user_auth/presentation/admin/admin_login.dart';
import 'package:foodevenproject/features/user_auth/presentation/pages/bottomnav.dart';
import 'package:foodevenproject/features/user_auth/presentation/pages/forgotpassword.dart';
import 'package:foodevenproject/features/user_auth/presentation/pages/sign_up_page.dart';
import 'package:foodevenproject/features/user_auth/presentation/service/shared_pref.dart';
import 'package:foodevenproject/features/user_auth/presentation/widgets/widget_support.dart';
import 'package:foodevenproject/global/common/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LogInState();
}

class _LogInState extends State<LoginPage> {
  String email = "", password = "";
  bool _isSigning = false;
  final FirebaseAuthService _auth = FirebaseAuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    checkUserLoggedIn();
  }

  void checkUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (FirebaseAuth.instance.currentUser != null &&
        prefs.getBool('loggedIn') == true) {
      // User is already logged in, navigate to the main screen
      Navigator.pushReplacementNamed(context, "/bottomnav");
    }
  }

  TextEditingController useremailcontroller = new TextEditingController();
  TextEditingController userpasswordcontroller = new TextEditingController();

  @override
  void dispose() {
    useremailcontroller.dispose();
    userpasswordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.5,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                    Color.fromARGB(255, 0, 0, 0),
                    Color(0xFFe74b1a),
                  ])),
            ),
            Container(
              margin:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40))),
              child: Text(""),
            ),
            Container(
              margin: EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                        child: Image.asset(
                      "images/logo.png",
                      width: MediaQuery.of(context).size.width / 1.5,
                      fit: BoxFit.cover,
                    )),
                    SizedBox(
                      height: 50.0,
                    ),
                    Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 1.5,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Form(
                          key: _formkey,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 30.0,
                              ),
                              Text(
                                "Login",
                                style: AppWidget.HeadlineTextFeildStyle(),
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              TextFormField(
                                controller: useremailcontroller,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Email';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    hintText: 'Email',
                                    hintStyle:
                                        AppWidget.semiBoldTextFeildStyle(),
                                    prefixIcon: Icon(Icons.email_outlined)),
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              TextFormField(
                                controller: userpasswordcontroller,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Password';
                                  }
                                  return null;
                                },
                                obscureText: true,
                                decoration: InputDecoration(
                                    hintText: 'Password',
                                    hintStyle:
                                        AppWidget.semiBoldTextFeildStyle(),
                                    prefixIcon: Icon(Icons.password_outlined)),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ForgotPassword()));
                                },
                                child: Container(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      "Forgot Password?",
                                      style: TextStyle(
                                          color: Color(0Xffff5722),
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Poppins'),
                                    )),
                              ),
                              SizedBox(
                                height: 80.0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  _signIn();
                                },
                                child: Material(
                                  elevation: 5.0,
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.0),
                                    width: 200,
                                    decoration: BoxDecoration(
                                        color: Color(0Xffff5722),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Center(
                                        child: _isSigning
                                            ? CircularProgressIndicator(
                                                color: Colors.white)
                                            : Text(
                                                "LOGIN",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18.0,
                                                    fontFamily: 'Poppins1',
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                  ),
                                ),
                              ),
                              SizedBox(height: 50), // Add some spacing
                              // Text for admin login
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AdminLogin()),
                                  );
                                  // Navigate to admin login page
                                },
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: Colors
                                          .black, // Default color for other text
                                      fontSize: 16.0,
                                      fontFamily: 'Poppins1',
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "If you are an admin, ",
                                      ),
                                      TextSpan(
                                        text: "login here",
                                        style: TextStyle(
                                          color: Color(
                                              0Xffff5722), // Separate color for this text
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 70.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUp()),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          style: AppWidget.semiBoldTextFeildStyle(),
                          children: [
                            TextSpan(
                              text: "Don't have an account? ",
                            ),
                            TextSpan(
                              text: "Sign up",
                              style: TextStyle(
                                  color: Color(
                                      0Xffff5722)), // You can change the color here
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _signIn() async {
    setState(() {
      _isSigning = true;
    });

    String email = useremailcontroller.text;
    String password = userpasswordcontroller.text;

    try {
      User? user = await _auth.signInWithEmailAndPassword(email, password);

      setState(() {
        _isSigning = false;
      });

      if (user != null) {
        await saveUserLoginState(
            user); // Pass the User object to saveUserLoginState
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: CustomToast(message: "Login Successful"),
            duration: Duration(seconds: 1), // Set duration here
          ),
        );

        // Retrieve userId
        String? userId = await SharedPreferenceHelper().getUserId();

        // Pass userId to BottomNav when navigating
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNav(
                userId:
                    userId ?? ''), // Provide a default value if userId is null
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: CustomToast(message: "Credentials Missing"),
            duration: Duration(seconds: 1), // Set duration here
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isSigning = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: CustomToast(message: "Login Failed: $e"),
          duration: Duration(seconds: 1), // Set duration here
        ),
      );
    }
  }

  Future<void> saveUserLoginState(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('loggedIn', true);
    prefs.setString('email', user.email ?? ''); // Ensure email is not null
    // Save other user-related data if needed
  }
}
