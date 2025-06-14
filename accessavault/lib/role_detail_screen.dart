import 'package:flutter/material.dart';

class RoleDetailScreen extends StatelessWidget {
  final String roleName;

  const RoleDetailScreen({super.key, required this.roleName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Role Details')),
      body: Center(child: Text('Details for Role: $roleName')),
    );
  }
}
