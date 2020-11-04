import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class App extends StatelessWidget {
  final String _title;
  final Widget child;

  App(this._title, {@required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, widget) {
        return Scaffold(
          appBar: AppBar(
            title: Text(_title),
          ),
          drawer: authProvider.authenticated
              ? _drawer(context, authProvider)
              : null,
          body: child,
        );
      },
    );
  }

  Widget _drawer(BuildContext context, AuthProvider authProvider) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('BPI admin'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          _menuTitle('Users'),
          Divider(),
          ListTile(
            title: Text('List'),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/users',
              );
            },
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () {
              authProvider.logout();
              Navigator.pushNamed(
                context,
                '/'
              );
              // Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _menuTitle(String title) {
    return ListTile(
      title: Text(title),
    );
  }
}
