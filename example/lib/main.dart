import 'package:flutter/material.dart';

import 'package:stack_canvas/stack_canvas.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final StackCanvasController controller = StackCanvasController();

  @override
  void initState() {
    super.initState();

    // Add dummy objects
    controller.addCanvasObjects([
      CanvasObject<Widget>(
        dx: 10,
        dy: 10,
        width: 40,
        height: 60,
        child: Container(
          color: Colors.red,
        ),
      ),
      CanvasObject<Widget>(
        dx: 140,
        dy: 60,
        width: 80,
        height: 80,
        child: Container(
          color: Colors.blue,
        ),
      ),
      CanvasObject<Widget>(
        dx: 60,
        dy: 160,
        width: 100,
        height: 60,
        child: Container(
          color: Colors.purple,
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stack Canvas"),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_drop_up_rounded),
            tooltip: "Move upward",
            onPressed: () {
              controller.moveUp();
            },
          ),
          IconButton(
            icon: Icon(Icons.arrow_drop_down_rounded),
            tooltip: "Move downward",
            onPressed: () {
              controller.moveDown();
            },
          ),
          IconButton(
            icon: Icon(Icons.arrow_left_rounded),
            tooltip: "Move to the left",
            onPressed: () {
              controller.moveLeft();
            },
          ),
          IconButton(
            icon: Icon(Icons.arrow_right_rounded),
            tooltip: "Move to the right",
            onPressed: () {
              controller.moveRight();
            },
          ),
          IconButton(
            icon: Icon(Icons.zoom_in_rounded),
            tooltip: "Zoom in",
            onPressed: () {
              controller.zoomIn();
            },
          ),
          IconButton(
            icon: Icon(Icons.zoom_out_rounded),
            tooltip: "Zoom out",
            onPressed: () {
              controller.zoomOut();
            },
          ),
        ],
      ),
      body: Center(
        child: StackCanvas(
          width: double.maxFinite,
          height: double.maxFinite,
          canvasController: controller,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Reset canvas transforamtion',
        child: Icon(Icons.refresh_rounded),
        onPressed: () {
          controller.resetCanvasTransformation();
        },
      ),
    );
  }
}
