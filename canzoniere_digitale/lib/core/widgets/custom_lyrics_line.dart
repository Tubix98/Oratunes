import 'package:flutter/material.dart';
import '../../features/song/domain/song_model.dart';
import '../utils/chord_transposer.dart';
import '../layout/lyrics_layout.dart';

/// Widget che renderizza una singola riga di testo
/// con eventuali accordi posizionati sopra al testo
/// usando ChordPosition.position.
class CustomLyricsLine extends StatelessWidget {
  final SongLine line;
  final int transposeIncrement;
  final bool showChords;
  final double fontScale;

  const CustomLyricsLine({
    super.key,
    required this.line,
    required this.transposeIncrement,
    required this.showChords,
    this.fontScale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 18*fontScale,
      fontWeight: line.isChorus ? FontWeight.bold : FontWeight.normal,
      color: Colors.black87,
      height: 1.5,
    );

    final chordStyle = TextStyle(
      fontSize: 16*fontScale,
      fontWeight: FontWeight.bold,
      color: Colors.indigo,
      height: 1.2
    );

    // ----------------------------
    // COMMENTO (corsivo)
    // ----------------------------
    if (line.isComment) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 8*fontScale),
        child: Text(
          line.content,
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.black54,
            fontSize: 16*fontScale,
          ),
        ),
      );
    }

    // ----------------------------
    // RIGA DI SOLI ACCORDI
    // ----------------------------
    if (line.content.isEmpty && line.chords.isNotEmpty) {
      // Se gli accordi sono nascosti, non mostrare nulla
      if (!showChords) {
        return const SizedBox.shrink();
      }
      
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Wrap(
          spacing: 12,
          children: line.chords.map((chordPos) {
            final transposed = transposeModel(
              chordPos.chord,
              transposeIncrement,
            );

            final chordText = formatChord(
              transposed,
              style: NotationStyle.latin,
            );

            return Text(
              chordText,
              style: TextStyle(
                fontSize: 16*fontScale,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            );
          }).toList(),
        ),
      );
    }


    // ----------------------------
    // TESTO SENZA ACCORDI VISIBILI
    // ----------------------------
    if (!showChords || line.chords.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(line.content, style: textStyle),
      );
    }

    // ----------------------------
    // TESTO + ACCORDI (posizionati)
    // ----------------------------
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Testo
          Text(line.content, style: textStyle),

          // Accordi
          ...line.chords.map((chordPos) {
            final transposed = transposeModel(
              chordPos.chord,
              transposeIncrement,
            );

            final chordText = formatChord(
              transposed,
              style: NotationStyle.latin,
            );

            return Positioned(
              left: LyricsLayout.measureTextWidth(
                text: line.content,
                charIndex: chordPos.position,
                style: textStyle,
              ),
              top: LyricsLayout.chordTopOffset(textStyle),
              child: Text(chordText, style: chordStyle),
            );
          }),
        ],
      ),
    );
  }
}
