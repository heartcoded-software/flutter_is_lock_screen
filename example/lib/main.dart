import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_is_lock_screen/is_lock_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  bool _isLockScreen = true;


  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    bool isLockScreenActive = true;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    
    try {
      platformVersion = await getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

       try {
         isLockScreenActive = await isLockScreen() ?? true;
    } on PlatformException {
      platformVersion = 'Failed to get Lockscreen-Status.';
    }
    

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
       _platformVersion = platformVersion;
       _isLockScreen = isLockScreenActive;
    });
  }

  Future<void> isLockScreenActive() async {
    bool isLockScreenActive = false;
    try {
      isLockScreenActive = await isLockScreen() ?? true;
      print('Lockscreen is active: $isLockScreenActive');
    } on PlatformException {
      print('Failed to get Lockscreen-Status.');
    }
    setState(() {
      _isLockScreen = isLockScreenActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('Running on: $_platformVersion\n'),
              Text('Lockscreen is active: $_isLockScreen\n'),
              const Text('When running the example App, the Lockscreen should be inactive.\n'
                  'If the Text above indacates true, then there seems to be a problem with the Plugin.\n'),
              ElevatedButton(
                onPressed: isLockScreenActive,
                child: const Text('Check Lockscreen'),
              ),
            ],
          ),

        ),
      ),
    );
  }
}
