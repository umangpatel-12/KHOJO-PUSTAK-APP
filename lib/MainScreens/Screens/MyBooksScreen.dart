import 'package:flutter/material.dart';
import 'dart:async'; // For simulating data fetch

class MyBooksScreen extends StatefulWidget {
  const MyBooksScreen({super.key});

  @override
  State<MyBooksScreen> createState() => _MyBooksScreenState();
}

class _MyBooksScreenState extends State<MyBooksScreen> {
  bool isSelling = true; // default tab
  bool isLoading = true; // overall loading state

  List<Map<String, String>> sellingBooks = [];
  List<Map<String, String>> boughtBooks = [];

  @override
  Widget build(BuildContext context) {
    // Choose current list based on tab
    List<Map<String, String>> currentList =
    isSelling ? sellingBooks : boughtBooks;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white60,
        shadowColor: Colors.black12,
        elevation: 1,
        title: Text(
          "My Books",
          style: TextStyle(
            fontSize: 22,
            color: Colors.green,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Earnings Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.trending_up,color: Colors.green,),
                      SizedBox(width: 8,),
                      const Text(
                        'Your Earnings',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32), // Dark green text
                        ),
                      ),

                    ],
                  ),

                  const SizedBox(height: 16),
                  _buildEarningRow('Total Earned', '₹2,450'),
                  _buildEarningRow('This Month', '₹599'),
                  _buildEarningRow('Pending', '₹0'),


                  // Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //     children: const [
                  //       Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Text("₹2,450",
                  //               style: TextStyle(
                  //                   fontWeight: FontWeight.bold, fontSize: 18)),
                  //           SizedBox(height: 4),
                  //           Text("Total Earned",
                  //               style: TextStyle(color: Colors.black54)),
                  //         ],
                  //       ),
                  //       Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Text("₹599",
                  //               style: TextStyle(
                  //                   fontWeight: FontWeight.bold, fontSize: 18)),
                  //           SizedBox(height: 4),
                  //           Text("This Month",
                  //               style: TextStyle(color: Colors.black54)),
                  //         ],
                  //       ),
                  //       Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Text("₹0",
                  //               style: TextStyle(
                  //                   fontWeight: FontWeight.bold, fontSize: 18)),
                  //           SizedBox(height: 4),
                  //           Text("Pending",
                  //               style: TextStyle(color: Colors.black54)),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            // Tabs
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isSelling = true;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelling ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            "Books I'm Selling",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isSelling ? Colors.black : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isSelling = false;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: !isSelling ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            "Books I Bought",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: !isSelling ? Colors.black : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Book List with per-card loading
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: isLoading ? 3 : currentList.length,
                itemBuilder: (context, index) {
                  if (isLoading) {
                    // Show 3 loading cards while fetching
                    return _bookCard(isLoading: true);
                  }

                  final book = currentList[index];
                  return _bookCard(
                    title: book["title"]!,
                    author: book["author"]!,
                    price: book["price"]!,
                    oldPrice: book["oldPrice"]!,
                    condition: book["condition"]!,
                    status: book["status"]!,
                    imageUrl: book["imageUrl"]!,
                    views: book["views"]!,
                    chats: book["chats"]!,
                    time: book["time"]!,
                    isLoading: false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Book Card Widget
  Widget _bookCard({
    String title = "",
    String author = "",
    String price = "",
    String oldPrice = "",
    String condition = "",
    String status = "",
    String imageUrl = "",
    String views = "",
    String chats = "",
    String time = "",
    bool isLoading = false,
  }) {
    if (isLoading) {
      return Card(
        margin: const EdgeInsets.only(bottom: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: const SizedBox(
          height: 120,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                height: 90,
                width: 70,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: status == "Active"
                              ? Colors.green.withOpacity(0.1)
                              : Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(status,
                            style: TextStyle(
                                color: status == "Active"
                                    ? Colors.green
                                    : Colors.orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 12)),
                      )
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text("by $author",
                      style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(price,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.green)),
                      const SizedBox(width: 8),
                      Text(oldPrice,
                          style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(condition,
                            style: const TextStyle(
                                color: Colors.green, fontSize: 12)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.remove_red_eye,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text("$views views",
                          style:
                          const TextStyle(color: Colors.grey, fontSize: 12)),
                      const SizedBox(width: 20),
                      Text(time,
                          style:
                          const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  )
                ],
              ),
            ),

            // Edit/Delete
            Column(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.edit, color: Colors.grey),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

Widget _buildEarningRow(String label, String amount) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF2E7D32),
          ),
        ),
        Text(
          amount,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E7D32),
          ),
        ),
      ],
    ),
  );
}
