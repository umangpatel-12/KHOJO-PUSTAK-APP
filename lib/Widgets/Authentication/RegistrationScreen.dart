import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../Screens/HomeScreen.dart';
import 'LoginScreen.dart';

class Registrationscreen extends StatefulWidget {
  const Registrationscreen({super.key});
  @override
  State<Registrationscreen> createState() => _RegistrationscreenState();
}

class _RegistrationscreenState extends State<Registrationscreen> {
  final _fullName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agree = false;

  @override
  void dispose() {
    _fullName.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  // InputDecoration _buildDecoration(String hint, IconData icon) {
  //   return InputDecoration(
  //     prefixIcon: Icon(icon, color: Colors.grey[600]),
  //     hintText: hint,
  //     filled: true,
  //     fillColor: Colors.grey[100],
  //     contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
  //     border: OutlineInputBorder(
  //       borderRadius: BorderRadius.circular(10),
  //       borderSide: BorderSide.none,
  //     ),
  //   );
  // }

  InputDecoration _buildDecoration(String hint, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.grey[600]),
      hintText: hint,
      filled: true,
      fillColor: Colors.grey[100],
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        // borderSide: BorderSide.none,
      ),
    );
  }

  Widget _socialButton(String label, Widget leading, VoidCallback onTap) {
    return Expanded(
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            leading,
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }

    // Minimum 8 characters
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    // At least 1 uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }

    // At least 1 lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }

    // At least 1 digit
    if (!RegExp(r'\d').hasMatch(value)) {
      return 'Password must contain at least one number';
    }

    // At least 1 special character
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }

    return null; // ✅ All checks passed
  }


  ////////////////////Firebase Authentication////////////////////
  Future<void> _registerUser() async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email.text.trim(),
          password: _password.text.trim(),
      );
      // Save extra Details in Firebase
      FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .set(
        {
          'fullName': _fullName.text.trim(),
          'email': _email.text.trim(),
          'phone': _phone.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        },
      );
      //Navigate to Screens Page
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration Successful ✅")),
      );
      Navigator.push(context, _createRoute(BottomAppBar()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('The password provided is too weak.')),
        );
        } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('The account already exists for that email.')),
        );
      }
    }
  }

  /////////////////// Google Authentication ////////////////////
  

  /////////////////// Facebook Authentication ////////////////////

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = MyApp.primaryGreen;

    return Scaffold(
      backgroundColor: const Color(0xFFF4FFF8),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
            child: Column(
              children: [
                Text(
                  "Registration",
                  style: TextStyle(
                    color: primary,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 18),

                // const Icon(Icons.menu_book, size: 64, color: Colors.green),
                Image.asset("assets/icon/icon.png",height: 80,width: 80,),
                const SizedBox(height: 12),

                // Text(
                //   "KHOJ PUSTAK",
                //   style: TextStyle(
                //     color: primaryGreen,
                //     fontSize: 22,
                //     fontWeight: FontWeight.w700,
                //   ),
                // ),
                const SizedBox(height: 6),

                const Text(
                  "Welcome back! Please sign in to your account.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 22),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  constraints: const BoxConstraints(maxWidth: 400),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Optional header label on top left like screenshot (Full Name label is above fields)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Full Name',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _fullName,
                        decoration:
                        _buildDecoration('Enter your full name', Icons.person),
                        keyboardType: TextInputType.name,
                      ),
                      const SizedBox(height: 14),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Email Address',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _email,
                        decoration:
                        _buildDecoration('Enter your email', Icons.email_outlined),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 14),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Phone Number',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _phone,
                        decoration: _buildDecoration('Enter your phone number', Icons.phone),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 14),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Password',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        validator: validatePassword,
                        controller: _password,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[600]),
                          hintText: 'Create a password',
                          filled: true,
                          fillColor: Colors.grey[100],
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            // borderSide: BorderSide.none,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility : Icons.visibility_off,
                              color: Colors.grey[600],
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Confirm Password',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _confirm,
                        obscureText: _obscureConfirm,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[600]),
                          hintText: 'Confirm your password',
                          filled: true,
                          fillColor: Colors.grey[100],
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            // borderSide: BorderSide.none,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirm ? Icons.visibility : Icons.visibility_off,
                              color: Colors.grey[600],
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirm = !_obscureConfirm;
                              });
                            },
                          ),
                        ),
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return 'Please confirm your password';
                          }
                          if (value != _password.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: _agree,
                            onChanged: (v) => setState(() => _agree = v ?? false),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            activeColor: primary,
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(color: Colors.grey[800], fontSize: 14),
                                children: [
                                  const TextSpan(text: 'I agree to the '),
                                  TextSpan(
                                    text: 'Terms of Service',
                                    style: TextStyle(color: primary, fontWeight: FontWeight.w600),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // open terms
                                      },
                                  ),
                                  const TextSpan(text: ' and '),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: TextStyle(color: primary, fontWeight: FontWeight.w600),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // open privacy
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _agree ? _registerUser : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            textStyle:
                            const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          child: const Text('Create Account'),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Divider with text
                      Row(
                        children: [
                          const Expanded(child: Divider(thickness: 1)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              'Or register with',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                          const Expanded(child: Divider(thickness: 1)),
                        ],
                      ),

                      const SizedBox(height: 14),

                      Row(
                        children: [
                          // Google button
                          _socialButton(
                            'Google',
                            // simple circle with 'G' — replace with Image.asset or network svg for real icon
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.white,
                              child: Text('G', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                            ),
                                () {
                              // Handle Google auth
                            },
                          ),
                          const SizedBox(width: 12),
                          // Facebook button
                          _socialButton(
                            'Facebook',
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.white,
                              child: Text('f', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                            ),
                                () {
                              // Handle Facebook auth
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      // Already have account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Already have an account? '),
                          GestureDetector(
                            onTap: () {
                              // navigate to sign in
                              Navigator.pop(context, _createRoute(LoginScreen()));
                            },
                            child: Text(
                              'Sign in here',
                              style: TextStyle(
                                color: primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Custom Page Route with slide animation
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

// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
//
// import '../../main.dart';
// import 'LoginScreen.dart';
//
// class Registrationscreen extends StatefulWidget {
//   const Registrationscreen({super.key});
//   @override
//   State<Registrationscreen> createState() => _RegistrationscreenState();
// }
//
// class _RegistrationscreenState extends State<Registrationscreen> {
//   final _fullName = TextEditingController();
//   final _email = TextEditingController();
//   final _phone = TextEditingController();
//   final _password = TextEditingController();
//   final _confirm = TextEditingController();
//
//   final PageController _pageController = PageController();
//   int _currentPage = 0;
//
//   bool _obscurePassword = true;
//   bool _obscureConfirm = true;
//   bool _agree = false;
//
//   @override
//   void dispose() {
//     _fullName.dispose();
//     _email.dispose();
//     _phone.dispose();
//     _password.dispose();
//     _confirm.dispose();
//     _pageController.dispose();
//     super.dispose();
//   }
//
//   InputDecoration _buildDecoration(String hint, IconData icon) {
//     return InputDecoration(
//       prefixIcon: Icon(icon, color: Colors.grey[600]),
//       hintText: hint,
//       filled: true,
//       fillColor: Colors.grey[100],
//       contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: BorderSide.none,
//       ),
//     );
//   }
//
//   void nextPage() {
//     if (_currentPage < 1) {
//       setState(() => _currentPage++);
//       _pageController.animateToPage(
//         _currentPage,
//         duration: const Duration(milliseconds: 400),
//         curve: Curves.easeInOut,
//       );
//     } else {
//       // Registration complete
//       if (_password.text == _confirm.text && _agree) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Registration Successful ✅")),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Check your password or terms ❌")),
//         );
//       }
//     }
//   }
//
//   void prevPage() {
//     if (_currentPage > 0) {
//       setState(() => _currentPage--);
//       _pageController.animateToPage(
//         _currentPage,
//         duration: const Duration(milliseconds: 400),
//         curve: Curves.easeInOut,
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final primary = MyApp.primaryGreen;
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF4FFF8),
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
//             child: Column(
//               children: [
//                 Text(
//                   "Registration",
//                   style: TextStyle(
//                     color: primary,
//                     fontSize: 20,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 18),
//                 const Icon(Icons.menu_book, size: 64, color: Colors.green),
//                 const SizedBox(height: 22),
//
//                 Container(
//                   width: MediaQuery.of(context).size.width * 0.9,
//                   constraints: const BoxConstraints(maxWidth: 400),
//                   height: 400,
//                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(14),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.06),
//                         blurRadius: 18,
//                         offset: const Offset(0, 8),
//                       )
//                     ],
//                   ),
//                   child: PageView(
//                     controller: _pageController,
//                     physics: const NeverScrollableScrollPhysics(),
//                     children: [
//
//                       // ---------------- PAGE 1 ----------------
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text("Full Name", style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[800])),
//                           const SizedBox(height: 8),
//                           TextField(controller: _fullName, decoration: _buildDecoration('Enter your full name', Icons.person)),
//
//                           const SizedBox(height: 14),
//                           Text("Email", style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[800])),
//                           const SizedBox(height: 8),
//                           TextField(controller: _email, decoration: _buildDecoration('Enter your email', Icons.email_outlined)),
//
//                           const SizedBox(height: 14),
//                           Text("Phone", style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[800])),
//                           const SizedBox(height: 8),
//                           TextField(
//                             controller: _phone,
//                             decoration: _buildDecoration('Enter your phone number', Icons.phone),
//                             keyboardType: TextInputType.phone,
//                           ),
//
//                           const SizedBox(height: 20),
//                           SizedBox(
//                             width: double.infinity,
//                             child: ElevatedButton(
//                               onPressed: nextPage,
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: primary,
//                                 foregroundColor: Colors.white,
//                                 padding: const EdgeInsets.symmetric(vertical: 14),
//                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                                 textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
//                               ),
//                               child: const Text("Next"),
//                             ),
//                           ),
//                         ],
//                       ),
//
//                       // ---------------- PAGE 2 ----------------
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text("Password", style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[800])),
//                           const SizedBox(height: 8),
//                           TextField(
//                             controller: _password,
//                             obscureText: _obscurePassword,
//                             decoration: InputDecoration(
//                               prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[600]),
//                               hintText: 'Create a password',
//                               filled: true,
//                               fillColor: Colors.grey[100],
//                               border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
//                               suffixIcon: IconButton(
//                                 icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off, color: Colors.grey[600]),
//                                 onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
//                               ),
//                             ),
//                           ),
//
//                           const SizedBox(height: 14),
//                           Text("Confirm Password", style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[800])),
//                           const SizedBox(height: 8),
//                           TextField(
//                             controller: _confirm,
//                             obscureText: _obscureConfirm,
//                             decoration: InputDecoration(
//                               prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[600]),
//                               hintText: 'Confirm your password',
//                               filled: true,
//                               fillColor: Colors.grey[100],
//                               border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
//                               suffixIcon: IconButton(
//                                 icon: Icon(_obscureConfirm ? Icons.visibility : Icons.visibility_off, color: Colors.grey[600]),
//                                 onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
//                               ),
//                             ),
//                           ),
//
//                           const SizedBox(height: 12),
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Checkbox(
//                                 value: _agree,
//                                 onChanged: (v) => setState(() => _agree = v ?? false),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(4),
//                                 ),
//                                 activeColor: primary,
//                               ),
//                               Expanded(
//                                 child: RichText(
//                                   text: TextSpan(
//                                     style: TextStyle(color: Colors.grey[800], fontSize: 14),
//                                     children: [
//                                       const TextSpan(text: 'I agree to the '),
//                                       TextSpan(
//                                         text: 'Terms of Service',
//                                         style: TextStyle(color: primary, fontWeight: FontWeight.w600),
//                                         recognizer: TapGestureRecognizer()
//                                           ..onTap = () {
//                                             // open terms
//                                           },
//                                       ),
//                                       const TextSpan(text: ' and '),
//                                       TextSpan(
//                                         text: 'Privacy Policy',
//                                         style: TextStyle(color: primary, fontWeight: FontWeight.w600),
//                                         recognizer: TapGestureRecognizer()
//                                           ..onTap = () {
//                                             // open privacy
//                                           },
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//
//                           const SizedBox(height: 8),
//                           SizedBox(
//                             width: double.infinity,
//                             child: ElevatedButton(
//                               onPressed: _agree ? nextPage : null,
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: primary,
//                                 foregroundColor: Colors.white,
//                                 padding: const EdgeInsets.symmetric(vertical: 14),
//                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                                 textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
//                               ),
//                               child: const Text('Create Account'),
//                             ),
//                           ),
//
//                           const SizedBox(height: 16),
//                           Center(
//                             child: GestureDetector(
//                               onTap: prevPage,
//                               child: const Text(
//                                 "Back",
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w500,
//                                   decoration: TextDecoration.underline,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
