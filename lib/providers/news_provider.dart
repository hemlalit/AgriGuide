import 'package:flutter/material.dart';
import 'package:AgriGuide/models/feeds_model.dart';

class NewsProvider with ChangeNotifier {
  List<News> _news = [];

  bool _isLoading = false;

  List<News> get news => _news;
  bool get isLoading => _isLoading;

  Future<void> fetchNews() async {
    _isLoading = true;
    notifyListeners();
    try {
      // _news = await FeedsService.fetchNews();

      _news = [
        News(
          title: "Farmers Receive Record High Subsidies",
          description:
              "The government has announced a record high subsidy for farmers to boost agricultural production in the upcoming season.",
          imageUrl: "https://via.placeholder.com/400x200?text=Farmers+Subsidy",
          date: "November 1, 2024",
        ),
        News(
          title: "New Climate Resilient Crops Introduced",
          description:
              "Agricultural scientists have developed new crops resistant to extreme weather, ensuring better yields for farmers.",
          imageUrl: "https://via.placeholder.com/400x200?text=Resilient+Crops",
          date: "October 28, 2024",
        ),
        News(
          title: "AgriGuide Launches New AI-Based Tool",
          description:
              "AgriGuide introduces an AI-powered tool to help farmers monitor crop health in real-time using satellite imagery.",
          imageUrl: "https://via.placeholder.com/400x200?text=AgriGuide+AI",
          date: "October 15, 2024",
        ),
        News(
          title: "Organic Farming: A Growing Trend",
          description:
              "More farmers are transitioning to organic farming techniques due to increasing consumer demand for organic produce.",
          imageUrl: "https://via.placeholder.com/400x200?text=Organic+Farming",
          date: "October 10, 2024",
        ),
        News(
          title: "Monsoon Forecast Promises Abundant Rainfall",
          description:
              "The latest monsoon forecast predicts above-average rainfall, bringing relief to drought-hit regions.",
          imageUrl: "https://via.placeholder.com/400x200?text=Monsoon+Forecast",
          date: "October 5, 2024",
        ),
      ];
    } catch (error) {
      print('Error fetching news: $error');
    }
    _isLoading = false;
    notifyListeners();
  }
}
