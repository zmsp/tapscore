import 'package:flutter/material.dart';
// Conditional import for web-specific functionality
import 'platform_specific.dart' if (dart.library.html) 'web_specific.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isFullscreen = false;

  void _toggleFullscreen() {
    setState(() {
      // Only toggle if the fullscreen state actually changes based on the result of the function
      if (toggleFullscreenMode(_isFullscreen)) {
        _isFullscreen =
            !_isFullscreen; // Toggle the fullscreen state if the function returned true
      }
    });
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
