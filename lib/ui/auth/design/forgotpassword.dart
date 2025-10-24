import 'package:flutter/material.dart';

import '../../../component/reuseable_widgets/appText.dart';
import '../../../component/reuseable_widgets/custom_button.dart';
import '../../personalinformation/uploadimage.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25, top: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 45),
            GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(false);
                },
                child: Image.asset('assets/images/backarrow.png',
                    width: 30, height: 30)),
            const SizedBox(height: 25),
            AppText(
              size: 20,
              text: 'Forget Password',
              color: const Color(0xff1B1B1B),
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(height: 7),
            AppText(
              size: 18,
              text:
                  'Enter your registered email, we will send you 4 digits code for reset password.',
              color: const Color(0xff555555),
              fontWeight: FontWeight.w400,
            ),
            const SizedBox(height: 30),
            TextField(
              // controller: firstNameController,
              decoration: InputDecoration(
                  labelText: 'abc@gmail.com',
                  filled: true,
                  fillColor: Colors.transparent,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      color: Color(0XFFBABABA),
                      width: 1.0, // Set border width here
                    ),
                  )),
              readOnly: true,
              onTap: () {},
            ),
            const SizedBox(height: 60),
            Center(
                child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const UploadImage()),
                      );
                    },
                    child: const CustomButton(text: 'Continue'))),
          ],
        ),
      ),
    );
  }
}
