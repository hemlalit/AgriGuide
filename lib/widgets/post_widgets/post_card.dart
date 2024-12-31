import 'package:AgriGuide/localization/locales.dart';
import 'package:AgriGuide/providers/post_provider.dart';
import 'package:AgriGuide/screens/hamburger_menu/profile_screen.dart';
import 'package:AgriGuide/widgets/like_animation.dart';
import 'package:AgriGuide/widgets/post_widgets/action_button.dart';
import 'package:AgriGuide/widgets/post_widgets/comments_section.dart';
import 'package:AgriGuide/widgets/post_widgets/retweet_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class TweetCard extends StatefulWidget {
  final String? id;
  final String? authorId;
  final String? authorName;
  final String? username;
  final String? content;
  final String timestamp;
  final String? profileImage;
  final int? initialLikeCount;
  final int? initialCommCount;
  final int? initialRetweetCount;
  final bool? initialHasRetweeted;
  final bool? isLiked;
  final bool isNavigate;
  final List<String> comments;

  const TweetCard({
    super.key,
    required this.authorName,
    required this.username,
    required this.content,
    required this.timestamp,
    required this.profileImage,
    required this.initialLikeCount,
    required this.initialCommCount,
    required this.initialRetweetCount,
    required this.initialHasRetweeted,
    this.comments = const [],
    required this.id,
    required this.isLiked,
    this.authorId,
    required this.isNavigate,
  });

  @override
  State<TweetCard> createState() => _TweetCardState();
}

class _TweetCardState extends State<TweetCard> {
  late bool _isLiked;
  late int _likeCount;
  late int _commentCount;
  late int _initialRetweetCount;
  late bool _initialHasRetweeted;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.isLiked ?? false;
    print(_isLiked);
    _likeCount = widget.initialLikeCount ?? 0;
    _commentCount = widget.initialCommCount ?? 0;
    _initialRetweetCount = widget.initialRetweetCount ?? 0;
    _initialHasRetweeted = widget.initialHasRetweeted ?? false;
  }

  void _openCommentSection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return CommentSection(
              tweetId: widget.id,
              onAddComment: _addComment,
              scrollController: scrollController,
            );
          },
        );
      },
    );
  }

  void _addComment(String comment) async {
    try {
      // Safely access the Provider
      final commentsProvider =
          Provider.of<TweetProvider>(context, listen: false);

      await commentsProvider.addComment(widget.id, comment);

      // Safely update state only if the widget is still mounted
      if (mounted) {
        setState(() {
          _commentCount = commentsProvider.comments.length;
        });
      }
    } catch (e) {
      print('Error in _addComment: $e');

      // Safely show a Snackbar if the widget is still mounted
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding comment: $e')),
        );
      }
    }
  }

  void _toggleLike(bool isLiked) async {
    setState(() {
      _isLiked = isLiked;
      _likeCount += isLiked ? 1 : -1;
    });

    try {
      await Provider.of<TweetProvider>(context, listen: false)
          .toggleLike(widget.id);
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLiked = !isLiked;
          _likeCount += isLiked ? -1 : 1; // Revert like count
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error toggling like: $e')),
        );
      }
    }
  }

  void _navigateToProfile(
      BuildContext context, String userId, bool isAnotherUser) {
    print(userId);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            ProfileScreen(id: userId, isAnotherUser: isAnotherUser),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author Info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: widget.isNavigate
                    ? () => _navigateToProfile(context, widget.authorId!, true)
                    : null,
                child: CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(widget.profileImage ?? ''),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: widget.isNavigate
                          ? () => _navigateToProfile(
                              context, widget.authorId!, true)
                          : null,
                      child: Text(
                        widget.authorName ?? '',
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge!
                            .copyWith(
                                fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 2),
                    GestureDetector(
                      onTap: widget.isNavigate
                          ? () => _navigateToProfile(context, widget.id!, true)
                          : null,
                      child: Text(
                        '@${widget.username}',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                widget.timestamp,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Colors.grey),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Tweet Content
          Text(
            widget.content ?? 'content not available',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontSize: 15, height: 1.5),
          ),

          const SizedBox(height: 16),

          // Actions: Like, Comment, Retweet, Share
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Like Button
              Tooltip(
                message: LocaleData.like.getString(context),
                child: ActionButton(
                  icon: LikeButton(
                    isLiked: _isLiked,
                    onLiked: _toggleLike, // Pass the callback function
                  ),
                  label: _likeCount.toString(),
                ),
              ),

              // Comment Button
              Tooltip(
                message: LocaleData.comments.getString(context),
                child: ActionButton(
                  icon: const Icon(Icons.comment, size: 20, color: Colors.grey),
                  label: _commentCount.toString(),
                  onTap: () => _openCommentSection(context),
                ),
              ),

              // Retweet Button
              Tooltip(
                message: LocaleData.rePost.getString(context),
                child: RePostButton(
                  tweetId: widget.id,
                  initialHasRetweeted: _initialHasRetweeted,
                  initialRetweetCount: _initialRetweetCount,
                ),
              ),

              // Share Button
              Tooltip(
                message: LocaleData.share.getString(context),
                child: IconButton(
                  icon: const Icon(Icons.share, size: 20, color: Colors.grey),
                  onPressed: () {
                    Share.share(
                      context.formatString(
                          LocaleData.sharePost.getString(context),
                          [widget.username, widget.content]),
                      subject: context.formatString(
                          LocaleData.postFrom.getString(context),
                          [widget.authorName]),
                    );
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
