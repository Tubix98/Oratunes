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

import '../data/song_index_model.dart';
import '../data/song_index_repository.dart';
import '../data/song_local_storage.dart';

import 'song_view_page.dart';
import '../../../core/widgets/search_bar.dart';

class SongListPage extends StatefulWidget {
  const SongListPage({super.key});

  @override
  State<SongListPage> createState() => _SongListPageState();
}

class _SongListPageState extends State<SongListPage> {
  final SongIndexRepository indexRepository = SongIndexRepository(
    localStorage: SongLocalStorage(),
  );

  SongIndex? index;
  bool isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadIndex();
  }

  Future<void> _loadIndex() async {
    final loadedIndex = await indexRepository.loadIndex();

    setState(() {
      index = loadedIndex;
      isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (index == null || index!.songs.isEmpty) {
      return const Center(child: Text('Nessun canto trovato'));
    }
    // Filtra i canti in base alla query di ricerca
    final filteredSongs = index!.songs.where((entry) {
      return entry.title.toLowerCase().contains(_searchQuery) 
      /*||
          entry.section.toLowerCase().contains(_searchQuery) ||
          entry.tags.any((tag) {
            return tag.toLowerCase().contains(_searchQuery);
          })*/ ;
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
                  itemBuilder: (context, i) {
                    final song = filteredSongs[i];
                    return ListTile(
                      title: Text(song.title),
                      //subtitle: Text(song.section),
                      onTap: () {
                        //debugPrint('OPEN SONG ID: ${song.id}');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SongViewPage(songId: song.id),
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
