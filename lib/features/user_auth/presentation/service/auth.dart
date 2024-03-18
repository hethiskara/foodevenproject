import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  getCurrentUser() async {
    return auth.currentUser;
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
    await clearUserLoginState(); // Clear user login state
    // Navigate to your login page or any other destination
  }

  Future<void> clearUserLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('loggedIn'); // Remove the 'loggedIn' flag
    // Clear any other user-related data if needed
  }

  Future deleteuser() async {
    User? user = FirebaseAuth.instance.currentUser;
    user?.delete();
  }
}
