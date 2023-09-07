import 'package:fecipe/Onbording/Welcome.dart';
import 'package:fecipe/commons/bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tbib_splash_screen/splash_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoaded = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3)).then((value) => setState(() {
          isLoaded = true;
        }));
    setBool();
  }

  setBool() async {
    final SharedPreferences boolPref = await SharedPreferences.getInstance();
    boolPref.setBool('boolPref', false);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // If the snapshot has user data, then they're already signed in. So Navigating to the Dashboard.
          if (snapshot.hasData) {
            return SplashScreenView(
              navigateWhere: isLoaded,
              navigateRoute: const BottomBar(),
              backgroundColor: Theme.of(context).colorScheme.primary,
              imageSrc: 'asset/images/logo.png',
              logoSize: MediaQuery.of(context).size.height * 0.5,
              pageRouteTransition: PageRouteTransition.CupertinoPageRoute,
            );
          }
          // Otherwise, they're not signed in. Show the sign in page.
          else {
            return SplashScreenView(
              navigateWhere: isLoaded,
              navigateRoute: Welcome(),
              backgroundColor: Theme.of(context).colorScheme.primary,
              imageSrc: 'asset/images/logo.png',
              logoSize: MediaQuery.of(context).size.height * 0.5,
              pageRouteTransition: PageRouteTransition.CupertinoPageRoute,
            );
          }
        });
  }
}
