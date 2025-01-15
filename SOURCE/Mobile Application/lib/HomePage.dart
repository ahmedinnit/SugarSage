import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugar_sage/viewmealplan.dart';
import 'UserProvider.dart';
import 'healthprofile.dart';
import 'GenerateMealPlan.dart';
import 'profilepage.dart';
import 'ActivityTracking.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 2; // Default to the home item

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HealthProfileScreen()),
      );
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
        MaterialPageRoute(builder: (context) => ProfileScreen()),
      );
    }
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ActivityPage()),
      );
    }
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false; // Disable back button
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Image.asset(
            'assets/images/SugarSage_Logo.png',
            height: 100,
            color: Color(0xFF6FA68F),
          ),
        ),
        body: ListView(
          children: [
            hellocontainer(),
            SizedBox(height: 16),
            OnboardingSection(),
            sugarLevelContainer(),
            FavouriteMeal(),
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
      ),
    );
  }

  Widget hellocontainer() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Image.asset(
                'images/user.png',
                width: 40,
                height: 40,
                color: Color(0xFF315045),
              ),
            ),
            Expanded(
              child: Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  return Text(
                    "Hello ${userProvider.username}",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sugarLevelContainer() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF8FB1A5),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your latest sugar level",
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "100 mg/dl",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget FavouriteMeal() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF8FB1A5),
          borderRadius: BorderRadius.circular(20),
        ),
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Image.asset(
                'images/favmeal.png',
                width: 50,
                height: 50,
              ),
            ),
            Expanded(
              child: Text(
                "View Meals",
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
}

class OnboardingSection extends StatefulWidget {
  @override
  _OnboardingSectionState createState() => _OnboardingSectionState();
}

class _OnboardingSectionState extends State<OnboardingSection> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Map<String, String>> _articles = [
    {
      'image': 'images/bot.png',
      'text': 'All you need to know about Glycemic Index and diabetes.',
      'summary': 'This comprehensive article provides an in-depth overview of diabetes, a chronic condition characterized by the body’s inability to process blood glucose effectively. It covers the main types of diabetes, including type 1, type 2, and gestational diabetes. Type 1 diabetes is an autoimmune condition where the body attacks insulin-producing cells. Type 2 diabetes, the most common form, results from the bodys ineffective use of insulin. Gestational diabetes occurs during pregnancy and can increase the risk of developing type 2 diabetes later in life. The article also delves into the various treatment options available, such as lifestyle changes, medications, and insulin therapy, tailored to manage each specific type of diabetes.'
    },
    {
      'image': 'images/bot.png',
      'text': 'Explore local recipes that combine tradition and health.',
      'summary': 'This article highlights the alarming rise of diabetes mellitus to epidemic levels globally. It emphasizes the importance of early diagnosis and screening, particularly in underrepresented and underserved populations. The authors explain the use of hemoglobin A1c criteria for diagnosing different types of diabetes, excluding gestational diabetes. They discuss the challenges and importance of screening for diabetes and prediabetes to prevent the onset of complications. The article underscores the need for public health initiatives and policies aimed at improving diabetes awareness, screening, and management to curb the epidemic.'
    },
    {
      'image': 'images/bot.png',
      'text': 'Track your health metrics to maintain or improve your lifestyle.',
      'summary': 'This detailed article delves into type 2 diabetes, the most prevalent form of diabetes. It explains how type 2 diabetes is diagnosed when blood glucose levels are persistently elevated over time. The article covers the causes of type 2 diabetes, which include genetic factors, obesity, and physical inactivity. It also outlines the common symptoms such as frequent urination, increased thirst, and unexplained weight loss. Treatment options are thoroughly discussed, emphasizing the role of lifestyle changes, including a balanced diet and regular exercise, in managing the condition. The article also highlights the importance of medications and insulin therapy for those who need it.'
    },
  ];

  Widget _buildPageIndicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Color(0xFF456E5C) : Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  List<Widget> _buildPageIndicators() {
    List<Widget> list = [];
    for (int i = 0; i < _articles.length; i++) {
      list.add(i == _currentPage ? _buildPageIndicator(true) : _buildPageIndicator(false));
    }
    return list;
  }

  void _showSummaryDialog(String summary) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Article Summary"),
          content: Text(summary),
          actions: [
            TextButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF8FB1A5),
          borderRadius: BorderRadius.circular(20),
        ),
        height: 200,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemCount: _articles.length,
              itemBuilder: (_, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _articles[index]['text']!,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 27),
                            ElevatedButton(
                              onPressed: () {
                                _showSummaryDialog(_articles[index]['summary']!);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF456E5C),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                              ),
                              child: Text(
                                'Read now',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.asset(
                          _articles[index]['image']!,
                          width: 100,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Positioned(
              bottom: 10.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildPageIndicators(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
