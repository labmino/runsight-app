import 'package:flutter/material.dart';
import 'presentation/community/community_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Community Test',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CommunityPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
