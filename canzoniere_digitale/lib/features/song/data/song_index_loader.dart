import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'song_index_model.dart';

class SongIndexLoader {
  static Future<SongIndex> load() async {
    final jsonString =
        await rootBundle.loadString('assets/mock/index.json');

    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return SongIndex.fromJson(jsonMap);
  }
}
