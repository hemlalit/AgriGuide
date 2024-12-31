import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:AgriGuide/providers/post_provider.dart';

class RePostButton extends StatelessWidget {
  final String? tweetId;
  final bool initialHasRetweeted;
  final int initialRetweetCount;

  const RePostButton({
    super.key,
    required this.tweetId,
    required this.initialHasRetweeted,
    required this.initialRetweetCount,
  });

  @override
  Widget build(BuildContext context) {
    final tweetProvider = Provider.of<TweetProvider>(context);

    // Set initial retweet state and count in the provider if not already set
    tweetProvider.setInitialTweetData(
      tweetId!,
      initialRetweetCount,
      initialHasRetweeted,
    );

    final hasRetweeted = tweetProvider.hasRetweeted(tweetId!);
    final retweetCount = tweetProvider.retweetCount(tweetId!);

    return GestureDetector(
      onTap: () async {
        if (!hasRetweeted) {
          try {
            await tweetProvider.retweet(tweetId!);
          } catch (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Failed to repost!")),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("You already retweeted this post!")),
          );
        }
      },
      child: Row(
        children: [
          Icon(
            Icons.repeat,
            size: 20,
            color: hasRetweeted ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(retweetCount.toString()),
        ],
      ),
    );
  }
}
