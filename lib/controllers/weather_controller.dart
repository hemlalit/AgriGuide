import 'package:AgriGuide/models/weather_data.dart';
import 'package:AgriGuide/services/weather_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class WeatherController extends GetxController {
  final RxBool _isLoading = true.obs;
  final RxDouble _latitude = 0.0.obs;
  final RxDouble _longitude = 0.0.obs;
  final RxInt _currentIndex = 0.obs;

  RxBool checkloading() => _isLoading;
  RxDouble getLattitude() => _latitude;
  RxDouble getLongitude() => _longitude;

  final weatherData = WeatherData().obs;

  WeatherData getData() {
    return weatherData.value;
  }

  @override
  void onInit() {
    if (_isLoading.isTrue) {
      getLocation();
    } else {
      getIndex();
    }

    super.onInit();
  }

  final LocationSettings locationSettings =
      const LocationSettings(accuracy: LocationAccuracy.high);

  getLocation() async {
    bool isServiceEnabled;
    LocationPermission locationPermission;

    isServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isServiceEnabled) {
      return Future.error('Location is enabled');
    }

    locationPermission = await Geolocator.checkPermission();
    print(locationPermission);

    if (locationPermission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are denied forever');
    } else if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        return Future.error('Location permission is denied');
      }
    }

    return await Geolocator.getCurrentPosition(
            locationSettings: locationSettings)
        .then((value) {
      _latitude.value = value.latitude;
      _longitude.value = value.longitude;

      return FetchWeather()
          .proccessData(value.latitude, value.longitude)
          .then((value) {
        weatherData.value = value;
        _isLoading.value = false;
      });
    });
  }

  RxInt getIndex() {
    return _currentIndex;
  }
}
