import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class App {
  final String name;
  final String id;
  final String linkedClient;
  final String type;
  final String status;
  final IconData icon;
  final Color iconColor;

  App({
    required this.name,
    required this.id,
    required this.linkedClient,
    required this.type,
    required this.status,
    required this.icon,
    required this.iconColor,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'linkedClient': linkedClient,
        'type': type,
        'status': status,
        'iconCodePoint': icon.codePoint,
        'iconFontFamily': icon.fontFamily,
        'iconFontPackage': icon.fontPackage,
        'iconColorValue': iconColor.value,
      };

  factory App.fromJson(Map<String, dynamic> json) => App(
        name: json['name'],
        id: json['id'],
        linkedClient: json['linkedClient'],
        type: json['type'],
        status: json['status'],
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
            linkedClient: 'Client A',
            type: 'Web',
            status: 'Active',
            icon: Icons.bar_chart,
            iconColor: Colors.green,
          ),
          App(
            name: 'Mobile CRM',
            id: 'APP1002',
            linkedClient: 'Client B',
            type: 'Mobile',
            status: 'Active',
            icon: Icons.phone_android,
            iconColor: Colors.green,
          ),
          App(
            name: 'Data Analytics',
            id: 'APP1003',
            linkedClient: 'Client C',
            type: 'Web',
            status: 'Active',
            icon: Icons.analytics,
            iconColor: Colors.blue,
          ),
          App(
            name: 'Email Service',
            id: 'APP1004',
            linkedClient: 'Client D',
            type: 'Web',
            status: 'Inactive',
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
