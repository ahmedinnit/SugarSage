import 'package:flutter/material.dart';
import 'verifycode.dart';

class ForgotPasswordPage extends StatefulWidget {
  get previousPage => null;

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _isEmailValid = true; // Initially, we assume the email is valid

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      if (_emailController.text.isEmpty != _isEmailValid) {
        setState(() {
          _isEmailValid = _emailController.text.isEmpty;
        });
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xFF6FA68F), // Change this to your desired color
          iconTheme: IconThemeData(color: Colors.white)
      ),
      backgroundColor: Colors.white, // This is the background color from your image
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 250.0, // Set the height to any value you want
                decoration: BoxDecoration(
                  color: Color(0xFF6FA68F), // The color you want for the background
                  image: DecorationImage(
                    image: AssetImage('assets/images/logo.png'), // Replace with your image path
                    fit: BoxFit.none, // This will cover the container with the image, you can change the fit as needed
                    scale: 2.0,
                  ),
                ),
                child: SizedBox.expand(), // This will expand the SizedBox to fill all available space
              ),
              SizedBox(height: 70.0),
              Text(
                widget.previousPage == 'main' ? 'Forgot Password' : 'Reset Password',
                style: TextStyle(
                  color: Colors.black, // Font color
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),
              SizedBox(height: 40.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 26.0), // This applies horizontal padding to both sides
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // This aligns children to the start, i.e., left side
                  children: <Widget>[
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        labelStyle: TextStyle(color: Colors.grey),  // Label style
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: _isEmailValid ? Colors.green : Colors.red,  // Border color when focused
                            width: 3.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: _isEmailValid ? Colors.grey : Colors.red,  // Border color when enabled
                            width: 3.0,
                          ),
                        ),
                      ),
                      cursorColor: Colors.green,  // Cursor color
                    ),
                    SizedBox(height: 30.0),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Your login logic might go here
                          // ...

                          // Navigation to VerifyCodePage
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => VerifyCodePage()),
                          );
                        },
                        child: Text(
                          'Send Reset Link',
                          style: TextStyle(
                              color: Colors.white, // Font color
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter'
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, backgroundColor: Color(0xFF6FA68F),  // Text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 70.0, vertical: 12.0),  // Button padding
                        ),
                      ),

                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
