import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Error_Widget extends StatelessWidget {
  final String message;

  const Error_Widget({required this.message, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: TextStyle(color: Colors.red, fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );
  }
}
