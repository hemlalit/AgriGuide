import 'package:AgriGuide/models/post_model.dart';
import 'package:AgriGuide/notifications/local_notifications/notification_controller.dart';
import 'package:AgriGuide/providers/theme_provider.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:AgriGuide/widgets/post_widgets/post_card.dart';
import 'package:AgriGuide/utils/helper_functions.dart';
import 'package:AgriGuide/models/comment.dart';
import 'package:provider/provider.dart';

class PostDetailScreen extends StatefulWidget {
  final Tweet tweet;

  const PostDetailScreen({super.key, required this.tweet});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  @override
  void initState() {
    super.initState();
    AwesomeNotifications().setListeners(
      onDismissActionReceivedMethod:
          NotificationController.onDismissedActionReceived,
      onActionReceivedMethod: NotificationController.onActionReceived,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Detail'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDarkMode
                  ? [
                      const Color.fromARGB(255, 0, 100, 0),
                      const Color.fromARGB(255, 0, 20, 0)
                    ]
                  : [Colors.lightGreen, const Color.fromARGB(255, 1, 128, 5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TweetCard(
                id: widget.tweet.id,
                authorId: widget.tweet.author!.id,
                isLiked: widget.tweet.likes!.contains(widget.tweet.author?.id),
                isNavigate: false,
                authorName: widget.tweet.author?.name ?? 'Unknown',
                username: widget.tweet.author?.username ?? 'Unknown',
                content: widget.tweet.content,
                timestamp: formatTimestamp(
                    context, widget.tweet.createdAt ?? DateTime.now()),
                profileImage: widget.tweet.author?.profileImage ?? '',
                initialLikeCount: widget.tweet.likes?.length,
                initialCommCount: widget.tweet.comments?.length,
                initialRetweetCount: widget.tweet.retweetCount,
                initialHasRetweeted:
                    widget.tweet.retweetedBy?.contains(widget.tweet.author?.id),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Comments',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...widget.tweet.comments!
                  .map((comment) => CommentCard(comment: comment)),
            ],
          ),
        ),
      ),
    );
  }
}

class CommentCard extends StatelessWidget {
  final Comment comment;

  const CommentCard({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(comment.commentedBy!.username ?? 'Unknown'),
        subtitle: Text(comment.content ?? 'No Content'),
        trailing: Text(
          formatTimestamp(context, comment.timestamp ?? DateTime.now()),
          // style: const TextStyle(
          //   color: Colors.green,
          // ),
        ),
      ),
    );
  }
}
