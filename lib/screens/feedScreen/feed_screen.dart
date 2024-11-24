import 'package:AgriGuide/screens/feedScreen/news_tab.dart';
import 'package:AgriGuide/screens/feedScreen/schemes_tab.dart';
import 'package:flutter/material.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: TabBar(
          labelColor: Colors.blue,
          tabs: [
            Tab(
              text: 'News',
            ),
            Tab(
              text: 'Gov. Schemes',
            ),
          ],
        ),
        body: TabBarView(
          children: <Widget>[
            NewsTab(),
            SchemesTab(),
          ],
        ),
      ),
    );
  }
}
