import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPreferencesTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('SharedPreferences Test')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  final testData = jsonEncode({'key': 'value'});
                  await prefs.setString('test', testData);
                  print('Data saved: $testData');
                },
                child: Text('Save Data'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  final testData = prefs.getString('test');
                  print('Data retrieved: $testData');
                },
                child: Text('Retrieve Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
