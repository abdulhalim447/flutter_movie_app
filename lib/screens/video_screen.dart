import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/video.dart';
import '../services/api_service.dart';
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

  @override
  void initState() {
    super.initState();
    videos = apiService.fetchVideosByCategory(widget.category.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category.name)),
      body: FutureBuilder<List<Video>>(
        future: videos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No videos found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Video video = snapshot.data![index];
                return ListTile(
                  leading: Image.network(video.thumbnail),
                  title: Text(video.name),
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
                );
              },
            );
          }
        },
      ),
    );
  }
}