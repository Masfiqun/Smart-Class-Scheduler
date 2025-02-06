// EnrolledCoursesScreen.dart (Simple Example)
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EnrolledCoursesScreen extends StatelessWidget {
  final String userId;

  EnrolledCoursesScreen({required this.userId});

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
          'Enrolled Courses',
          style: TextStyle(
            fontFamily: 'Eastwood',
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('courses').where('studentsEnrolled', arrayContains: userId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          
          return ListView(
            children: snapshot.data!.docs.map((course) {
              return ListTile(
                title: Text(course['title']),
                subtitle: Text(course['description']),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
