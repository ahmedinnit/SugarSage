import 'package:flutter/material.dart';
import 'package:sugar_sage/Personal form.dart'; // Make sure this path is correct

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String? _emailError;
  String? _passwordError;
  bool _isPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  void dispose() {
    _emailController.removeListener(_onEmailChanged);
    _emailController.dispose();
    _passwordController.removeListener(_onPasswordChanged);
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    setState(() {
      final emailRegex = RegExp(r'^[a-zA-Z][a-zA-Z0-9]*@[a-zA-Z]+\.(com)$');
      if (!emailRegex.hasMatch(_emailController.text)) {
        _emailError = "Invalid email";
      } else {
        _emailError = null;
      }
    });
  }

  void _onPasswordChanged() {
    setState(() {
      final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$');
      if (!passwordRegex.hasMatch(_passwordController.text)) {
        _passwordError = "Must be at least 8 characters long and contain at least one capital letter, one special character, and one small letter";
      } else {
        _passwordError = null;
      }
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordHidden = !_isPasswordHidden;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordHidden = !_isConfirmPasswordHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 250.0,
                decoration: BoxDecoration(
                  color: Color(0xFF6FA68F),
                  image: DecorationImage(
                    image: AssetImage('assets/images/logo.png'),
                    fit: BoxFit.none,
                    scale: 2.0,
                  ),
                ),
                child: SizedBox.expand(),
              ),
              SizedBox(height: 40.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 26.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Sign up',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 20.0),
                    // Email TextFormField
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _inputDecoration("Email Address", _emailError),
                      cursorColor: Colors.green,
                    ),
                    SizedBox(height: 20.0),
                    // Password TextFormField
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _isPasswordHidden,
                      decoration: _inputDecoration("Password", _passwordError).copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordHidden ? Icons.visibility_off : Icons.visibility,
                            color: Theme.of(context).hintColor,
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
                      ),
                      cursorColor: Colors.green,
                    ),
                    SizedBox(height: 20.0),
                    // Confirm Password TextFormField
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _isConfirmPasswordHidden,
                      decoration: _inputDecoration("Confirm Password", null).copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordHidden ? Icons.visibility_off : Icons.visibility,
                            color: Theme.of(context).hintColor,
                          ),
                          onPressed: _toggleConfirmPasswordVisibility,
                        ),
                      ),
                      cursorColor: Colors.green,
                    ),
                    SizedBox(height: 10.0),
                    // Sign Up Button
                    _signUpButton(context),
                    SizedBox(height: 20.0),
                    // Already have an account?
                    _loginPrompt(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, String? error) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey),
      fillColor: Colors.white,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: Colors.green,
          width: 2.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: BorderSide(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: Colors.red,
          width: 2.0,
        ),
      ),
      errorText: error,
    );
  }

  Widget _signUpButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          if (_passwordController.text == _confirmPasswordController.text && _passwordError == null && _emailError == null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FormPage(
                  email: _emailController.text,
                  password: _passwordController.text,
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Check the form for errors')),
            );
          }
        },
        child: Text('Sign Up',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: Color(0xFF6FA68F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 12.0),
        ),
      ),
    );
  }

  Widget _loginPrompt(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Already have an account?",
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.0,
              fontWeight: FontWeight.normal,
              fontFamily: 'Inter',
            ),
            textAlign: TextAlign.left,
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Log In",
              style: TextStyle(
                color: Color(0xFF6FA68F), // You can set any color you like
                fontSize: 13.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
