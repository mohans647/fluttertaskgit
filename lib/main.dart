import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'view/Screen/IssueTrackerPage.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'JosefinSans',
        useMaterial3: true,
      ),
      home: IssueSearchScreen(),
    );
  }
}

class IssueSearchScreen extends StatefulWidget {
  @override
  _IssueSearchScreenState createState() => _IssueSearchScreenState();
}

class _IssueSearchScreenState extends State<IssueSearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          title: Text(
            'GitHub Issue Tracker',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: IssueTrackerPage(),
        ));
  }
}
