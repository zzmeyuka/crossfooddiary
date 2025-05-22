import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../auth_provider.dart';
import '../l10n/app_localizations.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime selectedDate = DateTime.now();
  Map<String, List<Map<String, dynamic>>> mealsByDate = {};
  int _selectedIndex = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    loadMeals();
  }

  Future<void> loadMeals() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (auth.user == null || auth.isGuest) {
      setState(() {
        _loading = false;
        mealsByDate.clear();
      });
      return;
    }

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.user!.uid)
        .collection('meals')
        .get();

    final Map<String, List<Map<String, dynamic>>> loadedMeals = {};
    for (var doc in snapshot.docs) {
      final data = doc.data();
      final date = data['date'] ?? '';
      loadedMeals.putIfAbsent(date, () => []);
      loadedMeals[date]!.add({...data, 'id': doc.id});
    }
    setState(() {
      mealsByDate = loadedMeals;
      _loading = false;
    });
  }

  Future<void> _addMeal() async {
    final t = AppLocalizations.of(context)!;
    final nameController = TextEditingController();
    final kcalController = TextEditingController();
    TimeOfDay time = TimeOfDay.now();
    File? image;
    String? errorText;

    await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Theme.of(context).dialogBackgroundColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(t.addMeal, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(controller: nameController, decoration: InputDecoration(labelText: t.mealName)),
                  TextField(controller: kcalController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: t.kcal)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () async {
                      final pickedTime = await showTimePicker(context: context, initialTime: time);
                      if (pickedTime != null) setState(() => time = pickedTime);
                    },
                    child: Text(t.pickTime),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
                      if (picked != null) setState(() => image = File(picked.path));
                    },
                    child: Text(t.pickImage),
                  ),
                  if (errorText != null)
                    Padding(padding: const EdgeInsets.only(top: 12), child: Text(errorText!, style: const TextStyle(color: Colors.red))),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  if (nameController.text.isEmpty || kcalController.text.isEmpty) {
                    setState(() => errorText = t.fillFieldsError);
                    return;
                  }

                  final auth = Provider.of<AuthProvider>(context, listen: false);
                  final dateKey = "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
                  final meal = {
                    "name": nameController.text,
                    "kcal": kcalController.text,
                    "time": time.format(context),
                    "image": null
                  };

                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(auth.user!.uid)
                      .collection('meals')
                      .add({...meal, 'date': dateKey});

                  setState(() {
                    mealsByDate.putIfAbsent(dateKey, () => []);
                    mealsByDate[dateKey]!.add(meal);
                  });

                  Navigator.of(context).pop();
                },
                child: Text(t.save),
              ),
            ],
          );
        },
      ),
    );
  }

  void _onTabTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() => _selectedIndex = index);

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/calendar');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/settings');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  Widget _buildBottomNavigationBar(AppLocalizations t) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onTabTapped,
      items: [
        BottomNavigationBarItem(icon: const Icon(Icons.home), label: t.home),
        BottomNavigationBarItem(icon: const Icon(Icons.settings), label: t.settings),
        BottomNavigationBarItem(icon: const Icon(Icons.person), label: t.profile),
      ],
      backgroundColor: Theme.of(context).colorScheme.background,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Colors.grey,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final auth = Provider.of<AuthProvider>(context);
    final dateKey = "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
    final meals = mealsByDate[dateKey] ?? [];
    final totalKcal = meals.fold(0, (sum, item) => sum + int.parse(item['kcal']));

    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (auth.isGuest) {
      return Scaffold(
        appBar: AppBar(title: Text(t.appTitle)),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline, size: 80, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 20),
              Text(t.welcomeGuest ?? 'Welcome! You are in guest mode.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 12),
              Text(t.featureRestricted ?? 'This feature is restricted. Please log in to use it.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                child: Text(t.login),
              ),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/register'),
                child: Text(t.register),
              )
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(t),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("${t.appTitle} (${selectedDate.day}/${selectedDate.month})"),
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
              if (picked != null) setState(() => selectedDate = picked);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hi, ${auth.userName} 👋", style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 20),
            Center(
              child: CircularPercentIndicator(
                radius: 80.0,
                lineWidth: 12.0,
                animation: true,
                percent: (totalKcal / auth.kcalGoal).clamp(0.0, 1.0),
                center: Text("${auth.kcalGoal - totalKcal} KCAL left", textAlign: TextAlign.center),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: Theme.of(context).colorScheme.secondary,
                backgroundColor: Theme.of(context).cardColor.withOpacity(0.3),
              ),
            ),
            const SizedBox(height: 20),
            Text(t.todaysMeals, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            Expanded(
              child: meals.isEmpty
                  ? Center(child: Text(t.noMealsToday))
                  : ListView.builder(
                itemCount: meals.length,
                itemBuilder: (context, index) {
                  final meal = meals[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.fastfood),
                      title: Text(meal["name"]),
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
        onPressed: () async {
          await _addMeal();
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(t),
    );
  }
}
