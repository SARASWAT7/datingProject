import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../component/apihelper/common.dart';
import '../../../component/commonfiles/appcolor.dart';
import '../../../component/reuseable_widgets/appBar.dart';
import '../../../component/reuseable_widgets/apploder.dart';
import '../../../component/reuseable_widgets/apptext.dart';
import '../../../component/reuseable_widgets/pinkcontainer.dart';
import '../../../component/reuseable_widgets/pinklistcontainer.dart';
import '../../auth/design/splash.dart';
import '../../match/cubit/getuserbyidcubit.dart';
import '../../match/cubit/getuserbyidstate.dart';

class AllDataView extends StatefulWidget {
  final String id;
  const AllDataView({super.key, required this.id});

  @override
  State<AllDataView> createState() => _AllDataViewState();
}

class _AllDataViewState extends State<AllDataView> {
  late PageController _pageController;
  int activePageIndex = 0;

  @override
  void initState() {
    super.initState();
    getToken();
    Helper.executeWithConnectivityCheck(
      context,
      () async {
        BlocProvider.of<GetUserByIdCubit>(context).UserById(widget.id);
      },
    );
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetUserByIdCubit, GetUserByIdState>(
      builder: (context, state) {
        if (state is GetUserByIdLoading) {
          return Scaffold(
            body: Center(
              child: CupertinoActivityIndicator(
                color: AppColor.activeiconclr,
                radius: 20,
              ),
            ),
          );
        } else if (state is GetUserByIdError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'An error occurred. Please try again later.',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.read<GetUserByIdCubit>().UserById(widget.id); // Retry fetching data
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        } else if (state is GetUserByIdSuccess) {
          double height = MediaQuery.of(context).size.height;
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
              title: "${state.homeResponse.result?.firstName ?? ""} ${state.homeResponse.result?.lastName??""}",
              titleColor: Colors.black,
              backgroundColor: Colors.white,
              centerTitle: true,
            ),
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 70.h,
                      width: MediaQuery.of(context).size.width,
                      child: (state.homeResponse.result?.media?.length ?? 0) > 0 // Ensure this condition returns a bool
                          ? PageView.builder(
                        itemCount: state.homeResponse.result?.media?.length ?? 0,
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
                                  imageUrl: state.homeResponse.result?.media?[index] ?? "",
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
                                  ),                                  errorWidget: (context, url, error) => ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Image.asset(
                                      "assets/images/nn.png",
                                      height: 70.h,
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context).size.width,
                                    ),
                                  ),
                                ),
                                if ((state.homeResponse.result?.media?.length ?? 0) > 1) // Ensure condition returns a bool
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: List.generate(
                                          state.homeResponse.result?.media?.length ?? 0,
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
                    // Basic Information
                    ProfileListCard(
                      showEditIcon: false,
                      title: 'Basic Information',
                      icons: [
                        Image.asset(
                          'assets/images/profile12.png',
                          width: 34,
                          height: 34,
                          color: AppColor.activeiconclr,
                        ),
                        Image.asset('assets/images/education.png', width: 34, height: 34),
                        Image.asset('assets/images/jobs.png', width: 34, height: 34),
                      ],
                      texts: [
                        state.homeResponse.result?.firstName ?? "Name",            "Degree Placeholder",
                        state.homeResponse.result?.degree??"Degree",
                        state.homeResponse.result?.profession??"Profession",
                      ],
                      onEditPressed: () {},
                    ),
                    SizedBox(height: height / 30),
                    // Bio
                    ProfileListCard(
                      showEditIcon: false,
                      title: 'Bio',
                      icons: [
                        Image.asset(
                          'assets/images/profile12.png',
                          width: 34,
                          height: 34,
                          color: AppColor.activeiconclr,
                        ),
                      ],
                      texts: [
                        state.homeResponse.result?.bio??"",
                      ],
                      onEditPressed: () {
                      },
                    ),
                    SizedBox(height: height / 30),
                    // More About Me
                    ProfileInfoCard(
                      showEditIcon: false,
                      title: 'More About Me',
                      items: [
                        ProfileInfoItem(
                          icon: Image.asset('assets/images/relationship.png', width: 34, height: 34),
                          text: state.homeResponse.result?.relationshipStatus ?? "Relation",
                        ),
                        ProfileInfoItem(
                          icon: Image.asset('assets/images/height.png', width: 34, height: 34),
                          text: state.homeResponse.result?.height.toString() ?? "Height",
                        ),
                        ProfileInfoItem(
                          icon: Image.asset('assets/images/sun.png', width: 34, height: 34),
                          text: state.homeResponse.result?.sunSign ??"",
                        ),
                        ProfileInfoItem(
                          icon: Image.asset('assets/images/beer.png', width: 34, height: 34),
                          text: state.homeResponse.result?.drinking ??'Occasional', // Hardcoded value
                        ),
                        ProfileInfoItem(
                          icon: Image.asset('assets/images/child.png', width: 34, height: 34),
                          text: state.homeResponse.result?.haveKids ??"", // Hardcoded value
                        ),
                        ProfileInfoItem(
                          icon: Image.asset('assets/images/govt.png', width: 34, height: 34),
                          text: state.homeResponse.result?.politic ??"", // Hardcoded value
                        ),
                        ProfileInfoItem(
                          icon: Image.asset('assets/images/hamsa.png', width: 34, height: 34),
                          text: state.homeResponse.result?.religion ??"", // Hardcoded value
                        ),
                        ProfileInfoItem(
                          icon: Image.asset('assets/images/language.png', width: 34, height: 34),
                          text:state.homeResponse.result?.languages.toString()??"",
                        ),
                        ProfileInfoItem(
                          icon: Image.asset('assets/images/smoking.png', width: 34, height: 34),
                          text: state.homeResponse.result?.smoking??"Smoking", // Hardcoded value
                        ),
                        ProfileInfoItem(
                          icon: Image.asset('assets/images/pets.png', width: 34, height: 34),
                          text:  state.homeResponse!.result?.pet??"",
                        ),
                      ],
                      onEditPressed: () {
                        // CustomNavigator.push(context: context, screen: MoreAboutMe());
                      },
                    ),
                    SizedBox(height: height / 30),
                    // Quotes
                    ProfileInfoCard(
                      showEditIcon: false,

                      title: 'Quotes',
                      items: [
                        ProfileInfoItem(

                          icon: Image.asset('assets/images/quote.png', width: 34, height: 34),
                          text: state.homeResponse!.result?.quote??"", // Replace with actual data
                        ),
                      ],
                      onEditPressed: () {
                        // CustomNavigator.push(context: context, screen: MoreAboutMe());
                      },
                    ),
                    SizedBox(height: height / 30),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget buildIndicator(bool isSelected) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Container(
        height: isSelected ? 15 : 10,
        width: isSelected ? 15 : 10,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? AppColor.activeiconclr : AppColor.lightGrey,
        ),
      ),
    );
  }
}
