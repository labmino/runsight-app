// // lib/widgets/custom_bottom_nav_bar.dart

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:get/get.dart';
// import 'package:jaket_mobile/auth_controller.dart';
// import 'package:jaket_mobile/presentation/authentication/login.dart';
// import 'package:provider/provider.dart'; // Add Provider package
// import 'package:jaket_mobile/presentation/article/article.dart';
// import 'package:jaket_mobile/presentation/detail/all_product.dart'; // Import ProductPage
// import 'package:jaket_mobile/presentation/homepage/homepage.dart';
// import 'package:jaket_mobile/presentation/service_page/service_page.dart';
// import 'package:jaket_mobile/presentation/wishlist/wishlist.dart';

// class CustomBottomNavBar extends StatelessWidget {
//   const CustomBottomNavBar({
//     Key? key,
//   }) : super(key: key);

//   void _navigateTo(int index, BuildContext context, AuthController authController) {
//     switch (index) {
//       case 0:
//         Get.to(() => const HomePage());
//         break;
//       case 1:
//         Get.to(() => const ServiceCenterPage());
//         break;
//       case 3:
//         Get.to(() => const ArticleListPage());
//         break;
//       case 4:
//         if (authController.isLoggedIn) {
//           Get.to(() => const WishlistPage());
//         } else {
//           Get.to(() => const LoginPage()); 
//         }
//         break;
//       default:
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Access AuthController using Provider
//     final authController = Provider.of<AuthController>(context);
//     final String currentRoute = Get.currentRoute;
//     int selectedIndex;

//     if (currentRoute.contains('home')) {
//       selectedIndex = 0;
//     } else if (currentRoute.contains('service_center')) {
//       selectedIndex = 1;
//     } else if (currentRoute.contains('article')) {
//       selectedIndex = 3;
//     } else if (currentRoute.contains('wishlist')) {
//       selectedIndex = 4;
//     } else {
//       selectedIndex = 0; // Default to Home if route is unrecognized
//     }

//     return SizedBox(
//       height: 100,
//       child: Stack(
//         alignment: Alignment.center,
//         clipBehavior: Clip.none,
//         children: [
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: BottomNavigationBar(
//               type: BottomNavigationBarType.fixed,
//               backgroundColor: Colors.white,
//               selectedItemColor: Colors.black,
//               unselectedItemColor: Colors.grey,
//               selectedLabelStyle: GoogleFonts.inter(
//                 fontSize: 9,
//                 fontWeight: FontWeight.bold,
//               ),
//               unselectedLabelStyle: GoogleFonts.inter(
//                 fontSize: 9,
//                 fontWeight: FontWeight.normal,
//               ),
//               currentIndex: selectedIndex,
//               onTap: (index) {
//                 if (index != 2) { // Index 2 is the central Product button
//                   _navigateTo(index, context, authController);
//                 }
//               },
//               items: [
//                 BottomNavigationBarItem(
//                   icon: Icon(
//                     Icons.home_outlined,
//                     color: selectedIndex == 0 ? Colors.black : Colors.grey,
//                   ),
//                   label: 'Home',
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(
//                     Icons.miscellaneous_services_outlined,
//                     color: selectedIndex == 1 ? Colors.black : Colors.black,
//                   ),
//                   label: 'Service Center',
//                 ),
//                 BottomNavigationBarItem(
//                   icon: SizedBox.shrink(),
//                   label: '',
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(
//                     Icons.article_outlined,
//                     color: selectedIndex == 3 ? Colors.black : Colors.black,
//                   ),
//                   label: 'Article',
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(
//                     selectedIndex == 4 ? Icons.favorite : Icons.favorite_border,
//                     color: selectedIndex == 4 ? Colors.red : Colors.black,
//                   ),
//                   label: 'Wishlist',
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//             bottom: 10,
//             child: GestureDetector(
//               onTap: () {
//                 Get.offAll(() => const ProductPage());
//               },
//               child: Column(
//                 children: [
//                   Container(
//                     width: 70,
//                     height: 70,
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF6D0CC9),
//                       shape: BoxShape.circle,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.2),
//                           spreadRadius: 3,
//                           blurRadius: 5,
//                           offset: const Offset(0, 3),
//                         ),
//                       ],
//                     ),
//                     child: const Icon(
//                       Icons.smartphone_outlined,
//                       size: 30,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     'Product',
//                     style: GoogleFonts.inter(
//                       color: const Color(0xFF6D0CC9),
//                       fontWeight: FontWeight.bold,
//                       fontSize: 9,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
