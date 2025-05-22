import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth_provider.dart';
import '../l10n/app_localizations.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  final nameController = TextEditingController();
  final kcalController = TextEditingController();
  bool _loading = false;
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(t.register)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: t.email)),
            TextField(controller: passwordController, obscureText: true, decoration: InputDecoration(labelText: t.password)),
            TextField(controller: confirmController, obscureText: true, decoration: InputDecoration(labelText: t.confirmPassword ?? "Confirm Password")),
            TextField(controller: nameController, decoration: InputDecoration(labelText: t.name ?? "Name")),
            TextField(controller: kcalController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: t.kcalGoal ?? "Kcal Goal")),
            if (_errorText != null)
              Padding(padding: const EdgeInsets.only(top: 12), child: Text(_errorText!, style: const TextStyle(color: Colors.red))),
            const SizedBox(height: 20),
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: () async {
                final email = emailController.text.trim();
                final password = passwordController.text.trim();
                final confirm = confirmController.text.trim();
                final name = nameController.text.trim();
                final kcal = int.tryParse(kcalController.text.trim()) ?? 2000;

                setState(() => _errorText = null);

                if (!email.contains('@')) {
                  setState(() => _errorText = t.invalidEmail ?? "Invalid email");
                  return;
                }
                if (password.length < 6) {
                  setState(() => _errorText = t.shortPassword ?? "Password too short");
                  return;
                }
                if (password != confirm) {
                  setState(() => _errorText = t.passwordMismatch ?? "Passwords do not match");
                  return;
                }
                if (name.isEmpty) {
                  setState(() => _errorText = t.nameRequired ?? "Name is required");
                  return;
                }

                setState(() => _loading = true);
                try {
                  await authProvider.register(email, password, name, kcal);
                  if (authProvider.isLoggedIn) {
                    if (mounted) {
                      Navigator.pushNamedAndRemoveUntil(context, '/calendar', (route) => false);
                    }
                  }
                } catch (e) {
                  setState(() => _errorText = t.registrationFailed);
                }
                setState(() => _loading = false);
              },
              child: Text(t.register),
            ),
            TextButton(
              onPressed: () {
                authProvider.loginAsGuest();
                Navigator.pushNamedAndRemoveUntil(context, '/calendar', (route) => false);
              },
              child: Text(t.continueAsGuest ?? "Continue as Guest"),
            )
          ],
        ),
      ),
    );
  }
}
