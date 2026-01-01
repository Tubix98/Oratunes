import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

import '../domain/song_model.dart';
import '../../../core/widgets/lyrics_renderer_wrapper.dart';
import '../../../core/layout/lyrics_layout.dart';
import '../../../core/layout/font_size_level.dart';
import 'song_view_model.dart';

/// Pagina principale che mostra il canto con accordi, testo e controlli
class SongViewPage extends StatelessWidget {
  final Song song;

  const SongViewPage({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SongViewModel(song: song),
      child: const _SongViewContent(),
    );
  }
}

class _SongViewContent extends StatelessWidget {
  const _SongViewContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SongViewModel>();

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
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: LyricsRendererWrapper(
            song: viewModel.song,
            transpose: viewModel.transposeValue,
            showChords: viewModel.showChords,
            fontScale: fontScale, 
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
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
      ),
    );
  }
}

