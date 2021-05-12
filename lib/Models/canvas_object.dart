import 'dart:ui';

import 'package:stack_canvas/Utils/rect_transform_ext.dart';

class CanvasObject<T> {
  const CanvasObject({
    required double dx,
    required double dy,
    required double width,
    required double height,
    required T child,
  })   : _dx = dx,
        _dy = dy,
        _width = width,
        _height = height,
        _child = child;

  final double _dx;
  final double _dy;
  final double _width;
  final double _height;
  final T _child;

  Offset get offset => Offset(_dx, _dy);
  Size get size => Size(_width, _height);
  Rect get rect => offset & size;
  T get child => _child;

  CanvasObject<T> copyWith({
    double? dx,
    double? dy,
    double? width,
    double? height,
    T? child,
  }) {
    return CanvasObject<T>(
      dx: dx ?? _dx,
      dy: dy ?? _dy,
      width: width ?? _width,
      height: height ?? _height,
      child: child ?? _child,
    );
  }

  CanvasObject<T> transform(Offset offset, double scale) {
    final Rect transformedRect = this.rect.transform(offset, scale);
    
    return this.copyWith(
      dx: transformedRect.left,
      dy: transformedRect.top,
      width: transformedRect.width,
      height: transformedRect.height,
    );
  }

  CanvasObject<T> transformFromOrigin(Offset offset, double scale, Offset origin) {
    final Rect transformedRect = this.rect.transformFromOrigin(offset, scale, origin);
    
    return this.copyWith(
      dx: transformedRect.left,
      dy: transformedRect.top,
      width: transformedRect.width,
      height: transformedRect.height,
    );
  }
}
