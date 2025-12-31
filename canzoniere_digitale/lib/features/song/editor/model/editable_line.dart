import 'chord_position.dart';

class EditableLine {
  String text;

  /// Accordi posizionati rispetto al testo
  List<ChordPosition> chords;

  /// Es: {c:RIT.}
  final bool isComment;

  EditableLine({
    required this.text,
    this.chords = const [],
    this.isComment = false,
  });
}
