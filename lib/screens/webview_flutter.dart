import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyWebViewScreen extends StatefulWidget {
  @override
  _MyWebViewScreenState createState() => _MyWebViewScreenState();
}

class _MyWebViewScreenState extends State<MyWebViewScreen> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    // Initialize the controller
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Show progress bar or similar UI updates
            print('Loading progress: $progress%');
          },
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('intent://')) {
              // Handle intent:// URLs manually here
              print('Blocked intent URL: ${request.url}');
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://flutter.dev'));  // Load your desired URL
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter WebView Example'),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}

