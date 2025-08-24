import 'package:canzoniere_digitale/services/trasponder.dart';
import 'package:flutter/material.dart';

class ChordViewer extends StatelessWidget {
  final String chordpro;
  final int transpose; // semitoni da applicare
  final bool showChords;
  final double fontSize;


  const ChordViewer({
  super.key,
  required this.chordpro,
  this.transpose = 0,
  this.showChords = true,
  this.fontSize = 18,
  });


  @override
  Widget build(BuildContext context) {
    final lines = chordpro.split('\n');


    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: lines.map((raw) {
          final line = transpose == 0 ? raw : transposeChordProLine(raw, transpose);


          // se è una riga con accordi (contiene [ ... ]) la rendiamo in due righe o la nascondiamo
          if (RegExp(r'\[[^\]]+\]').hasMatch(line)) {
            if (!showChords) {
              // rimuovi le parti [C]
              final onlyLyrics = line.replaceAll(RegExp(r'\[[^\]]+\]'), '');
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(onlyLyrics.trim(), style: TextStyle(fontSize: fontSize)),
              );
            }


            // costruiamo due righe: accordi sopra, testo sotto
            // generiamo stringa "accordi" con padding per allineare (semplice heuristica)
            final chordLine = StringBuffer();
            final lyricLine = StringBuffer();


            int i = 0; // index nella linea originale
            final pattern = RegExp(r'\[([^\]]+)\]');
            final matches = pattern.allMatches(line);
            int lastEnd = 0;


            for (final m in matches) {
              final before = line.substring(lastEnd, m.start);
              lyricLine.write(before);


              final chord = m.group(1)!;
              // per semplicità inseriamo il chord nella chordLine con lo stesso numero di spazi
              final pad = before.replaceAll(RegExp(r'[^\s]'), ' ');
              chordLine.write(pad);
              chordLine.write(chord);


              lastEnd = m.end;
            }
            // append restante
            if (lastEnd < line.length) lyricLine.write(line.substring(lastEnd));


            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(chordLine.toString(), style: TextStyle(fontSize: fontSize * 0.85, fontFeatures: [])),
                Text(lyricLine.toString(), style: TextStyle(fontSize: fontSize)),
                const SizedBox(height: 8),
              ],
            );
          }


          // riga senza accordi
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(line, style: TextStyle(fontSize: fontSize)),
          );
        }).toList(),
      ),
    );
  }
}