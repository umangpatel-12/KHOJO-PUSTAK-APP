import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:khojpustak/Widgets/Authentication/LoginScreen.dart';
import 'package:khojpustak/Widgets/ForgotPassword/ForgotPasswordScreen.dart';
import 'package:khojpustak/Widgets/Screens/Profile/EditProfileScreen.dart';
import 'package:khojpustak/Widgets/Screens/Profile/LocationScreen.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../Widgets/ProfileCard.dart';

class Profilescreen extends StatefulWidget {
  const Profilescreen({super.key});

  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen> {
  String? profilePic;

  Future<void> _Logout() async {
    await FirebaseAuth.instance.signOut();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Logout Successfully Completed ✅")),
    );
    Navigator.pushReplacement(context, _createRoute(LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white60,
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        elevation: 0.2,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.green,size: 22),
        title: Text(
          "Profile",
          style: TextStyle(
              fontSize: 18,
              color: Colors.green,
              fontWeight: FontWeight.w500
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          child: Column(
            children: [
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
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final XFile? picimage = await ImagePicker()
                              .pickImage(
                              source: ImageSource.gallery, imageQuality: 60,
                          );
                          if(picimage != null){
                            setState(() {
                              profilePic = picimage.path;
                            });
                          }
                          print("Profile Pic");
                        },
                        child: Container(
                          child: profilePic == null ?
                          CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.black26,
                            child: Image.asset(
                              "assets/images/user_pic.png",
                              fit: BoxFit.cover,
                            ),
                          )
                              :
                          CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.black26,
                            backgroundImage: FileImage(File(profilePic!)),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("Rahul Sharma", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          // Row(
                          //   children: [
                          //     Icon(Icons.star, color: Colors.amber, size: 18),
                          //     SizedBox(width: 4),
                          //     Text("4.8 (127 reviews)", style: TextStyle(fontSize: 14, color: Colors.black54)),
                          //   ],
                          // ),
                          SizedBox(height: 4),
                          Text("Mumbai, Maharashtra", style: TextStyle(fontSize: 14, color: Colors.black54)),
                        ],
                      ),
                      const Spacer(),
                      OutlinedButton.icon(
                          onPressed: (){},
                          icon: const Icon(FontAwesomeIcons.edit, size: 14, color: Colors.green,),
                          label: Text(
                            "Edit",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                              fontSize: 14
                            ),
                          ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.green, width: 1.5),
                          padding: EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.green, width: 1.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),


              const SizedBox(height: 16),

              SizedBox(height: 16,),

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
                      SizedBox(height: 8,),
                      Text(
                        "     My Activity",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black45
                        ),
                      ),

                      ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          ActivityTile(
                            icon: Icons.shopping_bag_outlined,
                            title: "My Orders",
                            subtitle: "Track your purchases",
                            count: 3,
                            onTap: () {
                              // Action for My Orders
                              print("My Orders tapped");
                            },
                          ),
                          ActivityTile(
                            icon: Icons.inventory_2_outlined,
                            title: "My Listings",
                            subtitle: "Manage your book listings",
                            count: 8,
                            onTap: () {
                              print("My Listings tapped");
                            },
                          ),
                          ActivityTile(
                            icon: Icons.favorite_border,
                            title: "Wishlist",
                            subtitle: "Saved books",
                            count: 12,
                            onTap: () {
                              print("Wishlist tapped");
                            },
                          ),
                          ActivityTile(
                            icon: Icons.history,
                            title: "Transaction History",
                            subtitle: "All your transactions",
                            onTap: () {
                              print("Transaction History tapped");
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16,),

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
                      SizedBox(height: 8,),
                      Text(
                        "     Account",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black45
                        ),
                      ),

                      ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          ActivityTile(
                            icon: CupertinoIcons.person,
                            title: "Personal Information",
                            subtitle: "Update your details",
                            onTap: () {
                              // Action for My Orders
                              Navigator.push(context, _createRoute(EditProfileScreen()));
                              print("Personal Information tapped");
                            },
                          ),
                          ActivityTile(
                            icon: CupertinoIcons.location,
                            title: "Location",
                            subtitle: "Updates your location's",
                            onTap: () {
                              Navigator.push(context, _createRoute(LocationScreen()));
                              // print("Location tapped");
                            },
                          ),
                          ActivityTile(
                            icon: CupertinoIcons.lock,
                            title: "Forgot password",
                            subtitle: "Change or reset your password",
                            onTap: () {
                              Navigator.push(context, _createRoute(ForgotPasswordScreen()));
                              print("Location tapped");
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

              SizedBox(height: 16,),

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
                    ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        ActivityTile(
                          icon: Iconsax.logout_1,
                          color: Colors.red,
                          title: "Logout",
                          subtitle: "Sign out of your account",
                          onTap: () {
                            // Action for My Orders
                            _Logout();
                            print("Personal Information tapped");
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 80,)
            ],
          ),
        ),
      ),
    );
  }
}


Route _createRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Slide from right
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}