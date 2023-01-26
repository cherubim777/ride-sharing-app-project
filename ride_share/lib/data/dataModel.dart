// import 'package:firebase_database/firebase_database.dart';

class DataModel {
  DataModel(this.uid, this.email,
      {this.userStatus = 'online',
      this.userName = 'name',
      this.phoneNumber = 'phoneNumber',
      this.currentLocation = 'welete',
      this.destinationLocation = '4kilo',
      this.userType = 'agari'});

  DataModel.fromJson(Map<String, dynamic> json)
      : uid = json['Uid'] as String,
        userName = json['UserName'] as String,
        phoneNumber = json['PhoneNumber'] as String,
        email = json['EmailAddress'] as String,
        userType = json['UserStatus'] as String,
        userStatus = json['UserStatus'] as String,
        currentLocation = json['CurrentLocation'] as String,
        destinationLocation = json['DestinationLocation'] as String;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'Uid': uid,
        'UserName': userName,
        'PhoneNumber': phoneNumber,
        'EmailAddress': email,
        'UserType': userType,
        'UserStatus': userStatus,
        'CurrentLocation': currentLocation,
        'DestinationLocation': destinationLocation
      };

  late String uid;
  late String userName;
  late String phoneNumber;
  late String email;
  late String userType;
  late String userStatus;
  late String currentLocation;
  late String destinationLocation;
}
