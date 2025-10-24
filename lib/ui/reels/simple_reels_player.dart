import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:demoproject/component/reuseable_widgets/apploder.dart';
import 'package:sizer/sizer.dart';
import 'reelsplayer/commentbtmsheet.dart';

/// Simple reels player that matches your original design exactly
class SimpleReelsPlayer extends StatefulWidget {
  final List<ReelData> reels;
  final Function(int) onPageChanged;
  final Function(int, bool) onLikeUpdate;
  final Function(int, int) onCommentUpdate;
  final Function() onLoadMore;

  const SimpleReelsPlayer({
    Key? key,
    required this.reels,
    required this.onPageChanged,
    required this.onLikeUpdate,
    required this.onCommentUpdate,
    required this.onLoadMore,
  }) : super(key: key);

  @override
  _SimpleReelsPlayerState createState() => _SimpleReelsPlayerState();
}

class _SimpleReelsPlayerState extends State<SimpleReelsPlayer>
    with WidgetsBindingObserver {
  late PageController _pageController;
  int _currentIndex = 0;
  
  // Simple video controller management
  VideoPlayerController? _currentController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    log("🚀 SimpleReelsPlayer initState called");
    log("🚀 Reels count: ${widget.reels.length}");
    
    _pageController = PageController(initialPage: _currentIndex);
    WidgetsBinding.instance.addObserver(this);
    
    // Initialize first video
    if (widget.reels.isNotEmpty) {
      _initializeCurrentVideo();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _currentController?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    if (state == AppLifecycleState.paused) {
      _currentController?.pause();
    } else if (state == AppLifecycleState.resumed) {
      _currentController?.play();
    }
  }

  /// Initialize video for current index
  void _initializeCurrentVideo() {
    if (_currentIndex >= widget.reels.length) return;
    
    final reel = widget.reels[_currentIndex];
    if (reel.videoUrl.isEmpty) return;
    
    log("🚀 Initializing video for index $_currentIndex: ${reel.videoUrl}");
    
    // Dispose previous controller
    _currentController?.dispose();
    
    try {
      _currentController = VideoPlayerController.networkUrl(
        Uri.parse(reel.videoUrl),
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true,
          allowBackgroundPlayback: false,
        ),
      );
      
      _currentController!.initialize().then((_) {
        if (mounted) {
          setState(() {
            _isVideoInitialized = true;
          });
          _currentController!.play();
          _currentController!.setLooping(true);
          log("✅ Video initialized and playing for index $_currentIndex");
        }
      }).catchError((error) {
        log("❌ Error initializing video: $error");
        setState(() {
          _isVideoInitialized = false;
        });
      });
    } catch (e) {
      log("❌ Error creating video controller: $e");
      setState(() {
        _isVideoInitialized = false;
      });
    }
  }

  /// Handle page change
  void _onPageChanged(int index) {
    log("🔄 Page changed from $_currentIndex to $index");
    
    _currentIndex = index;
    widget.onPageChanged(index);
    
    // Initialize new video
    _initializeCurrentVideo();
    
    // Load more reels if needed
    if (index >= widget.reels.length - 3) {
      widget.onLoadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    log("🚀 SimpleReelsPlayer build called");
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

  /// Build individual reel item with original design
  Widget _buildReelItem(int index) {
    final reel = widget.reels[index];
    final isCurrentReel = index == _currentIndex;

    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Video player - only show for current reel
          if (isCurrentReel && _currentController != null && _isVideoInitialized)
            _buildVideoPlayer()
          else
            _buildVideoPlaceholder(),
          
          // Back button (top-left)
          Positioned(
            top: 10.h,
            left: 1.w,
            child: IconButton(
              icon: Icon(size: 30, Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          
          // User info (bottom-left) - Original design
          Positioned(
            bottom: 10.h,
            left: 16,
            child: GestureDetector(
              onTap: () {
                // Navigate to user profile
                log("👤 User profile tapped: ${reel.userName}");
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
          
          // Action buttons (bottom-right) - Original design
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

  /// Build video player with original stretched design
  Widget _buildVideoPlayer() {
    return GestureDetector(
      onTap: () {
        if (_currentController!.value.isPlaying) {
          _currentController!.pause();
          log("⏸️ Video paused");
        } else {
          _currentController!.play();
          log("▶️ Video playing");
        }
        setState(() {});
      },
      child: Center(
        child: AspectRatio(
          aspectRatio: _currentController!.value.aspectRatio,
          child: VideoPlayer(_currentController!),
        ),
      ),
    );
  }

  /// Build video placeholder while loading
  Widget _buildVideoPlaceholder() {
    return Center(
      child: AppLoader(),
    );
  }

  /// Show comments sheet
  void _showCommentsSheet(BuildContext context, String videoId) {
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
