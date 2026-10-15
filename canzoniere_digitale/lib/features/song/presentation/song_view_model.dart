import 'package:canzoniere/core/persistence/font_size_storage.dart';
import 'package:flutter/material.dart';
import '../domain/song_model.dart';
import '../../../core/layout/font_size_level.dart';

/// ViewModel che gestisce lo stato della pagina di visualizzazione del canto
class SongViewModel extends ChangeNotifier {
  final Song song;

  // Stato privato
  int _transposeValue = 0;
  bool _showChords = true;

  FontSizeLevel _fontSizeLevel = FontSizeLevel.medium;

  // Costruttore
  SongViewModel({required this.song}){
    _loadFontSize();
  }

  // Getters
  int get transposeValue => _transposeValue;
  bool get showChords => _showChords;
  FontSizeLevel get fontSizeLevel => _fontSizeLevel;

  // Metodi

  void increaseTranspose() {
    _transposeValue++;
    notifyListeners();
  }

  void decreaseTranspose() {
    _transposeValue--;
    notifyListeners();
  }

  void toggleChords() {
    _showChords = !_showChords;
    notifyListeners();
  }

  void setFontSizeLevel(FontSizeLevel level) {
    if (_fontSizeLevel == level) return;
    _fontSizeLevel = level;
    notifyListeners();
  }

  void cycleFontSize() {
    switch (_fontSizeLevel) {
      case FontSizeLevel.small:
        _fontSizeLevel = FontSizeLevel.medium;
      case FontSizeLevel.medium:
        _fontSizeLevel = FontSizeLevel.large;
      case FontSizeLevel.large:
        _fontSizeLevel = FontSizeLevel.small;
    }

    FontSizeStorage.save(_fontSizeLevel);
    notifyListeners();
  }

  Future<void> _loadFontSize() async {
    final saved = await FontSizeStorage.load();
    _fontSizeLevel = saved;
    notifyListeners();
  }


}
