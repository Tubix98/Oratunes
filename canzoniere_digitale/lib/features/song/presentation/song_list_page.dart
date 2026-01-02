// Pagina che mostra la lista di tutti i canti disponibili.
// Carica i dati tramite il repository, ordina i titoli e visualizza un elenco.
// Al tap su un elemento apre la SongViewPage con il canto selezionato.
//
// Cosa si può aggiungere:
// - Barra di ricerca in tempo reale.
// - Raggruppamento alfabetico (A, B, C…).
// - Lazy loading se i canti sono tanti.
// - Pulsante "aggiungi a preferiti" direttamente dalla lista.

import 'package:flutter/material.dart';

import '../data/song_local_storage.dart';
import '../data/song_repository.dart';
import '../data/song_index_loader.dart';
import '../domain/song_model.dart';

import 'song_view_page.dart';
import '../../../core/widgets/search_bar.dart';

class SongListPage extends StatefulWidget {
  const SongListPage({super.key});

  @override
  State<SongListPage> createState() => _SongListPageState();
}

class _SongListPageState extends State<SongListPage> {
  late final SongRepository repository;

  List<Song> songs = [];
  bool isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    repository = SongRepository(
      localStorage: SongLocalStorage(),
    );
    _loadSongs();
    _testIndex();
  }

  Future<void> _testIndex() async {
    final index = await SongIndexLoader.load();
    for (final song in index.songs) {
      debugPrint('Song: ${song.file} (${song.hash})');
    }
  }

  Future<void> _loadSongs() async {
    final loadedSongs = await repository.loadSongs();

    setState(() {
      songs = loadedSongs;
      isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (songs.isEmpty) return const Center(child: Text('Nessun canto trovato'));

    // Filtra i canti in base alla query di ricerca
    final filteredSongs = songs.where((song) {
      return song.title.toLowerCase().contains(_searchQuery) ||
          song.section.toLowerCase().contains(_searchQuery) ||
          song.tags.any((tag) {
            return tag.toLowerCase().contains(_searchQuery);
          });
    }).toList();

    return Column(
      children: [
        SearchBarWidget(
          hintText: 'Cerca ...',
          onChanged: (query) {
            setState(() {
              _searchQuery = query.toLowerCase();
            });
          },
        ),
        Expanded(
          child: filteredSongs.isEmpty
              ? const Center(
                  child: Text('Nessun canto trovato per questa ricerca'),
                )
              : ListView.builder(
                  itemCount: filteredSongs.length,
                  itemBuilder: (context, index) {
                    final song = filteredSongs[index];
                    return ListTile(
                      title: Text(song.title),
                      //subtitle: Text(song.section),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SongViewPage(song: song),
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}
