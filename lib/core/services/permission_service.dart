import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

/// PermissionService handles runtime permission checks and requests.
/// This is a thin modular wrapper around permission_handler so the rest of
/// the app can remain testable and platform-agnostic.
class PermissionService {
  PermissionService._privateConstructor();
  static final PermissionService _instance = PermissionService._privateConstructor();
  factory PermissionService() => _instance;

  /// Check microphone permission status.
  Future<ph.PermissionStatus> checkMicrophonePermission() async {
    final status = await ph.Permission.microphone.status;
    return status;
  }

  /// Request microphone permission with rationale flow support.
  /// Returns the new permission status.
  Future<ph.PermissionStatus> requestMicrophonePermission() async {
    final status = await ph.Permission.microphone.request();
    return status;
  }

  /// Opens app settings so user can manually grant permissions.
  Future<bool> openAppSettings() async {
    return await PermissionHandlerCompat.openAppSettings();
  }
}

/// Helper for safely opening settings in a testable way.
class PermissionHandlerCompat {
  static Future<bool> openAppSettings() async {
    try {
      return await ph.openAppSettings();
    } catch (_) {
      return false;
    }
  }
}
