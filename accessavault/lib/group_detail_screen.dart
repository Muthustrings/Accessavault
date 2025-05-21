import 'package:flutter/material.dart';

class GroupDetailScreen extends StatelessWidget {
  final String groupName;

  const GroupDetailScreen({Key? key, required this.groupName})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Group Details: $groupName')),
      body: Center(child: Text('Details for group: $groupName')),
    );
  }
}
