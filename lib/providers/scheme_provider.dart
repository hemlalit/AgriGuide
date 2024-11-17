import 'package:AgriGuide/services/feeds_service.dart';
import 'package:flutter/material.dart';
import 'package:AgriGuide/models/scheme_model.dart';

class SchemeProvider with ChangeNotifier {
  List<Scheme> _schemes = [];
  bool _isLoading = false;

  List<Scheme> get schemes => _schemes;
  bool get isLoading => _isLoading;

  Future<void> fetchSchemes() async {
    _isLoading = true;
    notifyListeners();
    try {
      _schemes = await FeedsService.fetchSchemes();
    } catch (error) {
      print('Error fetching schemes: $error');
    }
    _isLoading = false;
    notifyListeners();
  }
}
