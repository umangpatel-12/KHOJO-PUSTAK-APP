import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../CartScreen.dart';
import '../HomeScreen.dart';
import '../MyBooksScreen.dart';
import '../Profile/ProfileScreen.dart';
import '../SellScreen.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    MyBooksScreen(),
    SellScreen(),
    CartScreen(),
    Profilescreen(),
  ];

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String address = "Fetching location...";

  @override
  void initState() {
    super.initState();
    _requestLocationPermissionAndGetLocation();
  }

  Future<void> _requestLocationPermissionAndGetLocation() async {
    var status = await Permission.location.request();

    if (status.isGranted) {
      // Get user UID
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        setState(() {
          this.address = "User not logged in!";
        });
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Convert lat/lon → readable address
      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      String address =
          "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";

      setState(() {
        this.address = address;
      });

      // ✅ Save to Firestore under current user’s UID
      await FirebaseFirestore.instance.collection('users').doc(user.uid).collection("location").doc(user.uid).set({
          'latitude': position.latitude,
          'longitude': position.longitude,
          'address': address,
          // 'timestamp': DateTime.now(),
      }, SetOptions(merge: true)); // merge = overwrite nahi karega

      // ✅ Save to Realtime Database under current user’s UID
      DatabaseReference ref =
      FirebaseDatabase.instance.ref("users/${user.uid}/location");
      await ref.set({

          'latitude': position.latitude,
          'longitude': position.longitude,
          'address': address,
          // 'timestamp': DateTime.now().toIso8601String(),
      });

      // print("📍 Location stored successfully for user: ${user.uid}");
    } else if (status.isDenied) {
      setState(() {
        this.address = "Location permission denied";
      });
    } else if (status.isPermanentlyDenied) {
      setState(() {
        this.address = "Permission permanently denied. Open settings to allow.";
      });
      openAppSettings();
    }
  }


  Widget buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isSelected ? 1.0 : 0.6,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 300),
          scale: isSelected ? 1.2 : 1.0,
          curve: Curves.easeInOut,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 25,
                color: isSelected ? Colors.green : Colors.black,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? Colors.green : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // 👈 Prevent nav bar from moving
      body: Stack(
        children: [
          // ✅ Smooth page transition
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 0.1),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: _pages[_selectedIndex],
          ),

          // ✅ Fixed Bottom Navigation Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0, // 👈 Always stick at bottom
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildNavItem(PhosphorIcons.house(), "Home", 0),
                  buildNavItem(PhosphorIcons.book(), "Books", 1),
                  buildNavItem(PhosphorIcons.shoppingCartSimple(), "Cart", 3),
                  buildNavItem(PhosphorIcons.plus(), "Add", 2),
                  buildNavItem(PhosphorIcons.user(), "Profile", 4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
