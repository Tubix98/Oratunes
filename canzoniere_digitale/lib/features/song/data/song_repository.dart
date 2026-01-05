import '../domain/song_model.dart';
import '../domain/parser.dart';
import 'song_local_storage.dart';

const bool useAssets = true;

class SongRepository {
  final SongLocalStorage localStorage;

  SongRepository({required this.localStorage});

  /// Carica UN canto dagli assets (TEMP)
  Future<Song?> loadSong(String songId) async {
    final filename = '$songId.md';

    final content = await localStorage.readSong(filename);
    if (content == null) return null;

    return parseMarkdownSong(content);
  }
}