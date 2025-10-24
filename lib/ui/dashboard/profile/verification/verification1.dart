import 'dart:io';
import 'package:demoproject/component/reuseable_widgets/apploder.dart';
import 'package:demoproject/component/reuseable_widgets/customNavigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../component/apihelper/common.dart';
import '../cubit/updateData/updateprofilecubit.dart';
import '../../../../component/commonfiles/appcolor.dart';
import '../../../../component/reuseable_widgets/custom_button.dart';
import '../cubit/updateData/updateprofilestate.dart';
import '../design/editProfile.dart';

class ProfileVerificationPage extends StatefulWidget {
  const ProfileVerificationPage({super.key});

  @override
  _ProfileVerificationPageState createState() => _ProfileVerificationPageState();
}

class _ProfileVerificationPageState extends State<ProfileVerificationPage> {
  File? _image;

  Future<void> _showImagePickerDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Please take a Selfie.'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // TextButton(
              //   child:Text('Gallery',
              //       style: TextStyle(
              //           color: AppColor.tinderclr
              //       )
              //   ),
              //   onPressed: () {
              //     _pickImage(ImageSource.gallery);
              //     Navigator.pop(context);
              //   },
              // ),
              TextButton(
                child:Text(        '               Camera',style: TextStyle(fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColor.tinderclr
                )

                ),
                onPressed: () {
                  _pickImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _image = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to pick image. Please try again.")),
      );
    }
  }

  void _verifyProfile(BuildContext context) {
    if (_image != null) {
      context.read<UpdateProfileCubit>().profileVerify(context, _image!.path);
      AppLoader();
    } else {
     AlertDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: true,
      ),
      body: BlocBuilder<UpdateProfileCubit, UpdateProfileState>(
        builder: (context, state) {
          if (state.status == ApiState.isLoading) {
            return  Center(
              child: AppLoader()
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => _showImagePickerDialog(context),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.tinderclr.withOpacity(0.4),
                            spreadRadius: 3,
                            blurRadius: 10,
                            offset: const Offset(0, 18),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: _image != null
                            ? Image.file(
                          _image!,
                          height: 300,
                          width: 225,
                          fit: BoxFit.cover,
                        )
                            : Image.asset(
                          'assets/images/user12.png',
                          height: 300,
                          width: 225,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 29),
                Text(
                    'Wave your hand and click a random ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                  Text(
                    'live picture to verify your profile.',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                SizedBox(height: 15),
               Text(
                    'Get Your Profile Verified Now!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: AppColor.tinderclr),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: CustomButton(
                      text: 'Verify',
                      onPressed: () => _verifyProfile(context),
                    ),
                  ),
                  const SizedBox(height: 18),
                  GestureDetector(
                    onTap: () {
                   CustomNavigator.push(context:context , screen: EditProfile())   ;                 },
                    child: const Text(
                      'Skip',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
