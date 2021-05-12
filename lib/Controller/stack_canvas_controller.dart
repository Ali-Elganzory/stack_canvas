import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:stack_canvas/Models/canvas_object.dart';

class StackCanvasController {
  // For updating the ui with widgets
  final StreamController<List<CanvasObject<Widget>>>
      _canvasObjectsStreamController =
      StreamController<List<CanvasObject<Widget>>>();
  Stream<List<CanvasObject<Widget>>> get canvasObjectsStream =>
      _canvasObjectsStreamController.stream;

  // Default canvas transformation
  static const Offset _defaultOffset = Offset(0, 0);
  static const double _defaultScale = 1;
  static const double _maxScaleMargin = 3;
  static const double _scaleChangeUnit = 0.05;
  static const double _offsetChangeUnit = 5.0;

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

  // Canvas objects to be rendered
  final List<CanvasObject<Widget>> _canvasObjects = [];
  List<CanvasObject<Widget>> get canvasObjects =>
      // Apply canvas transformations to the list
      _canvasObjects.map((obj) => obj.transform(offset, scale)).toList();

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

  // Publish the updated list of canvas objects after a callback
  void _updateCanvasAfterCallback(Function callback) {
    callback();
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
