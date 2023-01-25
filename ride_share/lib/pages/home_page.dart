import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ride_share/auth.dart';
import 'package:ride_share/data/dataModel.dart';
import 'package:ride_share/data/UserProfileData.dart';

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
    return const Text('እንኩዋን በደህና መጡ፣ ታክሲ የመጋራት');
  }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: signOut,
      child: const Text('Sign Out'),
    );
  }

  final TextEditingController _controllerLocation = TextEditingController();
  Widget _changeEntryField(String title, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
      ),
    );
  }

  _updateDatabaseField() {
    userProfileData.updateUserData(_controllerLocation.text);
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
            _changeEntryField('new location', _controllerLocation),
            ElevatedButton(
              onPressed: _updateDatabaseField,
              child: const Text('update'),
            ),
            ElevatedButton(
                onPressed: () async {
                  try {
                    Text(_readFromDatabase());
                    print('User profile has been read from the database');
                  } catch (error) {
                    print('something went wrong\n\n $error');
                  }
                },
                child: const Text('Read Data')),
            // _userId(),
            ElevatedButton(
              onPressed: () async {
                try {
                  _registerIntoDatabase();
                  print('User profile has been saved to the database');
                } catch (error) {
                  print('something went wrong\n\n $error');
                }
              },
              child: const Text('save my Profile'),
            ),
            _signOutButton(),
          ],
        ),
      ),
    );
  }
}
