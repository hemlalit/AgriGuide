import 'dart:convert';
import 'package:AgriGuide/providers/post_provider.dart';
import 'package:AgriGuide/providers/theme_provider.dart';
import 'package:AgriGuide/screens/postScreen/create_new_post.dart';
import 'package:AgriGuide/screens/postScreen/post_detail_screen.dart';
import 'package:AgriGuide/utils/constants.dart';
import 'package:AgriGuide/utils/helper_functions.dart';
import 'package:AgriGuide/utils/theme.dart';
import 'package:AgriGuide/widgets/post_widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  final ScrollController _scrollController = ScrollController();
  static const storage = FlutterSecureStorage();

  String? userId;
  bool _isLoadingMore = false;

  Future<void> fetchUser() async {
    final user = await storage.read(key: 'userData');
    print(user);

    if (user != null) {
      final Map<String, dynamic> userData = jsonDecode(user);
      setState(() {
        userId = userData['_id'];
      });
    } else {
      print('No user data found');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUser();
    _fetchInitialTweets();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _fetchInitialTweets() async {
    final tweetProvider = Provider.of<TweetProvider>(context, listen: false);
    if (tweetProvider.tweets.isEmpty) {
      await tweetProvider.fetchTweets();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoadingMore) {
      setState(() {
        _isLoadingMore = true;
      });
      final tweetProvider = Provider.of<TweetProvider>(context, listen: false);
      tweetProvider.fetchMoreTweets().then((_) {
        setState(() {
          _isLoadingMore = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tweetProvider = Provider.of<TweetProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _isLoadingMore = false; // Reset loading state on refresh
          });
          await tweetProvider.fetchTweets();
        },
        child: tweetProvider.isLoadingTweets
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                thickness: 4.0,
                radius: const Radius.circular(2.0),
                child: ListView.builder(
                  key: PageStorageKey<String>('tweetList'),
                  controller: _scrollController,
                  padding: globalPadding,
                  itemCount:
                      tweetProvider.tweets.length + (_isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == tweetProvider.tweets.length) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final tweet = tweetProvider.tweets[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (context) =>
                                PostDetailScreen(tweet: tweet),
                          ),
                        );
                      },
                      child: TweetCard(
                        id: tweet.id,
                        authorId: tweet.author!.id,
                        isLiked: tweet.likes!.contains(userId),
                        isNavigate: true,
                        authorName: tweet.author?.name ?? 'Unknown',
                        username: tweet.author?.username ?? 'Unknown',
                        content: tweet.content,
                        timestamp: formatTimestamp(
                            context, tweet.createdAt ?? DateTime.now()),
                        profileImage: tweet.author?.profileImage ?? '',
                        initialLikeCount: tweet.likes?.length,
                        initialCommCount: tweet.comments?.length,
                        initialRetweetCount: tweet.retweetCount,
                        initialHasRetweeted:
                            tweet.retweetedBy?.contains(tweet.author?.id),
                      ),
                    );
                  },
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute<bool>(
                builder: (context) => const CreatePostScreen()),
          );
          if (result == true) {
            // Refresh tweets after popping
            tweetProvider.fetchTweets();
          }
        },
        backgroundColor: isDarkMode ? AppTheme.darkBtnColor : Colors.green,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
        child: const Icon(Icons.add),
      ),
    );
  }
}
