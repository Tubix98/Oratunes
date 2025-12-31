// Definisce i modelli di dominio usati in tutta l'app.
// Song: rappresenta un canto completo, con titolo, sezione, tags e linee.
// SongLine: rappresenta una singola riga del canto, con flag per coro/commenti.
//
// Cosa si può aggiungere:
// - Campi aggiuntivi: autore, tonalità, tempo, numero di canto.
// - Metodo toJson/fromJson per eventuale salvataggio su database o export.
// - Estensioni per funzioni utili, es. trasposizione accordi.
import 'package:canzoniere/features/song/domain/chord_model.dart';

class Song {
  final String title;
  final String section;
  final String author;
  final ChordModel? key;
  final List<String> tags;
  final List<SongLine> lines;

  Song({
    required this.title,
    required this.section,
    this.author = '',
    this.key,
    required this.tags,
    required this.lines,
  });
}

class SongLine {
  final String content;
  final List<ChordPosition> chords;
  final bool isChorus;
  final bool isComment;

  SongLine({
    required this.content,
    this.chords = const [],
    this.isChorus = false,
    this.isComment = false,
  });
}
