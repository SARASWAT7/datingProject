import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:sizer/sizer.dart';
import '../../../component/commonfiles/appcolor.dart';
import '../../../component/reuseable_widgets/appBar.dart';
import '../../../component/reuseable_widgets/apptext.dart';
import '../../../component/reuseable_widgets/custom_button.dart';
import 'package:demoproject/component/reuseable_widgets/text_field.dart';
import 'flutterpets.dart';

class FlutterPolitics extends StatefulWidget {
  const FlutterPolitics({Key? key}) : super(key: key);

  @override
  State<FlutterPolitics> createState() => _FlutterPoliticsState();
}

class _FlutterPoliticsState extends State<FlutterPolitics> {
  final List<String> items = List<String>.generate(10, (i) => "Item $i");

  final List<String> gender = [
    "Apolitical",
    "Socialist",
    "Communist",
    "Feudal",
    "Moderate"
  ];
  final GroupButtonController controller = GroupButtonController();
  String selectedButon = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: 'Politics',
        titleColor: Colors.black,
        backgroundColor: Colors.white,
        centerTitle: true,
        showBorder: false, // Set this to true or false as needed
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Spacer(),
          Container(
            height: MediaQuery.of(context).size.height * 0.86,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Color(0xffFFC8D3),
              borderRadius: BorderRadius.only(topLeft:Radius.circular(45),topRight:Radius.circular(45)),
            ),
            child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    AppText(
                      size: 18,
                      maxlin: 2,
                      text:
                          'Select the politic type you would prefer in your partner.',
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                    Center(
                      child: GroupButton(
                        controller: controller,
                        isRadio: true,
                        maxSelected: 1,
                        buttons: gender,
                        onSelected: (value, index, isSelected) {
                          setState(() {
                            // controller.selectIndex(index);
                            selectedButon = value.toString();
                          });
                        },
                        options: GroupButtonOptions(
                          selectedTextStyle: TextStyle(
                            fontSize: 18.sp,
                            color: bgClr,
                          ),
                          selectedColor:
                              Colors.white, // White background when selected
                          unselectedColor: Colors
                              .transparent, // Transparent background when not selected
                          selectedBorderColor: bgClr,
                          unselectedBorderColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                          spacing: 1.h,
                          runSpacing: 1.h,
                          groupingType: GroupingType.column,
                          direction: Axis.horizontal,
                          buttonHeight: 6.h,
                          buttonWidth: 45.w,
                          mainGroupAlignment: MainGroupAlignment.start,
                          crossGroupAlignment: CrossGroupAlignment.start,
                          groupRunAlignment: GroupRunAlignment.start,
                          textAlign: TextAlign.center,
                          textPadding: EdgeInsets.zero,
                          alignment: Alignment.center,
                          elevation: 0,
                        ),
                      ),
                    ),
                    SpaceWidget(
                        height: MediaQuery.of(context).size.height * 0.1),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const FilterPets()),
                          );
                        },
                        child: CustomButton(text: 'Apply Filter'))
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
