import 'package:flutter/material.dart';

import 'custom_text.dart';

class Checkbox extends StatefulWidget {
  const Checkbox({Key? key, required bool value, required Null Function(dynamic value) onChanged}) : super(key: key);

  @override
  State<Checkbox> createState() => _CkeckboxState();
}

class _CkeckboxState extends State<Checkbox> {
  bool firstValue = false;
  bool secondValue = false;
  bool thirdValue = false;
  bool fourValue = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         Row(
           children: [
             Checkbox(value: firstValue, onChanged: (value){
               setState(() {
                 firstValue = value!;
               });
             }),
             CustomText(size: 16, text: 'Extremely Important', color: Colors.black, weight: FontWeight.w600,fontFamily: 'NunitoSans',)
           ],
         ),
         SizedBox(height: 10,),
         Row(
           children: [
             Checkbox(value: secondValue, onChanged: (value){
               setState(() {
                 secondValue = value!;
               });
             }),
             CustomText(size: 16, text: 'Somewhat Important', color: Colors.black, weight: FontWeight.w600,fontFamily: 'NunitoSans',)
           ],
         ),
         SizedBox(height: 10,),
         Row(
           children: [
             Checkbox(value: thirdValue, onChanged: (value){
               setState(() {
                 thirdValue = value!;
               });
             }),
             CustomText(size: 16, text: 'Not Very Important', color: Colors.black, weight: FontWeight.w600,fontFamily: 'NunitoSans',)
           ],
         ),
         SizedBox(height: 10,),
         Row(
           children: [
             Checkbox(value: fourValue, onChanged: (value){
               setState(() {
                 fourValue = value!;
               });
             }),
             CustomText(size: 16, text: 'Not Very Important', color: Colors.black, weight: FontWeight.w600,fontFamily: 'NunitoSans',)
           ],
         ),
         SizedBox(height: 10,),
         Row(
           children: [
             Checkbox(value: firstValue, onChanged: (value){
               setState(() {
                 firstValue = value!;
               });
             }),
             CustomText(size: 16, text: 'Not Important At all', color: Colors.black, weight: FontWeight.w600,fontFamily: 'NunitoSans',)
           ],
         ),
       ],
      ),
    );
  }
}

