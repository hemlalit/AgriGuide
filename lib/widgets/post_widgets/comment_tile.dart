import 'package:AgriGuide/models/comment.dart';
import 'package:AgriGuide/services/translator.dart';
import 'package:AgriGuide/utils/helper_functions.dart';
import 'package:AgriGuide/utils/read_user_data.dart';
import 'package:flutter/material.dart';

class CommentTile extends StatefulWidget {
  final Comment comment;

  const CommentTile({super.key, required this.comment});

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  String commentContent = '';

  @override
  void initState() {
    super.initState();
    _translateComment();
  }

  Future<void> _translateComment() async {
    String fromLanguage = 'en';
    final toLanguage = await storage.read(key: 'ln') ?? 'en';
    String content = await TranslationService()
        .translateText(widget.comment.content, fromLanguage, toLanguage);
    setState(() {
      commentContent = content;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(
          widget.comment.commentedBy?.name?.substring(0, 1).toUpperCase() ?? 'U',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(
        widget.comment.commentedBy?.name ?? 'username',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      subtitle: Text(
        commentContent,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: Text(
        formatTimestamp(context, widget.comment.timestamp!),
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
