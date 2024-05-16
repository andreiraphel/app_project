import 'package:flutter/material.dart';
import 'models.dart';

class SettingsScreen extends StatefulWidget {
  final ReviewSettings settings;
  final Function(ReviewSettings) onSave;

  SettingsScreen({required this.settings, required this.onSave});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _initialIntervalController;
  late TextEditingController _intervalMultiplierController;
  late TextEditingController _sessionDurationController;

  @override
  void initState() {
    super.initState();
    _initialIntervalController =
        TextEditingController(text: widget.settings.initialInterval.toString());
    _intervalMultiplierController = TextEditingController(
        text: widget.settings.intervalMultiplier.toString());
    _sessionDurationController =
        TextEditingController(text: widget.settings.sessionDuration.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _initialIntervalController,
              decoration: InputDecoration(labelText: 'Initial Interval (days)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _intervalMultiplierController,
              decoration: InputDecoration(labelText: 'Interval Multiplier'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _sessionDurationController,
              decoration:
                  InputDecoration(labelText: 'Session Duration (minutes)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final settings = ReviewSettings(
                  initialInterval: int.parse(_initialIntervalController.text),
                  intervalMultiplier:
                      double.parse(_intervalMultiplierController.text),
                  sessionDuration: int.parse(_sessionDurationController.text),
                );
                widget.onSave(settings);
                Navigator.pop(context);
              },
              child: Text('Save Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
