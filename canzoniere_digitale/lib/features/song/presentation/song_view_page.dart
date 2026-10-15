import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

import '../data/song_local_storage.dart';
import '../data/song_repository.dart';
import '../domain/song_model.dart';
import '../../../core/widgets/lyrics_renderer_wrapper.dart';
import '../../../core/layout/lyrics_layout.dart';
import '../../../core/layout/font_size_level.dart';
import 'song_view_model.dart';
import '../editor/presentation/song_editor_view_model.dart';

/// Pagina principale che mostra il canto con accordi, testo e controlli
class SongViewPage extends StatelessWidget {
  final String songId;

  const SongViewPage({super.key, required this.songId});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SongViewModel(song: song),
        ),
        ChangeNotifierProvider(
          create: (_) => SongEditorViewModel(originalSong: song),
        ),
      ],
      child: const _SongViewScaffold(),
  );
  }
}

class _SongViewScaffold extends StatelessWidget {
  const _SongViewScaffold();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SongViewModel>();
    final editor = context.watch<SongEditorViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(viewModel.song.title),
        actions: [
          IconButton(
            icon: Icon(editor.isEditing ? Icons.check : Icons.edit),
            tooltip: editor.isEditing ? 'Esci da modifica' : 'Modifica',
            onPressed: () {
              if (editor.isEditing) {
                editor.exitEditMode();
              } else {
                editor.enterEditMode();
              }
            },
          ),
        ],
      ),
      body: editor.isEditing
          ? _EditableSongBody()
          : _ReadOnlySongBody(),
      floatingActionButton: editor.isEditing
          ? null // niente SpeedDial in edit (per ora)
          : _SongSpeedDial(),
=======
    final repository = SongRepository(
      localStorage: SongLocalStorage(),
    );

    return FutureBuilder<Song?>(
      future: repository.loadSong(songId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Scaffold(
            body: Center(child: Text('Canto non trovato')),
          );
        }

        final song = snapshot.data!;

        return ChangeNotifierProvider(
          create: (_) => SongViewModel(song: song),
          child: const _SongViewContent(),
        );
      },
>>>>>>> e19607676500f21d80a6835bae87bcd3e7446df9
    );
  }
}

<<<<<<< HEAD
class _ReadOnlySongBody extends StatelessWidget {
=======
class _SongViewContent extends StatelessWidget {
  const _SongViewContent();

>>>>>>> e19607676500f21d80a6835bae87bcd3e7446df9
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SongViewModel>();

<<<<<<< HEAD
    return InteractiveViewer(
      panEnabled: true,
      boundaryMargin: const EdgeInsets.all(20),
      minScale: 0.5,
      child: SingleChildScrollView(
=======
    // 🔹 larghezza schermo (phone / tablet / desktop)
    final screenWidth = MediaQuery.of(context).size.width;

    // 🔹 calcolo scala font
    final fontScale = LyricsLayout.fontScaleForLevel(
      level: viewModel.fontSizeLevel,
      screenWidth: screenWidth,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(viewModel.song.title),
      ),
      body: SingleChildScrollView(
>>>>>>> e19607676500f21d80a6835bae87bcd3e7446df9
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: LyricsRendererWrapper(
            song: viewModel.song,
            transpose: viewModel.transposeValue,
            showChords: viewModel.showChords,
<<<<<<< HEAD
          ),
        ),
=======
            fontScale: fontScale, 
          ),
        ),
      ),
      floatingActionButton: SpeedDial(

        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        closeManually: true,
        renderOverlay: true,
        overlayOpacity: 0.5,

        children: [
          SpeedDialChild(
            child: const Icon(Icons.add),
            label: 'Aumenta tonalità',
            onTap: viewModel.increaseTranspose,
          ),
          SpeedDialChild(
            child: const Icon(Icons.remove),
            label: 'Diminuisci tonalità',
            onTap: viewModel.decreaseTranspose,
          ),
          SpeedDialChild(
            child: Icon(
              viewModel.showChords
                  ? Icons.visibility
                  : Icons.visibility_off,
            ),
            label: viewModel.showChords
                ? 'Nascondi accordi'
                : 'Mostra accordi',
            onTap: viewModel.toggleChords,
          ),
          SpeedDialChild(
            child: Center(
              child: Text(
                'A',
                style: TextStyle(
                  fontSize: fontIndicatorSize(viewModel.fontSizeLevel),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            label: 'Cambia dimensione testo',
            onTap: viewModel.cycleFontSize,
          ),
        ],
>>>>>>> e19607676500f21d80a6835bae87bcd3e7446df9
      ),
    );
  }
}

<<<<<<< HEAD
class _EditableSongBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final editor = context.watch<SongEditorViewModel>();
    final editableSong = editor.editableSong!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: editableSong.lines.map((line) {
          if (line.isComment) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                line.text,
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text(line.text),
          );
        }).toList(),
      ),
    );
  }
}

class _SongSpeedDial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SongViewModel>();

    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      children: [
        SpeedDialChild(
          child: const Icon(Icons.add),
          label: 'Aumenta tonalità',
          onTap: viewModel.increaseTranspose,
        ),
        SpeedDialChild(
          child: const Icon(Icons.remove),
          label: 'Diminuisci tonalità',
          onTap: viewModel.decreaseTranspose,
        ),
        SpeedDialChild(
          child: Icon(
            viewModel.showChords
                ? Icons.visibility
                : Icons.visibility_off,
          ),
          label: viewModel.showChords
              ? 'Nascondi accordi'
              : 'Mostra accordi',
          onTap: viewModel.toggleChords,
        ),
      ],
    );
  }
}

=======
>>>>>>> e19607676500f21d80a6835bae87bcd3e7446df9
