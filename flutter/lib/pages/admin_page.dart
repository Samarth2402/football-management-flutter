import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPage extends StatelessWidget {
  final _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Dashboard')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _db.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final docs = snapshot.data!.docs;
          return ListView(
            children: docs.map((d) {
              final data = d.data() as Map<String,dynamic>;
              return ListTile(
                title: Text(data['name'] ?? d.id),
                subtitle: Text(data['email'] ?? ''),
                trailing: TextButton(
                  child: Text('Make Admin'),
                  onPressed: () async {
                    await _db.collection('admins').doc(d.id).set({'role':'admin'});
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Made admin')));
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
