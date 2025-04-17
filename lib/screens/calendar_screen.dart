
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../about_page.dart';
import '../theme_provider.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime selectedDate = DateTime.now();
  final Map<String, List<Map<String, dynamic>>> mealsByDate = {};

  void _addMeal() async {
    final nameController = TextEditingController();
    final kcalController = TextEditingController();
    TimeOfDay time = TimeOfDay.now();
    File? image;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        title: Text("Add Meal",
            style: TextStyle(color: Theme.of(context).colorScheme.primary)),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Meal Name"),
              ),
              TextField(
                controller: kcalController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Kcal"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  final pickedTime = await showTimePicker(
                      context: context, initialTime: time);
                  if (pickedTime != null) setState(() => time = pickedTime);
                },
                child: const Text("Pick Time"),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  final picker = ImagePicker();
                  final picked =
                  await picker.pickImage(source: ImageSource.gallery);
                  if (picked != null) setState(() => image = File(picked.path));
                },
                child: const Text("Pick Image"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  kcalController.text.isNotEmpty) {
                final key =
                    "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
                mealsByDate.putIfAbsent(key, () => []);
                mealsByDate[key]!.add({
                  "name": nameController.text,
                  "kcal": kcalController.text,
                  "time": time.format(context),
                  "image": image,
                });
                Navigator.of(context).pop();
                setState(() {});
              }
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final key = "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
    final meals = mealsByDate[key] ?? [];
    final totalKcal =
    meals.fold(0, (sum, item) => sum + int.parse(item['kcal'] as String));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Food Diary"),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false)
                  .toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
              );
              if (picked != null) setState(() => selectedDate = picked);
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: Theme.of(context).brightness == Brightness.dark
                ? [Color(0xFF1E1B2E), Color(0xFF2C2940)]
                : [Color(0xFFFFF0F6), Color(0xFFE1BEE7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Hi, Malika & Dana 👋",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary)),
              const SizedBox(height: 20),
              Center(
                child: CircularPercentIndicator(
                  radius: 80.0,
                  lineWidth: 12.0,
                  animation: true,
                  percent: (totalKcal / 2000).clamp(0.0, 1.0),
                  center: Text(
                    "${2000 - totalKcal} KCAL left",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: Theme.of(context).colorScheme.secondary,
                  backgroundColor:
                  Theme.of(context).cardColor.withOpacity(0.3),
                ),
              ),
              const SizedBox(height: 20),
              Text("Today's Meals",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary)),
              const SizedBox(height: 10),
              Expanded(
                child: meals.isEmpty
                    ? Center(
                  child: Text("No meals today",
                      style: TextStyle(
                          color:
                          Theme.of(context).colorScheme.secondary)),
                )
                    : ListView.builder(
                  itemCount: meals.length,
                  itemBuilder: (context, index) {
                    final meal = meals[index];
                    return Card(
                      color: Theme.of(context).cardColor,
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: ListTile(
                        leading: meal["image"] != null
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            meal["image"],
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                          ),
                        )
                            : Icon(Icons.fastfood,
                            color:
                            Theme.of(context).colorScheme.secondary),
                        title: Text(meal["name"] as String,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary)),
                        subtitle: Text(
                          "${meal["kcal"]} kcal • ${meal["time"]}",
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMeal,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.info_outline), label: 'About'),
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
