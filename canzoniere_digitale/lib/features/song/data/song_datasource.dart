// Data source per caricare i file ChordPro dall'app (assets).
// Usa rootBundle per leggere il manifest e filtrare i file .chordpro.
// Restituisce l'elenco dei contenuti grezzi dei file.
//
// Cosa si può aggiungere:
// - Supporto a sorgenti multiple (locale, remoto, API).
// - Cache dei file letti per non ricaricarli ogni volta.
// - Conversione immediata in Song tramite il parser (per risparmiare passaggi).

import 'package:flutter/services.dart' show AssetManifest, rootBundle;

class SongDataSource {
  Future<List<String>> loadFiles() async {
    // Carica il manifest degli asset
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);

    // Ottieni la lista di tutti gli asset
    final assetPaths = manifest.listAssets();

    // Filtra i file con estensione .chordpro nella cartella assets/songs/
    final chordProPaths = assetPaths.where(
      (path) => 
        path.startsWith('assets/songs/') && 
        path.endsWith('.md'), 
    );

    
    final contents = <String>[];
    // Carica il contenuto di ciascun file
    for (final path in chordProPaths) {
      final content = await rootBundle.loadString(path);
      contents.add(content);
    }

    return contents;
  }
}
