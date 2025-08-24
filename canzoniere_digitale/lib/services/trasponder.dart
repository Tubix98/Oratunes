// Funzioni per trasporre un singolo accordo e intere linee

final _chromaticSharps = [
  'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'
];


final _enharmonic = {
  'Db': 'C#', 'Eb': 'D#', 'Gb': 'F#', 'Ab': 'G#', 'Bb': 'A#'
};


String _normalizeRoot(String r) {
  if (_enharmonic.containsKey(r)) return _enharmonic[r]!;
  return r;
}


String transposeChord(String chord, int semitones) {
  // separa la radice dal resto (es. "Am7" -> "A" + "m7")
  final m = RegExp(r'^([A-G][b#]?)(.*)\$').firstMatch(chord);
  if (m == null) return chord; // non riconosciuto
  final root = _normalizeRoot(m.group(1)!);
  final suffix = m.group(2)!;
  final idx = _chromaticSharps.indexOf(root);
  if (idx == -1) return chord;
  final newIdx = (idx + semitones) % 12;
  final adjusted = newIdx < 0 ? newIdx + 12 : newIdx;
  final newRoot = _chromaticSharps[adjusted];
  return '$newRoot$suffix';
}


String transposeChordProLine(String line, int semitones) {
  // cerca tutti gli accordi nel formato [C] ...
  return line.replaceAllMapped(RegExp(r'\[([^\]]+)\]'), (m) {
    final chord = m.group(1)!;
    final t = transposeChord(chord, semitones);
    return '[\$t]';
  });
}