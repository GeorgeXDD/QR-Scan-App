// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:qr_app/auth/register.dart';
import 'package:qr_app/main.dart';
import 'package:qr_app/pages/header_widget.dart';
import 'auth_controller.dart';

class LoginPage extends StatelessWidget {
  final AuthController _authController = AuthController();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF272829),
      body: Stack(
        children: [
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Column(
              children: [
                HeaderWidget(),
                SizedBox(height: 20),
              ],
            ),
          ),
          Positioned(
            top: 20,
            right: 0,
            child: CustomPaint(
              size: Size(100, 100),
              painter: AbstractPainter(),
            ),
          ),
          Positioned(
            top: 150,
            right: 20,
            child: CustomPaint(
              size: Size(50, 50),
              painter: CirclePainter(),
            ),
          ),
          Positioned(
            top: 150,
            right: 350,
            child: CustomPaint(
              size: Size(150, 150),
              painter: CirclePainter(),
            ),
          ),
          Positioned(
            top: 550,
            right: 350,
            child: CustomPaint(
              size: Size(100, 100),
              painter: AbstractPainter(),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 100),
                    Text(
                      'Welcome Back!',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'We missed you!',
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
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
                    SizedBox(
                      height: 35,
                      width: 150,
                      child: ElevatedButton(
                        child: Text('Login'),
                        onPressed: () async {
                          bool loggedIn = await _authController.handleSignIn(
                            _emailController.text,
                            _passwordController.text,
                          );
                          if (loggedIn) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainPage()),
                            );
                          } else {
                            // Handle login failure
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPage()),
                        );
                      },
                      child: Text(
                        "Not having an account? Go to Register",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 144, 123, 198),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AbstractPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Color.fromARGB(255, 144, 123, 198)
      ..style = PaintingStyle.fill;

    Path path = Path();

    path.moveTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width * 0.5, size.height * 0.5);
    path.close();

    path.moveTo(size.width * 0.5, size.height * 0.5);
    path.lineTo(400, size.height);
    path.lineTo(1, 2);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Color.fromARGB(255, 144, 123, 198)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.width / 2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
