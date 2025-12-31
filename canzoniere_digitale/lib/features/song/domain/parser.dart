// Parser Markdown + YAML → Song
//
// Regole supportate:
// - YAML Front Matter solo se il file inizia con '---'
// - Separatore visivo: '***' → riga vuota
// - Commento: *testo*
// - Ritornello: **testo**
// - Accordi inline: [MI] (lasciati nel testo)
// - Righe vuote ignorate (tranne separatori)
//
// Cosa si può aggiungere:
// - Parsing accordi → ChordPosition
// - Supporto heading multipli
// - Supporto multiline chorus

import 'package:canzoniere/features/song/domain/chord_model.dart';
import 'package:canzoniere/features/song/domain/song_model.dart';

Song parseMarkdownSong(String content) {
  String title = '';
  String section = '';
  String author = '';
  ChordModel? key;
  List<String> tags = [];
  List<SongLine> lines = [];

  final rawLines = content.split('\n');
  int index = 0;

  // ============================================================
  // 1️⃣ YAML FRONT MATTER (solo se all'inizio del file)
  // ============================================================
  if (rawLines.isNotEmpty && rawLines.first.trim() == '---') {
    index++; // entra nel YAML

    while (index < rawLines.length && rawLines[index].trim() != '---') {
      final line = rawLines[index].trim();

      if (line.contains(':')) {
        final parts = line.split(':');
        final keyName = parts.first.trim();
        final value = parts.sublist(1).join(':').trim();

        switch (keyName) {
          case 'title':
            title = value;
          case 'section':
            section = value;
          case 'author':
            author = value;
          case 'key':
            // per ora lasciamo la tonalità come testo
            // il parsing musicale lo faremo dopo
            key = null;
          case 'tags':
            tags = value
                .replaceAll('[', '')
                .replaceAll(']', '')
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList();
        }
      }

      index++;
    }

    // salta la riga di chiusura '---'
    if (index < rawLines.length) index++;
  }

  // ============================================================
  // 2️⃣ BODY MARKDOWN
  // ============================================================
  for (; index < rawLines.length; index++) {
    final rawLine = rawLines[index];
    final line = rawLine.trim();

    // ----------------------------
    // Ignora commenti tecnici //
    // ----------------------------
    if (line.startsWith('//')) {
      continue;
    } else
    // ----------------------------
    // Separatore visivo ***
    // → riga vuota logica
    // ----------------------------
    if (line == '***') {
      lines.add(SongLine(content: ''));
      continue;
    } else
    // ----------------------------
    // Riga vuota → ignorata
    // ----------------------------
    if (line.isEmpty) {
      continue;
    } else
    // ----------------------------
    // Ritornello **testo**
    // ----------------------------
    if (line.startsWith('**') && line.endsWith('**')) {
      lines.add(
        SongLine(
          content: line.substring(2, line.length - 2).trim(),
          isChorus: true,
        ),
      );
      continue;
    } else
    // ----------------------------
    // Commento *testo*
    // ----------------------------
    if (line.startsWith('*') &&
        line.endsWith('*') &&
        !line.startsWith('**')) {
      lines.add(
        SongLine(
          content: line.substring(1, line.length - 1).trim(),
          isComment: true,
        ),
      );
      continue;
    }
    // ----------------------------
    // Testo normale (con o senza accordi)
    // ----------------------------
    lines.add(
      SongLine(
        content: rawLine.trimRight(),
      ),
    );
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
