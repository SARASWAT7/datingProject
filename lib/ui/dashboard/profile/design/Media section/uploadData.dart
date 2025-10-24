import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../../component/reuseable_widgets/appBar.dart';
import '../../../../../component/reuseable_widgets/reusebottombar.dart';
import '../myvideo.dart';

class FilePicker extends StatefulWidget {
  const FilePicker({super.key});

  @override
  State<FilePicker> createState() => _FilePickerState();
}

class _FilePickerState extends State<FilePicker> {
  String? _filePath;
  late double height;
  late double width;
  final ImagePicker _picker = ImagePicker();
  _getFromGallery() async {
    try {
      final List<XFile>? pickedFile =
      await _picker.pickMultiImage(imageQuality: 40);

      if (pickedFile != null) {
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return FilesGridView(
            filePaths: pickedFile,
          );
        }));
      }
    } catch (e) {
      print(e);
    }
  }

  _getFromGalleryVideo() async {
    final XFile? pickedFile =
    await _picker.pickVideo(source: ImageSource.gallery);
    // if (pickedFile != null) {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => FilesGridView(
    //         filePaths: pickedFile,
    //       ),
    //     ),
    //   );
    // }
  }

  showAlertDialog(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          insetPadding:
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          elevation: 0.0,
          // title: Center(child: Text("Evaluation our APP")),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                //   width:650,
                width: double.infinity,
                padding: const EdgeInsets.all(8.0),
                decoration: const BoxDecoration(
                    color: Color(0xffE7E7E7),
                    borderRadius: BorderRadius.all(Radius.circular(16.0))),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        _getFromGalleryVideo();
                        Navigator.pop(context);
                      },
                      child: const SizedBox(
                        width: 650,
                        child: Padding(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          child: Center(
                              child: Text(
                                "Pick Video",
                                style: TextStyle(
                                    fontSize: 18, color:Colors.black),
                              )),
                        ),
                      ),
                    ),
                    const Divider(),
                    InkWell(
                      onTap: () async {
                        _getFromGallery();
                        Navigator.pop(context);
                      },
                      child: const SizedBox(
                        width: 650,
                        child: Padding(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          child: Center(
                              child: Text(
                                "Select Picture",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                    fontSize:18, color: Colors.black),
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              InkWell(
                onTap: () => {Navigator.pop(context)},
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                      color: Color(0xffE7E7E7),
                      borderRadius: BorderRadius.all(Radius.circular(65.0))),
                  child: const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        child: Text(
                          "Cancel",
                          style: TextStyle(fontSize: 18, color:Colors.black),
                        ),
                      )),
                ),
              )
            ],
          )),
    );
  }


  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    final double topPadding = MediaQuery.of(context).size.height * 0.14;
    final double leftPadding = MediaQuery.of(context).size.width * 0.08;

    return Scaffold(
      bottomNavigationBar: const BottomSteet(
        currentIndex: 4,
      ),
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
        title: 'Upload Files',
        titleColor: Colors.black,
        backgroundColor: Colors.white,
        centerTitle: true,
        showBorder: true,

      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(top: topPadding, left: leftPadding),
        child: Container(

          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(20),
          //   color: Colors.white,
          //   boxShadow: [
          //     BoxShadow(
          //       color: Colors.redAccent.withOpacity(0.4),
          //       spreadRadius: 1,
          //       blurRadius: 18,
          //       offset: Offset(5, 5), // Shadow position
          //     ),
          //   ],
          // ),
          // height: height / 2.5,
          // width: width / 1.2,
          // child: Column(
          //   children: [
          //     Container(
          //       height: height / 3,
          //       width: width / 1.2,
          //       child: Padding(
          //         padding: const EdgeInsets.only(left: 20,right: 20),
          //         child: DottedBorder(
          //           dashPattern: [5, 5],
          //           strokeWidth:1,
          //           radius: Radius.circular(20),
          //           borderType: BorderType.RRect,
          //           color: Colors.black,
          //           child: ClipRRect(
          //             borderRadius: BorderRadius.all(Radius.circular(20)),
          //             child: Column(
          //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //               crossAxisAlignment: CrossAxisAlignment.center,
          //               children: [
          //                 Image.asset(
          //                   'assets/images/file.png',
          //                   width: 62.5,
          //                   height: 50,
          //                 ),
          //                 Text(
          //                   'Upload Photos And Videos',
          //                   style: TextStyle(fontSize: 20),
          //                 ),
          //                 Row(
          //                   mainAxisAlignment: MainAxisAlignment.center,
          //                   children: [
          //                     Expanded(
          //                       child: Divider(
          //                         indent: 30,
          //                         endIndent: 10,
          //                       ),
          //                     ),
          //                     Text('Or'),
          //                     Expanded(
          //                         child: Divider(
          //                           indent: 10,
          //                           endIndent: 30,
          //                         ))
          //                   ],
          //                 ),
          //                 GestureDetector(
          //                   onTap: () {
          //                     showDialog(
          //                         context: context,
          //                         builder: (_) => showAlertDialog(context));
          //                   },
          //                   child: Image.asset(
          //                     "assets/images/brows.png",
          //                     width: 120,
          //                   ),
          //                 ),
          //                 SizedBox(height: 20),
          //                 if (_filePath != null)
          //                   Text('Selected File: $_filePath'),
          //               ],
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //
          //   ],
          // ).pOnly(top: 3.h),
        ),
      ),
    );
  }
}
