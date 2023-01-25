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

  void _updateDatabase() {
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
    // widget.messageDao.saveMessage(message);
    // _messageController.clear();
    // setState(() {});
  }

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

  // Widget _saveProfile() {
  //   return ElevatedButton(
  //     onPressed: () {},
  //     child: const Text('Save my profile'),
  //   );
  // }

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
            // _userId(),
            _signOutButton(),
            // _saveProfile(),
            ElevatedButton(
              onPressed: () async {
                try {
                  // await userProfile.set(
                  //   {
                  //     'UserName': 'arik',
                  //     'UserType': 'agari',
                  //     'PhoneNumber': '0987654321',
                  //     'EmailAddress': 'arik@gmail.com',
                  //     'UserStatus': 'online',
                  //     'location': {
                  //       'CurrentLocation': '4kilo',
                  //       'DestinationLocation': 'Welete',
                  //     }
                  //   },
                  // );
                  _updateDatabase();
                  print('User profile has been saved to the database');
                } catch (error) {
                  print('something went wrong $error');
                }
              },
              child: const Text('save my Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
