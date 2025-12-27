import '../model/editable_song.dart';
import '../model/editable_line.dart';
import '../model/chord_position.dart';
import '../../../../core/utils/chord_transposer.dart';

/// Parser:
/// .chordpro (String)  →  EditableSong
EditableSong parseChordProToEditable(String content) {
  final rawLines = content.split('\n');

  String title = '';
  String section = '';
  List<String> tags = [];
  String? key;

  final List<EditableLine> editableLines = [];

  for (final raw in rawLines) {
    final line = raw.trimRight();

    // ------------------------------------------------------------
    // METADATI E COMMENTI { ... }
    // ------------------------------------------------------------
    if (line.startsWith('{') && line.endsWith('}')) {
      if (line.startsWith('{title:')) {
        title = _extractValue(line);
      } else if (line.startsWith('{section:')) {
        section = _extractValue(line);
      } else if (line.startsWith('{tags:')) {
        tags = _extractValue(line)
            .split(',')
            .map((t) => t.trim())
            .toList();
      } else if (line.startsWith('{key:')) {
        key = _extractValue(line);
      } else {
        // Tutti gli altri blocchi ({c:}, {start_of_chorus}, ecc.)
        editableLines.add(
          EditableLine(
            text: line,
            isComment: true,
          ),
        );
      }
      continue;
    }

    // ------------------------------------------------------------
    // RIGA VUOTA
    // ------------------------------------------------------------
    if (line.isEmpty) {
      editableLines.add(
        EditableLine(text: ''),
      );
      continue;
    }

    // ------------------------------------------------------------
    // RIGA CON TESTO + ACCORDI [DO]
    // ------------------------------------------------------------
    final buffer = StringBuffer();
    final List<ChordPosition> chords = [];

    int textIndex = 0;
    int i = 0;

    while (i < line.length) {
      if (line[i] == '[') {
        final end = line.indexOf(']', i);
        if (end == -1) {
          // parentesi aperta senza chiusura → ignora
          i++;
          continue;
        }

        final chordText = line.substring(i + 1, end);
        final chordModel = parseChord(chordText);

        if (chordModel != null) {
          chords.add(
            ChordPosition(
              chord: chordModel,
              charIndex: textIndex,
            ),
          );
        }

        i = end + 1;
      } else {
        buffer.write(line[i]);
        textIndex++;
        i++;
      }
    }

    editableLines.add(
      EditableLine(
        text: buffer.toString(),
        chords: chords,
      ),
    );
  }

  return EditableSong(
    title: title,
    section: section,
    tags: tags,
    key: key,
    lines: editableLines,
  );
}

/// Estrae il valore da una riga tipo {key: MI}
String _extractValue(String line) {
  final start = line.indexOf(':') + 1;
  final end = line.lastIndexOf('}');
  if (start <= 0 || end <= start) return '';
  return line.substring(start, end).trim();
}
