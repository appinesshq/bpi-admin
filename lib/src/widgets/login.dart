import 'package:flutter/material.dart';
import '../mixins/validation.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with Validation {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Enter your email address'),
            validator: email,
          ),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Enter your password'),
            validator: notEmpty,
            obscureText: true,
          ),
          ElevatedButton(
            onPressed: () {
              // Validate returns true if the form is valid, otherwise false.
              if (_formKey.currentState.validate()) {
                // If the form is valid, display a snackbar. In the real world,
                // you'd often call a server or save the information in a database.

                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text('Processing Data')));
              }
            },
            child: Text('Login'),
          ),
        ],
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
