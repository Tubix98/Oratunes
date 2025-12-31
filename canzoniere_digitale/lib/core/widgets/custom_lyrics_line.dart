import 'package:flutter/material.dart';
import '../../features/song/domain/song_model.dart';
import '../utils/chord_transposer.dart';

/// Widget "lavoratore" che renderizza una singola riga di testo e accordi.
/// Contiene tutta la logica di parsing, conversione, trasposizione e formattazione.
class CustomLyricsLine extends StatelessWidget {
  final SongLine line;
  final int transposeIncrement;
  final bool showChords;

  const CustomLyricsLine({
    super.key,
    required this.line,
    required this.transposeIncrement,
    required this.showChords,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(
      fontSize: 18,
      fontWeight: line.isChorus ? FontWeight.bold : FontWeight.normal,
      color: Colors.black87,
      height: 1.5,
    );
    const chordStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.indigo,
      height: 1.2,
    );

    // Se la riga è un commento, la formatta in modo speciale
    if (line.isComment) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Text(
          line.content,
          style: const TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.black54,
            fontSize: 16.0,
          ),
        ),
      );
    }

    if (!showChords) {
      final textOnly = line.content.replaceAll(RegExp(r'\[[^\]]+\]'), '');
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(textOnly, style: textStyle),
      );
    }

    // RegExp per trovare [Accordo]Testo o solo Testo
    final regex = RegExp(r'(\[[^\]]+\])?([^\[\]]*)');
    final matches = regex.allMatches(line.content);

    List<Widget> segments = [];

    for (final match in matches) {
      String? chord = match.group(1); // Es: "[DO]"
      String? text = match.group(2); // Es: "notti"

      if ((chord == null || chord.isEmpty) && (text == null || text.isEmpty)) {
        continue;
      }

      Widget segmentWidget;

      if (chord != null) {
        // --- SE ABBIAMO SIA ACCORDO CHE TESTO ---
        String originalChord = chord.substring(
          1,
          chord.length - 1,
        ); // Rimuove le parentesi quadre
        final chordModel = parseChord(originalChord);

        String displayText = originalChord;
        if (chordModel != null) {
          final transposedModel = transposeModel(
            chordModel,
            transposeIncrement,
          );
          displayText = formatChord(
            transposedModel,
            style: NotationStyle.latin,
          );
        }

        // Creiamo il nostro "blocco" Accordo+Testo
        segmentWidget = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                right: 4.0,
              ), // Padding per distanziare gli accordi vicini
              child: Text(displayText, style: chordStyle),
            ),
            Text(text!, style: textStyle),
          ],
        );
      } else {
        // --- SE ABBIAMO SOLO TESTO ---
        segmentWidget = Padding(
          // Aggiungiamo un padding sopra per allineare il testo con gli altri
          // che hanno l'accordo. L'altezza del font dell'accordo è circa 16*1.2 = 19.2
          padding: const EdgeInsets.only(top: 19.2),
          child: Text(text!, style: textStyle),
        );
      }
      segments.add(segmentWidget);
    }

    // Usiamo Wrap per disporre i nostri segmenti
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Wrap(
        crossAxisAlignment:
            WrapCrossAlignment.end, // Allinea le baseline del testo
        children: segments,
      ),
    );
  }
}
