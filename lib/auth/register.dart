// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, prefer_const_constructors, use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_app/pages/header_widget.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  int _currentStep = 0;

  List<Widget> get _steps => [
        _emailPasswordStep(),
        _nameStep(),
        _usernameStep(),
        _descriptionStep(),
      ];

  Widget _emailPasswordStep() => Column(
        children: [
          _buildTextField(_emailController, 'Email'),
          SizedBox(height: 10),
          _buildTextField(_passwordController, 'Password', isPassword: true),
        ],
      );

  Widget _usernameStep() => _buildTextField(_usernameController, 'Username');

  Widget _nameStep() => Column(
        children: [
          _buildTextField(_firstNameController, 'First Name'),
          SizedBox(height: 10),
          _buildTextField(_lastNameController, 'Last Name'),
        ],
      );

  Widget _descriptionStep() =>
      _buildTextField(_descriptionController, 'Description');

  Widget _buildTextField(TextEditingController controller, String label,
          {bool isPassword = false}) =>
      TextField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Color(0xFF272829),
        ),
        obscureText: isPassword,
      );

  void _goBack() => setState(() => _currentStep--);

  void _goForward() {
    String? validationMessage;
    switch (_currentStep) {
      case 0:
        if (!_emailController.text.contains('@')) {
          validationMessage = "Email must contain '@'.";
        } else if (_passwordController.text.length < 6 ||
            !_passwordController.text.contains(RegExp(r'[A-Z]')) ||
            !_passwordController.text.contains(RegExp(r'[0-9]'))) {
          validationMessage =
              "Password must be at least 6 characters, include an upper case letter and a digit.";
        }
        break;
      case 1:
        if (_firstNameController.text.trim().isEmpty ||
            _lastNameController.text.trim().isEmpty) {
          validationMessage = "First name and last name cannot be empty.";
        }
        break;
      case 2:
        if (_usernameController.text.length < 6) {
          validationMessage = "Username must be at least 6 characters.";
        }
        break;
      case 3:
        break;
    }

    if (validationMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(validationMessage)),
      );
      return;
    }

    if (_currentStep < _steps.length - 1) {
      setState(() => _currentStep++);
    } else {
      _register();
    }
  }

  Future<void> _register() async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      final user = userCredential.user;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('userProfile')
            .doc(user.uid)
            .set({
          'username': _usernameController.text.trim(),
          'firstName': _firstNameController.text.trim(),
          'lastName': _lastNameController.text.trim(),
          'description': _descriptionController.text.trim(),
        });
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      print("Error during registration: $e");
    }
  }

  String _getNextButtonText() {
    if (_currentStep < _steps.length - 1) {
      return 'Next';
    } else {
      return 'Register';
    }
  }

  Widget _buildBottomText() {
    switch (_currentStep) {
      case 0:
        return GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
          child: Text(
            "Already have an account? Go to Login",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 144, 123, 198),
              decoration: TextDecoration.underline,
            ),
          ),
        );
      case 1:
        return Text(
          "Let us know you!",
          style: TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
        );
      case 2:
        return Text(
          "Pick a name that will be visible to all users!",
          style: TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
        );
      case 3:
        return Text(
          "Describe yourself as you feel!",
          style: TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
        );
      default:
        return SizedBox.shrink();
    }
  }

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
            top: 550,
            right: 0,
            child: CustomPaint(
              size: Size(100, 100),
              painter: AbstractPainter(),
            ),
          ),
          Positioned(
            top: 530,
            right: 320,
            child: CustomPaint(
              size: Size(50, 50),
              painter: CirclePainter(),
            ),
          ),
          Positioned(
            top: 120,
            right: -60,
            child: CustomPaint(
              size: Size(150, 150),
              painter: CirclePainter(),
            ),
          ),
          Positioned(
            top: -60,
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
                      'Welcome!',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Excited to meet you!',
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                    SizedBox(height: 20),
                    _steps[_currentStep],
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_currentStep > 0)
                          SizedBox(
                            height: 35,
                            width: 150,
                            child: ElevatedButton(
                              onPressed: _goBack,
                              child: Text('Back'),
                            ),
                          ),
                        SizedBox(width: 10),
                        SizedBox(
                          height: 35,
                          width: 150,
                          child: ElevatedButton(
                            onPressed: _goForward,
                            child: Text(_getNextButtonText()),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    _buildBottomText(),
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
