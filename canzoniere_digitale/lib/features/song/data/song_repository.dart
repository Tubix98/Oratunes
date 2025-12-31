// Repository che fa da "ponte" tra data source e dominio.
// Si occupa di caricare i file ChordPro dal data source
// e di convertirli in modelli Song tramite il parser.
//
// Cosa si può aggiungere:
// - Filtri (per sezione, per tag, per autore).
// - Metodi per cercare un canto specifico per titolo o ID.
// - Eventuale gestione di preferiti/playlist (anche se potrebbe andare in domain).

import '../domain/song_model.dart';
import 'song_datasource.dart';
import '../domain/parse_chordpro.dart';

class SongRepository {
  final SongDataSource dataSource;
  SongRepository({required this.dataSource});

  Future<List<Song>> getAllSongs() async {
    final files = await dataSource.loadFiles();
    return files.map(parseChordPro).toList();
  }
}
