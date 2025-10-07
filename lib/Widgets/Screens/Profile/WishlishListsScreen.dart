import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class WishlishListScreen extends StatefulWidget {
  const WishlishListScreen({super.key});

  @override
  State<WishlishListScreen> createState() => _WishlishListScreenState();
}

class _WishlishListScreenState extends State<WishlishListScreen> {
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
              Container(
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
                            child: Image.network(
                              "https://images.unsplash.com/photo-1553729784-e91953dec042",
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
                              "The Midnight Library",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "by Matt Haig",
                              textAlign: TextAlign.start,

                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Chip(
                              label: Text("Academic"),
                              backgroundColor: Colors.white,
                              labelStyle: TextStyle(fontSize: 10),
                              padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                            ),
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
                                  "Ahmedabad",
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
              ),
              SizedBox(height: 10,),

              Container(
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
                            child: Image.network(
                              "https://images.unsplash.com/photo-1553729784-e91953dec042",
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
                              "The Midnight Library",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "by Matt Haig",
                              textAlign: TextAlign.start,

                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Chip(
                              label: Text("Academic"),
                              backgroundColor: Colors.white,
                              labelStyle: TextStyle(fontSize: 10),
                              padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                            ),
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
                                    "Ahmedabad",
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
              ),
              SizedBox(height: 10,),

              Container(
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
                            child: Image.network(
                              "https://images.unsplash.com/photo-1553729784-e91953dec042",
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
                              "The Midnight Library",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "by Matt Haig",
                              textAlign: TextAlign.start,

                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Chip(
                              label: Text("Academic"),
                              backgroundColor: Colors.white,
                              labelStyle: TextStyle(fontSize: 10),
                              padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                            ),
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
                                    "Ahmedabad",
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
              ),
              SizedBox(height: 10,),

              Container(
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
                            child: Image.network(
                              "https://images.unsplash.com/photo-1553729784-e91953dec042",
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
                              "The Midnight Library",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "by Matt Haig",
                              textAlign: TextAlign.start,

                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Chip(
                              label: Text("Academic"),
                              backgroundColor: Colors.white,
                              labelStyle: TextStyle(fontSize: 10),
                              padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                            ),
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
                                    "Ahmedabad",
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
              ),

            ],
          ),
        ),
      ),

    );
  }
}
