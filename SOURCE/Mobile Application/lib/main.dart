import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugar_sage/step_tracker_service.dart'; // Ensure you have the correct import path
import 'splash.dart';
import 'package:sugar_sage/UserProvider.dart';

void main() {
  runApp(SugarSageApp());
}

class SugarSageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => StepTrackerService()), // Provide StepTrackerService here
      ],
      child: MaterialApp(
        title: 'SugarSage',
        theme: ThemeData(
          checkboxTheme: CheckboxThemeData(
            checkColor: MaterialStateProperty.all(Color(0xFFFFFFFF)), // White check
            fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return Color(0xFF6FA68F); // Green when selected
              }
              return Colors.grey; // Default color
            }),
          ),
        ),

        home: Splash(), // Starting screen
      ),
    );
  }
}
