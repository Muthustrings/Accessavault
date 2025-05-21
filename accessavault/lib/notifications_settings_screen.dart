import 'package:flutter/material.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  @override
  _NotificationsSettingsScreenState createState() =>
      _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState
    extends State<NotificationsSettingsScreen> {
  bool emailNotifications = false;
  bool smsNotifications = false;
  bool pushNotifications = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F9FB),
      body: Center(
        child: Container(
          width: 480,
          padding: EdgeInsets.symmetric(horizontal: 36, vertical: 40),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B2447),
                ),
              ),
              SizedBox(height: 40),
              _NotificationToggle(
                label: 'Email Notifications',
                value: emailNotifications,
                onChanged: (val) => setState(() => emailNotifications = val),
              ),
              SizedBox(height: 24),
              _NotificationToggle(
                label: 'SMS Notifications',
                value: smsNotifications,
                onChanged: (val) => setState(() => smsNotifications = val),
              ),
              SizedBox(height: 24),
              _NotificationToggle(
                label: 'Push Notifications',
                value: pushNotifications,
                onChanged: (val) => setState(() => pushNotifications = val),
              ),
              SizedBox(height: 48),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0B2447),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 44, vertical: 18),
                  ),
                  onPressed: () {
                    // Save logic here
                  },
                  child: Text('Save', style: TextStyle(fontSize: 20)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationToggle extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _NotificationToggle({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 24,
            color: Color(0xFF3A4A5D),
            fontWeight: FontWeight.w400,
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.white,
          activeTrackColor: Color(0xFF0B2447),
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: Colors.grey[400],
        ),
      ],
    );
  }
}
