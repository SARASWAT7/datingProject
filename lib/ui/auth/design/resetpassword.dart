import 'package:demoproject/component/reuseable_widgets/appBar.dart';
import 'package:demoproject/component/reuseable_widgets/apptext.dart';
import 'package:flutter/material.dart';

import '../../../component/reuseable_widgets/custom_button.dart';

import 'forgotpassword.dart';

class Resetpassword extends StatefulWidget {
  const Resetpassword({Key? key}) : super(key: key);

  @override
  State<Resetpassword> createState() => _ResetpasswordState();
}

class _ResetpasswordState extends State<Resetpassword> {
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
      body: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25, top: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 45),
            GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(false);
                },
                child: Image.asset('assets/images/backarrow.png',
                    width: 30, height: 30)),
            SizedBox(height: 25),
            AppText(
              size: 20,
              text: 'Reset password',
              color: Color(0xff1B1B1B),
              fontWeight: FontWeight.w700,
            ),
            SizedBox(height: 7),
            AppText(
              size: 18,
              text: 'Enter your new password',
              color: Color(0xff555555),
              fontWeight: FontWeight.w400,
            ),
            SizedBox(height: 30),
            TextField(
              // controller: firstNameController,
              decoration: InputDecoration(
                  labelText: 'Password',
                  filled: true,
                  fillColor: Colors.transparent,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      color: Colors.redAccent,
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
                  labelText: 'Confirm password',
                  filled: true,
                  fillColor: Colors.transparent,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      color: Colors.redAccent,
                      width: 1.0, // Set border width here
                    ),
                  )),
              readOnly: true,
              onTap: () {
                print('2');
              },
            ),
            SizedBox(height: 60),
            Center(
                child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ForgotPasswordScreen()),
                      );
                    },
                    child: CustomButton(text: 'Continue'))),
          ],
        ),
      ),
    );
  }
}
