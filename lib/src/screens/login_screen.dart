import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../mixins/validation.dart';
import '../providers/auth_provider.dart';
import '../widgets/app_card.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with Validation {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _authProvider = Provider.of<AuthProvider>(context, listen: false);
    return AppCard(
      title: 'Login',
      division: 2,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _emailController,
              decoration:
                  InputDecoration(labelText: 'Enter your email address'),
              validator: email,
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Enter your password'),
              validator: notEmpty,
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, otherwise false.
                if (_formKey.currentState.validate()) {
                  _authProvider
                      .authenticate(
                          _emailController.text, _passwordController.text)
                      .then((value) => Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Login succeeded'))))
                      .catchError((err) => Scaffold.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('Couldn\'t login: ${err.toString()}'))));
                }
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
