import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;

class InstagramAuthService {
  final String clientId = "YOUR_INSTAGRAM_CLIENT_ID";
  final String redirectUri = "YOUR_REDIRECT_URI";

  void signInWithInstagram(BuildContext context) {
    final authUrl = "https://api.instagram.com/oauth/authorize"
        "?client_id=$clientId&redirect_uri=$redirectUri&scope=user_profile,user_media&response_type=code";

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InstagramLoginWebview(authUrl: authUrl),
      ),
    );
  }

  Future<void> handleAuthCode(String code) async {
    final response = await http.post(
      Uri.parse('http://localhost:5000/auth/instagram'),
      body: {'code': code},
    );
    print('Backend Response: ${response.body}');
  }
}

class InstagramLoginWebview extends StatefulWidget {
  final String authUrl;

  const InstagramLoginWebview({super.key, required this.authUrl});

  @override
  _InstagramLoginWebviewState createState() => _InstagramLoginWebviewState();
}

class _InstagramLoginWebviewState extends State<InstagramLoginWebview> {
  late InAppWebViewController webView;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Instagram Login")),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(widget.authUrl)),
        onWebViewCreated: (controller) {
          webView = controller;
        },
        onLoadStop: (controller, url) async {
          if (url != null && url.toString().startsWith("YOUR_REDIRECT_URI")) {
            final code = Uri.parse(url.toString()).queryParameters['code'];
            if (code != null) {
              // Close the webview after retrieving the code
              Navigator.pop(context);
              await InstagramAuthService().handleAuthCode(code);
            }
          }
        },
      ),
    );
  }
}
