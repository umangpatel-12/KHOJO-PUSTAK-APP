// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_feather_icons/flutter_feather_icons.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:phosphor_flutter/phosphor_flutter.dart';
//
//
// class Custombottomnav extends StatelessWidget {
//   const Custombottomnav({
//     super.key,
//   });
//
//   Widget buildNavItem(IconData icon, String label, int index) {
//
//
//     return GestureDetector(
//       onTap: () => onItemTapped(index),
//       child: AnimatedOpacity(
//         duration: const Duration(milliseconds: 300),
//         opacity: isSelected ? 1.0 : 0.6, // fade effect
//         child: AnimatedScale(
//           duration: const Duration(milliseconds: 300),
//           scale: isSelected ? 1.2 : 1.0, // zoom effect
//           curve: Curves.easeInOut,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(
//                 icon,
//                 size: 25,
//                 color: isSelected ? Colors.green : Colors.black,
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: 11,
//                   fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
//                   color: isSelected ? Colors.green : Colors.black,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: Container(
//         margin: EdgeInsets.all(16),
//         padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(24),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 20,
//               offset: Offset(0, 8),
//             ),
//           ],
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             buildNavItem(PhosphorIcons.house(), "Home", 0),
//             buildNavItem(PhosphorIcons.book(), "Book", 2),
//             buildNavItem(PhosphorIcons.plus(), "Add", 1),
//             buildNavItem(PhosphorIcons.messengerLogo(), "Chat", 3),
//             buildNavItem(PhosphorIcons.user(), "Profile", 4),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart' show PhosphorIcons;

import '../Screens/CartScreen.dart';
import '../Screens/HomeScreen.dart';
import '../Screens/MyBooksScreen.dart';
import '../Screens/ProfileScreen.dart';
import '../Screens/SellScreen.dart';

class Custombottomnav extends StatefulWidget {
  const Custombottomnav({super.key});

  @override
  State<Custombottomnav> createState() => _CustombottomnavState();
}

class _CustombottomnavState extends State<Custombottomnav> {

  int _currentIndex = 0;


  final List<Widget> _Pages = [
    HomeScreen(),
    MyBooksScreen(),
    SellScreen(),
    CartScreen(),
    Profilescreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // Widget buildNavItem(IconData icon, String label, int index) {
  //   bool isSelected = _currentIndex == index;
  //
  //   return GestureDetector(
  //     onTap: () => _onItemTapped(index),
  //     child: AnimatedOpacity(
  //       duration: const Duration(milliseconds: 300),
  //       opacity: isSelected ? 1.0 : 0.6, // fade effect
  //       child: AnimatedScale(
  //         duration: const Duration(milliseconds: 300),
  //         scale: isSelected ? 1.2 : 1.0, // zoom effect
  //         curve: Curves.easeInOut,
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Icon(
  //               icon,
  //               size: 25,
  //               color: isSelected ? Colors.green : Colors.black,
  //             ),
  //             const SizedBox(height: 4),
  //             Text(
  //               label,
  //               style: TextStyle(
  //                 fontSize: 11,
  //                 fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
  //                 color: isSelected ? Colors.green : Colors.black,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _Pages[_currentIndex],
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius:  20,
              offset: Offset(0, 8),
            )
          ]
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BottomNavigationBar(
              currentIndex: _currentIndex,

              backgroundColor: Colors.white,
              selectedItemColor: Colors.green,
              unselectedItemColor: Colors.black,
              showUnselectedLabels: false,
              showSelectedLabels: true,
              type: BottomNavigationBarType.fixed,

              onTap: _onItemTapped,

              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
                BottomNavigationBarItem(icon: Icon(CupertinoIcons.book), label: "My Books"),
                BottomNavigationBarItem(icon: Icon(CupertinoIcons.plus), label: "Add"),
                BottomNavigationBarItem(icon: Icon(Iconsax.device_message), label: "Chat"),
                BottomNavigationBarItem(icon: Icon(CupertinoIcons.person), label: "Profile"),
              ]
          ),
        ),
      ),

    );
  }
}
