import 'dart:convert';
import 'package:flutter/services.dart';
import 'song_index_model.dart';

class SongIndexRepository {
  const SongIndexRepository();

  Future<SongIndex> loadIndex() async {
    final jsonString = await rootBundle.loadString(
      'assets/mock/index.json',
    );

    final Map<String, dynamic> jsonMap =
        json.decode(jsonString) as Map<String, dynamic>;

    return SongIndex.fromJson(jsonMap);
  }
}
