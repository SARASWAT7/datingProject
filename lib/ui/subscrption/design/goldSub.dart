import 'dart:async';
import 'package:demoproject/ui/subscrption/design/silverSub.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:demoproject/component/apihelper/toster.dart';
import 'package:demoproject/component/utils/custom_button.dart';
import 'package:demoproject/component/reuseable_widgets/customNavigator.dart';
import 'package:demoproject/component/reuseable_widgets/apploder.dart';

import '../subscription/cubit.dart';

class PremimumSubscription extends StatefulWidget {
  @override
  _PremimumSubscriptionState createState() => _PremimumSubscriptionState();
}

class _PremimumSubscriptionState extends State<PremimumSubscription> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  int _selectedPlanIndex = 0;
  List<String> _subscriptionIds = [
    '1m_gold',
    '3m_gold',
    '6m_gold',
  ];

  bool _isAvailable = false;
  bool _loading = true;
  bool _isProcessingPurchase = false;
  String? _queryProductError;

  StreamSubscription<List<PurchaseDetails>>? _subscription;

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
    final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(
      _subscriptionIds.toSet(),
    );

    if (response.error != null) {
      setState(() {
        _queryProductError = response.error!.message;
      });
    }
  }

  void _listenToPurchaseUpdates() {
    _subscription = _inAppPurchase.purchaseStream.listen(
          (List<PurchaseDetails> purchaseDetailsList) {
        for (var purchase in purchaseDetailsList) {
          if (purchase.status == PurchaseStatus.purchased) {
            showToast(context, 'Purchase successful: ${purchase.productID}');
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

  Future<ProductDetails?> _getProductDetails(String productId) async {
    final ProductDetailsResponse response =
    await _inAppPurchase.queryProductDetails({productId});
    if (response.notFoundIDs.isNotEmpty) {
      showToast(context, 'Product not found: $productId');
      return null;
    }
    if (response.error != null) {
      showToast(context, 'Error querying product details: ${response.error?.message}');
      return null;
    }
    return response.productDetails.first;
  }

  Future<void> _startPurchase(BuildContext context) async {
    if (!_isAvailable) {
      showToast(context, 'In-App Purchases are not available');
      return;
    }

    setState(() {
      _isProcessingPurchase = true;
    });

    final String selectedProductId = _subscriptionIds[_selectedPlanIndex];
    final ProductDetails? productDetails = await _getProductDetails(selectedProductId);

    setState(() {
      _isProcessingPurchase = false;
    });

    if (productDetails == null) return;

    final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);

    try {
      final success = await _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
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
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Gold Plan'),
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
            _buildSubscriptionOption('1 Month Subscription', 10.99, 0, screenWidth),
            _buildSubscriptionOption('3 Month Subscription', 30.99, 1, screenWidth),
            _buildSubscriptionOption('6 Month Subscription', 62.00, 2, screenWidth),
            SizedBox(height: screenHeight * 0.01),
            Center(
              child: Text(
                'Take Your Love Life to the Next Level! Upgrade now to chat without limits and see who likes you instantly',
                style: TextStyle(fontSize: screenWidth * 0.035, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: screenHeight * 0.2),
            if (_isProcessingPurchase)
              AppLoader(),
            if (!_isProcessingPurchase)
              Center(
                child: GestureDetector(
                  onTap: () {
                    _startPurchase(context);
                  },
                  child: CustomButton(
                    text: "Buy Plan",
                  ),
                ),
              ),
            SizedBox(height: screenHeight * 0.02),
            Center(
              child: GestureDetector(
                onTap: () {
                  CustomNavigator.push(context: context, screen: SubscriptionPage());
                },
                child: Text(
                  'Silver Plan',
                  style: TextStyle(fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionOption(String title, double price, int index, double screenWidth) {
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
          '\$$price',
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
