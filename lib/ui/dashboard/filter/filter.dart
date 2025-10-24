// import 'package:demoproject/ui/dashboard/filter/cubit/filtercubit.dart';
// import 'package:demoproject/ui/dashboard/filter/cubit/filterstate.dart';
// import 'package:demoproject/ui/dashboard/home/cubit/homecubit/homecubit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../component/reuseable_widgets/customaboutme.dart';
// import '../../../component/reuseable_widgets/text_field.dart';
// import '../../../component/reuseable_widgets/appBar.dart';
// import '../../../component/reuseable_widgets/custom_button.dart';
//
// class FilterScreen extends StatefulWidget {
//   const FilterScreen({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   State<FilterScreen> createState() => _FilterScreenState();
// }
//
// class _FilterScreenState extends State<FilterScreen> {
//   int? selectedIndex;
//   double selectedHeight = 100;
//   String selectedPhotoOption = "";
//   String selectedBio = "";
//   List<String> selectedPassions = [];
//   String selectedExercise = "";
//   String selectedDrink = "";
//   String selectedSmoke = "";
//   String selectedLanguage = "";
//   String selectedKids = "";
//   String selectedSunSign = "";
//   List<String> selectedReligions = [];
//   List<String> selectedPets = [];
//
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<FilterCubit, FilterState>(
//       builder: (context, state) {
//         return Scaffold(
//           appBar: appBarWidgetThree(
//             leading: Padding(
//               padding: const EdgeInsets.only(left: 5.0),
//               child: GestureDetector(
//                 onTap: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Transform.scale(
//                   scale: 0.5,
//                   child: Image.asset(
//                     'assets/images/backarrow.png',
//                     height: 50,
//                     width: 50,
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//               ),
//             ),
//             title: 'Filter',
//             titleColor: Colors.black,
//             backgroundColor: Colors.white,
//             centerTitle: true,
//             showBorder: false,
//           ),
//           backgroundColor: Colors.white,
//           body: Column(
//             children: [
//               Spacer(),
//               Container(
//                 height: MediaQuery.of(context).size.height * 0.86,
//                 width: MediaQuery.of(context).size.width,
//                 decoration: BoxDecoration(
//                   color: Color(0xffFFC8D3),
//                   borderRadius: BorderRadius.only(topLeft:Radius.circular(45),topRight:Radius.circular(45)),
//                 ),
//                 child: Padding(
//                   padding: EdgeInsets.all(10.0),
//                   child: SingleChildScrollView(
//                     child: Column(
//                       children: [
//                         ProfileItem(
//                           iconAssetPath: 'assets/images/crown.png',
//                           title: 'View verified',
//                           trailingText: state.verified,
//                           index: 0,
//                           selectedIndex: state.selectedPage,
//                           onTap: (index) {
//                             context
//                                 .read<FilterCubit>()
//                                 .selectedIndex(context, 0);
//                           },
//                         ),
//                         ProfileItem(
//                           iconAssetPath: 'assets/images/crown.png',
//                           title: 'What is their height?',
//                           trailingText: state.heightmin.isNotEmpty && state.heightmax.isNotEmpty
//                               ? '${state.heightmin} - ${state.heightmax}'
//                           :"",
//                           index: 1,
//                           selectedIndex: state.selectedPage,
//                           onTap: (index) async {
//                             context.read<FilterCubit>().selectedIndex(context, 1);
//
//                           },
//                         ),
//
//                         ProfileItem(
//                           iconAssetPath: 'assets/images/crown.png',
//                           title: 'Minimum number of photos',
//                           trailingText: state.minphotolenght,
//                           index: 2,
//                           selectedIndex: state.selectedPage,
//                           onTap: (index) async {
//                             context
//                                 .read<FilterCubit>()
//                                 .selectedIndex(context, 2);
//                           },
//                         ),
//                         ProfileItem(
//                           iconAssetPath: 'assets/images/crown.png',
//                           title: 'Has a bio',
//                           trailingText: state.hasbio,
//                           index: 3,
//                           selectedIndex: state.selectedPage,
//                           onTap: (index) async {
//                             context
//                                 .read<FilterCubit>()
//                                 .selectedIndex(context, 3);
//                           },
//                         ),
//                         ProfileItem(
//                           iconAssetPath: 'assets/images/crown.png',
//                           title: 'Passions',
//                           trailingText: (state.passion?.isEmpty ?? true)
//                               ? ""
//                               : state.passion?.first ?? "",
//                           index: 4,
//                           selectedIndex: state.selectedPage,
//                           onTap: (index) async {
//                             context
//                                 .read<FilterCubit>()
//                                 .selectedIndex(context, 4);
//                           },
//                         ),
//                         ProfileItem(
//                           iconAssetPath: 'assets/images/crown.png',
//                           title: 'Do they exercise',
//                           trailingText: state.doExercise,
//                           index: 5,
//                           selectedIndex: state.selectedPage,
//                           onTap: (index) async {
//                             context
//                                 .read<FilterCubit>()
//                                 .selectedIndex(context, 5);
//                           },
//                         ),
//                         ProfileItem(
//                           iconAssetPath: 'assets/images/crown.png',
//                           title: 'Do they drink',
//                           trailingText: state.dotheydrink,
//                           index: 6,
//                           selectedIndex: state.selectedPage,
//                           onTap: (index) async {
//                             context
//                                 .read<FilterCubit>()
//                                 .selectedIndex(context, 6);
//                           },
//                         ),
//                         ProfileItem(
//                           iconAssetPath: 'assets/images/crown.png',
//                           title: 'Do they smoke',
//                           trailingText: state.dotheysmoke,
//                           index: 7,
//                           selectedIndex: state.selectedPage,
//                           onTap: (index) async {
//                             context
//                                 .read<FilterCubit>()
//                                 .selectedIndex(context, 7);
//                           },
//                         ),
//                         ProfileItem(
//                           iconAssetPath: 'assets/images/crown.png',
//                           title: 'Languages they know',
//                           trailingText:
//                               (state.languagetheyknow?.isEmpty ?? true)
//                                   ? ""
//                                   : state.languagetheyknow?.first ?? "",
//                           index: 8,
//                           selectedIndex: state.selectedPage,
//                           onTap: (index) async {
//                             context
//                                 .read<FilterCubit>()
//                                 .selectedIndex(context, 8);
//                           },
//                         ),
//                         ProfileItem(
//                           iconAssetPath: 'assets/images/crown.png',
//                           title: 'Do they have or want kids',
//                           trailingText: state.kids,
//                           index: 9,
//                           selectedIndex: state.selectedPage,
//                           onTap: (index) async {
//                             context
//                                 .read<FilterCubit>()
//                                 .selectedIndex(context, 9);
//                           },
//                         ),
//                         ProfileItem(
//                           iconAssetPath: 'assets/images/crown.png',
//                           title: 'Sun sign',
//                           trailingText: state.sunSign,
//                           index: 10,
//                           selectedIndex: state.selectedPage,
//                           onTap: (index) async {
//                             context
//                                 .read<FilterCubit>()
//                                 .selectedIndex(context, 10);
//                           },
//                         ),
//                         ProfileItem(
//                           iconAssetPath: 'assets/images/crown.png',
//                           title: 'Religion',
//                           trailingText: state.religion,
//                           index: 11,
//                           selectedIndex: state.selectedPage,
//                           onTap: (index) async {
//                             context
//                                 .read<FilterCubit>()
//                                 .selectedIndex(context, 11);
//                           },
//                         ),
//                         ProfileItem(
//                           iconAssetPath:
//                               'assets/images/crown.png', // Update icon path
//                           title: 'Pets',
//                           trailingText: state.pets,
//                           index: 12,
//                           selectedIndex: state.selectedPage,
//                           onTap: (index) async {
//                             context
//                                 .read<FilterCubit>()
//                                 .selectedIndex(context, 12);
//                           },
//                         ),
//                         SpaceWidget(
//                             height: MediaQuery.of(context).size.height * 0.04),
//                         GestureDetector(
//                           onTap: () {},
//                           child: CustomButton(
//                             text: 'Apply Filter',
//                             onPressed: () {
//                               context.read<HomePageCubit>().filter(context, {
//                                 "profile_verified": "No",
//                                 "height": num.parse(state.heightmin.isEmpty
//                                     ? "0"
//                                     : state.heightmin.split(' ').first),
//                                 "min_photo": state.minphotolenght, //default 2,
//                                 "bio": state.hasbio,
//                                 "passions": state.passion ?? [],
//                                 "exercise": state.doExercise,
//                                 "drinking": state.dotheydrink,
//                                 "smoking": state.dotheysmoke,
//                                 "languages": state.languagetheyknow ?? [],
//                                 "have_kids": state.kids,
//                                 "sun_sign": state.sunSign,
//                                 "religion": state.religion,
//                                 "politic": state.politics,
//                                 "pet": state.pets
//                               });
//                               int count = 0;
//                               Navigator.of(context)
//                                   .popUntil((_) => count++ >= 2);
//                             },
//                           ),
//                         ),
//                         SpaceWidget(
//                             height: MediaQuery.of(context).size.height * 0.04),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:demoproject/ui/dashboard/filter/cubit/filtercubit.dart';
import 'package:demoproject/ui/dashboard/filter/cubit/filterstate.dart';
import 'package:demoproject/ui/dashboard/home/cubit/homecubit/homecubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../component/reuseable_widgets/customaboutme.dart';
import '../../../component/reuseable_widgets/text_field.dart';
import '../../../component/reuseable_widgets/appBar.dart';
import '../../../component/reuseable_widgets/custom_button.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterCubit, FilterState>(
      builder: (context, state) {
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
            title: 'Filter',
            titleColor: Colors.black,
            backgroundColor: Colors.white,
            centerTitle: true,
            showBorder: false,
          ),
          backgroundColor: Colors.white,
          body: RefreshIndicator(
            onRefresh: () async {
              context.read<FilterCubit>().resetFilter();
            },
            child: Column(
              children: [
                Spacer(),
                Container(
                  height: MediaQuery.of(context).size.height * 0.86,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color(0xffFFC8D3),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(45),
                      topRight: Radius.circular(45),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ProfileItem(
                            iconAssetPath: 'assets/images/crown.png',
                            title: 'View verified',
                            trailingText: state.verified,
                            index: 0,
                            selectedIndex: state.selectedPage,
                            onTap: (index) {
                              context.read<FilterCubit>().selectedIndex(context, 0);
                            },
                          ),
                          ProfileItem(
                            iconAssetPath: 'assets/images/crown.png',
                            title: 'What is their height?',
                            trailingText: state.heightmin.isNotEmpty && state.heightmax.isNotEmpty
                                ? '${state.heightmin}-${state.heightmax}'
                                : "",
                            index: 1,
                            selectedIndex: state.selectedPage,
                            onTap: (index) async {
                              context.read<FilterCubit>().selectedIndex(context, 1);
                            },
                          ),
                          ProfileItem(
                            iconAssetPath: 'assets/images/crown.png',
                            title: 'Minimum number of photos',
                            trailingText: state.minphotolenght,
                            index: 2,
                            selectedIndex: state.selectedPage,
                            onTap: (index) async {
                              context.read<FilterCubit>().selectedIndex(context, 2);
                            },
                          ),
                          ProfileItem(
                            iconAssetPath: 'assets/images/crown.png',
                            title: 'Has a bio',
                            trailingText: state.hasbio,
                            index: 3,
                            selectedIndex: state.selectedPage,
                            onTap: (index) async {
                              context.read<FilterCubit>().selectedIndex(context, 3);
                            },
                          ),
                          ProfileItem(
                            iconAssetPath: 'assets/images/crown.png',
                            title: 'Passions',
                            trailingText: (state.passion?.isEmpty ?? true)
                                ? ""
                                : state.passion?.first ?? "",
                            index: 4,
                            selectedIndex: state.selectedPage,
                            onTap: (index) async {
                              context.read<FilterCubit>().selectedIndex(context, 4);
                            },
                          ),
                          ProfileItem(
                            iconAssetPath: 'assets/images/crown.png',
                            title: 'Do they exercise',
                            trailingText: state.doExercise,
                            index: 5,
                            selectedIndex: state.selectedPage,
                            onTap: (index) async {
                              context.read<FilterCubit>().selectedIndex(context, 5);
                            },
                          ),
                          ProfileItem(
                            iconAssetPath: 'assets/images/crown.png',
                            title: 'Do they drink',
                            trailingText: state.dotheydrink,
                            index: 6,
                            selectedIndex: state.selectedPage,
                            onTap: (index) async {
                              context.read<FilterCubit>().selectedIndex(context, 6);
                            },
                          ),
                          ProfileItem(
                            iconAssetPath: 'assets/images/crown.png',
                            title: 'Do they smoke',
                            trailingText: state.dotheysmoke,
                            index: 7,
                            selectedIndex: state.selectedPage,
                            onTap: (index) async {
                              context.read<FilterCubit>().selectedIndex(context, 7);
                            },
                          ),
                          ProfileItem(
                            iconAssetPath: 'assets/images/crown.png',
                            title: 'Languages they know',
                            trailingText: (state.languagetheyknow?.isEmpty ?? true)
                                ? ""
                                : state.languagetheyknow?.first ?? "",
                            index: 8,
                            selectedIndex: state.selectedPage,
                            onTap: (index) async {
                              context.read<FilterCubit>().selectedIndex(context, 8);
                            },
                          ),
                          ProfileItem(
                            iconAssetPath: 'assets/images/crown.png',
                            title: 'Do they have or want kids',
                            trailingText: state.kids,
                            index: 9,
                            selectedIndex: state.selectedPage,
                            onTap: (index) async {
                              context.read<FilterCubit>().selectedIndex(context, 9);
                            },
                          ),
                          ProfileItem(
                            iconAssetPath: 'assets/images/crown.png',
                            title: 'Sun sign',
                            trailingText: state.sunSign,
                            index: 10,
                            selectedIndex: state.selectedPage,
                            onTap: (index) async {
                              context.read<FilterCubit>().selectedIndex(context, 10);
                            },
                          ),
                          ProfileItem(
                            iconAssetPath: 'assets/images/crown.png',
                            title: 'Religion',
                            trailingText: state.religion,
                            index: 11,
                            selectedIndex: state.selectedPage,
                            onTap: (index) async {
                              context.read<FilterCubit>().selectedIndex(context, 11);
                            },
                          ),
                          ProfileItem(
                            iconAssetPath: 'assets/images/crown.png',
                            title: 'Pets',
                            trailingText: state.pets,
                            index: 12,
                            selectedIndex: state.selectedPage,
                            onTap: (index) async {
                              context.read<FilterCubit>().selectedIndex(context, 12);
                            },
                          ),
                          SpaceWidget(
                              height: MediaQuery.of(context).size.height * 0.04),
                          GestureDetector(
                            onTap: () {},
                            child: CustomButton(

                              text: 'Apply Filter',
                              onPressed: () {
                                context.read<HomePageCubit>().filter(context, {
                                  "profile_verified": state.verified,
                                  "height": '${state.heightmin}${state.heightmax}',
                                  "min_photo": state.minphotolenght,
                                  "bio": state.hasbio,
                                  "passions": state.passion ?? [],
                                  "exercise": state.doExercise,
                                  "drinking": state.dotheydrink,
                                  "smoking": state.dotheysmoke,
                                  "languages": state.languagetheyknow ?? [],
                                  "have_kids": state.kids,
                                  "sun_sign": state.sunSign,
                                  "religion": state.religion,
                                  "politic": state.politics,
                                  "pet": state.pets
                                });
                                int count = 0;
                                Navigator.of(context)
                                    .popUntil((_) => count++ >= 2);
                              },
                            ),
                          ),
                          SpaceWidget(
                              height: MediaQuery.of(context).size.height * 0.04),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
