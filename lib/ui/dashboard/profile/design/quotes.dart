import 'package:demoproject/component/apihelper/urls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../../component/alert_box.dart';
import '../../../../component/apihelper/common.dart';
import '../../../../component/reuseable_widgets/appbar.dart';
import '../../../../component/reuseable_widgets/apploder.dart';
import '../../../../component/reuseable_widgets/apptext.dart';
import '../../../../component/reuseable_widgets/container.dart';
import '../../../../component/reuseable_widgets/custom_button.dart';
import '../../../../component/reuseable_widgets/reusebottombar.dart';
import '../cubit/updateData/updateprofilecubit.dart';
import '../cubit/updateData/updateprofilestate.dart';
import 'editProfile.dart';

class Quotes extends StatefulWidget {
  const Quotes({super.key});

  @override
  State<Quotes> createState() => _QuotesState();
}

class _QuotesState extends State<Quotes> {
  final TextEditingController _controller = TextEditingController();
  int? _selectedContainerIndex;

  List<String> quotes = [
    'My Nani used to call me.',
    '2 things I can’t get enough of would be.',
    'My love language is.',
    'Yes! I’m an adult but',
    'The worst advice I ever gave',
    'I think sara zamana should',
    'Let’s agree to disagree on',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onContainerTap(String text, int index) {
    setState(() {
      _selectedContainerIndex = index;
      _controller.text = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UpdateProfileCubit(),
      child: BlocBuilder<UpdateProfileCubit, UpdateProfileState>(
        builder: (context, state) {
          return Scaffold(
            bottomNavigationBar: BottomSteet(currentIndex: 4),
            appBar: appBarWidgetThree(
              leading: Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
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
              title: 'Quotes',
              titleColor: Colors.black,
              backgroundColor: Colors.white,
              centerTitle: true,
              showBorder: true,
            ),
            backgroundColor: Colors.white,
            body: state.status == ApiState.isLoading
                ? Center(child: AppLoader())
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            fontWeight: FontWeight.w400,
                            size: 22.0,
                            text:
                                'Pick a Quote so that your partner can see on your profile.',
                          ),
                          SizedBox(height: 10),
                          ..._buildQuoteOptions(),
                          SizedBox(height: 20),
                          AppContainer(
                            height: MediaQuery.of(context).size.height * 0.1,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.white,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    'assets/images/quotes1.png',
                                    width: 50,
                                    height: 50,
                                  ),
                                ),
                                Expanded(
                                  child: TextField(
                                    maxLines: 2,
                                    controller: _controller,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Nunito Sans',
                                      color: Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Type here...',
                                      hintStyle: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Nunito Sans',
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      border: InputBorder.none,
                                      isDense: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              print("pushkar");
                              List<String> quotes = [];

                              if (_controller.text.isNotEmpty) {
                                quotes.add(_controller.text);
                              } else if (_selectedContainerIndex != null &&
                                  _selectedContainerIndex! < quotes.length) {
                                quotes.add(quotes[_selectedContainerIndex!]);
                              }

                              if (quotes.isNotEmpty) {
                                String formData = quotes.join(" ");

                                context
                                    .read<UpdateProfileCubit>()
                                    .quotes(context, formData);
                              } else {
                                print("No quotes to submit");
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.only(left: 4.w, right: 4.w),
                              child: CustomButton(text: 'Continue'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }

  List<Widget> _buildQuoteOptions() {
    return List<Widget>.generate(quotes.length, (index) {
      return GestureDetector(
        onTap: () => _onContainerTap(quotes[index], index),
        child: AppContainer(
          height: MediaQuery.of(context).size.height * 0.06,
          width: MediaQuery.of(context).size.width,
          color: _selectedContainerIndex == index ? Colors.pink : Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                AppText(
                  fontWeight: FontWeight.w400,
                  size: 12.sp,
                  text: quotes[index],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
