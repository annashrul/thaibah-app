import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/historyModel.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/loadMoreQ.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/bloc/transaction/historyBloc.dart';
import 'package:thaibah/config/user_repo.dart';

class WidgetHistoryTransaksi extends StatefulWidget {
  final String label;
  WidgetHistoryTransaksi({this.label});
  @override
  _WidgetHistoryTransaksiState createState() => _WidgetHistoryTransaksiState();
}

class _WidgetHistoryTransaksiState extends State<WidgetHistoryTransaksi> {
  final GlobalKey<RefreshIndicatorState> _refresh = GlobalKey<RefreshIndicatorState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final userRepository = UserRepository();
  bool isLoading = false;
  int perpage=20;
  DateTime _dateTime;
  DateTimePickerLocale _locale = DateTimePickerLocale.id;
  TextEditingController _tgl_pertama = TextEditingController();
  TextEditingController _tgl_kedua = TextEditingController();
  final searchController = TextEditingController();
  final FocusNode searchFocus       = FocusNode();
  Future _search() async{
    setState(() {isLoading=true;});
    if (_tgl_pertama.text != 'yyyy-MM-dd') {
      _tgl_pertama.text = _tgl_pertama.text;
    }
    if (_tgl_kedua.text != 'yyyy-MM-dd') {
      _tgl_kedua.text = _tgl_kedua.text;
    }
    if(searchController.text!=''||searchController.text!='tulis disini ...'){
      searchController.text = searchController.text;
    }else{
      searchController.text = '';
    }
    historyBloc.fetchHistoryList(widget.label, 1, perpage, _tgl_pertama.text,_tgl_kedua.text,searchController.text);
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
    historyBloc.fetchHistoryList(widget.label, 1, perpage, _tgl_pertama.text,_tgl_kedua.text,searchController.text);
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
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    var formattedDate = "${dateParse.year}-${dateParse.month.toString().padLeft(2, '0')}-${dateParse.day.toString().padLeft(2, '0')}";
    _tgl_pertama.text = formattedDate;
    _tgl_kedua.text = formattedDate;
    _dateTime = DateTime.parse(formattedDate);
    historyBloc.fetchHistoryList(widget.label, 1, perpage, _tgl_pertama.text,_tgl_kedua.text,'');
  }
  @override
  Widget build(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false)..init(context);
    return Column(
      children: <Widget>[
        Padding(padding: EdgeInsets.only(top:10)),
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
              SizedBox(width: 5.0),
              new Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      UserRepository().textQ("Cari",12,Colors.black,FontWeight.bold,TextAlign.left),
                      SizedBox(height: 10.0),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: TextFormField(
                            style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),fontWeight: FontWeight.bold,fontFamily: ThaibahFont().fontQ,color: Colors.grey),
                            controller: searchController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none,),
                              hintStyle: TextStyle(color: Colors.grey, fontSize:ScreenUtilQ.getInstance().setSp(30),fontFamily: ThaibahFont().fontQ),
                            ),
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (term){
                              setState(() {
                                isLoading = true;
                              });
                              _search();
                            }
                        ),
                      ),
                    ],
                  )
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left:10.0,right:10.0,top:10.0),
          child: UserRepository().buttonQ(context,(){_search();},'cari'),
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
    return snapshot.data.result.data.length > 0 ? LiquidPullToRefresh(
      color: Colors.transparent,
      backgroundColor:ThaibahColour.primary2,
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
                                      flex: 2,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Html(data:hm, defaultTextStyle: TextStyle(fontFamily:ThaibahFont().fontQ,fontSize: 10, fontWeight: FontWeight.bold )),
                                            Html(data:ymd, defaultTextStyle: TextStyle(fontFamily:ThaibahFont().fontQ,fontSize:10),)
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(height: 40, width: 1, color: Colors.grey, margin: EdgeInsets.only(left: 5, right: 5),),
                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(child: Html(data:snapshot.data.result.data[index].note, defaultTextStyle: TextStyle(fontSize:10,fontFamily:ThaibahFont().fontQ)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        flex: 3,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Icon(Icons.add,size: 12,),
                                                UserRepository().textQ(snapshot.data.result.data[index].trxIn, 10, Colors.green, FontWeight.bold,TextAlign.left)
                                                // Text(snapshot.data.result.data[index].trxIn, style: TextStyle(fontFamily:ThaibahFont().fontQ,color:Colors.green,fontSize:ScreenUtilQ.getInstance().setSp(28), fontWeight: FontWeight.bold)),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Icon(const IconData(0xe15b, fontFamily: 'MaterialIcons'),
                                                  color: Colors.black,size: 12,
                                                ),
                                                UserRepository().textQ(snapshot.data.result.data[index].trxOut, 10, Colors.red, FontWeight.bold,TextAlign.left)
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
    ) : UserRepository().noData();
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
                        flex: 2,
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SkeletonFrame(width: MediaQuery.of(context).size.width/4,height: 16),
                              SizedBox(height: 5.0),
                              SkeletonFrame(width: MediaQuery.of(context).size.width/4,height: 16),
                            ],
                          ),
                        ),
                      ),
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
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SkeletonFrame(width: MediaQuery.of(context).size.width/4,height: 16),
                              SizedBox(height: 5.0),
                              SkeletonFrame(width: MediaQuery.of(context).size.width/4,height: 16),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
              )
          ),
        );
      },
    );
  }
}
