import 'package:flutter/material.dart';
import 'apps_screen.dart';

class AddAppScreen extends StatefulWidget {
  const AddAppScreen({Key? key, this.app}) : super(key: key);

  final App? app;

  @override
  _AddAppScreenState createState() => _AddAppScreenState();
}

class _AddAppScreenState extends State<AddAppScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.app == null ? 'Add Application' : 'Edit Application',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Name
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'App Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // App ID
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'App ID',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Client
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Client',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Client A', child: Text('Client A')),
                  // Add more clients as needed
                ],
                onChanged: (value) {
                  // Handle client selection
                },
              ),
              const SizedBox(height: 20),

              // Upload Image
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(
                      Icons.cloud_upload_outlined,
                      size: 50,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Drag & drop or click to upload',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Description
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),

              // Status
              Row(
                children: [
                  const Text('Status:'),
                  const SizedBox(width: 10),
                  Row(
                    children: [
                      Radio(
                        value: true,
                        groupValue: true,
                        onChanged: (value) {},
                      ),
                      const Text('Active'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: false,
                        groupValue: true,
                        onChanged: (value) {},
                      ),
                      const Text('Inactive'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Redirect URL
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Redirect URL',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Assigned Groups
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Assigned Groups',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Group A', child: Text('Group A')),
                  // Add more groups as needed
                ],
                onChanged: (value) {
                  // Handle group selection
                },
              ),
              const SizedBox(height: 20),

              // Assigned Users
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Assigned Users',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'User A', child: Text('User A')),
                  // Add more users as needed
                ],
                onChanged: (value) {
                  // Handle user selection
                },
              ),
              const SizedBox(height: 30),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 3, 42, 100),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    onPressed: () {
                      // Handle create application
                    },
                    child: const Text(
                      'Create Application',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      textStyle: const TextStyle(fontSize: 18),
                      side: BorderSide(color: Colors.grey.shade400),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
