import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/depositManual/historyDepositModel.dart';
import 'package:thaibah/UI/Widgets/loadMoreQ.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/component/History/detailDeposit.dart';
import 'package:thaibah/bloc/depositManual/listAvailableBankBloc.dart';
import 'package:thaibah/config/dateRangePickerQ.dart' as DateRagePicker;
import 'package:thaibah/config/user_repo.dart';

class HistoryDeposit extends StatefulWidget {
  @override
  _HistoryDepositState createState() => _HistoryDepositState();
}

class _HistoryDepositState extends State<HistoryDeposit> {
  bool isLoading = false;
  bool loadingLoadMore = false;
  String label  = 'Periode';
  String from   = '';
  String to     = '';
  int perpage=20;
  var total=0;
  var fromHari = DateFormat.d().format( DateTime.now());
  var toHari = DateFormat.d().format( DateTime.now());
  var fromBulan = DateFormat.M().format( DateTime.now());
  var toBulan = DateFormat.M().format( DateTime.now());
  var tahun = DateFormat.y().format( DateTime.now());
  final dateController = TextEditingController();
  final FocusNode searchFocus       = FocusNode();
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
      historyDepositBloc.fetchHistoryDeposit(1,perpage,'$from','$to');
    }
    if(dateController.text == ''){
      historyDepositBloc.fetchHistoryDeposit(1,perpage,'$tahun-${fromBulan}-${fromHari}','${tahun}-${toBulan}-${toHari}');
    }
    return;
  }
  void load() {
    print("load $perpage");
    setState(() {
      perpage = perpage += perpage;
    });
    historyDepositBloc.fetchHistoryDeposit(1, perpage,'$tahun-${fromBulan}-${fromHari}','${tahun}-${toBulan}-${toHari}');
    print(perpage);
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
//    load();
    loadTheme();
    DateTime today = new DateTime.now();
    DateTime fiftyDaysAgo = today.subtract(new Duration(days: 30));
    historyDepositBloc.fetchHistoryDeposit(1, perpage,fiftyDaysAgo,'${tahun}-${toBulan}-${toHari}');

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UserRepository().appBarWithButton(context,"Riwayat Top Up",warna1,warna2,(){Navigator.pop(context);},Container()),
      body: Column(
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
                        fontFamily: ThaibahFont().fontQ
                      ),
                      decoration: InputDecoration(
                        hintText: 'Periode',hintStyle: TextStyle(fontFamily: ThaibahFont().fontQ)
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
            child: StreamBuilder(
              stream: historyDepositBloc.getResult,
              builder: (context, AsyncSnapshot<HistoryDepositModel> snapshot) {
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

  Widget buildContent(AsyncSnapshot<HistoryDepositModel> snapshot, BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: RefreshIndicator(
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
//                              name: snapshot.data.result.data[index].name,
                              bukti: snapshot.data.result.data[index].bukti,
                              )),
                            );
                          },
                          child: Card(
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
                                    minRadius: 150,
                                    maxRadius: 150,
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
                                ),
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("${snapshot.data.result.data[index].bankName}",style: TextStyle(fontFamily:ThaibahFont().fontQ,color: Colors.grey, fontWeight: FontWeight.bold),),
                                    Text("$cek",style: TextStyle(fontSize:12.0,fontFamily:ThaibahFont().fontQ,color:warna, fontWeight: FontWeight.bold),),
                                  ],
                                ),
                                subtitle: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(snapshot.data.result.data[index].amount, style: TextStyle(fontFamily:ThaibahFont().fontQ,color: Colors.red)),
                                    Text("${DateFormat.yMd().add_jm().format(snapshot.data.result.data[index].createdAt.toLocal())}",style: TextStyle(fontSize:12.0,fontFamily:ThaibahFont().fontQ,color: Colors.grey, fontWeight: FontWeight.bold),),
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
            )
        ),

      ],
    );
  }


}


