import 'package:flutter/material.dart';

import '../Screens/CartScreen.dart';
import '../Screens/HomeScreen.dart';
import '../Screens/MyBooksScreen.dart';
import '../Screens/ProfileScreen.dart';
import '../Screens/SellScreen.dart';
import 'CustomBottomNav.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  final List<Widget> _Pages = [
    HomeScreen(),
    MyBooksScreen(),
    SellScreen(),
    CartScreen(),
    Profilescreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBody: true, // 👈 makes body visible behind nav
      // body: _Pages[_selectedIndex],
      // bottomNavigationBar: Custombottomnav(
      //   selectedIndex: _selectedIndex,
      //   onItemTapped: _onItemTapped,
      // ),
    );
  }
}
