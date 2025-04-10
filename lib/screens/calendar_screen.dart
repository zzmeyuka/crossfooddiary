import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../about_page.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime selectedDate = DateTime.now();
  final Map<String, List<Map<String, dynamic>>> mealsByDate = {};

  void _addMeal() async {
    TextEditingController nameController = TextEditingController();
    TextEditingController kcalController = TextEditingController();
    TimeOfDay time = TimeOfDay.now();
    File? image;

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Add Meal"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(controller: nameController, decoration: const InputDecoration(labelText: "Meal Name")),
                TextField(controller: kcalController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Kcal")),
                ElevatedButton(
                  onPressed: () async {
                    final pickedTime = await showTimePicker(context: context, initialTime: time);
                    if (pickedTime != null) setState(() => time = pickedTime);
                  },
                  child: const Text("Pick Time"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final picker = ImagePicker();
                    final picked = await picker.pickImage(source: ImageSource.gallery);
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
                if (nameController.text.isNotEmpty && kcalController.text.isNotEmpty) {
                  final key = "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final key = "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
    final meals = mealsByDate[key] ?? [];
    int totalKcal = meals.fold(0, (sum, item) => sum + int.parse(item['kcal']));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Nutrition"),
        backgroundColor: Colors.teal.shade200,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                setState(() => selectedDate = picked);
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Hi, Malika & Dana 👋", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Center(
              child: CircularPercentIndicator(
                radius: 80.0,
                lineWidth: 12.0,
                animation: true,
                percent: totalKcal / 2000 > 1 ? 1 : totalKcal / 2000,
                center: Text(
                  "${2000 - totalKcal} KCAL left",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: Colors.orange,
              ),
            ),
            const SizedBox(height: 20),
            const Text("Today's Meals", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            Expanded(
              child: meals.isEmpty
                  ? const Center(child: Text("No meals today"))
                  : ListView.builder(
                itemCount: meals.length,
                itemBuilder: (context, index) {
                  final meal = meals[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: ListTile(
                      leading: meal["image"] != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(meal["image"], width: 48, height: 48, fit: BoxFit.cover),
                      )
                          : const Icon(Icons.fastfood),
                      title: Text(meal["name"], style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("${meal["kcal"]} kcal • ${meal["time"]}"),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMeal,
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.info_outline), label: 'About'),
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
