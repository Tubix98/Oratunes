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
}

class SongIndexEntry {
  final String file;
  final String hash;
  final String title;

  SongIndexEntry({
    required this.file,
    required this.hash,
    required this.title,
  });

  factory SongIndexEntry.fromJson(Map<String, dynamic> json) {
    return SongIndexEntry(
      file: json['file'],
      hash: json['hash'],
      title: json['title'],
    );
  }
}
