import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:khojpustak/Widgets/ForgotPassword/ForgotPasswordScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../BottomNavigationBar/BottomNavBar.dart';
import '../Screens/Widgets/ButtonLayout.dart';
import 'RegistrationScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  // final FirebaseAuth _auth = FirebaseAuth.instance;


  bool _obscurePassword = true;
  bool _remember = false;

  static const Color primaryGreen = Color(0xFF05A941);
  bool _loading = false;


  ///////////////////// Login ///////////////////////
  Future<void> _userLogin() async {
    if(_formKey.currentState!.validate()){
      setState(() {
        _loading = true;
      });
      try{
        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email.text.trim(),
          password: _password.text.trim(),
        );

        if (_remember){
          SharedPreferences preferences = await SharedPreferences.getInstance();
          await preferences.setBool('isLoggedIn', true);
        }

        // Navigate to Screens Page
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login Successful ✅")),
        );
        // Navigator.push(context, _createRoute(BottomNavBar()));
        Navigator.pushReplacement(context, createRoute(CustomBottomNavBar()));
      }
      on FirebaseAuthException catch (e) {
        String message = "";
        if (e.code == 'user-not-found') {
          message = "No user found with this email.";
        } else if (e.code == 'wrong-password') {
          message = "Wrong password.";
        } else {
          message = "Login failed. ${e.message}";
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }  finally {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  // Google Sign In
  Future<void> signInWithGoogle() async {
    setState(() {
      _loading = true;
    });
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled
        setState(() => _loading = false);
        return;
      }

      // Get Google authentication
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // 🔹 Some versions only provide `idToken`, so we use that
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken, // only available on some platforms
      );

      // Firebase sign in
      final userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        if (_remember) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('userEmail', userCredential.user!.email ?? '');
          await prefs.setString('userName', userCredential.user!.displayName ?? '');
          await prefs.setString('userPhoto', userCredential.user!.photoURL ?? '');
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Google Sign-In Successful ✅")),
        );
        Navigator.pushReplacement(context, createRoute(CustomBottomNavBar()));
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google Sign-In Failed: ${e.message}")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error during Google Sign-In: $e")),
      );
    } finally {
      setState(() => _loading = false);
    }
  }



  InputDecoration _decoration(String hint, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.grey[600]),
      hintText: hint,
      filled: true,
      fillColor: Colors.grey[100],
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _socialButton(String label, Widget icon, VoidCallback onTap) {
    return Expanded(
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
      backgroundColor: const Color(0xFFF4FFF8),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Sign In",
                  style: TextStyle(
                    color: primaryGreen,
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Email Address",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800])),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _email,
                          decoration: _decoration("Enter your email", Icons.email),
                          validator: (value) =>
                          (value == null || value.isEmpty)
                              ? "Email is required"
                              : null,
                        ),
                        const SizedBox(height: 14),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Password",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800])),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _password,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock_outline,
                                color: Colors.grey[600]),
                            hintText: "Enter your password",
                            filled: true,
                            fillColor: Colors.grey[100],
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey[600],
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) =>
                          (value == null || value.isEmpty)
                              ? "Password is required"
                              : null,
                        ),
                        const SizedBox(height: 12),

                        // ✅ Checkbox + Forgot Password
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: _remember,
                                  onChanged: (v) => setState(() => _remember = v ?? false),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  activeColor: primaryGreen,
                                  visualDensity: VisualDensity.compact, // ✅ chhota size
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // ✅ spacing kam
                                ),
                                const Text(
                                  "Remember me",
                                  style: TextStyle(fontSize: 13), // ✅ font chhota
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                // handle forgot password
                                Navigator.push(context, createRoute(ForgotPasswordScreen()));
                              },
                              child: Text(
                                "Forgot password?",
                                style: TextStyle(
                                  fontSize: 13, // ✅ font chhota
                                  color: primaryGreen,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // ✅ Sign In Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _remember ? _userLogin : null,
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

                        Row(
                          children: [
                            const Expanded(child: Divider(thickness: 1)),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Text("Or continue with",
                                  style: TextStyle(color: Colors.grey[600])),
                            ),
                            const Expanded(child: Divider(thickness: 1)),
                          ],
                        ),

                        const SizedBox(height: 14),

                        Row(
                          children: [
                            _socialButton(
                              "Google",
                              const Icon(Icons.g_mobiledata,
                                  color: Colors.black, size: 24),
                              signInWithGoogle,
                            ),
                            const SizedBox(width: 12),
                            _socialButton(
                              "Facebook",
                              const Icon(Icons.facebook,
                                  color: Colors.black, size: 20),
                                  () {
                                     // TODO: Implement Facebook Sign In
                                  },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        // go to signup
                        Navigator.push(context, createRoute(Registrationscreen()));
                      },
                      child: Text(
                        "Create one here",
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