import 'package:flutter/material.dart';
import 'package:on_borading_screen/on_borading_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final controller = OnBoardingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: OnBoarding(
          controller: controller,
          leftAction: IconButton(
            onPressed: controller.previousPage,
            icon: Icon(
              Icons.keyboard_arrow_left,
            ),
          ),
          rightAction: IconButton(
            onPressed: controller.nextPage,
            icon: Icon(
              Icons.keyboard_arrow_right,
            ),
          ),
          pages: [
            Container(
              color: Colors.red,
              child: Center(
                child: Text("1"),
              ),
            ),
            Container(
              color: Colors.green,
              child: Center(
                child: Text("2"),
              ),
            ),
            Container(
              color: Colors.amber,
              child: Center(
                child: Text("3"),
              ),
            ),
            Container(
              color: Colors.purple,
              child: Center(
                child: Text("4"),
              ),
            ),
            Center(
              child: Text("5"),
            ),
            Container(
              color: Colors.pink,
              child: Center(
                child: Text("6"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
