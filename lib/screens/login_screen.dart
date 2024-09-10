import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:tometo_hub/screens/category_screen.dart';
import 'package:network_info_plus/network_info_plus.dart';
import '../utils/components.dart';
import '../utils/snake_message.dart';
import '../utils/api_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final ApiController apiController = ApiController();
  bool isLoading = false;
  // Login function to call the API


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
        children: [
          ScreenBackground(context),
          Container(
            padding: EdgeInsets.all(30),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Get started with ",
                    style: Head1Text(colorWhite),
                  ),
                  const SizedBox(
                    height: 1,
                  ),
                  Text(
                    "Tometo Hub",
                    style: Head6Text(colorLightGray),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                    decoration: AppInputDecoration("Email Address"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: AppInputDecoration("Password"),
                    obscureText: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20,),
                  Container(
                    child: Visibility(
                      visible: !isLoading,
                      replacement: const Center(
                        child: CircularProgressIndicator(),
                      ),
                      child: ElevatedButton(
                        style: AppButtonStyle(),
                        child: SuccessButtonChild("Login"),
                        onPressed: (){
                          if(formKey.currentState!.validate()){
                            _loginAUTH();
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
  void _loginAUTH() async {
    isLoading = true;
    if (mounted) {
      setState(() {});
    }
    final info = NetworkInfo();
    final macAddress = await info.getWifiBSSID();
    try {
      final result = await apiController.login(
        _emailController.text,
        _passwordController.text,
        macAddress!,
      );
      // Navigate to another page if login is successful
      if(mounted) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => CategoryScreen()), (
                Route<dynamic> route) => false);
        showSnakMessage(context, "Login Successful");
      } } catch (e) {
      if(mounted) {
        showSnakMessage(context,e.toString() ?? "Login Failed");
        isLoading = false;
        setState(() {});
      }
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text('Login failed: ${e.toString()}'),
      // ));
    }
  }

  @override
  dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
