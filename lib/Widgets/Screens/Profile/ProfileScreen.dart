import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:khojpustak/Widgets/Authentication/LoginScreen.dart';
import 'package:khojpustak/Widgets/ForgotPassword/ForgotPasswordScreen.dart';
import 'package:khojpustak/Widgets/Screens/Profile/EditProfileScreen.dart';
import 'package:khojpustak/Widgets/Screens/Profile/LocationScreen.dart';
import 'package:khojpustak/Widgets/Screens/Profile/WishlishListsScreen.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../Widgets/ButtonLayout.dart';
import '../Widgets/ProfileCard.dart';
import 'ListingBooksScreen.dart';

class Profilescreen extends StatefulWidget {
  const Profilescreen({super.key});

  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen> {
  String? profilePic;
  final _fullName = TextEditingController();
  final _address = TextEditingController();

  @override
  void initState() {
    super.initState();
    _showdata(); // Load user data on screen open
  }

  Future<void> _Logout() async {
    await FirebaseAuth.instance.signOut();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Logout Successfully Completed ✅")),
    );
    Navigator.pushReplacement(context, createRoute(LoginScreen()));
  }

  Future<void> _showdata() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          profilePic = data['profilePic'] ?? '';
          _fullName.text = data['fullName'] ?? '';
          _address.text = data['location'] ?? '';
        });
      }

      final addressDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .collection("location")
          .doc(user.uid)
          .get();

      if (addressDoc.exists) {
        final addressData  = addressDoc.data()!;
        setState(() {
          _address.text = addressData['address'] ?? '';
        });
      }
      else{
        setState(() {
          _address.text = '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        elevation: 0.2,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.green, size: 22),
        title: const Text(
          "Profile",
          style: TextStyle(
            fontSize: 18,
            color: Colors.green,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Card
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child:
                Row(
                  children: [
                    // Profile Image
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.black26,
                      backgroundImage: (profilePic != null && profilePic!.isNotEmpty)
                          ? NetworkImage(profilePic!)
                          : null,
                      child: (profilePic == null || profilePic!.isEmpty)
                          ? Image.asset(
                        "assets/images/user_pic.png",
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),

                    const SizedBox(width: 12),

                    // ✅ Wrap Column inside Expanded
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name
                          Text(
                            (_fullName.text.length > 11)
                                ? "${_fullName.text.substring(0, 11)}..."
                                : _fullName.text,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 4),

                          // Address
                          Text(
                            _address.text.isEmpty ? "Location" : _address.text,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Edit Button
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(context, createRoute(EditProfileScreen()));
                      },
                      icon: const Icon(
                        FontAwesomeIcons.edit,
                        size: 14,
                        color: Colors.green,
                      ),
                      label: const Text(
                        "Edit",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.green, width: 1.5),
                        padding: const EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // My Activity
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    const Text(
                      "     My Activity",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black45),
                    ),
                    ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        // ActivityTile(
                        //   icon: Icons.shopping_bag_outlined,
                        //   title: "My Orders",
                        //   subtitle: "Track your purchases",
                        //   count: 3,
                        //   onTap: () {
                        //     print("My Orders tapped");
                        //   },
                        // ),
                        ActivityTile(
                          icon: Icons.inventory_2_outlined,
                          title: "My Listings",
                          subtitle: "Manage your book listings",
                          count: 8,
                          onTap: () {
                            Navigator.push(context, createRoute(ListingBookScreen()));
                            print("My Listings tapped");
                          },
                        ),
                        ActivityTile(
                          icon: Icons.favorite_border,
                          title: "Wishlist",
                          subtitle: "Saved books",
                          count: 12,
                          onTap: () {
                            Navigator.push(context, createRoute(WishlishListScreen()));
                            print("Wishlist tapped");
                          },
                        ),
                        // ActivityTile(
                        //   icon: Icons.history,
                        //   title: "Transaction History",
                        //   subtitle: "All your transactions",
                        //   onTap: () {
                        //     print("Transaction History tapped");
                        //   },
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Account
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    "     Account",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black45),
                  ),
                  ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      ActivityTile(
                        icon: CupertinoIcons.person,
                        title: "Personal Information",
                        subtitle: "Update your details",
                        onTap: () {
                          Navigator.push(
                              context, createRoute(EditProfileScreen()));
                        },
                      ),
                      ActivityTile(
                        icon: CupertinoIcons.location,
                        title: "Location",
                        subtitle: "Update your location",
                        onTap: () {
                          Navigator.push(
                              context, createRoute(LocationScreen()));
                        },
                      ),
                      ActivityTile(
                        icon: CupertinoIcons.lock,
                        title: "Forgot password",
                        subtitle: "Change or reset your password",
                        onTap: () {
                          Navigator.push(
                              context, createRoute(ForgotPasswordScreen()));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Logout
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  ActivityTile(
                    icon: Iconsax.logout_1,
                    color: Colors.red,
                    title: "Logout",
                    subtitle: "Sign out of your account",
                    onTap: () {
                      _Logout();
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}