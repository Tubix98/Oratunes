// Contiene la logica di business sui canti.
// Usa il repository per ottenere i dati e applica logiche di alto livello,
// come la ricerca, il filtraggio o l'ordinamento.
//
// Cosa si può aggiungere:
// - Ricerca full-text nei testi.
// - Filtri per sezione, per tag, per accordo.
// - Metodi per creare indici tematici dinamici.

import '../data/song_model.dart';

class SongService {
  List<Song> search(List<Song> songs, String query) {
    return songs
        .where((s) => s.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
