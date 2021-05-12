import 'package:flutter/material.dart';

import 'package:stack_canvas/Controller/stack_canvas_controller.dart';
import 'package:stack_canvas/Models/canvas_object.dart';

class StackCanvas extends StatefulWidget {
  const StackCanvas({
    required this.width,
    required this.height,
    this.backgroundColor = Colors.white,
    this.animationDuration = const Duration(milliseconds: 400),
    required this.canvasController,
    this.disposeController = true,
  });

  final double width;
  final double height;
  final Color backgroundColor;
  final Duration animationDuration;
  final StackCanvasController canvasController;
  final bool disposeController;

  @override
  _StackCanvasState createState() => _StackCanvasState();
}

class _StackCanvasState extends State<StackCanvas> {
  @override
  void dispose() {
    super.dispose();
    if (widget.disposeController) widget.canvasController.dispose();
  }

  List<CanvasObject<Widget>> canvasObjects = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.widget.width,
      height: this.widget.height,
      color: widget.backgroundColor,
      child: StreamBuilder<List<CanvasObject<Widget>>>(
          stream: widget.canvasController.canvasObjectsStream,
          builder: (_, snapshot) {
            if (snapshot.hasData) canvasObjects = snapshot.data!;

            return Stack(
              children: [
                for (final CanvasObject<Widget> obj in canvasObjects)
                  AnimatedPositioned.fromRect(
                    duration: widget.animationDuration,
                    rect: obj.rect,
                    child: obj.child,
                  ),
              ],
            );
          }),
    );
  }
}
