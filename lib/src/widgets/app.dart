import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class App extends StatelessWidget {
  final String _title;
  final Widget child;

  App(this._title, {@required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: child,
    );
  }
}
