// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';

// class PurchaseApi {
//   static const _apiKey = 'goog_PvJhOozHVZFvchpXcRdlpquOhlQ';
//   static Future init() async {
//     await Purchases.setDebugLogsEnabled(true);
//     await Purchases.setup('goog_PvJhOozHVZFvchpXcRdlpquOhlQ');
//   }

//   static Future<List<Offering>> fetchOffers() async {
//     try {
//       final offerings = await Purchases.getOfferings();
//       final current = offerings.current;
//       return current == null ? [] : [current];
//     } on PlatformException catch (e) {
//       return [];
//     }
//   }

//   Future fetchOffers1() async {
//     final offerings = await PurchaseApi.fetchOffers();
//     if (offerings.isEmpty) {
//       print('object');
//       // ScaffoldMessenger.of(context)
//       //     .showSnackBar(SnackBar(content: Text('data')));
//     } else {
//       final offer = offerings.first;
//       print('this is offer $offer');
//     }
//   }
// }
