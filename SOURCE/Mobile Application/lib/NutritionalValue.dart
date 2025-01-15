import 'package:flutter/material.dart';

class NutritionDetailsScreen extends StatelessWidget {
  final Map<String, String> nutritionData = {
    'Carbs (kcal)': '135',
    'Fats (g)': '8',
    'Protein (g)': '3',
    'Protein (g)': '3',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: double.infinity), // Ensures the column takes full width
            Image.asset('assets/images/SugarSage_Logo.png', width: 300, height: 150),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                padding:  const EdgeInsets.fromLTRB(20.0,0,20,10),  // Adjust padding inside the container
                decoration: BoxDecoration(
                  color: Color(0xFFE9F1EE), // Light background color
                  borderRadius: BorderRadius.circular(50.0), // Adjust border radius
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 3),  // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 15.0, // Ensures the column takes full width
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15,),
                      decoration: BoxDecoration(
                        color: Colors.white, // Specific background color for the text container
                        borderRadius: BorderRadius.circular(10), // Rounded edges
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 2), // subtle shadow
                          ),
                        ],
                      ),
                      child: Text(
                        '1. Banana Smoothie',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ...nutritionData.entries.map((entry) => ListTile(
                      title: Text(entry.key),
                      trailing: Text(entry.value),
                    )).toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
