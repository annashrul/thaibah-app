import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/historyPembelianSuplemen.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/loadMoreQ.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/component/History/detailHistorySuplemen.dart';
import 'package:thaibah/bloc/historyPembelianBloc.dart';
//import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:thaibah/config/dateRangePickerQ.dart' as DateRagePicker;
import 'package:thaibah/config/user_repo.dart';

class HistorySuplemen extends StatefulWidget {
  @override
  _HistorySuplemenState createState() => _HistorySuplemenState();
}

class _HistorySuplemenState extends State<HistorySuplemen> {
  bool isLoading = false;
  bool loadingLoadMore = false;
  int perpage=12;
  Future _search() async{
    if(_tgl_pertama.text != '' && _tgl_kedua.text != ''){
      Timer(Duration(seconds: 1), () {
        setState(() {
          isLoading = false;
        });
      });
      historyPembelianSuplemenBloc.fetchHistoryPemblianSuplemenList(1, perpage, _tgl_pertama.text, _tgl_kedua.text);
    }

  }


  void load() {
    print("load $perpage");
    setState(() {
      perpage = perpage += perpage;
    });
    historyPembelianSuplemenBloc.fetchHistoryPemblianSuplemenList(1,perpage,_tgl_pertama.text,_tgl_kedua.text);
  }



  Future<void> _refresh() async {
    setState(() {
      isLoading=true;
    });
    _search();
  }
  Future<bool> _loadMore() async {
    print("onLoadMore");
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    load();
    return true;
  }

  final userRepository=UserRepository();


  DateTime _dateTime;
  DateTimePickerLocale _locale = DateTimePickerLocale.id;
  TextEditingController _tgl_pertama = TextEditingController();
  TextEditingController _tgl_kedua = TextEditingController();
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
  void initState() {
    super.initState();
    initializeDateFormatting('id');
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    var formattedDate = "${dateParse.year}-${dateParse.month.toString().padLeft(2, '0')}-${dateParse.day.toString().padLeft(2, '0')}";
    _tgl_pertama.text = formattedDate;
    _tgl_kedua.text = formattedDate;
    _dateTime = DateTime.parse(formattedDate);
    historyPembelianSuplemenBloc.fetchHistoryPemblianSuplemenList(1, perpage,_tgl_pertama.text,_tgl_kedua.text);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false)..init(context);
    return Column(
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
          child: UserRepository().buttonQ(context,(){setState(() {
            isLoading=true;
          });_search();},'cari'),
        ),

        Expanded(
            child:  StreamBuilder(
              stream: historyPembelianSuplemenBloc.getResult,
              builder: (context, AsyncSnapshot<HistoryPembelianSuplemenModel> snapshot) {
                if (snapshot.hasData) {
                  return buildContent(snapshot, context);
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return _loading();
              },
            )
        ),

      ],
    );
  }

  Widget buildContent(AsyncSnapshot<HistoryPembelianSuplemenModel> snapshot, BuildContext context) {
    return snapshot.data.result.data.length > 0 ? isLoading ? _loading() : Column(
      children: <Widget>[
        Expanded(
            child: RefreshIndicator(
                child: Container(
                  margin: EdgeInsets.all(15.0),
                  child: LoadMoreQ(
                    child: ListView.builder(
                        itemCount:  snapshot.data.result.data.length,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          var kdTrx = "";
                          var status = '';
                          Color statColor;
                          if (snapshot.data.result.data[index].kdTrx != null) {
                            kdTrx = snapshot.data.result.data[index].kdTrx;
                          } else {
                            kdTrx = "kosong";
                          }
                          if (snapshot.data.result.data[index].status == 1) {
                            status = 'proses';
                            statColor = Colors.deepOrangeAccent;
                          } else if (snapshot.data.result.data[index].status == 3) {
                            status = 'dikirim';
                            statColor = Colors.blueAccent;
                          } else if (snapshot.data.result.data[index].status == 4) {
                            status = 'diterima';
                            statColor = Colors.green;
                          } else {
                            status = '';
                          }
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context, rootNavigator: true).push(
                                new CupertinoPageRoute(builder: (context) => DetailHistorySuplemen(resi:snapshot.data.result.data[index].resi,id: snapshot.data.result.data[index].id, status:snapshot.data.result.data[index].status,param: 'index',)),
                              );
                            },
                            child: accountItems(
                                "",
                                "$kdTrx",
                                "${status}",
                                statColor,
                                snapshot.data.result.data[index].price.toString(),
                                DateFormat.yMMMMEEEEd('id').add_jm().format(snapshot.data.result.data[index].createdAt.toLocal()),
                                oddColour: (index % 2 == 0) ? Colors.white : Color(0xFFF7F7F9)
                            ),
                          );
                        }
                    ),
                    isFinish: snapshot.data.result.data.length < perpage,
                    onLoadMore: _loadMore,
                    whenEmptyLoad: true,
                    delegate: DefaultLoadMoreDelegate(),
                    textBuilder: DefaultLoadMoreTextBuilder.english,
                  ),
                ),
                onRefresh: _refresh
            )
        ),

      ],
    ) : UserRepository().noData();
  }

  Widget _loading(){
    return Container(
      margin: EdgeInsets.all(15.0),
      child: ListView.builder(
          itemCount: 7,
          shrinkWrap: true,
          physics: ScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index){
            return GestureDetector(
              child: Container(
                decoration: BoxDecoration(color: Colors.white),
                padding:EdgeInsets.only(top: 20.0, bottom: 20.0, left: 5.0, right: 5.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SkeletonFrame(width: MediaQuery.of(context).size.width/3,height: 16),
                        SkeletonFrame(width: MediaQuery.of(context).size.width/3,height: 16),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SkeletonFrame(width: MediaQuery.of(context).size.width/3,height: 16),
                        SkeletonFrame(width: MediaQuery.of(context).size.width/3,height: 16),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
      ),
    );
  }


  Container accountItems(String kdTrx, String item, String charge, Color statColor, String dateString, String type,{Color oddColour = Colors.white}) => Container(
    decoration: BoxDecoration(color: oddColour),
    padding:EdgeInsets.only(top: 20.0, bottom: 20.0, left: 5.0, right: 5.0),
    child: Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            RichText(text: TextSpan(text:item, style: TextStyle(fontSize: 12.0,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold,color:Colors.black))),
            RichText(text: TextSpan(text:charge, style: TextStyle(fontSize: 12.0,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold,color:statColor))),
          ],
        ),
        SizedBox(
          height: 20.0,
          child: RichText(text: TextSpan(text:kdTrx, style: TextStyle(color: Colors.green,fontFamily:ThaibahFont().fontQ,fontSize: 12,fontWeight: FontWeight.bold))),
          // child: Text(kdTrx,style: TextStyle(color: Colors.green,fontFamily:ThaibahFont().fontQ,fontSize: 12,fontWeight: FontWeight.bold)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            RichText(text: TextSpan(text:dateString, style: TextStyle(color: Colors.grey, fontSize: 12.0,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold))),
            RichText(text: TextSpan(text:type, style: TextStyle(color: Colors.grey, fontSize: 12.0,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold))),
          ],
        ),
      ],
    ),
  );
}

