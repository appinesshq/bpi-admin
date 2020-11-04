import 'package:bpi_admin/src/repositories/api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/widgets/widgets.dart' show AuthSwitcher, App;
import 'src/providers/providers.dart';
import 'src/screens/screens.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final _api = API(url: 'http://192.168.0.100:3000');
    _api.debug = true;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(_api)),
        ChangeNotifierProvider(create: (_) => UserProvider(_api)),
      ],
      child: MaterialApp(
        title: 'BPI Admin',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: _routes(),
      ),
    );
  }

  Map<String, Widget Function(BuildContext)> _routes() {
    return {
      '/': (context) => _wrap(
              child: AuthSwitcher(
            child: Text('Welcome'),
            nonAuthedChild: LoginScreen(),
          )),
      LoginScreen.routeName: (context) =>
          _wrap(title: 'Login', child: LoginScreen()),
      UsersScreen.routeName: (context) =>
          _wrap(title: 'Users', child: UsersScreen()),
    };
  }

  Widget _wrap({String title, @required Widget child}) {
    return App(
        title == null || title.isEmpty ? 'BPI Admin' : 'BPI Admin - $title',
        child: child);
  }
}
