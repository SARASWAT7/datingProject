// import 'dart:async';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:flutter/foundation.dart';
// import 'package:sizer/sizer.dart';
//
// import '../../../component/apihelper/toster.dart';
// import '../../../component/reuseable_widgets/customNavigator.dart';
// import '../../../component/reuseable_widgets/custom_button.dart';
// import 'goldSub.dart';
//
// class SubscriptionPage extends StatefulWidget {
//   @override
//   _SubscriptionPageState createState() => _SubscriptionPageState();
// }
//
// class _SubscriptionPageState extends State<SubscriptionPage> {
//   final InAppPurchase _inAppPurchase = InAppPurchase.instance;
//   int _selectedPlanIndex = 0;
//   List<String> _subscriptionIds = [
//     '1m_sub',
//     '6m_sub',
//     '1yr_sub',
//   ];
//
//   bool _isAvailable = false;
//   bool _loading = true;
//   String? _queryProductError;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeInAppPurchase();
//     _listenToPurchaseUpdates();
//   }
//
//   // Initialize In-App Purchase
//   Future<void> _initializeInAppPurchase() async {
//     final bool isAvailable = await _inAppPurchase.isAvailable();
//     setState(() {
//       _isAvailable = isAvailable;
//       _loading = false;
//     });
//
//     if (_isAvailable) {
//       await _loadProductDetails();
//     }
//   }
//
//   // Load product details
//   Future<void> _loadProductDetails() async {
//     final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(
//       _subscriptionIds.toSet(),
//     );
//
//     if (response.error != null) {
//       setState(() {
//         _queryProductError = response.error!.message;
//       });
//     }
//   }
//
//   void _listenToPurchaseUpdates() {
//     _inAppPurchase.purchaseStream.listen((List<PurchaseDetails> purchaseDetailsList) {
//       for (var purchase in purchaseDetailsList) {
//         if (purchase.status == PurchaseStatus.purchased) {
//           showToast(context, 'Purchase successful: ${purchase.productID}');
//           // Unlock features for the user
//         } else if (purchase.status == PurchaseStatus.error) {
//           showToast(context, 'Purchase failed: ${purchase.error?.message}');
//         } else if (purchase.status == PurchaseStatus.restored) {
//           showToast(context, 'Purchase restored: ${purchase.productID}');
//         }
//       }
//     }, onError: (error) {
//       showToast(context, 'Purchase Stream Error: $error');
//     });
//   }
//
//   void _startPurchase(BuildContext context) async {
//     String productId = _subscriptionIds[_selectedPlanIndex];
//
//     if (_isAvailable) {
//       try {
//         // if (kDebugMode) {
//         //   // Debug mode simulation
//         //   showToast(context, 'Debug: Simulating purchase for $productId');
//         //   return;
//         // }
//
//         final ProductDetailsResponse response =
//         await _inAppPurchase.queryProductDetails({productId}.toSet());
//
//         if (response.error != null) {
//           showToast(context, 'Error: ${response.error!.message}');
//           return;
//         }
//
//         if (response.productDetails.isEmpty) {
//           showToast(context, 'Product not found');
//           return;
//         }
//
//         final ProductDetails product = response.productDetails.first;
//         final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
//
//         _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
//       } catch (e) {
//         showToast(context, 'Error starting purchase: $e');
//       }
//     } else {
//       showToast(context, 'Store is unavailable');
//     }
//   }
//
//   // Handle selection of plan
//   void _selectPlan(int index) {
//     setState(() {
//       _selectedPlanIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Text('Silver Plan'),
//         centerTitle: true,
//       ),
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(screenWidth * 0.04),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Upgrade to premium and quickly find new people in your area and chat without having to match first!',
//               style: TextStyle(fontSize: screenWidth * 0.04),
//             ),
//             SizedBox(height: screenHeight * 0.03),
//             _buildSubscriptionOption('1 Month Subscription', 6.99, 0, screenWidth),
//             _buildSubscriptionOption('6 Month Subscription', 19.99, 1, screenWidth),
//             _buildSubscriptionOption('1 Year Subscription', 30.00, 2, screenWidth),
//             SizedBox(height: screenHeight * 0.01),
//             Center(
//               child: Text(
//                 maxLines: 3,
//                 'Take Your Love Life to the Next Level! Upgrade now to chat without limits and see who likes you instantly',
//                 style: TextStyle(fontSize: screenWidth * 0.035, color: Colors.black),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             SizedBox(height: screenHeight * 0.2),
//             Center(
//               child: GestureDetector(
//                 onTap: () {
//                   _startPurchase(context); // Correctly pass the context to _startPurchase
//                 },
//                 child: CustomButton(
//                   text: "Buy Plan",
//                 ),
//               ),
//             ),
//             SizedBox(height: screenHeight * 0.02),
//             Center(
//               child: GestureDetector(
//                 onTap: () {
//                   CustomNavigator.push(context: context, screen: PremimumSubscription());
//                 },
//                 child: Text(
//                   'Gold Plan',
//                   style: TextStyle(fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//             SizedBox(height: screenHeight * 0.01),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Build subscription options
//   Widget _buildSubscriptionOption(String title, double price, int index, double screenWidth) {
//     bool isSelected = _selectedPlanIndex == index;
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
//       decoration: BoxDecoration(
//         border: Border.all(color: isSelected ? Colors.red : Colors.grey),
//         borderRadius: BorderRadius.circular(screenWidth * 0.05),
//       ),
//       child: ListTile(
//         title: Text(
//           title,
//           style: TextStyle(fontSize: screenWidth * 0.04, color: isSelected ? Colors.red : Colors.black),
//         ),
//         trailing: Text(
//           '\$ $price',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: screenWidth * 0.04,
//             color: isSelected ? Colors.red : Colors.black,
//           ),
//         ),
//         selected: isSelected,
//         onTap: () => _selectPlan(index),
//       ),
//     );
//   }
// }
//

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../../../component/apihelper/toster.dart';
import '../../../component/reuseable_widgets/customNavigator.dart';
import '../../../component/reuseable_widgets/custom_button.dart';
import '../subscription/cubit.dart';
import 'goldSub.dart';
import 'package:http/http.dart' as http;

class SubscriptionPage extends StatefulWidget {
  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  int _selectedPlanIndex = 0;
  List<String> _subscriptionIds = ['1m_sub', '3m_sub', '6m_sub'];

  bool _isAvailable = false;
  bool _loading = true;
  String? _queryProductError;

  @override
  void initState() {
    super.initState();
    _initializeInAppPurchase();
    _listenToPurchaseUpdates();
  }

  Future<void> _initializeInAppPurchase() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    setState(() {
      _isAvailable = isAvailable;
      _loading = false;
    });

    if (_isAvailable) {
      await _loadProductDetails();
    }
  }

  Future<void> _loadProductDetails() async {
    final ProductDetailsResponse response = await _inAppPurchase
        .queryProductDetails(_subscriptionIds.toSet());

    if (response.error != null) {
      setState(() {
        _queryProductError = response.error!.message;
      });
    }
  }

  void _listenToPurchaseUpdates() {
    _inAppPurchase.purchaseStream.listen(
      (List<PurchaseDetails> purchaseDetailsList) {
        for (var purchase in purchaseDetailsList) {
          if (purchase.status == PurchaseStatus.purchased) {
            // Acknowledge the purchase
            _inAppPurchase.completePurchase(purchase);
            showToast(context, 'Purchase successful: ${purchase.productID}');
            // Send purchase details to your subscription system
            context.read<SubscriptionCubit>().sendPurchaseDetails(
              transactionId: purchase.purchaseID ?? '',
              productId: purchase.productID,
            );
          } else if (purchase.status == PurchaseStatus.error) {
            showToast(context, 'Purchase failed: ${purchase.error?.message}');
          } else if (purchase.status == PurchaseStatus.restored) {
            showToast(context, 'Purchase restored: ${purchase.productID}');
            context.read<SubscriptionCubit>().sendPurchaseDetails(
              transactionId: purchase.purchaseID ?? '',
              productId: purchase.productID,
            );
          }
        }
      },
      onError: (error) {
        showToast(context, 'Purchase Stream Error: $error');
      },
    );
  }

  Future<void> _startPurchase(BuildContext context) async {
    if (!_isAvailable) {
      showToast(context, 'In-App Purchases are not available');
      return;
    }

    final String selectedProductId = _subscriptionIds[_selectedPlanIndex];
    final ProductDetailsResponse response = await _inAppPurchase
        .queryProductDetails({selectedProductId});

    if (response.notFoundIDs.isNotEmpty) {
      showToast(context, 'Product not found: $selectedProductId');
      return;
    }

    if (response.error != null) {
      showToast(
        context,
        'Error querying product details: ${response.error?.message}',
      );
      return;
    }
    final ProductDetails productDetails = response.productDetails.first;
    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: productDetails,
    );

    try {
      final success = await _inAppPurchase.buyConsumable(
        purchaseParam: purchaseParam,
      );
      if (!success) {
        showToast(context, 'Purchase initiation failed');
      }
    } catch (e) {
      showToast(context, 'Purchase error: $e');
    }
  }

  void _selectPlan(int index) {
    setState(() {
      _selectedPlanIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Silver Plan'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upgrade to premium and quickly find new people in your area and chat without having to match first!',
              style: TextStyle(fontSize: screenWidth * 0.04),
            ),
            SizedBox(height: screenHeight * 0.03),
            _buildSubscriptionOption(
              '1 Month Subscription',
              6.99,
              0,
              screenWidth,
            ),
            _buildSubscriptionOption(
              '3 Month Subscription',
              19.99,
              1,
              screenWidth,
            ),
            _buildSubscriptionOption(
              '6 Month Subscription',
              30.00,
              2,
              screenWidth,
            ),
            SizedBox(height: screenHeight * 0.01),
            Center(
              child: Text(
                maxLines: 3,
                'Take Your Love Life to the Next Level! Upgrade now to chat without limits and see who likes you instantly',
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: screenHeight * 0.2),
            Center(
              child: GestureDetector(
                onTap: () {
                  _startPurchase(context);
                },
                child: CustomButton(text: "Buy Plan"),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Center(
              child: GestureDetector(
                onTap: () {
                  CustomNavigator.push(
                    context: context,
                    screen: PremimumSubscription(),
                  );
                },
                child: Text(
                  'Gold Plan',
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
          ],
        ),
      ),
    );
  }

  // Build subscription options
  Widget _buildSubscriptionOption(
    String title,
    double price,
    int index,
    double screenWidth,
  ) {
    bool isSelected = _selectedPlanIndex == index;
    return Container(
      margin: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
      decoration: BoxDecoration(
        border: Border.all(color: isSelected ? Colors.red : Colors.grey),
        borderRadius: BorderRadius.circular(screenWidth * 0.05),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontSize: screenWidth * 0.04,
            color: isSelected ? Colors.red : Colors.black,
          ),
        ),
        trailing: Text(
          '\$ $price',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.04,
            color: isSelected ? Colors.red : Colors.black,
          ),
        ),
        selected: isSelected,
        onTap: () => _selectPlan(index),
      ),
    );
  }
}
