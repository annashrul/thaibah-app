import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thaibah/Model/historyPembelianSuplemen.dart';
import 'package:thaibah/UI/Widgets/loadMoreQ.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/component/History/detailHistorySuplemen.dart';
import 'package:thaibah/bloc/historyPembelianBloc.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;

class HistorySuplemen extends StatefulWidget {
  @override
  _HistorySuplemenState createState() => _HistorySuplemenState();
}

class _HistorySuplemenState extends State<HistorySuplemen> {




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
//      print(label);
    }
  }

  Future _search() async{
    if(dateController.text != '' ){
      Timer(Duration(seconds: 1), () {
        setState(() {
          isLoading = false;
        });
      });
        historyPembelianSuplemenBloc.fetchHistoryPemblianSuplemenList(1,perpage,'$from','$to');
    }
    if(dateController.text == ''){
      Timer(Duration(seconds: 1), () {
        setState(() {
          isLoading = false;
        });
      });
      DateTime today = new DateTime.now();
      DateTime fiftyDaysAgo = today.subtract(new Duration(days: 30));
      historyPembelianSuplemenBloc.fetchHistoryPemblianSuplemenList(1, perpage,fiftyDaysAgo,'${tahun}-${toBulan}-${toHari}');
    }
    return;
  }
  void load() {
    print("load $perpage");
    setState(() {
      perpage = perpage += perpage;
    });
    DateTime today = new DateTime.now();
    DateTime fiftyDaysAgo = today.subtract(new Duration(days: 30));
    String cek = fiftyDaysAgo.toString();
    print(cek.substring(0,10));
    if(dateController.text == ''){
      historyPembelianSuplemenBloc.fetchHistoryPemblianSuplemenList(1, perpage,fiftyDaysAgo,'${tahun}-${toBulan}-${toHari}');
    }else{
      historyPembelianSuplemenBloc.fetchHistoryPemblianSuplemenList(1,perpage,'$from','$to');
    }
    print(perpage);
  }


  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    load();
//    historyBloc.fetchHistoryList('bonus',1, perpage,'$tahun-${fromBulan}-${fromHari}','${tahun}-${toBulan}-${toHari}','');
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
    historyPembelianSuplemenBloc.fetchHistoryPemblianSuplemenList(1, perpage,fiftyDaysAgo,'${tahun}-${toBulan}-${toHari}');
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
            Padding(
              padding: EdgeInsets.all(8.0),
              child: IconButton(
                icon: isLoading?CircularProgressIndicator():Icon(Icons.search),
                tooltip: 'Cari',
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
//                            snapshot.data.result.data[index].
                            status = '';
                          }
                          total = total+int.parse(snapshot.data.result.data[index].rawPrice);
//                          print(total);
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
    ) : Container(child:Center(child:Text("Data Tidak Tersedia",style:TextStyle(fontFamily: 'Rubik',fontWeight: FontWeight.bold))));
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

