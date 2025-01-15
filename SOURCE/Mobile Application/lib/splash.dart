import 'package:flutter/material.dart';
import 'login.dart'; // Make sure this points to your LoginPage widget

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _bounceAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 3), // Duration of 3 seconds for the whole animation
      vsync: this,
    );

    _bounceAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(0, -0.1), // Bounces a few centimeters upward
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0, 0.66, // Interval for bouncing
        curve: Curves.bounceOut,
      ),
    ));

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.66, 1.0, // Blinking starts after the bouncing
        curve: Curves.linear,
      ),
    ));

    // Start the animation
    _animationController.forward().whenComplete(_navigateToHome);
  }

  _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6FA68F),
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Opacity(
              opacity: _bounceAnimation.value.dy == -0.1 ? _opacityAnimation.value : 1.0,
              child: SlideTransition(
                position: _bounceAnimation,
                child: Container(
                  width: 300,
                  height: 300,
                  child: Image.asset('assets/images/logo.png'), // Ensure the image asset path is correct
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
