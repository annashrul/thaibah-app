import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/historyModel.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/loadMoreQ.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/bloc/transaction/historyBloc.dart';
//import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:thaibah/config/user_repo.dart';
import 'package:thaibah/config/dateRangePickerQ.dart' as DateRagePicker;

class HistoryVoucher extends StatefulWidget {
  @override
  _HistoryVoucherState createState() => _HistoryVoucherState();
}

class _HistoryVoucherState extends State<HistoryVoucher>{
  final GlobalKey<RefreshIndicatorState> _refresh = GlobalKey<RefreshIndicatorState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final userRepository = UserRepository();
  bool isLoading = false;
  int perpage=20;
  String label='voucher';
  DateTime _dateTime;
  DateTimePickerLocale _locale = DateTimePickerLocale.id;
  TextEditingController _tgl_pertama = TextEditingController();
  TextEditingController _tgl_kedua = TextEditingController();
  final searchController = TextEditingController();
  final FocusNode searchFocus       = FocusNode();
  Color warna1;
  Color warna2;
  Future loadTheme() async{
    final color1 = await userRepository.getDataUser('warna1');
    final color2 = await userRepository.getDataUser('warna2');
    setState(() {
      warna1 = hexToColors(color1);
      warna2 = hexToColors(color2);
    });
  }
  Future _search() async{
    setState(() {isLoading=true;});
    if (_tgl_pertama.text != 'yyyy-MM-dd') {
      _tgl_pertama.text = _tgl_pertama.text;
    }
    if (_tgl_kedua.text != 'yyyy-MM-dd') {
      _tgl_kedua.text = _tgl_kedua.text;
    }
    if(searchController.text!=''){
      searchController.text = searchController.text;
    }else{
      searchController.text = '';
    }
    historyBloc.fetchHistoryList(label, 1, perpage, _tgl_pertama.text,_tgl_kedua.text,searchController.text);
    Timer(Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });


  }
  void load() {
    setState(() {
      perpage = perpage += 20;
      isLoading=false;

    });
    historyBloc.fetchHistoryList(label, 1, perpage, _tgl_pertama.text,_tgl_kedua.text,searchController.text);
  }
  Future<void> refresh() async {
    Timer(Duration(seconds: 1), () {
      setState(() {
        isLoading = true;
      });
    });
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    load();
  }
  Future<bool> _loadMore() async {
    print("onLoadMore");
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    load();
    return true;
  }


  @override
  void initState() {
    super.initState();
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    var formattedDate = "${dateParse.year}-${dateParse.month.toString().padLeft(2, '0')}-${dateParse.day.toString().padLeft(2, '0')}";
    _tgl_pertama.text = formattedDate;
    _tgl_kedua.text = formattedDate;
    _dateTime = DateTime.parse(formattedDate);
    historyBloc.fetchHistoryList(label, 1, perpage, _tgl_pertama.text,_tgl_kedua.text,'');
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

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
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false)..init(context);
    return Column(
      children: <Widget>[
        Padding(padding: EdgeInsets.only(top:10)),
        Row(
          children: <Widget>[
            new Flexible(
              child: Padding(
                padding: EdgeInsets.only(left:17.0,top:0.0),
                child: GestureDetector(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Dari',style: TextStyle(color:Colors.black,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold,fontSize: ScreenUtilQ.getInstance().setSp(30))),
                      TextField(
                        style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),fontFamily: ThaibahFont().fontQ),
                        readOnly: true,
                        controller: _tgl_pertama,
                        keyboardType: TextInputType.url,
                        decoration: InputDecoration(
                          hintText: 'yyyy-MM-dd',
                          hintStyle: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),color: Colors.black26, fontWeight: FontWeight.bold, fontFamily: 'Rubik'),
                        ),
                        onTap: () {_showDatePicker('1');},
                        onChanged: (value) {
                          setState(() {
                            _tgl_pertama.text =
                            '${_dateTime.year}-${_dateTime.month.toString().padLeft(2, '0')}-${_dateTime.day.toString().padLeft(2, '0')}';
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            new Flexible(
              child: Padding(
                padding: EdgeInsets.only(left:8.0,top:0.0),
                child: GestureDetector(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Sampai',style: TextStyle(color:Colors.black,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold,fontSize: ScreenUtilQ.getInstance().setSp(30))),
                      TextField(
                        style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),fontFamily: ThaibahFont().fontQ),
                        readOnly: true,
                        controller: _tgl_kedua,
                        keyboardType: TextInputType.url,
                        decoration: InputDecoration(
                          hintText: 'yyyy-MM-dd',
                          hintStyle: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),color: Colors.black26, fontWeight: FontWeight.bold, fontFamily: 'Rubik'),
                        ),
                        onTap: () {_showDatePicker('2');},
                        onChanged: (value) {
                          setState(() {
                            _tgl_kedua.text = '${_dateTime.year}-${_dateTime.month.toString().padLeft(2, '0')}-${_dateTime.day.toString().padLeft(2, '0')}';
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            new Flexible(
              child: Padding(
                padding: EdgeInsets.only(left:8.0,right:17.0,top:0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Cari',style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),color:Colors.black,fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ),),
                    TextFormField(
                        autofocus: false,
                        style:TextStyle(fontSize: ScreenUtilQ.getInstance().setSp(30),fontFamily: ThaibahFont().fontQ),
                        decoration: InputDecoration(
                            hintText: 'Tulis Disini ...',
                            hintStyle: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),color:Colors.grey,fontFamily:ThaibahFont().fontQ)
                        ),
                        controller: searchController,
                        focusNode: searchFocus,
                        onFieldSubmitted: (term){
                          setState(() {
                            isLoading = true;
                          });
                          _search();
                        }
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left:0.0,right:0.0,top:0.0),
          child: UserRepository().buttonQ(context, warna1, warna2,(){_search();}, isLoading,'cari'),
        ),
        Expanded(
            child:  StreamBuilder(
              stream: historyBloc.getResult,
              builder: (context, AsyncSnapshot<HistoryModel> snapshot) {
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
  Widget buildContent(AsyncSnapshot<HistoryModel> snapshot, BuildContext context){
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false)..init(context);
    return snapshot.data.result.data.length > 0 ? isLoading ? _loading() : RefreshIndicator(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
                color: Colors.white,
                child:LoadMoreQ(
                  whenEmptyLoad: true,
                  delegate: DefaultLoadMoreDelegate(),
                  textBuilder: DefaultLoadMoreTextBuilder.english,
                  isFinish: snapshot.data.result.data.length < perpage,
                  child: ListView.builder(
                    itemCount: snapshot.data.result.data.length,
                    itemBuilder: (context, index) {
                      var hm = DateFormat.Hm().format(snapshot.data.result.data[index].createdAt.toLocal());
                      var ymd = DateFormat.yMd().format(snapshot.data.result.data[index].createdAt.toLocal());
                      return Padding(
                        padding: EdgeInsets.only(left:0, right: 0),
                        child: Card(
                            elevation: 0,
                            child: Container(
                                decoration: BoxDecoration(color: (index % 2 == 0) ? Colors.white : Color(0xFFF7F7F9)),
                                padding: EdgeInsets.all(5),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Html(data:hm, defaultTextStyle: TextStyle(fontFamily:ThaibahFont().fontQ,fontSize: 12, fontWeight: FontWeight.bold )),
                                            Html(data:ymd, defaultTextStyle: TextStyle(fontFamily:ThaibahFont().fontQ,fontSize:10),)
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(height: 40, width: 1, color: Colors.grey, margin: EdgeInsets.only(left: 5, right: 5),),
                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                        // mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(child: Html(data:snapshot.data.result.data[index].note, defaultTextStyle: TextStyle(fontSize:12,fontFamily:ThaibahFont().fontQ)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Icon(Icons.add,size: 12,),
                                                Text(snapshot.data.result.data[index].trxIn, style: TextStyle(fontFamily:ThaibahFont().fontQ,color:Colors.green,fontSize:ScreenUtilQ.getInstance().setSp(28), fontWeight: FontWeight.bold)),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Icon(const IconData(0xe15b, fontFamily: 'MaterialIcons'),
                                                  color: Colors.black,size: 12,
                                                ),
                                                Text(snapshot.data.result.data[index].trxOut, style: TextStyle(fontFamily:ThaibahFont().fontQ,color:Colors.red,fontSize:ScreenUtilQ.getInstance().setSp(28), fontWeight: FontWeight.bold)),
                                              ],
                                            ),
                                          ],
                                        )
                                    )
                                  ],
                                )
                            )
                        ),
                      );
                    },
                  ),
                  onLoadMore: _loadMore,
                )
            ),
          ),
        ],
      ),
      onRefresh: refresh,
      key: _refresh,
    ) : Container(child: Center(child: Text("Data Tidak Tersedia",style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(40),fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold))));

  }
  Widget _loading() {
    return ListView.builder(
      itemCount: 10,
      physics: ClampingScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(left:5, right: 5),
          child: Card(
              elevation: 0.0,
              child: Container(
                  decoration: BoxDecoration(color: (index % 2 == 0) ? Colors.white : Color(0xFFF7F7F9)),
                  padding: EdgeInsets.all(5),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SkeletonFrame(width: MediaQuery.of(context).size.width/4,height: 16),
                              SkeletonFrame(width: MediaQuery.of(context).size.width/4,height: 16),
                            ],
                          ),
                        ),
                      ),
                      Container(height: 40, width: 1, color: Colors.grey, margin: EdgeInsets.only(left: 5, right: 5),),
                      Expanded(
                        flex: 4,
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child:SkeletonFrame(width: MediaQuery.of(context).size.width/2,height: 16),
                            ),
                          ],),
                      ),
                      Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  SkeletonFrame(width: MediaQuery.of(context).size.width/4,height: 16),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  SkeletonFrame(width: MediaQuery.of(context).size.width/4,height: 16),
                                ],
                              ),
                            ],
                          )
                      )
                    ],
                  )
              )
          ),
        );
      },
    );
  }
}
