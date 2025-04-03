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
                // Gambar lebih besar dan diletakkan di atas form
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/img/auth.jpg',
                    width: 250, // Ukuran gambar diperbesar
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 30),
                // Judul
                Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 20),
                // Form login dengan desain lebih modern dan minimalis
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
          // Kolom input username dengan sudut membulat dan desain yang lebih modern
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: "Username",
              labelStyle: TextStyle(color: Colors.blueAccent),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30), // Sudut membulat
              ),
              prefixIcon: Icon(Icons.person, color: Colors.blueAccent),
            ),
            validator:
                (value) => value!.isEmpty ? 'Please enter your username' : null,
          ),
          SizedBox(height: 20),
          // Kolom input password yang lebih modern
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Password",
              labelStyle: TextStyle(color: Colors.blueAccent),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30), // Sudut membulat
              ),
              prefixIcon: Icon(Icons.lock, color: Colors.blueAccent),
            ),
            validator:
                (value) => value!.isEmpty ? 'Please enter your password' : null,
          ),
          SizedBox(height: 20),
          // Tombol Login dengan warna yang lebih menarik dan kontras
          ElevatedButton(
            onPressed: _login,
            child: Text(
              "Login",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
              backgroundColor: Colors.blueAccent, // Warna biru cerah
              foregroundColor: Colors.white, // Warna teks putih untuk kontras
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          SizedBox(height: 20),
          // Link registrasi dengan warna biru agar tetap terlihat jelas
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/register'),
            child: Text(
              'Don\'t have an account? Register here',
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),
        ],
      ),
    );
  }
}
