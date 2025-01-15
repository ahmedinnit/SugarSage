import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'profilepage.dart';
import 'GenerateMealPlan.dart';
import 'healthprofile.dart';
import 'HomePage.dart';
import 'step_tracker_service.dart';

class ActivityPage extends StatefulWidget {
  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  int _selectedIndex = 3; // Default index for navigation bar

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(context, MaterialPageRoute(builder: (context) => HealthProfileScreen()));
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => GenerateMealPlan()));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (context) => ActivityPage()));
        break;
      case 4:
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
        break;
    }
  }

  void _editTargetSteps(BuildContext context, StepTrackerService stepTrackerService) {
    TextEditingController _targetStepController = TextEditingController();
    _targetStepController.text = stepTrackerService.target.toString();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF6FA68F),
          title: Text('Update Target Steps', style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: _targetStepController,
            decoration: InputDecoration(
              labelText: 'Enter target steps',
              labelStyle: TextStyle(color: Colors.white),
            ),
            keyboardType: TextInputType.number,
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                int newTargetSteps = int.tryParse(_targetStepController.text) ?? stepTrackerService.target;
                stepTrackerService.updateTargetSteps(newTargetSteps);
                Navigator.of(context).pop();
              },
              child: Text('Update', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  List<BarChartGroupData> _buildStepHistoryData(List<int> stepHistory, List<int> targetHistory) {
    return List.generate(stepHistory.length, (index) {
      double percent = targetHistory[index] != 0 ? (stepHistory[index] / targetHistory[index]) * 100 : 0; // Avoid division by zero
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: percent, // Use percentage for the Y value
            color: Color(0xFF6FA68F),
            borderRadius: BorderRadius.circular(6),
            width: 16,
          )
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StepTrackerService(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(10.0),
          child: AppBar(
            backgroundColor: Colors.transparent,
          ),
        ),
        body: Consumer<StepTrackerService>(
          builder: (context, stepTrackerService, child) {
            double progress = stepTrackerService.stepCount / stepTrackerService.target * 100;
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 36.0),
                    child: Image.asset('assets/images/SugarSage_Logo.png', height: 50, color: Color(0xFF6FA68F)),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 100.0),
                      child: SizedBox(
                        width: 200,
                        height: 200,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            PieChart(
                              PieChartData(
                                sections: [
                                  PieChartSectionData(
                                    value: progress,
                                    color: Color(0xFF6FA68F),
                                    radius: 80,
                                    title: '${progress.toStringAsFixed(1)}%',
                                    titleStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  PieChartSectionData(
                                    value: 100 - progress,
                                    color: Color(0xFFE9F1EE),
                                    radius: 80,
                                    title: '',
                                  ),
                                ],
                              ),
                            ),
                            if (stepTrackerService.goalAchieved)
                              Positioned(
                                top: 140,
                                child: Text(
                                  'Congratulations!!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text('Steps', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                Text('${stepTrackerService.stepCount}', style: TextStyle(fontSize: 16)),
                              ],
                            ),
                            Column(
                              children: [
                                Text('Calories', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                Text('${stepTrackerService.caloriesBurned.toStringAsFixed(2)} kcal', style: TextStyle(fontSize: 16)),
                              ],
                            ),
                            Column(
                              children: [
                                Text('Target Steps', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                Text('${stepTrackerService.target}', style: TextStyle(fontSize: 16)),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => _editTargetSteps(context, stepTrackerService),
                            child: Text('Edit Target Steps', style: TextStyle(fontSize: 12, color: Colors.black45)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text('Your Step History',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 3.5,
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: BarChart(
                            BarChartData(
                              backgroundColor: Colors.white,
                              alignment: BarChartAlignment.spaceAround,
                              maxY: 100,
                              barGroups: _buildStepHistoryData(stepTrackerService.previousSteps, stepTrackerService.previousTargetSteps),
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),  // No Y-axis titles
                                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),  // No right side titles
                                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),  // No top titles
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,  // Show bottom titles
                                    getTitlesWidget: (value, meta) {
                                      return Text('${value.toInt() + 1}', style: TextStyle(color: Colors.black));  // Labeling x-axis correctly
                                    },
                                  ),
                                ),
                              ),
                              gridData: FlGridData(show: false),
                              borderData: FlBorderData(
                                show: true,
                                border: Border(
                                  bottom: BorderSide(color: Colors.black45, width: 1),
                                  right: BorderSide(color: Colors.black45, width: 1),
                                  left: BorderSide(color: Colors.black45, width: 1),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
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
      ),
    );
  }
}
