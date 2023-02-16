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
          .set(newUser.toJson());
    }
  }

  void updateUserData(data) async {
    DatabaseReference newUserProfile = database.ref();
    final User? user = Auth().currentUser;
    if (user != null) {
      await newUserProfile
          .child('RideShare/Users')
          .child(user.uid)
          .update(data);
    }
  }

  void createRide(newRide) async {
    DatabaseReference newUserProfile = database.ref();
    final User? user = Auth().currentUser;
    if (user != null) {
      await newUserProfile
          .child('RideShare/Rides')
          .child(user.uid)
          .set(newRide.toJson());
    }
  }

  void createRideGroup(group) async {
    DatabaseReference newUserProfile = database.ref();
    final User? user = Auth().currentUser;
    if (user != null) {
      await newUserProfile
          .child('RideShare/RideMembers')
          .child(user.uid)
          .set(group.toJson());
    }
  }

  void joinRideGroup() async {
    DatabaseReference rideData = database.ref();
    final User? user = Auth().currentUser;
    Ride? rideCreator = Ride();

    if (user != null) {
      rideData.child('RideShare/Rides').limitToFirst(1).onValue.listen((event) {
        for (var child in event.snapshot.children) {
          print('>>>${child.value}<<<');
          rideCreator = Ride.fromJson(child.value);
        }
        // rideData.child('RideShare/RideMembers/');÷≥≤
        // print(
        // ">>>>>>>>>>>>>>>>>>>${rideCreator?.location?.currentLocation?.latitude}<<<<<<<<<<<<<<<<<<<<<<<<");
        RideMembers group = RideMembers(
          rideCreator: rideCreator?.creator,
          joiner1: user.uid,
        );
        rideData
            .child('RideShare/RideMembers/${rideCreator?.creator}')
            .update(group.toJson());
      });
    }
  }
  // void updateRide(){
  //   DatabaseReference newUserProfile = database.ref();
  //   final User? user = Auth().currentUser;
  //   if (user != null) {
  //     await newUserProfile
  //         .child('RideShare/Users')
  //         .child(user.uid)
  //         .update(data);
  //   }
  // }
}
