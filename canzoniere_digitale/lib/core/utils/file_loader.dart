// Utility generica per leggere file dal bundle (assets).
// Attualmente legge l'AssetManifest.json e restituisce i percorsi.
// Usato dal song_datasource per trovare i file ChordPro.
//
// Cosa si può aggiungere:
// - Gestione di JSON/YAML/XML generici, non solo manifest.
// - Caricamento file esterni (download da internet).
// - Funzioni helper per parsing rapido (es. caricaEParsaCanto(path)).

import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

Future<List<String>> loadChordProFiles() async {
  final manifestContent = await rootBundle.loadString('AssetManifest.json');
  final Map<String, dynamic> manifestMap = await Future.value(
    Map<String, dynamic>.from(json.decode(manifestContent)),
  );

  final songPaths = manifestMap.keys
      .where(
        (key) => key.startsWith('assets/songs/') && key.endsWith('.chordpro'),
      )
      .toList();

  List<String> contents = [];
  for (final path in songPaths) {
    final content = await rootBundle.loadString(path);
    contents.add(content);
  }
  return contents;
}
