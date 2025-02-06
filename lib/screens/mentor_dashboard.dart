import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_class_scheduler/auth_screen.dart';
import 'package:smart_class_scheduler/screens/login_screen.dart';
import 'package:smart_class_scheduler/screens/student/mentor/addCourse.dart';
import 'package:smart_class_scheduler/screens/student/mentor/view_students.dart';

class MentorDashboard extends StatelessWidget {
  final String mentorId;

  MentorDashboard({required this.mentorId});

  // Sign out function
  void _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  // Delete a course
  void _deleteCourse(String courseId) async {
    try {
      await FirebaseFirestore.instance.collection('courses').doc(courseId).delete();
    } catch (e) {
      print('Error deleting course: $e');
    }
  }

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
          'Mentor Dashboard',
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
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
              ),
              child: Text(
                'Mentor Options',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.add_circle, color: Colors.blueAccent),
              title: Text('Add Course'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CreateCourseScreen(mentorId: mentorId))); // Close the drawer
                // Navigate to Add Course screen (currently on this screen)
              },
            ),
            ListTile(
              leading: Icon(Icons.list_alt, color: Colors.blueAccent),
              title: Text('View Added Courses'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MentorDashboard(mentorId: mentorId))); // Close the drawer
                // Stay on this screen as it already shows the list of courses
              },
            ),
            ListTile(
              leading: Icon(Icons.supervised_user_circle, color: Colors.blueAccent),
              title: Text('View Total Student Details'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ViewStudentsScreen()));
                // Navigate to Student Details screen (implement this if needed)
              },
            ),
            ListTile(
              leading: Icon(Icons.schedule, color: Colors.blueAccent),
              title: Text('Update Class Schedules'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Navigate to Class Schedules screen (implement this if needed)
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app, color: Colors.red),
              title: Text('Sign Out'),
              onTap: () => _signOut(context),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Display list of courses section
            Text(
              'Your Courses',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('courses')
                    .where('mentorId', isEqualTo: mentorId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No courses created yet.'));
                  }

                  // List of courses created by mentor
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var course = snapshot.data!.docs[index];
                      var studentsEnrolled = (course['studentsEnrolled'] as List).length;

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16),
                          title: Text(
                            course['title'],
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(course['description']),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('$studentsEnrolled students'),
                              SizedBox(width: 8),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteCourse(course.id),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
