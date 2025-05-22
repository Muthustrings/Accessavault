import 'package:flutter/material.dart';
import 'package:accessavault/general_settings_screen.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      body: GeneralSettingsScreen(),
    );
  }
}
