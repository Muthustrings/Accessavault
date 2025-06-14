import 'package:flutter/material.dart';
import 'package:accessavault/main_layout.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserProvider extends ChangeNotifier {
  List<Map<String, String>> _users = [];
  bool _initialized = false;

  Future<void> initialize() async {
    if (!_initialized) {
      await loadUsers();
      _initialized = true;
    }
  }

  List<Map<String, String>> get users => List.unmodifiable(_users);

  Future<void> addUser(Map<String, String> user) async {
    _users.add(Map<String, String>.from(user));
    await _saveUsers();
    print('User added: $user'); // Debugging log
    print('Current users after addition: $_users'); // Debugging log
    notifyListeners();
  }

  Future<void> removeUser(Map<String, String> user) async {
    _users.remove(user);
    await _saveUsers();
    notifyListeners();
  }

  Future<void> loadUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString('users');
      print(
        'Raw users JSON from SharedPreferences: $usersJson',
      ); // Debugging log
      if (usersJson != null) {
        final List<dynamic> decodedList = jsonDecode(usersJson);
        _users =
            decodedList.map<Map<String, String>>((item) {
              return Map<String, String>.from(item);
            }).toList();
        print('Users loaded into _users: $_users'); // Debugging log
      } else {
        print('No users found in SharedPreferences'); // Debugging log
        _users = [];
      }
      notifyListeners();
    } catch (e) {
      print('Error loading users: $e');
      _users = [];
      notifyListeners();
    }
  }

  Future<void> _saveUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = jsonEncode(_users);
      await prefs.setString('users', usersJson);
      print('Users saved to SharedPreferences: $usersJson'); // Debugging log
    } catch (e) {
      print('Error saving users: $e');
    }
  }
}

final RouteObserver<PageRoute> routeObserver =
    RouteObserver<PageRoute>(); // Define as global final

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final userProvider = UserProvider();
  await userProvider.initialize();

  runApp(
    ChangeNotifierProvider(create: (_) => userProvider, child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
