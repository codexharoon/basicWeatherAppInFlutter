import 'dart:convert';
import 'package:basic_weather_app/models/weather_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class WeatherService{
  // static const String baseURL = '';
  final String apiKey;

  WeatherService(this.apiKey);


  Future<Weather> getWeather(String cityName) async {
    final response = await http.get(Uri.parse('http://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey'));

    if(response.statusCode == 200){
      return Weather.fromJson(jsonDecode(response.body));
    }
    else{
     throw Exception('Failed to load weather data');
    }
  }


  Future<String> getCurrentCity() async {

    // get location permission from user
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
    }


    // get the current location
    Position position = await Geolocator.getCurrentPosition();
    // make list of placemark objects
    List<Placemark> placemark = await placemarkFromCoordinates(position.latitude, position.longitude);
    // extract city from first placemark
    return placemark[0].locality ?? "";
  }
}