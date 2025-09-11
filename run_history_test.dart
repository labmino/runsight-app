import 'package:flutter/material.dart';
import 'lib/presentation/history/history_test_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Run History Test',
      home: HistoryTestPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
