
import 'package:cached_network_image/cached_network_image.dart';
import 'package:demoproject/component/alert_box.dart';
import 'package:demoproject/component/commonfiles/appcolor.dart';
import 'package:demoproject/component/reuseable_widgets/apptext.dart';
import 'package:demoproject/component/reuseable_widgets/customNavigator.dart';
import 'package:demoproject/component/reuseable_widgets/pinklistcontainer.dart';
import 'package:demoproject/ui/dashboard/profile/design/quotes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../../component/reuseable_widgets/appBar.dart';
import '../../../../component/reuseable_widgets/apploder.dart';
import '../../../../component/reuseable_widgets/custom_button.dart';
import '../../../../component/reuseable_widgets/pinkcontainer.dart';
import '../../../quesition/remaningQuestions.dart';
import '../cubit/profile/profilecubit.dart';
import '../cubit/profile/profilestate.dart';
import '../moreaboutme/moreAboutMe.dart';
import 'bio.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  int currentIndex = 0;
  late PageController _pageController;
  int activePageIndex = 0;
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        double height = MediaQuery.of(context).size.height;
        return
          Scaffold(
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
            title: 'My Profile',
            titleColor: Colors.black,
            backgroundColor: Colors.white,
            centerTitle: true,
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 70.h,
                    width: MediaQuery.of(context).size.width,
                    child: (state.profileResponse?.result?.media?.length ?? 0) > 0 // Ensure this condition returns a bool
                        ? PageView.builder(
                      itemCount: state.profileResponse?.result?.media?.length ?? 0,
                      controller: _pageController,
                      physics: const ClampingScrollPhysics(),
                      onPageChanged: (int i) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        setState(() {
                          activePageIndex = i;
                        });
                      },
                      itemBuilder: (BuildContext context, index) {
                        return Container(
                          height: 70.h,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Stack(
                            children: [
                              CachedNetworkImage(
                                imageUrl: state.profileResponse?.result?.media?[index] ?? "",
                                height: 70.h,
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width,
                                imageBuilder: (context, imageProvider) => Container(
                                  height: 70.h,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) =>  Center(
                                  child: AppLoader(),
                                ),
                                errorWidget: (context, url, error) => ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Image.asset(
                                    "assets/images/nn.png",
                                    height: 70.h,
                                    fit: BoxFit.cover,
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                ),
                              ),
                              if ((state.profileResponse?.result?.media?.length ?? 0) > 1) // Ensure condition returns a bool
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: List.generate(
                                        state.profileResponse?.result?.media?.length ?? 0,
                                            (i) => buildIndicator(i == activePageIndex),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    )
                        : Center(
                      child: AppText(
                        fontWeight: FontWeight.w600,
                        size: 14.sp,
                        color: Colors.black,
                        text: 'No media available', // Fallback message when no media
                      ),
                    ),
                  ),

                  3.h.heightBox,
////////////////// Basic Information////////////////////////////////
                  ProfileListCard(
                    title: 'Basic Information',
                    icons: [
                      Image.asset(
                        'assets/images/profile12.png',
                        width: 34,
                        height: 34,
                        color: AppColor.activeiconclr,
                      ),
                      Image.asset('assets/images/education.png',
                          width: 34, height: 34),
                      Image.asset('assets/images/jobs.png', width: 34, height: 34),
                    ],
                    texts: [
                      '${state.profileResponse?.result?.firstName} ${state.profileResponse?.result?.lastName}',
                      state.profileResponse?.result?.degree??"Degree",
                      state.profileResponse?.result?.profession??"Profession",
                    ],
                    onEditPressed: () {
                      CustomNavigator.push(context: context, screen: MoreAboutMe());
                    },
                  ),
                  SizedBox(height: height / 30),

                  /////////////////////// Bio/////////////////////////////
                  ProfileListCard(
                    title: 'Bio',
                    icons: [
                      Image.asset(
                        'assets/images/profile12.png',
                        width: 34,
                        height: 34,
                        color: AppColor.activeiconclr,
                      ),

                    ],
                    texts:  [
                      state.profileResponse?.result?.bio??"",
                    ],
                    onEditPressed: () {
                      CustomNavigator.push(context: context, screen: Bio());
                    },
                  ),
                  SizedBox(height: height / 30),

///////// More About Me///////////////////

                ProfileInfoCard(
                  title: "More About Me",
                  items: [
                    ProfileInfoItem(
                      icon: Image.asset('assets/images/relationship.png', width: 34, height: 34),
                      text: state.profileResponse?.result?.relationshipStatus ?? "Relation",
                    ),
                    ProfileInfoItem(
                      icon: Image.asset('assets/images/height.png', width: 34, height: 34),
                      text: state.profileResponse?.result?.height.toString() ?? "Height",
                    ),
                    ProfileInfoItem(
                      icon: Image.asset('assets/images/sun.png', width: 34, height: 34),
                      text: state.profileResponse?.result?.sunSign ??"",
                    ),
                    ProfileInfoItem(
                      icon: Image.asset('assets/images/beer.png', width: 34, height: 34),
                      text: state.profileResponse?.result?.drinking ??'Occasional', // Hardcoded value
                    ),
                    ProfileInfoItem(
                      icon: Image.asset('assets/images/child.png', width: 34, height: 34),
                      text: state.profileResponse?.result?.haveKids ??"", // Hardcoded value
                    ),
                    ProfileInfoItem(
                      icon: Image.asset('assets/images/govt.png', width: 34, height: 34),
                      text: state.profileResponse?.result?.politic ??"", // Hardcoded value
                    ),
                    ProfileInfoItem(
                      icon: Image.asset('assets/images/hamsa.png', width: 34, height: 34),
                      text: state.profileResponse?.result?.religion ??"", // Hardcoded value
                    ),
                    ProfileInfoItem(
                      icon: Image.asset('assets/images/language.png', width: 34, height: 34),
                      text:state.profileResponse?.result?.languages.toString()??"",
                    ),
                    ProfileInfoItem(
                      icon: Image.asset('assets/images/smoking.png', width: 34, height: 34),
                      text: state.profileResponse?.result?.smoking??"Smoking", // Hardcoded value
                    ),
                    ProfileInfoItem(
                      icon: Image.asset('assets/images/pets.png', width: 34, height: 34),
                      text: state.profileResponse?.result?.pet??"Pets", // Hardcoded value
                    ),
                  ],
                  onEditPressed: () {
                    CustomNavigator.push(context: context, screen: MoreAboutMe());
                  },
                ),

                SizedBox(height: height / 30),
                  ProfileInfoCard(
                    title: 'Quotes',
                    items: [
                      ProfileInfoItem(
                        icon: Image.asset('assets/images/quote.png', width: 34, height: 34),
                        text: state.profileResponse?.result?.quote?? "Quotes""Quotes",
                      ),
                    ],
                    onEditPressed: () {
                      CustomNavigator.push(context: context, screen: Quotes());

                    },
                  ),
                  SizedBox(height: height / 30),
                  ProfileInfoCard(
                    title: 'Questions',
                    items: [
                      ProfileInfoItem(
                        icon: Image.asset('assets/images/quote.png', width: 34, height: 34),
                        text: "Please Fill Unanswerd Questions",
                        maxLines: 1,
                      ),
                    ],
                    onEditPressed: () {
                      CustomNavigator.push(context: context, screen: RemaningQues());
                    },
                  ),
                  SizedBox(height: height / 30),

                ],
              ),
            ),
          ),
        );

      },
    );
  }

  Widget buildIndicator(bool isSelected) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Container(
        height: isSelected ? 15 : 20,
        width: isSelected ? 15 : 10,
        decoration: BoxDecoration(
            shape: isSelected ? BoxShape.circle : BoxShape.circle,
            color: isSelected ? AppColor.activeiconclr : AppColor.lightGrey,
            borderRadius: isSelected ? null : null),
      ),
    );
  }
}
