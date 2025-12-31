import 'package:flutter/material.dart';

/// Utility per il layout tipografico di testi con accordi.
/// Responsabilità:
/// - misurare la larghezza reale del testo
/// - calcolare la posizione orizzontale degli accordi
/// - fornire offset verticali coerenti col font
class LyricsLayout {
  /// Calcola la larghezza reale del testo fino a un certo indice di carattere
  static double measureTextWidth({
    required String text,
    required int charIndex,
    required TextStyle style,
  }) {
    if (text.isEmpty || charIndex <= 0) return 0;

    final safeIndex = charIndex.clamp(0, text.length);

    final painter = TextPainter(
      text: TextSpan(
        text: text.substring(0, safeIndex),
        style: style,
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();

    return painter.width;
  }

  /// Offset verticale consigliato per posizionare un accordo sopra al testo
  static double chordTopOffset(TextStyle textStyle) {
    final fontSize = textStyle.fontSize ?? 16;
    return -fontSize * 0.9;
  }
}
