import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/song.dart';


class SongRepository {
  List<Song>? _cache;

  Future<List<Song>> loadAll() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString('assets/songs.json');
    final arr = json.decode(raw) as List<dynamic>;
    _cache = arr.map((e) => Song.fromJson(e)).toList();
    return _cache!;
  }


  Future<Song?> findById(String id) async {
    final list = await loadAll();
    try {
      return list.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }
}