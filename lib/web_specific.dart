// web_specific.dart
import 'dart:html' as html;
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'dart:js' as js;

bool toggleFullscreenMode(bool isFullscreen) {
  if (kIsWeb) {
    if (!isFullscreen) {
      // Enter fullscreen
      if (html.document.fullscreenElement == null) {
        html.document.documentElement?.requestFullscreen();
        return true; // Successfully toggled to fullscreen
      }
    } else {
      // Exit fullscreen
      if (html.document.fullscreenElement != null) {
        html.document.exitFullscreen();
        return true; // Successfully toggled to exit fullscreen
      }
    }
  }
  return false; // No change made
}

void preventSleep() {
  if (kIsWeb) {
    // Use JavaScript interop to invoke the Wake Lock API to prevent sleep on the browser
    js.context.callMethod('eval', [
      '''
        if ('wakeLock' in navigator) {
          let wakeLock = null;
          try {
            navigator.wakeLock.request('screen').then(lock => {
              wakeLock = lock;
              lock.addEventListener('release', () => {
                console.log('Wake Lock released!');
              });
            });
          } catch (err) {
            console.error("Failed to acquire wake lock: ", err);
          }
        } else {
          console.log("Wake Lock API not supported.");
        }
      '''
    ]);
  }
}
