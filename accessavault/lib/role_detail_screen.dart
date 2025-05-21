import 'package:flutter/material.dart';

class RoleDetailScreen extends StatelessWidget {
  final String roleName;

  const RoleDetailScreen({Key? key, required this.roleName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Role Details')),
      body: Center(child: Text('Details for Role: $roleName')),
    );
  }
}
