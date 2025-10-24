import 'dart:async';
import 'dart:io';
import 'package:demoproject/component/reuseable_widgets/apploder.dart';
import 'package:demoproject/component/utils/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../component/reuseable_widgets/appBar.dart';
import '../../component/reuseable_widgets/custom_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../dashboard/profile/cubit/updateData/updateprofilecubit.dart';
import 'myreelprofile.dart';

class UploadPostPage extends StatefulWidget {
  final String imagePath;

  const UploadPostPage({Key? key, required this.imagePath}) : super(key: key);

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {
  late VideoPlayerController _videoController;
  bool _isVideoInitialized = false;
  bool _isPlayPauseButtonVisible = true;
  Timer? _hideButtonTimer;
  final TextEditingController _captionController = TextEditingController();
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    if (_isSupportedVideoFormat(widget.imagePath)) {
      _initializeVideoController(widget.imagePath);
    } else {
      print("Invalid file type. Expected a supported video format.");
    }
  }

  bool _isSupportedVideoFormat(String path) {
    const supportedFormats = ['.mp4', '.mov', '.avi', '.mkv', '.flv'];
    return supportedFormats.any((format) => path.toLowerCase().endsWith(format));
  }

  Future<void> _initializeVideoController(String path) async {
    try {
      _videoController = VideoPlayerController.file(File(path))
        ..addListener(() {
          if (_videoController.value.hasError) {
            print("VideoPlayer Error: ${_videoController.value.errorDescription}");
          }
        })
        ..initialize().then((_) {
          setState(() {
            _isVideoInitialized = true;
          });
        }).catchError((error) {
          print("Error initializing video: $error");
        });
    } catch (e) {
      print("Exception caught while initializing video: $e");
    }
  }

  void _togglePlayPause() {
    setState(() {
      if (_videoController.value.isPlaying) {
        _videoController.pause();
      } else {
        _videoController.play();
      }
    });
    _resetHideButtonTimer();
  }

  void _resetHideButtonTimer() {
    _hideButtonTimer?.cancel();
    _hideButtonTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _isPlayPauseButtonVisible = false;
      });
    });

    setState(() {
      _isPlayPauseButtonVisible = true;
    });
  }

  Future<void> _uploadVideo(BuildContext context) async {
    final String caption = _captionController.text.trim();

    if (caption.isEmpty) {
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      // Assuming `uploadReels` is a Future that completes on success
      await context.read<UpdateProfileCubit>().uploadReels(context, widget.imagePath, caption);

      // Pause the video when the upload is successful
      if (_videoController.value.isPlaying) {
        _videoController.pause();
      }

      // Navigate to MyReelProfile page
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MyReelProfile(),
        ),
      );
    } catch (e) {
      print("Error uploading reel: $e");
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    _hideButtonTimer?.cancel();
    _captionController.dispose();
    super.dispose();
  }

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
        title: "VIDEOS",
        titleColor: Colors.black,
        backgroundColor: Colors.white,
        centerTitle: true,
        showBorder: false,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _isSupportedVideoFormat(widget.imagePath)
              ? ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Container(
              height: 300.0,
              color: Colors.black,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  GestureDetector(
                    onTap: _togglePlayPause, // Play/pause only when tapping on video
                    child: _isVideoInitialized
                        ? AspectRatio(
                      aspectRatio: _videoController.value.aspectRatio,
                      child: VideoPlayer(_videoController),
                    )
                        :  Center(child: AppLoader()),
                  ),
                  if (_isVideoInitialized && _isPlayPauseButtonVisible)
                    GestureDetector(
                      onTap: _togglePlayPause,
                      child: CircleAvatar(
                        radius: 30.0,
                        backgroundColor: Colors.white.withOpacity(0.8),
                        child: Icon(
                          _videoController.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.black,
                          size: 30.0,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          )
              : const Center(
            child: Text(
              "Unsupported video format. Please select a valid video.",
              style: TextStyle(color: Colors.red),
            ),
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              cursorColor: AppColor.activeiconclr,
              controller: _captionController,
              maxLines: 2,
              maxLength: 50,
              decoration: InputDecoration(
                hintText: "Write a caption...",
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColor.darkmainColor),
                ),
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: CustomButton(
              text: _isUploading ? 'Uploading...' : 'Upload',
              onPressed: _isUploading ? null : () => _uploadVideo(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}


// import 'dart:async';
// import 'dart:io';
// import 'package:camera/camera.dart';
// import 'package:demoproject/component/reuseable_widgets/apploder.dart';
// import 'package:demoproject/component/utils/appcolor.dart';
// import 'package:flutter/material.dart';
// import 'package:get_thumbnail_video/video_thumbnail.dart';
// import 'package:video_player/video_player.dart';
// import 'package:path_provider/path_provider.dart';
// import '../../component/reuseable_widgets/appBar.dart';
// import '../../component/reuseable_widgets/custom_button.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../dashboard/profile/cubit/updateData/updateprofilecubit.dart';
// import 'package:image_picker/image_picker.dart';
//
//
// class UploadPostPage extends StatefulWidget {
//   final String imagePath;
//
//   const UploadPostPage({Key? key, required this.imagePath}) : super(key: key);
//
//   @override
//   State<UploadPostPage> createState() => _UploadPostPageState();
// }
//
// class _UploadPostPageState extends State<UploadPostPage> {
//   late VideoPlayerController _videoController;
//   bool _isVideoInitialized = false;
//   bool _isPlayPauseButtonVisible = true;
//   Timer? _hideButtonTimer;
//   final TextEditingController _captionController = TextEditingController();
//   bool _isUploading = false;
//   String? _thumbnailPath;
//
//   @override
//   void initState() {
//     super.initState();
//     if (_isSupportedVideoFormat(widget.imagePath)) {
//       _generateThumbnail(widget.imagePath);
//       _initializeVideoController(widget.imagePath);
//     } else {
//       print("Invalid file type. Expected a supported video format.");
//     }
//   }
//
//   bool _isSupportedVideoFormat(String path) {
//     const supportedFormats = ['.mp4', '.mov', '.avi', '.mkv', '.flv'];
//     return supportedFormats.any((format) => path.toLowerCase().endsWith(format));
//   }
//
//
//   Future<void> _generateThumbnail(String videoPath) async {
//     try {
//       final thumbnailFile = await VideoThumbnail.thumbnailFile(
//         video: videoPath,
//         thumbnailPath: (await getTemporaryDirectory()).path,
//         imageFormat: ImageFormat.PNG,
//         maxHeight: 300,
//         quality: 75,
//       );
//
//       setState(() {
//         _thumbnailPath = thumbnailFile?.path;
//       });
//     } catch (e) {
//       print("Error generating thumbnail: $e");
//     }
//   }
//
//   Future<void> _initializeVideoController(String path) async {
//     try {
//       _videoController = VideoPlayerController.file(File(path))
//         ..addListener(() {
//           if (_videoController.value.hasError) {
//             print("VideoPlayer Error: ${_videoController.value.errorDescription}");
//           }
//         })
//         ..initialize().then((_) {
//           setState(() {
//             _isVideoInitialized = true;
//           });
//         }).catchError((error) {
//           print("Error initializing video: $error");
//         });
//     } catch (e) {
//       print("Exception caught while initializing video: $e");
//     }
//   }
//
//   void _togglePlayPause() {
//     setState(() {
//       if (_videoController.value.isPlaying) {
//         _videoController.pause();
//       } else {
//         _videoController.play();
//       }
//     });
//     _resetHideButtonTimer();
//   }
//
//   void _resetHideButtonTimer() {
//     _hideButtonTimer?.cancel();
//     _hideButtonTimer = Timer(Duration(seconds: 3), () {
//       setState(() {
//         _isPlayPauseButtonVisible = false;
//       });
//     });
//
//     setState(() {
//       _isPlayPauseButtonVisible = true;
//     });
//   }
//
//   Future<void> _uploadVideo(BuildContext context) async {
//     final String caption = _captionController.text.trim();
//
//     if (caption.isEmpty) {
//       return;
//     }
//
//     setState(() {
//       _isUploading = true;
//     });
//
//     try {
//       await context.read<UpdateProfileCubit>().uploadReels(context, widget.imagePath, caption);
//
//       Navigator.of(context).pop();
//     } catch (e) {
//       print("Error uploading video: $e");
//     } finally {
//       setState(() {
//         _isUploading = false;
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     _videoController.dispose();
//     _hideButtonTimer?.cancel();
//     _captionController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//         _togglePlayPause();
//       },
//       child: Scaffold(
//         appBar: appBarWidgetThree(
//           leading: Padding(
//             padding: const EdgeInsets.only(left: 5.0),
//             child: GestureDetector(
//               onTap: () {
//                 Navigator.of(context).pop();
//               },
//               child: Transform.scale(
//                 scale: 0.5,
//                 child: Image.asset(
//                   'assets/images/backarrow.png',
//                   height: 50,
//                   width: 50,
//                   fit: BoxFit.contain,
//                 ),
//               ),
//             ),
//           ),
//           title: "VIDEOS",
//           titleColor: Colors.black,
//           backgroundColor: Colors.white,
//           centerTitle: true,
//           showBorder: false,
//         ),
//         backgroundColor: Colors.white,
//         body: LayoutBuilder(
//           builder: (context, constraints) {
//             return SingleChildScrollView(
//               child: ConstrainedBox(
//                 constraints: BoxConstraints(
//                   minHeight: constraints.maxHeight,
//                 ),
//                 child: IntrinsicHeight(
//                   child: Column(
//                     children: [
//                       _isSupportedVideoFormat(widget.imagePath)
//                           ? ClipRRect(
//                         borderRadius: BorderRadius.circular(20.0),
//                         child: Container(
//                           height: 300.0,
//                           color: Colors.black,
//                           child: Stack(
//                             alignment: Alignment.center,
//                             children: [
//                               if (_isVideoInitialized)
//                                 AspectRatio(
//                                   aspectRatio: _videoController.value.aspectRatio,
//                                   child: VideoPlayer(_videoController),
//                                 )
//                               else if (_thumbnailPath != null)
//                                 Image.file(File(_thumbnailPath!))
//                               else
//                                 Center(
//                                   child: AppLoader(),
//                                 ),
//                               if (_isVideoInitialized && _isPlayPauseButtonVisible)
//                                 GestureDetector(
//                                   onTap: _togglePlayPause,
//                                   child: CircleAvatar(
//                                     radius: 30.0,
//                                     backgroundColor: Colors.white.withOpacity(0.8),
//                                     child: Icon(
//                                       _videoController.value.isPlaying
//                                           ? Icons.pause
//                                           : Icons.play_arrow,
//                                       color: Colors.black,
//                                       size: 30.0,
//                                     ),
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         ),
//                       )
//                           : const Center(
//                         child: Text(
//                           "Unsupported video format. Please select a valid video.",
//                           style: TextStyle(color: Colors.red),
//                         ),
//                       ),
//                       const SizedBox(height: 16.0),
//                       TextField(
//                         controller: _captionController,
//                         maxLines: 2,
//                         maxLength: 50,
//                         decoration: InputDecoration(
//                           hintText: "Write a caption...",
//                           focusedBorder: UnderlineInputBorder(
//                             borderSide: BorderSide(color: AppColor.darkmainColor),
//                           ),
//                           enabledBorder: UnderlineInputBorder(
//                             borderSide: BorderSide(color: Colors.grey),
//                           ),
//                         ),
//                       ),
//                       const Spacer(),
//                       Padding(
//                         padding: const EdgeInsets.all(14.0),
//                         child: CustomButton(
//                           text: _isUploading ? 'Uploading...' : 'Upload',
//                           onPressed: _isUploading ? null : () => _uploadVideo(context),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(14.0),
//                         child: GestureDetector(
//                           onTap: () {
//                             Navigator.of(context).pop();
//                           },
//                           child: Text(
//                             'Cancel',
//                             style: TextStyle(color: Colors.black, fontSize: 16),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 10),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
// }
