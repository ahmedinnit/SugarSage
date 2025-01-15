import 'package:flutter/material.dart';
import 'HomePage.dart';


class EatHealthy extends StatefulWidget {
  @override
  _EatHealthyState createState() => _EatHealthyState();
}

class _EatHealthyState extends State<EatHealthy> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages = [
      OnboardingPage(
        logoHeight: 130.0, // New height for the logo
        title: 'Eat Healthy',
        description: 'Maintaining good health should be the primary focus of everyone',
        image: 'images/eathealthy1.JPG', // Replace with your asset image path
      ),
      OnboardingPage(
        logoHeight: 130.0, // New height for the logo
        title: 'Healthy and Local Recipes',
        description: 'Have access to healthy and local recipes',
        image: 'images/eathealthy2.JPG', // Replace with your asset image path
      ),
      OnboardingPage(
        logoHeight: 130.0, // New height for the logo
        title: 'Track Your Health',
        description: 'With amazing inbuilt tools you can track your progress',
        image: 'images/eathealthy3.JPG', // Replace with your asset image path
      ),
    ];
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _pages.length; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: isActive ? 12.0 : 8.0,
      width: isActive ? 15.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? Theme.of(context).primaryColor : Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: PageView(
                physics: ClampingScrollPhysics(),
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: _pages,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildPageIndicator(),
            ),
            SizedBox(height: 30.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 106.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: Color(0xFF6FA68F),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                },
                child: Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: 14,
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

class OnboardingPage extends StatelessWidget {
  final double logoHeight;
  final String image;
  final String title;
  final String description;

  OnboardingPage({
    required this.logoHeight,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          'images/logo.png', // Replace with your actual logo path
          height: logoHeight,
          color: Color(0xFF6FA68F),
        ),
        SizedBox(height: 20),
        Image.asset(image),
        SizedBox(height: 30),
        Text(
          title,
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 15),
        Text(
          description,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }
}
