// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:khojpustak/Widgets/Models/SubCategory.dart';
//
// class SubCategoryScreen extends StatefulWidget {
//   const SubCategoryScreen({super.key,required String categoryId, required String categoryName,});
//
//   @override
//   State<SubCategoryScreen> createState() => _SubCategoryScreenState();
// }
//
// class _SubCategoryScreenState extends State<SubCategoryScreen> {
//
//   final List<Color> categoryColors = [
//     Colors.green.shade100,
//     Colors.blue.shade100,
//     Colors.orange.shade100,
//     Colors.purple.shade100,
//     Colors.pink.shade100,
//     Colors.yellow.shade100,
//     Colors.teal.shade100,
//     Colors.red.shade100,
//   ];
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         shadowColor: Colors.white,
//         elevation: 0.2,
//         centerTitle: true,
//         iconTheme: const IconThemeData(color: Colors.green, size: 22),
//         title: const Text(
//           "Sub Categories",
//           style: TextStyle(
//             fontSize: 18,
//             color: Colors.green,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
//       body: FutureBuilder(
//           future: FirebaseFirestore.instance.collection("Category").doc().collection('Subcategory').get(),
//           builder: (context, snapshot){
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             }
//             if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//               return const Center(child: Text("No subcategories found"));
//             }
//             return GridView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: snapshot.data!.docs.length,
//               padding: const EdgeInsets.only(top: 5),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 12,
//                 mainAxisSpacing: 12,
//                 childAspectRatio: 1.6,
//               ),
//               itemBuilder: (context, index) {
//                 // final category = categories[index];
//                 final color = categoryColors[index % categoryColors.length];
//                 SubcategoryModel subcategoryModel = SubcategoryModel(
//                     subcname: snapshot.data!.docs[index]['subcname']
//                 );
//                 return InkWell(
//                   highlightColor: Colors.transparent,
//                   borderRadius: BorderRadius.circular(12),
//                   onTap: () {},
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white38,
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: Colors.grey.shade300),
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 10, vertical: 2),
//                           decoration: BoxDecoration(
//                             color: color.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Text(
//                             subcategoryModel.subcname,
//                             style: TextStyle(
//                               color: color,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           "books",
//                           style: const TextStyle(
//                             fontSize: 14,
//                             color: Colors.black54,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           }
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khojpustak/Widgets/CardLayouts/ButtonLayout.dart';
import 'package:khojpustak/Widgets/Models/SubCategory.dart';
import 'BooksCategoryList.dart';
import 'BooksListScreen.dart';

class SubCategoryScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const SubCategoryScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {

  final List<Color> categoryColors = [
    Color(0xFF1B5E20), // Dark Green
    Color(0xFF0D47A1), // Dark Blue
    Color(0xFFE65100), // Deep Orange
    Color(0xFF4A148C), // Dark Purple
    Color(0xFFB71C1C), // Dark Red
    Color(0xFFF57F17), // Dark Yellow / Amber
    Color(0xFF00695C), // Dark Teal
    Color(0xFF263238), // Dark Gray / Blue-Gray
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
        title: Text(
          widget.categoryName,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.green,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection("Category")
              .doc(widget.categoryId)
              .collection('Subcategory')
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No subcategories found"));
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
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

                SubcategoryModel subcategoryModel = SubcategoryModel(
                    cname: doc['cname'],
                    categoryId: doc['categoryId'],
                    subcategoryId: doc.id
                );

                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    print('Subcategory tapped: ${subcategoryModel.categoryId}');
                    // You can navigate to BooksListScreen for this subcategory
                    Navigator.push(context, createRoute(
                      BooksCategoryList(
                        categoryName: widget.categoryName,
                        categoryId: widget.categoryId,
                        subcategoryId: doc.id, // 👈 subcategory document ID
                        subcategoryName: doc['cname'], // 👈 subcategory name
                      ),
                    ));
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
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.20),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            subcategoryModel.cname,
                            style: TextStyle(
                              color: color, // darker shade for text
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
