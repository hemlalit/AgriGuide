import 'package:AgriGuide/controllers/weather_controller.dart';
import 'package:AgriGuide/services/translator.dart';
import 'package:AgriGuide/utils/read_user_data.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class headerWidget extends StatefulWidget {
  const headerWidget({super.key});

  @override
  State<headerWidget> createState() => _headerWidgetState();
}

class _headerWidgetState extends State<headerWidget> {
  String city = '';
  String date = DateFormat('yMMMMd').format(DateTime.now());
  final WeatherController weatherController =
      Get.put(WeatherController(), permanent: true);

  void getAdress(lat, lon) async {
    List<Placemark> placemark = await placemarkFromCoordinates(lat, lon);
    Placemark place = placemark[0];
    String fromLanguage = 'en';
    final toLanguage = await storage.read(key: 'ln');
    // print(toLanguage);
    String translatedtext = await TranslationService()
        .translateText(place.locality!, fromLanguage, toLanguage);
    String translatedDate = await TranslationService()
        .translateText(date, fromLanguage, toLanguage);
    setState(() {
      city = translatedtext;
      date = translatedDate;
    });
  }

  @override
  void initState() {
    getAdress(weatherController.getLattitude().value,
        weatherController.getLongitude().value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          alignment: Alignment.topLeft,
          child: Text(
            city,
            style: const TextStyle(fontSize: 35, height: 2),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          alignment: Alignment.topLeft,
          child: Text(
            date,
            style:
                TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.5),
          ),
        ),
      ],
    );
  }
}
