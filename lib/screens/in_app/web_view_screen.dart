import 'package:flutter/material.dart';
import 'package:fyndr_ng/widgets/custom_appbar.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InAppWebViewScreen extends StatefulWidget {
  final String url;
  final String title;

  const InAppWebViewScreen({
    Key? key,
    required this.url,
    required this.title,
  }) : super(key: key);

  @override
  State<InAppWebViewScreen> createState() => _InAppWebViewScreenState();
}

class _InAppWebViewScreenState extends State<InAppWebViewScreen> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: widget.title,
        leadingIcon: BackButton(onPressed: Get.back),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}