import 'package:demoproject/component/commonfiles/appcolor.dart';
import 'package:demoproject/component/reuseable_widgets/apploder.dart';
import 'package:demoproject/component/reuseable_widgets/customNavigator.dart';
import 'package:demoproject/ui/reels/original_reels_player.dart';
import 'package:demoproject/ui/reels/cubit/simple_reels_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:sizer/sizer.dart';
import '../userprofiledata.dart';
import 'commentbtmsheet.dart';

class AllReels extends StatefulWidget {
  const AllReels({Key? key}) : super(key: key);

  @override
  _AllReelsState createState() => _AllReelsState();
}

class _AllReelsState extends State<AllReels> {
  @override
  void initState() {
    super.initState();
    print("🚀 AllReels initState called");
    print("🚀 Widget mounted: ${mounted}");
    print("🚀 Context available: ${context.mounted}");
    
    // Load initial reels with simple cubit
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("🚀 PostFrameCallback executing...");
      print("🚀 Context mounted in callback: ${context.mounted}");
      try {
        print("🚀 Attempting to read SimpleReelsCubit...");
        final cubit = context.read<SimpleReelsCubit>();
        print("🚀 SimpleReelsCubit found: ${cubit.runtimeType}");
        print("🚀 Calling loadInitialReels...");
        cubit.loadInitialReels();
        print("🚀 loadInitialReels called successfully");
      } catch (e) {
        print("❌ Error in PostFrameCallback: $e");
        print("❌ Stack trace: ${StackTrace.current}");
      }
    });
  }

  // Removed _loadMoreReels as it's handled by OptimizedReelsCubit

  void updateReelLikeStatus(String videoId, bool isLiked, int likeCount) {
    // This method is now handled by OptimizedReelsCubit
    // The like updates are handled directly in the OptimizedReelsPlayer
  }

  void updateReelCommentCount(String videoId, int newCommentCount) {
    // This method is now handled by OptimizedReelsCubit
    // The comment updates are handled directly in the OptimizedReelsPlayer
  }

  @override
  Widget build(BuildContext context) {
    print("🚀 AllReels build method called");
    print("🚀 Context mounted in build: ${context.mounted}");
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<SimpleReelsCubit, SimpleReelsState>(
        builder: (context, state) {
          print("🚀 BlocBuilder builder called");
          print("🚀 Current state: ${state.status}");
          print("🚀 Reels count: ${state.reels.length}");
          print("🚀 Error message: ${state.errorMessage}");
          
          if (state.status == ApiStates.loading) {
            print("🚀 Showing loading state");
            return Center(child: AppLoader());
          } else if (state.status == ApiStates.error) {
            print("🚀 Showing error state: ${state.errorMessage}");
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 50.sp,
                  ),
                  SizedBox(height: 16),
                  Text(
                    state.errorMessage ?? "Error fetching reels",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<SimpleReelsCubit>().loadInitialReels();
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state.reels.isEmpty) {
            print("🚀 Showing empty state");
            return const Center(
              child: Text(
                "No Reels Available",
                style: TextStyle(color: Colors.white),
              ),
            );
          } else {
            print("🚀 Showing reels player with ${state.reels.length} reels");
            return OriginalReelsPlayer(
              reels: state.reels,
              onPageChanged: (index) {
                // Handle page change if needed
              },
              onLikeUpdate: (index, isLiked) {
                context.read<SimpleReelsCubit>().updateReelLike(index, isLiked);
              },
              onCommentUpdate: (index, newCount) {
                context.read<SimpleReelsCubit>().updateReelComment(index, newCount);
              },
              onLoadMore: () {
                // Simple cubit doesn't have load more for now
              },
            );
          }
        },
      ),
    );
  }
}

class ReelPlayer extends StatefulWidget {
  final String videoUrl;
  final String profilePicture;
  final String userName;
  final String caption;
  final int likeCount;
  final int commentCount;
  final String userId;
  final String videoId;
  final bool likeStatus;
  final Function(int) onCommentUpdate;

  final Function(String, bool, int) onLikeUpdate;

  const ReelPlayer({
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
  _ReelPlayerState createState() => _ReelPlayerState();
}

class _ReelPlayerState extends State<ReelPlayer> with WidgetsBindingObserver {
  late VideoPlayerController _controller;
  late bool _isLiked;
  late int _currentLikeCount;
  // bool _isTapped = false; // Flag to track if the button is tapped - unused

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

    // Registering the observer to handle lifecycle events
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // Disposing the controller when leaving the screen
    _controller.dispose();

    // Removing observer when leaving the screen
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Pause the video when app is paused or backgrounded
    if (state == AppLifecycleState.paused) {
      _controller.pause();
    } else if (state == AppLifecycleState.resumed) {
      // Optionally, you can resume the video if you want, but it's better to leave it paused.
      // _controller.play();
    }
  }

  void _toggleLike() {
    setState(() {
      if (_isLiked) {
        _currentLikeCount--;
      } else {
        _currentLikeCount++;
      }
      _isLiked = !_isLiked;
    });

    // Like handling is now done by OptimizedReelsPlayer
    // This method is kept for compatibility but doesn't do network calls
  }

  // FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  //
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
  //           bundleId: 'com.dating.corretta', appStoreId: "6450701850"),
  //     );
  //
  //     final ShortDynamicLink shortLink =
  //     await dynamicLinks.buildShortLink(parameters);
  //     final url = shortLink.shortUrl;
  //     Share.share(url.toString());  // Share the dynamic link
  //   } catch (e) {
  //     // Handle error if needed
  //     print("Error creating dynamic link: $e");
  //   } finally {
  //     Future.delayed(Duration(seconds: 1), () {
  //       setState(() {
  //         _isTapped = false;
  //       });
  //     });
  //   }
  // }

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
            icon: Icon(size: 30, Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        Positioned(
          bottom: 10.h,
          left: 16,
          child: GestureDetector(
            onTap: () {
              CustomNavigator.push(
                context: context,
                screen: UserReelProfile(
                  userId: widget.userId,
                  Name: widget.userName,
                ),
              );
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
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(
                      width: 60.w,
                      child: Text(
                        maxLines: 2,
                        widget.caption,
                        style: TextStyle(color: Colors.white70, fontSize: 12),
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
              Text('$_currentLikeCount', style: TextStyle(color: Colors.white)),
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
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(height: 10),
              GestureDetector(
                // onTap: () => createDynamicLink(widget.videoUrl),
                child: Image.asset(
                  'assets/images/share.png',
                  color: Colors.white,
                  width: 30,
                  height: 30,
                ),
              ),
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
