import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class DashboardPage extends StatelessWidget {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(icon: Icon(Icons.person), onPressed: ()=> Navigator.pushNamed(context, '/profile')),
          IconButton(icon: Icon(Icons.admin_panel_settings), onPressed: ()=> Navigator.pushNamed(context, '/admin')),
          IconButton(icon: Icon(Icons.logout), onPressed: ()=> auth.logout()),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _db.collection('teams').orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) return Center(child: Text('No teams added yet.'));
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final d = docs[i];
              return ListTile(
                title: Text(d['name'] ?? 'Unnamed'),
                subtitle: Text(d['city'] ?? ''),
                onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_) => TeamDetailsPage(teamId: d.id))),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: ()=> _showAddTeamDialog(context),
      ),
    );
  }

  void _showAddTeamDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String name='', city='';
    showDialog(context: context, builder: (_) => AlertDialog(
      title: Text('Add Team'),
      content: Form(
        key: _formKey,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextFormField(decoration: InputDecoration(labelText: 'Team name'), validator: (v)=> v!=null && v.trim().isNotEmpty ? null : 'Enter name', onSaved: (v)=> name=v!.trim()),
          TextFormField(decoration: InputDecoration(labelText: 'City'), onSaved: (v)=> city=v!.trim()),
        ]),
      ),
      actions: [
        TextButton(onPressed: ()=> Navigator.pop(context), child: Text('Cancel')),
        ElevatedButton(onPressed: () async {
          if (!_formKey.currentState!.validate()) return;
          _formKey.currentState!.save();
          await FirebaseFirestore.instance.collection('teams').add({'name': name, 'city': city, 'createdAt': FieldValue.serverTimestamp()});
          Navigator.pop(context);
        }, child: Text('Add')),
      ],
    ));
  }
}

class TeamDetailsPage extends StatelessWidget {
  final String teamId;
  TeamDetailsPage({required this.teamId});

  @override
  Widget build(BuildContext context) {
    final docRef = FirebaseFirestore.instance.collection('teams').doc(teamId);
    return Scaffold(
      appBar: AppBar(title: Text('Team Details')),
      body: StreamBuilder<DocumentSnapshot>(
        stream: docRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final data = snapshot.data!.data() as Map<String,dynamic>?;
          if (data==null) return Center(child: Text('No data'));
          return Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ' + (data['name'] ?? ''), style: TextStyle(fontSize: 18)),
                SizedBox(height: 8),
                Text('City: ' + (data['city'] ?? '')),
                SizedBox(height: 12),
                Text('Players:'),
                Text(data['players']?.toString() ?? 'No players'),
              ],
            ),
          );
        },
      ),
    );
  }
}
