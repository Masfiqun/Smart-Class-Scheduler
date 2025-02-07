import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Students & Mentors',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No users found.'));
          }

          // Separate students and mentors
          List<QueryDocumentSnapshot> students = [];
          List<QueryDocumentSnapshot> mentors = [];

          for (var user in snapshot.data!.docs) {
            if (user['role'] == 'Student') {
              students.add(user);
            } else if (user['role'] == 'Mentor') {
              mentors.add(user);
            }
          }

          return ListView(
            padding: EdgeInsets.all(12),
            children: [
              // Display Mentors Section
              _buildUserSection(title: "Mentors", users: mentors),

              SizedBox(height: 20), // Spacing

              // Display Students Section
              _buildUserSection(title: "Students", users: students),
            ],
          );
        },
      ),
    );
  }

  // Widget for displaying users in a section
  Widget _buildUserSection({required String title, required List<QueryDocumentSnapshot> users}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent),
        ),
        SizedBox(height: 8),
        users.isEmpty
            ? Text("No $title found.", style: TextStyle(color: Colors.grey))
            : Column(
                children: users.map((user) => _buildUserCard(user)).toList(),
              ),
      ],
    );
  }

  // User Card UI
  Widget _buildUserCard(QueryDocumentSnapshot user) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blueAccent,
          child: Text(
            user['name'][0].toUpperCase(),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          user['name'],
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Email: ${user['email']}',
          style: TextStyle(color: Colors.grey[700]),
        ),
      ),
    );
  }
}
