// import 'package:demoproject/component/reuseable_widgets/apploder.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// import 'package:sizer/sizer.dart';
//
//
// class ReelVideoPlayer extends StatefulWidget {
//   final String videoUrl;
//   final String profilePicture;
//   final String userName;
//   final String bio;
//   final int likeCount;
//
//   const ReelVideoPlayer({
//     Key? key,
//     required this.videoUrl,
//     required this.profilePicture,
//     required this.userName,
//     required this.bio,
//     required this.likeCount,
//   }) : super(key: key);
//
//   @override
//   _ReelVideoPlayerState createState() => _ReelVideoPlayerState();
// }
//
// class _ReelVideoPlayerState extends State<ReelVideoPlayer> {
//   late VideoPlayerController _controller;
//   bool _isVideoInitialized = false;
//   bool _isLiked = false;
//   double _currentPosition = 0.0;
//   bool _isFullScreen = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(widget.videoUrl)
//       ..initialize().then((_) {
//         setState(() {
//           _isVideoInitialized = true;
//           _controller.play();
//           _controller.setLooping(true);
//         });
//       });
//
//     _controller.addListener(() {
//       setState(() {
//         _currentPosition = _controller.value.position.inSeconds.toDouble();
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   void _toggleLike() {
//     setState(() {
//       _isLiked = !_isLiked;
//     });
//   }
//
//   void _toggleFullScreen() {
//     setState(() {
//       _isFullScreen = !_isFullScreen;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: GestureDetector(
//         onTap: () {
//           if (_controller.value.isPlaying) {
//             _controller.pause();
//           } else {
//             _controller.play();
//           }
//         },
//         child: Stack(
//           children: [
//             _isVideoInitialized
//                 ? Positioned.fill(
//               child: AspectRatio(
//                 aspectRatio: _controller.value.aspectRatio,
//                 child: VideoPlayer(_controller),
//               ),
//             )
//                 : Center(child: AppLoader()),
//             Positioned(
//               top: 50,
//               left: 16,
//               child: IconButton(
//                 icon: Icon(
//                     size: 25,
//                     Icons.arrow_back, color: Colors.white),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ),
//             Positioned(
//               bottom: 50,
//               left: 16,
//               child: Row(
//                 children: [
//                   CircleAvatar(
//                     backgroundImage: NetworkImage(widget.profilePicture),
//                     radius: 25,
//                   ),
//                   const SizedBox(width: 8),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         widget.userName,
//                         style: const TextStyle(color: Colors.white, fontSize: 16),
//                       ),
//                       SizedBox( width: 60.w,
//                         child: Text(
//                           maxLines: 2,
//                           widget.bio,
//                           style: TextStyle(color: Colors.white70, fontSize: 12),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             Positioned(
//               bottom: 50,
//               right: 16,
//               child: Column(
//                 children: [
//                   IconButton(
//                     icon: Icon(
//                       size: 30,
//                       _isLiked ? Icons.favorite : Icons.favorite_border,
//                       color: _isLiked ? Colors.red : Colors.white,
//                     ),
//                     onPressed: _toggleLike,
//                   ),
//                   Text(
//                     '${widget.likeCount + (_isLiked ? 1 : 0)}',
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                   IconButton(
//                     icon: Image.asset(
//                       'assets/images/comment.png',
//                       color: Colors.white,
//                       width: 30,
//                       height: 30,
//                     ),
//                     onPressed: () {
//                       // Handle comment button press
//                     },
//                   ),
//                   Text(
//                     "28",
//                     style: const TextStyle(color: Colors.white, fontSize: 16),
//                   ),
//                   IconButton(
//                     icon: Image.asset(
//                       'assets/images/share.png',
//                       color: Colors.white,
//                       width: 30,
//                       height: 30,
//                     ),
//                     onPressed: () {
//                       // Handle share button press
//                     },
//                   ),
//                   Text(
//                     "127",
//                     style: const TextStyle(color: Colors.white, fontSize: 16),
//                   ),
//                   // IconButton(
//                   //   icon: Icon(
//                   //     _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
//                   //     color: Colors.white,
//                   //   ),
//                   //   onPressed: _toggleFullScreen,
//                   // ),
//                 ],
//               ),
//             ),
//             // Video progress slider
//             // Positioned(
//             //   bottom: 60,
//             //   left: 16,
//             //   right: 16,
//             //   child: Slider(
//             //     value: _currentPosition,
//             //     min: 0.0,
//             //     max: _controller.value.duration.inSeconds.toDouble(),
//             //     onChanged: (value) {
//             //       setState(() {
//             //         _currentPosition = value;
//             //         _controller.seekTo(Duration(seconds: value.toInt()));
//             //       });
//             //     },
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
//
//
//
//
//
//
//
//
//
//
//
//

import 'package:demoproject/component/commonfiles/appcolor.dart';
import 'package:demoproject/component/reuseable_widgets/apploder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:sizer/sizer.dart';

// import 'commentbtmsheet.dart';
//
// class ReelVideoPlayer extends StatefulWidget {
//   final String videoUrl;
//   final String profilePicture;
//   final String userName;
//   final String bio;
//   final int likeCount;
//   final int commentCount;
//
//   const ReelVideoPlayer({
//     Key? key,
//     required this.videoUrl,
//     required this.profilePicture,
//     required this.userName,
//     required this.bio,
//     required this.likeCount,
//     required this.commentCount
//   }) : super(key: key);
//
//   @override
//   _ReelVideoPlayerState createState() => _ReelVideoPlayerState();
// }
//
// class _ReelVideoPlayerState extends State<ReelVideoPlayer> {
//   late VideoPlayerController _controller;
//   bool _isVideoInitialized = false;
//   bool _isLiked = false;
//   double _currentPosition = 0.0;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(widget.videoUrl)
//       ..initialize().then((_) {
//         setState(() {
//           _isVideoInitialized = true;
//           _controller.play();
//           _controller.setLooping(true);
//         });
//       });
//
//     _controller.addListener(() {
//       setState(() {
//         _currentPosition = _controller.value.position.inSeconds.toDouble();
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   void _toggleLike() {
//     setState(() {
//       _isLiked = !_isLiked;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body:
//       GestureDetector(
//         onTap: () {
//           if (_controller.value.isPlaying) {
//             _controller.pause();
//           } else {
//             _controller.play();
//           }
//         },
//         child: Stack(
//           children: [
//             _isVideoInitialized
//                 ? Center(
//               child: AspectRatio(
//                 aspectRatio: _controller.value.aspectRatio,
//                 child: VideoPlayer(_controller),
//               ),
//             )
//                 : AppLoader(),
//             Positioned(
//               top: 10.h,
//               left: 1.w,
//               child: IconButton(
//                 icon: Icon(
//                   size: 25,
//                   Icons.arrow_back,
//                   color: Colors.white,
//                 ),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ),
//             Positioned(
//               bottom: 10.h,
//               left: 16,
//               child: Row(
//                 children: [
//                   CircleAvatar(
//                     backgroundImage: NetworkImage(widget.profilePicture),
//                     radius: 25,
//                   ),
//                   const SizedBox(width: 8),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         widget.userName,
//                         style: const TextStyle(color: Colors.white, fontSize: 16),
//                       ),
//                       SizedBox(
//                         width: 60.w,
//                         child: Text(
//                           maxLines: 2,
//                           widget.bio,
//                           style: TextStyle(color: Colors.white70, fontSize: 12),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             Positioned(
//               bottom: 15.h,
//               right: 1.w,
//               child: Column(
//                 children: [
//                   IconButton(
//                     icon: Icon(
//                       size: 30,
//                       _isLiked ? Icons.favorite : Icons.favorite_border,
//                       color: _isLiked ? Colors.red : Colors.white,
//                     ),
//                     onPressed: _toggleLike,
//                   ),
//                   Text(
//                     '${widget.likeCount + (_isLiked ? 1 : 0)}',
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                   IconButton(
//                     icon: Image.asset(
//                       'assets/images/comment.png',
//                       color: Colors.white,
//                       width: 30,
//                       height: 30,
//                     ),
//                     onPressed: () {
//                       // Handle comment button press
//                     },
//                   ),
//                   Text(
//                     '${widget.commentCount}',
//                     style: const TextStyle(color: Colors.white, fontSize: 16),
//                   ),
//                   IconButton(
//                     icon: Image.asset(
//                       'assets/images/share.png',
//                       color: Colors.white,
//                       width: 30,
//                       height: 30,
//                     ),
//                     onPressed: () {
//                       // Handle share button press
//                     },
//                   ),
//                   Text(
//                     "127",
//                     style: const TextStyle(color: Colors.white, fontSize: 16),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//





import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import '../cubit/allreels/allreelscubit.dart';
import 'commentbtmsheet.dart';

class ReelVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String profilePicture;
  final String userName;
  final String caption;
  final int likeCount;
  final int commentCount;
  final String userId;
  final String videoId;
  final bool likeStatus;
  final Function(String, bool, int) onLikeUpdate;
  final Function(int) onCommentUpdate;

  const ReelVideoPlayer({
    Key? key,
    required this.videoUrl,
    required this.profilePicture,
    required this.userName,
    required this.caption,
    required this.likeCount,
    required this.commentCount,
    required this.userId,
    required this.videoId,
    required this.likeStatus,
    required this.onLikeUpdate,
    required this.onCommentUpdate,

  }) : super(key: key);

  @override
  _ReelVideoPlayerState createState() => _ReelVideoPlayerState();
}

class _ReelVideoPlayerState extends State<ReelVideoPlayer> {
  late VideoPlayerController _controller;
  late bool _isLiked;
  late int _currentLikeCount;
  bool _isTapped = false;


  @override
  void initState() {
    super.initState();
    _isLiked = widget.likeStatus;
    _currentLikeCount = widget.likeCount;

    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  // Future<void> createDynamicLink(String screenPath) async {
  //   if (_isTapped) return;
  //
  //   setState(() {
  //     _isTapped = true;
  //   });
  //
  //   try {
  //     final DynamicLinkParameters parameters = DynamicLinkParameters(
  //       uriPrefix: 'https://correttacorettaflutter.page.link',
  //       link: Uri.parse("https://correttacorettaflutter.page.link/GfBB/$screenPath"),
  //       androidParameters: const AndroidParameters(
  //         packageName: 'com.dating.corretta',
  //       ),
  //       iosParameters: const IOSParameters(
  //         bundleId: 'com.dating.corretta',
  //         appStoreId: "6450701850",
  //       ),
  //     );
  //
  //     final ShortDynamicLink shortLink = await dynamicLinks.buildShortLink(parameters);
  //     final Uri url = shortLink.shortUrl;
  //
  //     // Share the dynamic link
  //     await Share.share(url.toString());
  //   } catch (e) {
  //     debugPrint("Error creating dynamic link: $e");
  //   } finally {
  //     // Reset _isTapped safely
  //     Future.delayed(const Duration(seconds: 1), () {
  //       if (mounted) {
  //         setState(() {
  //           _isTapped = false;
  //         });
  //       }
  //     });
  //   }
  // }

  void _toggleLike() {
    setState(() {
      if (_isLiked) {
        _currentLikeCount--;
      } else {
        _currentLikeCount++;
      }
      _isLiked = !_isLiked;
    });

    context
        .read<AllReelsCubit>()
        .sendLike(context, widget.videoId, _isLiked ? "Like" : "Like")
        .then((_) {
      widget.onLikeUpdate(widget.videoId, _isLiked, _currentLikeCount);
    }).catchError((error) {
      setState(() {
        if (_isLiked) {
          _currentLikeCount--;
        } else {
          _currentLikeCount++;
        }
        _isLiked = !_isLiked;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating like status: $error")),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _controller.value.isInitialized
            ? GestureDetector(
          onTap: () {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          },
          child: Center(
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          ),
        )
            : Center(
          child: CircularProgressIndicator(color: AppColor.tinderclr),
        ),
        Positioned(
          top: 10.h,
          left: 1.w,
          child: IconButton(
            icon: Icon(size:30,Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        Positioned(
          bottom: 10.h,
          left: 16,
          child: GestureDetector(
            onTap: () {
              // CustomNavigator.push(
              //   context: context,
              //   screen: UserReelProfile(
              //     userId: widget.userId,
              //     Name: widget.userName,
              //   ),
              // );
            },
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.profilePicture),
                  radius: 25,
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.userName,
                      style: const TextStyle(color: Colors.white, fontSize: 16,  decoration: TextDecoration.none, // No underline
                      ),
                    ),
                    SizedBox(
                      width: 60.w,
                      child: Text(
                        maxLines: 2,
                        widget.caption,
                        style: TextStyle(color: Colors.white70, fontSize: 12,decoration: TextDecoration.none),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 15.h,
          right: 1.w,
          child: Column(
            children: [
              IconButton(
                icon: Icon(
                  size: 30,
                  _isLiked ? Icons.favorite : Icons.favorite_border,
                  color: _isLiked ? Colors.red : Colors.white,
                ),
                onPressed: _toggleLike,
              ),
              Text('$_currentLikeCount', style: const TextStyle(color: Colors.white,fontSize: 16,decoration: TextDecoration.none)),
              IconButton(
                icon: Image.asset(
                  'assets/images/comment.png',
                  color: Colors.white,
                  width: 30,
                  height: 30,
                ),
                onPressed: () {
                  showCommentsSheet(context, widget.videoId);
                },
              ),
              Text(
                '${widget.commentCount}',
                style: const TextStyle(color: Colors.white, fontSize: 16,decoration: TextDecoration.none),
              ),
              SizedBox(height: 10,),
              GestureDetector(
                // onTap: () => createDynamicLink(widget.videoUrl),
                child: Image.asset(
                  'assets/images/share.png',
                  color: Colors.white,
                  width: 30,
                  height: 30,
                ),
              )

            ],
          ),
        ),
      ],
    );
  }

  void showCommentsSheet(BuildContext context, String videoId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return CommentSheet(
          videoId: videoId,
          onCommentAdded: () {
            widget.onCommentUpdate(widget.commentCount + 1);
          },
        );
      },
    );
  }
}




