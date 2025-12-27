import '../model/editable_song.dart';
import '../model/chord_position.dart';
import '../../../../core/utils/chord_transposer.dart';

/// Exporter:
/// EditableSong → String in formato .chordpro
String exportEditableSongToChordPro(
  EditableSong song, {
  int transpose = 0,
}) {
  final buffer = StringBuffer();

  // ------------------------------------------------------------
  // METADATI
  // ------------------------------------------------------------
  if (song.title.isNotEmpty) {
    buffer.writeln('{title: ${song.title}}');
  }
  if (song.section.isNotEmpty) {
    buffer.writeln('{section: ${song.section}}');
  }
  if (song.tags.isNotEmpty) {
    buffer.writeln('{tags: ${song.tags.join(', ')}}');
  }
  if (song.key != null && song.key!.isNotEmpty) {
  buffer.writeln('{key: ${song.key}}');
  }

  buffer.writeln(); // riga vuota dopo i metadati

  // ------------------------------------------------------------
  // LINEE
  // ------------------------------------------------------------
  for (final line in song.lines) {
    // Commenti ({c:}, {start_of_chorus}, ecc.)
    if (line.isComment) {
      buffer.writeln(line.text);
      continue;
    }

    // Riga vuota
    if (line.text.isEmpty && line.chords.isEmpty) {
      buffer.writeln();
      continue;
    }

    buffer.writeln(
      _buildChordProLine(
        text: line.text,
        chords: line.chords,
        transpose: transpose,
      ),
    );
  }

  return buffer.toString().trimRight();
}

/// Costruisce una singola riga ChordPro inserendo gli accordi nel testo
String _buildChordProLine({
  required String text,
  required List<ChordPosition> chords,
  required int transpose,
}) {
  if (chords.isEmpty) return text;

  final chars = text.split('');
  final buffer = StringBuffer();

  // Ordina gli accordi per posizione decrescente
  final sortedChords = [...chords]
    ..sort((a, b) => b.charIndex.compareTo(a.charIndex));

  final usedIndexes = <int, List<ChordPosition>>{};

  for (final chord in sortedChords) {
    usedIndexes.putIfAbsent(chord.charIndex, () => []).add(chord);
  }

  for (int i = 0; i <= chars.length; i++) {
    if (usedIndexes.containsKey(i)) {
      for (final chordPos in usedIndexes[i]!) {
        final transposed = transposeModel(chordPos.chord, transpose);
        final chordText = formatChord(transposed);
        buffer.write('[$chordText]');
      }
    }

    if (i < chars.length) {
      buffer.write(chars[i]);
    }
  }

  return buffer.toString().trimRight();
}
