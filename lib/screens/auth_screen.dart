import 'package:flutter/material.dart';
import 'package:icu_controller/screens/rooms_list_screen.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({Key? key}) : super(key: key);

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Container(
          height: height * 0.5,
          margin: EdgeInsets.all(50),
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'E-Mail'),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  controller: _passwordController,
                ),
                FlatButton(
                  child: Text('Submit'),
                  onPressed: () {
                    if (_passwordController.text == '111' &&
                        _emailController.text == 'kh@kh.com') {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => RoomsListScreen(),
                        ),
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
