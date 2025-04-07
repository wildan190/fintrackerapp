import 'package:flutter/material.dart';
import 'package:fintrackerapp/services/auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final AuthService _authService = AuthService();

  void _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Passwords do not match!')));
        return;
      }

      bool success = await _authService.register(
        _usernameController.text.trim(),
        _passwordController.text.trim(),
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration successful! Please log in.')),
        );
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Username is already taken!')));
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
                // Gambar di atas form registrasi dengan ukuran yang lebih besar
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/img/auth.jpg',
                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 30),
                // Judul form
                Text(
                  'Create Your Account',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 20),
                // Form registrasi dengan kolom input yang lebih minimalis
                _buildRegisterForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Kolom input username dengan desain yang lebih modern
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
          // Kolom input password dengan desain yang lebih modern
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
          // Kolom input konfirmasi password yang lebih modern
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Confirm Password",
              labelStyle: TextStyle(color: Colors.blueAccent),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30), // Sudut membulat
              ),
              prefixIcon: Icon(Icons.lock, color: Colors.blueAccent),
            ),
            validator:
                (value) =>
                    value!.isEmpty ? 'Please confirm your password' : null,
          ),
          SizedBox(height: 20),
          // Tombol Register dengan desain yang menarik dan kontras
          ElevatedButton(
            onPressed: _register,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
              backgroundColor: Colors.blueAccent, // Warna biru cerah
              foregroundColor: Colors.white, // Warna teks putih
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              "Register",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20),
          // Link untuk login dengan desain konsisten
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Already have an account? Login here',
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),
        ],
      ),
    );
  }
}
