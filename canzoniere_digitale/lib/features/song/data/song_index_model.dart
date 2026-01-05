import 'dart:convert';

class SongIndex {
  final int version;
  final DateTime generatedAt;
  final List<SongIndexEntry> songs;

  SongIndex({
    required this.version,
    required this.generatedAt,
    required this.songs,
  });

  factory SongIndex.fromJson(Map<String, dynamic> json) {
    return SongIndex(
      version: json['version'] as int,
      generatedAt: DateTime.parse(json['generatedAt']),
      songs: (json['songs'] as List)
          .map((e) => SongIndexEntry.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'generatedAt': generatedAt.toIso8601String(),
      'songs': songs.map((e) => e.toJson()).toList(),
    };
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }
}

class SongIndexEntry {
  final String id;
  final String hash;
  final String title;

  SongIndexEntry({
    required this.id,
    required this.hash,
    required this.title,
  });

  factory SongIndexEntry.fromJson(Map<String, dynamic> json) {
    return SongIndexEntry(
      id: json['id'],
      hash: json['hash'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'hash': hash,
    };
  }
}
