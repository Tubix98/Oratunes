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
import '../../../core/utils/chord_transposer.dart';

SongLine parseLineWithChords(
  String rawLine, {
    bool isChorus = false,
    bool isComment = false,
  }) {
  final chordRegex = RegExp(r'\[([^\]]+)\]');
  final matches = chordRegex.allMatches(rawLine);

  final buffer = StringBuffer();
  final chords = <ChordPosition>[];

  int lastIndex = 0;
  int textIndex = 0;

  for (final match in matches) {
    // testo prima dell'accordo
    final before = rawLine.substring(lastIndex, match.start);
    buffer.write(before);
    textIndex += before.length;

    // accordo
    final chordText = match.group(1)!;
    final chordModel = parseChord(chordText);

    if (chordModel != null) {
      chords.add(
        ChordPosition(
          chord: chordModel,
          position: textIndex,
        ),
      );
    }

    lastIndex = match.end;
  }

  // testo dopo l’ultimo accordo
  final after = rawLine.substring(lastIndex);
  buffer.write(after);

  return SongLine(
    content: buffer.toString(),
    chords: chords,
    isChorus: isChorus,
    isComment: isComment,
  );
}

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
      lines.add(
        SongLine(
          content: '',
          chords: const [],
          ),
      );
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
        parseLineWithChords(
          line.substring(2, line.length - 2).trim(),
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
        parseLineWithChords(
          line.substring(1, line.length - 1).trim(),
          isComment: true,
        ),
      );
      continue;
    }
    // ----------------------------
    // Testo normale (con o senza accordi)
    // ----------------------------
    lines.add(
      parseLineWithChords(
        rawLine.trimRight(),
        isChorus: false,
        isComment: false,
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
