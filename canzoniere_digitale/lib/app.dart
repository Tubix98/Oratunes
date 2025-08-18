import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  final String env;

  const MyApp({super.key, required this.env});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter $env',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flavor: $env'),
        ),
        body: Center(
          child: Text(
            'Benvenuto in ambiente $env!',
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
