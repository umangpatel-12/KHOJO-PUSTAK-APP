import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khojpustak/Screens/BooksCategoryList.dart';
import 'package:khojpustak/Widgets/Models/BookModel.dart';
import 'package:shimmer/shimmer.dart'; // 👈 Add shimmer package
import '../../Controller/banner_controller.dart';
import '../Widgets/CardLayouts/ButtonLayout.dart';
import '../Widgets/Models/CategoryModel.dart';
import 'BookDetailsScreen.dart';
import 'BooksListScreen.dart';
import 'CategoryScreen.dart';
import '../Widgets/CardLayouts/InfoCard.dart';
import 'SubCategoryScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final bool isLoggedIn;
  final BannerController _bannerController = BannerController();
  final ScrollController _scrollController = ScrollController(); // 👈 for smooth scroll

  bool isWishlisted = false;
  bool _isLoading = true;
  late final String categoryId;
  Color myGreenColor = const Color(0xFF06923E);
  late final Color lightGreen = Color.lerp(myGreenColor, Colors.white, 0.4)!;

  final List<Color> categoryColors = [
    Color(0xFF2E3B55),
    Color(0xFF3E2723),
    Color(0xFF4A148C),
    Color(0xFF0B3D91),
    Color(0xFF880E4F),
    Color(0xFF004D40),
    Color(0xFF1A237E),
    Color(0xFF263238),
  ];

  @override
  void initState() {
    super.initState();
    isLoggedIn = false;
    _bannerController.init();
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _bannerController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          controller: _scrollController, // 👈 smooth scroll controller
          // physics: const BouncingScrollPhysics(), // 👈 smooth scroll feel
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: Colors.white,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search for books...",
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    prefixIcon: const Icon(Icons.search, color: Colors.green),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // 🔹 Banner Section with shimmer
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: AnimatedBuilder(
                  animation: _bannerController,
                  builder: (context, child) {
                    if (_bannerController.isLoading) {
                      // 🔥 Shimmer Placeholder
                      return Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      );
                    }

                    if (_bannerController.bannerImageUrls.isEmpty) {
                      return Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: lightGreen,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child:
                        const Center(child: Text("No banner images available")),
                      );
                    }

                    return SizedBox(
                      height: 200,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          PageView.builder(
                            controller: _bannerController.pageController,
                            itemCount: _bannerController.bannerImageUrls.length,
                            onPageChanged: _bannerController.onPageChanged,
                            itemBuilder: (context, index) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: Image.network(
                                  _bannerController.bannerImageUrls[index],
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                          Positioned(
                            bottom: 10.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                  _bannerController.bannerImageUrls.length,
                                      (index) {
                                    return Container(
                                      width: 8.0,
                                      height: 8.0,
                                      margin:
                                      const EdgeInsets.symmetric(horizontal: 4.0),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _bannerController.currentPage == index
                                            ? myGreenColor
                                            : Colors.grey[400],
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // 🔹 Category Section
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Browse Categories",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: () {
                            Navigator.push(
                                context, _createRoute(const CategoryScreen()));
                          },
                          label: const Text(
                            "Filter",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          icon: const Icon(Icons.filter_alt_outlined,
                              color: Colors.black54, size: 18),
                        ),
                      ],
                    ),

                    // 🔥 Shimmer for Category Loading
                    FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('Category')
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 4,
                              gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1.6,
                              ),
                              itemBuilder: (context, index) {
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
                              },
                            );
                          }

                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return const Center(
                                child: Text("No categories found 😢"));
                          }

                          return
                            GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 4,
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 1.6,
                            ),
                            itemBuilder: (context, index) {
                              final doc = snapshot.data!.docs[index];
                              final color = categoryColors[index % categoryColors.length];
                              // final categoryId = doc.id;
                              final String categoryId = doc['categoryId'];

                              CategoryModel categoryModel =
                              CategoryModel(cname: doc['cname'], Subcategory: [], categoryId: categoryId);

                              return InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () async {
                                  // ✅ Ab correct categoryId ke basis pe subcategory fetch karo
                                  final subcategorySnapshot = await FirebaseFirestore.instance
                                      .collection('Category')
                                      .doc(categoryId)
                                      .collection('Subcategory')
                                      .get();

                                  if (subcategorySnapshot.docs.isNotEmpty) {
                                    Navigator.push(
                                        context,
                                        createRoute(SubCategoryScreen(
                                            categoryId: categoryId,
                                            categoryName: categoryModel.cname)));
                                  } else {
                                    Navigator.push(
                                        context,
                                        createRoute(BooksCategoryList(categoryName: categoryModel.cname, categoryId: categoryModel.categoryId,)));
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: color.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: Colors.grey.shade300),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: color.withOpacity(0.15),
                                          borderRadius:
                                          BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          categoryModel.cname,
                                          style: TextStyle(
                                            color: color.withOpacity(0.8),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        "books",
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
                        }),
                  ],
                ),
              ),

              // 🔹 Featured Books Section
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    const Text(
                      "Featured Books",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                            context,
                            _createRoute(Bookslistscreen(categoryName: '',)));
                      },
                      label: const Text(
                        "View All",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      icon: const Icon(Icons.trending_up,
                          color: Colors.black54, size: 18),
                    ),
                  ],
                ),
              ),

              // 🔹 Static Featured Card

// Inside your widget:
              FutureBuilder(
                future: FirebaseFirestore.instance.collection('Books').get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // ✅ Shimmer effect while loading
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 6, // number of shimmer cards
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                            margin:
                            const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Shimmer image placeholder
                                Container(
                                  height: 160,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 16,
                                        color: Colors.grey[300],
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        width: 150,
                                        height: 16,
                                        color: Colors.grey[300],
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        width: 100,
                                        height: 14,
                                        color: Colors.grey[300],
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        width: 60,
                                        height: 16,
                                        color: Colors.grey[300],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No books found 😢"));
                  }

                  // ✅ Real data after loading
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final doc = snapshot.data!.docs[index];
                      final data = doc.data() as Map<String, dynamic>;

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

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        margin:
                        const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, createRoute(BookDetailsScreen(book: bookmodel)));
                                  },
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),
                                    child: Image.network(
                                      bookmodel.images.isNotEmpty
                                          ? bookmodel.images[0]
                                          : 'https://via.placeholder.com/150',
                                      height: 160,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  left: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      "Bestseller",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Chip(
                                    label: Text(bookmodel.category),
                                    backgroundColor: const Color(0xffe8f0fe),
                                    labelStyle: const TextStyle(fontSize: 12),
                                    padding: EdgeInsets.zero,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    bookmodel.title,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "by ${bookmodel.author ?? 'Unknown Author'}",
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  const SizedBox(height: 6),
                                  const Row(
                                    children: [
                                      Icon(Icons.star,
                                          color: Colors.orange, size: 18),
                                      SizedBox(width: 4),
                                      Text("4.3"),
                                      Text(" (20 reviews)",
                                          style: TextStyle(color: Colors.grey)),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Text(
                                        "₹${bookmodel.price}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.green,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      const Text(
                                        "₹599",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          decoration: TextDecoration.lineThrough,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),

              // 🔹 Availability Info
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                color: Colors.green[50],
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Expanded(
                          child: InfoCard(
                            title: '10,000+',
                            subtitle: 'Books Available',
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: InfoCard(
                            title: '50,000+',
                            subtitle: 'Happy Customers',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: const [
                        Expanded(
                          child: InfoCard(
                            title: '24/7',
                            subtitle: 'Customer Support',
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: InfoCard(
                            title: 'Free',
                            subtitle: 'Delivery Available',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 70),
            ],
          ),
        ),
      ),
    );
  }
}

// 🔹 Page Route Animation
Route _createRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder:
        (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;
      var tween = Tween(begin: begin, end: end)
          .chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);
      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}
