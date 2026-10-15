import 'dart:convert';
import 'package:http/http.dart' as http;
import 'song_index_model.dart';

class SongIndexRemoteSource {
  final String baseUrl;

  SongIndexRemoteSource({required this.baseUrl});

  Future<SongIndex> loadIndex() async {
    final url = Uri.parse('$baseUrl/index.json');

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception(
        'Errore caricamento index.json (${response.statusCode})',
      );
    }

    final Map<String, dynamic> jsonMap = json.decode(response.body);
    return SongIndex.fromJson(jsonMap);
  }

  Future<String> loadSong(String songId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$songId.md'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load song $songId');
    }

    return response.body;
  }
}
