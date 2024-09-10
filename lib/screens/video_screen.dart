import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/category.dart';
import '../models/remaining_date.dart';
import '../models/video.dart';
import '../services/api_service.dart';
import '../utils/remaining_date.dart';
import 'login_screen.dart';
import 'webview_screen.dart';

class VideoScreen extends StatefulWidget {
  final Category category;

  VideoScreen({required this.category});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final ApiService apiService = ApiService();
  late Future<List<Video>> videos;
  late Future<GetDate?> futureDate;
  @override
  void initState() {
    super.initState();
    videos = apiService.fetchVideosByCategory(widget.category.id.toString());
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
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text('Videos List'),
        backgroundColor: Colors.blueAccent,
        actions: [
          RemainingDate(futureDate: futureDate),
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout, color: Colors.red),
          ),
        ],
      ),
      body: FutureBuilder<List<Video>>(
        future: videos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No videos found.'));
          } else {
            return LayoutBuilder(
              builder: (context, constraints) {
                // Calculate the number of items in a row based on the screen width
                int crossAxisCount = (constraints.maxWidth / 150).floor(); // Adjust 150 as the desired width per item

                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount, // Use calculated value
                      crossAxisSpacing: 8.0,          // Space between grid items horizontally
                      mainAxisSpacing: 8.0,           // Space between grid items vertically
                      childAspectRatio: 0.75,         // Adjust this to control the size of the grid items
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Video video = snapshot.data![index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WebViewScreen(
                                url: video.url,
                                title: video.name,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.network(
                              video.thumbnail,
                              fit: BoxFit.cover,      // Ensure the image fits within the grid item
                              height: constraints.maxWidth / crossAxisCount * 0.75, // Adjust the image height for responsiveness
                            ),
                            const SizedBox(height: 8.0),
                            Center(
                              child: Text(
                                video.name,
                                style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}