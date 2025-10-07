import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khojpustak/Widgets/Screens/Widgets/ListingCardLayout.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ListingBookScreen extends StatefulWidget {
  const ListingBookScreen({super.key});

  @override
  State<ListingBookScreen> createState() => _ListingBookScreenState();
}

class _ListingBookScreenState extends State<ListingBookScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.2,
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        title: Text(
          "My Listings",
          style: TextStyle(
            color: Colors.green,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.green,size: 20),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround, // even spacing
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "5",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Active",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "2",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Sold",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.red.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            "2",
                            style: TextStyle(
                              fontSize: 18,
                              color: CupertinoColors.activeBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Inactive",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            CustomContainer(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 18,
                              offset: Offset(0, 8),
                            )
                          ]
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          "https://images.unsplash.com/photo-1553729784-e91953dec042",
                          height: 130,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "The Midnight Library",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        SizedBox(height: 2,),
                        Text(
                          "By Matt Haig",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        SizedBox(height: 2,),
                        Row(
                          children: [
                            const Text("₹399",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16,color: Colors.green)),
                            const SizedBox(width: 6),
                            const Text(
                              "₹599",
                              style: TextStyle(
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough),
                            ),
                            SizedBox(width: 16,),
                          ],
                        ),

                        SizedBox(height: 2,),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 13,vertical: 6.5),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'Active',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade900,
                                ),
                              ),
                            ),
                            SizedBox(width: 10,),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.grey.shade400, // light grey border
                                  width: 1.2,
                                ),
                              ),
                              child: const Text(
                                'Like New',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 6,),
                        Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: Colors.black54,
                                size: 18,
                              ),
                              SizedBox(width: 3,),
                              Text(
                                "Ahmedabad",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(width: 16,),
                              Icon(
                                Icons.favorite,
                                color: Colors.red,
                                size: 18  ,
                              ),
                              SizedBox(width: 3,),
                              Text(
                                "20",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ]
                        ),

                      ],
                    ),
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
}
