import 'package:demoproject/component/commonfiles/appcolor.dart';
import 'package:demoproject/ui/reels/model/profilereelsresponse.dart';
import 'package:demoproject/ui/reels/model/userprofiledata.dart';
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
import '../auth/design/splash.dart';
import '../dashboard/chat/design/chatroom.dart';
import '../dashboard/home/cubit/homecubit/homecubit.dart';
import 'cubit/myreels/myreelscubit.dart';
import 'cubit/myreels/myreelsstate.dart';
import '../reels/reelsupload.dart';

class UserReelProfile extends StatefulWidget {
  final String userId;
  final String Name;

  const UserReelProfile({
    Key? key,
    required this.userId,
    required this.Name,
  }) : super(key: key);

  @override
  _UserReelProfileState createState() => _UserReelProfileState();
}

class _UserReelProfileState extends State<UserReelProfile> {
  final ImagePicker _picker = ImagePicker();
  late ScrollController _scrollController;
  bool isLiked = false; // Track whether the profile is liked

  @override
  void initState() {
    super.initState();
    context.read<ProfileReelsCubit>().userProfileReels(context, widget.userId);
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent &&
        context.read<ProfileReelsCubit>().state.status != ApiStates.loading) {
      // Handle scroll behavior if needed
    }
  }

  Future<void> _likeUser(String id, String userName) async {
    final token = await getToken();
    if (token != null) {
      context.read<HomePageCubit>().likeSidlike(
        context,
        id,
        isLiked ? 'dislike' : 'like',
        token,
        userName,
      );
      setState(() {
        isLiked = !isLiked;
      });
    } else {
      print("Token not found");
    }
  }

  void updateReelLikeStatus(String reelId, bool isLiked, int likeCount) {
    final cubit = context.read<ProfileReelsCubit>();
    final result = cubit.state.response?.result;

    if (result != null && result.reelsDetails != null) {
      final reelsData = result.reelsDetails!;
      final reelIndex = reelsData.indexWhere((reel) => reel.reelId == reelId);

      if (reelIndex != -1) {
        final updatedReel = ReelsData(
          reelId: reelsData[reelIndex].reelId,
          caption: reelsData[reelIndex].caption,
          video: reelsData[reelIndex].video,
          createdAt: reelsData[reelIndex].createdAt,
          totalComments: reelsData[reelIndex].totalComments,
          totalLikes: likeCount,
          isLikedByMe: isLiked,
        );
        setState(() {
          reelsData[reelIndex] = updatedReel as ReelsDetails;
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
                if (state.status == ApiStates.loading || state.userProfileResponse == null) {
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
                              Container(color: Colors.grey, width: 120.0, height: 16.0),
                              const SizedBox(height: 4.0),
                              Container(color: Colors.grey, width: 180.0, height: 14.0),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Column(
                          children: [
                            Container(color: Colors.grey, width: 40.0, height: 16.0),
                            const Text('Reels', style: TextStyle(color: Colors.black54, fontSize: 12.0)),
                          ],
                        ),
                      ],
                    ),
                  );
                } else if (state.status == ApiStates.error) {
                  return Center(child: Text(state.errorMessage ?? "Error loading profile"));
                }

                final userProfile = state.userProfileResponse?.result?.reelOwnerData;
                final firebaseId = userProfile?.firebaseId ?? "";

                return Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundImage: userProfile?.profilePicture != null
                              ? NetworkImage(userProfile!.profilePicture!)
                              : AssetImage('assets/images/boy.png') as ImageProvider,
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${userProfile?.firstName ?? ""} ${userProfile?.lastName ?? ""}",
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                userProfile?.bio ?? "",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Column(
                          children: [
                            Text(
                              userProfile?.totalreels.toString() ?? '0',
                              style: const TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
                            ),
                            const Text('Reels', style: TextStyle(color: Colors.black54, fontSize: 14.0)),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                _likeUser(widget.userId, widget.Name);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isLiked ? AppColor.tinderclr : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  side: BorderSide(color: isLiked ? AppColor.tinderclr : Colors.grey),
                                ),
                              ),
                              child: Text(
                                isLiked ? 'Liked' : 'Like',
                                style: TextStyle(color: isLiked ? Colors.white : Colors.black),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ChatScreen(
                                      otherUserId:  state.userProfileResponse?.result?.loggedInUserData?.firebaseId.toString() ?? "",
                                      userId:state.userProfileResponse?.result?.reelOwnerData!.firebaseId.toString()??"",
                                      profileImage: state.userProfileResponse?.result?.reelOwnerData?.profilePicture ?? "",
                                      userName: "${state.userProfileResponse?.result?.reelOwnerData?.firstName ?? ""} ${state.userProfileResponse?.result?.reelOwnerData?.lastName ?? ""}",
                                      pageNavId: 1,
                                      myImage: state.userProfileResponse?.result?.loggedInUserData?.profilePicture ?? "",
                                      name: state.userProfileResponse?.result?.loggedInUserData?.firstName ?? "",
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  side: const BorderSide(color: Colors.grey),
                                ),
                              ),
                              child: const Text('Message', style: TextStyle(color: Colors.black)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          const SizedBox(height: 15.0),
          Expanded(
            child: BlocBuilder<ProfileReelsCubit, ProfileReelsState>(
              builder: (context, state) {
                if (state.status == ApiStates.loading && state.userProfileResponse == null) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: 20,
                      itemBuilder: (context, index) {
                        return Container(color: Colors.grey);
                      },
                    ),
                  );
                } else if (state.status == ApiStates.error) {
                  return Center(child: Text(state.errorMessage ?? "Error loading data"));
                } else if (state.userProfileResponse?.result?.reelsData?.isEmpty ?? true) {
                  return const Center(child: Text("No Reels Available"));
                } else {
                  final reels = state.userProfileResponse?.result?.reelsData;
                  return GridView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 1,
                    ),
                    itemCount: reels?.length,
                    itemBuilder: (context, index) {
                      final reel = reels?[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ReelVideoPlayer(
                                videoUrl: reel?.video ?? '',
                                profilePicture: state.userProfileResponse!.result!.reelOwnerData!.profilePicture!,
                                userName: "${state.userProfileResponse?.result?.reelOwnerData?.firstName ?? ""} ${state.userProfileResponse?.result?.reelOwnerData?.lastName ?? ""}",
                                caption: state.userProfileResponse?.result?.reelOwnerData?.bio ?? "",
                                likeCount: reel?.totalLikes ?? 0,
                                commentCount: reel?.totalComments ?? 0,
                                userId: widget.userId,
                                videoId: reel?.reelId??"",
                                likeStatus:reel?.isLikedByMe ?? false,
                                onLikeUpdate: updateReelLikeStatus,
                                    onCommentUpdate: (newCommentCount) {
                                      updateReelCommentCount(reel?.video??"", newCommentCount);
                                    },
                              ),
                            ),
                          );
                        },
                        child: VideoPlayerGridItem(videoUrl: reel?.video ?? ''),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
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