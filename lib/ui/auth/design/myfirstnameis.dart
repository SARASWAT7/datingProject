
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/commonfiles/appcolor.dart';
import '../../../component/reuseable_widgets/appText.dart';
import '../../../component/reuseable_widgets/custom_button.dart';
import '../cubit/createaccount/createaccountcubit.dart';
import '../cubit/createaccount/createaccountstate.dart';

class MyFirstName extends StatefulWidget {
  const MyFirstName({super.key});

  @override
  State<MyFirstName> createState() => _MyFirstNameState();
}

class _MyFirstNameState extends State<MyFirstName> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateAccountCubit(),
      child: BlocBuilder<CreateAccountCubit, CreateAccountState>(
        builder: (context, state) {
          return Stack(
            children: [
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus(); // Close the keyboard when tapping outside
                },
                child: Scaffold(
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
                          text: 'My First name Is',
                          color: const Color(0xff1B1B1B),
                          fontWeight: FontWeight.w700,
                        ),
                        const SizedBox(height: 7),
                        AppText(
                          size: 18,
                          text:
                          'This is how it will appear in Dating  &  you will not able to change it.',
                          color: const Color(0xff555555),
                          fontWeight: FontWeight.w400,
                        ),
                        const SizedBox(height: 30),
                        TextField(
                          cursorColor: AppColor.tinderclr,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")), // Exclude spaces
                          ],
                          onChanged: (i) {
                            context.read<CreateAccountCubit>().firstName(i);
                          },
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Color(0xFFFD5564), width: 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            hintText: "First Name",
                            hintStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Nunito Sans',
                              color: Colors.grey,
                            ),
                            contentPadding:
                            EdgeInsets.fromLTRB(15, 15, 15, 15),
                            alignLabelWithHint: true,
                          ),
                          readOnly: false,
                        ),
                        const SizedBox(height: 30),
                        TextField(
                          cursorColor: AppColor.tinderclr,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")), // Exclude spaces
                          ],
                          onChanged: (i) {
                            context.read<CreateAccountCubit>().lastname(i);
                          },
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Color(0xFFFD5564), width: 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            hintText: "Last Name",
                            hintStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Nunito Sans',
                              color: Colors.grey,
                            ),
                            contentPadding:
                            EdgeInsets.fromLTRB(15, 15, 15, 15),
                            alignLabelWithHint: true,
                          ),
                          readOnly: false,
                        ),
                        const SizedBox(height: 60),
                        Center(
                            child: GestureDetector(
                                onTap: () {
                                  context
                                      .read<CreateAccountCubit>()
                                      .alldatacallect(context);
                                },
                                child: const CustomButton(text: 'Continue'))),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
