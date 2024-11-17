import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:AgriGuide/providers/news_provider.dart';
import 'package:AgriGuide/providers/scheme_provider.dart';
import 'package:AgriGuide/widgets/news_item.dart';
import 'package:AgriGuide/widgets/scheme_item.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<NewsProvider>(context, listen: false).fetchNews();
    Provider.of<SchemeProvider>(context, listen: false).fetchSchemes();
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);
    final schemeProvider = Provider.of<SchemeProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Latest News', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (newsProvider.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (newsProvider.news.isEmpty)
              const Center(child: Text('No news available'))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: newsProvider.news.length,
                itemBuilder: (context, index) => NewsItem(news: newsProvider.news[index]),
              ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Icon(Icons.local_florist, color: Colors.green[800]),
                const SizedBox(width: 8),
                const Text('Government Schemes', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            if (schemeProvider.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (schemeProvider.schemes.isEmpty)
              const Center(child: Text('No schemes available'))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: schemeProvider.schemes.length,
                itemBuilder: (context, index) => SchemeItem(scheme: schemeProvider.schemes[index]),
              ),
          ],
        ),
      ),
    );
  }
}
