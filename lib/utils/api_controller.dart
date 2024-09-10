import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiController {
  // API URL
  final String apiUrl = 'https://tometohub.com/api/login';

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

      return responseData;
    } else {
      throw Exception('Failed to log in');
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
  }
}
