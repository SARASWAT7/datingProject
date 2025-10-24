import 'package:flutter/material.dart';
import 'package:demoproject/component/reuseable_widgets/customNavigator.dart';
import 'package:demoproject/component/utils/custom_text.dart';
import 'package:demoproject/component/reuseable_widgets/appBar.dart';
import 'package:demoproject/component/reuseable_widgets/apptext.dart';
import 'package:demoproject/component/reuseable_widgets/custom_button.dart';
import 'emailLogin.dart';
import 'mynumber.dart';
import 'workemail.dart'; // Import Work Email page

class TermsScreen extends StatefulWidget {
  final String loginType; // Accept loginType from the previous page

  const TermsScreen({Key? key, required this.loginType}) : super(key: key);

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidgetTwo(
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
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
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 10),
              _buildTermsCard(),
              const SizedBox(height: 10),
              _buildCheckbox(),
              const SizedBox(height: 60),
              _buildContinueButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: Row(
        children: [
          Image.asset('assets/images/pdf.png', width: 50, height: 50),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                size: 22,
                text: 'Terms Of Services',
                color: Colors.black,
                weight: FontWeight.w700,
                fontFamily: 'Poppins',
              ),
              AppText(
                size: 12,
                text: 'Updated on 14.04.24',
                color: const Color(0xff6D6D6D),
                fontWeight: FontWeight.w300,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTermsCard() {
    return Center(
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: CustomText(
            color: Colors.black,
            size: 12,
            maxLines: 9,
            text: "Welcome to L'Empire Dating, "
                "the premier global dating app with headquarters in London, UK. "
                "Designed for singles seeking serious relationships and fun hangouts, "
                "our platform is built for everyone and cuts across all sexual orientations, "
                "offering a vibrant community of members ready to connect. "
                "Explore endless possibilities, find your perfect match, and experience love "
                "beyond boundaries with L'Empire Dating! Sign up now...",
            weight: FontWeight.w300,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox() {
    return Row(
      children: [
        Checkbox(
          side: const BorderSide(color: Colors.red),
          value: isChecked,
          activeColor: Colors.orangeAccent,
          onChanged: (value) {
            setState(() {
              isChecked = value ?? false;
            });
          },
          checkColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        GestureDetector(
          onTap: () {
            // Handle terms and conditions text tap
          },
          child: CustomText(
            color: Colors.black,
            weight: FontWeight.w600,
            size: 12,
            text: 'Accept all the terms and conditions',
            fontFamily: 'Nunito Sans',
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return Center(
      child: GestureDetector(
        onTap: isChecked
            ? () {
          _navigateBasedOnLoginType();
        }
            : null, // Only trigger navigation if the checkbox is checked
        child: CustomButton(text: 'Continue', isEnable: isChecked),
      ),
    );
  }

  void _navigateBasedOnLoginType() {
    if (widget.loginType == 'peEmail') {
      CustomNavigator.push(
        context: context,
        screen: Email(),
      );
    } else if (widget.loginType == 'pePhone') {
      CustomNavigator.push(
        context: context,
        screen: MyNumber(),
      );
    } else if (widget.loginType == 'workEmail') {
      CustomNavigator.push(
        context: context,
        screen: WorkEmail(),
      );
    }
  }
}
