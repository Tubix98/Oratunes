class ChordModel {
  final int semitoneValue;
  final String? suffix;
  final int? bassSemitone;

  ChordModel({required this.semitoneValue, this.suffix, this.bassSemitone});
}

class ChordPosition {
  final ChordModel chord;
  final int position;

  ChordPosition({
    required this.chord, 
    required this.position,
  });
}