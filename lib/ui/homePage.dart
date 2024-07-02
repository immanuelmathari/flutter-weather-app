import 'package:flutter/material.dart';
import 'package:weatherapp/widgets/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _cityController = TextEditingController();
  final Constants _constants = Constants();

  static String API_KEY = "ed25ad604289431b89a94655240107";

  String location = "Nairobi";
  String weatherIcon = "heavycloudy.png";
  int temperature = 0;
  int humidity = 0;
  int windSpeed = 0;
  int cloud = 0;
  String currentDate = '';

  List hourlyWeatherforecast = [];
  List dailyWeatherforecast = [];

  String currentWeatherStatus = '';

  // api call
  String searchWeatherAPI = 'http://api.weatherapi.com/v1/current.json?key=' + API_KEY + '&days=7&q=';


  @override
  Widget build(BuildContext context){
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false, // when we want to search and pull up our keyboard, we can have it well without errors
      // backgroundColor: Colors.green,
      body: Container(
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.only(top: 70, left: 10, right: 10),
        color: _constants.primaryColor.withOpacity(.2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical:10, horizontal:10),
              height: size.height * .7,
              decoration: BoxDecoration(
                gradient: _constants.linearGradientBlue,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: _constants.primaryColor.withOpacity(.6),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: const Offset(0,3),
                  )
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        Image.asset('assets/menu.png', width: 35, height: 35),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/pin.png', width: 20),
                          const SizedBox(width: 3),
                          Text(location, style: const TextStyle(color: Colors.white, fontSize: 16,)),
                          IconButton(onPressed: (){}, icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 20,))
                        ]
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset('assets/profile.png', width: 35, height: 35,)
                      )
                    ],
                  ),
                  SizedBox(
                    height: 160,
                    child: Image.asset('assets/$weatherIcon'),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(padding: const EdgeInsets.only(top: 8.0)),
                    ]
                  )
                ]
              ),
            )
          ]
        ),
      ),
    );
  }
}