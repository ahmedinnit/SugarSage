import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'viewmealplan.dart';
import 'package:sugar_sage/healthprofile.dart';// Ensure this import is correct
import 'package:sugar_sage/profilepage.dart';
import 'package:sugar_sage/ActivityTracking.dart';
import 'package:sugar_sage/HomePage.dart';

class GenerateMealPlan extends StatefulWidget {
  @override
  _GenerateMealPlanState createState() => _GenerateMealPlanState();
}

class _GenerateMealPlanState extends State<GenerateMealPlan> {
  int _selectedIndex = 1;  // Default to the middle item

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: ListView(
        children: [
          SizedBox(height: 20,),
          Center(
            child: Image.asset(
              'assets/images/SugarSage_Logo.png',
              width: 300,
              height: 60,
            ),
          ),
          SizedBox(height: 170,),
          ViewMealPlanWidget(),  // Rename to avoid confusion with the ViewMealPlan class
          EditFoodItems(),
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

  Widget ViewMealPlanWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF8FB1A5),
          borderRadius: BorderRadius.circular(20),
        ),
        height: 90,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Image.asset(
                'images/food.png',
                width: 50,
                height: 50,
                color: Color(0xFF315045),
              ),
            ),
            Expanded(
              child: Text(
                "Generate Meal Plan",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewMealPlan()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF456E5C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
                child: Text(
                  'View Now',
                  style: TextStyle(
                    fontSize: 16,
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

  Widget EditFoodItems() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF8FB1A5),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}