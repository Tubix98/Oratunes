// Utility generica per leggere file dal bundle (assets).
// Attualmente legge l'AssetManifest.json e restituisce i percorsi.
// Usato dal song_datasource per trovare i file ChordPro.
//
// Cosa si può aggiungere:
// - Gestione di JSON/YAML/XML generici, non solo manifest.
// - Caricamento file esterni (download da internet).
// - Funzioni helper per parsing rapido (es. caricaEParsaCanto(path)).

import 'dart:convert';
import 'package:flutter/services.dart';

Future<List<String>> loadChordProFiles() async {
  final indexJson =
      await rootBundle.loadString('assets/songs/index.json');

  final List<dynamic> files = json.decode(indexJson);

  List<String> contents = [];
  for (final file in files) {
    final content =
        await rootBundle.loadString('assets/songs/$file');
    contents.add(content);
  }

  return contents;
}