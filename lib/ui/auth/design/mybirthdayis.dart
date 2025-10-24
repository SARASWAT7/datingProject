
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../component/apihelper/common.dart';
import '../../../component/commonfiles/appcolor.dart';
import '../../../component/reuseable_widgets/appText.dart';
import '../../../component/reuseable_widgets/apploder.dart';
import '../../../component/reuseable_widgets/custom_button.dart';
import '../../../../component/apihelper/normalmessage.dart';
import '../cubit/createaccount/createaccountcubit.dart';
import '../cubit/createaccount/createaccountstate.dart';

class MyBirthday extends StatefulWidget {
  final String firstname;
  final String lastname;
  const MyBirthday({super.key, this.firstname = "", this.lastname = ""});

  @override
  State<MyBirthday> createState() => _MyBirthdayState();
}

class _MyBirthdayState extends State<MyBirthday> {
  TextEditingController _dateController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateAccountCubit(),
      child: BlocBuilder<CreateAccountCubit, CreateAccountState>(
        builder: (context, state) {
          return Stack(
            children: [
              Scaffold(
                body: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 25, right: 25, top: 15),
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
                          text: 'My Birthday Is',
                          color: Color(0xff1B1B1B),
                          fontWeight: FontWeight.w700,
                        ),
                        SizedBox(height: 7),
                        AppText(
                          size: 18,
                          text: 'Your age will be public',
                          color: Color(0xff555555),
                          fontWeight: FontWeight.w400,
                        ),
                        SizedBox(height: 30),
                        TextField(
                          onChanged: (i) {
                            context.read<CreateAccountCubit>().dob(i);
                          },
                          controller: _dateController,
                          // decoration: InputDecoration(
                          //   labelText: 'YYYY/MM/DD',
                          //   filled: true,
                          //   fillColor: Colors.transparent,
                          //   enabledBorder: OutlineInputBorder(
                          //     borderRadius: BorderRadius.circular(30),
                          //     borderSide: const BorderSide(
                          //       color: Colors.grey,
                          //       width: 1.0, // Set border width here
                          //     ),
                          //   ),
                          //   focusedBorder: OutlineInputBorder(
                          //     borderRadius: BorderRadius.circular(30),
                          //     borderSide: const BorderSide(
                          //       color: Colors.grey,
                          //       width: 1.0, // Set border width here to match enabledBorder
                          //     ),
                          //   ),
                          //   // Adding padding to make it look like a container
                          //   contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                          // ),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular( 20),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFFD5564), width: 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            hintText: "DD/MM/YYYY",
                            hintStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Nunito Sans',
                              color: Colors.grey,
                            ),
                            contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                            alignLabelWithHint: true,

                          ),
                          readOnly: true,
                          onTap: () {
                            _selectDate();
                          },
                        ),

                        const SizedBox(height: 60),
                        Center(
                            child: GestureDetector(
                                onTap: () {
                                  if(_dateController.text.isEmpty){
                                    NormalMessage().normalerrorstate(context, "Please select date of birth");
                                  }else{
                                      context
                                      .read<CreateAccountCubit>()
                                      .createaccount(
                                          context,
                                          widget.firstname,
                                          widget.lastname,_dateController.text.toString(),);
                                  }
                                },
                                child: const CustomButton(text: 'Continue'))),
                      ],
                    ),
                  ),
                ),
              ),
              state.status == ApiState.isLoading ? AppLoader() : Container()
            ],
          );
        },
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime now = DateTime.now();
    DateTime eighteenYearsAgo = DateTime(now.year - 18, now.month, now.day);

    DateTime? _selected = await showDatePicker(
      context: context,
      firstDate: DateTime(1000),
      lastDate: eighteenYearsAgo,
      initialDate: eighteenYearsAgo,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColor.iconsColor, // Header background color
            hintColor: AppColor.iconsColor, // Selected date color
            colorScheme: ColorScheme.light(primary: AppColor.iconsColor), // Header text color
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary, // Button text color
            ),
          ),
          child: child!,
        );
      },
    );

    if (_selected != null) {
      setState(() {
        _dateController.text = DateFormat('dd-MM-yyyy').format(_selected);
      });
    }
  }}
