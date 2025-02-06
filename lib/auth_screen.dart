import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_class_scheduler/services/auth_service.dart';
import 'services/auth_service.dart';
import 'screens/student_dashboard.dart';
import 'screens/mentor_dashboard.dart';
import 'screens/admin_dashboard.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  String selectedRole = 'student'; // Default role
  bool isLogin = true;

  void _authenticate() async {
    if (isLogin) {
      // LOGIN
      User? user = await _authService.login(emailController.text, passwordController.text);
      if (user != null) {
        String? role = await _authService.getUserRole(user.uid);
        if (role != null) {
          _navigateToDashboard(user.uid, role);
        }
      }
    } else {
      // SIGNUP
      User? user = await _authService.signUp(
        emailController.text, 
        passwordController.text, 
        nameController.text, 
        selectedRole
      );

      if (user != null) {
        _navigateToDashboard(user.uid, selectedRole);
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
      appBar: AppBar(title: Text(isLogin ? 'Login' : 'Sign Up')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!isLogin) TextField(controller: nameController, decoration: InputDecoration(labelText: 'Name')),
            TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
            if (!isLogin)
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
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _authenticate,
              child: Text(isLogin ? 'Login' : 'Sign Up'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isLogin = !isLogin;
                });
              },
              child: Text(isLogin ? 'Create an account' : 'Already have an account? Login'),
            )
          ],
        ),
      ),
    );
  }
}
