import 'package:flutter/material.dart';
import '../../features/song/domain/song_model.dart';
import 'custom_lyrics_line.dart';

/// Widget "manager" che riceve un intero oggetto Song e si occupa di
/// renderizzare ogni sua riga, delegando il lavoro pesante a CustomLyricsLine.
class LyricsRendererWrapper extends StatelessWidget {
  final Song song;
  final int transpose;
  final bool showChords;

  const LyricsRendererWrapper({
    super.key,
    required this.song,
    this.transpose = 0,
    this.showChords = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: song.lines.map((line) {
        if (line.content.isEmpty) {
          return const Text('', style: TextStyle(height: 2.0));
        }
        // Altrimenti, usa il nostro widget per renderizzare la riga con gli accordi
        return CustomLyricsLine(
          line: line,
          transposeIncrement: transpose,
          showChords: showChords,
        );
      }).toList(),
    );
  }
}
