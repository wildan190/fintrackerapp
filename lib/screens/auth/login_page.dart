import 'package:flutter/material.dart';
import 'package:fintrackerapp/services/auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  void _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      var user = await _authService.login(
        _usernameController.text.trim(),
        _passwordController.text.trim(),
      );

      if (user != null) {
        // Jika login sukses, pindah ke dashboard
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        // Jika gagal, tampilkan pesan error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed! Incorrect username or password.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome Back!',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                _buildLoginForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: "Username",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
            validator:
                (value) => value!.isEmpty ? 'Please enter your username' : null,
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Password",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock),
            ),
            validator:
                (value) => value!.isEmpty ? 'Please enter your password' : null,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _login,
            child: Text("Login", style: TextStyle(fontSize: 18)),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          SizedBox(height: 20),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/register'),
            child: Text('Don\'t have an account? Register here'),
          ),
        ],
      ),
    );
  }
}
