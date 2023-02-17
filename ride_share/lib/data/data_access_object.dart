import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
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

  void createRideGroup() async {
    DatabaseReference newUserProfile = database.ref();
    final User? user = Auth().currentUser;
    if (user != null) {
      await newUserProfile.child('RideShare/RideMembers').set(user.uid);
    }
  }

  List getJoinedMembersLocation() {
    DatabaseReference rideMembers = database.ref();
    final User? user = Auth().currentUser;

    var locatioin = [];

    if (user != null) {
      rideMembers
          .child('RideShare/RideMembers/${user.uid}/')
          .onValue
          .listen((event) {
        for (var child in event.snapshot.children) {
          var a = child.ref;
          a.onValue.listen((event) {
            for (var val in event.snapshot.children) {
              if (val.key == 'location') {
                locatioin.add(Location.fromJson(val.value));
              }
            }
          });
        }
      });
    }
    print(locatioin);
    return locatioin;
  }

  // List<GeoPoint> joiners() {
  //   DatabaseReference joined = database.ref();
  //   final User? user = Auth().currentUser;
  //   Ride? rideCreator = Ride();
  //   var joinersId = [];
  //   List<GeoPoint> joinersLocation = [];

  //   if (user != null) {
  //     joined.child('RideShare/Rides').onValue.listen((event) {
  //       for (var child in event.snapshot.children) {
  //         rideCreator = Ride.fromJson(child.value);
  //       }

  //       joined
  //           .child('RideShare/RideMember/${rideCreator?.creator}')
  //           .onChildChanged
  //           .listen((event) {
  //         for (var child in event.snapshot.children) {
  //           if (child.key == 'creator') continue;
  //           joinersId.add(child.value.toString());
  //           joined
  //               .child('RideShare/Users/${child.value}/CurrentLocation')
  //               .onValue
  //               .listen((event) {
  //             print('---->-->${event.snapshot.children.first}<---<---');
  //             GeoPoint point = GeoPoint(
  //               latitude:
  //                   double.parse(event.snapshot.children.first.toString()),
  //               longitude:
  //                   double.parse(event.snapshot.children.last.toString()),
  //             );
  //             joinersLocation.add(point);
  //             print('------>$point<------');
  //           });
  //         }
  //       });
  //     });
  //     // joined.child('RideShare/Users').onValue.listen((event) {
  //     //   for (var child in event.snapshot.children) {
  //     //     if(joinersId.contains(child.key)){
  //     //       child.value
  //     //     }
  //     //   }
  //     // });
  //   }
  //   return joinersLocation;
  // }

  void joinRideGroup(joinerLocation) async {
    DatabaseReference rideData = database.ref();
    final User? user = Auth().currentUser;
    Ride? rideCreator = Ride();

    if (user != null) {
      rideData.child('RideShare/Rides').limitToFirst(1).onValue.listen((event) {
        for (var child in event.snapshot.children) {
          rideCreator = Ride.fromJson(child.value);
        }
        Joiner joiner = Joiner(
          uid: user.uid,
          location: joinerLocation,
        );
        RideMembers group = RideMembers(joiner1: joiner);
        rideData
            .child('RideShare/RideMembers/${rideCreator?.creator}')
            .update(group.toJson());
      });

      print('\n\n\n\n\n');
      getJoinedMembersLocation();
      print('\n\n\n\n\n');
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
