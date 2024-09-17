import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tometo_hub/screens/login_screen.dart';
import 'package:tometo_hub/utils/api_controller.dart';
import '../models/category.dart';
import '../models/remaining_date.dart';
import '../services/api_service.dart';
import '../utils/remaining_date.dart';
import 'video_screen.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final ApiService apiService = ApiService();
  late Future<List<Category>> categories;
  late Future<GetDate?> futureDate;

  @override
  void initState() {
    super.initState();
    categories = apiService.fetchCategories();
    futureDate = ApiService().fetchDate();
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    if (mounted) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text('Categories'),
        backgroundColor: Colors.transparent,
        actions: [
          RemainingDate(futureDate: futureDate),
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout, color: Colors.red),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            categories = apiService.fetchCategories();
          });
        },
        child: FutureBuilder<List<Category>>(
          future: categories,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No categories found.'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Category category = snapshot.data![index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 10.0, left: 10.0,top: 10.0),
                    child: Card(
                      elevation: 2.0,
                      color: Colors.grey,
                      child: ListTile(
                        leading: const Icon(Icons.image,
                            color: Colors.yellow, size: 40),
                        trailing: const Icon(Icons.chevron_right,size: 60,color: Colors.white,),
                        title: Text(
                          category.name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  VideoScreen(category: category),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
