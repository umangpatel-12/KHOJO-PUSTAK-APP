import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../Widgets/CardLayouts/ButtonLayout.dart';
import '../Widgets/Models/BookModel.dart';
import 'BookDetailsScreen.dart';

class BooksCategoryList extends StatefulWidget {
  final String categoryName;
  final String categoryId;

  const BooksCategoryList({super.key, required this.categoryName, required this.categoryId});

  @override
  State<BooksCategoryList> createState() => _BooksCategoryListState();
}

class _BooksCategoryListState extends State<BooksCategoryList> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        _isLoading = false;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        elevation: 0.2,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.green, size: 22),
        title: Text(
          widget.categoryName,
          style: TextStyle(
            fontSize: 18,
            color: Colors.green,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Books')
              .where('categoryId',isEqualTo: widget.categoryId)
              .snapshots(),
          builder: (context, snapshot) {
            // 🟢 STEP 1: Show Shimmer while loading
            if (snapshot.connectionState == ConnectionState.waiting || _isLoading) {
              return GridView.builder(
                padding: const EdgeInsets.all(14),
                physics: const BouncingScrollPhysics(),
                itemCount: 6, // shimmer placeholder count
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.70,
                ),
                itemBuilder: (context, index) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
              );
            }

            // 🟡 STEP 2: No data found
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text("No books found 😢"),
              );
            }

            // 🟣 STEP 3: Data available → Show real grid
            final mybooks = snapshot.data!.docs;
            return GridView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(14),
              itemCount: mybooks.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 18,
                mainAxisSpacing: 15,
                childAspectRatio: 0.70,
              ),
              itemBuilder: (BuildContext context, int index) {
                final myBooks = mybooks[index].data() as Map<String, dynamic>;
                BookModel bookmodel = BookModel(
                  title: myBooks['title'] ?? '',
                  category: myBooks['category'] ?? '',
                  images: List<String>.from(myBooks['images'] ?? []),
                  description: myBooks['description'] ?? '',
                  condition: myBooks['condition'] ?? 'Good',
                  location: myBooks['location'] ?? '',
                  phone: myBooks['phone'] ?? '',
                  price: double.tryParse(myBooks['price'].toString()) ?? 0.0,
                  userId: myBooks['userId'] ?? '',
                  author: myBooks['author'] ?? 'Unknown',
                  oldprice: double.tryParse(myBooks['oldprice'].toString()) ?? 0.0,
                );

                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white60,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            createRoute(BookDetailsScreen(book: bookmodel)),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          child: myBooks['images'] != null &&
                              myBooks['images'].toString().isNotEmpty
                              ? Image.network(
                            (myBooks['images'] as List<dynamic>)[0].toString(),
                            height: 155,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                              : Image.asset(
                            "assets/images/user_pic.png",
                            height: 155,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                myBooks['title'] ?? '',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '₹499',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        '₹699',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey,
                                          decoration: TextDecoration.lineThrough,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
