import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../utils/navigation_controls.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({Key? key,required this.url, required this.title}) : super(key: key);
  final String url;
  final String title;
  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  WebViewController? _controller;  // Changed from late to nullable
  late Uri _url;
  @override
  void initState() {
    super.initState();
    _url = Uri.parse(widget.url.toString());
    _initializeController();
  }

  void _initializeController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint("Loading: $progress%");
          },
          onPageStarted: (String url) {
            debugPrint("Page started loading: $url");
          },
          onPageFinished: (String url) {
            debugPrint("Page finished loading: $url");
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint("Web resource error: ${error.description}");
          },
          onNavigationRequest: (NavigationRequest request) {
            final adPattern = RegExp(r"(adserver\.com|doubleclick\.net|ads\.com|popupads\.com|anotherads\.com)", caseSensitive: false);

            if (adPattern.hasMatch(request.url)) {
              debugPrint("Blocked ad site: ${request.url}");
              return NavigationDecision.prevent;
            }

            if (!request.url.startsWith(widget.url.toString())) {
              debugPrint("Blocked external redirect: ${request.url}");
              return NavigationDecision.prevent;
            }

            if (request.url.startsWith('http://') || request.url.startsWith('https://')) {
              return NavigationDecision.navigate;
            } else {
              _launchUrl(request.url);
              return NavigationDecision.prevent;
            }
          },
        ),
      )
      ..loadRequest(_url);
  }
  @override
  @override
  void didUpdateWidget(WebViewScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.url != oldWidget.url) {
      _url = Uri.parse(widget.url);
      if (_controller != null) {
        _controller!.loadRequest(_url); // Ensure the controller is initialized
      }
    }
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Webview Example'),
        actions: [
          if (_controller != null) NavigationControls(controller: _controller!), // Check if controller is initialized
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        child: _controller != null
            ? WebViewWidget(
          controller: _controller!,
        )
            : const Center(child: CircularProgressIndicator()), // Show loader until WebView is ready
      ),
    );
  }
}
