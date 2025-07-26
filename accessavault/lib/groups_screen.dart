import 'package:flutter/material.dart';
import 'package:accessavault/multiple_groups_screen.dart';
import 'single_group_screen.dart';

class GroupsScreenContent extends StatefulWidget {
  const GroupsScreenContent({super.key});

  @override
  State<GroupsScreenContent> createState() => _GroupsScreenContentState();
}

class _GroupsScreenContentState extends State<GroupsScreenContent> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        double cardWidth = screenWidth < 600 ? 140 : 220;
        double cardHeight = screenWidth < 600 ? 100 : 180;
        double titleFontSize = screenWidth < 600 ? 18 : 28;
        double labelFontSize = screenWidth < 600 ? 12 : 20;
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Select Group Management Type',
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF162032),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenWidth < 600 ? 24 : 48),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _GroupTypeCard(
                      icon: Icons.person_outline,
                      label: 'Single Group',
                      width: cardWidth,
                      height: cardHeight,
                      labelFontSize: labelFontSize,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SingleGroupScreen(),
                          ),
                        );
                      },
                    ),
                    SizedBox(width: screenWidth < 600 ? 12 : 32),
                    _GroupTypeCard(
                      icon: Icons.groups_outlined,
                      label: 'Multiple Groups\n(Bulk)',
                      width: cardWidth,
                      height: cardHeight,
                      labelFontSize: labelFontSize,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MultipleGroupsScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _GroupTypeCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final double width;
  final double height;
  final double labelFontSize;
  final VoidCallback onTap;

  const _GroupTypeCard({
    required this.icon,
    required this.label,
    required this.width,
    required this.height,
    required this.labelFontSize,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE0E6ED), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 56, color: const Color(0xFF162032)),
            const SizedBox(height: 24),
            Text(
              label,
              style: TextStyle(
                fontSize: labelFontSize,
                fontWeight: FontWeight.w500,
                color: Color(0xFF162032),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
