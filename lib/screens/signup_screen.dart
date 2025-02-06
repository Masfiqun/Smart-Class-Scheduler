import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_class_scheduler/screens/login_screen.dart';
import 'package:smart_class_scheduler/services/auth_service.dart';
import 'package:smart_class_scheduler/screens/student_dashboard.dart';
import 'package:smart_class_scheduler/screens/mentor_dashboard.dart';
import 'package:smart_class_scheduler/screens/admin_dashboard.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final AuthService _authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  String selectedRole = 'student'; // Default role

  void _signUp() async {
    User? user = await _authService.signUp(
      emailController.text, 
      passwordController.text, 
      nameController.text, 
      selectedRole,
    );
    
    if (user != null) {
      _navigateToDashboard(user.uid, selectedRole);
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
      body: Center(  // Wrapping everything with Center to center it in the screen
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,  // Centering the content vertically within the Column
            crossAxisAlignment: CrossAxisAlignment.center,  // Centering the content horizontally within the Column
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
                'Create Your Account!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 20),
              // Name Input
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person, color: Colors.blueAccent),
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
              // Role Selection Dropdown
              DropdownButton<String>(
                value: selectedRole,
                onChanged: (newRole) {
                  setState(() {
                    selectedRole = newRole!;
                  });
                },
                items: ['student', 'mentor', 'admin'].map((role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role.toUpperCase()),
                  );
                }).toList(),
                isExpanded: true,
                icon: Icon(Icons.arrow_drop_down, color: Colors.blueAccent),
                style: TextStyle(color: Colors.black, fontSize: 16),
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              SizedBox(height: 20),
              // Sign Up Button
              ElevatedButton(
                onPressed: _signUp,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15), backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              // Login Button (TextButton)
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text(
                  'Already have an account? Login',
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
