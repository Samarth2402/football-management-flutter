import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool loading = false;
  String? error;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (error != null) Text(error!, style: TextStyle(color: Colors.red)),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (v) => v!=null && v.contains('@') ? null : 'Enter a valid email',
                onSaved: (v) => email = v!.trim(),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (v) => v!=null && v.length>=6 ? null : 'Password must be at least 6 chars',
                onSaved: (v) => password = v!.trim(),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                child: loading ? CircularProgressIndicator(color: Colors.white) : Text('Login'),
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  _formKey.currentState!.save();
                  setState((){ loading=true; error=null;});
                  final msg = await auth.login(email: email, password: password);
                  setState((){ loading=false; });
                  if (msg != null) setState(()=> error = msg);
                },
              ),
              TextButton(onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterPage())), child: Text('Create account')),
            ],
          ),
        ),
      ),
    );
  }
}
