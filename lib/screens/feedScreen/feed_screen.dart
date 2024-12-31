import 'package:AgriGuide/localization/locales.dart';
import 'package:AgriGuide/screens/feedScreen/news_tab.dart';
import 'package:AgriGuide/screens/feedScreen/schemes_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: TabBar(
          labelColor: Colors.blue,
          tabs: [
            Tab(
              text: LocaleData.news.getString(context),
            ),
            Tab(
              text: LocaleData.govSchemes.getString(context),
            ),
          ],
        ),
        body: const TabBarView(
          children: <Widget>[
            NewsTab(),
            SchemesTab(),
          ],
        ),
      ),
    );
  }
}
