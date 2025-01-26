import 'package:AgriGuide/models/weather_data.dart';
import 'package:AgriGuide/services/weather_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class WeatherController extends GetxController {
  final RxBool _isLoading = true.obs;
  final RxDouble _latitude = 0.0.obs;
  final RxDouble _longitude = 0.0.obs;
  final RxInt _currentIndex = 0.obs;
  final Rx<WeatherData> weatherData = WeatherData().obs;

  RxBool checkloading() => _isLoading;
  RxDouble getLattitude() => _latitude;
  RxDouble getLongitude() => _longitude;

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

  Future<void> getLocation() async {
    bool isServiceEnabled;
    LocationPermission locationPermission;

    isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      return Future.error('Location services are disabled.');
    }

    locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are denied forever.');
    } else if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings);
    _latitude.value = position.latitude;
    _longitude.value = position.longitude;

    await fetchWeatherData();
  }

  Future<void> fetchWeatherData() async {
    try {
      final WeatherData fetchedData = await FetchWeather()
          .proccessData(_latitude.value, _longitude.value);
      weatherData.value = fetchedData;
      _isLoading.value = false;
    } catch (e) {
      _isLoading.value = false;
      rethrow;
    }
  }

  RxInt getIndex() {
    return _currentIndex;
  }
}
