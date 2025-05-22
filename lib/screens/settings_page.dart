import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth_provider.dart';
import '../locale_provider.dart';
import '../theme_provider.dart';
import '../l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _selectedIndex = 1;

  void _onTabTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/calendar');
        break;
      case 1:
      // stay on settings
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
    final localeProvider = Provider.of<LocaleProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    if (auth.isGuest || !auth.isLoggedIn) {
      return Scaffold(
        appBar: AppBar(title: Text(t.settings)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              t.featureOnlyForRegistered,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomBar(t),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(t.settings),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacementNamed(context, '/calendar'),
        ),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text(t.darkMode),
            value: auth.themeMode == ThemeMode.dark,
            onChanged: (value) {
              auth.setTheme(value ? ThemeMode.dark : ThemeMode.light);
              themeProvider.setTheme(value ? ThemeMode.dark : ThemeMode.light);
            },
          ),
          ListTile(
            title: Text(t.language),
            trailing: DropdownButton<String>(
              value: auth.languageCode,
              onChanged: (value) {
                if (value != null) {
                  auth.setLanguage(value);
                  localeProvider.setLocale(Locale(value));
                }
              },
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'ru', child: Text('Русский')),
                DropdownMenuItem(value: 'kk', child: Text('Қазақша')),
              ],
            ),
          ),
          ListTile(
            title: Text(t.about),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => Navigator.pushNamed(context, '/about'),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(t),
    );
  }

  Widget _buildBottomBar(AppLocalizations t) {
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
}
