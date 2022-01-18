import 'package:flutter/material.dart';
import 'calendar_widget.dart';
import 'const.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: primaryColor,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Calendar'),
        ),
        body: CalendarWidget(
          onChange: (d) => {print(d)},
        ),
      ),
    );
  }
}
