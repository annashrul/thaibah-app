import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:thaibah/Model/historyPenarikanModel.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/loadMoreQ.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/bloc/withdrawBloc.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:thaibah/Constants/constants.dart';

class HistoryPenarikan extends StatefulWidget {
  @override
  _HistoryPenarikanState createState() => _HistoryPenarikanState();
}

class _HistoryPenarikanState extends State<HistoryPenarikan> {
  final userRepository = UserRepository();
  bool isLoading = false;
  bool loadingLoadMore = false;
  int perpage=20;
  final GlobalKey<RefreshIndicatorState> _refresh = GlobalKey<RefreshIndicatorState>();

  Future _search() async{
    if(_tgl_pertama.text != '' && _tgl_kedua.text != ''){
      Timer(Duration(seconds: 1), () {
        setState(() {
          isLoading = false;
        });
      });
      historyPenarikanBloc.fetchHistoryPenarikan(1, perpage, _tgl_pertama.text, _tgl_kedua.text);
    }

  }

  void load() {
    setState(() {
      perpage = perpage += 20;
    });
    historyPenarikanBloc.fetchHistoryPenarikan(1, perpage,_tgl_pertama.text,_tgl_kedua.text);
  }
  Future<void> refresh() async {
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    load();
  }
  Future<bool> _loadMore() async {
    print("onLoadMore");
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    load();
    return true;
  }


  DateTime _dateTime;
  DateTimePickerLocale _locale = DateTimePickerLocale.id;
  TextEditingController _tgl_pertama = TextEditingController();
  TextEditingController _tgl_kedua = TextEditingController();
  @override
  void initState() {
    super.initState();
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    var formattedDate = "${dateParse.year}-${dateParse.month.toString().padLeft(2, '0')}-${dateParse.day.toString().padLeft(2, '0')}";
    _tgl_pertama.text = formattedDate;
    _tgl_kedua.text = formattedDate;
    _dateTime = DateTime.parse(formattedDate);
    historyPenarikanBloc.fetchHistoryPenarikan(1, perpage,_tgl_pertama.text,_tgl_kedua.text);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  final formatter = new NumberFormat("#,###");
  void _showDatePicker(var param) {
    DatePicker.showDatePicker(
      context,
      onMonthChangeStartWithFirstDate: true,
      pickerTheme: DateTimePickerTheme(
        showTitle: true,
        confirm: Text('Selesai', style: TextStyle(color: Colors.red,fontFamily: 'Rubik',fontWeight:FontWeight.bold)),
      ),
      minDateTime: DateTime.parse('2010-05-12'),
      maxDateTime: DateTime.parse('2100-01-01'),
      initialDateTime: _dateTime,
      dateFormat: 'yyyy-MM-dd',
      locale: _locale,
      onClose: () => print("----- onClose -----"),
      onCancel: () => print('onCancel'),
      onChange: (dateTime, List<int> index) {
        setState(() {
          _dateTime = dateTime;
        });
      },
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _dateTime = dateTime;
          if (param == '1') {
            _tgl_pertama.text = '${_dateTime.year}-${_dateTime.month.toString().padLeft(2, '0')}-${_dateTime.day.toString().padLeft(2, '0')}';
          } else {
            _tgl_kedua.text = '${_dateTime.year}-${_dateTime.month.toString().padLeft(2, '0')}-${_dateTime.day.toString().padLeft(2, '0')}';
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false);
    return Scaffold(
      appBar: UserRepository().appBarWithButton(context, "Riwayat Penarikan",(){Navigator.pop(context);},<Widget>[]),

      // appBar:UserRepository().appBarWithButton(context,"Riwayat Penarikan",warna1,warna2,(){Navigator.pop(context);},Container()),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top:10,left:10,right:10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Flexible(
                  child: GestureDetector(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        UserRepository().textQ("Dari",12,Colors.black,FontWeight.bold,TextAlign.left),
                        SizedBox(height: 10.0),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: TextFormField(
                            readOnly: true,
                            style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),fontWeight: FontWeight.bold,fontFamily: ThaibahFont().fontQ,color: Colors.grey),
                            controller: _tgl_pertama,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[200]),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              hintStyle: TextStyle(color: Colors.grey, fontSize:ScreenUtilQ.getInstance().setSp(30),fontFamily: ThaibahFont().fontQ),
                            ),
                            textInputAction: TextInputAction.done,
                            onTap: () {_showDatePicker('1');},
                            onChanged: (value) {
                              setState(() {
                                _tgl_pertama.text =
                                '${_dateTime.year}-${_dateTime.month.toString().padLeft(2, '0')}-${_dateTime.day.toString().padLeft(2, '0')}';
                              });
                            },
                          ),
                        ),


                      ],
                    ),
                  ),
                ),
                SizedBox(width: 5.0),
                new Flexible(
                  child:GestureDetector(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        UserRepository().textQ("Sampai",12,Colors.black,FontWeight.bold,TextAlign.left),
                        SizedBox(height: 10.0),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: TextFormField(
                            readOnly: true,
                            style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),fontWeight: FontWeight.bold,fontFamily: ThaibahFont().fontQ,color: Colors.grey),
                            controller: _tgl_kedua,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none,),
                              hintStyle: TextStyle(color: Colors.grey, fontSize:ScreenUtilQ.getInstance().setSp(30),fontFamily: ThaibahFont().fontQ),
                            ),
                            textInputAction: TextInputAction.done,
                            onTap: () {_showDatePicker('2');},
                            onChanged: (value) {
                              setState(() {
                                _tgl_kedua.text = '${_dateTime.year}-${_dateTime.month.toString().padLeft(2, '0')}-${_dateTime.day.toString().padLeft(2, '0')}';
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.only(left:10.0,right:10.0,top:10.0),
            child: UserRepository().buttonQ(context,(){
              setState(() {
                isLoading=true;
              });
              _search();
              }, 'cari'),
          ),
          Expanded(
            child: StreamBuilder(
              stream: historyPenarikanBloc.getResult,
              builder: (context, AsyncSnapshot<HistoryPenarikanModel> snapshot) {
                if (snapshot.hasData) {
                  return buildContent(snapshot, context);
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return Container(
                  margin: EdgeInsets.all(15.0),
                  child: ListView.builder(
                      itemCount:  6,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: Card(
                            color: Colors.transparent,
                            elevation: 0.0,
                            margin: new EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
                            child: Container(
                              decoration: BoxDecoration(color: Colors.white),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                                leading: Container(
                                  width: 90.0,
                                  height: 50.0,
                                  padding: EdgeInsets.all(10),
                                  child: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      minRadius: 150,
                                      maxRadius: 150,
                                      child: SkeletonFrame(width: 90.0,height: 90.0)
                                  ),
                                ),
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    SkeletonFrame(width: MediaQuery.of(context).size.width/4,height: 16.0,),
                                    SkeletonFrame(width: MediaQuery.of(context).size.width/4,height: 16.0,)
                                  ],
                                ),
                                subtitle: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    SkeletonFrame(width: MediaQuery.of(context).size.width/4,height: 16.0,),
                                    SkeletonFrame(width: MediaQuery.of(context).size.width/4,height: 16.0,)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildContent(AsyncSnapshot<HistoryPenarikanModel> snapshot, BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false);
    return snapshot.data.result.data.length>0?RefreshIndicator(
      child: Column(
        children: [
          Expanded(
              child: Container(
                margin: EdgeInsets.all(15.0),
                child: LoadMoreQ(
                  isFinish: snapshot.data.result.data.length < perpage,
                  child: ListView.builder(
                      itemCount:  snapshot.data.result.data.length,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        var cek; Color warna;
                        if(snapshot.data.result.data[index].status == 0){
                          cek = 'Pending';
                          warna = Colors.blueAccent;
                        }else if(snapshot.data.result.data[index].status == 1){
                          cek = 'Diterima';
                          warna = Colors.green;
                        }else{
                          cek = 'Ditolak';
                          warna = Colors.red;
                        }
                        return GestureDetector(
                          onTap: (){

                          },
                          child: Card(
                            elevation: 0.0,
                            margin: new EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
                            child: Container(
                              decoration: BoxDecoration(color: Colors.white),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    RichText(
                                      text: TextSpan(
                                          text: '${snapshot.data.result.data[index].accHolderName}',
                                          style: TextStyle(fontSize: 12,fontFamily:ThaibahFont().fontQ,color: Colors.black,fontWeight: FontWeight.bold),
                                          children: <TextSpan>[
                                            TextSpan(text: ' (${snapshot.data.result.data[index].accNumber})',style: TextStyle(color: Colors.grey, fontSize: 10,fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ)),
                                          ]
                                      ),
                                    ),
                                    RichText(text: TextSpan(text: '$cek', style: TextStyle(fontSize:12.0,fontFamily:ThaibahFont().fontQ,color:warna, fontWeight: FontWeight.bold),),),
                                  ],
                                ),
                                subtitle: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    RichText(text: TextSpan(text:"Rp ${formatter.format(int.parse(snapshot.data.result.data[index].amount))}", style: TextStyle(fontFamily:ThaibahFont().fontQ,color: Colors.red, fontWeight: FontWeight.bold))),
                                    RichText(text: TextSpan(text:"${DateFormat.yMd().add_jm().format(snapshot.data.result.data[index].createdAt.toLocal())}", style:TextStyle(fontSize:12.0,fontFamily:ThaibahFont().fontQ,color: Colors.grey, fontWeight: FontWeight.bold))),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                  ),
                  onLoadMore: _loadMore,
                  whenEmptyLoad: true,
                  delegate: DefaultLoadMoreDelegate(),
                  textBuilder: DefaultLoadMoreTextBuilder.english,
                ),
              )
          )
        ],
      ),
      onRefresh: refresh,
      key: _refresh,
    ):UserRepository().noData();
  }
}
