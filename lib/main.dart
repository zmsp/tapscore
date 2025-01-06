import 'dart:async'; // Import the required package for Timer

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Virtual Scoreboard',
      theme: ThemeData(
        useMaterial3: true,
      ),
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
Color _teamAColor = const Color.fromARGB(255, 0, 38, 94)!; // Very dark blue
Color _teamBColor = const Color.fromARGB(255, 116, 0, 0)!;  // Very dark red

  int _stopwatchTime = 0; // Stopwatch time in seconds
  late Timer _timer;

  // Start the stopwatch
  void _startStopwatch() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _stopwatchTime++;
      });
    });
  }

  // Reset the stopwatch
  void _resetStopwatch() {
    setState(() {
      _stopwatchTime = 0;
    });
    _timer.cancel(); // Stop the timer
    _startStopwatch(); // Restart the stopwatch
  }

  void _incrementScore(String team) {
    setState(() {
      if (team == 'A') {
        _teamAScore++;
      } else {
        _teamBScore++;
      }
    });
  }

  void _decrementScore(String team) {
    setState(() {
      if (team == 'A' && _teamAScore > 0) {
        _teamAScore--;
      } else if (team == 'B' && _teamBScore > 0) {
        _teamBScore--;
      }
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
                _resetStopwatch(); // Reset stopwatch when scores are reset
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
      int tempScore = _teamAScore;
      _teamAScore = _teamBScore;
      _teamBScore = tempScore;

      Color tempColor = _teamAColor;
      _teamAColor = _teamBColor;
      _teamBColor = tempColor;
    });
  }

  @override
  void initState() {
    super.initState();
    _startStopwatch(); // Start stopwatch when the app starts
  }

  @override
  void dispose() {
    _timer.cancel(); // Make sure to cancel the timer when the app is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen dimensions
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Calculate font size dynamically based on the screen width (you can adjust this formula)
    double fontSize =
        screenWidth * 0.2; // Font size will scale with screen width

    // Format stopwatch time
    String formattedTime =
        '${(_stopwatchTime ~/ 60).toString().padLeft(2, '0')}:${(_stopwatchTime % 60).toString().padLeft(2, '0')}';

    return Scaffold(
      body: Stack(
        children: [
          // Blue and Red Sections
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _incrementScore('A'),
                  child: Container(
                    color: _teamAColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () => _incrementScore('A'),
                          icon: const Icon(Icons.add_circle,
                              size: 40, color: Colors.white),
                        ),
                        Text(
                          '$_teamAScore',
                          style: TextStyle(
                              fontSize: fontSize, color: Colors.white),
                        ),
                        // Decrement button below Team A score
                        IconButton(
                          onPressed: () => _decrementScore('A'),
                          icon: const Icon(Icons.remove_circle,
                              size: 40, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                flex: 1,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => _incrementScore('B'),
                  child: Container(
                    color: _teamBColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () => _incrementScore('B'),
                          icon: const Icon(Icons.add_circle,
                              size: 40, color: Colors.white),
                        ),
                        Text(
                          '$_teamBScore',
                          style: TextStyle(
                              fontSize: fontSize, color: Colors.white),
                        ),
                        // Decrement button below Team B score
                        IconButton(
                          onPressed: () => _decrementScore('B'),
                          icon: const Icon(Icons.remove_circle,
                              size: 40, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                flex: 1,
              ),
            ],
          ),
          // Center Buttons
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                // Stopwatch Display
                Text(
                  formattedTime,
                  style: TextStyle(fontSize: 40, color: Colors.white),
                ),
                const SizedBox(height: 10),
                // Reset button
                FloatingActionButton(
                  onPressed: _resetScores,
                  backgroundColor: Colors.grey[700],
                  shape: const CircleBorder(), // Ensures the button is round
                  child: const Icon(Icons.refresh, color: Colors.white),
                ),
                const SizedBox(height: 10),
                // Swap button
                FloatingActionButton(
                  onPressed: _swapScores,
                  backgroundColor: Colors.orange,
                  shape: const CircleBorder(), // Ensures the button is round
                  child: const Icon(Icons.swap_horiz, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
