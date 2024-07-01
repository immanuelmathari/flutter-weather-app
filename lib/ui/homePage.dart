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
  String weather = "heavycloudy.png";
  @override
  Widget build(BuildContext context){
    return const Placeholder();
  }
}