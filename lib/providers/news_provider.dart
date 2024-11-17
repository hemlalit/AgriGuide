import 'package:AgriGuide/services/feeds_service.dart';
import 'package:flutter/material.dart';
import 'package:AgriGuide/models/news_model.dart';

class NewsProvider with ChangeNotifier {
  List<News> _news = [];
  bool _isLoading = false;

  List<News> get news => _news;
  bool get isLoading => _isLoading;

  Future<void> fetchNews() async {
    _isLoading = true;
    notifyListeners();
    try {
      _news = await FeedsService.fetchNews();
    } catch (error) {
      print('Error fetching news: $error');
    }
    _isLoading = false;
    notifyListeners();
  }
}
