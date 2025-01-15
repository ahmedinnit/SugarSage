import 'package:flutter/material.dart';
import 'resetpassword.dart';

class VerifyCodePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // This is the background color from your image
      appBar: AppBar(
        backgroundColor: Color(0xFF6FA68F),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0, // No shadow
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 250.0,
                decoration: BoxDecoration(
                  color: Color(0xFF6FA68F),
                  image: DecorationImage(
                    image: AssetImage('assets/images/logo.png'),
                    fit: BoxFit.none,
                    scale: 2.0,
                  ),
                ),
              ),
              SizedBox(height: 60.0), // Spacing between the logo and the text fields
              Text(
                'Verify Code',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 50.0),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(4, (index) => _buildCodeBox(context)),
                ),
              ),
              SizedBox(height: 40.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ResetPasswordPage()),
                  );
                },
                child: Text(
                  'Resend the code',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6FA68F),
                  padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCodeBox(BuildContext context) {
    return Container(
      width: 60.0,
      height: 48.0,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF6FA68F)),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextFormField(
        autofocus: true,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18.0),
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: InputDecoration(
          border: InputBorder.none,
          counterText: "",
          contentPadding: EdgeInsets.symmetric(vertical: 8.0), // Adjust as needed
        ),
      ),
    );
  }
}
