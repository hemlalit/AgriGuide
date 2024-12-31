import 'package:AgriGuide/localization/locales.dart';
import 'package:AgriGuide/providers/post_provider.dart';
import 'package:AgriGuide/widgets/post_widgets/comment_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';

class CommentSection extends StatefulWidget {
  final Function(String) onAddComment;
  final ScrollController scrollController;
  final String? tweetId;

  const CommentSection({
    super.key,
    required this.onAddComment,
    required this.scrollController,
    required this.tweetId,
  });

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final TextEditingController _controller = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  Future<void> _fetchComments() async {
    try {
      final commentsProvider = Provider.of<TweetProvider>(context, listen: false);
      await commentsProvider.fetchComments(widget.tweetId);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching comments: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commentsProvider = Provider.of<TweetProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(5),
                right: Radius.circular(5),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(LocaleData.comments.getString(context), style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 16),
          Expanded(
            child: commentsProvider.comments.isNotEmpty
                ? ListView.builder(
                    controller: widget.scrollController,
                    itemCount: commentsProvider.comments.length,
                    itemBuilder: (context, index) {
                      final comment = commentsProvider.comments[index];
                      print(comment.commentedBy!.id);
                      return CommentTile(comment: comment);
                    },
                  )
                : Center(
                    child: Text(
                      LocaleData.noCommentsYet.getString(context),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
          ),
          const Divider(),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: LocaleData.commentHere.getString(context),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                    filled: true,
                    contentPadding:
                        Theme.of(context).inputDecorationTheme.contentPadding,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: _isSubmitting
                      ? null
                      : () async {
                          if (_controller.text.trim().isNotEmpty) {
                            setState(() {
                              _isSubmitting = true;
                            });
                            try {
                              await widget.onAddComment(_controller.text.trim());
                              _controller.clear();
                              _fetchComments();
                              // if (mounted) {
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //     const SnackBar(
                              //         content:
                              //             Text('Comment added successfully')),
                              //   );
                              // }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: $e')),
                                );
                              }
                            } finally {
                              if (mounted) {
                                setState(() {
                                  _isSubmitting = false;
                                });
                              }
                            }
                          }
                        },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

