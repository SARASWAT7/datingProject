import 'package:demoproject/component/reuseable_widgets/customNavigator.dart';
import 'package:demoproject/ui/dashboard/profile/moreaboutme/exercise.dart';
import 'package:demoproject/ui/dashboard/profile/moreaboutme/myheight.dart';
import 'package:demoproject/ui/dashboard/profile/moreaboutme/passion.dart';
import 'package:demoproject/ui/dashboard/profile/moreaboutme/pet.dart';
import 'package:demoproject/ui/dashboard/profile/moreaboutme/politices.dart';
import 'package:demoproject/ui/dashboard/profile/moreaboutme/profession.dart';
import 'package:demoproject/ui/dashboard/profile/moreaboutme/religion.dart';
import 'package:demoproject/ui/dashboard/profile/moreaboutme/smoking.dart';
import 'package:demoproject/ui/dashboard/profile/moreaboutme/sunsign.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../component/reuseable_widgets/appbar.dart';
import '../../../../component/reuseable_widgets/apptext.dart';
import '../../../../component/reuseable_widgets/bottomTabBar.dart';
import '../../../../component/reuseable_widgets/customaboutme.dart';
import '../../../../component/reuseable_widgets/reusebottombar.dart';
import '../cubit/profile/profilecubit.dart';
import '../cubit/profile/profilestate.dart';
import 'drinking.dart';
import 'education.dart';
import 'kids.dart';
import 'language.dart';

class MoreAboutMe extends StatefulWidget {
  const MoreAboutMe({super.key});

  @override
  State<MoreAboutMe> createState() => _MoreAboutMeState();
}

class _MoreAboutMeState extends State<MoreAboutMe> {
  @override
  void initState() {
    context.read<ProfileCubit>().getprofile(context);
    super.initState();
  }
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
    builder: (context, state) {
      Map<String, dynamic> userProfile = {
        'height': state.profileResponse?.result?.height,
        'languages': state.profileResponse?.result!.languages,
        'exercise': state.profileResponse?.result?.exercise,
        'degree': state.profileResponse?.result?.degree,
        'profession': state.profileResponse?.result?.profession,
        'drinking': state.profileResponse?.result?.drinking,
        'smoking': state.profileResponse?.result?.smoking,
        'haveKids': state.profileResponse?.result?.haveKids,
        'sunSign': state.profileResponse?.result?.sunSign,
        'religion': state.profileResponse?.result?.religion,
        'politic': state.profileResponse?.result?.politic,
        'pet': state.profileResponse?.result?.pet,
        'passions': state.profileResponse?.result?.passions,
      };
        return WillPopScope(
          onWillPop: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const BottomBar(currentIndex:4)),
            );

            return true;
          },
          child: Scaffold(
            // bottomNavigationBar: BottomSteet(
            //   currentIndex: 4,
            // ),
            appBar: appBarWidgetThree(
              leading: Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const BottomBar(currentIndex:4)),
                            );
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
              title: 'Edit Your Details',
              titleColor: Colors.black,
              backgroundColor: Colors.white,
              centerTitle: true,
              showBorder: true,
            ),
            backgroundColor: Colors.white,
            body: SingleChildScrollView(


              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    AppText(
                      fontWeight: FontWeight.w400,
                      size: 20.0,
                      maxlin: 2,
                      text:
                      'Fill all the details which tells about you more will help you to find your partner.',
                    ),
                    ProfileItem(
                      iconAssetPath: 'assets/images/height.png',
                      title: 'My Height',
                      trailingText: state.profileResponse?.result?.height.toString() ?? "Height",
                      index: 0,
                      selectedIndex: selectedIndex,
                      onTap: (index) {
                        CustomNavigator.push(
                            context: context, screen: MyHeight(height: userProfile['height'].toString()));
                      },
                    ),
                    ProfileItem(
                      iconAssetPath: 'assets/images/language.png',
                      title: 'Languages I know',
                      trailingText:  state.profileResponse?.result?.languages.toString()??"Language",
                      index: 1,
                      selectedIndex: selectedIndex,
                      onTap: (index) {
                        CustomNavigator.push(
                            context: context, screen: Language(language:state.profileResponse!.result!.languages!));
                      },
                    ),
                    ProfileItem(
                      iconAssetPath: 'assets/images/exercise.png',
                      title: 'Exercise',
                      trailingText: state.profileResponse?.result?.exercise ?? "Exercise",
                      index: 2,
                      selectedIndex: selectedIndex,
                      onTap: (index) {
                        CustomNavigator.push(
                          context: context,
                          screen: Exercise(
                            exercise: state.profileResponse?.result?.exercise ?? "",
                          ),
                        );
                      },
                    ),

                    ProfileItem(
                      iconAssetPath: 'assets/images/education.png',
                      title: 'Educational Level',
                      trailingText: state.profileResponse?.result?.degree??"Degree",
                      index: 3,
                      selectedIndex: selectedIndex,
                      onTap: (index) {
                        CustomNavigator.push(
                          context: context, screen: Education(education:state.profileResponse?.result?.degree??""),
                        );
                      },
                    ),
                    ProfileItem(
                      iconAssetPath: 'assets/images/profession.png',
                      title: 'Profession',
                      trailingText: state.profileResponse?.result?.profession ?? "Profession",
                      index: 4,
                      selectedIndex: selectedIndex,
                      onTap: (index) {
                        CustomNavigator.push(
                          context: context,
                          screen: Profession(
                            profession: state.profileResponse?.result?.profession??"",
                          ),
                        );
                      },
                    ),

                    ProfileItem(
                      iconAssetPath: 'assets/images/drink.png',
                      title: 'Drinking',
                      trailingText: state.profileResponse?.result?.drinking ?? "Drinking",
                      index: 5,
                      selectedIndex: selectedIndex,
                      onTap: (index) {
                        CustomNavigator.push(
                          context: context,
                          screen: Drinking(
                            drinking: state.profileResponse?.result?.drinking ?? "",
                          ),
                        );
                      },
                    ),

                    ProfileItem(
                      iconAssetPath: 'assets/images/smoking.png',
                      title: 'Smoking',
                      trailingText: state.profileResponse?.result?.smoking ?? "Smoking",
                      index: 6,
                      selectedIndex: selectedIndex,
                      onTap: (index) {
                        CustomNavigator.push(
                          context: context,
                          screen: Smokeing(
                            smoking: state.profileResponse?.result?.smoking ?? "",
                          ),
                        );
                      },
                    ),

                    ProfileItem(
                      iconAssetPath: 'assets/images/kids.png',
                      title: 'Kids',
                      trailingText: state.profileResponse?.result?.haveKids ?? "Kids",
                      index: 7,
                      selectedIndex: selectedIndex,
                      onTap: (index) {
                        CustomNavigator.push(
                          context: context,
                          screen: Kids(
                            haveKids: state.profileResponse?.result?.haveKids ?? "",
                          ),
                        );
                      },
                    ),

                    ProfileItem(
                      iconAssetPath: 'assets/images/sun.png',
                      title: 'Sun sign',
                      trailingText:  state.profileResponse?.result?.sunSign??"sunsign",
                      index: 8,
                      selectedIndex: selectedIndex,
                      onTap: (index) {
                        CustomNavigator.push(
                          context: context, screen: Sunsign(sunSign:state.profileResponse?.result?.sunSign??""),);
                      },
                    ),
                    ProfileItem(
                      iconAssetPath: 'assets/images/cross.png',
                      title: 'Religion',
                      trailingText:  state.profileResponse?.result?.religion??"Relegion",
                      index: 9,
                      selectedIndex: selectedIndex,
                      onTap: (index) {
                        CustomNavigator.push(
                          context: context, screen: Religion(religion:state.profileResponse?.result?.religion??""),);
                      },
                    ),
                    ProfileItem(
                      iconAssetPath: 'assets/images/scale.png',
                      title: 'Politics',
                      trailingText:  state.profileResponse?.result?.politic??"Politics",
                      index: 10,
                      selectedIndex: selectedIndex,
                      onTap: (index) {
                        CustomNavigator.push(
                          context: context, screen: Politices(selectedPolitic:state.profileResponse?.result?.politic??"Politics"),);
                      },
                    ),
                    ProfileItem(
                      iconAssetPath: 'assets/images/pets.png',
                      title: 'Pets',
                      trailingText:  state.profileResponse?.result?.pet??"Pets",
                      index: 11,
                      selectedIndex: selectedIndex,
                      onTap: (index) {
                        CustomNavigator.push(context: context, screen: Pet(selectedPet: state.profileResponse?.result?.pet??"Pets",),);
                      },
                    ),
                    ProfileItem(
                      iconAssetPath: 'assets/images/skating.png',
                      title: 'Passion',
                      trailingText: state.profileResponse?.result?.passions.toString()??"passion",
                      index: 12,
                      selectedIndex: selectedIndex,
                      onTap: (index) {
                        CustomNavigator.push(
                          context: context, screen: Passion(selectedPassions: state.profileResponse!.result!.passions!),);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

