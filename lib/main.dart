import 'package:flutter/material.dart';
import 'screens/calendar_screen.dart';

void main() {
  runApp(const FoodDiaryApp());
}

class FoodDiaryApp extends StatelessWidget {
  const FoodDiaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food Diary',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFF7FDFB),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const CalendarScreen(),
    );
  }
}