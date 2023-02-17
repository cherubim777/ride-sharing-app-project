import 'dart:convert';

RideShare rideShareFromJson(String str) => RideShare.fromJson(json.decode(str));

String rideShareToJson(RideShare data) => json.encode(data.toJson());

class RideShare {
  RideShare({
    this.ride,
    this.rideMembers,
    this.users,
  });

  Ride? ride;
  RideMembers? rideMembers;
  Users? users;

  factory RideShare.fromJson(Map<String, dynamic> json) => RideShare(
        ride: json["ride"] == null ? null : Ride.fromJson(json["ride"]),
        rideMembers: json["rideMembers"] == null
            ? null
            : RideMembers.fromJson(json["rideMembers"]),
        users: json["users"] == null ? null : Users.fromJson(json["users"]),
      );

  Map<String, dynamic> toJson() => {
        "ride": ride?.toJson(),
        "rideMembers": rideMembers?.toJson(),
        "users": users?.toJson(),
      };
}

class Ride {
  Ride({
    this.creator,
    this.location,
    this.seats,
  });

  String? creator;
  Location? location;
  int? seats;

  factory Ride.fromJson(json) => Ride(
        creator: json["Creator"],
        location: json["location"] == null
            ? null
            : Location.fromJson(json["location"]),
        seats: json["seats"],
      );

  get uid => null;

  Map<String, dynamic> toJson() => {
        "Creator": creator,
        "location": location?.toJson(),
        "seats": seats,
      };
}

class Location {
  Location({
    this.currentLocation,
    this.destinationLocation,
  });

  Coordinates? currentLocation;
  Coordinates? destinationLocation;

  factory Location.fromJson(json) => Location(
        currentLocation: json["CurrentLocation"] == null
            ? null
            : Coordinates.fromJson(json["CurrentLocation"]),
        destinationLocation: json["DestinationLocation"] == null
            ? null
            : Coordinates.fromJson(json["DestinationLocation"]),
      );

  Map<String, dynamic> toJson() => {
        "CurrentLocation": currentLocation?.toJson(),
        "DestinationLocation": destinationLocation?.toJson(),
      };
}

class Coordinates {
  Coordinates({
    this.latitude,
    this.longitude,
  });

  double? latitude;
  double? longitude;

  factory Coordinates.fromJson(json) => Coordinates(
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
      };
}

class RideMembers {
  RideMembers({
    this.joiner1,
    this.joiner2,
  });

  Joiner? joiner1;
  Joiner? joiner2;

  factory RideMembers.fromJson(Map<String, dynamic> json) => RideMembers(
        joiner1:
            json["joiner1"] == null ? null : Joiner.fromJson(json["joiner1"]),
        joiner2:
            json["joiner2"] == null ? null : Joiner.fromJson(json["joiner2"]),
      );

  Map<String, dynamic> toJson() => {
        "joiner1": joiner1?.toJson(),
        "joiner2": joiner2?.toJson(),
      };
}

class Joiner {
  Joiner({
    this.uid,
    this.location,
  });

  String? uid;
  Location? location;

  factory Joiner.fromJson(Map<String, dynamic> json) => Joiner(
        uid: json["uid"],
        location: json["location"] == null
            ? null
            : Location.fromJson(json["location"]),
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "location": location?.toJson(),
      };
}

class Users {
  Users({
    this.uid,
    this.emailAddress,
    this.userName,
    this.phoneNumber,
    this.userType,
    this.location,
  });

  String? uid;
  String? emailAddress;
  String? userName;
  String? phoneNumber;
  String? userType;
  Location? location;

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        uid: json["Uid"],
        emailAddress: json["EmailAddress"],
        userName: json["UserName"],
        phoneNumber: json["PhoneNumber"],
        userType: json["UserType"],
        location: json["location"] == null
            ? null
            : Location.fromJson(json["location"]),
      );

  Map<String, dynamic> toJson() => {
        "Uid": uid,
        "EmailAddress": emailAddress,
        "UserName": userName,
        "PhoneNumber": phoneNumber,
        "UserType": userType,
        "location": location?.toJson(),
      };
}
