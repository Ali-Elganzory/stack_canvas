import 'dart:ui';

extension tranformations on Rect {
  Rect scaleInPlace(double scale) {
    final double width = this.width * scale;
    final double height = this.height * scale;
    return Rect.fromLTWH(this.left - (width - this.width) / 2,
        this.top - (height - this.height) / 2, width, height);
  }

  Rect scaleFromOrigin(double scale, Offset origin) {
    final double width = this.width * scale;
    final double height = this.height * scale;
    final Offset offset = origin - (origin - this.topLeft) * scale;
    return offset & Size(width, height);
  }

  Rect transform(Offset offset, double scale) {
    return this.shift(offset).scaleInPlace(scale);
  }

  Rect transformFromOrigin(Offset offset, double scale, Offset origin) {
    return this.shift(offset).scaleFromOrigin(scale, origin);
  }
}
