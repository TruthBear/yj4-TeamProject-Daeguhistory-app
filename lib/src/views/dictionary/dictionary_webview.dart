import 'package:flutter/material.dart';
import 'package:project/src/utils/colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DictionaryWebview extends StatefulWidget {
  final String url;

  const DictionaryWebview({super.key, required this.url});

  @override
  State<DictionaryWebview> createState() => _DictionaryWebviewState();
}

class _DictionaryWebviewState extends State<DictionaryWebview> {


  @override
  Widget build(BuildContext context) {
    final url = widget.url;


    final webUrl = Uri.parse(url);
    WebViewController controller = WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted)..loadRequest(webUrl);

    return Scaffold(
      appBar: AppBar(
        title: Text("대구역사문화대전"),
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
