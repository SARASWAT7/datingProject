import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:demoproject/component/reuseable_widgets/apploder.dart';
import 'package:sizer/sizer.dart';

/// Optimized Instagram-like reels player with smooth scrolling and fast loading
class OptimizedReelsPlayer extends StatefulWidget {
  final List<ReelData> reels;
  final Function(int) onPageChanged;
  final Function(int, bool) onLikeUpdate;
  final Function(int, int) onCommentUpdate;
  final Function() onLoadMore;

  const OptimizedReelsPlayer({
    Key? key,
    required this.reels,
    required this.onPageChanged,
    required this.onLikeUpdate,
    required this.onCommentUpdate,
    required this.onLoadMore,
  }) : super(key: key);

  @override
  _OptimizedReelsPlayerState createState() => _OptimizedReelsPlayerState();
}

class _OptimizedReelsPlayerState extends State<OptimizedReelsPlayer>
    with WidgetsBindingObserver {
  late PageController _pageController;
  int _currentIndex = 0;
  
  // Video controllers cache for smooth playback
  final Map<int, VideoPlayerController> _videoControllers = {};
  final Map<int, bool> _videoInitialized = {};
  final Map<int, bool> _videoPlaying = {};
  
  // Preloading variables
  static const int _preloadCount = 3; // Preload next 3 videos
  Timer? _preloadTimer;

  @override
  void initState() {
    super.initState();
    log("🚀 OptimizedReelsPlayer initState called");
    log("🚀 Reels count: ${widget.reels.length}");
    log("🚀 Widget mounted: ${mounted}");
    
    _pageController = PageController(initialPage: _currentIndex);
    WidgetsBinding.instance.addObserver(this);
    
    log("🚀 PageController created");
    log("🚀 WidgetsBinding observer added");
    
    // Start preloading videos
    _startVideoPreloading();
    log("🚀 Video preloading started");
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _preloadTimer?.cancel();
    
    // Dispose all video controllers
    for (var controller in _videoControllers.values) {
      controller.dispose();
    }
    _videoControllers.clear();
    
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    if (state == AppLifecycleState.paused) {
      _pauseCurrentVideo();
    } else if (state == AppLifecycleState.resumed) {
      _playCurrentVideo();
    }
  }

  /// Start preloading videos for smooth scrolling
  void _startVideoPreloading() {
    _preloadTimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      _preloadVideos();
    });
  }

  /// Preload videos around current index
  void _preloadVideos() {
    if (widget.reels.isEmpty) return;
    
    final startIndex = (_currentIndex - 1).clamp(0, widget.reels.length - 1);
    final endIndex = (_currentIndex + _preloadCount).clamp(0, widget.reels.length - 1);
    
    for (int i = startIndex; i <= endIndex; i++) {
      if (!_videoControllers.containsKey(i) && i < widget.reels.length) {
        _initializeVideoController(i);
      }
    }
  }

  /// Initialize video controller for specific index
  void _initializeVideoController(int index) {
    if (index >= widget.reels.length) return;
    
    final reel = widget.reels[index];
    if (reel.videoUrl.isEmpty) return;
    
    try {
      final controller = VideoPlayerController.networkUrl(
        Uri.parse(reel.videoUrl),
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true,
          allowBackgroundPlayback: false,
        ),
      );
      
      _videoControllers[index] = controller;
      _videoInitialized[index] = false;
      _videoPlaying[index] = false;
      
      // Initialize video in background
      controller.initialize().then((_) {
        if (mounted && _videoControllers.containsKey(index)) {
          setState(() {
            _videoInitialized[index] = true;
          });
          
          // Auto-play current video
          if (index == _currentIndex) {
            _playCurrentVideo();
          }
        }
      }).catchError((error) {
        log("Error initializing video $index: $error");
        _videoControllers.remove(index);
      });
    } catch (e) {
      log("Error creating video controller $index: $e");
    }
  }

  /// Play current video
  void _playCurrentVideo() {
    final controller = _videoControllers[_currentIndex];
    if (controller != null && _videoInitialized[_currentIndex] == true) {
      controller.play();
      _videoPlaying[_currentIndex] = true;
    }
  }

  /// Pause current video
  void _pauseCurrentVideo() {
    final controller = _videoControllers[_currentIndex];
    if (controller != null && _videoPlaying[_currentIndex] == true) {
      controller.pause();
      _videoPlaying[_currentIndex] = false;
    }
  }

  /// Handle page change
  void _onPageChanged(int index) {
    // Pause previous video
    _pauseCurrentVideo();
    
    _currentIndex = index;
    widget.onPageChanged(index);
    
    // Play new video
    _playCurrentVideo();
    
    // Load more reels if needed
    if (index >= widget.reels.length - 3) {
      widget.onLoadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    log("🚀 OptimizedReelsPlayer build called");
    log("🚀 Reels count: ${widget.reels.length}");
    log("🚀 Widget mounted: ${mounted}");
    
    if (widget.reels.isEmpty) {
      log("🚀 No reels available, showing loader");
      return Center(
        child: AppLoader(),
      );
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

  /// Build individual reel item with optimized video player
  Widget _buildReelItem(int index) {
    final reel = widget.reels[index];
    final controller = _videoControllers[index];
    final isInitialized = _videoInitialized[index] == true;
    final isPlaying = _videoPlaying[index] == true;

    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Video player
          if (controller != null && isInitialized)
            _buildVideoPlayer(controller, isPlaying)
          else
            _buildVideoPlaceholder(reel),
          
          // Reel content overlay
          _buildReelOverlay(reel, index),
        ],
      ),
    );
  }

  /// Build optimized video player
  Widget _buildVideoPlayer(VideoPlayerController controller, bool isPlaying) {
    return GestureDetector(
      onTap: () {
        if (isPlaying) {
          controller.pause();
          _videoPlaying[_currentIndex] = false;
        } else {
          controller.play();
          _videoPlaying[_currentIndex] = true;
        }
        setState(() {});
      },
      child: AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: VideoPlayer(controller),
      ),
    );
  }

  /// Build video placeholder while loading
  Widget _buildVideoPlaceholder(ReelData reel) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppLoader(),
            SizedBox(height: 20),
            Text(
              'Loading video...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build reel content overlay (user info, actions, etc.)
  Widget _buildReelOverlay(ReelData reel, int index) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.7),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User info
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: CachedNetworkImageProvider(reel.profilePicture),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reel.userName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        reel.caption,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  icon: Icons.favorite,
                  count: reel.likeCount,
                  isActive: reel.likeStatus,
                  onTap: () => widget.onLikeUpdate(index, !reel.likeStatus),
                ),
                _buildActionButton(
                  icon: Icons.comment,
                  count: reel.commentCount,
                  onTap: () {
                    // Handle comment tap
                  },
                ),
                _buildActionButton(
                  icon: Icons.share,
                  onTap: () {
                    // Handle share tap
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build action button
  Widget _buildActionButton({
    required IconData icon,
    int count = 0,
    bool isActive = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            icon,
            color: isActive ? Colors.red : Colors.white,
            size: 28.sp,
          ),
          if (count > 0) ...[
            SizedBox(height: 4),
            Text(
              _formatCount(count),
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Format count for display (1K, 1M, etc.)
  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
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
