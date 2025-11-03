import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart'; // Added import

import '../../Widgets/CardLayouts/ButtonLayout.dart';
import '../../Widgets/CardLayouts/OTPTextField.dart';
import '../../main.dart';
import '../Authentication/LoginScreen.dart';
import '../BottomNavigationBar/BottomNavBar.dart';

class Registrationscreen extends StatefulWidget {
  const Registrationscreen({super.key});
  @override
  State<Registrationscreen> createState() => _RegistrationscreenState();
}

class _RegistrationscreenState extends State<Registrationscreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _otpcontroller = TextEditingController();
  static const Color primaryGreen = Color(0xFF05A941);

  int currentStep = 0;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agree = false;
  bool _loading = false;

  String _verificationId = '';

  @override
  void dispose() {
    _fullName.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

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
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!RegExp(r'\d').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  //////////////////// OTP //////////////////////////


  ////////////////////Firebase Authentication////////////////////
  Future<void> _registerUser() async {
    if(_formKey.currentState!.validate())
    {
      setState(() {
        _loading = true;
      });
    }

    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email.text.trim(),
        password: _password.text.trim(),
      );

      if (credential.user != null) {
        // Save extra Details in Firebase Firestore
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

        // Save details to Firebase Realtime Database
        DatabaseReference userRefRDB = FirebaseDatabase.instance
            .ref()
            .child('users')
            .child(credential.user!.uid);
        await userRefRDB.set({
          'fullName': _fullName.text.trim(),
          'email': _email.text.trim(),
          'phone': _phone.text.trim(),
          'uid': credential.user!.uid,
          'createdAt': DateTime.now().toIso8601String(), // Realtime DB timestamp
        });

        //Navigate to MainScreens Page
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registration Successful ✅")),
        );
        // Ensure BottomAppBar() is a Page/Screen or replace with your actual home screen widget
        Navigator.pushReplacement(context, createRoute(CustomBottomNavBar()));
      }
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      } else {
        message = 'Registration failed: ${e.message}';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred: $e')),
      );
    }
    finally{
      setState(() {
        _loading = false;
      });
    }
  }

  ////////////////////////////// Auth /////////////////////////////////
  Widget _buildStepIndicator() {
    List<String> steps = ["Step 1", "Step 2", "Step 3"];
    return Center(
      child: SizedBox(
        width: 200,
        child: Column(
          children: [
            Row(
              children: List.generate(steps.length * 2 - 1, (index) {
                // Step circles
                if (index.isEven) {
                  int stepIndex = index ~/ 2;
                  bool isActive = stepIndex == currentStep;
                  bool isCompleted = stepIndex < currentStep;

                  Color circleColor;
                  Widget child;

                  if (isCompleted) {
                    circleColor = Colors.green;
                    child = const Icon(
                      CupertinoIcons.check_mark_circled,
                      color: Colors.white,
                      size: 21,
                    );
                  } else if (isActive) {
                    circleColor = Colors.green;
                    child = Text(
                      "${stepIndex + 1}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    );
                  } else {
                    circleColor = Colors.grey[300]!;
                    child = Text("${stepIndex + 1}", style: const TextStyle(color: Colors.black));
                  }

                  return CircleAvatar(radius: 15, backgroundColor: circleColor, child: child);
                }
                // Connector lines
                else {
                  int lineIndex = (index - 1) ~/ 2;
                  bool isLineActive = lineIndex < currentStep;
                  return Expanded(
                    child: Container(
                      height: 1.5,
                      color: isLineActive ? Colors.green : Colors.grey[300],
                    ),
                  );
                }
              }),
            ),
            const SizedBox(height: 6),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(steps.length, (index) {
                bool isActive = index == currentStep;
                bool isCompleted = index < currentStep;

                return Text(
                  steps[index],
                  style: TextStyle(
                    fontSize: 11,
                    color: isCompleted ? Colors.green : (isActive ? Colors.green : Colors.grey),
                    fontWeight: FontWeight.w500,
                  ),
                );
              }),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void nextStep() {
    setState(() {
      if (currentStep < 2) currentStep++;
    });
  }

  void prevStep() {
    setState(() {
      if (currentStep > 0) currentStep--;
    });
  }

  ///////////////////////////////////////  Step 1 ////////////////////////////////////
  Widget _buildPhoneInput() {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
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
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildStepIndicator(),

                        SizedBox(height: 20),

                        Text(
                          "Verify Phone Number",
                          style: TextStyle(
                            color: primaryGreen,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        SizedBox(height: 10),

                        Text(
                          textAlign: TextAlign.center,
                          // "Please enter your email address. You will receive a link to create a new password via email.",
                          "We'll send you a verification code.",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        SizedBox(height: 20),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Phone Number",
                            style: TextStyle(fontWeight: FontWeight.w700, color: Colors.grey[800]),
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _phone,
                          decoration: InputDecoration(
                            prefixIcon: Icon(CupertinoIcons.phone, color: Colors.grey[600],size: 22,),
                            hintText: 'Enter 10-digit number',
                            hintStyle: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                            filled: true,
                            prefixText: "+91 ",
                            prefixStyle: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            fillColor: Colors.grey[200],
                            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: _validateMobile,
                        ),

                        SizedBox(height: 20),
                        // ✅ Sign In Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_phone.text.trim().isEmpty || _phone.text.length != 10) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Please enter a valid 10-digit phone number")),
                                );
                                return;
                              }

                              setState(() => _loading = true);

                              await FirebaseAuth.instance.verifyPhoneNumber(
                                phoneNumber: '+91${_phone.text.trim()}',
                                verificationCompleted: (PhoneAuthCredential credential) async {
                                  // Auto verification (optional)
                                },
                                verificationFailed: (FirebaseAuthException e) {
                                  setState(() => _loading = false);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Verification failed: ${e.message}")),
                                  );
                                },
                                codeSent: (String verificationId, int? resendToken) {
                                  setState(() {
                                    _verificationId = verificationId;
                                    _loading = false;
                                  });
                                  nextStep(); // Go to OTP screen
                                },
                                codeAutoRetrievalTimeout: (String verificationId) {
                                  _verificationId = verificationId;
                                },
                                timeout: const Duration(seconds: 60),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryGreen,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
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
                                : const Text('Send OTP'),
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
                        Navigator.push(context, createRoute(LoginScreen()));
                      },
                      child: Text(
                        "Sign in here",
                        style: TextStyle(color: primaryGreen, fontWeight: FontWeight.w700),
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

  ///////////////////////////////////////  Step 2 ////////////////////////////////////
  Widget _buildOtpVerification() {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Login Card
                Container(
                  width: 360,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildStepIndicator(),
                        SizedBox(height: 20),
                        TextButton(
                          style: TextButton.styleFrom(
                            alignment: Alignment.center,
                            foregroundColor: Colors.green,),
                          onPressed: prevStep,
                          child: Row(
                            children: [
                              Icon(Icons.arrow_back, color: Colors.green, size: 16),
                              SizedBox(width: 3),
                              const Text(
                                "Back",
                                style: TextStyle(fontSize: 14, color: Colors.green),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 10),

                        Text(
                          "Enter Verification Code",
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        SizedBox(height: 10),

                        Text(
                          textAlign: TextAlign.center,
                          // "Please enter your email address. You will receive a link to create a new password via email.",
                          "We'll send a code to 7310134689",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        SizedBox(height: 20),

                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            textAlign: TextAlign.center,
                            "Enter 6-digit OTP",
                            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[800]),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(6, (index) {
                            return SizedBox(
                              height: 50,
                              width: 43,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLength: 1,
                                decoration: InputDecoration(
                                  counterText: '',
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(color: Colors.green, width: 2),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 12,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                onChanged: (value) {
                                  if (value.isNotEmpty && index < 5) {
                                    FocusScope.of(context).nextFocus();
                                  } else if (value.isEmpty && index > 0) {
                                    FocusScope.of(context).previousFocus();
                                  }
                                },
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 10),

                        SizedBox(height: 20),
                        // ✅ Sign In Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              String otp = _otpcontroller.text.trim();

                              if (otp.length != 6) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Please enter the 6-digit OTP")),
                                );
                                return;
                              }

                              setState(() => _loading = true);

                              try {
                                PhoneAuthCredential credential = PhoneAuthProvider.credential(
                                  verificationId: _verificationId,
                                  smsCode: otp,
                                );

                                await FirebaseAuth.instance.signInWithCredential(credential);

                                // Move to Step 3 after successful OTP
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Phone number verified successfully ✅")),
                                );
                                nextStep();
                              } catch (e) {
                                setState(() => _loading = false);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Invalid OTP. Please try again.")),
                                );
                              }
                            },

                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryGreen,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
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
                                : const Text('Send OTP'),
                          ),
                        ),

                        const SizedBox(height: 15),

                        Otptextfield(),
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
                        Navigator.push(context, createRoute(LoginScreen()));
                      },
                      child: Text(
                        "Sign in here",
                        style: TextStyle(color: primaryGreen, fontWeight: FontWeight.w700),
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

  /////////////////////////////////////////  Step 3 ////////////////////////////////////
  Widget _buildAdditionalDetails() {
    final primary = MyApp.primaryGreen;
    return Scaffold(
      body: SingleChildScrollView(
        // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
        child: Column(
          children: [
            // const SizedBox(height: 22),
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
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildStepIndicator(),
                    SizedBox(height: 20),

                    Text(
                      "Complete Your Profile",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),

                    const Text(
                      "Phone Verified: 7340134989 ✓", // This text might be more appropriate for a login screen
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54),
                    ),

                    SizedBox(height: 10),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Full Name',
                        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[800]),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _fullName,
                      decoration: _buildDecoration('Enter your full name', Icons.person),
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 14),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Email Address',
                        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[800]),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _email,
                      decoration: _buildDecoration('Enter your email', Icons.email_outlined),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 14),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Password',
                        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[800]),
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
                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
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
                        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[800]),
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
                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
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
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
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
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
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
                            : const Text('Create Account'),
                      ),
                    ),

                    const SizedBox(height: 16),

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
                        _socialButton(
                          'Google',
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.white,
                            child: Text(
                              'G',
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                          ),
                              () {
                            // Handle Google auth
                          },
                        ),
                        const SizedBox(width: 12),
                        _socialButton(
                          'Facebook',
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.white,
                            child: Text(
                              'f',
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                          ),
                              () {
                            // Handle Facebook auth
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account? '),
                        GestureDetector(
                          onTap: () {
                            // go to signup
                            Navigator.push(context, createRoute(LoginScreen()));
                          },
                          child: Text(
                            'Sign in here',
                            style: TextStyle(color: primary, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> steps = [_buildPhoneInput(), _buildOtpVerification(), _buildAdditionalDetails()];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        elevation: 0.2,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.green, size: 22),
        title: const Text(
          "Create Account",
          style: TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: steps[currentStep],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String? _validateMobile(String? value) {
// Indian Mobile number are of 10 digit only
  if(value == null || value.isEmpty){
    return 'Please enter your phone number';
  }
  else if(!RegExp(r'^[0-9]{10}$').hasMatch(value)){
    return "Enter a valid 10-digit number";
  }
  return null;
}