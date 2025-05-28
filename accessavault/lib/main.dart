import 'package:flutter/material.dart';
import 'package:accessavault/main_layout.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserProvider extends ChangeNotifier {
  List<Map<String, String>> _users = [];

  UserProvider() {
    _loadUsers();
  }

  List<Map<String, String>> get users => List.unmodifiable(_users);

  Future<void> addUser(Map<String, String> user) async {
    _users.add(user);
    await _saveUsers();
    notifyListeners();
  }

  Future<void> removeUser(Map<String, String> user) async {
    _users.remove(user);
    await _saveUsers();
    notifyListeners();
  }

  Future<void> _loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString('users');
    if (usersJson != null) {
      final List<dynamic> decodedList = jsonDecode(usersJson);
      _users = decodedList.cast<Map<String, String>>().toList();
      notifyListeners();
    }
  }

  Future<void> _saveUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = jsonEncode(_users);
    await prefs.setString('users', usersJson);
  }
}

final RouteObserver<PageRoute> routeObserver =
    RouteObserver<PageRoute>(); // Define as global final

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => UserProvider(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AccessaVault',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MainLayout(),
      navigatorObservers: [routeObserver],
    );
  }
}
