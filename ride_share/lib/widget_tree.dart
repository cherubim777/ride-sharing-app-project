// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ride_share/auth.dart';
import 'package:ride_share/pages/home_page.dart';
import 'package:ride_share/pages/login_register_page.dart';
// import 'package:ride_share/data/UserProfileData.dart';
// import 'package:ride_share/data/dataModel.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

// var userProfileData = UserProfileData();

// void _sendMessage() {
//   FirebaseAuth.instance.authStateChanges().listen((User? user) {
//     if (user != null) {
//       final currentProfileData = DataModel(
//         user.displayName.toString(),
//         user.email.toString(),
//         user.phoneNumber.toString(),
//       );
//       userProfileData.appendIntoDatabase(currentProfileData);
//     }
//   });
// widget.messageDao.saveMessage(message);
// _messageController.clear();
// setState(() {});
// }

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authstatchanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HomePage();
        } else {
          // _sendMessage();
          return const LoginPage();
        }
      },
    );
  }
}
