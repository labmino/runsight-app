import 'package:flutter/material.dart';
import 'presentation/run/active_run_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Active Run Test',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ActiveRunPage(
        selectedMode: 'Independent Mode',
        gpsEnabled: true,
        voiceEnabled: true,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
