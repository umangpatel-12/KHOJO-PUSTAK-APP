import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class BookDetailsScreen extends StatefulWidget {
  const BookDetailsScreen({super.key});

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  static const Color primaryGreen = Color(0xFF05A941);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Book Details",
          style: TextStyle(
            fontSize: 18,
            color: Colors.green,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white60,
        shadowColor: Colors.black12,
        elevation: 1,
        actions: [
          IconButton(
            icon: Icon(
              FeatherIcons.share2,
              size: 22,
            ),
            onPressed: () {  },
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(PhosphorIconsBold.heart,size: 22,),
          ),
        ],
      ),

      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.1),
              spreadRadius: 5,
              offset: Offset(0, 3),
            )
          ]
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {},
                child: ClipRRect(
                  child: Image.network(
                    "https://images.unsplash.com/photo-1553729784-e91953dec042",
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SizedBox(height: 16,),

              Padding(
                padding: EdgeInsets.only(left: 16,right: 16,top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Book Title
                    Text(
                      "Book Title of ramayan and show Loard Ram History",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(height: 10,),

                    // Book Auther
                    Row(
                      children: [
                        Text(
                            "By",
                          style: TextStyle(
                            color: Colors.black38,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        SizedBox(width: 5,),

                        Text(
                          "Author Name",
                          style: TextStyle(
                            color: Colors.black38,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],

                    ),

                    SizedBox(height: 12,),

                    // Book Price
                    Row(
                      children: [
                        Text(
                          "₹399",
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(width: 8,),

                        Text(
                          "₹599",
                          style: TextStyle(
                            color: Colors.black38,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        SizedBox(width: 8,),
                      ]
                    ),

                    SizedBox(height: 12,),

                    // Contact Button
                    SizedBox(
                      width: double.infinity,
                      child:
                      // _loading ? CircularProgressIndicator() :
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          foregroundColor: Colors.white,
                          padding:
                          const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Icon(
                              FeatherIcons.messageCircle,
                              color: Colors.white,
                            ),

                            SizedBox(width: 12,),

                            const Text('Contact Seller'),
                          ],
                        ),
                      ),
                    ),

                    SizedBox( height: 16,),
                    Divider(height: 8,),
                    SizedBox(height: 5,),

                    // Book Information
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Book Details",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Main Row for 2 Columns
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Left Column
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    // label - value pair
                                    // (Category)
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 12.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Category:", style: TextStyle(fontWeight: FontWeight.w500)),
                                          SizedBox(height: 4),
                                          Text("academic"),
                                        ],
                                      ),
                                    ),
                                    // Pages
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 12.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Pages:", style: TextStyle(fontWeight: FontWeight.w500)),
                                          SizedBox(height: 4),
                                          Text("856"),
                                        ],
                                      ),
                                    ),
                                    // Year
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 12.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Year:", style: TextStyle(fontWeight: FontWeight.w500)),
                                          SizedBox(height: 4),
                                          Text("2022"),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Right Column
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    // Language
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 12.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Language:", style: TextStyle(fontWeight: FontWeight.w500)),
                                          SizedBox(height: 4),
                                          Text("English"),
                                        ],
                                      ),
                                    ),
                                    // Publisher
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 12.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Publisher:", style: TextStyle(fontWeight: FontWeight.w500)),
                                          SizedBox(height: 4),
                                          Text("McGraw Hill Education"),
                                        ],
                                      ),
                                    ),
                                    // ISBN
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 12.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("ISBN:", style: TextStyle(fontWeight: FontWeight.w500)),
                                          SizedBox(height: 4),
                                          Text("978-0071070405"),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox( height: 5,),
                    Divider(height: 8,),
                    SizedBox(height: 2,),

                    // Description
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Description",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          SizedBox(height: 12,),

                          Text(
                            "Do you want me to also make a reusable function (like buildDetailItem) so you don’t have to repeat the same Padding + Column code for each label/value?",
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 5,)
                  ],
                ),
              )
            ]
          ),
        ),
      ),
    );
  }
}
