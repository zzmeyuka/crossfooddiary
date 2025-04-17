import 'package:flutter/material.dart';
import '../about_page.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> meals = [
    {"meal": "Breakfast", "food": "Hotdog", "kcal": 150, "image": "assets/hotdog.png"},
    {"meal": "Lunch", "food": "Pizza", "kcal": 450, "image": "assets/pizza.png"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Food Diary"),
        backgroundColor: Color(0xFFFF84B7),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF0F8), Color(0xFFE1BEE7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: meals.length,
          itemBuilder: (context, index) {
            final item = meals[index];
            return Card(
              color: Colors.white,
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: ListTile(
                leading: Image.asset(item["image"], width: 48, height: 48, fit: BoxFit.cover),
                title: Text('${item["meal"]} - ${item["food"]}', style: const TextStyle(color: Color(0xFF4A148C))),
                subtitle: Text('${item["kcal"]} kcal', style: const TextStyle(color: Color(0xFF6A1B9A))),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFFFE4EC),
        selectedItemColor: const Color(0xFFB388EB),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: "About"),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AboutPage()),
            );
          }
        },
      ),
    );
  }
}
