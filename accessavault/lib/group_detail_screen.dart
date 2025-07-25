import 'package:flutter/material.dart';

class GroupDetailScreen extends StatelessWidget {
  final String groupName;

  final String imageUrl;

  const GroupDetailScreen({
    super.key,
    required this.groupName,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Group Details: $groupName')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Details for group: $groupName'),
            SizedBox(height: 20),
            Image.network(imageUrl, width: 150, height: 150),
          ],
        ),
      ),
    );
  }
}
