import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:khojpustak/Widgets/CardLayouts/ListingCardLayout.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../Widgets/CardLayouts/Term&ConditionLayout.dart';

class ConditionsScreen extends StatefulWidget {
  const ConditionsScreen({super.key});

  @override
  State<ConditionsScreen> createState() => _ConditionsScreenState();
}

class _ConditionsScreenState extends State<ConditionsScreen> {

  int? _expandedIndex;
  final List<Map<String, dynamic>> TermsData = [
    {
      'icon': Icons.info_outline,
      'title': '1. Introduction',
      'content': '''
Welcome to Khoj Pustak! These Terms and Conditions govern your use of our book marketplace platform. By accessing or using Khoj Pustak, you agree to be bound by these terms. If you disagree with any part of these terms, you may not access our service.

Khoj Pustak is a platform that connects book buyers and sellers through listings. We provide a space for users to list their books and contact each other directly via phone. We do not process payments or facilitate the actual exchange of books.
'''
    },
    {
      'icon': Icons.person_outline,
      'title': '2. User Account',
      'content': '''
When you create an account with us, you must provide accurate, complete, and current information at all times. Failure to do so constitutes a breach of the Terms.

You are responsible for:
• Safeguarding your password and account credentials
• All activities that occur under your account
• Notifying us immediately of any unauthorized use

You must be at least 18 years old to use this service. By creating an account, you confirm that you meet this requirement.
'''
    },
    {
      'icon': Icons.rule,
      'title': '3. User Conduct',
      'content': '''
As a user of Khoj Pustak, you agree to:

• Provide accurate information about books you list for sale
• Not post offensive, defamatory, or illegal content
• Not engage in fraudulent activities or scams
• Respect intellectual property rights
• Communicate respectfully with other users
• Complete transactions in good faith

We reserve the right to suspend or terminate accounts that violate these terms.
'''
    },
    {
      'icon': Icons.shopping_basket_outlined,
      'title': '4. Listings and Transactions',
      'content': '''
Sellers are responsible for:
• Accurately describing the condition and details of their books
• Setting fair prices
• Responding to buyer inquiries promptly
• Delivering books as described

Buyers are responsible for:
• Reviewing book details carefully before contacting sellers
• Communicating clearly and respectfully with sellers
• Arranging payment and pickup/delivery directly with sellers
• Providing feedback honestly

Khoj Pustak is not responsible for disputes between buyers and sellers. All transactions occur directly between users.
'''
    },
    {
      'icon': Icons.payment_outlined,
      'title': '5. Payments and Fees',
      'content': '''
Khoj Pustak does not charge any fees for listing books. We do not process payments - all transactions happen directly between buyers and sellers via phone contact.

We recommend:
• Contacting sellers via the provided phone number
• Meeting in person for transactions when possible
• Verifying book condition before payment
• Using secure payment methods agreed upon directly
• Keeping records of all communications

Khoj Pustak is a listing platform only and does not handle any payments or financial transactions.
'''
    },
    {
      'icon': Icons.lock_outline,
      'title': '6. Privacy and Data',
      'content': '''
We are committed to protecting your privacy. Your personal information is collected and used in accordance with our Privacy Policy.

We collect:
• Account information (name, email, location)
• Listing details for books you sell
• Communication between users
• Usage data to improve our service

We will never sell your personal information to third parties.
'''
    },
    {
      'icon': Icons.block_outlined,
      'title': '7. Prohibited Content',
      'content': '''
The following are strictly prohibited on Khoj Pustak:

• Pirated or illegally copied books
• Stolen property
• Counterfeit or fake books
• Offensive or adult content (unless properly categorized)
• Spam or misleading information
• Content that violates copyright laws

Violation of these rules may result in immediate account termination and legal action.
'''
    },
    {
      'icon': Icons.warning_amber_outlined,
      'title': '8. Limitation of Liability',
      'content': '''
Khoj Pustak provides a platform for users to connect. We are not responsible for:

• The quality, condition, or accuracy of listed books
• Disputes between buyers and sellers
• Loss or damage during book delivery
• Financial losses from transactions
• Fraudulent activities by users

Use our service at your own risk. We recommend exercising caution in all transactions.
'''
    },
    {
      'icon': Icons.copyright_outlined,
      'title': '9. Intellectual Property',
      'content': '''
The Khoj Pustak platform, including its design, logo, and features, is protected by copyright and trademark laws. You may not:

• Copy or reproduce our platform
• Use our branding without permission
• Reverse engineer our technology

User-generated content (listings, reviews) remains the property of the respective users, but by posting, you grant us a license to use this content on our platform.
'''
    },
    {
      'icon': Icons.update,
      'title': '10. Changes to Terms',
      'content': '''
We reserve the right to modify these Terms and Conditions at any time. Changes will be effective immediately upon posting to the platform.

We will notify users of significant changes via:
• Email notifications
• In-app announcements
• Updates to this page

Continued use of Khoj Pustak after changes constitutes acceptance of the new terms.
'''
    },
    {
      'icon': Icons.cancel_outlined,
      'title': '11. Account Termination',
      'content': '''
You may terminate your account at any time by:
• Contacting our support team
• Using account deletion in app settings

We may terminate or suspend accounts for:
• Violation of these terms
• Fraudulent activities
• Abusive behavior
• Extended inactivity

Upon termination, your listings will be removed and access to the platform will be revoked.
'''
    },
    {
      'icon': Icons.contact_support_outlined,
      'title': '12. Contact Us',
      'content': '''
If you have questions about these Terms and Conditions, please contact us:

Email: legal@khojpustak.com
Phone: +91 1800 123 4567
Address: Khoj Pustak Legal Team, Mumbai, India
'''
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        elevation: 0.2,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.green, size: 22),
        title: const Text(
          "Terms & Conditions",
          style: TextStyle(
            fontSize: 18,
            color: Colors.green,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body:
      SingleChildScrollView(
        // padding: EdgeInsets.all(14.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade100),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Icon(
                        Iconsax.book_1_copy,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),

                    SizedBox(width: 15,),

                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Terms & Conditions",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),

                            SizedBox(height: 5,),

                            Text(
                              textAlign: TextAlign.justify,
                              "Please read these terms and conditions carefully before using Khoj Pustak."
                                                      "These terms outline the rules and regulations for using our book marketplace platform.",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.black45,
                              ),
                            ),
                          ]
                      ),
                    )
                  ],
                ),
              ),
            ),

            ...TermsData.map((data) => TermsContainer(
                padding: EdgeInsets.all(0.0),
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    leading: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        data['icon']!,
                        color: Colors.green.shade400,
                        size: 18,
                      ),
                    ),
                    title: Text(
                      data["title"]!,
                      maxLines: 1, // 👈 Only 1 line
                      overflow: TextOverflow.ellipsis, // 👈 Add "..." if text is too long
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    childrenPadding: EdgeInsets.only(top: 16.0,left: 66,right: 30,bottom: 0.0),
                    children: [
                      Text(
                        data['content']!,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      )
                    ],
                  ),
                )
            ),),

            SizedBox(height: 10,),

            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Container(
                padding: EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white54,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey[300]!),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    )
                  ]
                ),
                child: Text(
                    "By using Khoj Pustak, you acknowledge that you have read, understood, and agree to be bound by these Terms and Conditions.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ),
            ),

            SizedBox(height: 10,)

          ],
        ),
      ),
    );
  }
}
