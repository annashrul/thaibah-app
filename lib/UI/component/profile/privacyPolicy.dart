import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/config/user_repo.dart';

class PrivacyPolicy extends StatefulWidget {
  final String privasi;
  PrivacyPolicy({this.privasi});
  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  Color warna1;
  Color warna2;
  String statusLevel ='0';
  final userRepository = UserRepository();
  Future loadTheme() async{
    final levelStatus = await userRepository.getDataUser('statusLevel');
    final color1 = await userRepository.getDataUser('warna1');
    final color2 = await userRepository.getDataUser('warna2');
    setState(() {
      warna1 = hexToColors(color1);
      warna2 = hexToColors(color2);
      statusLevel = levelStatus;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadTheme();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: UserRepository().appBarWithButton(context, "Kebijakan & Privasi",(){Navigator.pop(context);},<Widget>[]),

      // appBar:UserRepository().appBarWithButton(context,"Kebijakan & Privasi",warna1,warna2,(){Navigator.pop(context);},Container()),
      body: Scrollbar(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Center(
            child: ListView(
              children: <Widget>[
                Html(data: widget.privasi,defaultTextStyle: TextStyle(color:Colors.black,fontFamily:ThaibahFont().fontQ),)
              ],
            ),
          ),
        ),
//        viewportBuilder: null,
      ),
    );
  }
}
