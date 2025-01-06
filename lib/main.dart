import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart'; // For kIsWeb

// Conditional import for web-specific functionality
import 'platform_specific.dart' if (dart.library.html) 'web_specific.dart';


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
  int _teamAScore = 0;
  int _teamBScore = 0;
  int _stopwatchTime = 0;
  late Timer _timer;

  Color _teamAColor = const Color(0xFF00265E); // Dark blue
  Color _teamBColor = const Color(0xFF740000); // Dark red

  @override
  void initState() {
    super.initState();
    _startStopwatch();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startStopwatch() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _stopwatchTime++;
      });
    });
  }

  void _resetStopwatch() {
    setState(() {
      _stopwatchTime = 0;
    });
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
              IconButton(
                onPressed: () => _incrementScore(team),
                icon: const Icon(Icons.add, size: 40, color: Colors.white),
              ),
              Text(
                '$score',
                style: TextStyle(fontSize: fontSize, color: Colors.white),
              ),
              IconButton(
                onPressed: () => _decrementScore(team),
                icon: const Icon(Icons.remove_circle_outline,
                    size: 40, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
      VoidCallback onPressed, IconData icon, Color backgroundColor) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      shape: const CircleBorder(),
      child: Icon(icon, color: Colors.white),
    );
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
            "Use the swap button to swap scores and colors.",
          ),
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
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth * 0.15;

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
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Text(formattedTime,
                    style: TextStyle(fontSize: 40, color: Colors.white)),
                const SizedBox(height: 10),
                _buildActionButton(_resetScores, Icons.refresh, Colors.black26),
                const SizedBox(height: 10),
                _buildActionButton(
                    _swapScores, Icons.swap_horiz, Colors.black26),
                const SizedBox(height: 10),
                _buildActionButton(
                    _showHelp, Icons.question_mark, Colors.black26),
              ],
            ),
          ),
          // Fullscreen button in the bottom right corner
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
    onPressed: toggleFullscreenMode,
              backgroundColor: Colors.black54,
              child: const Icon(Icons.fullscreen, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
