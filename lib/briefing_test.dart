import 'package:flutter/material.dart';
import 'presentation/run/run_briefing_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Run Briefing Test',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: RunBriefingPage(
        selectedMode: 'Independent Mode',
        gpsEnabled: true,
        voiceEnabled: true,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
