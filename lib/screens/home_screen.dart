import 'package:flutter/material.dart';
import '../about_page.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> meals = [
    {"meal": "Breakfast", "food": "Hotdog", "kcal": 150, "image": "assets/hotdog.png"},
    {"meal": "Lunch", "food": "Pizza", "kcal": 450, "image": "assets/pizza.png"},
  ];

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Food Diary"),
            backgroundColor: Colors.teal,
          ),
          body: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: meals.length,
            itemBuilder: (context, index) {
              final item = meals[index];
              return Card(
                child: ListTile(
                  leading: Image.asset(item["image"], width: 48, height: 48, fit: BoxFit.cover),
                  title: Text('${item["meal"]} - ${item["food"]}'),
                  subtitle: Text('${item["kcal"]} kcal'),
              ),
              );
            },
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.info), label: "About"),
            ],
            onTap: (index) {
              if (index == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage()),
                );
              }
            },
          ),
        );
      },
    );
  }
}