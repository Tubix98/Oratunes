import 'package:flutter/cupertino.dart';

import '../data/song_local_storage.dart';
import '../data/song_index_remote_source.dart';

class SyncService {
  final SongIndexRemoteSource remote;
  final SongLocalStorage local;

  SyncService({
    required this.remote,
    required this.local,
  });

  Future<void> sync() async {
    try {
      await _performSync();
    } catch (e) {
      debugPrint('Sync error: $e');
    }

  }

  Future<void> _performSync() async {
    // 1. scarica index remoto
    final index = await remote.loadIndex();

    // 2. salva index in locale
    await local.saveIndex(index.toJsonString());

    // 3. scarica tutti i canti
    for (final entry in index.songs) {
      final content = await remote.loadSong(entry.id);
      await local.saveSong('${entry.id}.md', content);
    }
  }
}
