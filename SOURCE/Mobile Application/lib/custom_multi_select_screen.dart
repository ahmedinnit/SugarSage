import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CustomMultiSelectScreen extends StatefulWidget {
  @override
  _CustomMultiSelectScreenState createState() => _CustomMultiSelectScreenState();
}

class _CustomMultiSelectScreenState extends State<CustomMultiSelectScreen> {
  List<String> _options = ['Option 1', 'Option 2', 'Option 3']; // Define your options
  Map<String, bool> _selectedOptions = {};

  @override
  void initState() {
    super.initState();
    // Initialize all options as not selected
    _options.forEach((option) {
      _selectedOptions[option] = false;
    });
  }

  void _handleCheckboxChange(String option, bool? value) {
    // Update the state when a checkbox is tapped
    setState(() {
      _selectedOptions[option] = value!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Custom Multi-Select")),
      body: ListView(
        children: _options.map((option) {
          return CheckboxListTile(
            title: Text(option),
            value: _selectedOptions[option],
            onChanged: (bool? value) {
              _handleCheckboxChange(option, value);
            },
            activeColor: Color(0xFF6FA68F), // Custom checkbox color when selected
            checkColor: Colors.white, // Color of the tick
          );
        }).toList(),
      ),
    );
  }
}
