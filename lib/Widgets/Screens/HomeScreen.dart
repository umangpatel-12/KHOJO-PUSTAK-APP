import 'package:flutter/material.dart';
import 'BookDetailsScreen.dart';
import 'CategoryScreen.dart';
import 'Widgets/InfoCard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final bool isLoggedIn;

  bool isWishlisted = false; // default false

  Color myGreenColor = const Color(0xFF06923E);

  // Halka shade
  late final Color lightGreen = Color.lerp(myGreenColor, Colors.white, 0.4)!;

  final List<Map<String, dynamic>> categories = [
    {
      "title": "Engineering",
      "books": "500+ books",
      "color": Colors.blue.shade100,
      "textColor": Colors.blue,
    },
    {
      "title": "Medical",
      "books": "300+ books",
      "color": Colors.red.shade100,
      "textColor": Colors.red,
    },
    {
      "title": "MBA/Management",
      "books": "250+ books",
      "color": Colors.purple.shade100,
      "textColor": Colors.purple,
    },
    {
      "title": "Competitive Exams",
      "books": "400+ books",
      "color": Colors.orange.shade100,
      "textColor": Colors.orange,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== Top Container: Logo + SignIn/Register =====
      
              // ===== Search Bar =====
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
      
              // ===== Banner / Container =====
              Container(
                color: lightGreen,
                height: 200,
                child: const Center(child: Text("Your content here")),
              ),
      
              // =============== Category Section ============= //
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
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
                            Navigator.push(context, _createRoute(CategoryScreen()));
                          },
                          label: const Text(
                            "Filter",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          icon: const Icon(
                            Icons.filter_alt_outlined,
                            color: Colors.black54,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
      
                    // 👇 Row ke bilkul neeche GridView
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: categories.length,
                      padding: EdgeInsets.only(top: 5),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.6,
                      ),
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return
                          InkWell(
                          highlightColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: category["color"],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    category["title"],
                                    style: TextStyle(
                                      color: category["textColor"],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  category["books"],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
      
      
              // =============== Featured Books ============= //
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                      onPressed: () {},
                      label: const Text(
                        "View All",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      icon: const Icon(
                        Icons.trending_up,
                        color: Colors.black54,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),

              //Book Cards

              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                margin: const EdgeInsets.only(left: 12,right: 12,bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image section with Wishlist icon
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, _createRoute(BookDetailsScreen()));
                          },
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            child: Image.network(
                              "https://images.unsplash.com/photo-1553729784-e91953dec042",
                              height: 160,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        // Bestseller Tag
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
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ),

                        // Wishlist Heart Icon

                        // Positioned(
                        //   top: 2,
                        //   right: 8,
                        //   child: GestureDetector(
                        //     onTap: () {
                        //       setState(() {
                        //         isWishlisted = !isWishlisted;
                        //       });
                        //     },
                        //     child: CircleAvatar(
                        //       backgroundColor: Colors.transparent,
                        //       child: Icon(
                        //         isWishlisted ? Icons.favorite : Icons.favorite_border,
                        //         color: isWishlisted ? Colors.red : Colors.grey,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),

                    // Info section
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Chip(
                            label: Text("Academic"),
                            backgroundColor: Color(0xffe8f0fe),
                            labelStyle: TextStyle(fontSize: 12),
                            padding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                          ),
                          const SizedBox(height: 6),

                          Text(
                            "Ramauan",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text("by Rakesh",
                              style: const TextStyle(color: Colors.grey)),

                          const SizedBox(height: 6),

                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.orange, size: 18),
                              const SizedBox(width: 4),
                              Text("4.3"),
                              Text(" (20 reviews)",
                                  style: const TextStyle(color: Colors.grey)),
                            ],
                          ),

                          const SizedBox(height: 6),

                          Row(
                            children: [
                              Text("₹399",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 16,color: Colors.green)),
                              const SizedBox(width: 6),
                              Text(
                                "₹599",
                                style: const TextStyle(
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough),
                              ),
                              const Spacer(),
                              ElevatedButton.icon(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                icon: const Icon(
                                    Icons.add_shopping_cart,
                                    color: Colors.white,
                                    size: 18),
                                label: const Text(
                                    "Add",
                                    style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // =============== Availability Info ============= //
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                color: Colors.green[50],
                child: Column(
                  children: [
                    // First Row
                    Row(
                      children: [
                        Expanded(
                          child: InfoCard(
                            title: '10,000+',
                            subtitle: 'Books Available',
                          ),
                        ),
                        const SizedBox(width: 10),
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
                      children: [
                        Expanded(
                          child: InfoCard(
                            title: '24/7',
                            subtitle: 'Customer Support',
                          ),
                        ),
                        const SizedBox(width: 10),
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
            ],
          ),
        ),
      ),
    );
  }
}

// Custom Page Route with slide animation
Route _createRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Slide from right
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}