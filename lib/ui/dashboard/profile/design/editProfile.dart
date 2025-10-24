import 'dart:developer';
import 'dart:io';
import 'dart:ui' as BorderType;
import 'package:demoproject/component/reuseable_widgets/container.dart';
import 'package:demoproject/component/reuseable_widgets/customNavigator.dart';
import 'package:demoproject/component/reuseable_widgets/custom_button.dart';
import 'package:demoproject/component/reuseable_widgets/reusebottombar.dart';
import 'package:demoproject/ui/dashboard/profile/cubit/profile/profilecubit.dart';
import 'package:demoproject/ui/dashboard/profile/cubit/profile/profilestate.dart';
import 'package:demoproject/ui/dashboard/profile/design/quotes.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dotted_border/dotted_border.dart' as db;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../../../component/apihelper/common.dart';
import '../../../../component/reuseable_widgets/appbar.dart';
import '../../../../component/reuseable_widgets/apperror.dart';
import '../../../../component/reuseable_widgets/apploder.dart';
import '../../../../component/reuseable_widgets/apptext.dart';
import '../../../../component/reuseable_widgets/profilecircle.dart';
import '../../../../component/reuseable_widgets/text_field.dart';
import '../../../auth/design/splash.dart';
import '../cubit/updateData/updateprofilecubit.dart';
import '../verification/verification1.dart';
import 'bio.dart';
import 'package:dotted_border/dotted_border.dart' as db;

class EditProfile extends StatefulWidget {
  final String? imagePath;

  const EditProfile({Key? key, this.imagePath}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final ImagePicker _picker = ImagePicker();
  List<File> imgFiles = [];
  String? _imagePath;
  bool Loadingqwe = false;

  @override
  void initState() {
    super.initState();
    _imagePath = widget.imagePath;
    context.read<ProfileCubit>().getprofile(context);
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imagePath = image.path;
      });
      print('hello $image');
      context.read<UpdateProfileCubit>().updateProfileImage(
        context,
        image.path,
      );
    }
  }

  getdata() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var data = pref.getString("token");
    setState(() {
      token = data.toString();
    });
    log("$data");
  }

  Future<void> saveProfileData(
    String id,
    String profilePicture,
    String name,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', id);
    await prefs.setString('profilePicture', profilePicture);
    await prefs.setString('userName', name);
    print("--------->data ID: $id, Username: $name, Image: $profilePicture");
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state.status == ApiState.success) {
          String id = state.profileResponse?.result?.id ?? '';
          String profilePicture =
              state.profileResponse?.result?.profilePicture ?? '';
          String name =
              "${state.profileResponse?.result?.firstName} ${state.profileResponse?.result?.lastName}";
          saveProfileData(id, profilePicture, name);
        }

        return Scaffold(
          backgroundColor: Colors.white,
          // bottomNavigationBar: const BottomSteet(
          //   currentIndex: 4,
          // ),
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
            title: 'My Profile',
            titleColor: Colors.black,
            backgroundColor: Colors.white,
            centerTitle: true,
            ///////////////vediopages////////////////

            // actions: [
            //   Padding(
            //     padding: const EdgeInsets.only(right: 16.0),
            //     child: GestureDetector(
            //       onTap: (){
            //         CustomNavigator.push(context: context, screen: FilePicker());
            //       },
            //       child: Center(
            //         child: Image.asset(
            //           'assets/images/plus.png',
            //           width: 30.0,
            //           height: 30.0, // Adjust the width of the image as needed
            //         ),
            //       ),
            //     ),
            //   ),
            // ],
          ),
          body: state.status == ApiState.isLoading
              ? AppLoader()
              : state.status == ApiState.error
              ? AppErrorError(
                  onPressed: () {
                    context.read<ProfileCubit>().getprofile(context);
                  },
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 18),
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Row(
                          children: [
                            Stack(
                              alignment: Alignment.bottomLeft,
                              children: [
                                CircleProfile(
                                  imagePath:
                                      _imagePath ??
                                      state
                                          .profileResponse
                                          ?.result
                                          ?.profilePicture ??
                                      "",
                                ),
                                Positioned(
                                  right: 0,
                                  top: 50,
                                  bottom: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black,
                                    ),
                                    padding: EdgeInsets.all(4.0),
                                    child:
                                        state
                                                .profileResponse
                                                ?.result
                                                ?.profileVerified
                                                ?.toLowerCase() ==
                                            "yes"
                                        ? Image.asset(
                                            'assets/images/verified.png',
                                            height: 30.0,
                                            width: 30.0,
                                          )
                                        : Icon(
                                            Icons.shield,
                                            color: Colors.white,
                                            size: 30.0,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 18.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: _pickImage,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8.0,
                                      horizontal: 12.0,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Colors.redAccent, Colors.pink],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                      borderRadius: BorderRadius.circular(11.0),
                                    ),
                                    child: const Text(
                                      'Edit Photo',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12.0),
                                Text(
                                  state.profileResponse?.result?.profileVerified
                                              ?.toLowerCase() ==
                                          "yes"
                                      ? "Profile Verified"
                                      : "Verification Pending",
                                  style: TextStyle(
                                    color:
                                        state
                                                .profileResponse
                                                ?.result
                                                ?.profileVerified
                                                ?.toLowerCase() ==
                                            "yes"
                                        ? Colors
                                              .black // Change color for verified state
                                        : Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      AbsorbPointer(
                        child: TextFieldWidget(
                          title: '',
                          // enable: false,.
                          controller: TextEditingController(
                            text:
                                "${state.profileResponse?.result?.firstName} ${state.profileResponse?.result?.lastName}",
                          ),
                          textFieldBorderColor: Colors.grey,
                          textInputType: TextInputType.text,
                          hint: 'First Name',
                          hintColor: Colors.black,
                          textFieldTitleColor: Colors.black,
                          prefixIcon: Transform.scale(
                            scale: 0.6,
                            child: Image.asset(
                              'assets/images/carbon_user.png',
                              height: 20,
                              width: 20,
                            ),
                          ),
                          // Icon on the left side
                          suffixIcon: Transform.scale(
                            scale: 0.6,
                            child: Image.asset(
                              'assets/images/check.png',
                              height: 20,
                              width: 20,
                            ),
                          ), // Icon on the right side
                        ),
                      ),
                      SpaceWidget(height: 10),
                      AbsorbPointer(
                        child: TextFieldWidget(
                          title: '',
                          controller: TextEditingController(
                            text:
                                (state.profileResponse != null &&
                                    state.profileResponse!.result != null &&
                                    state.profileResponse!.result!.email !=
                                        null &&
                                    state
                                        .profileResponse!
                                        .result!
                                        .email!
                                        .isNotEmpty)
                                ? "${state.profileResponse!.result!.email}"
                                : (state.profileResponse != null &&
                                      state.profileResponse!.result != null &&
                                      state.profileResponse!.result!.phone !=
                                          null &&
                                      state
                                          .profileResponse!
                                          .result!
                                          .phone!
                                          .isNotEmpty)
                                ? "${state.profileResponse!.result!.isd ?? ''} ${state.profileResponse!.result!.phone}"
                                : "",
                          ),

                          textFieldBorderColor: Colors.grey,
                          textInputType: TextInputType.text,
                          hint: 'Mobile No',
                          hintColor: Colors.black,
                          textFieldTitleColor: Colors.black,
                          prefixIcon: Transform.scale(
                            scale: 0.6,
                            child: Image.asset(
                              'assets/images/check.png',
                              height: 20,
                              width: 20,
                            ),
                          ),
                          // Icon on the left side
                          suffixIcon: Transform.scale(
                            scale: 0.6,
                            child: Image.asset(
                              'assets/images/check.png',
                              height: 20,
                              width: 20,
                            ),
                          ),
                        ),
                      ),
                      SpaceWidget(height: 10),

                      AbsorbPointer(
                        child: TextFieldWidget(
                          title: '',
                          controller: TextEditingController(
                            text: state.profileResponse?.result?.dob ?? "",
                          ),
                          textFieldBorderColor: Colors.grey,
                          textInputType: TextInputType.text,
                          hint: 'D.O.B',
                          hintColor: Colors.black,
                          textFieldTitleColor: Colors.black,
                          prefixIcon: Transform.scale(
                            scale: 0.6,
                            child: Image.asset(
                              'assets/images/cake.png',
                              height: 20,
                              width: 20,
                            ),
                          ),
                          // Icon on the left side
                          suffixIcon: Transform.scale(
                            scale: 0.6,
                            child: Image.asset(
                              'assets/images/date.png',
                              height: 20,
                              width: 20,
                            ),
                          ), // Icon on the right side
                        ),
                      ),
                      SpaceWidget(height: 10),
                      AbsorbPointer(
                        child: TextFieldWidget(
                          title: '',
                          controller: TextEditingController(
                            text: state.profileResponse?.result?.gender ?? "",
                          ),
                          textFieldBorderColor: Colors.grey,
                          textInputType: TextInputType.text,
                          hint: 'Gender',
                          hintColor: Colors.black,
                          textFieldTitleColor: Colors.black,
                          prefixIcon: Transform.scale(
                            scale: 0.6,
                            child: Image.asset(
                              'assets/images/gender.png',
                              height: 20,
                              width: 20,
                            ),
                          ), // Icon on the left side
                          // Icon on the right side
                        ),
                      ),
                      SpaceWidget(height: 10),
                      AppContainer(
                        height: MediaQuery.of(context).size.height * 0.10,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return _showAlertDialog(context);
                                  },
                                );
                              },
                              child: DottedBorder(
                                options: RectDottedBorderOptions(
                                  color: Colors.pink,
                                  strokeWidth: 2,
                                  dashPattern: [6, 3],
                                ),
                                child: Container(
                                  width: 65,
                                  height:
                                      MediaQuery.of(context).size.height * 0.10,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Center(
                                    child: Image.asset(
                                      'assets/images/plus.png',
                                      width: 30,
                                      height: 30,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 18),
                            const Expanded(
                              child: Text(
                                'Upload Photos',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SpaceWidget(height: 10),
                      const CustomButton(text: 'Submit Details'),
                      SpaceWidget(height: 18),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Bio()),
                          );
                        },
                        child: AppContainer(
                          height: MediaQuery.of(context).size.height * 0.060,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: [
                              AppText(
                                fontWeight: FontWeight.w400,
                                size: 14.sp,
                                text: 'Bio',
                              ),
                              const Spacer(),
                              Image.asset(
                                'assets/images/bio.png',
                                width: 34,
                                height: 34,
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Quotes()),
                          );
                        },
                        child: AppContainer(
                          height: MediaQuery.of(context).size.height * 0.060,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: [
                              AppText(
                                fontWeight: FontWeight.w400,
                                size: 14.sp,
                                text: 'Quote',
                              ),
                              Spacer(),
                              Image.asset(
                                'assets/images/quote.png',
                                width: 34,
                                height: 34,
                              ),
                            ],
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

  Widget _showAlertDialog(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        insetPadding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 24.0,
        ),
        elevation: 0.0,
        content: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 20.0, bottom: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Column(
                children: [
                  // InkWell(
                  //   onTap: () {
                  //     _getFromCamera(context);
                  //     Navigator.pop(context);
                  //   },
                  //   child: SizedBox(
                  //     width: 100.w, // Requires ScreenUtil initialization
                  //     child: Padding(
                  //       padding: EdgeInsets.only(
                  //           bottom: 2.w), // Requires ScreenUtil initialization
                  //       child: Center(
                  //         child: Text(
                  //           "Capture photo",
                  //           style: TextStyle(
                  //             fontSize:
                  //                 4.w, // Requires ScreenUtil initialization
                  //             color: Colors.black,
                  //             fontWeight: FontWeight.w500,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // const Divider(color: Colors.grey),
                  InkWell(
                    onTap: () {
                      _getFromGallery(context);
                      Navigator.pop(context);
                    },
                    child: SizedBox(
                      width: 100.w, // Requires ScreenUtil initialization
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 2.w,
                          bottom: 2.w,
                        ), // Requires ScreenUtil initialization
                        child: Center(
                          child: Text(
                            "Upload From Gallery",
                            style: TextStyle(
                              fontSize:
                                  4.w, // Requires ScreenUtil initialization
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getFromGallery(BuildContext) async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage(
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFiles != null) {
      setState(() {
        imgFiles.addAll(pickedFiles.map((file) => File(file.path)).toList());
      });

      for (var file in pickedFiles) {
        AppLoader();
        context.read<UpdateProfileCubit>().media(context, file.path);
      }
    }
  }

  // Future<void> _getFromCamera(BuildContext context) async {
  //   final XFile? pickedFile = await _picker.pickImage(
  //     source: ImageSource.camera,
  //     maxWidth: 1800,
  //     maxHeight: 1800,
  //   );
  //   if (pickedFile != null) {
  //     setState(() {
  //       imgFiles.add(File(pickedFile.path));
  //     });
  //     AppLoader();
  //     context.read<UpdateProfileCubit>().media(context, pickedFile.path);
  //   }
  // }
}
