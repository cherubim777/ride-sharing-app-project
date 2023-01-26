import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:ride_share/data/dataModel.dart';

import 'package:ride_share/auth.dart';

FirebaseDatabase database = FirebaseDatabase.instance;

class UserProfileData {
  // final DatabaseReference _userProfile =
  //     FirebaseDatabase.instance.ref('UserProfile');

  readData(String request) async {
    var _profile;
    final User? user = Auth().currentUser;
    if (user != null) {
      // var _userRequest = database.ref('UserProfile/${user.uid}/{$request');
      var _userRequest = database
          .ref()
          .child('UserProfile')
          .child(user.uid)
          .child('location/CurrentLocation');
      try {
        await _userRequest.onValue.listen((DatabaseEvent event) {
          _profile = event.snapshot.value;
          print('reading from database ===>> $_profile');
        });
      } catch (e) {
        print('unable to read data $e');
      }
    }
    return _profile;
  }

  void appendIntoDatabase(DataModel dataModel) async {
    // DatabaseReference _newUserProfile = database.ref('UserProfile');
    // _newUserProfile.push().set(dataModel.toJson());
    DatabaseReference _newUserProfile = database.ref();
    final User? user = Auth().currentUser;
    if (user != null) {
      _newUserProfile
          .child('UserProfile')
          .child(user.uid)
          .set(dataModel.toJson());
    }
  }
}
