import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:demoproject/component/commonfiles/appcolor.dart';
import 'package:demoproject/component/reuseable_widgets/apploder.dart';
import 'package:demoproject/component/reuseable_widgets/apptext.dart';
import 'package:demoproject/component/apihelper/urls.dart';
import '../cubit/allreels/allreelscubit.dart';
import '../cubit/allreels/allreelsstate.dart';
import '../reelswidget/commentwidget.dart';
import 'package:sizer/sizer.dart';

class ProfessionalCommentSheet extends StatefulWidget {
  final String videoId;
  final VoidCallback onCommentAdded;

  const ProfessionalCommentSheet({
    Key? key, 
    required this.videoId, 
    required this.onCommentAdded
  }) : super(key: key);

  @override
  _ProfessionalCommentSheetState createState() => _ProfessionalCommentSheetState();
}

class _ProfessionalCommentSheetState extends State<ProfessionalCommentSheet>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  
  bool _isSubmitting = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    _animationController.forward();
    _fetchComments();
    
    // Listen to keyboard changes
    _focusNode.addListener(_onFocusChange);
    WidgetsBinding.instance.addObserver(this);
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      // Keyboard opened - scroll to bottom and ensure full visibility
      Future.delayed(Duration(milliseconds: 100), () {
        if (mounted && _scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  // Fetch comments function
  void _fetchComments() {
    context.read<AllReelsCubit>().getComment(context, widget.videoId).then((_) {
      Future.delayed(Duration(milliseconds: 200), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  void _addComment() async {
    if (_controller.text.trim().isEmpty || _isSubmitting) return;

    String commentText = _controller.text.trim();
    _controller.clear();
    _focusNode.unfocus();

    setState(() {
      _isSubmitting = true;
    });

    try {
      await context.read<AllReelsCubit>().sendMyComment(context, widget.videoId, commentText);
      widget.onCommentAdded();
      _fetchComments();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add comment: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = MediaQuery.of(context).size.height;
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;
    
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: keyboardHeight > 0 
          ? screenHeight - keyboardHeight - safeAreaBottom // Full height minus keyboard and safe area
          : screenHeight * 0.8, // 80% of screen when keyboard is closed
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    AppText(
                      text: "Comments",
                      size: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.close,
                          size: 20,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Comments List
              Expanded(
                child: BlocBuilder<AllReelsCubit, AllReelsState>(
                  builder: (context, state) {
                    if (state.status == ApiStates.loading) {
                      return Center(
                        child: AppLoader(),
                      );
                    } else if (state.status == ApiStates.error) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 50.sp,
                              color: Colors.red[300],
                            ),
                            SizedBox(height: 16),
                            AppText(
                              text: "Failed to load comments",
                              size: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.red[600]!,
                            ),
                            SizedBox(height: 8),
                            AppText(
                              text: state.errorMessage ?? 'Unknown error',
                              size: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[600]!,
                            ),
                          ],
                        ),
                      );
                    } else if (state.responseCmt?.result == null ||
                        state.responseCmt!.result!.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 50.sp,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 16),
                            AppText(
                              text: "No comments yet",
                              size: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600]!,
                            ),
                            SizedBox(height: 8),
                            AppText(
                              text: "Be the first to comment!",
                              size: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[500]!,
                            ),
                          ],
                        ),
                      );
                    }

                    final comments = state.responseCmt!.result!;
                    return ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        final isMe = comment.commentUserId?.id == "current_user_id";

                        return Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: isMe
                              ? MyCommentWidget(comment: comment.comment ?? "")
                              : UserCommentWidget(
                                  profile: comment.commentUserId?.profilePicture ?? "",
                                  username: "${comment.commentUserId?.firstName ?? ''} ${comment.commentUserId?.lastName ?? ''}",
                                  comment: comment.comment ?? "",
                                ),
                        );
                      },
                    );
                  },
                ),
              ),
              
              // Professional Input Field
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  border: Border(
                    top: BorderSide(color: Colors.grey[200]!, width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: Colors.grey[300]!),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          cursorColor: AppColor.tinderclr,
                          maxLines: null,
                          textInputAction: TextInputAction.newline,
                          decoration: InputDecoration(
                            hintText: "Add a comment...",
                            hintStyle: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 14.sp,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, 
                              vertical: 12
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    // Professional Submit Button
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: _isSubmitting ? Colors.grey[300] : AppColor.tinderclr,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.tinderclr.withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(25),
                          onTap: _isSubmitting ? null : _addComment,
                          child: Center(
                            child: _isSubmitting
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : Icon(
                                    Icons.send_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animationController.dispose();
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
