import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Client {
  String id;
  String contactPerson;
  String email;
  String website;
  String status;

  Client({
    required this.id,
    required this.contactPerson,
    required this.email,
    required this.website,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'contactPerson': contactPerson,
        'email': email,
        'website': website,
        'status': status,
      };

  factory Client.fromJson(Map<String, dynamic> json) => Client(
        id: json['id'],
        contactPerson: json['contactPerson'],
        email: json['email'],
        website: json['website'],
        status: json['status'],
      );
}

class ClientProvider with ChangeNotifier {
  List<Client> _clients = [];
  bool _initialized = false;

  Future<void> initialize() async {
    if (!_initialized) {
      await loadClients();
      _initialized = true;
    }
  }

  List<Client> get clients => List.unmodifiable(_clients);

  Future<void> addClient(Client client) async {
    _clients.add(client);
    await _saveClients();
    notifyListeners();
  }

  Future<void> updateClient(String id, Client updatedClient) async {
    final index = _clients.indexWhere((client) => client.id == id);
    if (index != -1) {
      _clients[index] = updatedClient;
      await _saveClients();
      notifyListeners();
    }
  }

  Future<void> deleteClient(String id) async {
    _clients.removeWhere((client) => client.id == id);
    await _saveClients();
    notifyListeners();
  }

  Future<void> loadClients() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final clientsJson = prefs.getString('clients');
      if (clientsJson != null) {
        final List<dynamic> decodedList = jsonDecode(clientsJson);
        _clients = decodedList.map((item) => Client.fromJson(item)).toList();
      } else {
        // Initialize with default clients if none exist
        _clients = [
          Client(
            id: 'CLIENT001',
            contactPerson: 'John Smith',
            email: 'john.smith@acme.com',
            website: 'acme.com',
            status: 'Active',
          ),
          Client(
            id: 'CLIENT002',
            contactPerson: 'Susan Johnson',
            email: 's.johnson@globex.com',
            website: 'globex.com',
            status: 'Inactive',
          ),
          Client(
            id: 'CLIENT003',
            contactPerson: 'Tony Stark',
            email: 't.stark.stark.com',
            website: 'stark.com',
            status: 'Active',
          ),
          Client(
            id: 'CLIENT004',
            contactPerson: 'Bruce Wayne',
            email: 'bruce@wayne.com',
            website: 'wayne.com',
            status: 'Inactive',
          ),
        ];
        await _saveClients(); // Save default clients
      }
      notifyListeners();
    } catch (e) {
      print('Error loading clients: $e');
      _clients = [];
      notifyListeners();
    }
  }

  Future<void> _saveClients() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final clientsJson = jsonEncode(_clients.map((client) => client.toJson()).toList());
      await prefs.setString('clients', clientsJson);
    } catch (e) {
      print('Error saving clients: $e');
    }
  }
}
