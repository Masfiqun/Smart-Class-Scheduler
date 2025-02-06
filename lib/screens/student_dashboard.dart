import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_class_scheduler/auth_screen.dart';
import 'package:smart_class_scheduler/screens/login_screen.dart';
import 'package:smart_class_scheduler/screens/student/availability.dart';
import 'package:smart_class_scheduler/screens/student/enrolledCourse.dart';

class StudentDashboard extends StatefulWidget {
  final String userId;

  StudentDashboard({required this.userId});

  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  // StreamController to listen for changes in the courses
  final StreamController<QuerySnapshot> _coursesStreamController = StreamController<QuerySnapshot>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'Student Dashboard',
          style: TextStyle(
            fontFamily: 'Eastwood',
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade400, Colors.white30],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('users').doc(widget.userId).get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              var userData = snapshot.data!;
              var username = userData['name'] ?? 'Student';
              var email = userData['email'] ?? 'student@example.com';

              return ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade600, Colors.blue.shade400],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    accountName: Text(
                      username,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    accountEmail: Text(
                      email,
                      style: TextStyle(color: Colors.white),
                    ),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        color: Colors.blueAccent,
                        size: 50,
                      ),
                    ),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.book,
                    text: 'Enroll in Course',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => StudentDashboard(userId: widget.userId)),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.check_circle,
                    text: 'View Enrolled Courses',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EnrolledCoursesScreen(userId: widget.userId)),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.access_time,
                    text: 'Set Availability Time',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AvailabilityScreen(userId: widget.userId)),
                      );
                    },
                  ),
                  Divider(),
                  _buildDrawerItem(
                    context,
                    icon: Icons.exit_to_app,
                    text: 'Sign Out',
                    onTap: () => _signOut(context),
                  ),
                ],
              );
            },
          ),
        ),
      ),
body: Padding(
  padding: const EdgeInsets.all(8.0),
  child: StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('courses').snapshots(),
    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

      return ListView.builder(
        itemCount: snapshot.data!.docs.length,
        itemBuilder: (context, index) {
          var course = snapshot.data!.docs[index];
          bool isEnrolled = (course['studentsEnrolled'] as List).contains(widget.userId);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course['title'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      course['description'],
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12), backgroundColor: isEnrolled ? Colors.green : Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          isEnrolled ? 'Enrolled' : 'Enroll',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: isEnrolled
                            ? null
                            : () {
                                FirebaseFirestore.instance.collection('courses').doc(course.id).update({
                                  'studentsEnrolled': FieldValue.arrayUnion([widget.userId])
                                }).then((_) {
                                  // Optionally show a success message or Snackbar
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text('Enrolled in ${course['title']}'),
                                  ));
                                }).catchError((e) {
                                  print('Error enrolling: $e');
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text('Error enrolling in course'),
                                  ));
                                });
                            },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  ),
),
    );
  }

  // Sign Out Function
  void _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    // Navigate to AuthScreen after sign-out
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  // Helper function to create a Drawer Item with Icon and Text
  Widget _buildDrawerItem(BuildContext context, {required IconData icon, required String text, required Function onTap}) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.black,
      ),
      title: Text(
        text,
        style: TextStyle(color: Colors.black, fontSize: 18),
      ),
      onTap: () => onTap(),
    );
  }
}
