import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewScreen extends StatefulWidget {
  final String url; // URL পাস হবে অন্য এক্টিভিটি থেকে
  //final String Title; // URL পাস হবে অন্য এক্টিভিটি থেকে

  const WebViewScreen({Key? key, required this.url}) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  final GlobalKey webViewKey = GlobalKey();
  final List<ContentBlocker> contentBlockers = [];
  var contentBlockerEnabled = true;
  InAppWebViewController? webViewController;

  // Ad URL filters for blocking ads
  final adUrlFilters = [
    ".*.doubleclick.net/.*",
    ".*.ads.pubmatic.com/.*",
    ".*.googlesyndication.com/.*",
    ".*.google-analytics.com/.*",
    ".*.adservice.google.*/.*",
    ".*.adbrite.com/.*",
    ".*.exponential.com/.*",
    ".*.quantserve.com/.*",
    ".*.scorecardresearch.com/.*",
    ".*.zedo.com/.*",
    ".*.adsafeprotected.com/.*",
    ".*.teads.tv/.*",
    ".*.outbrain.com/.*"
  ];

  @override
  void initState() {
    super.initState();

    // Content Blockers for ad URL filtering
    for (final adUrlFilter in adUrlFilters) {
      contentBlockers.add(ContentBlocker(
          trigger: ContentBlockerTrigger(urlFilter: adUrlFilter),
          action: ContentBlockerAction(type: ContentBlockerActionType.BLOCK)));
    }

    // Block HTML elements related to ads
    contentBlockers.add(ContentBlocker(
        trigger: ContentBlockerTrigger(urlFilter: ".*"),
        action: ContentBlockerAction(
            type: ContentBlockerActionType.CSS_DISPLAY_NONE,
            selector: ".banner, .banners, .ads, .ad, .advert")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Title"),
        actions: [
          TextButton(
            onPressed: () async {
              contentBlockerEnabled = !contentBlockerEnabled;
              if (contentBlockerEnabled) {
                await webViewController?.setSettings(
                    settings: InAppWebViewSettings(contentBlockers: contentBlockers));
              } else {
                await webViewController?.setSettings(
                    settings: InAppWebViewSettings(contentBlockers: []));
              }
              webViewController?.reload();
              setState(() {});
            },
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            child: Text(contentBlockerEnabled ? 'Disable' : 'Enable'),
          ),
        ],
      ),
      body: SafeArea(
        child: InAppWebView(
          key: webViewKey,
          initialUrlRequest: URLRequest(url: WebUri(widget.url)), // URL from other activity
          initialSettings: InAppWebViewSettings(contentBlockers: contentBlockers),
          onWebViewCreated: (controller) {
            webViewController = controller;
          },
        ),
      ),
    );
  }
}
