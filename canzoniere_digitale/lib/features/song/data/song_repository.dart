import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import '../domain/song_model.dart';
import '../domain/parser.dart';
import 'song_local_storage.dart';

class SongRepository {
  final SongLocalStorage localStorage;

  SongRepository({required this.localStorage});

  /// Carica UN canto dagli assets (TEMP)
  Future<Song?> loadSong(String songId) async {
  final path = 'assets/mock/$songId.md';
  debugPrint('TRY LOAD SONG: $path');

  try {
    final content = await rootBundle.loadString(path);
    debugPrint('SONG LOADED OK');
    return parseMarkdownSong(content);
  } catch (e) {
    debugPrint('LOAD ERROR: $e');
    return null;
  }
}
  /// Carica UN canto dato il songId
  /*Future<Song?> loadSong(String songId) async {
    final filename = '$songId.md';

    final content = await localStorage.readSong(filename);
    if (content == null) return null;

    return parseMarkdownSong(content);
  }*/
}