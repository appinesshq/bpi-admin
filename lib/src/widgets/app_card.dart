import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

EdgeInsetsGeometry _defaultMargin() {
  if (kIsWeb) {
    return EdgeInsets.fromLTRB(150.0, 50.0, 150.0, 50.0);
  } else if (Platform.isAndroid || Platform.isIOS) {
    return EdgeInsets.all(4.0);
  } else
    return EdgeInsets.fromLTRB(10.0, 50.0, 100.0, 50.0);
}

Size screenSize(BuildContext context) {
  return MediaQuery.of(context).size;
}

double screenHeight(BuildContext context, {double dividedBy = 1}) {
  return screenSize(context).height / dividedBy;
}

double screenWidth(BuildContext context, {double dividedBy = 1}) {
  return screenSize(context).width / dividedBy;
}

class AppCard extends StatelessWidget {
  final Widget _child;
  final double _width, _height, _division, _padding;
  final String _title;

  AppCard(
      {@required Widget child,
      double width,
      double height,
      double division = 1,
      double padding = 8.0,
      String title})
      : _child = child,
        _width = width,
        _height = height,
        _division = division,
        _padding = padding,
        _title = title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Container(
        width: _width == null
            ? screenWidth(context, dividedBy: _division)
            : _width,
        height: _height == null
            ? screenHeight(context, dividedBy: _division)
            : _height,
        child: Card(
          child: _title == null
              ? Padding(
                  padding: EdgeInsets.all(_padding),
                  child: _child,
                )
              : Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: _width == null
                          ? screenWidth(context, dividedBy: _division) * 0.07
                          : _width * 0.07,
                      color: theme.primaryColor,
                      child: Center(
                        child: Text(
                          _title,
                          style: theme.primaryTextTheme.headline6,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(_padding),
                      child: _child,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
