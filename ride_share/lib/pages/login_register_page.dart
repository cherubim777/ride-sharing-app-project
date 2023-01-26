import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ride_share/auth.dart';
import 'package:ride_share/data/UserProfileData.dart';
// import 'package:ride_share/data/dataModel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLoggedIn = true;
  var profileData = UserProfileData();

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signinWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _title() {
    return const Text('Ride Share');
  }

  Widget _entryField(
    String title,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: title,
        ),
      ),
    );
  }

  Widget _errorMessage() {
    print(errorMessage);
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child:
          // return Text(errorMessage == '' ? '' : 'አወይ.... የሆነ ነገረ ተበላህ 🫤🧐🤨');
          Text(errorMessage == '' ? '' : 'Something went wrong'),
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed: isLoggedIn
          ? signInWithEmailAndPassword
          : createUserWithEmailAndPassword,
      child: Text(isLoggedIn ? "Login" : "Register"),
    );
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLoggedIn = !isLoggedIn;
        });
      },
      child: Text(isLoggedIn ? "Register Instead" : "Login Instead"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(50, 8, 50, 8),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _entryField('Email', _controllerEmail),
              _entryField('Password', _controllerPassword),
              _errorMessage(),
              _submitButton(),
              _loginOrRegisterButton(),
            ]),
      ),
    );
  }
}
