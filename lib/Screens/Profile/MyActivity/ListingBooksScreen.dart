import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khojpustak/Widgets/Models/BookModel.dart';

import '../../../Controller/BookService.dart';
import '../../../Widgets/CardLayouts/ListingCardLayout.dart';

class ListingBookScreen extends StatefulWidget {
  const ListingBookScreen({super.key});

  @override
  State<ListingBookScreen> createState() => _ListingBookScreenState();
}

class _ListingBookScreenState extends State<ListingBookScreen> {

  final user = FirebaseAuth.instance.currentUser;
  final BookService _bookService = BookService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.2,
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        title: Text(
          "My Listings",
          style: TextStyle(
            color: Colors.green,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.green,size: 20),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
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
                          const Text(
                            "5",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Active",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green.shade700,
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
                          const Text(
                            "2",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Sold",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.red.shade700,
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
                          Text(
                            "2",
                            style: TextStyle(
                              fontSize: 18,
                              color: CupertinoColors.activeBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Inactive",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Books')
                  .where('userId', isEqualTo: user?.uid ?? '')
                  .snapshots(),
              builder: (context, snapshot) {
                print(snapshot.data);
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No books uploaded yet.'));
                }

                final books = snapshot.data!.docs;


                return ListView.builder(
                  shrinkWrap: true, // ✅ allow inside scrollview
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: books.length,
                  itemBuilder: (BuildContext context, int index)
                  {
                    final book = books[index].data() as Map<String, dynamic>;
                    return GestureDetector(
                      onTap: (){

                      },
                      child: CustomContainer(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.06),
                                        blurRadius: 18,
                                        offset: Offset(0, 8),
                                      )
                                    ]
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: book['images'] != null && book['images'].toString().isNotEmpty
                                      ? Image.network(
                                    (book['images'] as List<dynamic>)[0].toString(),
                                    height: 130,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  )
                                      : Image.asset(
                                    "assets/images/user_pic.png", // koi default image
                                    height: 130,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),

                              ),
                              SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    book['title'],
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),

                                  SizedBox(height: 2,),
                                  Text(
                                    "By ${book['author'] ?? ''}",
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),

                                  SizedBox(height: 2,),
                                  Row(
                                    children: [
                                      Text("₹ ${book['price'] ?? ''}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 16,color: Colors.green)),
                                      const SizedBox(width: 6),
                                      Text(
                                        "₹${book['oldprice'] ?? ''}",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            decoration: TextDecoration.lineThrough),
                                      ),
                                      SizedBox(width: 16,),
                                    ],
                                  ),

                                  SizedBox(height: 2,),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 13,vertical: 6.5),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade100,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          'Active',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green.shade900,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            color: Colors.grey.shade400, // light grey border
                                            width: 1.2,
                                          ),
                                        ),
                                        child: const Text(
                                          'Like New',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 6,),
                                  Row(
                                      children: [
                                        Icon(
                                          Icons.location_on_outlined,
                                          color: Colors.black54,
                                          size: 18,
                                        ),
                                        SizedBox(width: 3,),
                                        Text(
                                          "Ahmedabad",
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(width: 16,),
                                        Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                          size: 18  ,
                                        ),
                                        SizedBox(width: 3,),
                                        Text(
                                          "20",
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ]
                                  ),

                                ],
                              ),
                            ],
                          )
                      ),
                    );
                  },
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}
