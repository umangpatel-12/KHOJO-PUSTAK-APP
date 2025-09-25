import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class SellScreen extends StatefulWidget {
  const SellScreen({super.key});

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {

  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  String? selectedCategory;

  InputDecoration _buildDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey[200],
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = MyApp.primaryGreen;
    return
      Scaffold(
        appBar: AppBar(
          shadowColor: Colors.black26,
          backgroundColor: Colors.white,
          // elevation: 1,
          title: const Text(
            "Sell Your Book",
            style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              fontSize: 20
            ),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.green),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Green Offer Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade100),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Turn Your Books Into Cash!",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Sell your used books to fellow students and earn money",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "₹200-₹2000 Average Earnings",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Add Photo Section

              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade300,),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      children: [
                        Icon(Icons.camera_alt_outlined),
                        const SizedBox(width: 8),
                        const Text(
                          "Book Photos (Add up to 5)",
                          style: TextStyle(
                              fontWeight: FontWeight.w400
                          ),
                        ),
                      ],
                    ),


                    const SizedBox(height: 15),

                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 100,
                        width: 150,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey.shade100,
                        ),
                        child: const Center(
                          child: Text(
                            "+ Add Photo",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Add clear photos of your book cover and condition",
                      style: TextStyle(
                          color: Colors.grey,
                        fontSize: 12
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const SizedBox(height: 8),

              // Books Information

              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade300,),
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

                    Row(
                      children: [
                        const Text(
                          "Book Details",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                            color: Colors.black87
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20,),

                    // Optional header label on top left like screenshot (Full Name label is above fields)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Book Title *',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    TextField(
                      // controller: _fullName,
                      decoration:
                      _buildDecoration('Enter book title'),
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 14),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Author *',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    TextField(
                      // controller: _email,
                      decoration:
                      _buildDecoration('Enter author name'),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 14),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Description *',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    TextField(
                      // controller: _phone,
                      decoration: _buildDecoration('Describe the book condition, any highlights, missing pages etc.'),
                      keyboardType: TextInputType.streetAddress,
                      minLines: 1,
                    ),

                  ],
                ),
              ),

              SizedBox(height: 20,),

              // Contact Information
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade300,),
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

                    Row(
                      children: [
                        const Text(
                          "Contact Information",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                              color: Colors.black87
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20,),

                    // Optional header label on top left like screenshot (Full Name label is above fields)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Your Location *',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    TextField(
                      // controller: _fullName,
                      decoration:
                      _buildDecoration('e.g., Gujarat University,Sector-1,Ahmedabad'),
                      keyboardType: TextInputType.streetAddress,
                    ),
                    const SizedBox(height: 14),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Phone Number *',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    TextField(
                      // controller: _email,
                      decoration:
                      _buildDecoration('Enter phone number'),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 14),

                  ],
                ),
              ),

              SizedBox(height: 20,),

              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                decoration: BoxDecoration(
                  color: Color(0xFFedf2fb),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.blue.shade100,),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Before you list:",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                        color: Color(0xff004dc5),
                      ),
                    ),

                    const SizedBox(height: 12),
                    bulletPoint("Ensure your book photos are clear and show the actual condition"),
                    bulletPoint("Price competitively - check similar books on the platform"),
                    bulletPoint("Be honest about book condition to avoid disputes"),
                    bulletPoint("Respond promptly to buyer messages"),

                    SizedBox(height: 20,),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
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
                        child: const Text('List Book for Sale'),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 80,)


              // DropdownButtonFormField<String>(
              //   decoration: const InputDecoration(
              //     labelText: "Subject/Category",
              //     border: OutlineInputBorder(),
              //   ),
              //   items: const [
              //     DropdownMenuItem(value: "Science", child: Text("Science")),
              //     DropdownMenuItem(value: "Math", child: Text("Math")),
              //     DropdownMenuItem(value: "History", child: Text("History")),
              //     DropdownMenuItem(value: "Other", child: Text("Other")),
              //   ],
              //   onChanged: (value) {
              //     selectedCategory = value;
              //   },
              // ),
            ],
          ),
        ),
      );
  }
}

// Custom bullet point widget
Widget bulletPoint(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "• ",
          style: TextStyle(fontSize: 14, color: Colors.blue),
        ),
        Expanded(
          child: Text(
            text,
            textAlign: TextAlign.justify,
            style: const TextStyle(fontSize: 14, color: Colors.blue),
          ),
        ),
      ],
    ),
  );
}