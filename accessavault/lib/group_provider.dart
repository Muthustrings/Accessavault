import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Group {
  String name;
  String description;
  List<String> users; // List of user IDs or names associated with this group
  String? clientId; // Added clientId to link groups to clients

  Group({
    required this.name,
    required this.description,
    this.users = const [],
    this.clientId, // Added to constructor
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'users': users,
        'clientId': clientId, // Added to toJson
      };

  factory Group.fromJson(Map<String, dynamic> json) => Group(
        name: json['name'],
        description: json['description'],
        users: List<String>.from(json['users'] ?? []),
        clientId: json['clientId'], // Added to fromJson
      );
}

class GroupProvider with ChangeNotifier {
  List<Group> _groups = [];
  bool _initialized = false;

  Future<void> initialize() async {
    if (!_initialized) {
      await loadGroups();
      _initialized = true;
    }
  }

  List<Group> get groups => List.unmodifiable(_groups);

  Future<void> addGroup(Group group) async {
    _groups.add(group);
    await _saveGroups();
    notifyListeners();
  }

  Future<void> updateGroup(String name, Group updatedGroup) async {
    final index = _groups.indexWhere((group) => group.name == name);
    if (index != -1) {
      _groups[index] = updatedGroup;
      await _saveGroups();
      notifyListeners();
    }
  }

  Future<void> deleteGroup(String name) async {
    _groups.removeWhere((group) => group.name == name);
    await _saveGroups();
    notifyListeners();
  }

  Future<void> loadGroups() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final groupsJson = prefs.getString('groups');
      if (groupsJson != null) {
        final List<dynamic> decodedList = jsonDecode(groupsJson);
        _groups = decodedList.map((item) => Group.fromJson(item)).toList();
      } else {
        // Initialize with default groups if none exist
        _groups = [
          Group(name: 'Developers', description: 'Software development team', clientId: 'CLIENT001'),
          Group(name: 'Marketing', description: 'Marketing team', clientId: 'CLIENT002'),
          Group(name: 'Sales', description: 'Sales team', clientId: 'CLIENT001'),
          Group(name: 'Support', description: 'Customer support team', clientId: 'CLIENT003'),
        ];
        await _saveGroups(); // Save default groups
      }
      notifyListeners();
    } catch (e) {
      print('Error loading groups: $e');
      _groups = [];
      notifyListeners();
    }
  }

  Future<void> _saveGroups() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final groupsJson = jsonEncode(_groups.map((group) => group.toJson()).toList());
      await prefs.setString('groups', groupsJson);
    } catch (e) {
      print('Error saving groups: $e');
    }
  }
}
