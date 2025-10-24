// import 'package:demoproject/ui/reels/reelsupload.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import '../../component/reuseable_widgets/appBar.dart';
// import 'package:sizer/sizer.dart';
//
// class MyReelProfile extends StatefulWidget {
//   final String imagePath;
//   final String name;
//   final String bio;
//
//   MyReelProfile({
//     Key? key,
//     required this.imagePath,
//     required this.bio,
//     required this.name,
//   }) : super(key: key);
//
//   @override
//   State<MyReelProfile> createState() => _MyReelProfileState();
// }
//
// class _MyReelProfileState extends State<MyReelProfile> {
//   final ImagePicker _picker = ImagePicker();
//
//   Future<void> pickVideo() async {
//     try {
//       final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
//
//       if (video != null) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => UploadPostPage(imagePath: video.path),
//           ),
//         );
//       }
//     } catch (e) {
//       print("Error picking video: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: appBarWidgetThree(
//         leading: Padding(
//           padding: const EdgeInsets.only(left: 5.0),
//           child: GestureDetector(
//             onTap: () {
//               Navigator.of(context).pop();
//             },
//             child: Transform.scale(
//               scale: 0.5,
//               child: Image.asset(
//                 'assets/images/backarrow.png',
//                 height: 50,
//                 width: 50,
//                 fit: BoxFit.contain,
//               ),
//             ),
//           ),
//         ),
//         title: widget.name,
//         titleColor: Colors.black,
//         backgroundColor: Colors.white,
//         centerTitle: true,
//         showBorder: false,
//       ),
//       backgroundColor: Colors.white,
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Profile Header
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               children: [
//                 // Profile Image
//                 Container(
//                   width: 70.0,
//                   height: 70.0,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     image: DecorationImage(
//                       image: NetworkImage(
//                           widget.imagePath), // Use the provided online image
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 16.0),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         widget.name,
//                         style: const TextStyle(
//                           color: Colors.black,
//                           fontSize: 18.0,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                       const SizedBox(height: 4.0),
//                       Text(
//                         widget.bio,
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                         style: const TextStyle(
//                           color: Colors.black,
//                           fontSize: 14.0,
//                           fontWeight: FontWeight.w400,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 8.0),
//                 Column(
//                   children: const [
//                     Text(
//                       '132',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 16.0,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     Text(
//                       'Reels',
//                       style: TextStyle(
//                         color: Colors.black54,
//                         fontSize: 12.0,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16.0),
//
//           // Reels Grid
//           Expanded(
//             child: Stack(
//               children: [
//                 GridView.builder(
//                   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 3,
//                     crossAxisSpacing: 4.0,
//                     mainAxisSpacing: 4.0,
//                   ),
//                   itemCount: 15, // Number of items in the grid
//                   itemBuilder: (context, index) {
//                     return Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8.0),
//                         image: const DecorationImage(
//                           image: NetworkImage(
//                               'https://lempire-dating.s3.amazonaws.com/752af83d-452c-4d07-aaf6-d2d65e7f8e1b.jpg'),
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 // Add Button
//                 Positioned(
//                   bottom: 20.0,
//                   right: 20.0,
//                   child: FloatingActionButton(
//                     onPressed: pickVideo, // Call the video picker
//                     backgroundColor: Colors.transparent,
//                     child: Image.asset(
//                       "assets/images/add.png",
//                       height: 40.h,
//                       width: 40.w,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:demoproject/ui/reels/reelsplayer/reelsplayerpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:sizer/sizer.dart';
import 'package:shimmer/shimmer.dart';
import '../../component/apihelper/urls.dart';
import '../../component/reuseable_widgets/appBar.dart';
import '../../component/reuseable_widgets/apploder.dart';
import '../../component/reuseable_widgets/bottomTabBar.dart';
import 'cubit/myreels/myreelscubit.dart';
import 'cubit/myreels/myreelsstate.dart';
import '../reels/reelsupload.dart';
import 'model/profilereelsresponse.dart';

class MyReelProfile extends StatefulWidget {
  const MyReelProfile({Key? key}) : super(key: key);

  @override
  State<MyReelProfile> createState() => _MyReelProfileState();
}

class _MyReelProfileState extends State<MyReelProfile> {
  final ImagePicker _picker = ImagePicker();
  late ScrollController _scrollController;

  @override
  void initState() {
    context.read<ProfileReelsCubit>().fetchProfileReels(context);
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent &&
        context.read<ProfileReelsCubit>().state.status != ApiStates.loading) {
    }
  }

  Future<void> pickVideo() async {
    try {
      final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);

      if (video != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UploadPostPage(imagePath: video.path),
          ),
        );
      }
    } catch (e) {
      print("Error picking video: $e");
    }
  }

  void updateReelLikeStatus(String videoId, bool isLiked, int likeCount) {
    final cubit = context.read<ProfileReelsCubit>();
    final reels = cubit.state.response?.result?.reelsDetails;

    if (reels != null) {
      final reelIndex = reels.indexWhere((reel) => reel.reelId == videoId);
      if (reelIndex != -1) {
        setState(() {
          reels[reelIndex] = ReelsDetails(
            reelId: reels[reelIndex].reelId,
            caption: reels[reelIndex].caption,
            video: reels[reelIndex].video,
            totalLikes: likeCount,
            totalComments: reels[reelIndex].totalComments,
            isLikedByMe: isLiked,
            createdAt: reels[reelIndex].createdAt,
          );
        });
      }
    }
  }

  void updateReelCommentCount(String reelId, int newCommentCount) {
    final cubit = context.read<ProfileReelsCubit>();
    final reels = cubit.state.response?.result?.reelsDetails;

    if (reels != null) {
      final reelIndex = reels.indexWhere((reel) => reel.reelId == reelId);
      if (reelIndex != -1) {
        setState(() {
          reels[reelIndex] = ReelsDetails(
            reelId: reels[reelIndex].reelId,
            caption: reels[reelIndex].caption,
            video: reels[reelIndex].video,
            totalLikes: reels[reelIndex].totalLikes,
            totalComments: newCommentCount, // Update comment count
            isLikedByMe: reels[reelIndex].isLikedByMe,
            createdAt: reels[reelIndex].createdAt,
          );
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => BottomBar(currentIndex: 4),
          ),
        );
        return false; // Prevent default back behavior
      },
      child: Scaffold(
        appBar: appBarWidgetThree(
          leading: Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (_) => BottomBar(
                          currentIndex: 4,
                        )),
                        (route) => false);
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
          title: "Reels Profile",
          titleColor: Colors.black,
          backgroundColor: Colors.white,
          centerTitle: true,
          showBorder: false,
        ),
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: BlocBuilder<ProfileReelsCubit, ProfileReelsState>(
                builder: (context, state) {
                  if (state.status == ApiStates.loading || state.response == null) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Row(
                        children: [
                          CircleAvatar(radius: 35, backgroundColor: Colors.grey),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  color: Colors.grey,
                                  width: 120.0,
                                  height: 16.0,
                                ),
                                const SizedBox(height: 4.0),
                                Container(
                                  color: Colors.grey,
                                  width: 180.0,
                                  height: 14.0,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Column(
                            children: [
                              Container(
                                color: Colors.grey,
                                width: 40.0,
                                height: 16.0,
                              ),
                              const Text(
                                'Reels',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  } else if (state.status == ApiStates.error) {
                    return Center(
                        child: Text(state.errorMessage ?? "Error loading profile"));
                  }

                  return Row(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundImage: state.response?.result?.userDetails?.profilePicture != null
                            ? NetworkImage(state.response!.result!.userDetails!.profilePicture!)
                            : AssetImage('assets/images/boy.png') as ImageProvider,
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${state.response?.result?.userDetails?.firstName ?? ""} ${state.response?.result?.userDetails?.lastName ?? ""}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              state.response?.result?.userDetails?.bio ?? "",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Column(
                        children: [
                          BlocBuilder<ProfileReelsCubit,ProfileReelsState>(
                            builder: (context, state) {
                              return Text(
                                state.response?.result?.userDetails?.totalreels.toString() ?? '0',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            },
                          ),
                          const Text(
                            'Reels',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: BlocBuilder<ProfileReelsCubit, ProfileReelsState>(
                builder: (context, state) {
                  if (state.status == ApiStates.loading && state.response == null) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child:
                      GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        itemCount: 20,
                        itemBuilder: (context, index) {
                          return Container(
                            color: Colors.grey,
                          );
                        },
                      ),
                    );
                  } else if (state.status == ApiStates.error) {
                    return Center(
                        child: Text(state.errorMessage ?? "Error loading data"));
                  } else if (state.response?.result?.reelsDetails?.isEmpty ?? true) {
                    return const Center(child: Text("No Reels Available"));
                  } else {
                    final reels = state.response!.result!.reelsDetails!;

                    return GridView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 1,
                        mainAxisSpacing: 1,
                      ),
                      itemCount: reels.length,
                      itemBuilder: (context, index) {
                        final reel = reels[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ReelVideoPlayer(
                                  videoUrl: reel.video ?? '',
                                  profilePicture: state.response!.result!.userDetails!.profilePicture!,
                                  userName: "${state.response?.result?.userDetails!.firstName ?? ""} ${state.response?.result?.userDetails?.lastName ?? ""}",
                                  caption: state.response?.result?.userDetails?.bio?? "",
                                  likeCount: reel.totalLikes??0,
                                  commentCount: reel.totalComments??0,
                                  userId: state.userProfileResponse?.result?.loggedInUserData?.id ?? "",
                                  videoId: reel.reelId ?? "",
                                  likeStatus: reel.isLikedByMe ?? false,
                                  onLikeUpdate: updateReelLikeStatus,
                                  onCommentUpdate: (newCommentCount) {
                                    updateReelCommentCount(reel.video??"", newCommentCount);
                                  },
                                ),
                              ),
                            );
                          },
                          child: VideoPlayerGridItem(videoUrl: reel.video ?? ''),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          foregroundColor: Colors.transparent,
          onPressed: pickVideo,
          backgroundColor: Colors.transparent,
          elevation: 0,
          highlightElevation: 0,
          child: Image.asset(
            "assets/images/add.png",
            height: 40.h,
            width: 40.w,
          ),
        ),
      ),
    );
  }
}

class VideoPlayerGridItem extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerGridItem({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerGridItemState createState() => _VideoPlayerGridItemState();
}

class _VideoPlayerGridItemState extends State<VideoPlayerGridItem> {
  late VideoPlayerController _controller;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _isVideoInitialized = true;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        color: Colors.black,
        child: _isVideoInitialized
            ? FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _controller.value.size.width,
            height: _controller.value.size.height,
            child: VideoPlayer(_controller),
          ),
        )
            : Center(child:AppLoader()),
      ),
    );
  }}

