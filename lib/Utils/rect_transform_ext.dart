import 'dart:ui';

extension tranformations on Rect {
  Rect scale(double scale) {
    final double width = this.width * scale;
    final double height = this.height * scale;
    return Rect.fromLTWH(this.left - (width - this.width) / 2,
        this.top - (height - this.height) / 2, width, height);
  }

  Rect transform(Offset offset, double scale) {
    return this.shift(offset).scale(scale);
  }
}
