import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thaibah/Model/onboardingModel.dart';
import 'package:thaibah/Model/pageViewModel.dart';
import 'package:thaibah/UI/produk_mlm_ui.dart';
import 'package:thaibah/UI/splash/introViews.dart';
import 'package:thaibah/config/api.dart';

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
    final response = await client.get(ApiService().baseUrl+'info/onboarding');


    if(response.statusCode == 200){
      final jsonResponse = json.decode(response.body);
      if(response.body.isNotEmpty){
        OnboardingModel onboardingModel = OnboardingModel.fromJson(jsonResponse);
        onboardingModel.result.map((Result items){
          setState(() {
            wrapOnboarding.add(PageViewModel(
              pageColor: Colors.white,
              bubbleBackgroundColor: Colors.indigo,
              title: Text('acuy'),
              body: Column(
                children: <Widget>[
                  Text(items.title,style: TextStyle(fontFamily: 'Rubik',color: Color(0xFF116240),fontWeight: FontWeight.bold)),
                  Text(items.description,style: TextStyle(fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                ],
              ),
              mainImage: Image.network(
                items.picture,
                width: 250.0,
                height:250.0,
                alignment: Alignment.center,
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
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    return new Scaffold(
        appBar: AppBar(
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
          centerTitle: false,
          elevation: 0.0,
          automaticallyImplyLeading: true,
          title: new Text("Produk Kami", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
        ),
        body: isLoading?Container(child: Center(child: CircularProgressIndicator())):Stack(
          children: <Widget>[
            IntroViewsFlutter(
              wrapOnboarding,
              onTapDoneButton: (){

              },
              showSkipButton: false,
              doneText: Text("",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
              pageButtonsColor: Colors.green,
              pageButtonTextStyles: new TextStyle(
                  fontSize: 16.0,
                  fontFamily: "Rubik",
                  fontWeight: FontWeight.bold
              ),
            ),
            Positioned(
                top: 600.0,
                left: 50.0,
                right:50.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                      child: Container(
                        width: MediaQuery.of(context).size.width/1,
                        height: ScreenUtil.getInstance().setHeight(100),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [Color(0xFF116240),Color(0xFF30CC23)]),
                            borderRadius: BorderRadius.circular(6.0),
                            boxShadow: [BoxShadow(color: Color(0xFF6078ea).withOpacity(.3),offset: Offset(0.0, 8.0),blurRadius: 8.0)]
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () async {
                              Navigator.of(context).push(new MaterialPageRoute(builder: (_) => ProdukMlmUI()));
                            },
                            child: Center(
                              child: Text("Masuk",style: TextStyle(color: Colors.white,fontFamily: "Rubik",fontSize: 16,fontWeight: FontWeight.bold,letterSpacing: 1.0)),
                            ),
                          ),
                        ),
                      ),
                      onTap: (){
                        Navigator.of(context).push(new MaterialPageRoute(builder: (_) => ProdukMlmUI()));
                      },
                    )
                  ],
                ),
            )
          ],
        )
    );
  }
}
