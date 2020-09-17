import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/depositManual/historyDepositModel.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/loadMoreQ.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/component/History/detailDeposit.dart';
import 'package:thaibah/bloc/depositManual/listAvailableBankBloc.dart';
import 'package:thaibah/config/dateRangePickerQ.dart' as DateRagePicker;
import 'package:thaibah/config/user_repo.dart';

class HistoryDeposit extends StatefulWidget {
  String saldo;
  HistoryDeposit({this.saldo});
  @override
  _HistoryDepositState createState() => _HistoryDepositState();
}

class _HistoryDepositState extends State<HistoryDeposit> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool isLoading = false;
  bool loadingLoadMore = false;
  int perpage=20;
  var total=0;

  Future _search() async{
    if(_tgl_pertama.text != '' && _tgl_kedua.text != ''){
      UserRepository().loadingQ(context);
      await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
      Navigator.of(context).pop();
      historyDepositBloc.fetchHistoryDeposit(1, perpage, _tgl_pertama.text, _tgl_kedua.text);
    }
  }
  void load() {
    setState(() {
      perpage = perpage += 20;
    });
    historyDepositBloc.fetchHistoryDeposit(1, perpage,_tgl_pertama.text,_tgl_kedua.text);
  }
  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    load();
  }
  Future<bool> _loadMore() async {
    print("onLoadMore");
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    load();
    return true;
  }

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
    super.initState();
    loadTheme();
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    var formattedDate = "${dateParse.year}-${dateParse.month.toString().padLeft(2, '0')}-${dateParse.day.toString().padLeft(2, '0')}";
    _tgl_pertama.text = formattedDate;
    _tgl_kedua.text = formattedDate;
    _dateTime = DateTime.parse(formattedDate);
    historyDepositBloc.fetchHistoryDeposit(1, perpage,_tgl_pertama.text,_tgl_kedua.text);

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
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
  Widget build(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false);
    return Scaffold(
      key: _scaffoldKey,
      appBar: UserRepository().appBarWithButton(context,"Riwayat Top Up",warna1,warna2,(){Navigator.pop(context);},Container()),
      body: Column(
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
                        TextField(
                          style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),fontFamily: ThaibahFont().fontQ),
                          readOnly: true,
                          controller: _tgl_pertama,
                          keyboardType: TextInputType.url,
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                            ),
                            labelText: 'Dari',
                            labelStyle: TextStyle(fontWeight:FontWeight.bold,color: Colors.black, fontSize:ScreenUtilQ.getInstance().setSp(40),fontFamily: ThaibahFont().fontQ),
                            hintStyle: TextStyle(color: Colors.grey, fontSize:ScreenUtilQ.getInstance().setSp(30),fontFamily: ThaibahFont().fontQ),
                            hintText: 'yyyy-MM-dd',
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
                  padding: EdgeInsets.only(left:8.0,right:15.0,top:0.0),
                  child: GestureDetector(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Text('Sampai',style: TextStyle(color:Colors.black,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold,fontSize: ScreenUtilQ.getInstance().setSp(30))),
                        TextField(
                          style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),fontFamily: ThaibahFont().fontQ),
                          readOnly: true,
                          controller: _tgl_kedua,
                          keyboardType: TextInputType.url,
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                            ),
                            labelText: 'Sampai',
                            labelStyle: TextStyle(fontWeight:FontWeight.bold,color: Colors.black, fontSize:ScreenUtilQ.getInstance().setSp(40),fontFamily: ThaibahFont().fontQ),
                            hintStyle: TextStyle(color: Colors.grey, fontSize:ScreenUtilQ.getInstance().setSp(30),fontFamily: ThaibahFont().fontQ),
                            hintText: 'yyyy-MM-dd',
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
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left:0.0,right:0.0,top:0.0),
            child: UserRepository().buttonQ(context, warna1, warna2,(){
              _search();
            }, false,'cari'),
          ),
          Expanded(
            child: StreamBuilder(
              stream: historyDepositBloc.getResult,
              builder: (context, AsyncSnapshot<HistoryDepositModel> snapshot) {
                if (snapshot.hasData) {
                  return buildContent(snapshot, context);
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return UserRepository().loadingWidget();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildContent(AsyncSnapshot<HistoryDepositModel> snapshot, BuildContext context) {
    return snapshot.data.result.data.length>0?LiquidPullToRefresh(
        color: Colors.transparent,
        backgroundColor:ThaibahColour.primary2,
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
                      Navigator.of(context, rootNavigator: true).push(
                        new CupertinoPageRoute(builder: (context) => DetailDeposit(
                          amount: snapshot.data.result.data[index].amount,
                          bank_name: snapshot.data.result.data[index].bankName,
                          atas_nama: snapshot.data.result.data[index].atasNama,
                          no_rekening: snapshot.data.result.data[index].noRekening,
                          id_deposit: snapshot.data.result.data[index].idDeposit,
                          picture: snapshot.data.result.data[index].picture,
                          status: snapshot.data.result.data[index].status,
                          created_at: DateFormat.yMMMd().add_jm().format(snapshot.data.result.data[index].createdAt.toLocal()),
                          bukti: snapshot.data.result.data[index].bukti,
                          saldo: widget.saldo,
                        )),
                      );
                    },
                    child: Card(
                      elevation: 0.0,
                      margin: new EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                          leading: CircleAvatar(
                            minRadius: 20,
                            maxRadius: 20,
                            child: CachedNetworkImage(
                              imageUrl: snapshot.data.result.data[index].picture,
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))),
                              ),
                              errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                              imageBuilder: (context, imageProvider) => Container(
                                decoration: BoxDecoration(
                                  borderRadius: new BorderRadius.circular(0.0),
                                  color: Colors.white,
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              UserRepository().textQ(snapshot.data.result.data[index].bankName, 12, Colors.black, FontWeight.bold,TextAlign.left),
                              UserRepository().textQ(cek, 12, warna, FontWeight.bold,TextAlign.left)
                            ],
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              UserRepository().textQ(snapshot.data.result.data[index].amount, 12, Colors.red, FontWeight.bold,TextAlign.left),
                              UserRepository().textQ(DateFormat.yMd().add_jm().format(snapshot.data.result.data[index].createdAt.toLocal()), 10, Colors.grey, FontWeight.bold,TextAlign.left),
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
        ),
        onRefresh: _refresh
    ):UserRepository().noData();
  }


}


