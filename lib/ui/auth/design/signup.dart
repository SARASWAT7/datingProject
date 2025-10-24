import 'package:demoproject/component/reuseable_widgets/appBar.dart';
import 'package:demoproject/component/reuseable_widgets/apptext.dart';
import 'package:demoproject/ui/auth/design/resetpassword.dart';
import 'package:flutter/material.dart';

import '../../../component/reuseable_widgets/custom_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 25,
            right: 25,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 45),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Image.asset('Assets/images/backarrow.png',
                      width: 30, height: 30)),
              SizedBox(height: 25),
              AppText(
                size: 20,
                text: 'Sign up',
                color: Color(0xff1B1B1B),
                fontWeight: FontWeight.w700,
              ),
              SizedBox(height: 7),
              AppText(
                size: 18,
                text: 'Please entre your details.',
                color: Color(0xff555555),
                fontWeight: FontWeight.w400,
              ),
              SizedBox(height: 30),
              TextField(
                // controller: firstNameController,
                decoration: InputDecoration(
                    labelText: 'First Name',
                    filled: true,
                    fillColor: Colors.transparent,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: Color(0XFFBABABA),
                        width: 1.0, // Set border width here
                      ),
                    )),
                readOnly: true,
                onTap: () {
                  print('2');
                },
              ),
              SizedBox(height: 30),
              TextField(
                // controller: firstNameController,
                decoration: InputDecoration(
                    labelText: 'Last Name',
                    filled: true,
                    fillColor: Colors.transparent,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: Color(0XFFBABABA),
                        width: 1.0, // Set border width here
                      ),
                    )),
                readOnly: false,
                onTap: () {
                  print('2');
                },
              ),
              SizedBox(height: 30),
              TextField(
                // controller: firstNameController,
                decoration: InputDecoration(
                    labelText: 'Enter Email',
                    filled: true,
                    fillColor: Colors.transparent,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: Color(0XFFBABABA),
                        width: 1.0, // Set border width here
                      ),
                    )),
                readOnly: true,
                onTap: () {
                  print('2');
                },
              ),
              SizedBox(height: 30),
              TextField(
                // controller: firstNameController,
                decoration: InputDecoration(
                    labelText: 'Enter Password',
                    filled: true,
                    fillColor: Colors.transparent,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: Color(0XFFBABABA),
                        width: 1.0, // Set border width here
                      ),
                    )),
                readOnly: true,
                onTap: () {
                  print('2');
                },
              ),
              SizedBox(height: 30),
              TextField(
                // controller: firstNameController,
                decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    filled: true,
                    fillColor: Colors.transparent,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: Color(0XFFBABABA),
                        width: 1.0, // Set border width here
                      ),
                    )),
                readOnly: true,
                onTap: () {
                  print('2');
                },
              ),
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
                      child: AppText(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        size: 12,
                        text: 'Accept the all term&condition',
                      )),
                ],
              ),
              SizedBox(height: 20),
              Center(child: CustomButton(text: 'Continue')),
              SizedBox(height: 20),
              Center(
                  child: AppText(
                size: 16,
                text: 'OR',
                color: Color(0xff000000),
                fontWeight: FontWeight.w700,
              )),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/fbgroup.png', width: 40, height: 40),
                  const SizedBox(width: 10),
                  Image.asset('assets/images/googlegroup.png', width: 40, height: 40),
                  const SizedBox(width: 10),
                  Image.asset('assets/images/instagroup.png', width: 40, height: 40),
                ],
              ),
              SizedBox(height: 25),
              Center(
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const Resetpassword()),
                        );
                      },
                      child: AppText(
                        size: 16,
                        text: 'Sign in with another account',
                        color: const Color(0xff6A6A6A),
                        fontWeight: FontWeight.w600,
                      )))
            ],
          ),
        ),
      ),
    );
  }
}
