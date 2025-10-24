import 'package:demoproject/component/reuseable_widgets/customNavigator.dart';
import 'package:demoproject/component/utils/custom_text.dart';
import 'package:demoproject/ui/quesition/quesition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../component/reuseable_widgets/bottomTabBar.dart';
import '../../component/reuseable_widgets/custom_button.dart';
import '../../component/reuseable_widgets/text_field.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 25,
            right: 25,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SpaceWidget(height: MediaQuery.of(context).size.height * 0.1),
              CustomText(
                  size: 20,
                  maxLines: 3,
                  text:
                      'Lempire Coretta note some questions to calculate compatiblity with your perfect match.',
                  color: Color(0xff000000),
                  weight: FontWeight.w600,
                  fontFamily: 'Nunito Sans'),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Image.asset('assets/images/message.png', width: 384, height: 302),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              GestureDetector(
                onTap: () {
                  CustomNavigator.push(
                      context: context, screen: QuesitionsPage());
                },
                child: const Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.all(25.0),
                    child: CustomButton(text: 'Get Started'),
                  ),


                ),
              ),

              GestureDetector(
                onTap: () {
                  CustomNavigator.push(
                      context: context, screen: BottomBar());
                },
                child: const Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.all(25.0),
                    child: CustomButton(text: 'Skip All Questions'),
                  ),


                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
