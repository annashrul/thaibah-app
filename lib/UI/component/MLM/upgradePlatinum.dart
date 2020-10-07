import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:thaibah/Model/onboardingModel.dart';
import 'package:thaibah/Model/pageViewModel.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/onboarding/introViews.dart';
import 'package:thaibah/config/api.dart';
import '../home/widget_index.dart';

class UpgradePlatinum extends StatefulWidget {
  @override
  _UpgradePlatinumState createState() => _UpgradePlatinumState();
}

class _UpgradePlatinumState extends State<UpgradePlatinum> {
  List<PageViewModel> wrapOnboarding = [];
  var cek = [];
  bool isLoading = false;
  var res;
  Future load() async{
    Client client = Client();
    final response = await client.get(ApiService().baseUrl+'info/platinumData');


    if(response.statusCode == 200){
      final jsonResponse = json.decode(response.body);
      if(response.body.isNotEmpty){
        OnboardingModel onboardingModel = OnboardingModel.fromJson(jsonResponse);
        onboardingModel.result.map((Result items){
          setState(() {
            wrapOnboarding.add(PageViewModel(
              pageColor: Colors.white,
              bubbleBackgroundColor: Colors.green,
              title: Container(),
              body: Container(),
              mainImage: Column(
                children: <Widget>[
                  Image.network(
                    items.picture,
                    width: 150.0,
                    height:150.0,
                    alignment: Alignment.center,
                  ),
                  Text(items.title,style: TextStyle(fontFamily: 'Rubik',color: Color(0xFF116240),fontWeight: FontWeight.bold)),
                  Text(items.description,style: TextStyle(fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                ],
              ),
              textStyle: TextStyle(color: Colors.black,fontFamily: 'Rubik',),
            ));
          });

        }).toList();
        setState(() {
          isLoading = false;
        });
      }
      print(wrapOnboarding);
    }else {
      throw Exception('Failed to load info');
    }
  }



  @override
  void initState(){
    load();
    isLoading = true;

  }



  @override
  Widget build(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(width: 750, height: 1334, allowFontScaling: true);
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.keyboard_backspace,color: Colors.white),
            onPressed: (){
              Navigator.of(context).pop();
            },
          ),
          centerTitle: false,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[
                  Color(0xFF116240),
                  Color(0xFF30cc23)
                ],
              ),
            ),
          ),
          elevation: 1.0,
          automaticallyImplyLeading: true,
          title: new Text("Upgrade Platinum", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
        ),
        body: isLoading?Container(child: Center(child: CircularProgressIndicator())):Stack(
          children: <Widget>[
            Container(
              child: IntroViewsFlutter(
                wrapOnboarding,
                onTapDoneButton: (){
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>WidgetIndex(param: 'produk',)), (Route<dynamic> route) => false);
                },
                showSkipButton: true,
                doneText: Text("Mulai",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
                pageButtonsColor: Colors.green,
                pageButtonTextStyles: new TextStyle(
                    fontSize: 12.0,
                    fontFamily: "Rubik",
                    fontWeight: FontWeight.bold
                ),
              ),
            ),


          ],
        )
    );
  }
}
