import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiController {
  // API URL
  final String apiUrl = 'https://tomato.yozilive.xyz/api/login';

  // Login Function
  Future<Map<String, dynamic>> login(String email, String password, String macAddress) async {
    // Data to send in POST request
    final Map<String, dynamic> data = {
      'email': email,
      'password': password,
      'mac_address': macAddress
    };

    // Sending the POST request
    final response = await http.post(
      Uri.parse(apiUrl),
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      // Save token locally using shared_preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', responseData['token']);
      await prefs.setBool('isLoggedIn', true); // Save login status
      return responseData;
    } else if (response.statusCode == 401) {
      throw Exception('Invalid credentials');
    } else if (response.statusCode == 404) {
      throw Exception('User does not exist');
    } else if (response.statusCode == 403) {
      throw Exception('You are already logged in from another device');
    } else {
      throw Exception(response.statusCode.toString());
    }
  }

  // To fetch stored token
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // To log out
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.setBool('isLoggedIn', false); // Reset login status
  }

  // Check login status
  Future<bool> checkLoginStatus(String serialNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (token != null && isLoggedIn) {
      // You can add an additional API call to verify the token if needed.
      return true;
    } else {
      return false;
    }
  }
}
