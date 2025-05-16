import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';
import '../locale_provider.dart';
import '../l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(t.settings)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: Text(t.darkMode),
              value: themeProvider.themeMode == ThemeMode.dark,
              onChanged: (_) => themeProvider.toggleTheme(),
            ),
            const SizedBox(height: 16),
            Text(t.language, style: const TextStyle(fontSize: 16)),
            DropdownButton<Locale>(
              value: localeProvider.locale,
              items: [
                DropdownMenuItem(value: const Locale('en'), child: Text(t.english)),
                DropdownMenuItem(value: const Locale('ru'), child: Text(t.russian)),
                DropdownMenuItem(value: const Locale('kk'), child: Text(t.kazakh)),
              ],
              onChanged: (locale) => localeProvider.setLocale(locale!),
            ),
          ],
        ),
      ),
    );
  }
}
