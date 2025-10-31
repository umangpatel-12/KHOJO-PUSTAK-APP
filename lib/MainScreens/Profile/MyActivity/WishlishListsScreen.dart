import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class WishlishListScreen extends StatefulWidget {
  const WishlishListScreen({super.key});

  @override
  State<WishlishListScreen> createState() => _WishlishListScreenState();
}

class _WishlishListScreenState extends State<WishlishListScreen> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.2,
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        title: Text(
          "My Wishlist",
          style: TextStyle(
            color: Colors.green,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.green,size: 20),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Favourite')
                    .where('userId', isEqualTo: user!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text("No favourites yet 😢"),
                    );
                  }
                  final whishlist = snapshot.data!.docs;
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: whishlist.length,
                      itemBuilder: (BuildContext context, int index) {
                        final favourite = whishlist[index].data() as Map<String, dynamic>;

                        return Container(
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 18,
                                offset: Offset(0, 8),
                              )
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                      child: favourite['images'] != null && favourite['images'].toString().isNotEmpty
                                          ? Image.network(
                                        (favourite['images'] as List<dynamic>)[0].toString(),
                                        height: 130,
                                        width: 100,
                                        fit: BoxFit.cover,
                                      )
                                          : Image.asset(
                                        "assets/images/user_pic.png", // koi default image
                                        height: 130,
                                        width: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),

                                  SizedBox(width: 16,),

                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        favourite['title'],
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        "by ${favourite['author']}",
                                        textAlign: TextAlign.start,

                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Chip(
                                        label: Text(favourite['category']),
                                        backgroundColor: Colors.white,
                                        labelStyle: TextStyle(fontSize: 10),
                                        padding: EdgeInsets.zero,
                                        visualDensity: VisualDensity.compact,
                                      ),
                                      Row(
                                        children: [
                                          Text("₹ ${favourite['price'] ?? ''}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold, fontSize: 16,color: Colors.green)),
                                          const SizedBox(width: 6),
                                          Text(
                                            "₹ ${favourite['oldprice'] ?? ''}",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                decoration: TextDecoration.lineThrough),
                                          ),
                                        ],
                                      ),
                                      Row(
                                          children: [
                                            Icon(
                                              Icons.location_on_outlined,
                                              color: Colors.black54,
                                              size: 18,
                                            ),
                                            SizedBox(width: 3,),
                                            Text(
                                              favourite['location'],
                                              style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ]
                                      ),

                                      // OutlinedButton.icon(
                                      //     onPressed: () {},
                                      //     label: Text(
                                      //         "Remove",
                                      //       style: TextStyle(
                                      //         color: Colors.red,
                                      //         fontSize: 14,
                                      //         fontWeight: FontWeight.w600,
                                      //       ),
                                      //     ),
                                      //   icon: Icon(
                                      //       Icons.highlight_remove_sharp,
                                      //     color: Colors.red,
                                      //   ),
                                      //   style: OutlinedButton.styleFrom(
                                      //     side: BorderSide(
                                      //         color: Colors.red.shade200, width: 1.2),
                                      //     padding: const EdgeInsets.all(14),
                                      //     shape: RoundedRectangleBorder(
                                      //       borderRadius: BorderRadius.circular(10),
                                      //     ),
                                      //   ),
                                      // ),

                                    ],
                                  ),

                                ],
                              ),

                              SizedBox(height: 10,),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  OutlinedButton.icon(
                                    onPressed: () {},
                                    style: OutlinedButton.styleFrom(
                                      iconColor: Colors.green,
                                      side: BorderSide(
                                          color: Colors.green.shade200, width: 1.2),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    icon: Icon(
                                      FeatherIcons.messageCircle,
                                    ),
                                    label: Text(
                                      'Contact Seller',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.green),
                                    ),
                                  ),

                                  OutlinedButton.icon(
                                    onPressed: () {},
                                    style: OutlinedButton.styleFrom(
                                      iconColor: Colors.red,
                                      side: BorderSide(
                                          color: Colors.red.shade200, width: 1.2),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    icon: Icon(
                                      Icons.delete_forever_outlined,
                                    ),
                                    label: Text(
                                      'Remove',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.red),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      }
                  );
                }
              )
            ],
          ),
        ),
      ),

    );
  }
}
