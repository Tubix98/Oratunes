import 'package:flutter/material.dart';
import '../data/song_model.dart';

/// ViewModel che gestisce lo stato della pagina di visualizzazione del canto
class SongViewModel extends ChangeNotifier {
  final Song song;

  int _transposeValue = 0;
  bool _showChords = true;

  SongViewModel({required this.song});

  int get transposeValue => _transposeValue;
  bool get showChords => _showChords;

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
}
