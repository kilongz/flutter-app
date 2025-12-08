import 'package:flutter/material.dart';
import 'package:lotapp/screens/auth/Register_screen.dart';
import 'package:lotapp/screens/navigation/main_navigation.dart';
import 'package:lotapp/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkIfLoggedIn();
  }

  Future<void> _checkIfLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainNavigation()),
      );
    }
  }

  Future<void> login() async {
    String email = txtEmail.text.trim();
    String password = txtPassword.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    setState(() => isLoading = true);

    final data = await AuthService.login(email, password);

    setState(() => isLoading = false);

    if (data != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setString('token', data['token']);
      await prefs.setInt('student_id', data['student_id']);
      await prefs.setString('name', data['user']['name']);
      await prefs.setString('username', data['user']['username']);
      await prefs.setString('email', data['user']['email']);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigation()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid email or password'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void register() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Register()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: txtEmail,
              decoration: const InputDecoration(labelText: 'Email or Username'),
            ),
            TextField(
              controller: txtPassword,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: login,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 8, 77, 117),
                foregroundColor: Colors.white,
              ),
              child: const Text('Login'),
            ),

            TextButton(
              onPressed: register,
              child: const Text('Don’t have an account? Register here -->'),
            ),
          ],
        ),
      ),
    );
  }
}
