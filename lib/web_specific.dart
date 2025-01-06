// web_specific.dart
import 'dart:html' as html;
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'dart:js' as js;

void toggleFullscreenMode() {
  if (kIsWeb) {
    // For web: Check if currently in fullscreen and toggle
    if (html.document.fullscreenElement != null) {
      // Exit fullscreen
      html.document.exitFullscreen();
    } else {
      // Enter fullscreen
      html.document.documentElement?.requestFullscreen();
    }
  } 
  // else {
  //   // For Android/iOS: Use SystemChrome to toggle fullscreen
  //   if (MediaQuery.of(context).viewInsets.bottom == 0) {
  //     // Enter fullscreen
  //     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  //   } else {
  //     // Exit fullscreen (restore system UI)
  //     SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
  //   }
  // }
}

void preventSleep() {
}
  // void _preventSleep() {
  //   if (kIsWeb) {
  //     // Use JavaScript interop to invoke the wake lock API
  //     js.context.callMethod('eval', [
  //       '''
  //         if ('wakeLock' in navigator) {
  //           let wakeLock = null;
  //           try {
  //             navigator.wakeLock.request('screen').then(lock => {
  //               wakeLock = lock;
  //             });
  //           } catch (err) {
  //             console.error("Failed to acquire wake lock: ", err);
  //           }
  //         } else {
  //           console.log("Wake Lock API not supported.");
  //         }
  //       '''
  //     ]);
  //   }
  // }