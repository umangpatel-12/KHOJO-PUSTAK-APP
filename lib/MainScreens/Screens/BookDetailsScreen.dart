import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:khojpustak/Widgets/Models/BookModel.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class BookDetailsScreen extends StatefulWidget {
  final BookModel book;

  const BookDetailsScreen({super.key, required this.book});

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  static const Color primaryGreen = Color(0xFF05A941);
  bool isFavourite = false; // ✅ Move here (not inside build)

  @override
  void initState() {
    super.initState();
    _checkIfFavourite();
  }

  Future<void> _makePhoneCall(String phone) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phone,
    );
    if (await canLaunchUrl(launchUri)) {
    await launchUrl(launchUri);
    } else {
    throw 'Could not launch $phone';
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Calling $phone')),
    );
  }

  void _shareBookDetails(BookModel book) {
    final String bookDetails = '''
📚 *Name: ${book.title}*  
✍️ Author: ${book.author}  
🏷️ Category: ${book.category}  
💰 Price: ₹${book.price}  
📍 Location: ${book.location}
📖 Condition: ${book.condition}
🖼️ Image: ${book.images.isNotEmpty ? book.images[0] : 'No image available'}

Check out this amazing book on Khojo Pustak! 🔥
''';

    Share.share(bookDetails);
  }


  // ✅ Check if current book is already in favourites
  Future<void> _checkIfFavourite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final favCollection = FirebaseFirestore.instance.collection('Favourite');
    final existing = await favCollection
        .where('userId', isEqualTo: user.uid)
        .where('title', isEqualTo: widget.book.title)
        .limit(1)
        .get();

    if (existing.docs.isNotEmpty) {
      setState(() {
        isFavourite = true;
      });
    }
  }

  // ✅ Toggle favourite
  Future<void> _favouritetoggle(BookModel book) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final favCollection = FirebaseFirestore.instance.collection('Favourite');
    final existing = await favCollection
        .where('userId', isEqualTo: user.uid)
        .where('bookId', isEqualTo: book.title)
        .limit(1)
        .get();

    if (existing.docs.isNotEmpty) {
      // 🔥 Already exists → remove it
      await favCollection.doc(existing.docs.first.id).delete();
      setState(() {
        isFavourite = false;
      });
      ScaffoldMessenger.of( context ).showSnackBar(
        const SnackBar(content: Text('Removed from favourite list')),
      );
    } else {
      // ❤️ Not in favourites → add it
      await favCollection.add({
        'userId': user.uid,
        'title': book.title,
        'bookId': book.id,
        'price': book.price,
        'images': book.images,
        'phone': book.phone,
        'originalPrice': book.originalPrice,
        'category': book.category,
        'condition': book.condition,
        'location': book.location,
        'description': book.description,
        'author': book.author,
        'createdAt': FieldValue.serverTimestamp(),
      });

      setState(() {
        isFavourite = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Added to favourite list')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
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
        iconTheme: IconThemeData(color: Colors.green,size: 22),
        actions: [
          IconButton(
            icon: const Icon(FeatherIcons.share2, size: 21),
            onPressed: () {
              _shareBookDetails(book);
            },
          ),
          IconButton(
            onPressed: () => _favouritetoggle(book),
            icon: Icon(
              isFavourite
                  ? CupertinoIcons.heart_fill
                  : PhosphorIconsBold.heart,
              color: isFavourite ? Colors.red : Colors.black,
              size: 22,
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Book Image
            ClipRRect(
              child: Image.network(
                book.images.isNotEmpty
                    ? book.images[0]
                    : "https://via.placeholder.com/300",
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ Title
                  Text(
                    book.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ✅ Author
                  Row(
                    children: [
                      const Text(
                        "By ",
                        style: TextStyle(
                          color: Colors.black38,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        book.author ?? "Unknown",
                        style: const TextStyle(
                          color: Colors.black38,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // ✅ Price
                  Row(
                    children: [
                      Text("₹ ${book.price} ",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16,color: Colors.green)),
                      const SizedBox(width: 6),
                      Text(
                        "₹${book.originalPrice}",
                        style: TextStyle(
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough),
                      ),
                      SizedBox(width: 16,),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // ✅ Contact Seller Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _makePhoneCall(book.phone);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(FeatherIcons.messageCircle, color: Colors.white),
                          SizedBox(width: 12),
                          Text('Contact Seller'),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  const Divider(height: 8),

                  // ✅ Book Information
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

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left column
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildDetailItem("Category", book.category),
                                  buildDetailItem("Condition", book.condition),
                                  buildDetailItem("Location", book.location),
                                ],
                              ),
                            ),
                            // Right column
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildDetailItem("Seller ID", book.userId),
                                  buildDetailItem("Phone", book.phone),
                                  buildDetailItem("Price", "₹${book.price}"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 8),

                  // ✅ Description
                  Padding(
                    padding: const EdgeInsets.all(12),
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
                        const SizedBox(height: 12),
                        Text(
                          book.description.isNotEmpty
                              ? book.description
                              : "No description provided.",
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Helper widget for Book Info
  Widget buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(value.isNotEmpty ? value : "-"),
        ],
      ),
    );
  }
}
