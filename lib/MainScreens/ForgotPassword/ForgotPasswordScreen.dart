import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Authentication/LoginScreen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  static const Color primaryGreen = Color(0xFF05A941);
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _loading = false;

  Future<void> _resetPassword() async {
    String email = _emailController.text.trim();
    if (!_formKey.currentState!.validate()) return;

    try
    {
      if(email.isEmpty){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter your email ✅")),
        );
      }

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password reset link sent to $email ✅")));

      setState(() {
        _loading = true;
      });

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No user found with this email ✅")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.message}")),
        );
      }
    }
    finally
        {
          setState(() {
            _loading = false;
          });
        }
    return;

  }

  // DECORATION
  InputDecoration _buildDecoration(String hint, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.grey[600]),
      hintText: hint,
      filled: true,
      fillColor: Colors.grey[200],
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        backgroundColor: const Color(0xFFF4FFF8),
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(
          foregroundColor: Colors.black,
          backgroundColor: Color(0xFFF4FFF8),
          centerTitle: true,
          title: Text(
            "Forgot Password",
            style: TextStyle(
              fontSize: 18,
              color: Colors.green,
              fontWeight: FontWeight.w500,
            ),
          ),
          elevation: 0.0,
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  // Login Card
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
                    child:
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [

                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.green.shade50,
                            child: Icon(
                              Icons.email_outlined,
                              color: primaryGreen,
                              size: 40,
                            ),
                          ),

                          SizedBox(height: 10,),
                          
                          Text(
                            "Forgot Password ?",
                            style: TextStyle(
                              color: primaryGreen,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          SizedBox(height: 10,),

                          Text(
                            textAlign: TextAlign.center,
                              // "Please enter your email address. You will receive a link to create a new password via email.",
                            "No worries! Enter your email address and we'll send you a link to reset your password.",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          
                          SizedBox(height: 20,),

                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Email Address",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800])),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _emailController,
                            decoration: _buildDecoration("Enter your email", Icons.email),
                            validator: (value) =>
                            (value == null || !value.contains('@'))
                                ? "Enter a valid email."
                                : null,
                          ),
                          const SizedBox(height: 20),
                          // const SizedBox(height: 12),


                          // ✅ Sign In Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _loading ? null : _resetPassword,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryGreen,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                              child: _loading
                                  ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                                  : const Text('Sign In'),
                            ),
                          ),


                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Remember your password? "),
                      GestureDetector(
                        onTap: () {
                          // go to signup
                          Navigator.push(context, _createRoute(LoginScreen()));
                        },
                        child: Text(
                          "Sign in here",
                          style: TextStyle(
                              color: primaryGreen, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
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