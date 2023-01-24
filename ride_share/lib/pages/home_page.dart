import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ride_share/auth.dart';

import '../main_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _title() {
    return const Text('እንኩዋን በደህና መጡ፣ አሁን ታክሲ የመጋራት ግልጋሎትዎን ይጀምሩ');
  }

  // Widget _userId() {
  //   return Text(user?.email ?? 'user email');
  // }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: signOut,
      child: const Text('Sign Out'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: (() {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainPage()),
                );
              }),
              child: const Text("CREATE RIDE"),
            ),
            ElevatedButton(
              onPressed: (() {}),
              child: const Text("REQUEST TO JOIN RIDE"),
            ),
            _signOutButton(),
          ],
        ),
      ),
    );
  }
}
