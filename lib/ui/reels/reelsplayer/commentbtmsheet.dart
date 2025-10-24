import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../component/commonfiles/appcolor.dart';
import '../../../component/apihelper/urls.dart';
import '../cubit/allreels/allreelscubit.dart';
import '../cubit/allreels/allreelsstate.dart';
import '../reelswidget/commentwidget.dart';

class CommentSheet extends StatefulWidget {
  final String videoId;
  final VoidCallback onCommentAdded;

  CommentSheet({Key? key, required this.videoId, required this.onCommentAdded}) : super(key: key);

  @override
  _CommentSheetState createState() => _CommentSheetState();
}

class _CommentSheetState extends State<CommentSheet> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchComments();
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
    if (_controller.text.trim().isEmpty) return;

    String commentText = _controller.text.trim();
    _controller.clear();

    try {
      await context.read<AllReelsCubit>().sendMyComment(context, widget.videoId, commentText);
      widget.onCommentAdded(); // Notify parent if needed
      _fetchComments(); // Fetch updated comments
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add comment: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: MediaQuery.of(context).viewInsets.bottom > 0
                ? constraints.maxHeight
                : MediaQuery.of(context).size.height * 0.5,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Comments",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                // Comments List
                Expanded(
                  child: BlocBuilder<AllReelsCubit, AllReelsState>(
                    builder: (context, state) {
                      if (state.status == ApiStates.loading) {
                        return Center(
                          child: CircularProgressIndicator(color: AppColor.tinderclr),
                        );
                      } else if (state.status == ApiStates.error) {
                        return Center(
                          child: Text(
                            "Error: ${state.errorMessage ?? 'Failed to fetch comments'}",
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                      } else if (state.responseCmt?.result == null ||
                          state.responseCmt!.result!.isEmpty) {
                        return Center(child: Text("No comments yet."));
                      }

                      final comments = state.responseCmt!.result!;
                      return ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          final comment = comments[index];
                          final isMe = comment.commentUserId?.id == "current_user_id";

                          return isMe
                              ? MyCommentWidget(comment: comment.comment ?? "")
                              : UserCommentWidget(
                            profile: comment.commentUserId?.profilePicture ?? "",
                            username:
                            "${comment.commentUserId?.firstName ?? ''} ${comment.commentUserId?.lastName ?? ''}",
                            comment: comment.comment ?? "",
                          );
                        },
                      );
                    },
                  ),
                ),
                // Input Field
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          cursorColor: AppColor.tinderclr,
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: "Add a comment...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: AppColor.tinderclr),
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      IconButton(
                        onPressed: _addComment,
                        icon: Icon(Icons.send, color: AppColor.tinderclr),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
