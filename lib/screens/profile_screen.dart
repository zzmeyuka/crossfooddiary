import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth_provider.dart';
import '../l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameController = TextEditingController();
  final kcalController = TextEditingController();
  int _selectedIndex = 2;

  @override
  void dispose() {
    nameController.dispose();
    kcalController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final auth = Provider.of<AuthProvider>(context);

    if (auth.isGuest) {
      return Scaffold(
        appBar: AppBar(title: Text(t.profile)),
        body: Center(child: Text(t.featureRestricted)),
        bottomNavigationBar: BottomNavigationBar(
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
        ),
      );
    }

    nameController.text = auth.userName;
    kcalController.text = auth.kcalGoal.toString();

    return Scaffold(
      appBar: AppBar(title: Text(t.profile)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: t.name),
            ),
            TextField(
              controller: kcalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: t.kcalGoal),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                final goal = int.tryParse(kcalController.text.trim()) ?? 2000;
                await auth.updateProfile(name, goal);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.save)));
              },
              child: Text(t.save),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await auth.logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text(t.logout),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
      ),
    );
  }
}
