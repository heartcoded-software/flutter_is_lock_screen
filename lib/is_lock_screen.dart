library is_lock_screen;

import 'package:flutter/services.dart';

const _channel = MethodChannel('is_lock_screen');

Future<bool?> isLockScreen() async {
  try {
    return await _channel.invokeMethod('isLockScreen') as bool?;
  } catch (e) {
    return null;
  }
}

  Future<String?> getPlatformVersion() async {
    final version = await _channel.invokeMethod<String>('getPlatformVersion');
    return version;
  }