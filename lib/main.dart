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

/***
 *
 */
class _MyHomePageState extends State<MyHomePage> {
  // Textフィールドからテキストを入力した際のコントローラー
  TextEditingController controller = TextEditingController();

  // 郵便番号から取得した住所を格納
  List<String> items = [];

  // APIのレスポンス中のメッセージを格納
  String errorMessage = '';

  Future<void> loadZipCode(String zipCode) async {
    setState(() {
      errorMessage = 'APIレスポンス待ち';
    });

    // 関数自体はasyncで非同期だが、この部分はhttp.getのレスポンスを待つ = await
    final response = await http.get(
        Uri.parse('https://zipCloud.ibsnet.co.jp/api/search?zipcode=$zipCode'));

    // 以降の処理は、awaitの処理(httpをgetする)まで処理されない
    if (response.statusCode != 200) {
      // 失敗
      setState(() {
        errorMessage = '通信に失敗しました。';
      });
      return;
    }

    // 成功
    final body = json.decode(response.body) as Map<String, dynamic>;
    final results = (body['results'] ?? []) as List<dynamic>;

    if (results.isEmpty) {
      // ステータス200だが、resultsが空
      setState(() {
        errorMessage = 'そのような郵便番号の住所は存在しません';
      });
    } else {
      // ステータス200かつ成功
      setState(() {
        errorMessage = '';
        // results.mapはresultsの要素を一つずつ返す拡張forのようなもの
        // (result)はラムダでmapで返ってくるresultsの要素であるresultを引数に取り、
        // =>以下の処理で引数のreusltを使用して処理をするgit
        items = results
            .map((result) =>
                "${result['address1']}${result['address2']}${result['address3']}")
            .toList(growable: false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            if (value.isNotEmpty) {
              loadZipCode(value);
            }
          },
        ),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          if (errorMessage.isNotEmpty) {
            return ListTile(title: Text(errorMessage));
          } else {
            return ListTile(title: Text(items[index]));
          }
        },
        itemCount: items.length,
      ),
    );
  }
}
