import 'package:flutter/material.dart';
import 'font_size_level.dart';

enum DeviceClass {
  phone,
  tablet,
  desktop,
}

/// Utility per il layout tipografico di testi con accordi.
/// Responsabilità:
/// - misurare la larghezza reale del testo
/// - calcolare la posizione orizzontale degli accordi
/// - fornire offset verticali coerenti col font

class LyricsLayout {
  /// Determina la classe di dispositivo in base alla larghezza disponibile
  static DeviceClass deviceClassForWidth(double width) {
    if (width < 600) {
      return DeviceClass.phone;
    } else if (width < 1024) {
      return DeviceClass.tablet;
    } else {
      return DeviceClass.desktop;
    }
  }

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
  static chordTopOffset(TextStyle textStyle) {
    final size = textStyle.fontSize ?? 16;
    return -size * 0.75;
  }

  static double fontScaleForLevel({
    required FontSizeLevel level,
    required double screenWidth,
  }) {
    // base: telefono
    double baseScale;
    if (screenWidth >= 1000) {
      baseScale = 1.25; // desktop
    } else if (screenWidth >= 600) {
      baseScale = 1.15; // tablet
    } else {
      baseScale = 1.0; // phone
    }

    switch (level) {
      case FontSizeLevel.small:
        return baseScale * 0.9;
      case FontSizeLevel.medium:
        return baseScale;
      case FontSizeLevel.large:
        return baseScale * 1.15;
    }
  }
}
