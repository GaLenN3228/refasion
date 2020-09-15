// import 'package:flutter/material.dart';
// import 'package:refashioned_app/models/seller.dart';
// import 'package:refashioned_app/utils/colors.dart';

// class CartSeller extends StatelessWidget {
//   final Seller seller;

//   const CartSeller(this.seller);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 10),
//       margin: EdgeInsets.only(top: 26),
//       decoration: BoxDecoration(
//         border: Border(bottom: BorderSide(
//           color: lightGrayColor,))
//     ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           Row(
//             children: <Widget>[
//               Container(
//                 width: 20,
//                 height: 20,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   image: new DecorationImage(
//                     fit: BoxFit.cover,
//                     image: NetworkImage(seller.image != null && seller.image.isNotEmpty ? seller.image : "https://admin.refashioned.ru/media/product/2c8cb353-4feb-427d-9279-d2b75f46d786/2b22b56279182fe9bedb1f246d9b44b7.JPG"),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 6.0),
//                 child: Text(seller.name, style: Theme.of(context).textTheme.subtitle1,),
//               ),
//             ],
//           ),
//           Text("Продавец", style: Theme.of(context).textTheme.bodyText2)
//         ],
//       ),
//     );
//   }
// }
