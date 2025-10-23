import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:khojpustak/Widgets/Models/CategoryModel.dart';
import '../../main.dart';

class SellScreen extends StatefulWidget {
  const SellScreen({super.key});

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {

  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  String? profilePic;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  List<File> _images = [];

  List<CategoryModel> categories = [];
  String? selectedCategory;
  String? selectedSubcategory;
  bool isDropdownOpen = false;
  String? expandedCategory;

  @override
  void initState() {
    super.initState();
    fetchCategories();
    _uploadAndSave();
  }

  Future<void> fetchCategories() async {
    categories = [];

    QuerySnapshot catSnapshot =
    await FirebaseFirestore.instance.collection('Category').get();

    for (var catDoc in catSnapshot.docs) {
      String catName = catDoc.data().toString().contains('cname')
          ? catDoc['cname']
          : '';

      QuerySnapshot subSnapshot = await FirebaseFirestore.instance
          .collection('Category')
          .doc(catDoc.id)
          .collection('Subcategory')
          .get();

      List<String> subCats = subSnapshot.docs
          .where((subDoc) => subDoc.data().toString().contains('cname'))
          .map((subDoc) => subDoc['cname'].toString())
          .toList();

      categories.add(CategoryModel(cname: catName, Subcategory: subCats));
    }

    setState(() {});
  }


  // Upload image to Cloudinary
  Future<String> _uploadToCloudinary(File imageFile) async {
    final cloudName = 'dozudmli0'; // replace with your Cloudinary cloud name
    final uploadPreset = 'profile_pics'; // replace with your upload preset

    var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload'));

    request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));
    request.fields['upload_preset'] = uploadPreset;

    var response = await request.send();
    var resStr = await response.stream.bytesToString();
    var jsonRes = jsonDecode(resStr);

    if (jsonRes['secure_url'] == null) {
      throw Exception("Cloudinary upload failed: ${jsonRes}");
    }

    return jsonRes['secure_url'];
  }

  // Upload and Save to Database
  Future<void> _uploadAndSave() async {
      if (_images.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one book photo')),
        );
        return;
      }

      if (titleController.text.isEmpty || authorController.text.isEmpty || selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all required book details')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        // 1️⃣ Upload images to Cloudinary
        List<String> uploadedUrls = [];
        for (var img in _images) {
          final url = await _uploadToCloudinary(img);
          uploadedUrls.add(url);
        }

        // 2️⃣ Prepare book data
        final user = FirebaseAuth.instance.currentUser;
        final bookData = {
          'title': titleController.text,
          'author': authorController.text,
          'category': selectedCategory,
          'description': '', // you can add a controller for description if needed
          'images': uploadedUrls,
          'userId': user?.uid ?? '',
          'createdAt': FieldValue.serverTimestamp(),
        };

        // 3️⃣ Prepare contact info
        final contactData = {
          'location': '', // add a controller if you want
          'phone': '',    // add a controller if you want
        };

        // 4️⃣ Save to Firestore
        await FirebaseFirestore.instance.collection('Books').add({
          ...bookData,
          ...contactData,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Book listed successfully!')),
        );

        // Clear all fields
        setState(() {
          _images.clear();
          titleController.clear();
          authorController.clear();
          selectedCategory = null;
          selectedSubcategory = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving book: $e')),
        );
        print('Error: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }

  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source, imageQuality: 80);
    if (pickedFile != null) {
      File file = File(pickedFile.path);

      setState(() {
        _images.add(file);
      });

      // Detect book text from the image
      String detectedText = await detectBookText(file);

      if (detectedText.isNotEmpty) {
        // Simple parsing: First line -> title, Second line -> author
        List<String> lines = detectedText.split('\n');
        titleController.text = lines.isNotEmpty ? lines[0] : '';
        authorController.text = lines.length > 1 ? lines[1] : '';
      }
    }
  }


  Future<String> detectBookText(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

    await textRecognizer.close();

    return recognizedText.text; // Full detected text
  }

  InputDecoration _buildDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey[200],
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = MyApp.primaryGreen;
    return
      Scaffold(
        appBar: AppBar(
          shadowColor: Colors.black26,
          backgroundColor: Colors.white,
          // elevation: 1,
          title: const Text(
            "Sell Your Book",
            style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              fontSize: 20
            ),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.green),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Green Offer Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade100),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Turn Your Books Into Cash!",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Sell your used books to fellow students and earn money",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "₹200-₹2000 Average Earnings",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Add Photo Section

              const SizedBox(height: 8),
              // 📸 Add Photo Section (Full Width Grid Layout)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.camera_alt_outlined, color: Colors.black87),
                        SizedBox(width: 8),
                        Text(
                          "Book Photos (Add up to 5)",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // ✅ Image Grid Section (Full Width)
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // 3 per row
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1,
                      ),
                      itemCount: _images.length < 5 ? _images.length + 1 : _images.length,
                      itemBuilder: (context, index) {
                        if (index == _images.length && _images.length < 5) {
                          // 🟢 + Add Photo Card
                          return GestureDetector(
                            onTap: (){
                              showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                ),
                                builder: (context) => SizedBox(
                                  height: 150,
                                  child: Column(
                                    children: [
                                      ListTile(
                                        leading: const Icon(Icons.camera_alt),
                                        title: const Text('Camera'),
                                        onTap: () {
                                          Navigator.pop(context);
                                          _pickImage(ImageSource.camera);
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.photo_library),
                                        title: const Text('Gallery'),
                                        onTap: () {
                                          Navigator.pop(context);
                                          _pickImage(ImageSource.gallery);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(1.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey.shade200,
                              ),
                              child: const Center(
                                child: Text(
                                  "+ Add Photo",
                                  style: TextStyle(color: Colors.blueGrey, fontSize: 12, fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          );
                        }

                        // 🖼️ Show Selected Images
                        return Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(_images[index]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 6,
                              top: 6,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _images.removeAt(index);
                                  });
                                },
                                child: const CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.black54,
                                  child: Icon(Icons.close, color: Colors.white, size: 16),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 8),
                    const Text(
                      "Add clear photos of your book cover and condition",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              const SizedBox(height: 8),

              // Books Information

              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade300,),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    Row(
                      children: [
                        const Text(
                          "Book Details",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                            color: Colors.black87
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20,),

                    // Optional header label on top left like screenshot (Full Name label is above fields)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Book Title *',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    TextField(
                      // controller: _fullName,
                      decoration:
                      _buildDecoration('Enter book title'),
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 14),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Author *',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    TextField(
                      // controller: _email,
                      decoration:
                      _buildDecoration('Enter author name'),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 14),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Category *',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    // Category Dropdown

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Dropdown Button
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isDropdownOpen = !isDropdownOpen;
                              expandedCategory = null; // collapse all categories initially
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  selectedSubcategory ?? selectedCategory ?? "Select Category",
                                ),
                                Icon(isDropdownOpen
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down),
                              ],
                            ),
                          ),
                        ),

                        // Dropdown Items
                        AnimatedSize(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: Container(
                            child: isDropdownOpen
                                ? Container(
                              margin: EdgeInsets.only(top: 4),
                              padding: EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                              child: Column(
                                children: categories.map((cat) {
                                  bool hasSub = cat.Subcategory.isNotEmpty;
                                  bool isExpanded = expandedCategory == cat.cname;
                                  return Column(
                                    children: [
                                      // Main Category
                                      ListTile(
                                        title: Text(cat.cname,
                                            style: TextStyle(fontWeight: FontWeight.bold)),
                                        trailing: hasSub
                                            ? AnimatedRotation(
                                          turns: isExpanded ? 0.5 : 0,
                                          duration: Duration(milliseconds: 300),
                                          child: Icon(Icons.keyboard_arrow_down),
                                        )
                                            : null,
                                        onTap: () {
                                          if (hasSub) {
                                            setState(() {
                                              expandedCategory = isExpanded ? null : cat.cname;
                                              selectedCategory = cat.cname;
                                            });
                                          } else {
                                            setState(() {
                                              selectedCategory = cat.cname;
                                              selectedSubcategory = null;
                                              isDropdownOpen = false;
                                            });
                                            print("Selected Category: ${cat.cname}");
                                          }
                                        },
                                      ),

                                      // Subcategories
                                      AnimatedSize(
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                        child: Container(
                                          child: isExpanded
                                              ? Column(
                                            children: cat.Subcategory.map((sub) {
                                              return Padding(
                                                padding: const EdgeInsets.only(left: 20),
                                                child: ListTile(
                                                  title: Text(sub),
                                                  onTap: () {
                                                    setState(() {
                                                      selectedSubcategory = sub;
                                                      isDropdownOpen = false;
                                                    });
                                                    print(
                                                        "Selected: $selectedCategory -> $selectedSubcategory");
                                                  },
                                                ),
                                              );
                                            }).toList(),
                                          )
                                              : SizedBox.shrink(),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            )
                                : SizedBox.shrink(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),


                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Description *',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    TextField(
                      // controller: _phone,
                      decoration: _buildDecoration('Describe the book condition, any highlights, missing pages etc.'),
                      keyboardType: TextInputType.streetAddress,
                      minLines: 1,
                    ),

                  ],
                ),
              ),

              SizedBox(height: 20,),

              // Contact Information
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade300,),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    Row(
                      children: [
                        const Text(
                          "Contact Information",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                              color: Colors.black87
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20,),

                    // Optional header label on top left like screenshot (Full Name label is above fields)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Your Location *',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    TextField(
                      // controller: _fullName,
                      decoration:
                      _buildDecoration('e.g., Gujarat University,Sector-1,Ahmedabad'),
                      keyboardType: TextInputType.streetAddress,
                    ),
                    const SizedBox(height: 14),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Phone Number *',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    TextField(
                      // controller: _email,
                      decoration:
                      _buildDecoration('Enter phone number'),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 14),

                  ],
                ),
              ),

              SizedBox(height: 20,),

              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                decoration: BoxDecoration(
                  color: Color(0xFFedf2fb),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.blue.shade100,),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Before you list:",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                        color: Color(0xff004dc5),
                      ),
                    ),

                    const SizedBox(height: 12),
                    bulletPoint("Ensure your book photos are clear and show the actual condition"),
                    bulletPoint("Price competitively - check similar books on the platform"),
                    bulletPoint("Be honest about book condition to avoid disputes"),
                    bulletPoint("Respond promptly to buyer messages"),

                    SizedBox(height: 20,),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _uploadAndSave,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('List Book for Sale'),
                      )

                    ),
                  ],
                ),
              ),

              SizedBox(height: 80,)
            ],
          ),
        ),
      );
  }
}

// Custom bullet point widget
Widget bulletPoint(String text) {
  return
    Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "• ",
          style: TextStyle(fontSize: 14, color: Colors.blue),
        ),
        Expanded(
          child: Text(
            text,
            textAlign: TextAlign.justify,
            style: const TextStyle(fontSize: 14, color: Colors.blue),
          ),
        ),
      ],
    ),
  );
}