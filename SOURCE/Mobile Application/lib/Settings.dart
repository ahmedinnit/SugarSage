import 'package:flutter/material.dart';
import 'package:sugar_sage/forgotpassword.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
    ),
    body: ListView(
        children: [
            Center(
              child: Image.asset(
                'assets/images/SugarSage_Logo.png',
                width: 300,
                height: 100,
              ),
            ),
            SizedBox(height: 30,),
            Center(
              child: Text(
                'Setting',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
              ),
            ),
            SizedBox(height: 50,),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 40, vertical: 25),
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6), // Add padding around the ListTile
            decoration: BoxDecoration(
              color: Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              title: Text('Change Password'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordPage()));
              },
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 40, vertical: 25),
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6), // Add padding around the ListTile
            decoration: BoxDecoration(
              color: Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: SwitchListTile(
              title: Text('Push notifications'),
              value: true,
              onChanged: (bool value) {
                // TODO: Implement push notification toggle logic
                // setState(() { _pushNotificationsEnabled = value; });
              },
            ),
          ),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 40, vertical: 25),
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6), // Add padding around the ListTile
            decoration: BoxDecoration(
              color: Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: SwitchListTile(
              title: Text('Dark Mode'),
              value: true,
              onChanged: (bool value) {
                // TODO: Implement push notification toggle logic
                // setState(() { _pushNotificationsEnabled = value; });
              },
            ),
          ),
          ],
      ),
    );
  }
}
