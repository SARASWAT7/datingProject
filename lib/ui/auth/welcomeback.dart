import 'package:demoproject/component/reuseable_widgets/container.dart';
import 'package:demoproject/component/reuseable_widgets/text_field.dart';
import 'package:demoproject/component/utils/custom_text.dart';
import 'package:demoproject/ui/auth/design/signup.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../component/reuseable_widgets/appBar.dart';
import '../../component/reuseable_widgets/apptext.dart';
import '../../component/reuseable_widgets/custom_button.dart';

class WelcomeBackScreen extends StatefulWidget {
  const WelcomeBackScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeBackScreen> createState() => _WelcomeBackScreenState();
}

class _WelcomeBackScreenState extends State<WelcomeBackScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  bool? isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidgetTwo(
        leading: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
              // Handle back button tap
            },
            child: Transform.scale(
              scale: 0.8,
              child: Image.asset(
                'assets/images/backarrow.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        title: '',
        titleColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.black,
        centerTitle: true,
        actions: [],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25, top: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                size: 20,
                text: 'Welcome Back',
                color: Color(0xff1B1B1B),
                fontWeight: FontWeight.w700,
              ),
              SpaceWidget(height: 7),
              AppText(
                size: 18,
                text: 'welcome back , please entre your details.',
                color: Color(0xff555555),
                fontWeight: FontWeight.w400,
              ),
              SpaceWidget(height: 30),
              TextFieldWidget(
                title: '',
                controller: TextEditingController(),
                textFieldBorderColor: Colors.grey,
                textInputType: TextInputType.text,
                hint: 'First Name',
                hintColor: Colors.black,
                textFieldTitleColor: Colors.black,
                prefixIcon: Transform.scale(
                  scale: 0.6,
                  child: Image.asset(
                    'assets/images/email.png',
                    height: 20,
                    width: 20,
                  ),
                ), // Icon on the left side// Icon on the right side
              ),
              TextFieldWidget(
                title: '',
                controller: TextEditingController(),
                textFieldBorderColor: Colors.grey,
                textInputType: TextInputType.text,
                hint: 'First Name',
                hintColor: Colors.black,
                textFieldTitleColor: Colors.black,
                prefixIcon: Transform.scale(
                  scale: 0.6,
                  child: Image.asset(
                    'assets/images/password.png',
                    height: 20,
                    width: 20,
                  ),
                ),
              ),
              SpaceWidget(height: 10),
              Row(
                children: [
                  Checkbox(
                    side: const BorderSide(color: Colors.red),
                    value: isChecked,
                    activeColor: Colors.orangeAccent,
                    onChanged: (value) {
                      setState(() {
                        isChecked = value;
                        print(value);
                        print("mahalaxmi");
                      });
                    },
                    checkColor: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => ()));
                      },
                      child: CustomText(
                        color: Colors.black,
                        weight: FontWeight.w600,
                        size: 12,
                        text: 'Keep me Logged In',
                        fontFamily: 'Nunito Sans',
                      )),
                ],
              ),
              SpaceWidget(height: 20),
              Center(child: CustomButton(text: 'Continue')),
              SpaceWidget(height: 20),
              Center(
                  child: CustomText(
                      size: 16,
                      text: 'OR',
                      color: Color(0xff000000),
                      weight: FontWeight.w700,
                      fontFamily: 'Nunito sans')),
              SpaceWidget(height: 20),
              AppContainer(
                height: MediaQuery.of(context).size.height * 0.060,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/facebook.png',
                      width: 24,
                      height: 24,
                    ),
                    SpaceWidget(width: 10),
                    AppText(
                        fontWeight: FontWeight.w300,
                        size: 12.sp,
                        text: 'Login With Facebook'),
                  ],
                ),
              ),
              AppContainer(
                height: MediaQuery.of(context).size.height * 0.060,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/google.png',
                      width: 24,
                      height: 24,
                    ),
                    SpaceWidget(width: 10),
                    AppText(
                        fontWeight: FontWeight.w300,
                        size: 12.sp,
                        text: 'Login With Google'),
                  ],
                ),
              ),
              AppContainer(
                height: MediaQuery.of(context).size.height * 0.060,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/instagram.png',
                      width: 24,
                      height: 24,
                    ),
                    SpaceWidget(width: 10),
                    AppText(
                        fontWeight: FontWeight.w300,
                        size: 12.sp,
                        text: 'Login With Instagram'),
                  ],
                ),
              ),
              SpaceWidget(height: 25),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignupScreen()),
                    );
                  },
                  child: Center(
                    child: CustomText(
                        text: 'Trouble logging in?',
                        size: 17,
                        color: Colors.black87,
                        weight: FontWeight.w700,
                        fontFamily: 'Nunito Sans'),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
