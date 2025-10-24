import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../component/reuseable_widgets/appBar.dart';
import '../../../../component/reuseable_widgets/apptext.dart';
import '../../../../component/reuseable_widgets/custom_button.dart';
import '../../../../component/reuseable_widgets/text_field.dart';
import '../cubit/profile/profilecubit.dart';
import '../cubit/profile/profilestate.dart';

class Refferal extends StatefulWidget {
  const Refferal({super.key});

  @override
  State<Refferal> createState() => _RefferalState();
}

class _RefferalState extends State<Refferal> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final referralCode = state.profileResponse?.result?.referralCode ?? "";

        return Scaffold(
          appBar: appBarWidgetThree(
            leading: Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  // Handle back button tap
                },
                child: Transform.scale(
                  scale: 0.5,
                  child: Image.asset(
                    'assets/images/backarrow.png',
                    height: 50,
                    width: 50,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            title: 'Invite your friends',
            titleColor: Colors.black,
            backgroundColor: Colors.white,
            centerTitle: true,
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SpaceWidget(height: MediaQuery.of(context).size.height * 0.05),
                  Image.asset('assets/images/refferal.png',
                      width: 384, height: 302),
                  AppText(
                    size: 20,
                    text: 'Just share this code with your friends and ask '
                        'them to sign up and add this code. You will get '
                        '50% Discount on their next membership renewal or purchase.',
                    color: const Color(0xff000000),
                    fontWeight: FontWeight.w600,
                    maxlin: 5,
                  ),
                  SpaceWidget(height: MediaQuery.of(context).size.height * 0.1),
                  TextFieldWidget(
                    title: "",
                    controller: TextEditingController(),
                    textFieldBorderColor: Colors.grey,
                    textInputType: TextInputType.text,
                    hint: referralCode,
                    hintColor: Colors.grey,
                    textFieldTitleColor: Colors.black,
                  ),
                  SpaceWidget(height: MediaQuery.of(context).size.height * 0.01),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: CustomButton(
                        text: 'Share Code',
                        onPressed: () {
                          _shareReferralCode(referralCode);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _shareReferralCode(String referralCode) {
    if (referralCode.isNotEmpty) {
      final String deepLinkUrl =
          'https://yourapp.com/invite?code=$referralCode';

      Share.share(
        'Join the app and use my referral code: $referralCode for a discount! Here\'s the link: $deepLinkUrl',
        subject: 'Referral Code for Awesome App',
      );
    }
  }
}
