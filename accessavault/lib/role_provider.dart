import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Role {
  String name;
  String description;
  List<String> users; // List of user IDs or names associated with this role

  Role({
    required this.name,
    required this.description,
    this.users = const [],
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'users': users,
      };

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        name: json['name'],
        description: json['description'],
        users: List<String>.from(json['users'] ?? []),
      );
}

class RoleProvider with ChangeNotifier {
  List<Role> _roles = [];
  bool _initialized = false;

  Future<void> initialize() async {
    if (!_initialized) {
      await loadRoles();
      _initialized = true;
    }
  }

  List<Role> get roles => List.unmodifiable(_roles);

  Future<void> addRole(Role role) async {
    _roles.add(role);
    await _saveRoles();
    notifyListeners();
  }

  Future<void> updateRole(String name, Role updatedRole) async {
    final index = _roles.indexWhere((role) => role.name == name);
    if (index != -1) {
      _roles[index] = updatedRole;
      await _saveRoles();
      notifyListeners();
    }
  }

  Future<void> deleteRole(String name) async {
    _roles.removeWhere((role) => role.name == name);
    await _saveRoles();
    notifyListeners();
  }

  Future<void> loadRoles() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rolesJson = prefs.getString('roles');
      if (rolesJson != null) {
        final List<dynamic> decodedList = jsonDecode(rolesJson);
        _roles = decodedList.map((item) => Role.fromJson(item)).toList();
      } else {
        // Initialize with default roles if none exist
        _roles = [
          Role(name: 'Admin', description: 'Full access to all features'),
          Role(name: 'Editor', description: 'Can create and edit content'),
          Role(name: 'Viewer', description: 'Can view content'),
        ];
        await _saveRoles(); // Save default roles
      }
      notifyListeners();
    } catch (e) {
      print('Error loading roles: $e');
      _roles = [];
      notifyListeners();
    }
  }

  Future<void> _saveRoles() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rolesJson = jsonEncode(_roles.map((role) => role.toJson()).toList());
      await prefs.setString('roles', rolesJson);
    } catch (e) {
      print('Error saving roles: $e');
    }
  }
}
