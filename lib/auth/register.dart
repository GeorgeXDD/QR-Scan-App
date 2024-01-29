import 'package:flutter/material.dart';
import 'package:qr_app/auth/login.dart';
import 'auth_controller.dart';

class RegisterPage extends StatelessWidget {
  final AuthController _authController = AuthController();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF272829),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Register',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Color(0xFF272829),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Color(0xFF272829),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Register'),
                onPressed: () async {
                  bool registered = await _authController.handleSignUp(
                    _emailController.text,
                    _passwordController.text,
                  );
                  if (registered) {
                    Navigator.pushReplacementNamed(context, '/home');
                  } else {
                    // Show error message
                  }
                },
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text(
                  "Already have an account? Go to Login",
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
