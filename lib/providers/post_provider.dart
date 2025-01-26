import 'package:AgriGuide/models/comment.dart';
import 'package:AgriGuide/models/post_model.dart';
import 'package:AgriGuide/services/message_service.dart';
import 'package:AgriGuide/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TweetProvider with ChangeNotifier {
  static const storage = FlutterSecureStorage();

  final Map<String?, bool> _retweetedTweets = {};
  final Map<String?, int> _retweetCounts = {};
  List<Comment> _comments = [];
  List<Tweet> _tweets = [];

  bool hasRetweeted(String tweetId) => _retweetedTweets[tweetId] ?? false;
  int retweetCount(String tweetId) => _retweetCounts[tweetId] ?? 0;
  List<Comment> get comments => _comments;
  List<Tweet> get tweets => _tweets;

  // Loading state variables
  bool _isLoadingTweets = false;
  bool _isLoadingComments = false;
  bool _isLoadingMoreTweets = false; // Added for lazy loading
  bool get isLoadingTweets => _isLoadingTweets;
  bool get isLoadingComments => _isLoadingComments;
  bool get isLoadingMoreTweets => _isLoadingMoreTweets; // Added for lazy loading

  void setInitialTweetData(
      String tweetId, int retweetCount, bool hasRetweeted) {
    if (!_retweetCounts.containsKey(tweetId)) {
      _retweetCounts[tweetId] = retweetCount;
      _retweetedTweets[tweetId] = hasRetweeted;
    }
  }

  Future<void> fetchTweets({int start = 0, int limit = 10}) async {
    if (_isLoadingTweets || _isLoadingMoreTweets) return;
    
    if (start == 0) {
      _isLoadingTweets = true;
    } else {
      _isLoadingMoreTweets = true;
    }
    notifyListeners();

    final String? token = await storage.read(key: 'token');
    if (token == null) {
      _isLoadingTweets = false;
      _isLoadingMoreTweets = false;
      notifyListeners();
      throw Exception("Token is null");
    }

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/post/feed?start=$start&limit=$limit"),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          final List<Tweet> newTweets = data
              .map((tweet) {
                try {
                  return Tweet.fromJson(tweet);
                } catch (e) {
                  debugPrint("Error parsing tweet: $e");
                  return null; // Ignore malformed tweets
                }
              })
              .where((tweet) => tweet != null)
              .cast<Tweet>()
              .toList();
          
          if (start == 0) {
            _tweets = newTweets; // Initial fetch
          } else {
            _tweets.addAll(newTweets); // Append new tweets for lazy loading
          }
        } else {
          throw Exception("Unexpected response format");
        }
      } else {
        throw Exception("Failed to load tweets: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching tweets: $e");
      throw Exception("Failed to load tweets");
    } finally {
      _isLoadingTweets = false;
      _isLoadingMoreTweets = false;
      notifyListeners();
    }
  }

  // Toggle like functionality
  Future<void> toggleLike(String? tweetId) async {
    final String? token = await storage.read(key: 'token');
    if (tweetId == null) {
      throw Exception("Tweet ID is null");
    }

    try {
      final response = await http.put(
        Uri.parse("$baseUrl/post/like/$tweetId"),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        notifyListeners();
        MessageService.showSnackBar(response.body);
      } else {
        throw Exception("Failed to like/unlike tweet: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error toggling like: $e");
      MessageService.showSnackBar("Error: $e");
    }
  }

  // Add a new post functionality
  Future<Map<String, String>?> addPost(String content) async {
    final String? token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception("Token is null");
    }

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/post/"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'content': content}),
      );

      if (response.statusCode == 201) {
        notifyListeners();
        final responseData = jsonDecode(response.body);
        return {
          'postId': responseData['postId'],
          'authorName': responseData['authorName'],
        }; // Return the postId and author's name
      } else {
        MessageService.showSnackBar("Failed to create post");
        return null;
      }
    } catch (e) {
      debugPrint("Error adding post: $e");
      MessageService.showSnackBar("Error: $e");
      return null;
    }
  }

  // Fetch comments for a tweet
  Future<void> fetchComments(String? tweetId) async {
    _isLoadingComments = true;
    // notifyListeners();

    final String? token = await storage.read(key: 'token');
    if (token == null) {
      _isLoadingComments = false;
      notifyListeners();
      throw Exception("Token is null");
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/post/comments/$tweetId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _comments = data.map((comment) => Comment.fromJson(comment)).toList();
      } else {
        throw Exception('Failed to load comments');
      }
    } catch (error) {
      _isLoadingComments = false;
      notifyListeners();
      rethrow;
    } finally {
      _isLoadingComments = false;
      if (SchedulerBinding.instance.schedulerPhase != SchedulerPhase.idle) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifyListeners();
        });
      } else {
        notifyListeners();
      }
    }
  }

  // Add a new comment
  Future<void> addComment(String? tweetId, String content) async {
    final String? token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception("Token is null");
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/post/comments/add/$tweetId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'content': content}),
      );

      if (response.statusCode == 201) {
        final newComment = Comment.fromJson(json.decode(response.body));
        _comments.add(newComment);
        notifyListeners();
      } else {
        throw Exception("Failed to add comment");
      }
    } catch (error) {
      debugPrint("Error adding comment: $error");
      rethrow;
    }
  }

  // Retweet functionality
  Future<void> retweet(String? tweetId) async {
    final String? token = await storage.read(key: 'token');
    if (token == null || tweetId == null) {
      throw Exception("Token or Tweet ID is null");
    }

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/post/$tweetId/retweet"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 201) {
        _retweetedTweets[tweetId] = true;
        _retweetCounts[tweetId] = (_retweetCounts[tweetId] ?? 0) + 1;
        notifyListeners();
      } else {
        throw Exception("Failed to repost");
      }
    } catch (e) {
      debugPrint("Error reposting: $e");
      rethrow;
    }
  }

  Future<void> fetchMoreTweets() async {
    await fetchTweets(start: _tweets.length);
  }
}
