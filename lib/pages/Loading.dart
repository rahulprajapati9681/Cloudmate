import 'package:flutter/material.dart';
import 'package:weather/worker/worker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weather/pages/ErrorPage.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  String city = "Delhi";   // Default city
  String? temp;
  String? hum;
  String? air_speed;
  String? desc;
  String? main;
  String? icon;
  bool isCityValid = true;

  void getCityAndStartApp() {
    var route = ModalRoute.of(context);
    if (route != null && route.settings.arguments != null) {
      Map<String, dynamic> search = route.settings.arguments as Map<String, dynamic>;
      city = search["new_city"] ?? "Delhi";
    }
    startApp();
  }

  void startApp() async {
    worker instance = worker(location: city);
    await instance.getData();

    if (instance.isCityValid) {
      // ✅ City is valid → Navigate to Home
      temp = instance.temperature;
      hum = instance.humidity;
      air_speed = instance.air_speed;
      desc = instance.description;
      main = instance.main;
      icon = instance.icon;

      // Navigator.pushReplacementNamed(context, '/Home', arguments: {
      //   "temp_value": temp,
      //   "hum_value": hum,
      //   "air_speed_value": air_speed,
      //   "desc_value": desc,
      //   "main_value": main,
      //   "icon_value": icon,
      //   "city_value": city,
      // });

      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacementNamed(context, '/Home', arguments: {
          "temp_value": temp,
          "hum_value": hum,
          "air_speed_value": air_speed,
          "desc_value": desc,
          "main_value": main,
          "icon_value": icon,
          "city_value": city,
        });

      });
      
    } else {
      // ❌ Invalid city → Show error page
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ErrorPage(city: city),
          ),
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getCityAndStartApp());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2196F3),   // Blue
              Color(0xFF64B5F6),   // Light Blue
              Color(0xFFBBDEFB),   // Sky Blue
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/images/Logo.png",
                width: 200,
                height: 150,
                fit: BoxFit.contain,
              ),
              SpinKitThreeInOut(
                color: Colors.white,
                size: 50.0,
              ),
              const SizedBox(height: 20),
              const Text(
                " CloudMate",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
