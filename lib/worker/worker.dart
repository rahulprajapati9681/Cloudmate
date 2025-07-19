import 'package:http/http.dart';
import 'dart:convert';

class worker {
  String? location;

  // Constructor
  worker({this.location});

  String? temperature; // °C
  String? humidity;    // %
  String? air_speed;   // Km/h
  String? description;
  String? main;
  String? icon;
  bool isCityValid = true;  // ✅ Track valid/invalid city

  Future<void> getData() async {
    try {
      var url = Uri.parse('USE YOUR OPENWEATHER API HERE'); // Paste your API Key Here
      Response response = await get(url);

      if (response.statusCode == 200) {
        // ✅ City found
        Map data = jsonDecode(response.body);

        // Extracting data
        Map temp_data = data['main'];
        double get_temp = temp_data['temp'] - 273.15;
        String get_humidity = temp_data['humidity'].toString();

        List weather_list = data['weather'];
        Map weather_dict = weather_list[0];
        String get_weather_main = weather_dict['main'];
        String get_weather_desc = weather_dict['description'];
        String get_icon = weather_dict["icon"].toString();

        Map wind = data['wind'];
        double get_air_speed = wind['speed'] * 3.6;

        // Assigning values
        temperature = get_temp.toStringAsFixed(1);
        humidity = get_humidity;
        air_speed = get_air_speed.toStringAsFixed(1);
        description = get_weather_desc;
        main = get_weather_main;
        icon = get_icon;
        isCityValid = true;  // ✅ Valid city

      } else {
        // ❌ Invalid city (404)
        isCityValid = false;
      }
    } catch (e) {
      print("Error: $e");
      isCityValid = false;
    }
  }
}
