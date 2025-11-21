import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String name='', email = '', password = '';
  bool loading=false;
  String? error;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (error!=null) Text(error!, style: TextStyle(color: Colors.red)),
              TextFormField(
                decoration: InputDecoration(labelText: 'Full name'),
                validator: (v)=> v!=null && v.trim().length>=3 ? null : 'Enter at least 3 chars',
                onSaved: (v)=> name = v!.trim(),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (v)=> v!=null && v.contains('@') ? null : 'Enter valid email',
                onSaved: (v)=> email = v!.trim(),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (v)=> v!=null && v.length>=6 ? null : 'At least 6 chars',
                onSaved: (v)=> password = v!.trim(),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                child: loading ? CircularProgressIndicator(color: Colors.white) : Text('Register'),
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  _formKey.currentState!.save();
                  setState(() {
                    loading = true;
                    error = null;
                  });
                  final msg = await auth.register(email: email, password: password, name: name);
                  setState((){ loading=false; });
                  if (msg!=null) setState(()=> error = msg);
                  else Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
