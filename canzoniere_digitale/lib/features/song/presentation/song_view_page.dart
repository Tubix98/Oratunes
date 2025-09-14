import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import '../data/song_model.dart';
import '../../../core/widgets/lyrics_renderer_wrapper.dart';
import 'song_view_model.dart';

/// Pagina principale che mostra il canto con accordi, testo e controlli
class SongViewPage extends StatelessWidget {
  final Song song;

  const SongViewPage({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SongViewModel(song: song),
      child: Consumer<SongViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            appBar: AppBar(title: Text(viewModel.song.title)),
            body: InteractiveViewer(
              panEnabled: true,
              boundaryMargin: EdgeInsets.all(20),
              minScale: 0.5,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: LyricsRendererWrapper(
                    song: viewModel.song,
                    transpose: viewModel.transposeValue,
                    showChords: viewModel.showChords,
                  ),
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
              ],
            ),
          );
        },
      ),
    );
  }
}
