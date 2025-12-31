// Contiene il parser che trasforma una stringa ChordPro in un oggetto Song.
// Legge i metadati {title: ...}, {section: ...}, {tags: ...} e le righe con accordi.
// Restituisce un modello Song pronto per essere mostrato.
//
// Cosa si può aggiungere:
// - Supporto completo a tutti i comandi ChordPro (es. {key:}, {tempo:}, {comment:})
// - Trasposizione automatica di tonalità.

import 'package:canzoniere/features/song/domain/chord_model.dart';
import 'package:canzoniere/features/song/domain/song_model.dart';
import 'package:canzoniere/core/utils/chord_transposer.dart';

Song parseChordPro(String content) {
  String title = '';
  String section = '';
  String author = '';
  ChordModel? key;
  List<String> tags = [];
  List<SongLine> lines = [];

  final linesRaw = content.split('\n');
  bool inChorus = false;

  for (var line in linesRaw) {
    line = line.trim();
    if (line.startsWith('#')) {
      // Ignora i commenti che iniziano con #
      continue;
    }
    if (line.startsWith('{') && line.endsWith('}')) {
      // Gestione dei metadati racchiusi tra parentesi graffe
      if (line.startsWith('{title:')) {
        title = line.replaceAll(RegExp(r'\{title:\s*|\}'), '').trim();
      } else if (line.startsWith('{section:')) {
        section = line.replaceAll(RegExp(r'\{section:\s*|\}'), '').trim();
      } else if (line.startsWith('{author:')) {
        author = line.replaceAll(RegExp(r'\{author:\s*|\}'), '').trim();
      } else if (line.startsWith('{key:')) {
        key = parseChord(line.replaceAll(RegExp(r'\{key:\s*|\}'), '').trim());
      } else if (line.startsWith('{tags:')) {
        final tagString = line.replaceAll(RegExp(r'\{tags:\s*|\}'), '').trim();
        tags = tagString.split(',').map((e) => e.trim()).toList();
      } else if (line.startsWith('{start_of_chorus}')) {
        inChorus = true;
      } else if (line.startsWith('{end_of_chorus}')) {
        inChorus = false;
      } else if (line.startsWith('{c:')) {
        lines.add(
          SongLine(
            content: line.replaceAll(RegExp(r'\{c:|\}'), '').trim(),
            isComment: true,
          ),
        );
      } else {
        // Altri comandi ChordPro non gestiti
        continue;
      }
    } else if (line.isEmpty) {
      lines.add(SongLine(content: ''));
    } else if (line.isNotEmpty) {
      lines.add(SongLine(content: line, isChorus: inChorus));
    }
  }

  return Song(
    title: title,
    section: section,
    author: author,
    key: key,
    tags: tags,
    lines: lines,
  );
}
