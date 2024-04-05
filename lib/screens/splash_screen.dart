import 'package:currency_conversion/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late FirebaseAuth auth;

  @override
  void initState() {
    super.initState();
    auth = FirebaseAuth.instance;
    navigateToNextScreen();
  }

  void navigateToNextScreen() {
    Future.delayed(Duration(seconds: 1), () {
      final User? user = auth.currentUser;
      if (user != null) {
        late FirebaseAuth auth = FirebaseAuth.instance;
        auth.signOut().then((value) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        });
        // User is logged in, navigate to home
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => HomeScreen()),
        // );
      } else {
        // User is not logged in, navigate to login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Your splash screen UI code goes here
    return Scaffold(
      body: Center(
          child: Container(
              width: 400,
              height: 800,
              child: Image.asset("assets/img/splash-logo.png"))),
    );
  }
}
