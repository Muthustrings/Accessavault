import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class App {
  final String name;
  final String id;
  final String? clientId; // Changed from 'client' to 'clientId' and made nullable
  final String type;
  final String status;
  final String image;
  final String description;
  final String redirectUrl;
  final List<String> assignedGroups;
  final List<String> assignedUsers;
  final IconData icon;
  final Color iconColor;

  App({
    required this.name,
    required this.id,
    this.clientId, // Changed from 'client' to 'clientId'
    required this.type,
    required this.status,
    required this.image,
    required this.description,
    required this.redirectUrl,
    required this.assignedGroups,
    required this.assignedUsers,
    required this.icon,
    required this.iconColor,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'clientId': clientId, // Changed from 'client' to 'clientId'
        'type': type,
        'status': status,
        'image': image,
        'description': description,
        'redirectUrl': redirectUrl,
        'assignedGroups': assignedGroups,
        'assignedUsers': assignedUsers,
        'iconCodePoint': icon.codePoint,
        'iconFontFamily': icon.fontFamily,
        'iconFontPackage': icon.fontPackage,
        'iconColorValue': iconColor.value,
      };

  factory App.fromJson(Map<String, dynamic> json) => App(
        name: json['name'],
        id: json['id'],
        clientId: json['clientId'], // Changed from 'client' to 'clientId'
        type: json['type'],
        status: json['status'],
        image: json['image'] ?? '',
        description: json['description'] ?? '',
        redirectUrl: json['redirectUrl'] ?? '',
        assignedGroups: List<String>.from(json['assignedGroups'] ?? []),
        assignedUsers: List<String>.from(json['assignedUsers'] ?? []),
        icon: IconData(
          json['iconCodePoint'],
          fontFamily: json['iconFontFamily'],
          fontPackage: json['iconFontPackage'],
        ),
        iconColor: Color(json['iconColorValue']),
      );
}

class AppProvider with ChangeNotifier {
  List<App> _apps = [];
  bool _initialized = false;

  Future<void> initialize() async {
    if (!_initialized) {
      await loadApps();
      _initialized = true;
    }
  }

  List<App> get apps => List.unmodifiable(_apps);

  Future<void> addApp(App app) async {
    _apps.add(app);
    await _saveApps();
    notifyListeners();
  }

  Future<void> updateApp(String id, App updatedApp) async {
    final index = _apps.indexWhere((app) => app.id == id);
    if (index != -1) {
      _apps[index] = updatedApp;
      await _saveApps();
      notifyListeners();
    }
  }

  Future<void> deleteApp(String id) async {
    _apps.removeWhere((app) => app.id == id);
    await _saveApps();
    notifyListeners();
  }

  Future<void> loadApps() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final appsJson = prefs.getString('apps');
      if (appsJson != null) {
        final List<dynamic> decodedList = jsonDecode(appsJson);
        _apps = decodedList.map((item) => App.fromJson(item)).toList();
      } else {
        // Initialize with default apps if none exist
        _apps = [
          App(
            name: 'Project Management',
            id: 'APP1001',
            clientId: 'CLIENT001', // Changed to clientId
            type: 'Web',
            status: 'Active',
            image: '',
            description: 'A comprehensive project management tool.',
            redirectUrl: 'https://project.acme.com',
            assignedGroups: ['Developers'],
            assignedUsers: [],
            icon: Icons.bar_chart,
            iconColor: Colors.green,
          ),
          App(
            name: 'Mobile CRM',
            id: 'APP1002',
            clientId: 'CLIENT002', // Changed to clientId
            type: 'Mobile',
            status: 'Active',
            image: '',
            description: 'CRM solution for mobile sales teams.',
            redirectUrl: 'https://crm.globex.com',
            assignedGroups: ['Marketing'],
            assignedUsers: [],
            icon: Icons.phone_android,
            iconColor: Colors.green,
          ),
          App(
            name: 'Data Analytics',
            id: 'APP1003',
            clientId: 'CLIENT003', // Changed to clientId
            type: 'Web',
            status: 'Active',
            image: '',
            description: 'Advanced data analytics platform.',
            redirectUrl: 'https://analytics.stark.com',
            assignedGroups: ['Sales'],
            assignedUsers: [],
            icon: Icons.analytics,
            iconColor: Colors.blue,
          ),
          App(
            name: 'Email Service',
            id: 'APP1004',
            clientId: 'CLIENT004', // Changed to clientId
            type: 'Web',
            status: 'Inactive',
            image: '',
            description: 'Secure email communication service.',
            redirectUrl: 'https://email.wayne.com',
            assignedGroups: ['Support'],
            assignedUsers: [],
            icon: Icons.email,
            iconColor: Colors.deepOrange,
          ),
        ];
        await _saveApps(); // Save default apps
      }
      notifyListeners();
    } catch (e) {
      print('Error loading apps: $e');
      _apps = [];
      notifyListeners();
    }
  }

  Future<void> _saveApps() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final appsJson = jsonEncode(_apps.map((app) => app.toJson()).toList());
      await prefs.setString('apps', appsJson);
    } catch (e) {
      print('Error saving apps: $e');
    }
  }
}
