import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_class_scheduler/screens/signup_screen.dart';
import 'package:smart_class_scheduler/services/auth_service.dart';
import 'package:smart_class_scheduler/screens/student_dashboard.dart';
import 'package:smart_class_scheduler/screens/mentor_dashboard.dart';
import 'package:smart_class_scheduler/screens/admin_dashboard.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _login() async {
    User? user = await _authService.login(emailController.text, passwordController.text);
    if (user != null) {
      String? role = await _authService.getUserRole(user.uid);
      if (role != null) {
        _navigateToDashboard(user.uid, role);
      }
    }
  }

  void _navigateToDashboard(String uid, String role) {
    if (role == 'student') {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StudentDashboard(userId: uid)));
    } else if (role == 'mentor') {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MentorDashboard(mentorId: uid)));
    } else if (role == 'admin') {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminDashboard()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      body: Center( // Wrap the whole body inside a Center widget to center everything
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,  // Center the Column's children vertically
            crossAxisAlignment: CrossAxisAlignment.center,  // Center the Column's children horizontally
            children: [
              Image.asset(
                'asset/image/asl.png',  // Add your logo/icon here
                height: 150,
                width: 150,
              ),
              Text(
                'Creativity Starts with Belief',
                style: TextStyle(
                  fontFamily: 'Eastwood',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 30),
              Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 20),
              // Email Input
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email, color: Colors.blueAccent),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
              ),
              SizedBox(height: 20),
              // Password Input
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock, color: Colors.blueAccent),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
              ),
              SizedBox(height: 20),
              // Login Button
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15), backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              // Sign Up Button
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPage()),
                  );
                },
                child: Text(
                  'Create an account',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
