class Song {
  final String id;
  final String title;
  final String author;
  final String section;
  final List<String> tags;
  final String key; // tonalità originale
  final String chordpro; // testo in ChordPro


  Song({
    required this.id,
    required this.title,
    required this.author,
    required this.section,
    required this.tags,
    required this.key,
    required this.chordpro,
  });


  factory Song.fromJson(Map<String, dynamic> j) => Song(
    id: j['id'] ?? j['title'],
    title: j['title'] ?? '',
    author: j['author'] ?? '',
    section: j['section'] ?? 'Generale',
    tags: List<String>.from(j['tags'] ?? []),
    key: j['key'] ?? 'C',
    chordpro: j['chordpro'] ?? '',
  );
}