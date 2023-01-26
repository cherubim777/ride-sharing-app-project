import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ride_share/auth.dart';
import 'package:ride_share/data/dataModel.dart';
import 'package:ride_share/data/UserProfileData.dart';
import 'package:ride_share/pages/creator_page.dart';
import 'package:ride_share/pages/joiner_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final User? user = Auth().currentUser;
  final database = FirebaseDatabase.instance;
  var userProfileData = UserProfileData();

  void _registerIntoDatabase() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        // String current = user.uid.toString();
        final currentProfileData = DataModel(
            user.uid.toString(),
            user.displayName.toString(),
            user.phoneNumber.toString(),
            user.email.toString());
        userProfileData.appendIntoDatabase(currentProfileData);
      }
    });
  }

  _readFromDatabase() {
    var data = userProfileData.readData('EmailAddress');
    return data.toString();
  }

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _title() {
    return const Text('Ride Share');
  }

  Widget _signOutButton() {
    return FloatingActionButton(
      onPressed: signOut,
      child: const Icon(Icons.logout),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = database.ref().child('UserProfile');

    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 75,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreatorPage(),
                      ),
                    );
                  },
                  child: const Text('Create Ride')),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 200,
              height: 75,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JoinerPage(),
                      ),
                    );
                  },
                  child: const Text('Join Ride')),
            ),
          ],
        ),
      ),
      floatingActionButton: _signOutButton(),
    );
  }
}
