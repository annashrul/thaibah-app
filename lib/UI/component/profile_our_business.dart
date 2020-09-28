import 'package:flutter/material.dart';
import 'package:thaibah/config/user_repo.dart';

class ProfileOurBusinees extends StatefulWidget {
  @override
  _ProfileOurBusineesState createState() => _ProfileOurBusineesState();
}

class _ProfileOurBusineesState extends State<ProfileOurBusinees> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          UserRepository().textQ("kontent profile belum tersedia",14,Colors.black,FontWeight.bold,TextAlign.center)
        ],
      ),
    );
  }
}
