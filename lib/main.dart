import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Widgets/Authentication/LoginScreen.dart';
import 'Widgets/BottomNavigationBar/BottomNavBar.dart';

Future<void> main() async {


  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();

  bool isLoggedIn = preferences.getBool('isLoggedIn') ?? false;

  await Firebase.initializeApp();

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  MyApp({super.key, required this.isLoggedIn,});
  static const Color primaryGreen = Color(0xFF05A941);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryGreen),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? CustomBottomNavBar() : LoginScreen(),
    );
  }
}
