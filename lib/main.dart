import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late InAppWebViewController _inAppWebViewController;
  double progress = 0;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool isPop) async {
        if (await _inAppWebViewController.canGoBack()) {
          _inAppWebViewController.goBack();
        } else {
          exit(0);
        }
      },
      child: Scaffold(
        appBar: MediaQuery.of(context).orientation == Orientation.landscape
            ? null
            : AppBar(
                backgroundColor: Colors.white,
                title: Text('Youtube Lite'),
                actions: [
                  IconButton(
                      onPressed: () async {
                        if (await _inAppWebViewController.canGoBack()) {
                          _inAppWebViewController.goBack();
                        }
                      },
                      icon: Icon(Icons.arrow_back)),
                ],
              ),
        body: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(
                  url: Uri.parse(
                      'https://www.youtube.com/watch?v=TAjlLQZs8X4&ab_channel=AbdulFardaus')),
              initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                javaScriptEnabled: true,
                supportZoom: false,
                useShouldOverrideUrlLoading: true,
              )),
              onWebViewCreated: (controller) => _inAppWebViewController,
              onLoadStop: (controller, url) => setState(() {
                progress = 1.0;
              }),
              onProgressChanged: (controller, url) => setState(() {
                this.progress = progress / 100;
              }),
            ),
            LinearProgressIndicator(
              value: progress,
              color: Colors.green,
              backgroundColor: Colors.black12,
            )
          ],
        ),
      ),
    );
  }
}
