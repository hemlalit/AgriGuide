import 'dart:convert';
import 'package:AgriGuide/localization/locales.dart';
import 'package:AgriGuide/providers/post_provider.dart';
import 'package:AgriGuide/screens/hamburger_menu/edit_profile_screen.dart';
import 'package:AgriGuide/services/translator.dart';
import 'package:AgriGuide/utils/constants.dart';
import 'package:AgriGuide/utils/helper_functions.dart';
import 'package:AgriGuide/utils/read_user_data.dart';
import 'package:AgriGuide/widgets/divider_line.dart';
import 'package:AgriGuide/widgets/post_widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final String id;
  final bool isAnotherUser;

  const ProfileScreen({
    super.key,
    required this.id,
    required this.isAnotherUser,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  Map<String, dynamic>? userData;
  String? loginedUserId;
  String bio = '';

  Future<void> fetchUser() async {
    final user = await storage.read(key: 'userData');
    print(user);

    if (user != null) {
      final Map<String, dynamic> userData = jsonDecode(user);
      String fromLanguage = 'en';
      final toLanguage = await storage.read(key: 'ln');
      String content = await TranslationService()
          .translateText(userData['bio'], fromLanguage, toLanguage);
      setState(() {
        if (!widget.isAnotherUser) {
          loginedUserId = userData['_id'];
          bio = content;
        } else {
          widget.id == userData['_id'] ? loginedUserId = userData['_id'] : null;
        }

        print(userData['_id'] + ' *  ' + widget.id);
        // if (loginedUserId == widget.id) {}
      });
    } else {
      print('No user data found');
    }
  }

  @override
  void initState() {
    super.initState();
    print('hii');
    fetchUser();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    userData = null; // Clear the userData
    super.dispose();
  }

  void _navigateBack(BuildContext context) {
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(180),
        child: Stack(
          children: [
            // Background Banner
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.green[700],
                image: const DecorationImage(
                  image: NetworkImage(
                      'https://via.placeholder.com/500x200.png?text=Banner+Image'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 16,
              child: widget.isAnotherUser
                  ? Container()
                  : IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfileScreen(
                              id: widget.id,
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Positioned(
              top: 40,
              left: 16,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => _navigateBack(context),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: FutureBuilder<Map<String, dynamic>?>(
          future: widget.isAnotherUser
              ? readAnotherUserData(context, widget.id)
              : readData(context, 'userData'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(
                  child:
                      Text('No user data available! Please try again later'));
            }

            userData = snapshot.data;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Information Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Avatar
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 38,
                          backgroundImage: NetworkImage(
                            userData?['profileImage'] ??
                                'https://via.placeholder.com/150.png?text=Profile+Image',
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Padding(
                        padding: const EdgeInsets.only(top: 13),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userData?['name'] ?? 'Unknown', // User name
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Row(
                              children: [
                                Text(
                                  '@${userData?['username'] ?? 'unknown'}', // Username
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 13),
                                  child: loginedUserId != widget.id
                                      ? ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            minimumSize: const Size(30, 10),
                                          ),
                                          onPressed: () {},
                                          child: Text(
                                            LocaleData.follow
                                                .getString(context),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        )
                                      : null,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, top: 30),
                  child: userData?['bio'] != ''
                      ? Text(
                          bio != '' ? bio : userData?['bio'],
                        )
                      : const Text(
                          "No Bio",
                          style: TextStyle(color: Colors.grey),
                        ),
                ),
                // Followers and Following Row
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInfoColumn(LocaleData.followers.getString(context),
                          '${userData?['followers']?.length ?? 0}'),
                      DividerLine().verticalDividerLine(context),
                      _buildInfoColumn(LocaleData.following.getString(context),
                          '${userData?['following']?.length ?? 0}'),
                    ],
                  ),
                ),
                // TabBar Section
                TabBar(
                  controller: _tabController,
                  labelColor: Colors.green[700],
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.green[700],
                  tabs: [
                    Tab(text: LocaleData.posts.getString(context)),
                    Tab(text: LocaleData.likes.getString(context)),
                    Tab(text: LocaleData.rePosts.getString(context)),
                    Tab(text: LocaleData.comments.getString(context)),
                  ],
                ),
                // TabBarView Section
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildPostList("Posts"),
                      _buildLikesList("Likes"),
                      _buildRePostsList("Reposts"),
                      _buildCommentsPostList("Comments"),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String title, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildPostList(String title) {
    final tweetProvider = Provider.of<TweetProvider>(context);

    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      thickness: 4.0,
      radius: const Radius.circular(2.0),
      child: ListView.builder(
        padding: globalPadding,
        itemCount: tweetProvider.tweets.length,
        itemBuilder: (context, index) {
          final tweet = tweetProvider.tweets[index];
          if (tweet.author!.id == widget.id) {
            return TweetCard(
              id: tweet.id,
              authorId: tweet.author!.id,
              isLiked: tweet.likes!.contains(widget.id),
              isNavigate: false,
              authorName: tweet.author?.name ?? 'Unknown',
              username: tweet.author?.username ?? 'Unknown',
              content: tweet.content,
              timestamp:
                  formatTimestamp(context, tweet.createdAt ?? DateTime.now()),
              profileImage: tweet.author?.profileImage ?? '',
              initialLikeCount: tweet.likes?.length,
              initialCommCount: tweet.comments?.length,
              initialRetweetCount: tweet.retweetCount,
              initialHasRetweeted:
                  tweet.retweetedBy?.contains(tweet.author?.id),
            );
          } else {
            return Container(); // Default return value for tweets not matching the condition
          }
        },
      ),
    );
  }

  Widget _buildCommentsPostList(String title) {
    final tweetProvider = Provider.of<TweetProvider>(context);

    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      thickness: 4.0,
      radius: const Radius.circular(2.0),
      child: ListView.builder(
        padding: globalPadding,
        itemCount: tweetProvider.tweets.length,
        itemBuilder: (context, index) {
          final tweet = tweetProvider.tweets[index];
          print(tweet.comments != null);
          if (tweet.comments != null && tweet.comments!.isNotEmpty) {
            for (var comment in tweet.comments!) {
              if (comment.commentedBy!.id == widget.id) {
                print(loginedUserId);
                return TweetCard(
                  id: tweet.id,
                  authorId: tweet.author!.id,
                  isLiked: tweet.likes!.contains(widget.id),
                  isNavigate: false,
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
                );
              }
            }
          }
          return Container(); // Default return value for tweets not matching the condition
        },
      ),
    );
  }

  Widget _buildRePostsList(String title) {
    final tweetProvider = Provider.of<TweetProvider>(context);

    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      thickness: 4.0,
      radius: const Radius.circular(2.0),
      child: ListView.builder(
        padding: globalPadding,
        itemCount: tweetProvider.tweets.length,
        itemBuilder: (context, index) {
          final tweet = tweetProvider.tweets[index];
          if (tweet.retweetedBy!.contains(widget.id)) {
            return TweetCard(
              id: tweet.id,
              authorId: tweet.author!.id,
              isLiked: tweet.likes!.contains(widget.id),
              isNavigate: false,
              authorName: tweet.author?.name ?? 'Unknown',
              username: tweet.author?.username ?? 'Unknown',
              content: tweet.content,
              timestamp:
                  formatTimestamp(context, tweet.createdAt ?? DateTime.now()),
              profileImage: tweet.author?.profileImage ?? '',
              initialLikeCount: tweet.likes?.length,
              initialCommCount: tweet.comments?.length,
              initialRetweetCount: tweet.retweetCount,
              initialHasRetweeted:
                  tweet.retweetedBy?.contains(tweet.author?.id),
            );
          } else {
            return Container(); // Default return value for tweets not matching the condition
          }
        },
      ),
    );
  }

  Widget _buildLikesList(String title) {
    final tweetProvider = Provider.of<TweetProvider>(context);

    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      thickness: 4.0,
      radius: const Radius.circular(2.0),
      child: ListView.builder(
        padding: globalPadding,
        itemCount: tweetProvider.tweets.length,
        itemBuilder: (context, index) {
          final tweet = tweetProvider.tweets[index];
          if (tweet.likes!.contains(widget.id)) {
            return TweetCard(
              id: tweet.id,
              authorId: tweet.author!.id,
              isLiked: tweet.likes!.contains(userData!['_id']),
              isNavigate: false,
              authorName: tweet.author?.name ?? 'Unknown',
              username: tweet.author?.username ?? 'Unknown',
              content: tweet.content,
              timestamp:
                  formatTimestamp(context, tweet.createdAt ?? DateTime.now()),
              profileImage: tweet.author?.profileImage ?? '',
              initialLikeCount: tweet.likes?.length,
              initialCommCount: tweet.comments?.length,
              initialRetweetCount: tweet.retweetCount,
              initialHasRetweeted:
                  tweet.retweetedBy?.contains(tweet.author?.id),
            );
          } else {
            return Container(); // Default return value for tweets not matching the condition
          }
        },
      ),
    );
  }
}
