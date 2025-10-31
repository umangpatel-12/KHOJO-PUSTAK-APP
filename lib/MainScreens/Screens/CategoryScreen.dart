import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khojpustak/Widgets/CardLayouts/ButtonLayout.dart';
import 'package:khojpustak/Widgets/Models/CategoryModel.dart';

import 'BooksListScreen.dart';
import 'SubCategoryScreen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final List<MaterialColor> categoryColors = [
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.yellow,
    Colors.teal,
    Colors.red,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        elevation: 0.2,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.green, size: 22),
        title: const Text(
          "Categories",
          style: TextStyle(
            fontSize: 18,
            color: Colors.green,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child:
        FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection('Category').get(),
          builder: (context, snapshot) {
            // Error state
            if (snapshot.hasError) {
              return const Center(
                child: Text('Something went wrong 😕'),
              );
            }
            // Loading state
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            // Empty state
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('No categories found 😢'),
              );
            }

            return GridView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              padding: const EdgeInsets.only(top: 5),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.6,
              ),
              itemBuilder: (context, index) {
                final doc = snapshot.data!.docs[index];
                final color = categoryColors[index % categoryColors.length];
                final String categoryId = doc['categoryId'];



                CategoryModel categoryModel = CategoryModel(
                  cname: doc['cname'], Subcategory: [], categoryId: categoryId,
                );


                return InkWell(
                  highlightColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  onTap: () async {
                    // 🔹 Check if subcategories exist in this category
                    final subcategorySnapshot = await FirebaseFirestore.instance
                        .collection('Category')
                        .doc(categoryId)
                        .collection('Subcategory')
                        .get();

                    if (subcategorySnapshot.docs.isNotEmpty) {
                      // ✅ Subcategories exist → go to SubCategoryScreen
                      Navigator.push(context, createRoute(SubCategoryScreen(categoryId: categoryId, categoryName: categoryModel.cname)));
                    } else {
                      // ❌ No subcategories → go to BooksListScreen
                      Navigator.push(context, createRoute(Bookslistscreen(categoryName: categoryModel.cname)));
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            categoryModel.cname,
                            style: TextStyle(
                              color: color.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Books",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
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
