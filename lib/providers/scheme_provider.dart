// import 'package:AgriGuide/services/feeds_service.dart';
import 'package:flutter/material.dart';
import 'package:AgriGuide/models/feeds_model.dart';

class SchemeProvider with ChangeNotifier {
  List<News> _schemes = [];
  bool _isLoading = false;

  List<News> get schemes => _schemes;
  bool get isLoading => _isLoading;

  Future<void> fetchSchemes() async {
    _isLoading = true;
    notifyListeners();
    try {
      // _schemes = await FeedsService.fetchSchemes();

      _schemes = [
        News(
          title: "PM Kisan Samman Nidhi",
          description:
              "The PM Kisan Samman Nidhi provides ₹6,000 per year in three installments to small and marginal farmers owning up to 2 hectares of land.",
          imageUrl:
              "https://via.placeholder.com/400x200?text=PM+Kisan+Samman+Nidhi", // Replace with actual image URLs
          date: "2024-11-01",
          sourceUrl: "https://pmkisan.gov.in/",
        ),
        News(
          title: "Kisan Credit Card Scheme",
          description:
              "The Kisan Credit Card Scheme offers loans up to ₹3 lakh at subsidized rates for purchasing seeds, fertilizers, and other inputs.",
          imageUrl:
              "https://via.placeholder.com/400x200?text=Kisan+Credit+Card+Scheme", // Replace with actual image URLs
          date: "2024-11-01",
          sourceUrl: "https://www.kisancreditcard.in/",
        ),
        News(
          title: "Soil Health Card Scheme",
          description:
              "The Soil Health Card Scheme encourages balanced use of fertilizers by providing soil testing services to all farmers.",
          imageUrl:
              "https://via.placeholder.com/400x200?text=Soil+Health+Card+Scheme", // Replace with actual image URLs
          date: "2024-11-01",
          sourceUrl: "https://www.soilhealth.dac.gov.in/",
        ),
        News(
          title: "Pradhan Mantri Fasal Bima Yojana",
          description:
              "The Pradhan Mantri Fasal Bima Yojana is a crop insurance scheme protecting farmers from losses due to natural calamities.",
          imageUrl:
              "https://via.placeholder.com/400x200?text=PM+Fasal+Bima+Yojana", // Replace with actual image URLs
          date: "2024-11-01",
          sourceUrl: "https://pmfby.gov.in/",
        ),
        News(
          title: "Atmanirbhar Krishi Yojana",
          description:
              "Atmanirbhar Krishi Yojana supports sustainable agriculture with subsidies for farm equipment and organic farming.",
          imageUrl:
              "https://via.placeholder.com/400x200?text=Atmanirbhar+Krishi+Yojana", // Replace with actual image URLs
          date: "2024-11-01",
          sourceUrl: "https://www.atmanirbharagriculture.gov.in/",
        ),
      ];
    } catch (error) {
      print('Error fetching schemes: $error');
    }
    _isLoading = false;
    notifyListeners();
  }
}
