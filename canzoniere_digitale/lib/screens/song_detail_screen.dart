import 'package:flutter/material.dart';
import '../repositories/song_repository.dart';
import '../widgets/chord_viewer.dart';

class SongDetailScreen extends StatefulWidget {
  final String songId;
  const SongDetailScreen({super.key, required this.songId});

  @override
  State<SongDetailScreen> createState() => _SongDetailScreenState();
}

class _SongDetailScreenState extends State<SongDetailScreen> {
  final repo = SongRepository();
  String chordpro = '';
  String title = '';
  bool showChords = true;
  int transpose = 0;
  double fontSize = 18;

  @override
  void initState() {
    super.initState();
    repo.findById(widget.songId).then((s) {
      if (s != null) {
        setState(() {
          chordpro = s.chordpro;
          title = s.title;
        });
      }
    });
  }

  void _incTranspose(int delta) => setState(() => transpose += delta);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title.isEmpty ? 'Brano' : title),
        actions: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () => _incTranspose(-1),
          ),
          Center(child: Text('$transpose')),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _incTranspose(1),
          ),
          IconButton(
            icon: const Icon(Icons.music_off),
            onPressed: () => setState(() => showChords = !showChords),
          ),
        ],
      ),
      body: ChordViewer(
        chordpro: chordpro,
        transpose: transpose,
        showChords: showChords,
        fontSize: fontSize,
      ),
      bottomNavigationBar: Slider(
        value: fontSize,
        min: 12,
        max: 28,
        onChanged: (v) => setState(() => fontSize = v),
      ),
    );
  }
}
