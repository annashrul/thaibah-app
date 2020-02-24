import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:thaibah/Model/islamic/asmaModel.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/config/api.dart';

import 'Homepage/index.dart';
import 'Widgets/pin_screen.dart';


class AsmaUI extends StatefulWidget {
  @override
  AsmaUIState createState() => new AsmaUIState();
}

class AsmaUIState extends State<AsmaUI> {
  Asma asma;
  bool isLoading = false;
  final GlobalKey<RefreshIndicatorState> _refresh = GlobalKey<RefreshIndicatorState>();



  @override
  void initState(){
    loadProduct();
  }

  Future<void> loadProduct() async {
    setState(() {
      isLoading = true;
    });
    var jsonString = await http.get(ApiService().baseUrl+'islamic/');
    if (jsonString.statusCode == 200) {
      // list = json.decode(response.body) as List
      final jsonResponse = json.decode(jsonString.body);
      asma = new Asma.fromJson(jsonResponse);
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load photos');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    // ApiService().getAsma().then((value) => print("value: $value"));
    List colors = [Colors.red, Colors.green, Colors.blue];
    Random random = new Random();
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
          title: new Text("Asmaul Husna", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
        ),
        body: isLoading ? ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return ListTile(
              leading: SkeletonFrame(width: 50.0,height: 50.0,),
              title: SkeletonFrame(width: MediaQuery.of(context).size.width/1,height: 16),
              subtitle:  SkeletonFrame(width: MediaQuery.of(context).size.width/1,height: 16),
              // trailing: Icon(Icons.more_vert),
              isThreeLine: false,
            );
          },
        ):
        asma.result.length > 0 ? RefreshIndicator(

          child: ListView.builder(
            itemCount: asma.result.length,
            itemBuilder: (context, index) {
              return Container(
                color: (index % 2 == 0) ? Colors.white : Color(0xFFF7F7F9),
                child: ListTile(
                  leading: Container(
                    alignment: Alignment.center,
                    width: 50.0,
                    height: 50.0,
                    padding: const EdgeInsets.all(5.0),
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors[random.nextInt(3)],
                    ),
                    child: new Text(asma.result[index].name, style: new TextStyle(color: Colors.white, fontSize: 13.0,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
                  ),
                  title: Text(asma.result[index].transliteration+' - '+asma.result[index].name, style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                  subtitle: Text(
                    asma.result[index].meaning,style: TextStyle(fontFamily: 'Rubik'),
                  ),
                  // trailing: Icon(Icons.more_vert),
                  isThreeLine: false,
                ),
              );
            },
          ),
          onRefresh: loadProduct,
          key: _refresh,
        ) : Container(
          child: Center(
            child: Text('Data Tidak Ada'),
          ),
        )
    );
  }
}