import 'package:flutter/material.dart';

class ResetPasswordPage extends StatelessWidget {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

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
                'Forgot Password',
                style: TextStyle(
                    color: Colors.black, // Font color
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter'
                ),
              ),
              SizedBox(height: 40.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 26.0), // This applies horizontal padding to both sides
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // This aligns children to the start, i.e., left side
                  children: <Widget>[
                    TextFormField(
                      obscureText: true,  // Ensures the text is treated as a password
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.grey, fontFamily: 'Inter'),  // Label style
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: Colors.grey,  // Border color when enabled
                            width: 3.0,
                          ),
                        ),
                      ),
                      cursorColor: Colors.green,  // Cursor color
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      obscureText: true,  // Ensures the text is treated as a password
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.grey, fontFamily: 'Inter'),  // Label style
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: Colors.grey,  // Border color when enabled
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
                        },
                        child: Text(
                          'Reset',
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
