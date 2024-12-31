import 'package:flutter/material.dart';

class CommentCard extends StatelessWidget {
  final String content;
  final String username;
  final String timestamp;

  const CommentCard({
    super.key,
    required this.content,
    required this.username,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    final Color secondaryColor = Theme.of(context).textTheme.bodyMedium!.color!;

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '@$username',
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              timestamp,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontSize: 12, color: secondaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
