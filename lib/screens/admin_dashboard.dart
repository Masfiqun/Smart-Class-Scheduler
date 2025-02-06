import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboard extends StatelessWidget {
  void _removeUser(String userId) {
    FirebaseFirestore.instance.collection('users').doc(userId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Dashboard')),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          return ListView(
            children: snapshot.data!.docs.map((user) {
              return ListTile(
                title: Text(user['name']),
                subtitle: Text(user['role']),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _removeUser(user.id),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
