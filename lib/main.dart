import 'package:flutter/material.dart';
// webviewを使用するためのライブラリ
import 'package:webview_flutter/webview_flutter.dart';
// レスポンスのJSONをパースするdartのライブラリ
import 'package:http/http.dart' as http;
// httpリクエストやレスポンスなどhttpクライアントとしての機能を提供するパッケージ
// asを使用して名前空間を与えるオプション(ライブラリ内の特定の関数などに短い名前などでアクセスできる)
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Lesson8'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
    // javascriptを有効にする
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://www.youtube.com/watch?v=zShNd2J5oMI&t=1107s'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: SafeArea(child: WebViewWidget(controller: controller)));
  }
}
