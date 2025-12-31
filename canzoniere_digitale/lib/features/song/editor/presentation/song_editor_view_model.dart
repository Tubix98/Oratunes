import 'package:flutter/material.dart';
import '../model/editable_song.dart';
import '../../data/song_model.dart';
import '../parser/chordpro_to_editable.dart';

class SongEditorViewModel extends ChangeNotifier {
  final Song originalSong;

  EditableSong? _editableSong;
  bool _isEditing = false;

  SongEditorViewModel({required this.originalSong});

  bool get isEditing => _isEditing;
  EditableSong? get editableSong => _editableSong;

  void enterEditMode() {
    _editableSong = parseChordProToEditable(originalSong.rawContent);
    _isEditing = true;
    notifyListeners();
  }

  void exitEditMode() {
    _editableSong = null;
    _isEditing = false;
    notifyListeners();
  }
}
