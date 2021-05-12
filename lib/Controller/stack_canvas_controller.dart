import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:stack_canvas/Models/canvas_object.dart';

enum Reference { TopLeft, Center }

class StackCanvasController {
  StackCanvasController({
    double zoomChangeUnit = 0.10,
    double moveChangeUnit = 30.00,
    Reference offsetReference = Reference.TopLeft,
    Reference zoomReference = Reference.TopLeft,
  })  : _scaleChangeUnit = zoomChangeUnit,
        _offsetChangeUnit = moveChangeUnit,
        offsetReference = offsetReference,
        zoomReference = zoomReference;

  // For updating the ui with widgets
  final StreamController<List<CanvasObject<Widget>>>
      _canvasObjectsStreamController =
      StreamController<List<CanvasObject<Widget>>>();
  Stream<List<CanvasObject<Widget>>> get canvasObjectsStream =>
      _canvasObjectsStreamController.stream;

  // Canvas size -- set by view
  Size _canvasSize = Size.zero;
  Size get canvasSize => _canvasSize;
  set canvasSize(Size size) {
    _canvasSize = size;
    _updateCanvas();
  }

  // Canvas transformation parameters
  Reference offsetReference;
  Reference zoomReference;
  static const Offset _defaultOffset = Offset.zero;
  static const double _defaultScale = 1;
  static const double _maxScaleMargin = 3;
  final double _scaleChangeUnit;
  final double _offsetChangeUnit;

  // Current canvas transformation values
  Offset _offset = _defaultOffset;
  Offset get offset => _offset;
  set offset(Offset offset) {
    _offset = offset;
    _updateCanvas();
  }

  double _scale = _defaultScale;
  double get scale => _scale;
  set scale(double scale) {
    _scale = scale;
    _updateCanvas();
  }

  // Transformation utilities
  void zoomIn() {
    scale = min(scale + _scaleChangeUnit, _maxScaleMargin);
  }

  void zoomOut() {
    scale = max(scale - _scaleChangeUnit, -_maxScaleMargin);
  }

  void moveRight() {
    offset = offset.translate(-_offsetChangeUnit, 0);
  }

  void moveLeft() {
    offset = offset.translate(_offsetChangeUnit, 0);
  }

  void moveUp() {
    offset = offset.translate(0, _offsetChangeUnit);
  }

  void moveDown() {
    offset = offset.translate(0, -_offsetChangeUnit);
  }

  Offset get originPoint => offsetReference == Reference.TopLeft
      ? Offset.zero
      : canvasSize.center(Offset.zero);

  Offset get zoomPoint => zoomReference == Reference.TopLeft
      ? Offset.zero
      : canvasSize.center(Offset.zero);

  // Canvas objects to be rendered
  final List<CanvasObject<Widget>> _canvasObjects = [];
  List<CanvasObject<Widget>> get canvasObjects {
    // Apply canvas transformations to the list
    return _canvasObjects
        .map((obj) =>
            obj.transformFromOrigin(originPoint + offset, scale, zoomPoint))
        .toList();
  }

  // Add canvas to be rendered
  void addCanvasObjects(List<CanvasObject<Widget>> objects) {
    _canvasObjects.addAll(objects);
    _updateCanvas();
  }

  // Remove canvas object
  void removeCanvasObject(CanvasObject<Widget> object) {
    _canvasObjects.remove(object);
    _updateCanvas();
  }

  // Publish the updated list of canvas objects
  void _updateCanvas() {
    _canvasObjectsStreamController.add(canvasObjects);
  }

  // Restore the canvas to its default transformation
  void resetCanvasTransformation() {
    _offset = _defaultOffset;
    _scale = _defaultScale;
    _updateCanvas();
  }

  // Dispose any unmanaged resources
  void dispose() {
    _canvasObjectsStreamController.close();
  }
}
