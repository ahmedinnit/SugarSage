import 'package:flutter/cupertino.dart';
import 'package:pedometer/pedometer.dart';

class StepTrackerService with ChangeNotifier {
  static final StepTrackerService _instance = StepTrackerService._internal();

  factory StepTrackerService() {
    return _instance;
  }

  StepTrackerService._internal() {
    _initializeStepCounts();
    _initializePedometer();
  }

  int _stepCount = 0;
  int _initialStepCount = 0;
  List<int> _stepCounts = []; // List to store last up to 10 current step counts
  List<int> _previousSteps = []; // Private list for previous step counts
  List<int> _previousTargetSteps = []; // Private list for previous target steps
  List<Map<String, dynamic>> _sleepData = [];
  int _targetSteps = 100; // Default target steps
  double caloriesPerStep = 0.04; // Approximation
  double stepLength = 0.00078; // Average step length in km
  double targetCalories = 400; // Default target calories
  bool _goalAchieved = false;

  int get stepCount => _stepCount - _initialStepCount;
  List<int> get stepCounts => _stepCounts;
  List<Map<String, dynamic>> get sleepData => _sleepData;
  int get target => _targetSteps;
  double get caloriesBurned => stepCount * caloriesPerStep;
  double get distanceCovered => stepCount * stepLength; // Distance in km
  double get targetCaloriesValue => targetCalories;
  bool get goalAchieved => _goalAchieved;

  // Public getter for previousSteps
  List<int> get previousSteps => _previousSteps;

  // Public getter for previousTargetSteps
  List<int> get previousTargetSteps => _previousTargetSteps;

  void _initializeStepCounts() {
    for (int i = 0; i < 10; i++) {
      _stepCounts.add(0); // Initialize step counts with 0
    }
    notifyListeners();
  }

  void _initializePedometer() async {
    try {
      Pedometer.stepCountStream.listen(_onStepCount).onError(_onError);
    } catch (e) {
      print('Error initializing Pedometer: $e');
    }
  }

  void _onStepCount(StepCount event) {
    if (!_goalAchieved) {
      if (_initialStepCount == 0) {
        _initialStepCount = event.steps;
      }
      _stepCount = event.steps;
      if (stepCount >= _targetSteps) {
        _goalAchieved = true;
      }
      _updateStepCounts();
      notifyListeners();
    }
  }

  void _onError(error) {
    print('Pedometer Error: $error');
  }

  void resetStepCount() {
    _stepCount = 0;
    _initialStepCount = 0;
    _stepCounts = [];
    _goalAchieved = false;
    notifyListeners();
  }

  void updateTargetSteps(int newTargetSteps) {
    if (_previousTargetSteps.length >= 10) {
      _previousTargetSteps.removeAt(0);
      _previousSteps.removeAt(0);
    }
    _previousSteps.add(stepCount);
    _previousTargetSteps.add(_targetSteps);

    _targetSteps = newTargetSteps;
    resetStepCount(); // Reset the step count only when the target steps are updated
    notifyListeners();
  }

  void _updateStepCounts() {
    if (_stepCounts.length >= 10) {
      _stepCounts.removeAt(0);
    }
    _stepCounts.add(stepCount);
    notifyListeners();
  }
}
