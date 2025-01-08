import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'platform_specific.dart' if (dart.library.html) 'web_specific.dart';
class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isFullscreen = false;
  bool _preventSleep = false;

  @override
  void initState() {
    super.initState();
    _loadSettings(); // Load settings when the page is first built
  }

  // Load the settings from SharedPreferences
  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isFullscreen = prefs.getBool('isFullscreen') ?? false;
      _preventSleep = prefs.getBool('preventSleep') ?? false;
    });
  }

  // Save the settings to SharedPreferences
  void _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isFullscreen', _isFullscreen);
    prefs.setBool('preventSleep', _preventSleep);
  }

  void _toggleFullscreen() {
        setState(() {
      if (toggleFullscreenMode(_isFullscreen)) {
     
      _saveSettings(); 
      }
        _isFullscreen = !_isFullscreen;
    });
  
  }

  // This function can trigger the necessary functionality to prevent sleep
  void _togglePreventSleep(bool value) {
    setState(() {
      _preventSleep = value;
      _saveSettings(); // Save the updated setting
    });
    preventSleep(context);
  }

  void _showHelp() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Help"),
          content: const Text(
              "Tap on the red or blue sections to increase the score for Red or Blue Team. "
              "Use the + and - buttons to adjust scores. "
              "Use the reset button to reset scores and stopwatch. "
              "Use the swap button to swap scores and colors."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("Fullscreen Mode"),
            value: _isFullscreen,
            onChanged: (value) => _toggleFullscreen(),
          ),
          SwitchListTile(
            title: const Text("Prevent Screen Sleep"),
            value: _preventSleep,
            onChanged: (value) => _togglePreventSleep(value),
          ),
          ListTile(
            title: const Text("Help"),
            leading: const Icon(Icons.help),
            onTap: _showHelp,
          ),
          // Add more settings options here as needed
        ],
      ),
    );
  }
}