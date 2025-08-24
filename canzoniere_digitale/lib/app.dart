/*import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  final String env;

  const MyApp({super.key, required this.env, required String flavor});

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
*/
import 'package:canzoniere_digitale/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_chord/flutter_chord.dart';

class CanzoniereApp extends StatefulWidget {
  const CanzoniereApp({super.key});

  @override
  State<CanzoniereApp> createState() => _CanzoniereAppState();
}

class _CanzoniereAppState extends State<CanzoniereApp> {
  String songContent = '';
  final textStyle = TextStyle(fontSize: 18, color: Colors.black);
  final chordStyle = TextStyle(fontSize: 20, color: Colors.blue);

  @override
  void initState() {
    super.initState();
    _loadSong();
  }

  Future<void> _loadSong() async {
    final content = await rootBundle.loadString('assets/songs/abbracciami.cho');
    setState(() {
      songContent = content;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Oratunes",
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(flavor: 'dev'),
    );
  }
}


/*Scaffold(
        appBar: AppBar(
          title: const Text("Oratunes"),
        ),
        body: songContent == null
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: LyricsRenderer(lyrics: songContent, textStyle: textStyle, chordStyle: chordStyle, onTapChord: (String chord) {
      print('pressed chord: $chord');
    },)
                ),
              ),
      ),*/