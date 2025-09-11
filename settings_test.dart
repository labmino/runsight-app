import 'package:flutter/material.dart';
import 'lib/presentation/settings/settings_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Settings Test',
      home: SettingsPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
