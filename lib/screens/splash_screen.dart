import 'dart:async';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:tometo_hub/screens/category_screen.dart';
import '../utils/components.dart';
import '../utils/snake_message.dart';
import '../utils/api_controller.dart';
import 'login_screen.dart'; // Login Screen import

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final ApiController apiController = ApiController();
  bool _isLoggedIn = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    // Fetch device info for authentication (same as in login)
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    String serialNumber = androidInfo.id;

    try {
      // Check if the user is already logged in via the API
      final result = await apiController.checkLoginStatus(serialNumber);
      if (result) {
        _isLoggedIn = true;
      } else {
        _isLoggedIn = false;
      }
    } catch (e) {
      _isLoggedIn = false;
      showSnakMessage(context, "Error checking login status: ${e.toString()}");
    } finally {
      _navigateToNextScreen();
    }
  }

  void _navigateToNextScreen() {
    Timer(const Duration(seconds: 2), () {
      if (_isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CategoryScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SplashAnimation(),
      ),
    );
  }
}

class SplashAnimation extends StatefulWidget {
  const SplashAnimation({Key? key}) : super(key: key);

  @override
  State<SplashAnimation> createState() => _SplashAnimationState();
}

class _SplashAnimationState extends State<SplashAnimation> {
  bool _isLogoAnimated = false;

  @override
  void initState() {
    super.initState();
    _startLogoAnimation();
  }

  void _startLogoAnimation() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isLogoAnimated = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedAlign(
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
      alignment: _isLogoAnimated ? Alignment.center : Alignment.topCenter,
      child: Image.asset(
        'assets/images/tometo.png', // Replace with your logo path
        height: 250,
        width: 200,
      ),
    );
  }
}
