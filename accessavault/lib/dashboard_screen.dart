import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:accessavault/main.dart'; // For UserProvider
import 'package:accessavault/client_provider.dart'; // For ClientProvider
import 'package:accessavault/role_provider.dart'; // For RoleProvider
import 'package:accessavault/group_provider.dart'; // For GroupProvider
import 'package:accessavault/app_provider.dart'; // For AppProvider

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final clientProvider = Provider.of<ClientProvider>(context);
    final roleProvider = Provider.of<RoleProvider>(context);
    final groupProvider = Provider.of<GroupProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);

    final int totalUsers = userProvider.users.length;
    final int activeUsers =
        userProvider.users.where((user) => user['status'] == 'Active').length;
    final int totalClients = clientProvider.clients.length;
    final int totalRoles = roleProvider.roles.length;
    final int totalGroups = groupProvider.groups.length;
    final int totalApps = appProvider.apps.length;

    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD), // Light Blue background
      appBar: AppBar(
        backgroundColor: const Color(0xFFE3F2FD), // Light Blue background
        elevation: 0,
        title: const Text(
          'Dashboard',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 24,
                runSpacing: 24,
                children: [
                  _buildStatCard(
                    'Total Users',
                    totalUsers.toString(),
                    Colors.blue.shade700,
                  ),
                  _buildStatCard(
                    'Active Users',
                    activeUsers.toString(),
                    Colors.green.shade700,
                  ),
                  _buildStatCard(
                    'Total Roles',
                    totalRoles.toString(),
                    Colors.purple.shade700,
                  ),
                  _buildStatCard(
                    'Total Groups',
                    totalGroups.toString(),
                    Colors.orange.shade700,
                  ),
                  _buildStatCard(
                    'Total Clients',
                    totalClients.toString(),
                    Colors.red.shade700,
                  ),
                  _buildStatCard(
                    'Total Apps',
                    totalApps.toString(),
                    Colors.teal.shade700,
                  ),
                ],
              ),
              const SizedBox(height: 48),
              Text(
                'Overview',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildBarChartCard(
                      'User Status',
                      [
                        BarChartGroupData(
                          x: 0,
                          barRods: [
                            BarChartRodData(
                              toY: totalUsers.toDouble(),
                              color: Colors.lightBlueAccent,
                              width: 20,
                            ),
                          ],
                        ),
                        BarChartGroupData(
                          x: 1,
                          barRods: [
                            BarChartRodData(
                              toY: activeUsers.toDouble(),
                              color: Colors.blue.shade800,
                              width: 20,
                            ),
                          ],
                        ),
                      ],
                      ['Total', 'Active'],
                      totalUsers,
                      activeUsers,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _buildPieChartCard('Client Status', [
                      PieChartSectionData(
                        color: Colors.lightBlueAccent,
                        value:
                            clientProvider.clients
                                .where((c) => c.status == 'Active')
                                .length
                                .toDouble(),
                        title: 'Active',
                        radius: 50,
                        titleStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      PieChartSectionData(
                        color: Colors.blue.shade800,
                        value:
                            clientProvider.clients
                                .where((c) => c.status == 'Inactive')
                                .length
                                .toDouble(),
                        title: 'Inactive',
                        radius: 50,
                        titleStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      width: 200, // Adjusted width for more cards
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
              color: color,
              fontSize: 18, // Adjusted font size
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              color: Color(0xFF0D47A1), // Dark Blue text
              fontSize: 40, // Adjusted font size
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChartCard(
    String title,
    List<BarChartGroupData> barGroups,
    List<String> titles,
    int totalUsers,
    int activeUsers,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D47A1), // Dark Blue text
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  barGroups: barGroups,
                  minY: 0,
                  maxY:
                      totalUsers.toDouble() > activeUsers.toDouble()
                          ? totalUsers.toDouble() + 5
                          : activeUsers.toDouble() +
                              5, // Add some padding to maxY
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          rod.toY.toString(),
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 50,
                      ), // Increased reservedSize
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 8, // Increased space
                            child: Text(
                              titles[value.toInt()],
                              style: const TextStyle(fontSize: 12),
                            ),
                          );
                        },
                        reservedSize: 50, // Increased reservedSize
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChartCard(String title, List<PieChartSectionData> sections) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D47A1), // Dark Blue text
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: sections,
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
