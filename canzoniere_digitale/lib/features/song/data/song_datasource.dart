// Data source per caricare i file ChordPro dall'app (assets).
// Usa rootBundle per leggere il manifest e filtrare i file .chordpro.
// Restituisce l'elenco dei contenuti grezzi dei file.
//
// Cosa si può aggiungere:
// - Supporto a sorgenti multiple (locale, remoto, API).
// - Cache dei file letti per non ricaricarli ogni volta.
// - Conversione immediata in Song tramite il parser (per risparmiare passaggi).

import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class SongDataSource {
  Future<List<String>> loadFiles() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final paths = manifestMap.keys
        .where(
          (key) => key.startsWith('assets/songs/') && key.endsWith('.chordpro'),
        )
        .toList();

    List<String> contents = [];
    for (var path in paths) {
      final content = await rootBundle.loadString(path);
      contents.add(content);
    }
    return contents;
  }
}
