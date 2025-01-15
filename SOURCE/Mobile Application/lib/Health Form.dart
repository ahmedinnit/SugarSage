import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Terms.dart';

class FormPage2 extends StatefulWidget {
  final String email;
  final String password;
  final String fname;
  final String lname;
  final String dob;
  final String? gender;
  final String? country;
  final String? city;

  FormPage2({
    required this.email,
    required this.password,
    required this.fname,
    required this.lname,
    required this.dob,
    this.gender,
    this.country,
    this.city,
  });

  @override
  _FormPage2State createState() => _FormPage2State();
}

class _FormPage2State extends State<FormPage2> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _Hba1cController = TextEditingController();

  String? _selectedActivityLevel;
  String? _selectedDiabetesType;
  String _activityLevelError = '';

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate() && _selectedActivityLevel != null && _selectedDiabetesType != null) {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3001/api/auth/signup'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'email': widget.email,
          'password': widget.password,
          'fname': widget.fname,
          'lname': widget.lname,
          'dob': widget.dob,
          'gender': widget.gender,
          'country': widget.country,
          'city': widget.city,
          'weight': _weightController.text,
          'height': _heightController.text,
          'activityLevel': _selectedActivityLevel,
          'hbA1cScore': _Hba1cController.text,
          'diabetesType': _selectedDiabetesType,
        }),
      );

      if (response.statusCode == 200) {
        print('Registration successful');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Terms()),
        );
      } else {
        print('Registration failed: ${response.body}');
      }
    } else {
      setState(() {
        _activityLevelError = _selectedActivityLevel == null ? 'Please select an activity level' : '';
      });
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _Hba1cController.dispose();
    super.dispose();
  }

  String? _validateWeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    final numValue = num.tryParse(value);
    if (numValue == null || numValue < 45 || numValue > 150 || !RegExp(r'^\d+(\.\d{1})?$').hasMatch(value)) {
      return 'Enter a valid weight (45-150 kg, up to 1 decimal)';
    }
    return null;
  }

  String? _validateHeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    final numValue = num.tryParse(value);
    if (numValue == null || numValue < 1.5 || numValue > 2 || !RegExp(r'^\d+(\.\d{1})?$').hasMatch(value)) {
      return 'Enter a valid height (1.5-2 m, up to 1 decimal)';
    }
    return null;
  }

  String? _validateHba1c(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    final numValue = num.tryParse(value);
    if (numValue == null || numValue < 4 || numValue > 8.9 || !RegExp(r'^\d+(\.\d{1})?$').hasMatch(value)) {
      return 'Enter a valid HbA1c score (4-8.9%, up to 1 decimal)';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 110.0,
                  decoration: BoxDecoration(
                    color: Color(0xFF6FA68F),
                    image: DecorationImage(
                      image: AssetImage('images/logo.png'),
                      fit: BoxFit.none,
                      scale: 2.0,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                  ),
                ),
                SizedBox(height: 12.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 26.0),
                  child: Text(
                    'Kindly enter your latest details',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 50.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 26.0),
                  child: TextFormField(
                    controller: _weightController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Weight (kg)*',
                      labelStyle: TextStyle(color: Colors.grey),
                      fillColor: Colors.white,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: Colors.grey.shade500,
                          width: 1.0,
                        ),
                      ),
                    ),
                    cursorColor: Colors.green,
                    validator: _validateWeight,
                  ),
                ),
                SizedBox(height: 35.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 26.0),
                  child: TextFormField(
                    controller: _heightController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Height (m)*',
                      labelStyle: TextStyle(color: Colors.grey),
                      fillColor: Colors.white,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: Colors.grey.shade500,
                          width: 1.0,
                        ),
                      ),
                    ),
                    cursorColor: Colors.green,
                    validator: _validateHeight,
                  ),
                ),
                SizedBox(height: 35.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 26.0),
                  child: TextFormField(
                    controller: _Hba1cController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'HbA1c Score (%)*',
                      labelStyle: TextStyle(color: Colors.grey),
                      fillColor: Colors.white,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: Colors.grey.shade500,
                          width: 1.0,
                        ),
                      ),
                    ),
                    cursorColor: Colors.green,
                    validator: _validateHba1c,
                  ),
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 26.0, vertical: 15.0),
                  child: DropdownButtonFormField<String>(
                    value: _selectedActivityLevel,
                    decoration: InputDecoration(
                      labelText: 'Activity Level',
                      labelStyle: TextStyle(color: Colors.grey),
                      fillColor: Colors.white,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: Colors.grey.shade500,
                          width: 1.0,
                        ),
                      ),
                    ),
                    items: <String>['Sedentary', 'Lightly Active', 'Moderately Active', 'Very Active', 'Extra Active'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedActivityLevel = newValue;
                      });
                    },
                    dropdownColor: Colors.white,
                    validator: (value) => value == null ? 'Please select an activity level' : null,
                  ),
                ),
                SizedBox(height: 5.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 26.0, vertical: 15.0),
                  child: DropdownButtonFormField<String>(
                    value: _selectedDiabetesType,
                    decoration: InputDecoration(
                      labelText: 'Diabetes Type',
                      labelStyle: TextStyle(color: Colors.grey),
                      fillColor: Colors.white,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: Colors.grey.shade500,
                          width: 1.0,
                        ),
                      ),
                    ),
                    items: <String>['Type 1', 'Type 2'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Container(
                          color: Colors.white,
                          child: Text(value),
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedDiabetesType = newValue;
                      });
                    },
                    dropdownColor: Colors.white,
                    validator: (value) => value == null ? 'Please select a diabetes type' : null,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 120.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      backgroundColor: Color(0xFF6FA68F),
                    ),
                    onPressed: _registerUser,
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
