import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Client {
  String id;
  String name;
  String contactPerson;
  String email;
  String website;
  String status;
  String businessId;
  String businessName;
  String businessUserName;
  String businessLogoUrl;
  String aboutBusiness;

  Client({
    required this.id,
    required this.name,
    required this.contactPerson,
    required this.email,
    required this.website,
    required this.status,
    required this.businessId,
    required this.businessName,
    required this.businessUserName,
    required this.businessLogoUrl,
    required this.aboutBusiness,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'contactPerson': contactPerson,
        'email': email,
        'website': website,
        'status': status,
        'businessId': businessId,
        'businessName': businessName,
        'businessUserName': businessUserName,
        'businessLogoUrl': businessLogoUrl,
        'aboutBusiness': aboutBusiness,
      };

  factory Client.fromJson(Map<String, dynamic> json) => Client(
        id: json['id'],
        name: json['name'],
        contactPerson: json['contactPerson'],
        email: json['email'],
        website: json['website'],
        status: json['status'],
        businessId: json['businessId'],
        businessName: json['businessName'],
        businessUserName: json['businessUserName'],
        businessLogoUrl: json['businessLogoUrl'],
        aboutBusiness: json['aboutBusiness'],
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
            name: 'Acme Corp',
            contactPerson: 'John Smith',
            email: 'john.smith@acme.com',
            website: 'acme.com',
            status: 'Active',
            businessId: 'B001',
            businessName: 'Acme Corporation',
            businessUserName: 'acme_admin',
            businessLogoUrl: 'https://placehold.co/100x100/png',
            aboutBusiness: 'A leading company in innovative solutions.',
          ),
          Client(
            id: 'CLIENT002',
            name: 'Globex Inc.',
            contactPerson: 'Susan Johnson',
            email: 's.johnson@globex.com',
            website: 'globex.com',
            status: 'Inactive',
            businessId: 'B002',
            businessName: 'Globex Incorporated',
            businessUserName: 'globex_support',
            businessLogoUrl: 'https://placehold.co/100x100/png',
            aboutBusiness: 'Specializing in global logistics and trade.',
          ),
          Client(
            id: 'CLIENT003',
            name: 'Stark Industries',
            contactPerson: 'Tony Stark',
            email: 't.stark.stark.com',
            website: 'stark.com',
            status: 'Active',
            businessId: 'B003',
            businessName: 'Stark Industries LLC',
            businessUserName: 'iron_man',
            businessLogoUrl: 'https://placehold.co/100x100/png',
            aboutBusiness: 'Pioneering advanced technology and defense.',
          ),
          Client(
            id: 'CLIENT004',
            name: 'Wayne Enterprises',
            contactPerson: 'Bruce Wayne',
            email: 'bruce@wayne.com',
            website: 'wayne.com',
            status: 'Inactive',
            businessId: 'B004',
            businessName: 'Wayne Enterprises Group',
            businessUserName: 'batman',
            businessLogoUrl: 'https://placehold.co/100x100/png',
            aboutBusiness: 'A diversified conglomerate dedicated to Gotham.',
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
