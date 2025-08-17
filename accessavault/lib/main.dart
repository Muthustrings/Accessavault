import 'package:flutter/material.dart';
import 'package:accessavault/main_layout.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:accessavault/client_provider.dart';
import 'package:accessavault/role_provider.dart';
import 'package:accessavault/app_provider.dart';
import 'package:accessavault/group_provider.dart';
import 'package:accessavault/user_provider.dart'; // Import UserProvider


final RouteObserver<PageRoute> routeObserver =
    RouteObserver<PageRoute>(); // Define as global final

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final userProvider = UserProvider();
  await userProvider.initialize();

  final clientProvider = ClientProvider();
  await clientProvider.initialize();

  final roleProvider = RoleProvider();
  await roleProvider.initialize();

  final appProvider = AppProvider();
  await appProvider.initialize();

  final groupProvider = GroupProvider();
  await groupProvider.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => userProvider),
        ChangeNotifierProvider(create: (_) => clientProvider),
        ChangeNotifierProvider(create: (_) => roleProvider),
        ChangeNotifierProvider(create: (_) => appProvider),
        ChangeNotifierProvider(create: (_) => groupProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => const MainLayout())); // Added const
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('asset/image/logo.png', width: 160, height: 160),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Accessavault',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SplashScreen(),
      navigatorObservers: [routeObserver],
    );
  }
}
