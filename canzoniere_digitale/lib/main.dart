// Punto di ingresso dell'app Flutter.
// Qui viene inizializzato il MaterialApp con il titolo e la home page.
// Attualmente la home è gestita da MyHomePage, che usa un Drawer per navigare
// tra diverse sezioni (Tutti i canti, Indici, Playlist, Preferiti).
//
// Cosa si può aggiungere:
// - Tema personalizzato (light/dark mode).
// - Routing centralizzato con `GoRouter` o `Navigator 2.0`.
// - Integrazione con un sistema di stato globale (Provider, Riverpod, ecc.)
//   per condividere informazioni (es. preferiti) tra più schermate.

import 'package:flutter/material.dart';
import 'features/song/presentation/song_list_page.dart';

import 'features/song/application/sync_service.dart';
import 'features/song/data/song_local_storage.dart';
import 'features/song/data/song_index_remote_source.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final local = SongLocalStorage();
  final remote = SongIndexRemoteSource(
    baseUrl: 'https://raw.githubusercontent.com/Tubix98/Oratunes/dev-chord-native/songs',
  );

  final syncService = SyncService(
    local: local,
    remote: remote,
  );

  try{
    await syncService.sync();
  } catch (e, st) {
    debugPrint('SYNC FAILED: $e');
    debugPrintStack(stackTrace: st);
  }
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const appTitle = 'Canzoniere';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  // Lista di widget per le diverse pagine del Drawer.
  static const List<Widget> _widgetOptions = <Widget>[
    SongListPage(), // Tutti i canti
    Center(child: Text('Indice', style: TextStyle(fontSize: 24))),
    Center(child: Text('Le mie Playlist', style: TextStyle(fontSize: 24))),
    Center(child: Text('Preferiti', style: TextStyle(fontSize: 24))),
  ];

  // Lista di elementi del Drawer con titolo, icona e indice.
  final List<Map<String, dynamic>> _drawerItems = [
    {'title': 'Tutti i canti', 'icon': Icons.queue_music, 'index': 0},
    {'title': 'Indici tematici', 'icon': Icons.sort, 'index': 1},
    {'title': 'Le mie playlist', 'icon': Icons.playlist_play, 'index': 2},
    {'title': 'Preferiti', 'icon': Icons.favorite, 'index': 3},
  ];

  // Funzione chiamata quando un elemento del Drawer viene selezionato.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Chiude il drawer
  }

  // Costruisce il widget principale con AppBar, Drawer e il contenuto selezionato.
  // Il corpo (body) cambia in base all'indice selezionato dal Drawer.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: _widgetOptions[_selectedIndex],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Header del Drawer con titolo
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Canzoniere',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            // Lista degli elementi del Drawer
            ..._drawerItems.map(
              (item) => ListTile(
                leading: Icon(item['icon']),
                title: Text(item['title']),
                selected: _selectedIndex == item['index'],
                onTap: () => _onItemTapped(item['index']),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
