import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weatherapp/components/weather_item.dart';
import 'package:weatherapp/widgets/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  // const HomePage({super.key});

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
  String searchWeatherAPI =
      'http://api.weatherapi.com/v1/current.json?key=' + API_KEY + '&days=7&q=';

  void fetchWeatherData(String searchText) async {
    try {
      var searchResult =
          await http.get(Uri.parse(searchWeatherAPI + searchText));
      final weatherData = Map<String, dynamic>.from(
          json.decode(searchResult.body) ?? 'No Data');
      var locationData = weatherData['location'];
      var currentWeather = weatherData['current'];
      setState(() {
        location = getShortLocationName(locationData['name']);
        var parsedDate =
            DateTime.parse(locationData['localtime'].substring(0, 10));
        var newDate = DateFormat('MMMMEEEEd').format(parsedDate);
        currentDate = newDate;
        // update weather
        currentWeatherStatus = currentWeather['condition']['text'];
        weatherIcon =
            currentWeatherStatus.replaceAll(' ', '').toLowerCase() + '.png';
        temperature = currentWeather['temp_c'].toInt();
        humidity = currentWeather['humidity'].toInt();
        windSpeed = currentWeather['wind_kph'].toInt();
        cloud = currentWeather['cloud'].toInt();
        //update hourly weather forecase
        dailyWeatherforecast = weatherData['forecast']['forecastday'];
        hourlyWeatherforecast = dailyWeatherforecast[0]['hour'];
        print(dailyWeatherforecast);
      });
    } catch (e) {
      print(e);
    }
  }

  // function to get short location name
  static String getShortLocationName(String s) {
    List<String> wordList = s.split(' ');

    if (wordList.isNotEmpty) {
      if (wordList.length > 1) {
        return wordList[0] + ' ' + wordList[1];
      } else {
        return wordList[0];
      }
    } else {
      return " ";
    }
  }

  @override
  void initState() {
    fetchWeatherData(location);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset:
          false, // when we want to search and pull up our keyboard, we can have it well without errors
      // backgroundColor: Colors.green,
      body: Container(
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.only(top: 70, left: 10, right: 10),
        color: _constants.primaryColor.withOpacity(.2),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            height: size.height * .7,
            decoration: BoxDecoration(
              gradient: _constants.linearGradientBlue,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: _constants.primaryColor.withOpacity(.6),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
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
                            Text(location,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                )),
                            IconButton(
                                onPressed: () {
                                  _cityController.clear();
                                  showBarModalBottomSheet(
                                      context: context,
                                      builder: (context) =>
                                          SingleChildScrollView(
                                              controller:
                                                  ModalScrollController.of(
                                                      context),
                                              child: Container(
                                                  height: size.height * .2,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                                  child: Column(children: [
                                                    SizedBox(
                                                      width: 70,
                                                      child: Divider(
                                                        thickness: 3.5,
                                                        color: _constants
                                                            .primaryColor,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    TextField(
                                                        onChanged:
                                                            (searchText) {
                                                          fetchWeatherData(
                                                              searchText);
                                                        },
                                                        controller:
                                                            _cityController,
                                                        autofocus: true,
                                                        decoration:
                                                            InputDecoration(
                                                                prefixIcon:
                                                                    Icon(
                                                                  Icons.search,
                                                                  color: _constants
                                                                      .primaryColor,
                                                                ),
                                                                suffixIcon:
                                                                    GestureDetector(
                                                                  onTap: () =>
                                                                      _cityController
                                                                          .clear(),
                                                                  child: Icon(
                                                                    Icons.close,
                                                                    color: _constants
                                                                        .primaryColor,
                                                                  ),
                                                                ),
                                                                hintText:
                                                                    'Search City eg Nairobi',
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: _constants
                                                                        .primaryColor,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                )))
                                                  ]))));
                                },
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                  size: 20,
                                ))
                          ]),
                      ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/profile.png',
                            width: 35,
                            height: 35,
                          ))
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
                      Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(temperature.toString(),
                              style: TextStyle(
                                  fontSize: 80,
                                  fontWeight: FontWeight.bold,
                                  foreground: Paint()
                                    ..shader = _constants.shader))),
                      Text('O',
                          style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              foreground: Paint()..shader = _constants.shader)),
                    ],
                  ),
                  Text(currentWeatherStatus,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 20,
                      )),
                  Text(currentDate,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 20,
                      )),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Divider(color: Colors.white70),
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            WeatherItem(
                              value: windSpeed.toInt(),
                              unit: 'Km/h',
                              imageUrl: 'assets/windspeed.png',
                            ),
                            WeatherItem(
                              value: humidity.toInt(),
                              unit: 'Km/h',
                              imageUrl: 'assets/humidity.png',
                            ),
                            WeatherItem(
                              value: cloud.toInt(),
                              unit: 'Km/h',
                              imageUrl: 'assets/cloud.png',
                            ),
                          ]))
                ]),
          ),
          Container(
              padding: const EdgeInsets.only(top: 10),
              height: size.height * 0.2,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Today',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                              // onTap: () => {
                              //   Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (_) => DetailPage(
                              //         dailyForecastweather: dailyWeatherforecast,
                              //       )
                              //     )
                              //   )
                              // },
                              child: Text(
                                'forecasts',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: _constants.primaryColor),
                              ))
                        ]),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                          itemCount: hourlyWeatherforecast.length,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          // taking time from API
                          itemBuilder: (BuildContext context, int index) {
                            String currentTime =
                                DateFormat('HH:mm:ss').format(DateTime.now());
                            String currentHour = currentTime.substring(0, 2);
                            String forecastTime = hourlyWeatherforecast[index]
                                    ['time'].substring(11, 16);
                            String forecastHour = hourlyWeatherforecast[index]
                                    ['time'].substring(11, 13);
                            String forecastWeatherName =
                                hourlyWeatherforecast[index]['condition']['text'];
                            String forecastWeatherIcon = forecastWeatherName.replaceAll(' ', '').toLowerCase() + ".png";
                            String forecastTemperature =
                                hourlyWeatherforecast[index]["temp_c"].round().toString();
                            return Container(
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                margin: const EdgeInsets.only(right: 20),
                                // color: Colors.black,
                                width: 60,
                                decoration: BoxDecoration(
                                    color: currentHour == forecastHour
                                        ? Colors.white
                                        : _constants.primaryColor,
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(50)),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: const Offset(0, 1),
                                        blurRadius: 5,
                                        color: _constants.primaryColor
                                            .withOpacity(.2),
                                      ),
                                    ]),
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(forecastTime,
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: _constants.greyColor,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      Image.asset(
                                        'assets/${forecastWeatherIcon}',
                                        width: 20,
                                      ),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(padding: const EdgeInsets.only(top: 8.0),
                                            child: Text(forecastTemperature,
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    color: _constants.greyColor,
                                                    fontWeight:
                                                    FontWeight.bold),),),
                                                Text('o',
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                      color: _constants.greyColor,
                                                      fontWeight: FontWeight.w600,
                                                    ))

                                          ])
                                    ]));
                          }),
                    )
                  ]))
        ]),
      ),
    );
  }
}
