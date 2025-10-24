import 'dart:io';
import 'package:demoproject/component/apihelper/common.dart';
import 'package:demoproject/component/reuseable_widgets/apploder.dart';
import 'package:demoproject/component/utils/custom_text.dart';
import 'package:demoproject/ui/auth/cubit/uploadimage/addphotocubit.dart';
import 'package:demoproject/ui/auth/cubit/uploadimage/addphotostate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../component/reuseable_widgets/custom_button.dart';
import '../../component/utils/alertbox.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({Key? key}) : super(key: key);

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  List<File> imgFiles = [];
  final ImagePicker _picker = ImagePicker();
  var networkImage = "";
  getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getBool("firstName"));
  }

  @override
  void initState() {
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddPhotoCubit(),
      child: BlocBuilder<AddPhotoCubit, AddPhotoState>(
        builder: (context, state) {
          return Stack(
            children: [
              Scaffold(
                backgroundColor: Colors.white,
                body: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 60),
                      Center(
                        child: CustomText(
                          size: 20,
                          text: 'Upload Image',
                          color: const Color(0xff000000),
                          weight: FontWeight.w600,
                          fontFamily: 'Nunito Sans',
                        ),
                      ),
                      const SizedBox(height: 14),
                      Image.asset('assets/images/progress.png'),
                      const SizedBox(height: 15),
                      CustomText(
                        size: 18,
                        text: 'Upload Minimum 6 Images',
                        color: const Color(0xff555555),
                        weight: FontWeight.w600,
                        fontFamily: 'Nunito Sans',
                      ),
                      const SizedBox(height: 30),
                      _buildAddImageButton(),
                      const SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.w, top: 10.w),
                        child: GestureDetector(
                          onTap: () {
                            if (imgFiles.length < 6) {
                              showDialog(
                                context: context,
                                builder: (_) => AlertBox(
                                  title: 'Plese Select Minimum 6 Photos',
                                ),
                              );
                            } else {
                              print("------------------->>>");
                              print(imgFiles.map((e) => e.path).toList());
                              ;
                              context.read<AddPhotoCubit>().addphoto(
                                context,
                                imgFiles.map((e) => e.path).toList(),
                              );
                            }
                          },
                          child: const CustomButton(text: 'Upload Image'),
                        ),
                      ),
                      if (imgFiles.isNotEmpty) _buildBottomImages(),
                    ],
                  ),
                ),
              ),
              state.currentState == ApiState.isLoading
                  ? AppLoader()
                  : Container(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAddImageButton() {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return _showAlertDialog(context);
          },
        );
      },
      child: Container(
        child: Center(
          child: Image.asset(
            'assets/images/uploadimg.png',
            width: 152,
            height: 202,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomImages() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 20.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imgFiles.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                width: 30.w,
                height: 20.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: FileImage(imgFiles[index]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                right: 5,
                top: 5,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      imgFiles.removeAt(index);
                    });
                  },
                  child: Icon(Icons.cancel, color: Colors.black, size: 30),
                ),
              ),
            ],
          );
        },
      ),
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
                  InkWell(
                    onTap: () {
                      _getFromCamera();
                      Navigator.pop(context);
                    },
                    child: SizedBox(
                      width: 100.w,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 2.w),
                        child: Center(
                          child: Text(
                            "Capture photo",
                            style: TextStyle(
                              fontSize: 4.w,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Divider(color: Colors.grey),
                  InkWell(
                    onTap: () {
                      _getFromGallery();
                      Navigator.pop(context);
                    },
                    child: SizedBox(
                      width: 100.w,
                      child: Padding(
                        padding: EdgeInsets.only(top: 2.w, bottom: 2.w),
                        child: Center(
                          child: Text(
                            "Upload From Gallery",
                            style: TextStyle(
                              fontSize: 4.w,
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

  Future<void> _getFromGallery() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage(
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFiles != null) {
      setState(() {
        imgFiles.addAll(pickedFiles.map((file) => File(file.path)).toList());
      });
      _validateImageCount();
    }
  }

  Future<void> _getFromCamera() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imgFiles.add(File(pickedFile.path));
      });
      _validateImageCount();
    }
  }

  void _validateImageCount() {
    if (imgFiles.length < 6) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Please select at least 6 photos.'),
      //   ),
      // );
    }
  }
}
