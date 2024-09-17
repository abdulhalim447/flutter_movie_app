import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';  // To handle external intents

class WebViewScreen extends StatefulWidget {
  final String url;
  final String title;

  const WebViewScreen({Key? key, required this.url, required this.title}) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(widget.url)),
        onLoadStart: (controller, url) async {
          // Check if the URL starts with intent://
          if (url != null && url.toString().startsWith('intent://')) {
            try {
              String fallbackUrl = url.toString().replaceFirst('intent://', 'https://');

              // Try to open the fallback URL in the browser
              if (await canLaunch(fallbackUrl)) {
                await launch(fallbackUrl);
              } else {
                // If no fallback is available, show an error message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Could not open the intent URL.')),
                );
              }
            } catch (e) {
              print('Error handling intent URL: $e');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to handle intent URL.')),
              );
            }
            return; // Stop WebView from trying to load the intent URL
          }
        },
        onLoadError: (controller, url, code, message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error loading page: $message')),
          );
        },
      ),
    );
  }
}
