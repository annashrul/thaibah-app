import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:thaibah/Model/islamic/kalenderHijriahModel.dart';
import 'package:thaibah/UI/Widgets/HIJRI/umm_alqura_calendar.dart';
import 'package:thaibah/bloc/islamic/islamicBloc.dart';
import 'package:thaibah/config/style.dart';

class Kalender extends StatefulWidget {
  @override
  _KalenderState createState() => _KalenderState();
}

var islamicDate = ummAlquraCalendarQ.now();

class _KalenderState extends State<Kalender> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  var hariHijriah = islamicDate.hDay;
  var bulanHijriah = islamicDate.hMonth;
  var tahunHijriah = islamicDate.hYear;
  int cek = 1;
  String bulanHijri='';
  String title = '';
  String titleBulan = '';
  Future selanjutnya() async {
    if(islamicDate.hMonth.toString().length == 1){
      bulanHijri = "0${islamicDate.hMonth}";
    }else{
      bulanHijri = "${islamicDate.hMonth}";
    }
    if(bulanHijriah == 12){
      bulanHijriah = 01;
      tahunHijriah = tahunHijriah+1;
      print(bulanHijriah);
      print(tahunHijriah);
      setState((){
        isLoading = false;
        titleBulan    = namaBulan(bulanHijriah.toString());
        title         = "${bulanHijriah.toString()}/${tahunHijriah.toString()}";
      });
      kalenderHijriahBloc.fetchKalenderHijriah(bulanHijriah,tahunHijriah);

    }else{
      bulanHijriah = bulanHijriah+1;
      setState((){
        isLoading = false;
        titleBulan    = namaBulan(bulanHijriah.toString());
        title         = "${bulanHijriah.toString()}/${islamicDate.hYear.toString()}";
      });
      kalenderHijriahBloc.fetchKalenderHijriah(bulanHijriah,tahunHijriah);
    }
  }
  Future sebelumnya() async {
    if(islamicDate.hMonth.toString().length == 1){
      bulanHijri = "0${islamicDate.hMonth}";
    }else{
      bulanHijri = "${islamicDate.hMonth}";
    }

    if(bulanHijriah == 12){
      bulanHijriah = 1;
      tahunHijriah = tahunHijriah-1;
      print("${bulanHijriah}- ${tahunHijriah}");
      this.setState((){
        isLoading = false;
        titleBulan    = namaBulan(bulanHijriah.toString());
        title         = "${bulanHijriah.toString()}/${tahunHijriah.toString()}";
      });
      kalenderHijriahBloc.fetchKalenderHijriah(bulanHijriah,tahunHijriah);
    }else{
//      bulanHijriah = bulanHijriah-1;
//      if(bulanHijriah < 0){
//        bulanHijriah = 12;
//      }
      bulanHijriah = bulanHijriah-1;
      print("${bulanHijriah}- ${tahunHijriah}");
      this.setState((){
        isLoading = false;
        titleBulan    = namaBulan(bulanHijriah.toString());
        title         = "${bulanHijriah.toString()}/${tahunHijriah.toString()}";
      });
      kalenderHijriahBloc.fetchKalenderHijriah(bulanHijriah,tahunHijriah);
    }
  }

  void sekarang() async{
    if(islamicDate.hMonth.toString().length == 1){
      bulanHijri = "0${islamicDate.hMonth}";
    }else{
      bulanHijri = "${islamicDate.hMonth}";
    }
    setState(() {
      titleBulan    = namaBulan(islamicDate.hMonth.toString());
      title         = "${islamicDate.hMonth.toString()}/${islamicDate.hYear.toString()}";
    });

    kalenderHijriahBloc.fetchKalenderHijriah(bulanHijri,islamicDate.hYear);
  }

  namaBulan(String bulan){
    if(bulanHijriah == 1||bulanHijriah == 01){
      bulan = 'Muharam';
    }else if(bulanHijriah == 2||bulanHijriah == 02){
      bulan = 'Safar';
    }else if(bulanHijriah == 3||bulanHijriah == 03){
      bulan = 'Rabiul Awal';
    }else if(bulanHijriah == 4||bulanHijriah == 04){
      bulan = 'Rabiul Akhir';
    }else if(bulanHijriah == 5||bulanHijriah == 05){
      bulan = 'Jumadil Awal';
    }else if(bulanHijriah == 6||bulanHijriah == 06){
      bulan = 'Jumadil Akhir';
    }else if(bulanHijriah == 7||bulanHijriah == 07){
      bulan = 'Rajab';
    }else if(bulanHijriah == 8||bulanHijriah == 08){
      bulan = 'Syakban';
    }else if(bulanHijriah == 9||bulanHijriah == 09){
      bulan = 'Ramadhan';
    }else if(bulanHijriah == 10){
      bulan = 'Syawal';
    }else if(bulanHijriah == 11){
      bulan = 'Zulkaidah';
    }else if(bulanHijriah == 12){
      bulan = 'Zulhijah';
    }
    return bulan;
  }




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sekarang();
//    print("${hariSekarang}-${bulanSekarang}-${tahunSekarang}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar:  AppBar(
        actions: <Widget>[
          InkWell(
            child: Container(
              margin: EdgeInsets.only(left: 10.0,right:20.0,top:20.0),
              child: Column(
                children: <Widget>[
                  Text("$title"),
                  Text("$titleBulan"),
                ],
              ),
            ),
          )
        ],
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: false,
        elevation: 0.0,
        title: Text('Kalender Islam',style: TextStyle(color: Colors.white,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
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
      ),
      body: StreamBuilder(
        stream: kalenderHijriahBloc.getResult,
        builder: (context, AsyncSnapshot<KalenderHijriahModel> snapshot) {
          if (snapshot.hasData) {
            return buildContent(snapshot, context);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
      bottomNavigationBar: _bottomNavBarBeli(context),

    );
  }







  Widget buildContent(AsyncSnapshot<KalenderHijriahModel> snapshot, BuildContext context) {
    return isLoading ? CircularProgressIndicator(): Container(
      child: Padding(
          padding: const EdgeInsets.only(top:20.0,left:0.0,right:0.0,bottom:5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex:1,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left:5.0,right:5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text('الأحد'),
                                  Text('الإثنين'),
                                  Text('الثلاثاء'),
                                  Text('الأربعاء'),
                                  Text('الخميس'),
                                  Text('الجمعة'),
                                  Text('السبت'),

                                ],
                              ),
                            )
                          ),
                          Expanded(
                            child: StaggeredGridView.countBuilder(
                              primary: false,
                              physics: ScrollPhysics(),
                              crossAxisCount: 7,
                              mainAxisSpacing: 2.0,
                              crossAxisSpacing: 2.0,
                              itemCount: snapshot.data.result.data.length,
                              itemBuilder: (context, index) {
//                                print(index);
                                Color warna; Color warnaText;
//                                print("#################################### CEK ###########################");

//                                print(snapshot.data.result.data[index].hijri.date);
//                                print("${islamicDate.hDay}-${bulanHijri}-${islamicDate.hYear}");
                                if(snapshot.data.result.data[index].hijri.date == "${islamicDate.hDay}-${bulanHijri}-${islamicDate.hYear}"){
                                  warna = Colors.green;
                                  warnaText = Colors.white;
                                }else{
                                  warnaText = Colors.green;
                                }
                                return Container(
                                  padding: EdgeInsets.all(10.0),
                                  color:warna,
                                  child: Column(
                                    children: <Widget>[
                                      Text("${snapshot.data.result.data[index].hijri.dayArabic==null?'':snapshot.data.result.data[index].hijri.dayArabic}",style: TextStyle(color:warnaText,fontFamily: 'Rubik',fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                );
                              },
                              staggeredTileBuilder: (index) => new StaggeredTile.fit(1),
                            )
                          )
                        ],
                      )
                    ),
                    Expanded(flex:3,child:  Text(''),),
                    Container(
                      padding: EdgeInsets.only(left:10.0,right:10.0),
                      child: Text('Hari Besar Islam',style: TextStyle(fontSize:16.0,color:Colors.red,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                        flex: 5,
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          child: ListView.builder(
                              itemCount: snapshot.data.result.holiday.length,
                              itemBuilder: (context,index){
                                if(snapshot.data.result.holiday.length > 0){
                                  return Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text('${snapshot.data.result.holiday[index].title}',style: TextStyle(fontSize:14.0,color:Colors.green,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                                          Text(''),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text('${snapshot.data.result.holiday[index].hijri}',style: TextStyle(fontSize:12.0,color:Colors.grey,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                                          Text('${snapshot.data.result.holiday[index].date}'),
                                        ],
                                      ),
                                      Divider()
                                    ],
                                  );
                                }else{
                                  return Container(
                                    child: Center(
                                      child: Text("Tidak Ada Data"),
                                    ),
                                  );
                                }
                              }
                          ),
                        )
                    )
                  ],
                )
              )
            ],
          )
      ),
    );
  }

  Widget buildHoliday(BuildContext context){
    StreamBuilder(
      stream: kalenderHijriahBloc.getResult,
      builder: (context, AsyncSnapshot<KalenderHijriahModel> snapshot) {
        if (snapshot.hasData) {
          return Expanded(
              flex: 5,
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: ListView.builder(
                    itemCount: snapshot.data.result.holiday.length,
                    itemBuilder: (context,index){
                      return Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('${snapshot.data.result.holiday[index].title}',style: TextStyle(fontSize:14.0,color:Colors.green,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                              Text(''),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('1 Muharram 1441',style: TextStyle(fontSize:12.0,color:Colors.grey,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                              Text('31 Desember'),
                            ],
                          ),
                          Divider()
                        ],
                      );
                    }
                ),
              )
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }

        return CircularProgressIndicator();
      },
    );
  }


  Widget _bottomNavBarBeli(BuildContext context){
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
              height: kBottomNavigationBarHeight,
              child: FlatButton(
                shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(10)),
                ),
                color: Styles.primaryColor,
                onPressed: (){
                  setState(() {
                    isLoading = true;
                  });
                  sebelumnya();
                },
                child: isLoading?CircularProgressIndicator():Text("Sebelumnya", style: TextStyle(color: Colors.white)),
              )
          ),
          Container(
              height: kBottomNavigationBarHeight,
              child: FlatButton(
                shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10)),
                ),
                color: Styles.primaryColor,
                onPressed: (){
                  setState(() {
                    isLoading = true;
                  });
                  selanjutnya();
                },
                child: Text("Selanjutnya", style: TextStyle(color: Colors.white)),
              )
          )

        ],
      ),
    );
  }

}
class CircleButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final String title;

  const CircleButton({Key key, this.onTap, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double size = 50.0;

    return new InkResponse(
      onTap: onTap,
      child: new Container(
        width: size,
        height: size,
        decoration: new BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Text(title),
      ),
    );
  }
}