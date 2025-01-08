import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';
import 'package:tap_score/settings_page.dart'; // For kIsWeb

import 'package:audioplayers/audioplayers.dart';

// For JS interop functionality (web only)
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Virtual Scoreboard',
      theme: ThemeData(useMaterial3: true),
      home: const Scoreboard(),
    );
  }
}

class Scoreboard extends StatefulWidget {
  const Scoreboard({super.key});

  @override
  State<Scoreboard> createState() => _ScoreboardState();
}

class _ScoreboardState extends State<Scoreboard> {
  late final AudioPlayer _audioPlayer;
  int _teamAScore = 0, _teamBScore = 0, _stopwatchTime = 0;
  late Timer _timer;
  Color _teamAColor = const Color(0xFF00265E),
      _teamBColor = const Color(0xFF740000);

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _startStopwatch();
  }

  @override
  void dispose() {
    _timer.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playHornSound() async {
    try {
      await _audioPlayer.play(AssetSource('whistle.mp3'));
    } catch (e) {
      print("Error playing sound: $e");
    }
  }

  void _startStopwatch() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _stopwatchTime++);
    });
  }

  void _resetStopwatch() {
    setState(() => _stopwatchTime = 0);
    _timer.cancel();
    _startStopwatch();
  }

  void _incrementScore(String team) {
    setState(() {
      if (team == 'A')
        _teamAScore++;
      else
        _teamBScore++;
    });
  }

  void _decrementScore(String team) {
    setState(() {
      if (team == 'A' && _teamAScore > 0)
        _teamAScore--;
      else if (team == 'B' && _teamBScore > 0) _teamBScore--;
    });
  }

  void _resetScores() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Reset Scores"),
          content:
              const Text("Are you sure you want to reset both scores to 0?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _teamAScore = 0;
                  _teamBScore = 0;
                });
                Navigator.of(context).pop();
                _resetStopwatch();
              },
              child: const Text("Reset"),
            ),
          ],
        );
      },
    );
  }

  void _swapScores() {
    setState(() {
      final tempScore = _teamAScore;
      _teamAScore = _teamBScore;
      _teamBScore = tempScore;

      final tempColor = _teamAColor;
      _teamAColor = _teamBColor;
      _teamBColor = tempColor;
    });
  }

  String get formattedTime {
    return '${(_stopwatchTime ~/ 60).toString().padLeft(2, '0')}:${(_stopwatchTime % 60).toString().padLeft(2, '0')}';
  }

  Widget _buildTeamSection(
      Color color, String team, int score, double fontSize) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _incrementScore(team),
        child: Container(
          color: color,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$score',
                style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              // This will push the minus button to the bottom
              IconButton(
                onPressed: () => _incrementScore(team),
                icon: const Icon(Icons.add, size: 40, color: Colors.white38),
              ),
            ],
          ),
        ),
      ),
    );
  }

// Widget _buildActionButton(
//     {required VoidCallback onPressed,
//     required IconData icon,
//     required Color backgroundColor,
//     required String heroTag}) {
//   return FloatingActionButton(
//     heroTag: heroTag, // Use the passed heroTag
//     onPressed: onPressed,
//     backgroundColor: backgroundColor,
//     shape: const CircleBorder(),
//     child: Icon(icon, color: Colors.white),
//   );
// }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required Color backgroundColor,
    required String heroTag,
    String? tooltip,
    double? top,
    double? left,
    double? bottom,
    double? right,
  }) {
    // Wrap Positioned widget inside a Stack if not already inside one
    return Stack(
      children: [
        Positioned(
          top: top,
          left: left,
          bottom: bottom,
          right: right,
          child: Tooltip(
            message: tooltip ?? 'No info available',
            child: FloatingActionButton(
              heroTag: heroTag,
              onPressed: onPressed,
              backgroundColor: backgroundColor,
              shape: const CircleBorder(),
              child: Icon(icon, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Get the minimum value between width and height
    double smallerDimension =
        screenWidth < screenHeight ? screenWidth : screenHeight * 1.0;

    // Calculate font size based on the smaller dimension
    double fontSize = smallerDimension * 0.4; // Ad

    return Scaffold(
      body: Stack(
        children: [
          Row(
            children: [
              _buildTeamSection(_teamAColor, 'A', _teamAScore, fontSize),
              _buildTeamSection(_teamBColor, 'B', _teamBScore, fontSize),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Text(formattedTime,
                    style: TextStyle(fontSize: 40, color: Colors.white)),
                // _buildActionButton(
                //     toggleFullscreenMode, Icons.fullscreen, Colors.black12),
                // const SizedBox(height: 10),
                // _buildActionButton(
                //     _showHelp, Icons.question_mark, Colors.black26),
                //              const SizedBox(height: 10),

                const SizedBox(height: 10),

                const SizedBox(height: 10),
                _buildActionButton(
                  onPressed: _resetScores,
                  icon: Icons.refresh,
                  backgroundColor: Colors.black26,
                  tooltip: 'Reset the scores',
                  heroTag:
                      'resetScoresButton', // Unique heroTag for the reset button
                ),
                const SizedBox(height: 10),
                _buildActionButton(
                  onPressed: _swapScores,
                  icon: Icons.swap_horiz,
                  backgroundColor: Colors.black26,
                  tooltip: 'Swap scores and colors',
                  heroTag:
                      'swapScoresButton', // Unique heroTag for the swap button
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          _buildActionButton(
            onPressed: _playHornSound,
            icon: Icons.campaign,
            backgroundColor: Colors.black12,
            heroTag: 'hornButton',
            tooltip: 'Play Horn Sound',
            top: 20,
            left: 20,
          ),
          _buildActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsPage()));
            },
            icon: Icons.settings,
            backgroundColor: Colors.black12,
            heroTag: 'settingsButton',
            tooltip: 'Settings',
            top: 20,
            right: 20,
          ),
          _buildActionButton(
            onPressed: () => _decrementScore('A'),
            icon: Icons.exposure_neg_1,
            backgroundColor: Colors.black12,
            heroTag: 'decrementTeamAButton',
            tooltip: 'Decrement Team A Score',
            bottom: 20,
            left: 20,
          ),
          _buildActionButton(
            onPressed: () => _decrementScore('B'),
            icon: Icons.exposure_neg_1,
            backgroundColor: Colors.black12,
            heroTag: 'decrementTeamBButton',
            tooltip: 'Decrement Team B Score',
            bottom: 20,
            right: 20,
          ),
        ],
      ),
    );
  }
}
