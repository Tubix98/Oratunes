enum FontSizeLevel {
  small,
  medium,
  large,
}

double fontIndicatorSize(FontSizeLevel level) {
  switch (level) {
    case FontSizeLevel.small:
      return 14;
    case FontSizeLevel.medium:
      return 18;
    case FontSizeLevel.large:
      return 22;
  }
}