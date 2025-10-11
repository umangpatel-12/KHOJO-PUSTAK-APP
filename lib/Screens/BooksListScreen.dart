import 'package:flutter/material.dart';

class Bookslistscreen extends StatefulWidget {
  const Bookslistscreen({super.key, required String categoryName});

  @override
  State<Bookslistscreen> createState() => _BookslistscreenState();
}

class _BookslistscreenState extends State<Bookslistscreen> {
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
          "List",
          style: TextStyle(
            fontSize: 18,
            color: Colors.green,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
