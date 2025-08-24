import 'package:flutter/material.dart';
import '../repositories/song_repository.dart';
import '../models/song.dart';
import 'song_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final String flavor;
  const HomeScreen({super.key, required this.flavor});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final repo = SongRepository();
  List<Song> songs = [];
  List<Song> filtered = [];
  String query = '';

  @override
  void initState() {
    super.initState();
    repo.loadAll().then((v) {
      setState(() {
        songs = v;
        filtered = v;
      });
    });
  }

  void _search(String q) {
    setState(() {
      query = q;
      filtered =
          songs
              .where(
                (s) =>
                    s.title.toLowerCase().contains(q.toLowerCase()) ||
                    s.chordpro.toLowerCase().contains(q.toLowerCase()),
              )
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Oratunes'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text(widget.flavor)),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Cerca per titolo o testo',
              ),
              onChanged: _search,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, idx) {
                final s = filtered[idx];
                return ListTile(
                  title: Text(s.title),
                  subtitle: Text('${s.author} • ${s.section}'),
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SongDetailScreen(songId: s.id),
                        ),
                      ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
