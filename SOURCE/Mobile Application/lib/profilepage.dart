import 'package:flutter/material.dart';
import 'dart:ui';  // Needed for the ImageFilter used in BackdropFilter
import 'package:sugar_sage/Settings.dart';
import 'package:sugar_sage/healthprofile.dart';
import 'package:sugar_sage/GenerateMealPlan.dart';
import 'package:sugar_sage/ActivityTracking.dart';
import 'package:sugar_sage/HomePage.dart';
import 'package:sugar_sage/TermsAndCondition.dart';
import 'package:sugar_sage/editprofile.dart';
import 'login.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 4; // Default to the middle item for demo purposes

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HealthProfileScreen()),);
    }
    if (index == 1) { // Assuming 'restaurant_menu' is at index 1
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GenerateMealPlan()),
      );
    }
    if(index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen()),
      );
    }
    if(index == 3){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ActivityPage()),);
    }
    if(index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),);
    }

  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Are you sure you want to logout?',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        child: Text('Yes', style: TextStyle(color: Colors.red)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                        },
                      ),
                      ElevatedButton(
                        child: Text('No', style: TextStyle(color: Colors.green)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

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
              width: 250,
              height: 100,
            ),
          ),
          profileSection(),
          SizedBox(height: 40),
          menuOption(Icons.edit, "Edit Profile"),
          menuOption(Icons.settings, "Settings"),
          menuOption(Icons.description, "Terms and Policy"),
          menuOption(Icons.logout, "Logout"),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_information, size: 38),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu, size: 38),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 38),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_run, size: 38),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, size: 38),
            activeIcon: Icon(Icons.person, size: 38),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF456E5C),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        backgroundColor: Color(0xFFF0F0F0),
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }

  Widget profileSection() {
    return Center(
      child: CircleAvatar(
        radius: 80,
        backgroundColor: Colors.grey[300],
        child: Icon(Icons.person, size: 80, color: Colors.grey[600]),
      ),
    );
  }

  Widget menuOption(IconData icon, String text) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 13),
      decoration: BoxDecoration(
        color: Color(0x516FA68F),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: Color(0xFF456E5C)),
        title: Text(text),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey[700]),
        onTap: () {
          if (text == "Logout") {
            _showLogoutDialog();
          }
          if(text == "Settings"){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsScreen()),
            );
          }
          if(text == "Terms and Policy"){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TermsAndPolicy()),
            );
          }
          if(text == "Edit Profile"){Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen()),);}
        },
      ),
    );
  }
}
