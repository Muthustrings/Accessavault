import 'package:flutter/material.dart';
import 'package:accessavault/settings_screen.dart';
import 'package:accessavault/notifications_settings_screen.dart';
import 'package:accessavault/users_screen.dart';
import 'package:accessavault/groups_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0; // 0 for Dashboard, 1 for Users
  final List<Widget> _screens = [];
  // Placeholder data for roles
  final List<Map<String, String>> _roles = [
    {'name': 'Admin', 'description': 'Full access to all features'},
    {'name': 'Editor', 'description': 'Can create and edit content'},
    {'name': 'Viewer', 'description': 'Can view content'},
  ];
  @override
  void initState() {
    super.initState();
    _screens.addAll([
      DashboardScreenContent(),
      UsersScreen(),
      RolesScreenContent(onRoleAdded: _addRole, roles: _roles),
      GroupsScreenContent(),
      SettingsScreenContent(),
    ]);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _addRole(Map<String, String> newRole, List<String>? selectedUsers) {
    if (mounted) {
      setState(() {
        _roles.add(newRole);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 260,
            color: const Color(0xFF0B2447),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 32),
                Row(
                  children: [
                    SizedBox(width: 24),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 22,
                      child: Icon(
                        Icons.shield,
                        color: Color(0xFF0B2447),
                        size: 28,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'AccessaVault',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                _SidebarItem(
                  icon: Icons.dashboard,
                  label: 'Dashboard',
                  selected: _selectedIndex == 0,
                  onTap: () => _onItemTapped(0),
                ),
                _SidebarItem(
                  icon: Icons.person_outline,
                  label: 'Users',
                  selected: _selectedIndex == 1,
                  onTap: () => _onItemTapped(1),
                ),
                _SidebarItem(
                  icon: Icons.account_tree_outlined,
                  label: 'Roles',
                  selected: _selectedIndex == 2,
                  onTap: () => _onItemTapped(2),
                ),
                _SidebarItem(
                  icon: Icons.groups_outlined,
                  label: 'Groups',
                  selected: _selectedIndex == 3,
                  onTap: () => _onItemTapped(3),
                ),
                _SidebarItem(
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                  selected: _selectedIndex == 4,
                  onTap: () => _onItemTapped(4),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 32.0,
                    left: 16.0,
                    right: 16.0,
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      // TODO: Implement logout logic
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.logout, color: Color(0xFF0B2447), size: 24),
                        SizedBox(width: 16),
                        Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0B2447),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Main Content Area
          Expanded(child: _screens[_selectedIndex]),
        ],
      ),
    );
  }
}

// We will move the content of DashboardScreen and UsersScreen into these widgets
class DashboardScreenContent extends StatelessWidget {
  const DashboardScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF7F9FB),
      padding: EdgeInsets.symmetric(horizontal: 48, vertical: 40),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0B2447),
              ),
            ),
            SizedBox(height: 20),
            // Statistic Cards
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _StatCard(title: 'TOTAL USERS', value: '152'),
                SizedBox(width: 32),
                _StatCard(title: 'ACTIVE USERS', value: '124'),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _StatCard(title: 'ROLES', value: '8'),
                SizedBox(width: 32),
                _StatCard(title: 'GROUPS', value: '5'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RolesScreenContent extends StatefulWidget {
  const RolesScreenContent({
    Key? key,
    required this.onRoleAdded,
    required this.roles,
  }) : super(key: key);

  final Function(Map<String, String>, List<String>?) onRoleAdded;
  final List<Map<String, String>> roles;

  @override
  _RolesScreenContentState createState() => _RolesScreenContentState();
}

class _RolesScreenContentState extends State<RolesScreenContent> {
  @override
  Widget build(BuildContext context) {
    return Container(); // Replace with actual content if needed
  }
}

class SettingsScreenContent extends StatelessWidget {
  const SettingsScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF7F9FB),
      padding: EdgeInsets.symmetric(horizontal: 48, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0B2447),
            ),
          ),
          SizedBox(height: 36),
          _SettingsTile(
            title: 'General',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
          Divider(height: 1, thickness: 1, color: Colors.grey[200]),
          _SettingsTile(
            title: 'Notifications',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NotificationsSettingsScreen(),
                ),
              );
            },
          ),
          Divider(height: 1, thickness: 1, color: Colors.grey[200]),
          // Removed: _SettingsTile(title: 'Billing', onTap: () {}),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  const _SettingsTile({required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 24, color: Color(0xFF23395d)),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[600], size: 32),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(vertical: 28, horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 20,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              color: Color(0xFF0B2447),
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      child: Material(
        color: selected ? Colors.white.withOpacity(0.08) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 22),
                SizedBox(width: 18),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
