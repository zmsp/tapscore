// platform_specific.dart

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/widgets.dart'; // For MediaQuery and context

void toggleFullscreenMode() {
  // Add your fullscreen logic here, without needing BuildContext
  if (!kIsWeb) {
    // Fullscreen logic for mobile or platform-specific
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }
}

void preventSleep() {
  // Platform-specific logic to prevent sleep (not needed for web in this case)
  if (!kIsWeb) {
    // Add code to prevent sleep on mobile platforms (Android/iOS)
    // Example: Using Flutter's `WidgetsBindingObserver` to prevent screen timeout
    WidgetsBinding.instance!.addObserver(LifecycleEventHandler());
  }
}

// LifecycleEventHandler to manage app lifecycle and prevent sleep
class LifecycleEventHandler extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Optionally, keep the screen on when the app is resumed
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
  }
}