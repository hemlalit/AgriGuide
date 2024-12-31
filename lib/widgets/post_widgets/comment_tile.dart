import 'package:AgriGuide/models/comment.dart';
import 'package:flutter/material.dart';

class CommentTile extends StatelessWidget {
  final Comment comment;

  const CommentTile({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(
          comment.commentedBy?.name?.substring(0, 1).toUpperCase() ?? 'U',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(
        comment.commentedBy?.name ?? 'username',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      subtitle: Text(
        comment.content ?? 'content',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: Text(
        comment.timestamp?.toLocal().toString().split(' ')[0] ?? 'timestamp',
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
