import '../domain/song_model.dart';
import '../domain/parser.dart';
import 'song_local_storage.dart';

class SongRepository {
  final SongLocalStorage localStorage;

  SongRepository({required this.localStorage});

  /// Carica TUTTI i canti disponibili in locale
  Future<List<Song>> loadSongs() async {
    final files = await localStorage.listSongFiles();

    final List<Song> songs = [];

    for (final filename in files) {
      final content = await localStorage.readSong(filename);
      if (content == null) continue;

      final song = parseMarkdownSong(content);
      songs.add(song);
    }

    songs.sort(
      (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
    );

    return songs;
  }
}