import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:demoproject/component/reuseable_widgets/apploder.dart';
import 'package:demoproject/component/reuseable_widgets/customNavigator.dart';
import 'package:demoproject/component/commonfiles/appcolor.dart';
import 'package:sizer/sizer.dart';
import 'userprofiledata.dart';
import 'reelsplayer/professional_comment_sheet.dart';

/// Original reels player that matches your previous UI exactly
class OriginalReelsPlayer extends StatefulWidget {
  final List<ReelData> reels;
  final Function(int) onPageChanged;
  final Function(int, bool) onLikeUpdate;
  final Function(int, int) onCommentUpdate;
  final Function() onLoadMore;

  const OriginalReelsPlayer({
    Key? key,
    required this.reels,
    required this.onPageChanged,
    required this.onLikeUpdate,
    required this.onCommentUpdate,
    required this.onLoadMore,
  }) : super(key: key);

  @override
  _OriginalReelsPlayerState createState() => _OriginalReelsPlayerState();
}

class _OriginalReelsPlayerState extends State<OriginalReelsPlayer>
    with WidgetsBindingObserver {
  late PageController _pageController;
  int _currentIndex = 0;
  
  // Simple video controller - only one at a time
  VideoPlayerController? _controller;
  bool _isVideoInitialized = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    log("🚀 OriginalReelsPlayer initState called");
    log("🚀 Reels count: ${widget.reels.length}");
    
    _pageController = PageController(initialPage: _currentIndex);
    WidgetsBinding.instance.addObserver(this);
    
    // Initialize first video with delay to prevent stuck loader
    if (widget.reels.isNotEmpty) {
      _initializeVideoWithDelay();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    if (state == AppLifecycleState.paused) {
      _controller?.pause();
    } else if (state == AppLifecycleState.resumed) {
      _controller?.play();
    }
  }

  /// Initialize video with delay to prevent stuck loader
  void _initializeVideoWithDelay() {
    setState(() {
      _isLoading = true;
    });
    
    // Small delay to prevent stuck loader
    Future.delayed(Duration(milliseconds: 100), () {
      if (mounted) {
        _initializeCurrentVideo();
      }
    });
  }

  /// Initialize video for current index
  void _initializeCurrentVideo() {
    if (_currentIndex >= widget.reels.length) return;
    
    final reel = widget.reels[_currentIndex];
    if (reel.videoUrl.isEmpty) {
      setState(() {
        _isLoading = false;
        _isVideoInitialized = false;
      });
      return;
    }
    
    log("🚀 Initializing video for index $_currentIndex: ${reel.videoUrl}");
    
    // Dispose previous controller
    _controller?.dispose();
    
    try {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(reel.videoUrl),
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true,
          allowBackgroundPlayback: false,
        ),
      );
      
      _controller!.initialize().then((_) {
        if (mounted) {
          setState(() {
            _isVideoInitialized = true;
            _isLoading = false;
          });
          _controller!.play();
          _controller!.setLooping(true);
          log("✅ Video initialized and playing for index $_currentIndex");
        }
      }).catchError((error) {
        log("❌ Error initializing video: $error");
        setState(() {
          _isVideoInitialized = false;
          _isLoading = false;
        });
      });
    } catch (e) {
      log("❌ Error creating video controller: $e");
      setState(() {
        _isVideoInitialized = false;
        _isLoading = false;
      });
    }
  }

  /// Handle page change
  void _onPageChanged(int index) {
    log("🔄 Page changed from $_currentIndex to $index");
    
    _currentIndex = index;
    widget.onPageChanged(index);
    
    // Initialize new video
    _initializeVideoWithDelay();
    
    // Load more reels if needed
    if (index >= widget.reels.length - 3) {
      widget.onLoadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    log("🚀 OriginalReelsPlayer build called");
    log("🚀 Reels count: ${widget.reels.length}");
    log("🚀 Current index: $_currentIndex");
    
    if (widget.reels.isEmpty) {
      log("🚀 No reels available, showing loader");
      return Center(child: AppLoader());
    }

    log("🚀 Building PageView with ${widget.reels.length} reels");
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      itemCount: widget.reels.length,
      onPageChanged: _onPageChanged,
      itemBuilder: (context, index) {
        return _buildReelItem(index);
      },
    );
  }

  /// Build individual reel item with exact original design
  Widget _buildReelItem(int index) {
    final reel = widget.reels[index];
    final isCurrentReel = index == _currentIndex;

    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Video player - EXACT same as your original
          if (isCurrentReel && _controller != null && _isVideoInitialized)
            GestureDetector(
              onTap: () {
                if (_controller!.value.isPlaying) {
                  _controller!.pause();
                } else {
                  _controller!.play();
                }
              },
              child: Center(
                child: AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                ),
              ),
            )
          else
            Center(
              child: _isLoading ? AppLoader() : CircularProgressIndicator(color: AppColor.tinderclr),
            ),
          
          // Back button (top-left) - EXACT same as original
          Positioned(
            top: 10.h,
            left: 1.w,
            child: IconButton(
              icon: Icon(size: 30, Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          
          // User info (bottom-left) - EXACT same as original
          Positioned(
            bottom: 10.h,
            left: 16,
            child: GestureDetector(
              onTap: () {
                // Navigate to user profile with user ID
                log("👤 User profile tapped: ${reel.userName} (ID: ${reel.userId})");
                CustomNavigator.push(
                  context: context,
                  screen: UserReelProfile(
                    userId: reel.userId,
                    Name: reel.userName,
                  ),
                );
              },
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(reel.profilePicture),
                    radius: 25,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reel.userName,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      SizedBox(
                        width: 60.w,
                        child: Text(
                          maxLines: 2,
                          reel.caption,
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Action buttons (bottom-right) - EXACT same as original
          Positioned(
            bottom: 15.h,
            right: 1.w,
            child: Column(
              children: [
                IconButton(
                  icon: Icon(
                    size: 30,
                    reel.likeStatus ? Icons.favorite : Icons.favorite_border,
                    color: reel.likeStatus ? Colors.red : Colors.white,
                  ),
                  onPressed: () {
                    widget.onLikeUpdate(index, !reel.likeStatus);
                    log("❤️ Like button tapped for index $index");
                  },
                ),
                Text('${reel.likeCount}', style: TextStyle(color: Colors.white)),
                IconButton(
                  icon: Image.asset(
                    'assets/images/comment.png',
                    color: Colors.white,
                    width: 30,
                    height: 30,
                  ),
                  onPressed: () {
                    _showCommentsSheet(context, reel.videoId);
                    log("💬 Comment button tapped for index $index");
                  },
                ),
                Text(
                  '${reel.commentCount}',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(height: 10),
                GestureDetector(
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
      ),
    );
  }

  /// Show professional comments sheet
  void _showCommentsSheet(BuildContext context, String videoId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      isDismissible: true,
      useSafeArea: true,
      builder: (context) {
        return ProfessionalCommentSheet(
          videoId: videoId,
          onCommentAdded: () {
            // Handle comment added
            log("💬 Comment added for video: $videoId");
          },
        );
      },
    );
  }
}

/// Reel data model
class ReelData {
  final String videoUrl;
  final String profilePicture;
  final String userName;
  final String caption;
  final int likeCount;
  final int commentCount;
  final String userId;
  final String videoId;
  final bool likeStatus;

  ReelData({
    required this.videoUrl,
    required this.profilePicture,
    required this.userName,
    required this.caption,
    required this.likeCount,
    required this.commentCount,
    required this.userId,
    required this.videoId,
    required this.likeStatus,
  });
}
