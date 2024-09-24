import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewExample extends StatefulWidget {
  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  InAppWebViewController? webViewController;

  // List of ad hostnames to block
  final List<String> adHosts = [
    'doubleclick.net',
    'googleadservices.com',
    'googlesyndication.com',
    'google-analytics.com',
    'ads.yahoo.com',
    'adserver.yahoo.com',
    'ads.microsoft.com',
    // Add more ad domains as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ad-Blocking WebView'),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse('https://prmovies.my')),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        // Intercept requests and block ads using shouldOverrideUrlLoading
        shouldOverrideUrlLoading: (controller, navigationAction) async {
          Uri? url = navigationAction.request.url;
          if (url != null) {
            for (String host in adHosts) {
              if (url.host.contains(host)) {
                // Block the request by canceling the navigation
                return NavigationActionPolicy.CANCEL;
              }
            }
          }
          // Allow the request to proceed
          return NavigationActionPolicy.ALLOW;
        },
      ),
    );
  }
}
