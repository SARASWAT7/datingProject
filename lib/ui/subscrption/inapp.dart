// import 'dart:async';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:in_app_purchase_android/in_app_purchase_android.dart';
//
// class InApp extends StatefulWidget {
//   final String productId; // Accept productId from the previous page
//
//   const InApp({Key? key, required this.productId}) : super(key: key);
//
//   @override
//   _InAppState createState() => _InAppState();
// }
//
// class _InAppState extends State<InApp> {
//   final InAppPurchase _inAppPurchase = InAppPurchase.instance;
//   late StreamSubscription<List<PurchaseDetails>> _subscription;
//   List<ProductDetails> _products = [];
//   bool _isAvailable = false;
//   bool _purchasePending = false;
//   bool _loading = true;
//   String? _queryProductError;
//
//   @override
//   void initState() {
//     final Stream<List<PurchaseDetails>> purchaseUpdated =
//         _inAppPurchase.purchaseStream;
//     _subscription = purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
//       _listenToPurchaseUpdated(purchaseDetailsList);
//     }, onDone: () {
//       _subscription.cancel();
//     });
//     initStoreInfo();
//     super.initState();
//   }
//
//   Future<void> initStoreInfo() async {
//     try {
//       final bool isAvailable = await _inAppPurchase.isAvailable();
//       if (!isAvailable) {
//         setState(() {
//           _isAvailable = false;
//           _loading = false;
//         });
//         return;
//       }
//
//       final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails({widget.productId}.toSet());
//
//       if (response.error != null) {
//         setState(() {
//           _queryProductError = response.error!.message;
//           _isAvailable = false;
//           _loading = false;
//         });
//         return;
//       }
//
//       if (response.productDetails.isEmpty) {
//         setState(() {
//           _queryProductError = "No products found for the given ID.";
//           _isAvailable = false;
//           _loading = false;
//         });
//         return;
//       }
//
//       setState(() {
//         _products = response.productDetails;
//         _isAvailable = true;
//         _loading = false;
//       });
//     } catch (error) {
//       setState(() {
//         _queryProductError = "Failed to load product details: $error";
//         _isAvailable = false;
//         _loading = false;
//       });
//     }
//   }
//
//   Future<void> _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
//     for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
//       if (purchaseDetails.status == PurchaseStatus.pending) {
//         setState(() {
//           _purchasePending = true;
//         });
//       } else if (purchaseDetails.status == PurchaseStatus.purchased ||
//           purchaseDetails.status == PurchaseStatus.restored) {
//         final bool valid = await _verifyPurchase(purchaseDetails);
//         if (valid) {
//           deliverProduct(purchaseDetails);
//         } else {
//           _handleInvalidPurchase(purchaseDetails);
//         }
//       }
//       if (Platform.isAndroid) {
//         if (purchaseDetails.productID == widget.productId) {
//           final androidAddition = _inAppPurchase.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
//           await androidAddition.consumePurchase(purchaseDetails);
//         }
//       }
//       if (purchaseDetails.pendingCompletePurchase) {
//         await _inAppPurchase.completePurchase(purchaseDetails);
//       }
//     }
//   }
//
//   Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
//     // Simulate purchase verification logic
//     return true;
//   }
//
//   void deliverProduct(PurchaseDetails purchaseDetails) {
//     setState(() {
//       _purchasePending = false;
//     });
//     // Provide the purchased product to the user (e.g., unlock feature, subscription).
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text('Purchase successful: ${purchaseDetails.productID}'),
//     ));
//   }
//
//   void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
//     setState(() {
//       _purchasePending = false;
//     });
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text('Purchase invalid for product: ${purchaseDetails.productID}'),
//     ));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('In-App Purchase'),
//       ),
//       body: _loading
//           ? AppLoader()
//           : _isAvailable
//           ? _products.isEmpty
//           ? Center(
//         child: Text(
//           'No products available for purchase.',
//           style: TextStyle(color: Colors.red),
//         ),
//       )
//           : ListView(
//         children: _products.map((product) {
//           return ListTile(
//             title: Text(product.title),
//             subtitle: Text(product.description),
//             trailing: TextButton(
//               child: Text(product.price),
//               onPressed: () {
//                 final purchaseParam = PurchaseParam(productDetails: product);
//                 _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
//               },
//             ),
//           );
//         }).toList(),
//       )
//           : Center(
//         child: Text(
//           _queryProductError ?? 'Store is unavailable or there was an error. Please try again.',
//           style: TextStyle(color: Colors.red),
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _subscription.cancel();
//     super.dispose();
//   }
// }
