import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thaibah/Model/historyModel.dart';
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
  bool loadingLoadMore = false;
  String label  = 'Periode';
  String from   = '';
  String to     = '';
  String param = 'voucher';
  int perpage=20;
  var total=0;
  var fromHari = DateFormat.d().format( DateTime.now());
  var toHari = DateFormat.d().format( DateTime.now());
  var fromBulan = DateFormat.M().format( DateTime.now());
  var toBulan = DateFormat.M().format( DateTime.now());
  var tahun = DateFormat.y().format( DateTime.now());
  final searchController = TextEditingController();
  final dateController = TextEditingController();
  final FocusNode searchFocus = FocusNode();
  Future<Null> _selectDate(BuildContext context) async{
    final List<DateTime> picked = await DateRagePicker.showDatePickerQ(
        context: context,
        initialFirstDate: new DateTime.now(),
        initialLastDate: (new DateTime.now()).add(new Duration(days: 1)),
        firstDate: new DateTime(2015),
        lastDate: new DateTime(2100)
    );
    if (picked != null && picked.length == 2) {
      setState(() {
        isLoading=true;
      });
      print(isLoading);
      setState(() {
        isLoading=false;
        from  = "${picked[0].year}-${picked[0].month}-${picked[0].day}";
        to    = "${picked[1].year}-${picked[1].month}-${picked[1].day}";
        label = "${from} ${to}";
        dateController.text = label;
      });
      print(isLoading);
    }
  }
  Future _search() async{
    DateTime today = new DateTime.now();
    DateTime fiftyDaysAgo = today.subtract(new Duration(days: 30));
    if(dateController.text != '' && searchController.text != ''){
      Timer(Duration(seconds: 1), () {
        setState(() {
          isLoading = false;
        });
      });
      historyBloc.fetchHistoryList(param, 1, perpage, '$from','$to',searchController.text);
    }
    if(dateController.text != '' && searchController.text == ''){
      Timer(Duration(seconds: 1), () {
        setState(() {
          isLoading = false;
        });
      });
      historyBloc.fetchHistoryList(param, 1, perpage, '$from','$to','');
    }
    if(dateController.text == '' && searchController.text != ''){
      Timer(Duration(seconds: 1), () {
        setState(() {
          isLoading = false;
        });
      });
      historyBloc.fetchHistoryList(param, 1, perpage, fiftyDaysAgo,'$tahun-$toBulan-$toHari',searchController.text);
    }
    if(dateController.text == '' && searchController.text == ''){
      Timer(Duration(seconds: 1), () {
        setState(() {
          isLoading = false;
        });
      });
      historyBloc.fetchHistoryList(param, 1, perpage, fiftyDaysAgo,'$tahun-$toBulan-$toHari','');
    }
  }
  void load() {
    print("load $perpage");
    setState(() {
      perpage = perpage += 20;
      isLoading = false;
    });
    DateTime today = new DateTime.now();
    DateTime fiftyDaysAgo = today.subtract(new Duration(days: 30));
    if(dateController.text != '' && searchController.text != ''){
      historyBloc.fetchHistoryList(param, 1, perpage, '$from','$to',searchController.text);
    }
    if(dateController.text != '' && searchController.text == ''){
      historyBloc.fetchHistoryList(param, 1, perpage, '$from','$to','');
    }
    if(dateController.text == '' && searchController.text != ''){
      historyBloc.fetchHistoryList(param, 1, perpage, fiftyDaysAgo,'$tahun-$toBulan-$toHari',searchController.text);
    }
    if(dateController.text == '' && searchController.text == ''){
      historyBloc.fetchHistoryList(param, 1, perpage, fiftyDaysAgo,'$tahun-$toBulan-$toHari','');
    }
//    historyBloc.fetchHistoryList('mainTrx', 1, perpage, fiftyDaysAgo,'${tahun}-${toBulan}-${toHari}','');
    print(perpage);
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
    DateTime today = new DateTime.now();
    DateTime fiftyDaysAgo = today.subtract(new Duration(days: 30));
    historyBloc.fetchHistoryList(param, 1, perpage, fiftyDaysAgo,'${tahun}-${toBulan}-${toHari}','');
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            new Flexible(
              child: Padding(
                padding: EdgeInsets.only(left:8.0,top:10.0),
                child: GestureDetector(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Periode',style: TextStyle(color:Colors.green,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                      TextFormField(
                        autofocus: false,
                        style: Theme.of(context).textTheme.body1.copyWith(
                          fontSize: 12.0,
                        ),
                        decoration: InputDecoration(
                            hintText: 'Bulan Ini ...',
                            hintStyle: TextStyle(color:Colors.grey,fontFamily: 'Rubik')
                        ),
                        controller: dateController,
                        onTap: (){
                          FocusScope.of(context).requestFocus(new FocusNode());
                          _selectDate(context);
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
            new Flexible(
              child: Padding(
                padding: EdgeInsets.only(left:8.0,top:10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Cari',style: TextStyle(color:Colors.green,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                    TextFormField(
                        autofocus: false,
                        style: Theme.of(context).textTheme.body1.copyWith(
                          fontSize: 12.0,
                        ),
                        decoration: InputDecoration(
                            hintText: 'Tulis Disini ...',
                            hintStyle: TextStyle(color:Colors.grey,fontFamily: 'Rubik')
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
            Padding(
              padding: EdgeInsets.only(left:8.0,top:10.0),
              child: IconButton(
                icon: isLoading?CircularProgressIndicator():Icon(Icons.search),
                tooltip: 'Increase volume by 10',
                onPressed: () async{
                  setState(() {
                    isLoading = true;
                  });
                  _search();
                },
              ),
            )
          ],
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
                      total = snapshot.data.result.data[index].id.length;
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
                                            Text(hm, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold )),
                                            Text(ymd, style: TextStyle(fontSize: 10),)
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
                                          Container(child: Text(snapshot.data.result.data[index].note, style: TextStyle(fontSize: 10)),
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
                                                Text(snapshot.data.result.data[index].trxIn, style: TextStyle(color:Colors.green,fontSize: 10, fontWeight: FontWeight.bold)),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Icon(const IconData(0xe15b, fontFamily: 'MaterialIcons'),
                                                  color: Colors.black,size: 12,
                                                ),
                                                Text(snapshot.data.result.data[index].trxOut, style: TextStyle(color:Colors.red,fontSize: 10, fontWeight: FontWeight.bold)),
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
    ) : Container(child: Center(child: Text("Data Tidak Tersedia",style: TextStyle(fontFamily:'Rubik',fontWeight: FontWeight.bold))));
  }
  Widget buildTotal(){
    return new Align(alignment: Alignment.centerLeft,
      child:ClipRRect(
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(30),
            bottomLeft: Radius.circular(30),
            topRight: Radius.circular(30)),
        child: Padding(
          padding: EdgeInsets.only(left:10.0,right:10.0,top:15.0,bottom:10.0),
          child: Text('Total $total'),
        ),
      ),
    );
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
