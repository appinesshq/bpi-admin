import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

import '../providers/auth_provider.dart';

class AuthSwitcher extends StatelessWidget {
  final Widget child;
  final Widget nonAuthedChild;

  AuthSwitcher({@required this.child, @required this.nonAuthedChild});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, widget) =>
          authProvider.authenticated ? child : nonAuthedChild,
    );
  }
}
