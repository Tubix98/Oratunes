import '../../features/song/domain/chord_model.dart';

/// =============================================================
/// DIZIONARI DI BASE
/// =============================================================

const Map<String, int> _noteToSemitone = {
  // Latina
  'Do': 0, 'Do#': 1, 'Reb': 1,
  'Re': 2, 'Re#': 3, 'Mib': 3,
  'Mi': 4,
  'Fa': 5, 'Mi#': 5, 'Fa#': 6, 'Solb': 6,
  'Sol': 7, 'Sol#': 8, 'Lab': 8,
  'La': 9, 'La#': 10, 'Sib': 10,
  'Si': 11, 'Dob': 11,

  // Inglese
  'C': 0, 'C#': 1, 'Db': 1,
  'D': 2, 'D#': 3, 'Eb': 3,
  'E': 4,
  'F': 5, 'E#': 5, 'F#': 6, 'Gb': 6,
  'G': 7, 'G#': 8, 'Ab': 8,
  'A': 9, 'A#': 10, 'Bb': 10,
  'B': 11, 'Cb': 11,
};

/// Scale di riferimento
const List<String> latinSharpScale = [
  'Do',
  'Do#',
  'Re',
  'Re#',
  'Mi',
  'Fa',
  'Fa#',
  'Sol',
  'Sol#',
  'La',
  'La#',
  'Si',
];

const List<String> latinFlatScale = [
  'Do',
  'Reb',
  'Re',
  'Mib',
  'Mi',
  'Fa',
  'Solb',
  'Sol',
  'Lab',
  'La',
  'Sib',
  'Si',
];

const List<String> englishSharpScale = [
  'C',
  'C#',
  'D',
  'D#',
  'E',
  'F',
  'F#',
  'G',
  'G#',
  'A',
  'A#',
  'B',
];

const List<String> englishFlatScale = [
  'C',
  'Db',
  'D',
  'Eb',
  'E',
  'F',
  'Gb',
  'G',
  'Ab',
  'A',
  'Bb',
  'B',
];

/// =============================================================
/// SCALE PREFERITE (CONFIGURABILI DA APP)
/// =============================================================
/// Queste sono quelle che verranno usate in output.
/// In futuro puoi permettere all’utente di cambiarle da un menu impostazioni.
List<String> preferredLatinScale = [
  'Do',
  'Do#',
  'Re',
  'Re#',
  'Mi',
  'Fa',
  'Fa#',
  'Sol',
  'Sol#',
  'La',
  'Sib',
  'Si',
];

List<String> preferredEnglishScale = englishSharpScale;

/// =============================================================
/// ENUM
/// =============================================================
enum NotationStyle { latin, english }

/// =============================================================
/// FUNZIONE DI PARSING
/// =============================================================
/// Converte una stringa tipo "Re/Fa#" o "Do#m7" in un [ChordModel].
ChordModel? parseChord(String chord) {
  // Supporta accordi con basso, es: "Re/Fa#"
  final parts = chord.split('/');
  final mainPart = parts[0];
  final bassPart = parts.length > 1 ? parts[1] : null;

  final regex = RegExp(
    r'^(Do|Re|Mi|Fa|Sol|La|Si|[A-G])([#b]?)(.*)$',
    caseSensitive: false,
  );
  final match = regex.firstMatch(mainPart);

  if (match == null) return null;

  final root = (match.group(1)! + (match.group(2) ?? '')).toLowerCase();
  final suffix = match.group(3);

  final rootSemitone = _noteToSemitone[_normalize(root)];
  if (rootSemitone == null) return null;

  int? bassSemitone;
  if (bassPart != null) {
    bassSemitone = _noteToSemitone[_normalize(bassPart)];
  }

  return ChordModel(
    semitoneValue: rootSemitone,
    suffix: suffix?.isEmpty ?? true ? null : suffix,
    bassSemitone: bassSemitone,
  );
}

/// Normalizza le note (es. "do#" → "Do#")
String _normalize(String input) {
  if (input.isEmpty) return input;
  final lower = input.toLowerCase();

  // Prima lettera maiuscola, resto minuscolo, tranne accidental
  if (lower.length > 1 && (lower.endsWith('#') || lower.endsWith('b'))) {
    return '${lower[0].toUpperCase()}${lower.substring(1, lower.length - 1)}${lower[lower.length - 1]}';
  }
  return lower[0].toUpperCase() + lower.substring(1);
}

/// =============================================================
/// FUNZIONE DI TRASPOSIZIONE
/// =============================================================
ChordModel transposeModel(ChordModel model, int semitones) {
  if (semitones == 0) return model;

  return ChordModel(
    semitoneValue: (model.semitoneValue + semitones + 12) % 12,
    suffix: model.suffix,
    bassSemitone: model.bassSemitone != null
        ? (model.bassSemitone! + semitones + 12) % 12
        : null,
  );
}

/// =============================================================
/// FUNZIONE DI FORMATTAZIONE
/// =============================================================
String formatChord(
  ChordModel model, {
  NotationStyle style = NotationStyle.latin,
}) {
  final scale = style == NotationStyle.latin
      ? preferredLatinScale
      : preferredEnglishScale;

  String rootNote = scale[model.semitoneValue];
  String result = rootNote + (model.suffix ?? '');

  if (model.bassSemitone != null) {
    final bassNote = scale[model.bassSemitone!];
    result += '/$bassNote';
  }

  return result;
}
