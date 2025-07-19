import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = new TextEditingController();
  Timer? _timer;  // ✅ Use nullable Timer for safety
  String hint = "hi";

  @override
  void initState() {
    super.initState();
    print("init state called");
    _startHintChanger();   // ✅ Start the hint changer
  }

  void _startHintChanger() {
    const Hint_text = [
      // 🇮🇳 Indian Cities
      "Mumbai", "Delhi", "Bangalore", "Hyderabad", "Chennai", "Kolkata",
      "Jaipur", "Pune", "Lucknow", "Chandigarh", "Ahmedabad", "Goa",
      "Shimla", "Kochi", "Bhopal", "Indore", "Surat", "Patna", "Nagpur",
      "Visakhapatnam", "Agra", "Varanasi", "Amritsar", "Guwahati",

      // 🌍 Overseas Cities
      "New York", "Los Angeles", "London", "Paris", "Berlin", "Tokyo",
      "Dubai", "Toronto", "Sydney", "Singapore", "Bangkok", "Istanbul",
      "Rome", "Barcelona", "Amsterdam", "Seoul", "Hong Kong", "Moscow",
      "Cairo", "Mexico City", "Cape Town", "Kuala Lumpur"
    ];

    final _random = Random();

    // Set initial hint
    hint = Hint_text[_random.nextInt(Hint_text.length)];

    // Change the hint every 2 seconds
    _timer = Timer.periodic(Duration(seconds: 4), (timer) {
      if (mounted) {   // ✅ Check if widget is mounted before calling setState()
        setState(() {
          hint = Hint_text[_random.nextInt(Hint_text.length)];
        });
      }
    });
  }

  @override
  void dispose() {
    // ✅ Null check before cancelling timer
    _timer?.cancel();
    super.dispose();
    print("dispose state called");
  }

  @override
  Widget build(BuildContext context) {
    var route = ModalRoute.of(context);
    if (route == null || route.settings.arguments == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Home Page"),
        ),
        body: Center(
          child: Text("Can't fetch API"),
        ),
      );
    }

    Map<String, dynamic> info = route.settings.arguments as Map<String, dynamic>;
    String icon = info["icon_value"].toString();
    String city = info["city_value"];


    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: AppBar(
            backgroundColor: Color(0xFF2196F3),
          )),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF2196F3),   // Blue
                Color(0xFF64B5F6),   // Light Blue
                Color(0xFFBBDEFB),   // Sky Blue
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
            ),
          ),
          child: Column(
            children: [
              // ======================= Search Bar =======================
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    // Search Icon (Tapping the Icon)
                    GestureDetector(
                      onTap: () {
                        if (searchController.text.isNotEmpty) {
                          Navigator.pushNamed(context, "/Loading", arguments: {
                            "new_city": searchController.text
                          });
                          print("Search triggered by icon: ${searchController.text}");
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(3, 0, 7, 0),
                        child: Icon(Icons.search, color: Colors.blueAccent),
                      ),
                    ),

                    // Search Field (Keyboard search action)
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        textInputAction: TextInputAction.search,  // ✅ Adds search icon on keyboard
                        onSubmitted: (value) {
                          if (value.isNotEmpty) {
                            Navigator.pushNamed(context, "/Loading", arguments: {
                              "new_city": value
                            });
                            print("Search triggered by keyboard: $value");
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "Search $hint",
                          hintStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //======================================= Container1 ===================================================
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.13,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white.withOpacity(0.5)
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.all(26),

                      child: LayoutBuilder(
                        builder: (context,constraints){
                          double containerWidth = constraints.maxWidth;
                          double containerHeight = constraints.maxHeight;

                          return Row(
                            children: [
                              Image.network(
                                "https://openweathermap.org/img/wn/$icon@2x.png",
                                width: containerWidth * 0.25,  // ✅ Image scales with container width
                                // height: containerHeight * 0.8, // ✅ Image scales with container height
                                fit: BoxFit.contain,
                              ),
                              SizedBox(width: containerWidth * 0.05),  // ✅ Dynamic spacing
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    info["desc_value"],
                                    style: TextStyle(
                                      fontSize: containerWidth * 0.06,   // ✅ Font size based on container width
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "In $city",
                                    style: TextStyle(
                                      fontSize: containerWidth * 0.06,   // ✅ Font size based on container width
                                    ),
                                  ),
                                ],
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              //======================================= Container2 ===================================================
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 250,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.white.withOpacity(0.5)
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                      padding: EdgeInsets.all(25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(WeatherIcons.thermometer),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(double.parse(info["temp_value"]).toStringAsFixed(1),style: TextStyle(
                                fontSize: 100,
                              ),),
                              Text("°C",style: TextStyle(
                                fontSize: 30
                              ),)
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              //======================================= Container 3 and 4 ===================================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.white.withOpacity(0.5)
                      ),
                      margin: EdgeInsets.fromLTRB(20, 0, 10, 0),
                      padding: EdgeInsets.all(30),
                      height: 200,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(WeatherIcons.day_windy),
                            ],
                          ),
                          SizedBox(height: 20,),
                          Text(double.parse(info["air_speed_value"]).toStringAsFixed(1),style: TextStyle(
                            fontSize: 30
                          ),),
                          Text("Km/h")
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.white.withOpacity(0.5)
                      ),
                      margin: EdgeInsets.fromLTRB(10, 0, 20, 0),
                      padding: EdgeInsets.all(30),
                      height: 200,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(WeatherIcons.humidity),
                              ],
                            ),
                            SizedBox(height: 20,),
                            Text(info["hum_value"],style: TextStyle(
                              fontSize: 30,
                            ),),
                            Text("Percent")
                          ],
                        ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
