import 'dart:convert';

import 'song_local_storage.dart';
import 'song_index_model.dart';

class SongIndexRepository {
  final SongLocalStorage localStorage;

  SongIndexRepository({required this.localStorage});

  Future<SongIndex?> loadIndex() async {
    final jsonString = await localStorage.readIndex();

    // Caso: primo avvio, sync non ancora fatta
    if (jsonString == null) return null;

    final Map<String, dynamic> jsonMap =
        jsonDecode(jsonString) as Map<String, dynamic>;

    return SongIndex.fromJson(jsonMap);
  }
}
