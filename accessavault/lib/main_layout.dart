import 'package:flutter/material.dart';
import 'settings_screen.dart';
import 'notifications_settings_screen.dart';
import 'users_screen.dart';
import 'groups_screen.dart';
import 'roles_screen.dart';
import 'dashboard_screen.dart';
import 'clients_screen.dart';
import 'apps_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 4; // 0 for Dashboard, 1 for Users, 4 for Clients

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens.addAll([
      DashboardScreen(),
      UsersScreen(),
      RolesScreen(),
      GroupsScreenContent(),
      ClientsScreen(),
      AppsScreen(),
      SettingsScreenContent(),
    ]);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          // Mobile layout
          return Scaffold(
            body: _screens[_selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  label: 'Users',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_tree_outlined),
                  label: 'Roles',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.groups_outlined),
                  label: 'Groups',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.business),
                  label: 'Clients',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.app_registration),
                  label: 'Apps',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings_outlined),
                  label: 'Settings',
                ),
              ],
              selectedItemColor: Color(0xFF0B2447),
              unselectedItemColor: Colors.grey,
              showUnselectedLabels: true,
            ),
          );
        } else {
          // Desktop layout
          return Scaffold(
            body: Row(
              children: [
                _buildSidebar(constraints.maxWidth > 1200 ? 260 : 200),
                Expanded(child: _screens[_selectedIndex]),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildSidebar(double width) {
    return Container(
      width: width,
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
                child: Icon(Icons.shield, color: Color(0xFF0B2447), size: 28),
              ),
              SizedBox(width: 12),
              if (width > 200)
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
            isExpanded: width > 200,
          ),
          _SidebarItem(
            icon: Icons.person_outline,
            label: 'Users',
            selected: _selectedIndex == 1,
            onTap: () => _onItemTapped(1),
            isExpanded: width > 200,
          ),
          _SidebarItem(
            icon: Icons.account_tree_outlined,
            label: 'Roles',
            selected: _selectedIndex == 2,
            onTap: () => _onItemTapped(2),
            isExpanded: width > 200,
          ),
          _SidebarItem(
            icon: Icons.groups_outlined,
            label: 'Groups',
            selected: _selectedIndex == 3,
            onTap: () => _onItemTapped(3),
            isExpanded: width > 200,
          ),
          _SidebarItem(
            icon: Icons.business,
            label: 'Clients',
            selected: _selectedIndex == 4,
            onTap: () => _onItemTapped(4),
            isExpanded: width > 200,
          ),
          _SidebarItem(
            icon: Icons.app_registration,
            label: 'Apps',
            selected: _selectedIndex == 5,
            onTap: () => _onItemTapped(5),
            isExpanded: width > 200,
          ),
          _SidebarItem(
            icon: Icons.settings_outlined,
            label: 'Settings',
            selected: _selectedIndex == 6,
            onTap: () => _onItemTapped(6),
            isExpanded: width > 200,
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
                  Icon(Icons.logout, color: Colors.white, size: 24),
                  if (width > 200) ...[
                    SizedBox(width: 16),
                    Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
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

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final bool isExpanded;

  const _SidebarItem({
    required this.icon,
    required this.label,
    this.selected = false,
    this.onTap,
    this.isExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Material(
        color: selected ? Colors.white.withOpacity(0.08) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 22),
                if (isExpanded) ...[
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Compare this snippet from accessavault/lib/settings_screen.dart:
