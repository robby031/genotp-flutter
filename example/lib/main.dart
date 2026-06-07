import 'package:flutter/material.dart';
import 'package:genotp_flutter/genotp_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _secret = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadSecret();
  }

  Future<void> _loadSecret() async {
    final secret = await GenotpFlutter.generateSecret();
    if (!mounted) return;
    setState(() {
      _secret = secret;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Center(child: Text('Generated secret: $_secret\n')),
      ),
    );
  }
}
