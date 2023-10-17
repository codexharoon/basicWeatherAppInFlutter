import 'package:basic_weather_app/models/weather_model.dart';
import 'package:basic_weather_app/service/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  final weatherService = WeatherService('d472af8c71b0874d1db16c165316e024');

  Weather? _weather;

  fetchWeather() async {
    String cityName = await weatherService.getCurrentCity();

    try{
      final weather = await weatherService.getWeather(cityName);

      setState(() {
        _weather = weather;
      });
    }
    catch(error){
      throw Exception(error);
    }

  }

  String getWeatherAnimations(String? mainCondition){
    switch(mainCondition?.toLowerCase()){
      case 'cloud':
      case 'smoke':
      case 'fog':
        return 'assets/cloud.json';
      case'rain':
       return 'assets/rain.json';
      case'thunderstrom':
       return 'assets/thunder.json';
      case'clear':
       return 'assets/sun.json';
      default:
        return 'assets/cloud.json';
    }
  }


  @override
  void initState() {
    fetchWeather();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(  
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            Text('City: ${_weather?.cityName ?? 'loading city...'}'),

            Lottie.asset(getWeatherAnimations(_weather?.mainCondition)),

            Text('Temprature: ${_weather?.temprature.round() ?? 'loading...'}'),
        
          ],
        ),
      ),
    );
  }
}