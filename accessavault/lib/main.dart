import 'package:flutter/material.dart';
import 'package:accessavault/login_screen.dart';
import 'package:accessavault/main_layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AccessaVault',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MainLayout(),
    );
  }
}
