import 'package:flutter/material.dart';

class MultipleGroupsScreen extends StatelessWidget {
  const MultipleGroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Multiple Groups'),
        backgroundColor: Color(0xFF0B2447),
      ),
      body: Center(
        child: Text(
          'This is the Multiple Groups Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
