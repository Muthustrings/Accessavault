import 'package:flutter/material.dart';

class GeneralSettingsScreen extends StatefulWidget {
  @override
  _GeneralSettingsScreenState createState() => _GeneralSettingsScreenState();
}

class _GeneralSettingsScreenState extends State<GeneralSettingsScreen> {
  final TextEditingController _companyNameController = TextEditingController(
    text: 'Example Corporation',
  );
  String _selectedLanguage = 'English (United States)';
  String _selectedTimeZone = '(UTC-05:00) Eastern Time (U S Canada)';
  final TextEditingController _dateFormatController = TextEditingController(
    text: 'MM/DD/YYYY',
  );

  final List<String> _languages = [
    'English (United States)',
    'Spanish (Spain)',
    'French (France)',
    'German (Germany)',
  ];

  final List<String> _timeZones = [
    '(UTC-05:00) Eastern Time (U S Canada)',
    '(UTC+00:00) London',
    '(UTC+01:00) Berlin',
    '(UTC+09:00) Tokyo',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F9FB),
      body: Stack(
        children: [
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Color(0xFF0B2447), size: 32),
              onPressed: () => Navigator.of(context).pop(),
              tooltip: 'Back',
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                width: 520,
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
                      'General',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0B2447),
                      ),
                    ),
                    SizedBox(height: 40),
                    _LabeledField(
                      label: 'Company Name',
                      child: TextField(
                        controller: _companyNameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    SizedBox(height: 24),
                    _LabeledField(
                      label: 'Language',
                      child: DropdownButtonFormField<String>(
                        value: _selectedLanguage,
                        items:
                            _languages
                                .map(
                                  (lang) => DropdownMenuItem(
                                    value: lang,
                                    child: Text(
                                      lang,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                )
                                .toList(),
                        onChanged: (val) {
                          if (val != null)
                            setState(() => _selectedLanguage = val);
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    _LabeledField(
                      label: 'Time Zone',
                      child: DropdownButtonFormField<String>(
                        value: _selectedTimeZone,
                        items:
                            _timeZones
                                .map(
                                  (tz) => DropdownMenuItem(
                                    value: tz,
                                    child: Text(
                                      tz,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                )
                                .toList(),
                        onChanged: (val) {
                          if (val != null)
                            setState(() => _selectedTimeZone = val);
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    _LabeledField(
                      label: 'Date Format',
                      child: TextField(
                        controller: _dateFormatController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    SizedBox(height: 40),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF0B2447),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 44,
                            vertical: 18,
                          ),
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
          ),
        ],
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final Widget child;
  const _LabeledField({required this.label, required this.child});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 22,
            color: Color(0xFF3A4A5D),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        child,
      ],
    );
  }
}
