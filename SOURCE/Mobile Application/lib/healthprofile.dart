import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:sugar_sage/GenerateMealPlan.dart';
import 'package:sugar_sage/profilepage.dart';
import 'package:sugar_sage/ActivityTracking.dart';
import 'package:sugar_sage/HomePage.dart';
import 'UserProvider.dart';
import 'food_options.dart';

class FoodReaction {
  String food;
  int rating;

  FoodReaction({required this.food, this.rating = 1});
}

class HealthProfileScreen extends StatefulWidget {
  @override
  _HealthProfileScreenState createState() => _HealthProfileScreenState();
}

class _HealthProfileScreenState extends State<HealthProfileScreen> {
  int _selectedIndex = 0;
  FoodOptions foodOptions = FoodOptions();
  List<FoodReaction> selectedFoods = [];

  final TextEditingController weight = TextEditingController();
  final TextEditingController height = TextEditingController();
  final TextEditingController sugarLevel = TextEditingController();
  final TextEditingController hbA1cScore = TextEditingController();

  String _selectedActivityLevel = 'Sedentary';
  String _selectedDiabeticType = 'Type1';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await foodOptions.loadOptions();
      setState(() {});
    });
    fetchUserHealthProfile();
  }

  void addFoodReaction(String food) {
    if (!selectedFoods.any((element) => element.food == food)) {
      selectedFoods.add(FoodReaction(food: food));
      setState(() {});
    }
  }

  void removeFoodReaction(String food) {
    selectedFoods.removeWhere((element) => element.food == food);
    setState(() {});
  }

  Widget buildFoodReactionField(FoodReaction reaction) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: '${reaction.food} Rating (1-5)',
          labelStyle: TextStyle(color: Colors.grey),
          fillColor: Colors.white70,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(
              color: Colors.green,
              width: 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(
              color: Colors.grey.shade500,
              width: 1.0,
            ),
          ),
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,  // Allows only numeric input
          FilteringTextInputFormatter.allow(RegExp(r'[1-5]')),  // Restricts input to the range 1-5
        ],
        onChanged: (value) {
          setState(() {
            reaction.rating = int.tryParse(value) ?? 1;
          });
        },
      ),
    );
  }

  Future<void> fetchUserHealthProfile() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.userId;
    final url = 'http://10.0.2.2:3001/api/user/healthprofile/get/$userId';

    try {
      final response = await http.post(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'][0];

        setState(() {
          weight.text = data['weight'].toString();
          height.text = data['height'].toString();
          sugarLevel.text = data['sugar_level'].toString();
          hbA1cScore.text = data['hbA1c'].toString();
          _selectedActivityLevel = data['activity_level'];
          _selectedDiabeticType = data['diabetes_type'].replaceAll(' ', '');

          // Update UserProvider with height and weight
          userProvider.setHeightAndWeight(double.parse(data['height'].toString()), double.parse(data['weight'].toString()));
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load health profile: ${response.body}'))
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'))
      );
    }
  }

  Future<void> saveUserHealthProfile() async {
    final userId = Provider.of<UserProvider>(context, listen: false).userId;
    final url = 'http://10.0.2.2:3001/api/user/healthprofile/update/$userId';

    try {
      final response = await http.put(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'weight': weight.text,
            'height': height.text,
            'sugar_level': sugarLevel.text,
            'hbA1c': hbA1cScore.text,
            'activity_level': _selectedActivityLevel,
            'diabetes_type': _selectedDiabeticType,
          })
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Health profile updated successfully'))
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save health profile: ${response.body}'))
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'))
      );
    }
  }

  @override
  void dispose() {
    weight.dispose();
    height.dispose();
    sugarLevel.dispose();
    hbA1cScore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> foodReactionFields = selectedFoods.map((reaction) => buildFoodReactionField(reaction)).toList();

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: double.infinity),
            Image.asset('assets/images/SugarSage_Logo.png', width: 300, height: 150),
            Text(
              'Health Profile',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 10),
                decoration: BoxDecoration(
                  color: Color(0xFFE9F1EE),
                  borderRadius: BorderRadius.circular(50.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 55.0),
                    TextField(
                      controller: weight,
                      decoration: InputDecoration(
                        labelText: 'Weight (KGs)*',
                        labelStyle: TextStyle(color: Colors.grey),
                        fillColor: Colors.white70,
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: Colors.green,
                            width: 1.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: Colors.grey.shade500,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15.0),
                    TextField(
                      controller: height,
                      decoration: InputDecoration(
                        labelText: 'Height (CM)*',
                        labelStyle: TextStyle(color: Colors.grey),
                        fillColor: Colors.white70,
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: Colors.green,
                            width: 1.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: Colors.grey.shade500,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15.0),
                    TextField(
                      controller: sugarLevel,
                      decoration: InputDecoration(
                        labelText: 'Sugar Levels (mg/dl)*',
                        labelStyle: TextStyle(color: Colors.grey),
                        fillColor: Colors.white70,
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: Colors.green,
                            width: 1.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: Colors.grey.shade500,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15.0),
                    TextField(
                      controller: hbA1cScore,
                      decoration: InputDecoration(
                        labelText: 'HbA1c Score (%)*',
                        labelStyle: TextStyle(color: Colors.grey),
                        fillColor: Colors.white70,
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: Colors.green,
                            width: 1.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: Colors.grey.shade500,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15.0),
                    DropdownButtonFormField<String>(
                      value: _selectedActivityLevel,
                      decoration: InputDecoration(
                        labelText: 'Activity Level',
                        labelStyle: TextStyle(color: Colors.grey),
                        fillColor: Colors.white70,
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: Colors.green,
                            width: 1.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: Colors.grey.shade500,
                            width: 1.0,
                          ),
                        ),
                      ),
                      items: [
                        'Sedentary',
                        'Lightly Active',
                        'Moderately Active',
                        'Very Active',
                        'Extra Active'
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedActivityLevel = newValue!;
                        });
                      },
                    ),
                    SizedBox(height: 15.0),
                    DropdownButtonFormField<String>(
                      value: _selectedDiabeticType,
                      decoration: InputDecoration(
                        labelText: 'Diabetic Type',
                        labelStyle: TextStyle(color: Colors.grey),
                        fillColor: Colors.white70,
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: Colors.green,
                            width: 1.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: Colors.grey.shade500,
                            width: 1.0,
                          ),
                        ),
                      ),
                      items: ['Type1', 'Type2'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedDiabeticType = newValue!;
                        });
                      },
                    ),
                    SizedBox(height: 20.0),
                    Theme(
                      data: Theme.of(context).copyWith(
                        primaryColor: Color(0xFF6FA68F),  // Override the primary color for checkbox
                      ),
                      child: MultiSelectDialogField<String>(
                        items: foodOptions.options.map((food) => MultiSelectItem<String>(food, food)).toList(),
                        title: Text("Select Food for Rating"),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(
                            color: Colors.grey.shade500,
                            width: 1.0,
                          ),
                        ),
                        buttonText: Text(
                          "Select Food for Rating",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        onConfirm: (List<String> selectedFoodsList) {
                          setState(() {
                            selectedFoods = selectedFoodsList.map((food) => FoodReaction(food: food)).toList();
                          });
                        },
                        chipDisplay: MultiSelectChipDisplay(
                          onTap: (value) {
                            setState(() {
                              selectedFoods.removeWhere((element) => element.food == value);
                            });
                          },
                          chipColor: Color(0xFF6FA68F),  // Chips color for selected items
                          textStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    ...foodReactionFields,
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        backgroundColor: Color(0xFF6FA68F),
                      ),
                      onPressed: () {
                        saveUserHealthProfile();
                      },
                      child: Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HealthProfileScreen()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GenerateMealPlan()),
      );
    } else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ActivityPage()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }
}
