import 'package:demoproject/component/apihelper/common.dart';
import 'package:demoproject/component/reuseable_widgets/apploder.dart';
import 'package:demoproject/component/utils/custom_text.dart';
import 'package:demoproject/ui/auth/cubit/moreaboutme/moreaboutmecubit.dart';
import 'package:demoproject/ui/auth/cubit/moreaboutme/moreaboutmestate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../component/alert_box.dart';
import '../../component/commonfiles/appcolor.dart';
import '../../component/reuseable_widgets/custom_button.dart';
import '../../component/utils/headerwidget.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:dropdown_search/dropdown_search.dart';

class MoreAboutMeScreen extends StatefulWidget {
  const MoreAboutMeScreen({Key? key}) : super(key: key);

  @override
  State<MoreAboutMeScreen> createState() => _MoreAboutMeScreenState();
}

class _MoreAboutMeScreenState extends State<MoreAboutMeScreen> {
  final List<String> items = List<String>.generate(10, (i) => "Item $i");

  List<String> language = [
    "Amharic",
    "Arabic",
    "Basque",
    "Bengali",
    "English (UK)",
    "English (US)",
    "Portuguese(Brazil)",
    "Bulgarian",
    "Catalan",
    "Cherokee",
    "Croatian",
    "Czech",
    "Danish",
    "Dutch",
    "Estonian",
    "Filipino",
    "Finnish",
    "French",
    "German",
    "Greek",
    "Gujarati",
    "Hebrew",
    "Hindi",
    "Hungarian",
    "Icelandic",
    "Indonesian",
    "Italian",
    "Japanese",
    "Kannada",
    "Korean",
    "Latvian",
    "Lithuanian",
    "Malay",
    "Malayalam",
    "Marathi",
    "Norwegian",
    "Polish",
    "Portuguese",
    "Romanian",
    "Russian",
    "Serbian",
    "Chinese",
    "Slovak",
    "Slovenian",
    "Spanish",
    "Swahili",
    "Swedish",
    "Tamil",
    "Telugu",
    "Thai",
    "Chinese",
    "Turkish",
    "Urdu",
    "Ukrainian",
    "Vietnamese",
    "Welsh",
  ];
  List<String> exercise = ['Active', 'Sometimes', 'Not Serious', 'Never'];
  List<String> smoking = ['Never', 'Socially', 'Frequently', 'Sober'];
  List<String> drinking = ['Never', 'Socially', 'Frequently', 'Sober'];
  List<String> religion = [
    'Hinduism',
    'Christianity',
    'Sikhism',
    'Buddhism',
    'Jainism',
    'Islam',
    'Judaism',
    'African Diaspora Religions',
    'Indigenous American Religions',
    'Atheism/Agnosticism',
  ];
  List<String> kids = [
    'Have & Don’t want More',
    'Want Someday',
    'Don’t Want',
    'Have & Want More',
    'Not Sure Yet',
  ];
  List<String> politics = [
    'Apolitical',
    'Socialist',
    'Communist',
    'Feudal',
    'Moderate',
  ];
  List<String> pets = [
    "Dogs",
    "Cats",
    "Hamsters",
    "Guinea Pigs",
    "Rabbits",
    "Parrots",
    "Budgies",
    "Fish",
    "Turtles",
    "Chinchillas",
    "Ferrets",
    "Hermit Crabs",
    "Canaries",
    "Lovebirds",
    "Cockatiels",
    "Hedgehogs",
    "Gerbils",
    "Bearded Dragons",
    "Leopard Geckos",
    "Rats",
  ];
  List<String> relationshipstatus = [
    "Single",
    "Married",
    "Divorced",
    "Separated",
    "Unmarried",
  ];
  List<String> sunsign = [
    "Aries",
    "Taurus",
    "Gemini",
    "Cancer",
    "Leo",
    "Virgo",
    "Libra",
    "Scorpio",
    "Sagittarius",
    "Capricorn",
    "Aquarius",
    "Pisces",
  ];
  List<String> selectedLanguages = [];
  final int maxSelections =
      3; // Set the maximum number of languages that can be selected

  var languageController;
  var exerciseController;
  var smokingController;
  var drinkingController;
  var religionController;
  var kidController;
  var politicsController;
  var petsController;
  var relationshipController;
  var sunsignController;

  TextEditingController languageTextController = TextEditingController();
  TextEditingController exerciseTextController = TextEditingController();
  TextEditingController smokingTextController = TextEditingController();
  TextEditingController drinkingTextController = TextEditingController();

  TextEditingController religionTextController = TextEditingController();
  TextEditingController kidTextController = TextEditingController();
  TextEditingController politicsTextController = TextEditingController();
  TextEditingController petsTextController = TextEditingController();
  TextEditingController relationshipTextController = TextEditingController();
  TextEditingController sunsignTextController = TextEditingController();

  List<String> selected = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MoreAboutMeCubit(),
      child: BlocBuilder<MoreAboutMeCubit, MoreAboutMeState>(
        builder: (context, state) {
          return Stack(
            children: [
              Scaffold(
                backgroundColor: AppColor.white,
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        HeaderWidget(
                          title: 'More About Me',
                          progress: 0.56,
                          onTap: () {},
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 17, right: 17),
                          child: CustomText(
                            size: 13.sp,
                            text:
                                'Fill All The Details Which Tells About You More! Will Help You To Find Your Partner.',
                            color: Colors.black,
                            weight: FontWeight.w600,
                            fontFamily: 'Nunito Sans',
                          ),
                        ),
                        2.h.heightBox,
                        Padding(
                          padding: const EdgeInsets.only(left: 17, right: 17),
                          child: CustomText(
                            text: 'Language',
                            size: 15.sp,
                            color: Colors.black,
                            weight: FontWeight.w600,
                            fontFamily: 'Nunito Sans',
                          ).objectCenterLeft(),
                        ),
                        1.h.heightBox,
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: DropdownSearch<String>.multiSelection(
                              items: language,
                              selectedItems: selectedLanguages,
                              enabled: true,
                              dropdownBuilder: (context, selectedItems) {
                                if (selectedItems.isEmpty) {
                                  return Text(
                                    "Select Options",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13.sp,
                                      fontFamily: 'NunitoSans',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  );
                                } else {
                                  return Text(
                                    selectedItems.join(", "),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.sp,
                                      fontFamily: 'NunitoSans',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  );
                                }
                              },
                              popupProps: PopupPropsMultiSelection.menu(
                                showSelectedItems: true,
                                showSearchBox:
                                    true, // optional: allow searching languages
                                disabledItemFn: (String s) =>
                                    selectedLanguages.length >= maxSelections &&
                                    !selectedLanguages.contains(s),
                              ),
                              onChanged: (List<String> newValue) {
                                if (newValue.length <= maxSelections) {
                                  setState(() {
                                    selectedLanguages = newValue;
                                    languageTextController.text =
                                        selectedLanguages.join(", ");
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "You can select maximum $maxSelections languages",
                                      ),
                                    ),
                                  );
                                  setState(() {
                                    selectedLanguages = newValue
                                        .take(maxSelections)
                                        .toList();
                                    languageTextController.text =
                                        selectedLanguages.join(", ");
                                  });
                                }
                              },
                            ),
                          ),
                        ),

                        2.h.heightBox,
                        Padding(
                          padding: const EdgeInsets.only(left: 17, right: 17),
                          child: CustomText(
                            text: 'Exercise',
                            size: 15.sp,
                            color: Colors.black,
                            weight: FontWeight.w600,
                            fontFamily: 'Nunito Sans',
                          ).objectCenterLeft(),
                        ),
                        1.h.heightBox,
                        Padding(
                          padding: const EdgeInsets.only(left: 17, right: 17),
                          child: Container(
                            height: 7.h,
                            width: 100.w,
                            decoration: BoxDecoration(
                              color: const Color(
                                0xffFFFFFF,
                              ), // Solid white color
                              border: Border.all(
                                color: const Color(0xffBCBCBC),
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: DropdownButton(
                              dropdownColor: Colors.white,
                              underline: const SizedBox(),
                              isExpanded: true,
                              icon: const Icon(
                                Icons.arrow_drop_down_rounded,
                                color: Colors.black,
                              ),
                              iconDisabledColor: Colors.black,
                              iconEnabledColor: Colors.black,
                              style: TextStyle(
                                height: 2,
                                color: Colors.black,
                                fontSize: 14.sp,
                                fontFamily: 'NunitoSans',
                                fontWeight: FontWeight.w600,
                              ),
                              hint: CustomText(
                                color: Colors.black,
                                weight: FontWeight.w500,
                                fontFamily: 'Nunito Sans',
                                size: 14.sp,
                                text: 'Please choose an option',
                              ), // Not necessary for Option 1
                              value: exerciseController,
                              onChanged: (newValue) {
                                setState(() {
                                  exerciseController = newValue;
                                  exerciseTextController.text = newValue
                                      .toString();
                                });
                              },
                              items: exercise.map((location) {
                                return DropdownMenuItem(
                                  value: location,
                                  child: Text(location),
                                );
                              }).toList(),
                            ).pSymmetric(h: 10),
                          ),
                        ),
                        2.h.heightBox,
                        Padding(
                          padding: const EdgeInsets.only(left: 17, right: 17),
                          child: CustomText(
                            text: 'Smoking',
                            size: 15.sp,
                            color: Colors.black,
                            weight: FontWeight.w600,
                            fontFamily: 'Nunito Sans',
                          ).objectCenterLeft(),
                        ),
                        1.h.heightBox,
                        Padding(
                          padding: const EdgeInsets.only(left: 17, right: 17),
                          child: Container(
                            height: 7.h,
                            width: 100.w,
                            decoration: BoxDecoration(
                              color: const Color(
                                0xffFFFFFF,
                              ), // Solid white color
                              border: Border.all(
                                color: const Color(0xffBCBCBC),
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: DropdownButton(
                              dropdownColor: Colors.white,

                              underline: const SizedBox(),
                              isExpanded: true,
                              icon: const Icon(
                                Icons.arrow_drop_down_rounded,
                                color: Colors.black,
                              ),
                              iconDisabledColor: Colors.black,
                              iconEnabledColor: Colors.black,
                              style: TextStyle(
                                height: 2,
                                color: Colors.black,
                                fontSize: 14.sp,
                                fontFamily: 'NunitoSans',
                                fontWeight: FontWeight.w600,
                              ),
                              hint: CustomText(
                                color: Colors.black,
                                weight: FontWeight.w600,
                                fontFamily: 'Nunito Sans',
                                size: 14.sp,
                                text: 'Please choose an option',
                              ), // Not necessary for Option 1
                              value: smokingController,
                              onChanged: (newValue) {
                                setState(() {
                                  smokingController = newValue;
                                  smokingTextController.text = newValue
                                      .toString();
                                });
                              },
                              items: smoking.map((location) {
                                return DropdownMenuItem(
                                  value: location,
                                  child: Text(location),
                                );
                              }).toList(),
                            ).pSymmetric(h: 10),
                          ),
                        ),
                        2.h.heightBox,
                        Padding(
                          padding: const EdgeInsets.only(left: 17, right: 17),
                          child: CustomText(
                            text: 'Drinking',
                            size: 15.sp,
                            color: Colors.black,
                            weight: FontWeight.w700,
                            fontFamily: 'Nunito Sans',
                          ).objectCenterLeft(),
                        ),
                        1.h.heightBox,
                        Padding(
                          padding: const EdgeInsets.only(left: 17, right: 17),
                          child: Container(
                            height: 7.h,
                            width: 100.w,
                            decoration: BoxDecoration(
                              color: const Color(
                                0xffFFFFFF,
                              ), // Solid white color
                              border: Border.all(
                                color: const Color(0xffBCBCBC),
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: DropdownButton(
                              dropdownColor: Colors.white,

                              underline: const SizedBox(),
                              isExpanded: true,
                              icon: const Icon(
                                Icons.arrow_drop_down_rounded,
                                color: Colors.black,
                              ),
                              iconDisabledColor: Colors.black,
                              iconEnabledColor: Colors.black,
                              style: TextStyle(
                                height: 2,
                                color: Colors.black,
                                fontSize: 14.sp,
                                fontFamily: 'NunitoSans',
                                fontWeight: FontWeight.w600,
                              ),
                              hint: CustomText(
                                color: Colors.black,
                                weight: FontWeight.w600,
                                fontFamily: 'Nunito Sans',
                                size: 14.sp,
                                text: 'Please choose an option',
                              ), // Not necessary for Option 1
                              value: drinkingController,
                              onChanged: (newValue) {
                                setState(() {
                                  drinkingController = newValue;
                                  drinkingTextController.text = newValue
                                      .toString();
                                });
                              },
                              items: drinking.map((location) {
                                return DropdownMenuItem(
                                  value: location,
                                  child: Text(location),
                                );
                              }).toList(),
                            ).pSymmetric(h: 10),
                          ),
                        ),
                        2.h.heightBox,
                        Padding(
                          padding: const EdgeInsets.only(left: 17, right: 17),
                          child: CustomText(
                            text: 'Religion',
                            size: 15.sp,
                            color: Colors.black,
                            weight: FontWeight.w700,
                            fontFamily: 'Nunito Sans',
                          ).objectCenterLeft(),
                        ),
                        1.h.heightBox,
                        Padding(
                          padding: const EdgeInsets.only(left: 17, right: 17),
                          child: Container(
                            height: 7.h,
                            width: 100.w,
                            decoration: BoxDecoration(
                              color: const Color(
                                0xffFFFFFF,
                              ), // Solid white color
                              border: Border.all(
                                color: const Color(0xffBCBCBC),
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: DropdownButton(
                              dropdownColor: Colors.white,

                              underline: const SizedBox(),
                              isExpanded: true,
                              icon: const Icon(
                                Icons.arrow_drop_down_rounded,
                                color: Colors.black,
                              ),
                              iconDisabledColor: Colors.black,
                              iconEnabledColor: Colors.black,
                              style: TextStyle(
                                height: 2,
                                color: Colors.black,
                                fontSize: 14.sp,
                                fontFamily: 'NunitoSans',
                                fontWeight: FontWeight.w600,
                              ),
                              hint: CustomText(
                                color: Colors.black,
                                weight: FontWeight.w600,
                                fontFamily: 'Nunito Sans',
                                size: 14.sp,
                                text: 'Please choose an option',
                              ), // Not necessary for Option 1
                              value: religionController,
                              onChanged: (newValue) {
                                setState(() {
                                  print(newValue);
                                  religionController = newValue;
                                  print(religionController);
                                  religionTextController.text = newValue
                                      .toString();
                                });
                              },
                              items: religion.map((location) {
                                return DropdownMenuItem(
                                  value: location,
                                  child: Text(location),
                                );
                              }).toList(),
                            ).pSymmetric(h: 10),
                          ),
                        ),
                        2.h.heightBox,
                        // CustomText(
                        //   text: 'Astro charm',
                        //   size: 14.sp,
                        //     color: AppColor.grey, weight: FontWeight.w700, fontFamily: 'Nunito Sans'
                        // ).objectCenterLeft(),
                        // 1.h.heightBox,
                        // Container(
                        //   height: 7.h,
                        //   width: 100.w,
                        //   decoration: BoxDecoration(
                        //     border: Border.all(color: const Color(0xffBDBDBD)),
                        //     borderRadius: BorderRadius.circular(20),
                        //     gradient: const LinearGradient(
                        //         colors: [Color(0xFFFFFFFF), Color(0xFFD3D3D3)],
                        //         begin: Alignment.topCenter,
                        //         end: Alignment.bottomCenter),
                        //   ),
                        //   child: DropdownButton(
                        //     underline: const SizedBox(),
                        //     isExpanded: true,
                        //     icon: const Icon(
                        //       Icons.arrow_drop_down_rounded,
                        //       color: Colors.black,
                        //     ),
                        //     iconDisabledColor: Colors.black,
                        //     iconEnabledColor: Colors.black,
                        //     style: TextStyle(
                        //       color: Colors.black,
                        //       fontSize: 18.sp,
                        //       fontFamily: 'NunitoSans',
                        //       fontWeight: FontWeight.w600,
                        //     ),
                        //     hint: CustomText(
                        //         color: AppColor.grey, weight: FontWeight.w600, fontFamily: 'Nunito Sans',
                        //         size: 12.sp,
                        //         text:
                        //         'Please choose an option'), // Not necessary for Option 1
                        //     value: sinsignController,
                        //     onChanged: (newValue) {
                        //
                        //       setState(() {
                        //         sinsignController = newValue;
                        //         sunsignTextController.text = newValue.toString();
                        //       });
                        //     },
                        //     items: sunsign.map((location) {
                        //       return DropdownMenuItem(
                        //         value: location,
                        //         child: Text(location),
                        //       );
                        //     }).toList(),
                        //   ).pSymmetric(h: 10),
                        // ),
                        // 2.h.heightBox,
                        Padding(
                          padding: const EdgeInsets.only(left: 17, right: 17),
                          child: CustomText(
                            text: 'Do You Have Kids?',
                            size: 15.sp,
                            color: Colors.black,
                            weight: FontWeight.w700,
                            fontFamily: 'Nunito Sans',
                          ).objectCenterLeft(),
                        ),
                        1.h.heightBox,
                        Padding(
                          padding: const EdgeInsets.only(left: 17, right: 17),
                          child: Container(
                            height: 7.h,
                            width: 100.w,
                            decoration: BoxDecoration(
                              color: const Color(
                                0xffFFFFFF,
                              ), // Solid white color
                              border: Border.all(
                                color: const Color(0xffBCBCBC),
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: DropdownButton(
                              dropdownColor: Colors.white,

                              underline: const SizedBox(),
                              isExpanded: true,
                              icon: const Icon(
                                Icons.arrow_drop_down_rounded,
                                color: Colors.black,
                              ),
                              iconDisabledColor: Colors.black,
                              iconEnabledColor: Colors.black,
                              style: TextStyle(
                                height: 2,
                                color: Colors.black,
                                fontSize: 14.sp,
                                fontFamily: 'NunitoSans',
                                fontWeight: FontWeight.w600,
                              ),
                              hint: CustomText(
                                color: Colors.black,
                                weight: FontWeight.w600,
                                fontFamily: 'Nunito Sans',
                                size: 14.sp,
                                text: 'Please choose an option',
                              ), // Not necessary for Option 1
                              value: kidController,
                              onChanged: (newValue) {
                                setState(() {
                                  kidController = newValue;
                                  kidTextController.text = newValue.toString();
                                });
                              },
                              items: kids.map((location) {
                                return DropdownMenuItem(
                                  value: location,
                                  child: Text(location),
                                );
                              }).toList(),
                            ).pSymmetric(h: 10),
                          ),
                        ),
                        2.h.heightBox,
                        Padding(
                          padding: const EdgeInsets.only(left: 17, right: 17),
                          child: CustomText(
                            text: 'Politics',
                            size: 15.sp,
                            color: Colors.black,
                            weight: FontWeight.w600,
                            fontFamily: 'Nunito Sans',
                          ).objectCenterLeft(),
                        ),
                        1.h.heightBox,
                        Padding(
                          padding: const EdgeInsets.only(left: 17, right: 17),
                          child: Container(
                            height: 7.h,
                            width: 100.w,
                            decoration: BoxDecoration(
                              color: const Color(
                                0xffFFFFFF,
                              ), // Solid white color
                              border: Border.all(
                                color: const Color(0xffBCBCBC),
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: DropdownButton(
                              dropdownColor: Colors.white,

                              underline: const SizedBox(),
                              isExpanded: true,
                              icon: const Icon(
                                Icons.arrow_drop_down_rounded,
                                color: Colors.black,
                              ),
                              iconDisabledColor: Colors.black,
                              iconEnabledColor: Colors.black,
                              style: TextStyle(
                                height: 2,
                                color: Colors.black,
                                fontSize: 14.sp,
                                fontFamily: 'NunitoSans',
                                fontWeight: FontWeight.w600,
                              ),
                              hint: CustomText(
                                color: Colors.black,
                                weight: FontWeight.w600,
                                fontFamily: 'Nunito Sans',
                                size: 14.sp,
                                text: 'Please choose an option',
                              ), // Not necessary for Option 1
                              value: politicsController,
                              onChanged: (newValue) {
                                setState(() {
                                  politicsController = newValue;
                                  politicsTextController.text = newValue
                                      .toString();
                                });
                              },
                              items: politics.map((location) {
                                return DropdownMenuItem(
                                  value: location,
                                  child: Text(location),
                                );
                              }).toList(),
                            ).pSymmetric(h: 10),
                          ),
                        ),
                        2.h.heightBox,
                        Padding(
                          padding: const EdgeInsets.only(left: 17, right: 17),
                          child: CustomText(
                            text: 'Pets',
                            size: 15.sp,
                            color: Colors.black,
                            weight: FontWeight.w700,
                            fontFamily: 'Nunito Sans',
                          ).objectCenterLeft(),
                        ),
                        1.h.heightBox,
                        Padding(
                          padding: const EdgeInsets.only(left: 17, right: 17),
                          child: Container(
                            height: 7.h,
                            width: 100.w,
                            decoration: BoxDecoration(
                              color: const Color(
                                0xffFFFFFF,
                              ), // Solid white color
                              border: Border.all(
                                color: const Color(0xffBCBCBC),
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Center(
                                child: DropdownButton<String>(
                                  dropdownColor: Colors.white,

                                  underline: const SizedBox(),
                                  isExpanded: true,
                                  icon: const Icon(
                                    Icons.arrow_drop_down_rounded,
                                    color: Colors.black,
                                  ),
                                  iconDisabledColor: Colors.black,
                                  iconEnabledColor: Colors.black,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.sp,
                                    fontFamily: 'NunitoSans',
                                    fontWeight: FontWeight.w600,
                                  ),
                                  hint: CustomText(
                                    color: Colors.black,
                                    weight: FontWeight.w600,
                                    fontFamily: 'Nunito Sans',
                                    size: 14.sp,
                                    text: 'Please choose an option',
                                  ),
                                  value: petsController,
                                  onChanged: (newValue) {
                                    setState(() {
                                      petsController = newValue;
                                      petsTextController.text = newValue!;
                                    });
                                  },
                                  items: pets.map((location) {
                                    return DropdownMenuItem(
                                      value: location,
                                      child: Text(location),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        2.h.heightBox,
                        Padding(
                          padding: const EdgeInsets.only(left: 17, right: 17),
                          child: CustomText(
                            text: 'Relationship',
                            size: 15.sp,
                            color: Colors.black,
                            weight: FontWeight.w700,
                            fontFamily: 'Nunito Sans',
                          ).objectCenterLeft(),
                        ),
                        1.h.heightBox,
                        Padding(
                          padding: const EdgeInsets.only(left: 17, right: 17),
                          child: Container(
                            height: 7.h,
                            width: 100.w,
                            decoration: BoxDecoration(
                              color: const Color(
                                0xffFFFFFF,
                              ), // Solid white color
                              border: Border.all(
                                color: const Color(0xffBCBCBC),
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Center(
                                child: DropdownButton<String>(
                                  dropdownColor: Colors.white,

                                  underline: const SizedBox(),
                                  isExpanded: true,
                                  icon: const Icon(
                                    Icons.arrow_drop_down_rounded,
                                    color: Colors.black,
                                  ),
                                  iconDisabledColor: Colors.black,
                                  iconEnabledColor: Colors.black,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.sp,
                                    fontFamily: 'NunitoSans',
                                    fontWeight: FontWeight.w600,
                                  ),
                                  hint: CustomText(
                                    color: Colors.black,
                                    weight: FontWeight.w600,
                                    fontFamily: 'Nunito Sans',
                                    size: 14.sp,
                                    text: 'Please choose an option',
                                  ),
                                  value: relationshipController,
                                  onChanged: (newValue) {
                                    setState(() {
                                      relationshipController = newValue;
                                      relationshipTextController.text =
                                          newValue!;
                                    });
                                  },
                                  items: relationshipstatus.map((location) {
                                    return DropdownMenuItem(
                                      value: location,
                                      child: Text(location),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        2.h.heightBox,
                        Padding(
                          padding: const EdgeInsets.only(left: 17, right: 17),
                          child: CustomText(
                            text: 'SunSign',
                            size: 15.sp,
                            color: Colors.black,
                            weight: FontWeight.w700,
                            fontFamily: 'Nunito Sans',
                          ).objectCenterLeft(),
                        ),
                        1.h.heightBox,
                        Padding(
                          padding: const EdgeInsets.only(left: 17, right: 17),
                          child: Container(
                            height: 7.h,
                            width: 100.w,
                            decoration: BoxDecoration(
                              color: const Color(
                                0xffFFFFFF,
                              ), // Solid white color
                              border: Border.all(
                                color: const Color(0xffBCBCBC),
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Center(
                                child: DropdownButton<String>(
                                  dropdownColor: Colors.white,
                                  underline: const SizedBox(),
                                  isExpanded: true,
                                  icon: const Icon(
                                    Icons.arrow_drop_down_rounded,
                                    color: Colors.black,
                                  ),
                                  iconDisabledColor: Colors.black,
                                  iconEnabledColor: Colors.black,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.sp,
                                    fontFamily: 'NunitoSans',
                                    fontWeight: FontWeight.w600,
                                  ),
                                  hint: CustomText(
                                    color: Colors.black,
                                    weight: FontWeight.w600,
                                    fontFamily: 'Nunito Sans',
                                    size: 14.sp,
                                    text: 'Please choose an option',
                                  ),
                                  value: sunsignController,
                                  onChanged: (newValue) {
                                    setState(() {
                                      sunsignController = newValue;
                                      sunsignTextController.text = newValue!;
                                    });
                                  },
                                  items: sunsign.map((location) {
                                    return DropdownMenuItem(
                                      value: location,
                                      child: Text(location),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ),

                        6.h.heightBox,
                        GestureDetector(
                          onTap: () {
                            if (selectedLanguages.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (_) => const AlertBox(
                                  title: "Please choose a Language",
                                ),
                              );
                            } else if (exerciseTextController.text.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (_) => const AlertBox(
                                  title: "Please choose an exercise",
                                ),
                              );
                            } else if (smokingTextController.text.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (_) => const AlertBox(
                                  title: "Please choose an option for smoking",
                                ),
                              );
                            } else if (drinkingTextController.text.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (_) => const AlertBox(
                                  title: "Please choose an option for drinking",
                                ),
                              );
                            } else if (religionTextController.text.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (_) => const AlertBox(
                                  title: "Please choose an option for religion",
                                ),
                              );
                            } else if (kidTextController.text.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (_) => const AlertBox(
                                  title:
                                      "Please choose an option for having kids",
                                ),
                              );
                            } else if (politicsTextController.text.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (_) => const AlertBox(
                                  title: "Please choose an option for politics",
                                ),
                              );
                            } else if (petsTextController.text.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (_) => const AlertBox(
                                  title: "Please choose an option for pets",
                                ),
                              );
                            } else if (relationshipTextController
                                .text
                                .isEmpty) {
                              showDialog(
                                context: context,
                                builder: (_) => const AlertBox(
                                  title:
                                      "Please choose an option for relationship",
                                ),
                              );
                            } else if (sunsignTextController.text.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (_) => const AlertBox(
                                  title:
                                      "Please choose an option for relationship",
                                ),
                              );
                            } else {
                              context.read<MoreAboutMeCubit>().moreabout(
                                context,
                                exerciseTextController.text,
                                smokingTextController.text,
                                drinkingTextController.text,
                                religionController,
                                kidTextController.text,
                                politicsTextController.text,
                                petsTextController.text,
                                selectedLanguages.join(
                                  ", ",
                                ), // Pass selected languages as a comma-separated string
                                relationshipTextController.text,
                                sunsignTextController.text,

                                // Helper().check().then((isInterAvailable) async {
                                //   if (isInterAvailable) {

                                //   } else {
                                //     showDialog(
                                //       context: context,
                                //       builder: (_) => const AlertBox(
                                //         title:
                                //             "Something went wrong, please try again.",
                                //       ),
                                //     );
                                //   }
                                // }
                              );
                            }
                          },
                          child: CustomButton(text: 'Continue'),
                        ),
                        SizedBox(height: 18),
                      ],
                    ).pSymmetric(h: 10),
                  ),
                ),
              ),
              if (state.status == ApiState.isLoading) AppLoader(),
            ],
          );
        },
      ),
    );
  }
}
