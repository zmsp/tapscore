import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart'; // For SystemChrome and WidgetsBinding

// Function to toggle fullscreen mode
bool toggleFullscreenMode(bool isFullscreen) {
  if (!isFullscreen) {
    // Enable immersive sticky fullscreen mode for iOS/Android
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return true; // Successfully toggled to fullscreen
  } else {
    // Restore the system UI to normal mode (visible status bar and navigation)
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    return true; // Successfully toggled to exit fullscreen
  }
}

// Function to prevent sleep (on mobile platforms)
void preventSleep() {
  // Prevent screen from going to sleep (on mobile platforms)
  WidgetsBinding.instance!.addObserver(LifecycleEventHandler());
}

// LifecycleEventHandler to manage app lifecycle and prevent sleep
class LifecycleEventHandler extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Optionally, keep the screen on when the app is resumed
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    }
  }
}
