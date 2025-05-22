import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth_provider.dart';
import '../l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? errorMessage;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(t.appTitle)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: t.email),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: t.password),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: () async {
                setState(() {
                  isLoading = true;
                  errorMessage = null;
                });
                try {
                  await authProvider.signInWithEmail(
                    emailController.text.trim(),
                    passwordController.text.trim(),
                  );
                  if (!mounted) return;
                  Navigator.pushReplacementNamed(context, '/calendar');
                } catch (e) {
                  setState(() {
                    errorMessage = e.toString();
                  });
                } finally {
                  setState(() {
                    isLoading = false;
                  });
                }
              },
              child: Text(t.login),
            ),
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              child: Text(t.noAccount),
            ),
            TextButton(
              onPressed: () {
                authProvider.loginAsGuest();
                Navigator.pushReplacementNamed(context, '/calendar');
              },
              child: const Text("Continue as Guest"),
            ),
          ],
        ),
      ),
    );
  }
}
