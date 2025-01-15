import 'package:flutter/material.dart';


class TermsAndPolicy extends StatefulWidget {
  @override
  _TermsAndPolicyState createState() => _TermsAndPolicyState();
}

class _TermsAndPolicyState extends State<TermsAndPolicy> {
  bool _agreedToTerms = false;

  void _setAgreedToTerms(bool? newValue) {
    setState(() {
      _agreedToTerms = newValue ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AGREEMENT'),
        backgroundColor: Color(0xFF6FA68F), // Adjust the color to match the screenshot
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Text(
              'Terms of Service',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Last updated on 5/1/2024',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 24.0),
            Text(
              ' 1. Acceptance of Terms By creating an account and using SugarSage, you agree to be bound by these terms and conditions ("Terms"). If you do not agree to these Terms, do not use this App.',
              style: TextStyle(
                fontSize: 14.0,
                height: 1.5, // Line spacing
              ),
            ),
            SizedBox(height: 24.0),
            Text(
              ' 2. Service Description SugarSage provides dietary plans and monitors blood sugar levels for individuals with diabetes. The App includes features such as personalized meal suggestions, carbohydrate tracking, and blood sugar level logging.',
              style: TextStyle(
                fontSize: 14.0,
                height: 1.5, // Line spacing
              ),
            ),
            SizedBox(height: 24.0),
            Text(
              ' 3. No Medical AdviceThe App is not a medical device nor should it be considered medical advice. SugarSage is designed to assist in the management of diabetes and is not a substitute for professional medical advice, diagnosis, or treatment. Always seek the advice of your physician or other qualified health provider with any questions you may have regarding a medical condition.',
              style: TextStyle(
                fontSize: 14.0,
                height: 1.5, // Line spacing
              ),
            ),
            SizedBox(height: 24.0),
            CheckboxListTile(
              value: _agreedToTerms,
              onChanged: _setAgreedToTerms,
              title: Text('I agree with all terms and conditions'),
              controlAffinity: ListTileControlAffinity.leading, // positions the checkbox at the start of the tile
            ),
            SizedBox(height: 30.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 126.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: Color(0xFF6FA68F),
                ),
                onPressed: () {
                 /* Navigator.push(context, MaterialPageRoute(builder: (context) => MyAppP()),
                  );*/
                },
                child: Text(
                  'Back',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
