import 'package:AgriGuide/localization/locales.dart';
import 'package:AgriGuide/providers/post_provider.dart';
import 'package:AgriGuide/utils/constants.dart';
import 'package:AgriGuide/utils/read_user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _tweetController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isSubmitting = false;
  final int _characterLimit = 280;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _tweetController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleData.newPost.getString(context)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightGreen, Color.fromARGB(255, 1, 128, 5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _tweetController,
              focusNode: _focusNode,
              maxLength: _characterLimit,
              maxLines: null,
              decoration: InputDecoration(
                hintText: LocaleData.whatsHappening.getString(context),
                border: InputBorder.none,
              ),
              onChanged: (text) {
                setState(() {});
              },
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${_tweetController.text.length} / $_characterLimit",
                  style: TextStyle(
                    color: _tweetController.text.length > _characterLimit
                        ? Colors.red
                        : Colors.grey,
                  ),
                ),
                _isSubmitting
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _isSubmitting
                            ? null
                            : () {
                                _submitTweet(context, _tweetController.text);
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: Text(
                          LocaleData.post.getString(context),
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitTweet(BuildContext context, String tweetContent) async {
    if (_validateTweet(context, tweetContent)) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        final data = await Provider.of<TweetProvider>(context, listen: false)
            .addPost(tweetContent);
        if (data != null) {
          final postId = data['postId'];
          final authorName = data['authorName'];

          String? fcmToken = await storage.read(key: 'fcmToken');
          if (fcmToken != null && postId != null) {
            await _sendNotification(
                'New Post', 'Check out the new post by $authorName!', fcmToken, postId);
          }

          _tweetController.clear();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(LocaleData.postSuccess.getString(context))),
          );

          Navigator.pop(context, true);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to post Tweet: $e")),
        );
      } finally {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  bool _validateTweet(BuildContext context, String tweetContent) {
    if (tweetContent.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LocaleData.postEmpty.getString(context))),
      );
      return false;
    }

    if (tweetContent.length > _characterLimit) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LocaleData.postChars.getString(context))),
      );
      return false;
    }

    return true;
  }

  Future<void> _sendNotification(
      String title, String body, String authorToken, String postId) async {
    const url = '$baseUrl/sendNotification/post';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': title,
          'body': body,
          'authorToken': authorToken,
          'postId': postId,
        }),
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully');
      } else {
        print('Failed to send notification: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }
}
