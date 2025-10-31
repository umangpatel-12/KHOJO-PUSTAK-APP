import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;


  InputDecoration _buildDecoration(String hint) {
    return InputDecoration(
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

  // Fetch Data
  final List<Map<String, String>> faqData = [
    {
      'question': 'How do I buy a book?',
      'answer': 'Browse through our collection, click on a book you like, and tap "Buy Now". You can then contact the seller directly to arrange payment and delivery.'
    },
    {
      'question': 'How do I sell my books?',
      'answer': 'Go to the Sell tab, fill in the book details including title, author, condition, and price. Add photos and publish your listing. Buyers will contact you directly.'
    },
    {
      'question': 'How do I edit my listing?',
      'answer': 'Go to Profile > My Listings, find your book, and tap the three-dot menu to edit or delete your listing.'
    },
    {
      'question': 'What if I face issues with a seller/buyer?',
      'answer': 'If you face any issues, go to "Help & Support" in the app and raise a complaint. Our team will assist you.'
    },
    {
      'question': 'How do I change my location?',
      'answer': 'Go to Profile > Account > Location to update your address details.'
    },
    {
      'question': 'Can I save books for later?',
      'answer': 'Yes! Tap the heart icon on any book to add it to your Wishlist. Access your saved books from Profile > My Activity > Wishlists.'
    },
  ];

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
          "Help & Support",
          style: TextStyle(
            fontSize: 18,
            color: Colors.green,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(16.0),
          child: Column(
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround, // even spacing
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.green.shade50,
                            child: Icon(
                              Icons.email_outlined,
                              color: Colors.green,
                              size: 20,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Active",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.green.shade50,
                            child: Icon(
                              CupertinoIcons.phone,
                              color: Colors.green,
                              size: 20,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Call Us",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.green.shade50,
                            child: Icon(
                              CupertinoIcons.chat_bubble,
                              color: Colors.green,
                              size: 20,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Message",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16,),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[300]!),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.question_circle,
                            color: Colors.green,
                            size: 25,
                          ),
                          SizedBox(width: 10,),
                          Text(
                            "Frequently Asked Questions",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          )
                        ],
                      ),
                    ),

                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: faqData.length,
                      itemBuilder: (context, index) {
                        final faq = faqData[index];
                        return Theme(
                            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              title: Text(
                                faq['question']!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              childrenPadding: EdgeInsets.all(16),
                              children: [
                                Text(
                                  faq['answer']!,
                                  style: TextStyle(
                                    color: Colors.black54,
                                  ),
                                )
                              ],
                            )
                        );
                      },
                    ),

                    SizedBox(height: 18,),
                  ],
                ),
              ),
              SizedBox(height: 16,),

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
                          child: Text("Name *",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800])),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          decoration: _buildDecoration("Enter your name"),
                          validator: (value) =>
                          (value == null || !value.contains('@'))
                              ? "Enter a valid email."
                              : null,
                        ),
                        const SizedBox(height: 25),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Address",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800])),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          decoration: _buildDecoration("Enter your address"),
                          validator: (value) =>
                          (value == null || !value.contains('@'))
                              ? "Enter a valid email."
                              : null,
                        ),
                        const SizedBox(height: 25),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Email *",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800])),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          decoration: _buildDecoration("Enter your email"),
                          validator: (value) =>
                          (value == null || !value.contains('@'))
                              ? "Enter a valid email."
                              : null,
                        ),
                        const SizedBox(height: 25),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Subject *",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800])),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          decoration: _buildDecoration("Enter your subject"),
                        ),
                        const SizedBox(height: 25),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Message *",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800])),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          maxLines: 5,
                          minLines: 3,
                          decoration: _buildDecoration("Tell as how we can help you..."),
                        ),

                        SizedBox(height: 25,),

                        // ✅ Sign In Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                            icon: Icon(FeatherIcons.send),
                            label: _loading
                                ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                                : const Text('Send Message'),
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
      ),
    );
  }
}
