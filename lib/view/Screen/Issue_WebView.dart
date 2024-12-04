import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class IssueWebView extends StatefulWidget {
  final String url;

  const IssueWebView({required this.url, Key? key}) : super(key: key);

  @override
  _IssueWebViewState createState() => _IssueWebViewState();
}

class _IssueWebViewState extends State<IssueWebView> {
  late InAppWebViewController _webViewController;
  double progress = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Issue Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _webViewController.reload();
            },
          ),
        ],
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(widget.url)),
        onWebViewCreated: (InAppWebViewController controller) {
          _webViewController = controller;
        },
        onProgressChanged: (InAppWebViewController controller, int progress) {
          setState(() {
            this.progress = progress / 100;
          });
        },
        onLoadError: (controller, url, code, message) {
          print("Failed to load: $url with error code $code: $message");
        },
        onLoadHttpError: (controller, url, statusCode, description) {
          print("HTTP Error: $url with status code $statusCode: $description");
        },
      ),
      floatingActionButton: progress < 1.0
          ? CircularProgressIndicator(value: progress)
          : SizedBox.shrink(),
    );
  }
}