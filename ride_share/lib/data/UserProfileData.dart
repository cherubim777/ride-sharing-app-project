import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:ride_share/auth.dart';
import 'package:ride_share/data/dataModel.dart';

class UserProfileData {
  FirebaseDatabase database = FirebaseDatabase.instance;
  Set<DataModel> users = {};

  readData(String request) async {
    DatabaseReference _userRequest = database.ref('UserProfile');
    try {
      _userRequest.onValue.listen((event) {
        final users = event.snapshot.children;
        for (final user in users) {
          // print(user.key);
          readSingleUserData('UserProfile/${user.key}');
        }
        print("reading.....");
      }, onError: (e) {
        print('---readData function error $e');
      });
    } catch (e) {
      print('userData Map -------------$e');
    }
    print('this is all user data ====> $users');
    users.clear();
  }

  readSingleUserData(String request) async {
    DatabaseReference _userRequest = database.ref(request);
    var _profile;
    Map<String, dynamic> userData = {'key': 'value'};
    try {
      await _userRequest.onValue.listen((event) {
        _profile = event.snapshot.children;
        for (final child in _profile) {
          userData[child.key.toString()] = child.value;
        }
        final currentUser = DataModel.fromJson(userData);
        users.add(currentUser);
        // print(userData);
        print("reReading.....");
        // print(currentUser.email);
        // print(_profile);
      }, onError: (e) {
        print('---readData function error $e');
      });
    } catch (e) {
      print('userData Map -------------$e');
    }
  }

  // fetchUser() {
  //   allUsersData = readData('UserProfile');
  // }

  void registerUser(dataModel) async {
    DatabaseReference _newUserProfile = database.ref();
    final User? user = Auth().currentUser;
    if (user != null) {
      await _newUserProfile
          .child('UserProfile')
          .child(user.uid)
          .set(dataModel.toJson());
    }
  }

  void updateUserData(String updatedData) async {
    DatabaseReference _newUserProfile = database.ref();
    final User? user = Auth().currentUser;
    if (user != null) {
      await _newUserProfile
          .child('UserProfile')
          .child(user.uid)
          .update({'CurrentLocation': updatedData});
    }
  }

  void findPairs() {
    List<dynamic> allUsersData = readData('UserProfile');
    final User? user = Auth().currentUser;
    if (user != null) {
      // must be true
      // isOnline;
      onlineUsers(allUsersData, user.uid);
      // must be false
      // isTheSameType(user);
      // must be true
      // isAtNearByCurrentLocation(user);
      // hasNearByDestination(user);
    }
  }

  onlineUsers(List users, String currentUid) {
    // List wantedUsers = [];
    for (final child in users) {
      if (child.value['userstatus' != 'online']) {
        users.remove(child);
      }
    }
    print(users);
    return users;
  }

  void findRide() {}
}
