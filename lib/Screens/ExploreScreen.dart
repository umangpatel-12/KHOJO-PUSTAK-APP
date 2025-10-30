import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khojpustak/Screens/BookDetailsScreen.dart';
import 'package:khojpustak/Widgets/CardLayouts/ButtonLayout.dart';
import 'package:shimmer/shimmer.dart';
import '../Widgets/Models/BookModel.dart';
import '../Widgets/Models/CategoryModel.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  bool _isLoading = true;
  int _selectedIndex = 0; // Default "All Books"
  String _selectedCategoryId = ''; // To track selected categoryId
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCategory();
  }

  Future<void> _fetchCategory() async {
    // Simulate shimmer delay
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: _appBar(),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 🔹 Category Section
          SliverToBoxAdapter(
            child: SizedBox(
              height: 65,
              child: FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance.collection('Category').get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    // 🔸 Loading shimmer for category chips
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      itemCount: 5,
                      itemBuilder: (context, index) => Container(
                        margin: const EdgeInsets.only(right: 10),
                        width: 80,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    );
                  }

                  final docs = snapshot.data!.docs;
                  // Add "All Books" at start
                  final allCategories = [
                    CategoryModel(cname: 'All Books', Subcategory: [], categoryId: ''),
                    ...docs.map((doc) => CategoryModel(
                        cname: doc['cname'],
                        Subcategory: [],
                        categoryId: doc['categoryId']))
                  ];

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    itemCount: allCategories.length,
                    itemBuilder: (context, index) {
                      bool isSelected = _selectedIndex == index;
                      final category = allCategories[index];

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                            _selectedCategoryId = category.categoryId;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.green : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.green
                                  : Colors.grey.shade400,
                              width: 1.3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isSelected
                                    ? Colors.green.withOpacity(0.3)
                                    : Colors.grey.withOpacity(0.1),
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              category.cname,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),

          // 🔹 Books Grid Section
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: StreamBuilder<QuerySnapshot>(
              stream: _selectedCategoryId.isEmpty
                  ? FirebaseFirestore.instance
                  .collection('Books')
                  .orderBy('title')
                  .snapshots()
                  : FirebaseFirestore.instance
                  .collection('Books')
                  .where('categoryId', isEqualTo: _selectedCategoryId)
                  .snapshots(),
              builder: (context, asyncSnapshot) {
                if (!asyncSnapshot.hasData) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: CircularProgressIndicator(color: Colors.green),
                      ),
                    ),
                  );
                }

                // final books = asyncSnapshot.data!.docs;
                final books = asyncSnapshot.data!.docs.where((doc) {
                  final title = doc['title'].toString().toLowerCase();
                  final query = _searchController.text.toLowerCase();
                  return title.contains(query);
                }).toList();

                if (books.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(50.0),
                        child: Text(
                          'No books found in this category 😕',
                          style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                        ),
                      ),
                    ),
                  );
                }

                return SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          final book = books[index];
                          final data = book.data() as Map<String, dynamic>;

                          // ✅ Safely extract all fields
                          BookModel bookmodel = BookModel(
                            title: data['title'] ?? '',
                            category: data['category'] ?? '',
                            images: List<String>.from(data['images'] ?? []),
                            description: data['description'] ?? '',
                            condition: data['condition'] ?? 'Good',
                            location: data['location'] ?? '',
                            phone: data['phone'] ?? '',
                            price: double.tryParse(data['price'].toString()) ?? 0.0,
                            userId: data['userId'] ?? '',
                            author: data['author'] ?? 'Unknown',
                          );

                      if (_isLoading) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      }

                      return GestureDetector(
                        onTap: () {
                          // TODO: Navigate to Book details page
                          Navigator.push(context, createRoute(BookDetailsScreen(book: bookmodel)));
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),
                                    child: bookmodel.images.isNotEmpty
                                        ? Image.network(
                                      bookmodel.images[0],
                                      height: 145,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    )
                                        : Image.asset(
                                      "assets/images/user_pic.png",
                                      height: 145,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: CircleAvatar(
                                      radius: 14,
                                      backgroundColor: Colors.white.withOpacity(0.6),
                                      child: const Icon(Icons.favorite_border,
                                          color: Colors.white70, size: 18),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        bookmodel.title,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: const [
                                          Text(
                                            '₹499',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                            ),
                                          ),
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
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: books.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 18,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.70,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 AppBar with blur and title
  PreferredSizeWidget _appBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(145),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: Colors.white.withOpacity(0.5),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  Text(
                    "Explore Books",
                    style: TextStyle(
                      color: Colors.grey.shade900,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Find your next great read",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _searchbar(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 Search Bar
  Widget _searchbar() {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (_) => setState(() {}), // refresh on typing
        decoration: InputDecoration(
          hintText: 'Search by title...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
