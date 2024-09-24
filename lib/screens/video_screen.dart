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
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Movies',
          style: TextStyle(fontSize: 18), // App bar এর ফন্ট সাইজ কমানো
        ),
        backgroundColor: Colors.transparent,
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
                int crossAxisCount =
                (constraints.maxWidth / 125).floor(); // Adjust 150 as the desired width per item

                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount, // Use calculated value
                      crossAxisSpacing: 8.0, // Space between grid items horizontally
                      mainAxisSpacing: 8.0, // Space between grid items vertically
                      childAspectRatio: 0.75, // Adjust this to control the size of the grid items
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Video video = snapshot.data![index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WebViewExample (
                                 // initialUrl: video.url,
                               /* url: video.url,
                                title: video.name,*/
                              ),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 5.0,
                          // Elevation দিয়ে কার্ডটি উঁচু করা হয়েছে
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12), // কর্নার রেডিয়াস ১২ পিক্সেল দেওয়া হয়েছে
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12), // ফটোতেও একই রেডিয়াস দেওয়া হয়েছে
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Image.network(
                                    video.thumbnail,
                                    fit: BoxFit.cover,
                                    // ফটোটা পুরো কার্ডের মধ্যে জুড়ে বসানোর জন্য
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    color: Colors.black.withOpacity(0.5), // ছবির নিচে কালো ব্যাকগ্রাউন্ড
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      video.name,
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
