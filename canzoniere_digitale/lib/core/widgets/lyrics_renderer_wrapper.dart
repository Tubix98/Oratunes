import 'package:flutter/material.dart';
import '../../features/song/domain/song_model.dart';
import 'custom_lyrics_line.dart';

/// Widget "manager" che riceve un intero oggetto Song e si occupa di
/// renderizzare ogni sua riga, delegando il lavoro pesante a CustomLyricsLine.
class LyricsRendererWrapper extends StatelessWidget {
  final Song song;
  final int transpose;
  final bool showChords;
  final double fontScale;

  const LyricsRendererWrapper({
    super.key,
    required this.song,
    this.transpose = 0,
    this.showChords = true,
    this.fontScale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: song.lines.map((line) {
        // Riga davvero vuota (nessun testo, nessun accordo)
        if (line.content.isEmpty && line.chords.isEmpty) {
          return const SizedBox(height: 16);
        }
        // Tutti gli altri casi (testo, accordi o entrambi)
        return CustomLyricsLine(
          line: line,
          transposeIncrement: transpose,
          showChords: showChords,
          fontScale: fontScale,
        );
      }).toList(),
    );
  }
}
