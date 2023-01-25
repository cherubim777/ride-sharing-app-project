import 'package:firebase_database/firebase_database.dart';
import 'package:ride_share/data/dataModel.dart';

FirebaseDatabase database = FirebaseDatabase.instance;

class UserProfileData {
  final DatabaseReference _userProfile =
      FirebaseDatabase.instance.ref('UserProfile');
  // reads data from real_time_database as they changes.
  void readData(DataModel dataModel) {
    _userProfile.onValue.listen((DatabaseEvent event) {
      final _profile = event.snapshot.value;
    });
    // dataModel.fromJson(_profile);
  }

  void appendIntoDatabase(DataModel dataModel) async {
    DatabaseReference _newUserProfile = _userProfile;
    _newUserProfile.push().set(dataModel.toJson());
    // Query getDataModelQuery() {
    //   return _userProfile;
    // }

    // void updateData() async {
    //   try {
    //     await dataModel.update(
    //       {
    //         'UserType': null,
    //         'location': {
    //           'CurrentLocation': 'Meskel square',
    //           'DestinationLocation': 'Welete',
    //         }
    //       },
    //     );
    //   } catch (e) {
    //     print('something went wrong with the update');
    //   }
    // }

    // try {
    //   await dataModel.set(
    //     {
    //       'UserName': 'arik',
    //       'UserType': 'agari',
    //       'PhoneNumber': '0987654321',
    //       'EmailAddress': 'arik@gmail.com',
    //       'UserStatus': 'online',
    //       'location': {
    //         'CurrentLocation': '4kilo',
    //         'DestinationLocation': 'Welete',
    //       }
    //     },
    //   );
    // } catch (e) {
    //   print("something went wrong");
    // }
  }
}
