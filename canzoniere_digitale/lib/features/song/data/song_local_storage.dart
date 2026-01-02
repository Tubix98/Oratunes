import 'dart:io';
import 'package:path_provider/path_provider.dart';

class SongLocalStorage {
  static const _songsDirName = 'songs';

  Future<Directory> get _songsDir async {
    final baseDir = await getApplicationDocumentsDirectory();
    final dir = Directory('${baseDir.path}/$_songsDirName');

    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    return dir;
  }

  // ---------------- INDEX ----------------

  Future<bool> hasIndex() async {
    final dir = await _songsDir;
    return File('${dir.path}/index.json').exists();
  }

  Future<String?> readIndex() async {
    final dir = await _songsDir;
    final file = File('${dir.path}/index.json');

    if (!await file.exists()) return null;
    return file.readAsString();
  }

  Future<void> saveIndex(String json) async {
    final dir = await _songsDir;
    final file = File('${dir.path}/index.json');
    await file.writeAsString(json);
  }

  // ---------------- SONGS ----------------

  Future<List<String>> listSongFiles() async {
    final dir = await _songsDir;

    return dir
    .listSync()
    .whereType<File>()
    .where((f) => f.path.endsWith('.md'))
    .map((f) => f.uri.pathSegments.last)
    .toList();
  }

  Future<String?> readSong(String filename) async {
    final dir = await _songsDir;
    final file = File('${dir.path}/$filename');

    if (!await file.exists()) return null;
    return file.readAsString();
  }

  Future<void> saveSong(String filename, String content) async {
    final dir = await _songsDir;
    final file = File('${dir.path}/$filename');
    await file.writeAsString(content);
  }

}
