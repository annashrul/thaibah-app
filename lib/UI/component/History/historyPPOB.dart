import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loadmore/loadmore.dart';
import 'package:thaibah/Model/historyPPOBModel.dart';
import 'package:thaibah/Model/historyPembelianTanahModel.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/component/History/detailHistoryPPOB.dart';
import 'package:thaibah/UI/component/History/detailHistoryTanah.dart';
import 'package:thaibah/bloc/historyPembelianBloc.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;

class HistoryPPOB extends StatefulWidget {
  @override
  _HistoryPPOBState createState() => _HistoryPPOBState();
}

class IconColors {
  static const Color send = Color(0xffecfaf8);
  static const Color transfer = Color(0xfffdeef5);
  static const Color passbook = Color(0xfffff4eb);
  static const Color more = Color(0xffeff1fe);
}

class IconImgs {
  static const String diterima = "assets/images/diterima.jpg";
  static const String pending = "assets/images/pending.png";
  static const String ditolak = "assets/images/ditolak.png";
  static const String more = "assets/imgs/more.png";
  static const String freeze = "assets/imgs/freeze.png";
  static const String unlock = "assets/imgs/unlock.png";
  static const String secret = "assets/imgs/secret.png";
}
class _HistoryPPOBState extends State<HistoryPPOB> {
//  bool isLoading = false;
//  bool loadingLoadMore = false;
//  String label  = 'Periode';
//  String from   = '';
//  String to     = '';
//  int perpage=10;
//  var total=0;
//  var fromHari = DateFormat.d().format( DateTime.now().subtract(Duration(days: 30)));
//  var toHari = DateFormat.d().format( DateTime.now());
//  var fromBulan = DateFormat.M().format( DateTime.now().subtract(Duration(days: 30)));
//  var toBulan = DateFormat.M().format( DateTime.now());
//  var tahun = DateFormat.y().format( DateTime.now());
//  final dateController = TextEditingController();
//  final FocusNode searchFocus       = FocusNode();
//  Future<Null> _selectDate(BuildContext context) async{
//    final List<DateTime> picked = await DateRagePicker.showDatePicker(
//        context: context,
//        initialFirstDate: new DateTime.now(),
//        initialLastDate: (new DateTime.now()).add(new Duration(days: 7)),
//        firstDate: new DateTime(2015),
//        lastDate: new DateTime(2100)
//    );
//    if (picked != null && picked.length == 2) {
//      setState(() {
//        from  = "${picked[0].year}-${picked[0].month}-${picked[0].day}";
//        to    = "${picked[1].year}-${picked[1].month}-${picked[1].day}";
//        label = "${from} ${to}";
//        dateController.text = label;
//      });
//
//    }
//  }
//
//  Future _search() async{
//    if(dateController.text != '' ){
//      setState(() {
//        isLoading = false;
//      });
//      historyPPPOBBloc.fetchHistoryPPOBList(1,perpage,'$from','$to');
//    }
//    if(dateController.text == ''){
//      historyPPPOBBloc.fetchHistoryPPOBList(1,perpage,'$tahun-${fromBulan}-${fromHari}','${tahun}-${toBulan}-${toHari}');
//    }
//    return;
//  }
//
//  void load() {
//    print("load $perpage");
//    setState(() {
//      perpage = perpage += perpage;
//    });
//    historyPPPOBBloc.fetchHistoryPPOBList(1, perpage,'$tahun-${fromBulan}-${fromHari}','${tahun}-${toBulan}-${toHari}');
//    print(perpage);
//  }
//  Future<void> _refresh() async {
//    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
//    historyPPPOBBloc.fetchHistoryPPOBList(1, perpage,'$tahun-${fromBulan}-${fromHari}','${tahun}-${toBulan}-${toHari}');
//  }
//  Future<bool> _loadMore() async {
//    print("onLoadMore");
//    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
//    load();
//    return true;
//  }
//
//  @override
//  void initState() {
//    super.initState();
//    historyPPPOBBloc.fetchHistoryPPOBList(1, perpage,'$tahun-${fromBulan}-${fromHari}','${tahun}-${toBulan}-${toHari}');
//  }
//  @override
//  void dispose() {
//    // TODO: implement dispose
//    super.dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
////    historyPembelianTanahBloc.fetchHistoryPemblianTanahList(1);
////    historyPPPOBBloc.fetchHistoryPPOBList(1,100);
//    return Column(
//      children: <Widget>[
//        Row(
//          children: <Widget>[
//            new Flexible(
//              child: Padding(
//                padding: EdgeInsets.only(left:15.0),
//                child: GestureDetector(
//                  child: TextFormField(
//                    autofocus: false,
//                    style: Theme.of(context).textTheme.body1.copyWith(
//                      fontSize: 12.0,
//                    ),
//                    decoration: InputDecoration(
//                      hintText: 'Periode',
//                    ),
//                    controller: dateController,
//                    onTap: (){
//                      FocusScope.of(context).requestFocus(new FocusNode());
//                      _selectDate(context);
//                    },
//                  ),
//                ),
//              ),
//            ),
//            Padding(
//              padding: EdgeInsets.all(8.0),
//              child: IconButton(
//                icon: Icon(Icons.search),
//                tooltip: 'Increase volume by 10',
//                onPressed: () async{
//                  setState(() {
//                    isLoading = true;
//                  });
//                  _search();
//                },
//              ),
//            ),
//          ],
//        ),
//        Expanded(
//            child:  StreamBuilder(
//              stream: historyPPPOBBloc.getResult,
//              builder: (context, AsyncSnapshot<HistoryPpobModel> snapshot) {
//                if (snapshot.hasData) {
//                  return buildContent(snapshot, context);
//                } else if (snapshot.hasError) {
//                  return Text(snapshot.error.toString());
//                }
//                return _loading();
//              },
//            )
//        ),
//      ],
//    );
//  }
//
//  Widget buildContent(AsyncSnapshot<HistoryPpobModel> snapshot, BuildContext context) {
//
//    if (snapshot.data.result.data.length > 0) {
//      return RefreshIndicator(
//        child: LoadMore(
//          child: Column(
//            children: <Widget>[
//              Expanded(
//                  child: Container(
//                    margin: EdgeInsets.all(15.0),
//                    child: ListView.builder(
//                        itemCount: snapshot.data.result.data.length,
//                        shrinkWrap: true,
//                        physics: ScrollPhysics(),
//                        scrollDirection: Axis.vertical,
//                        itemBuilder: (context, index) {
//                          var status = '';
//                          Color statColor;
//
//                          if (snapshot.data.result.data[index].status == 0) {
//                            status = 'Pending';
//                            statColor = Colors.blueAccent;
//                          } else if (snapshot.data.result.data[index].status == 1) {
//                            status = 'Diterima';
//                            statColor = Colors.green;
//                          } else if (snapshot.data.result.data[index].status == 2) {
//                            status = 'Ditolak';
//                            statColor = Colors.deepOrangeAccent;
//
//                          } else {
//                            status = '';
//                          }
//                          return GestureDetector(
//                            onTap: () {
//                              Navigator.push(
//                                context,
//                                MaterialPageRoute(
//                                  builder: (context) => DetailHistoryPPOB(kdTrx: snapshot.data.result.data[index].kdTrx),
//                                ),
//                              );
//                            },
//                            child: accountItems(
//                                "",
//                                snapshot.data.result.data[index].kdTrx,
//                                "${status}",
//                                statColor,
//                                snapshot.data.result.data[index].note.toString(),
//                                DateFormat.yMMMd().add_jm().format(snapshot.data.result.data[index].createdAt.toLocal()),
//                                oddColour: (index % 2 == 0) ? Colors.white : Color(0xFFF7F7F9)
//                            ),
//                          );
//                        }
//                    ),
//                  )
//              )
//            ],
//          ),
//          isFinish: snapshot.data.result.data.length < perpage,
//          onLoadMore: _loadMore,
//          whenEmptyLoad: true,
//          delegate: DefaultLoadMoreDelegate(),
//          textBuilder: DefaultLoadMoreTextBuilder.english,
//        ),
//          onRefresh: _refresh
//      );
//    }else{
//      return Container(
//        child: Center(
//          child: Text("Data Tidak Tersedia",style: TextStyle(fontWeight: FontWeight.bold)),
//        ),
//      );
//    }
////    return CustomContainer(
////      child: Column(
////        children: <Widget>[
////          Row(
////            mainAxisAlignment: MainAxisAlignment.spaceBetween,
////            children: <Widget>[
////              Text("Pembelian PPOB",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
////            ],
////          ),
////          SizedBox(height: 15.0),
////          ListView.builder(
////              itemCount: snapshot.data.result.data.length,
////              shrinkWrap: true,
////              physics: ScrollPhysics(),
////              scrollDirection: Axis.vertical,
////              itemBuilder: (context,index){
////                var status = "";
////                if(snapshot.data.result.data[index].status == 0){
////                  status = IconImgs.pending;
////                }else if(snapshot.data.result.data[index].status == 0){
////                  status = IconImgs.diterima;
////                }else{
////                  status = IconImgs.ditolak;
////                }
////                return HistoryListTile(
////                  iconColor: IconColors.transfer,
////                  onTap: () {
////                    Navigator.push(
////                      context,
////                      MaterialPageRoute(
////                        builder: (context) => DetailHistoryPPOB(kdTrx: snapshot.data.result.data[index].kdTrx),
////                      ),
////                    );
////                  },
////                  transactionAmount: DateFormat.yMMMd().add_jm().format(snapshot.data.result.data[index].createdAt.toLocal()),
////                  transactionIcon: status,
////                  transactionName: snapshot.data.result.data[index].kdTrx,
////                  transactionType: snapshot.data.result.data[index].note,
////                );
////              }
////          ),
////        ],
////      ),
////    );
//  }
//
//  Widget _loading(){
//    return Container(
//      margin: EdgeInsets.all(15.0),
//      child: ListView.builder(
//          itemCount: 7,
//          shrinkWrap: true,
//          physics: ScrollPhysics(),
//          scrollDirection: Axis.vertical,
//          itemBuilder: (context, index){
//            return GestureDetector(
//              child: Container(
//                decoration: BoxDecoration(color: Colors.white),
//                padding:EdgeInsets.only(top: 20.0, bottom: 20.0, left: 5.0, right: 5.0),
//                child: Column(
//                  children: <Widget>[
//                    Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                      children: <Widget>[
//                        SkeletonFrame(width: MediaQuery.of(context).size.width/3,height: 16),
//                        SkeletonFrame(width: MediaQuery.of(context).size.width/3,height: 16),
//                      ],
//                    ),
//                    SizedBox(height: 20.0),
//                    Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                      children: <Widget>[
//                        SkeletonFrame(width: MediaQuery.of(context).size.width/3,height: 16),
//                        SkeletonFrame(width: MediaQuery.of(context).size.width/3,height: 16),
//                      ],
//                    ),
//                  ],
//                ),
//              ),
//            );
//          }
//      ),
//    );
//  }
//  Container accountItems(String kdTrx, String item, String charge, Color statColor, String dateString, String type,{Color oddColour = Colors.white}) => Container(
//    decoration: BoxDecoration(color: oddColour),
//    padding:EdgeInsets.only(top: 20.0, bottom: 20.0, left: 5.0, right: 5.0),
//    child: Column(
//      children: <Widget>[
//        Row(
//          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//          children: <Widget>[
//            Text(item, style: TextStyle(fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
//            Text(charge, style: TextStyle(fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold,color:statColor))
//          ],
//        ),
//        SizedBox(
//          height: 20.0,
//          child: Text(kdTrx,style: TextStyle(color: Colors.green,fontFamily: 'Rubik',fontSize: 12,fontWeight: FontWeight.bold)),
//        ),
//        Row(
//          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//          children: <Widget>[
//            Text(dateString,style: TextStyle(color: Colors.grey, fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
//            Text(type, style: TextStyle(color: Colors.grey, fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold))
//          ],
//        ),
//      ],
//    ),
//  );

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


  bool isLoading = false;
  bool loadingLoadMore = false;
  String label  = 'Periode';
  String from   = '';
  String to     = '';
  int perpage=12;
  var total=0;
  var fromHari = DateFormat.d().format( DateTime.now());
  var toHari = DateFormat.d().format( DateTime.now());
  var fromBulan = DateFormat.M().format( DateTime.now());
  var toBulan = DateFormat.M().format( DateTime.now());
  var tahun = DateFormat.y().format( DateTime.now());
  final dateController = TextEditingController();
  final FocusNode searchFocus       = FocusNode();
  Future<Null> _selectDate(BuildContext context) async{
    final List<DateTime> picked = await DateRagePicker.showDatePicker(
        context: context,
        initialFirstDate: new DateTime.now(),
        initialLastDate: (new DateTime.now()).add(new Duration(days: 1)),
        firstDate: new DateTime(2015),
        lastDate: new DateTime(2100)
    );
    if (picked != null && picked.length == 2) {

      setState(() {
        from  = "${picked[0].year}-${picked[0].month}-${picked[0].day}";
        to    = "${picked[1].year}-${picked[1].month}-${picked[1].day}";
        label = "${from} ${to}";
        dateController.text = label;
      });
      print(label);
    }
  }

  Future _search() async{
    if(dateController.text != '' ){
      historyPPPOBBloc.fetchHistoryPPOBList(1,perpage,'$from','$to');

    }
    if(dateController.text == ''){
      historyPPPOBBloc.fetchHistoryPPOBList(1,perpage,'$tahun-${fromBulan}-${fromHari}','${tahun}-${toBulan}-${toHari}');
    }
    return;
  }
  void load() {
    print("load $perpage");
    setState(() {
      perpage = perpage += perpage;
    });
    historyPPPOBBloc.fetchHistoryPPOBList(1, perpage,'$tahun-${fromBulan}-${fromHari}','${tahun}-${toBulan}-${toHari}');
    print(perpage);
  }
  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    historyPPPOBBloc.fetchHistoryPPOBList(1, perpage,'$tahun-${fromBulan}-${fromHari}','${tahun}-${toBulan}-${toHari}');
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
    historyPPPOBBloc.fetchHistoryPPOBList(1, perpage,'$tahun-${fromBulan}-${fromHari}','${tahun}-${toBulan}-${toHari}');
    print("1, perpage,'${tahun}-${fromBulan}-${fromHari}','${tahun}-${toBulan}-${toHari}'");

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
                padding: EdgeInsets.only(left:15.0),
                child: GestureDetector(
                  child: TextFormField(
                    autofocus: false,
                    style: Theme.of(context).textTheme.body1.copyWith(
                      fontSize: 12.0,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Periode',
                    ),
                    controller: dateController,
                    onTap: (){
                      FocusScope.of(context).requestFocus(new FocusNode());
                      _selectDate(context);
                    },
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(Icons.search),
                tooltip: 'Increase volume by 10',
                onPressed: () async{
                  _search();
                },
              ),
            )
          ],
        ),
        Expanded(
            child:  StreamBuilder(
              stream: historyPPPOBBloc.getResult,
              builder: (context, AsyncSnapshot<HistoryPpobModel> snapshot) {
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

  Widget buildContent(AsyncSnapshot<HistoryPpobModel> snapshot, BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
            child: RefreshIndicator(
                child: Container(
                  margin: EdgeInsets.all(15.0),
                  child: LoadMore(
                    child: ListView.builder(
                        itemCount:  snapshot.data.result.data.length,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          var status = '';
                          Color statColor;

                          if (snapshot.data.result.data[index].status == 0) {
                            status = 'Pending';
                            statColor = Colors.blueAccent;
                          } else if (snapshot.data.result.data[index].status == 1) {
                            status = 'Diterima';
                            statColor = Colors.green;
                          } else if (snapshot.data.result.data[index].status == 2) {
                            status = 'Ditolak';
                            statColor = Colors.deepOrangeAccent;

                          } else {
                            status = '';
                          }
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailHistoryPPOB(kdTrx: snapshot.data.result.data[index].kdTrx),
                                ),
                              );
                            },
                            child: accountItems(
                                "",
                                snapshot.data.result.data[index].kdTrx,
                                "${status}",
                                statColor,
                                snapshot.data.result.data[index].note.toString(),
                                DateFormat.yMMMd().add_jm().format(snapshot.data.result.data[index].createdAt.toLocal()),
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
            Text(item, style: TextStyle(fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
            Text(charge, style: TextStyle(fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold,color:statColor))
          ],
        ),
        SizedBox(
          height: 20.0,
          child: Text(kdTrx,style: TextStyle(color: Colors.green,fontFamily: 'Rubik',fontSize: 12,fontWeight: FontWeight.bold)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(dateString,style: TextStyle(color: Colors.grey, fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
            Text(type, style: TextStyle(color: Colors.grey, fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold))
          ],
        ),
      ],
    ),
  );
}

