import 'editable_line.dart';

class EditableSong {
  final String title;
  final String section;
  final List<String> tags;
  final String? key;
  final List<EditableLine> lines;

  EditableSong({
    required this.title,
    required this.section,
    required this.tags,
    required this.lines,
    this.key,
  });
}
