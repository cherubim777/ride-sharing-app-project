import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:ride_share/data/dataModel.dart';
import 'package:ride_share/auth.dart';

class DataAccessObject {
  FirebaseDatabase database = FirebaseDatabase.instance;

  void registerUser(newUser) async {
    DatabaseReference newUserProfile = database.ref();
    final User? user = Auth().currentUser;
    if (user != null) {
      await newUserProfile
          .child('RideShare/Users')
          .child(user.uid)
          .set(newUser.tojson());
    }
  }

  void updateUserData(Location location) async {
    DatabaseReference newUserProfile = database.ref();
    final User? user = Auth().currentUser;
    if (user != null) {
      await newUserProfile
          .child('UserProfile')
          .child(user.uid)
          .update(location.toJson());
    }
  }
}
