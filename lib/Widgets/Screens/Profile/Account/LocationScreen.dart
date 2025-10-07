import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../Widgets/ProfileCard.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _address = TextEditingController();

  static const Color primaryGreen = Color(0xFF05A941);
  bool _loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _showAddData();
  }

  Future<void> _showAddData() async{
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          _address.text = data['address'] ?? '';
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFFF4FFF8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        elevation: 0.2,
        centerTitle: true,
        title: Text(
          "Location",
          style: TextStyle(
            fontSize: 18,
            color: Colors.green,
            fontWeight: FontWeight.w500,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.green,size: 20),
      ),

      body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey[300]!),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        )
                      ],
                    ),
                    child:
                    Padding(
                      padding: const EdgeInsets.all(22.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                                PhosphorIconsFill.mapPinArea,
                              color: Colors.green.shade400,
                              size: 28,
                            ),
                          ),

                          SizedBox(width: 15,),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10,),
                                Text(
                                  "Current Location",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                  ),
                                ),

                                SizedBox(height: 2,),

                                Text(
                                  _address.text.isEmpty ? "Location" : _address.text,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black45,
                                  ),
                                  softWrap: true,
                                  maxLines: 2,
                                ),

                                SizedBox(height: 10,),

                              ]
                            ),
                          )
                        ],
                      ),
                    )
                ),
                SizedBox(height: 20,),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey[300]!),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      )
                    ],
                  ),

                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child:  Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Location Details",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),



                          SizedBox(height: 25,),

                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Address",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800])),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            decoration: _buildDecoration("Enter your address", CupertinoIcons.location),
                            validator: (value) =>
                            (value == null || !value.contains('@'))
                                ? "Enter a valid email."
                                : null,
                          ),
                          const SizedBox(height: 25),
                          // const SizedBox(height: 12),


                          // ✅ Sign In Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
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
                                  : const Text('Change Location'),
                            ),
                          ),

                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),

                )
              ],
            ),
          ),
      // Container(
      //   decoration: BoxDecoration(
      //     color: Colors.white,
      //     borderRadius: BorderRadius.circular(10),
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.black.withOpacity(0.06),
      //         blurRadius: 18,
      //         offset: const Offset(0, 8),
      //       )
      //     ],
      //   ),
      //   child: Row(
      //     children: [
      //       CircleAvatar(
      //         radius: 35,
      //         backgroundColor: Colors.green.shade50,
      //         child: Icon(
      //           Icons.location_on_outlined,
      //           color: Colors.green,
      //           size: 40,
      //         ),
      //       ),
      //
      //       Column(
      //         children: [
      //           Text(
      //             "Location",
      //             style: TextStyle(
      //               fontSize: 18,
      //               fontWeight: FontWeight.w500,
      //               color: Colors.black45
      //             ),
      //           ),
      //         ],
      //       )
      //     ],
      //   ),
      // ),,

    );
  }
}
