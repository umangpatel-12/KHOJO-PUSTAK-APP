import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Added Firestore import

class BannerController with ChangeNotifier {
  final PageController pageController = PageController();
  Timer? _bannerTimer;
  int _currentPage = 0;

  // Changed to non-final and initialized as empty
  List<String> _bannerImageUrls = [];
  bool _isLoading = true; // Added loading state

  int get currentPage => _currentPage;
  List<String> get bannerImageUrls => _bannerImageUrls;
  bool get isLoading => _isLoading; // Getter for loading state

  BannerController() {
    // init(); // Called from HomeScreen's initState
  }

  // Fetches banner URLs from Firestore
  Future<void> _fetchBannerUrlsFromFirestore() async {
    _isLoading = true;
    notifyListeners(); // Notify UI that loading has started

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('banners') // Your Firestore collection name
          .get();

      if (snapshot.docs.isNotEmpty) {
        _bannerImageUrls = snapshot.docs
            .map((doc) => doc['imageUrl'] as String) // Assuming 'imageUrl' field
            .toList();
      } else {
        _bannerImageUrls = []; // Set to empty if no banners found
      }
    } catch (e) {
      print("Error fetching banners: $e");
      _bannerImageUrls = []; // Set to empty on error
      // You might want to set a specific error state here
    }

    _isLoading = false;
    notifyListeners(); // Notify UI that loading is complete

    // Start timer only if we have images
    if (_bannerImageUrls.isNotEmpty) {
      _startBannerTimer();
    }
  }

  void _startBannerTimer() {
    // Ensure we only start if there are images and cancel any existing timer
    if (_bannerImageUrls.isEmpty) return;
    _bannerTimer?.cancel(); 

    _bannerTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_bannerImageUrls.isEmpty) { // Double check in case list becomes empty
        timer.cancel();
        return;
      }
      if (_currentPage < _bannerImageUrls.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (pageController.hasClients) {
        pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
      // notifyListeners() is called by onPageChanged
    });
  }

  void onPageChanged(int page) {
    _currentPage = page;
    notifyListeners();
  }

  // Call this when the widget using the controller is initialized.
  Future<void> init() async { // Changed to async
    await _fetchBannerUrlsFromFirestore();
    // _startBannerTimer is now called within _fetchBannerUrlsFromFirestore after data is loaded
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    pageController.dispose();
    super.dispose();
  }
}
