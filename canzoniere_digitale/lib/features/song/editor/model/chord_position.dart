import '../../domain/chord_model.dart';

class ChordPosition {
  ChordModel chord;

  /// Indice nel testo (0-based)
  int charIndex;

  ChordPosition({
    required this.chord,
    required this.charIndex,
  });
}
