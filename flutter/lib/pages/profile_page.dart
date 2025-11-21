import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final user = auth.currentUser;
    if (user==null) return Scaffold(body: Center(child: Text('No user')));
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final data = snapshot.data!.data() as Map<String,dynamic>?;
          return Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text(data?['name'] ?? user.email ?? 'No name', style: TextStyle(fontSize: 20)),
                SizedBox(height: 8),
                Text(user.email ?? ''),
                SizedBox(height: 12),
                ElevatedButton(onPressed: ()=> Navigator.pop(context), child: Text('Back')),
              ],
            ),
          );
        },
      ),
    );
  }
}
