import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sugar_sage/ActivityTracking.dart';
import 'package:sugar_sage/NutritionalValue.dart';
import 'package:sugar_sage/healthprofile.dart';
import 'profilepage.dart';
import 'package:sugar_sage/HomePage.dart';
import 'package:sugar_sage/GenerateMealPlan.dart';

class ViewMealPlan extends StatefulWidget {
  @override
  _ViewMealPlanState createState() => _ViewMealPlanState();
}

class _ViewMealPlanState extends State<ViewMealPlan> {
  int _selectedIndex = 1;
  List<String> foodItems = [];
  List<MealPlanBox> mealPlanBoxes = [];
  final int bmrValue = 2000;
  int currentBmrValue = 2000;
  Color bmrBorderColor = Colors.green;

  @override
  void initState() {
    super.initState();
    fetchMealPlanData();
  }

  Future<void> fetchMealPlanData() async {
    // Commented out the API request code
    // final response = await http.get(Uri.parse('https://1fe6-39-60-249-131.ngrok-free.app/predict_model_01'));

    // if (response.statusCode == 200) {
    //   final data = json.decode(response.body);
    final data = {
      "Top RecScore": {
        "food_names": [
          "Wheat Bread Paratha",
          "Wheat Bread Puri",
          "Wheat Bread Double Roti",
          "Wheat Flour Biscuit"
        ],
        "predictions": [
          9,
          4,
          1,
          1
        ],
        "carbs": [
          39.8,
          44.3,
          54.8,
          73.7
        ],
        "fats": [
          21.4,
          9.1,
          1.3,
          7.2
        ],
        "Proteins": [
          8.6,
          8.6,
          8.4,
          9.1
        ],
        "cal": [
          364,
          293,
          263,
          440
        ]
      }
    };

    List<String> foodNames = List<String>.from(data['Top RecScore']?['food_names'] as Iterable);
    setState(() {
      foodItems = foodNames;
      mealPlanBoxes = foodItems.map((item) => MealPlanBox(
        title: item,
        items: [],
        onBoxTap: () {},
        onNutritionalValuesTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => NutritionDetailsScreen()));
        },
        onMealTypeSelected: _onMealTypeSelected,
      )).toList();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HealthProfileScreen()),);
    }
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GenerateMealPlan()),
      );
    }
    if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen()),);
    }
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ActivityPage()),);
    }
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),);
    }
  }

  void _updateBmrValue(String value) {
    setState(() {
      currentBmrValue = int.tryParse(value) ?? 0;
      double difference = (currentBmrValue - bmrValue).abs() / bmrValue;
      if (currentBmrValue > bmrValue * 1.1) {
        bmrBorderColor = Colors.red;
      } else {
        int greenValue = (255 * (1 - difference)).clamp(0, 255).toInt();
        bmrBorderColor = Colors.green;
      }
    });
  }

  void _onMealTypeSelected(String mealType, bool isSelected) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: double.infinity),
            Image.asset('assets/images/SugarSage_Logo.png', width: 300, height: 150),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: mealPlanBoxes.map((box) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: box,
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: mealPlanBoxes.any((box) => box.isSelected) ? () {
                List<MealPlanBox> selectedMeals = mealPlanBoxes.where((box) => box.isSelected).toList();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectedMealsScreen(selectedMeals: selectedMeals, currentBmrValue: currentBmrValue),
                  ),
                );
              } : null,
              child: Text('Save'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6FA68F),  // Background color
                foregroundColor: Colors.white,  // Text color
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.medical_information, size: 38), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu, size: 38), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.home, size: 38), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.directions_run, size: 38), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline, size: 38), label: ''),
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

  Widget _buildTextFieldContainer(String? labelText, String value, Color borderColor) {
    return Container(
      width: 60,
      padding: EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        children: [
          if (labelText != null)
            Text(
              labelText,
              style: TextStyle(color: borderColor, fontSize: 10),
            ),
          Text(
            value,
            style: TextStyle(color: borderColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class MealPlanBox extends StatefulWidget {
  final String title;
  final List<String> items;
  final VoidCallback onBoxTap;
  final VoidCallback onNutritionalValuesTap;
  final Function(String, bool) onMealTypeSelected;
  bool isSelected = false;
  String? selectedMealType;

  MealPlanBox({
    Key? key,
    required this.title,
    required this.items,
    required this.onBoxTap,
    required this.onNutritionalValuesTap,
    required this.onMealTypeSelected,
  }) : super(key: key);

  @override
  _MealPlanBoxState createState() => _MealPlanBoxState();
}

class _MealPlanBoxState extends State<MealPlanBox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onBoxTap,
      child: Container(
        padding: EdgeInsets.all(25.0),
        decoration: BoxDecoration(
          color: widget.isSelected ? Color(0xFF5C7A67) : Color(0xFF8FB1A5), // Change color when selected
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 4,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            ...widget.items.take(8).map((item) => Text(item)).toList(),
            if (widget.items.length > 8) Text('...'),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                DropdownButton<String>(
                  value: widget.selectedMealType,
                  hint: Text('Which Meal', style: TextStyle(color: Colors.white)), // Hint text color
                  items: <String>['Breakfast', 'Lunch', 'Supper', 'Snack', 'Dinner'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(color: Colors.white)), // Dropdown item text color
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        if (widget.selectedMealType != null && widget.selectedMealType != newValue) {
                          widget.onMealTypeSelected(widget.selectedMealType!, false);
                        }
                        widget.selectedMealType = newValue;
                        widget.isSelected = true;
                        widget.onMealTypeSelected(newValue, true);
                      });
                    }
                  },
                  dropdownColor: Color(0xFF456E5C), // Dropdown background color
                  iconEnabledColor: Colors.white, // Dropdown icon color
                  style: TextStyle(color: Colors.white), // Selected item text color
                  underline: Container(
                    height: 2,
                    color: Colors.white, // Underline color
                  ),
                ),
                if (widget.isSelected)
                  IconButton(
                    icon: Icon(Icons.remove_circle_outline, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        widget.onMealTypeSelected(widget.selectedMealType!, false);
                        widget.selectedMealType = null;
                        widget.isSelected = false;
                      });
                    },
                  ),
              ],
            ),
            if (widget.selectedMealType != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Center(
                  child: Text(
                    widget.selectedMealType!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16, // Slightly bigger font
                      fontWeight: FontWeight.bold, // Bold text
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

class SelectedMealsScreen extends StatefulWidget {
  final List<MealPlanBox> selectedMeals;
  final int currentBmrValue;

  SelectedMealsScreen({required this.selectedMeals, required this.currentBmrValue});

  @override
  _SelectedMealsScreenState createState() => _SelectedMealsScreenState();
}

class _SelectedMealsScreenState extends State<SelectedMealsScreen> {
  final int bmrValue = 2000;
  Color bmrBorderColor = Colors.grey;
  bool showFinalMeals = false;

  void _updateBmrValue(String value) {
    setState(() {
      int currentBmrValue = int.tryParse(value) ?? 0;
      double difference = (currentBmrValue - bmrValue).abs() / bmrValue;
      if (currentBmrValue > bmrValue * 1.1) {
        bmrBorderColor = Colors.red;
      } else {
        int greenValue = (255 * (1 - difference)).clamp(0, 255).toInt();
        bmrBorderColor = Color.fromARGB(255, 0, greenValue, 0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<MealPlanBox> orderedMeals = widget.selectedMeals
      ..sort((a, b) => _mealTypeOrder(a.selectedMealType!).compareTo(_mealTypeOrder(b.selectedMealType!)));

    return Scaffold(
      appBar: AppBar(
        title: Text('Portion Size Generation'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (!showFinalMeals) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
                child: Text(
                  'Selected Meals',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              ...orderedMeals.map((box) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                  child: Container(
                    padding: EdgeInsets.all(25.0),
                    decoration: BoxDecoration(
                      color: Color(0xFF8FB1A5), // Change color for selected meals
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              box.title,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        if (box.selectedMealType != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Center(
                              child: Text(
                                box.selectedMealType!,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16, // Slightly bigger font
                                  fontWeight: FontWeight.bold, // Bold text
                                ),
                              ),
                            ),
                          ),
                        SizedBox(height: 10.0),
                        ...box.items.take(8).map((item) => Text(item)).toList(),
                        if (box.items.length > 8) Text('...'),
                        SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                );
              }).toList(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: widget.currentBmrValue <= bmrValue * 1.1 ? () {
                  setState(() {
                    showFinalMeals = true;
                  });
                } : null,
                child: Text('Finish'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.currentBmrValue <= bmrValue * 1.1 ? Color(0xFF6FA68F) : Colors.grey,  // Background color
                  foregroundColor: Colors.white,  // Text color
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ] else ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
                child: Text(
                  'Final Selected Meals',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              ...orderedMeals.map((box) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                  child: Container(
                    padding: EdgeInsets.all(25.0),
                    decoration: BoxDecoration(
                      color: Color(0xFF8FB1A5), // Change color for selected meals
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              box.title,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTextFieldContainer(String labelText, Color borderColor) {
    return Container(
      width: 60,
      padding: EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Center(
        child: Text(
          labelText,
          style: TextStyle(color: borderColor),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  int _mealTypeOrder(String mealType) {
    switch (mealType) {
      case 'Breakfast':
        return 0;
      case 'Lunch':
        return 1;
      case 'Supper':
        return 2;
      case 'Snack':
        return 3;
      case 'Dinner':
        return 4;
      default:
        return 5;
    }
  }
}
