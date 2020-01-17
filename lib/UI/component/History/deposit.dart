//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
//import 'package:thaibah/Model/depositManual/historyDepositModel.dart';
//import 'package:thaibah/Model/historyModel.dart';
//import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
//import 'package:thaibah/UI/component/History/detailDeposit.dart';
//import 'package:thaibah/UI/component/History/historyPPOB.dart';
//import 'package:thaibah/bloc/depositManual/listAvailableBankBloc.dart';
//import 'package:loadmore/loadmore.dart';
//import 'package:thaibah/bloc/transaction/historyBloc.dart';
//
//class HistoryDeposit extends StatefulWidget {
//  @override
//  _HistoryDepositState createState() => _HistoryDepositState();
//}
//
//class _HistoryDepositState extends State<HistoryDeposit> {
//
//  var scaffoldKey = GlobalKey<ScaffoldState>();
//  DateTime selectedDate = DateTime.now();
//  String label1="Pilih Tanggal 1",label2="Pilih Tanggal 2";
//  bool isDateSelected1= false;bool isDateSelected2= false;
//  DateTime birthDate1; DateTime birthDate2; // instance of DateTime
//  String birthDateInString1,birthDateInString2;
//  bool isLoading = false;
//  int perpage = 30;
//  Future<Null> _selectDate1(BuildContext context) async {
//    final datePick= await showDatePicker(
//        context: context,
//        initialDate: new DateTime.now(),
//        firstDate: new DateTime(1900),
//        lastDate: new DateTime(2100)
//    );
//    if(datePick!=null && datePick!=birthDate1){
//      setState(() {
//        birthDate1=datePick;
//        isDateSelected1=true;
//        birthDateInString1 = "${birthDate1.month}/${birthDate1.day}/${birthDate1.year}";
//        label1 = "${birthDate1.year}-${birthDate1.month}-${birthDate1.day}";
//      });
//    }
//  }
//  Future<Null> _selectDate2(BuildContext context) async {
//    final datePick= await showDatePicker(
//        context: context,
//        initialDate: new DateTime.now(),
//        firstDate: new DateTime(1900),
//        lastDate: new DateTime(2100)
//    );
//    if(datePick!=null && datePick!=birthDate2){
//      setState(() {
//        birthDate2=datePick;
//        isDateSelected2=true;
//        birthDateInString2 = "${birthDate2.month}/${birthDate2.day}/${birthDate2.year}";
//        label2 = "${birthDate2.year}-${birthDate2.month}-${birthDate2.day}";
//      });
//    }
//  }
//
//
//  var  tampung ;
//
//  _search(){
//    print(isLoading);
//    setState(() {
//      isLoading = false;
//      filter();
//    });
//
//  }
//
//  Future filter() async{
//    final currentDateTime = DateTime.now();
//    print(currentDateTime.timeZoneName);
//    print(currentDateTime.toIso8601String());
//    print(currentDateTime.toUtc());
//    if(label1 == 'Pilih Tanggal 1' && label2 == 'Pilih Tanggal 2'){
//      var hari = DateFormat.d().format( DateTime.now().subtract(Duration(days: 30)));
//      var hari2 = DateFormat.d().format( DateTime.now());
//      var bulan = DateFormat.M().format( DateTime.now());
//      var bulan2 = DateFormat.M().format( DateTime.now().subtract(Duration(days: 30)));
//      var tahun = DateFormat.y().format( DateTime.now());
//      historyDepositBloc.fetchHistoryDeposit(1, "100","${tahun}-${bulan2}-${hari2}","${tahun}-${bulan}-${hari}");
//    }else{
//      tampung = historyDepositBloc.fetchHistoryDeposit(1, "100","$label1","$label2");
//    }
//
//  }
//
//  @override
//  void initState() {
//
//    super.initState();
//    filter();
////    if()
////    tampung;
//  }
//
//  @override
//  void dispose() {
//    // TODO: implement dispose
//    super.dispose();
//    filter();
//  }
//
//  void load({int step:30}) {
//    print("load $perpage");
//    setState(() {
//      perpage = perpage += step;
//    });
//    historyBloc.fetchHistoryList('mainTrx',1, perpage,"2019-10-01","2020-11-01","");
//    print(perpage);
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      key: scaffoldKey,
//      appBar: AppBar(
//        leading: IconButton(
//          icon: Icon(
//            Icons.keyboard_backspace,
//            color: Colors.white,
//          ),
//          onPressed: () => Navigator.of(context).pop(),
//        ),
//        automaticallyImplyLeading: true,
//        title: new Text("Riwayat Topup", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
//        centerTitle: true,
//        flexibleSpace: Container(
//          decoration: BoxDecoration(
//            gradient: LinearGradient(
//              begin: Alignment.centerLeft,
//              end: Alignment.centerRight,
//              colors: <Color>[
//                Color(0xFF116240),
//                Color(0xFF30cc23)
//              ],
//            ),
//          ),
//        ),
//        elevation: 0.0,
//      ),
//      body: SingleChildScrollView(
//        child: Column(
//          mainAxisSize: MainAxisSize.min,
//          children: <Widget>[
//            Container(
//              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
//              margin: EdgeInsets.all(15.0),
//              child: Column(
//                children: <Widget>[
//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                    children: <Widget>[
//                      MaterialButton(
//                          elevation: 0,
//                          color: Colors.white,
//                          onPressed: () async {
//                            _selectDate1(context);
//                          },
//                          child: new Text("$label1")
//                      ),
//                      MaterialButton(
//                          elevation: 0,
//                          color: Colors.white,
//                          onPressed: () async {
//                            _selectDate2(context);
//                          },
//                          child: new Text("$label2")
//                      ),
//                      Align(
//                          alignment: Alignment.centerRight,
//                          child: Container(
//                            margin: EdgeInsets.all(0),
//                            decoration: BoxDecoration(
//                                color: Colors.green, shape: BoxShape.circle
//                            ),
//                            child: IconButton(
//                              color: Colors.white,
//                              onPressed: () {
//                                setState(() {
//                                  isLoading = true;
//                                });
//                                _search();
//                              },
//                              icon: isLoading ? CircularProgressIndicator():Icon(Icons.search),
//                            ),
//                          )
//                      ),
//                    ],
//                  ),
//                ],
//              ),
//            ),
//            Divider(),
//            CustomContainer(
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: <Widget>[
//                  CustomIconButton(
//                    circleColor: IconColors.transfer,
//                    buttonImg: "assets/images/pending.png",
//                    buttonTitle: "PENDING",
//                    onTap: () {},
//                  ),
//                  CustomIconButton(
//                    circleColor: IconColors.send,
//                    buttonImg: "assets/images/diterima.jpg",
//                    buttonTitle: "DITERIMA",
//                    onTap: () {},
//                  ),
//                  CustomIconButton(
//                    circleColor: IconColors.more,
//                    buttonImg: "assets/images/ditolak.png",
//                    buttonTitle: "DITOLAK",
//                    onTap: () {},
//                  ),
//                ],
//              ),
//            ),
//            StreamBuilder(
//              stream: historyDepositBloc.getResult,
//              builder: (context, AsyncSnapshot<HistoryDepositModel> snapshot) {
//                if (snapshot.hasData) {
//                  return buildContent(snapshot, context);
//                } else if (snapshot.hasError) {
//                  return Text(snapshot.error.toString());
//                }
//                return _loading();
//              },
//            )
//          ],
//        ),
//      ),
//    );
//  }
//
//
//  Widget _loading(){
//    return Column(
//      mainAxisSize: MainAxisSize.min,
//      children: <Widget>[
//        CustomContainer(
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: <Widget>[
//                Material(
//                  color: Colors.transparent,
//                  child: InkWell(
//                    child: Container(
//                      padding: EdgeInsets.all(5.0),
//                      alignment: Alignment.center,
//                      child: Column(
//                        mainAxisAlignment: MainAxisAlignment.center,
//                        children: <Widget>[
//                          CircleAvatar(
//                            backgroundColor: Colors.transparent,
//                            radius: 20,
//                            child: Image.network(
//                              "http://lequytong.com/Content/Images/no-image-02.png",
//                              height: 19,
//                              width: 19,
//                            ),
//                          ),
//                          SizedBox(
//                            height: 5.0,
//                          ),
//                          SkeletonFrame(width: 70,height: 16,)
//                        ],
//                      ),
//                    ),
//                  ),
//                ),
//                Material(
//                  color: Colors.transparent,
//                  child: InkWell(
//                    child: Container(
//                      padding: EdgeInsets.all(5.0),
//                      alignment: Alignment.center,
//                      child: Column(
//                        mainAxisAlignment: MainAxisAlignment.center,
//                        children: <Widget>[
//                          CircleAvatar(
//                            backgroundColor: Colors.transparent,
//                            radius: 20,
//                            child: Image.network(
//                              "http://lequytong.com/Content/Images/no-image-02.png",
//                              height: 19,
//                              width: 19,
//                            ),
//                          ),
//                          SizedBox(
//                            height: 5.0,
//                          ),
//                          SkeletonFrame(width: 70,height: 16,)
//                        ],
//                      ),
//                    ),
//                  ),
//                ),
//                Material(
//                  color: Colors.transparent,
//                  child: InkWell(
//                    child: Container(
//                      padding: EdgeInsets.all(5.0),
//                      alignment: Alignment.center,
//                      child: Column(
//                        mainAxisAlignment: MainAxisAlignment.center,
//                        children: <Widget>[
//                          CircleAvatar(
//                            backgroundColor: Colors.transparent,
//                            radius: 20,
//                            child: Image.network(
//                              "http://lequytong.com/Content/Images/no-image-02.png",
//                              height: 19,
//                              width: 19,
//                            ),
//                          ),
//                          SizedBox(
//                            height: 5.0,
//                          ),
//                          SkeletonFrame(width: 70,height: 16,)
//                        ],
//                      ),
//                    ),
//                  ),
//                ),
//              ],
//            )
//        ),
//        CustomContainer(
//          child: Column(
//            children: <Widget>[
//              Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: <Widget>[
//                  SkeletonFrame(width: 300,height: 16),
//                ],
//              ),
//              SizedBox(height: 15.0),
//              ListView.builder(
//                  itemCount: 6,
//                  shrinkWrap: true,
//                  physics: ScrollPhysics(),
//                  scrollDirection: Axis.vertical,
//                  itemBuilder: (context,index){
//                    return Material(
//                      color: Colors.transparent,
//                      child: ListTile(
//                        title: SkeletonFrame(width: 50,height: 16),
//                        subtitle: SkeletonFrame(width: 50,height: 16),
//                        leading: CircleAvatar(
//                          backgroundColor: Colors.transparent,
//                          radius: 20,
//                          child: Image.network(
//                            "http://lequytong.com/Content/Images/no-image-02.png",
//                            height: 20,
//                            width: 20,
//                          ),
//                        ),
//                        enabled: true,
//                      ),
//                    );
//                  }
//              ),
//            ],
//          ),
//        ),
//      ],
//    );
//  }
//
//  Widget buildContent(AsyncSnapshot<HistoryDepositModel> snapshot, BuildContext context) {
//    if(snapshot.data.result.data.length > 0){
//      return CustomContainer(
//        child: Column(
//          children: <Widget>[
//            ListView.builder(
//                itemCount: snapshot.data.result.data.length,
//                shrinkWrap: true,
//                physics: ScrollPhysics(),
//                scrollDirection: Axis.vertical,
//                itemBuilder: (context,index){
//                  var status = ""; Color warna;
//                  if(snapshot.data.result.data[index].status == 0){
//                    status = IconImgs.pending;
//                    warna = IconColors.transfer;
//                  }else if(snapshot.data.result.data[index].status == 1){
//                    status = IconImgs.diterima;
//                    warna = IconColors.send;
//                  }else{
//                    status = IconImgs.ditolak;
//                    warna = IconColors.more;
//                  }
//                  var newHour = 5;
//                  var time = DateTime.parse("${snapshot.data.result.data[index].createdAt}");
//                  time = time.toLocal();
//                  time = new DateTime(time.year, time.month, time.day, newHour, time.minute, time.second, time.millisecond, time.microsecond);
//                  return HistoryListTile(
//                    iconColor: warna,
//                    onTap: () {
//                      Navigator.of(context, rootNavigator: true).push(
//                        new CupertinoPageRoute(builder: (context) => DetailDeposit(
//                          amount: snapshot.data.result.data[index].amount,
//                          bank_name: snapshot.data.result.data[index].bankName,
//                          atas_nama: snapshot.data.result.data[index].atasNama,
//                          no_rekening: snapshot.data.result.data[index].noRekening,
//                          id_deposit: snapshot.data.result.data[index].idDeposit,
//                          picture: snapshot.data.result.data[index].picture,
//                          status: snapshot.data.result.data[index].status,
//                          created_at: DateFormat.yMMMd().add_jm().format(snapshot.data.result.data[index].createdAt.toLocal()),
//                          name: snapshot.data.result.data[index].name,
//                          bukti: snapshot.data.result.data[index].bukti,
//                        )),
//                      );
//                    },
//                    transactionAmount:DateFormat.yMMMd().add_jm().format(snapshot.data.result.data[index].createdAt.toLocal()),
//                    transactionIcon: status,
//                    transactionName: snapshot.data.result.data[index].amount,
//                    transactionType: snapshot.data.result.data[index].bankName,
//                  );
//                }
//            ),
//          ],
//        ),
//      );
//    }else{
//      return Container(
//          child: Center(child:Text("Data Tidak Tersedia",style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 20,fontFamily: 'Rubik'),))
//      );
//    }
//
//  }
////  int get count => list.length;
////
////  int perpage = 30;
////
////  List<int> list = [];
////
////  void initState() {
////    super.initState();
////    historyBloc.fetchHistoryList('mainTrx', 1, perpage, "2019-10-01","2020-11-01",'');
////  }
////
////  void load({int step:30}) {
////    print("load $perpage");
////    setState(() {
////      perpage = perpage += step;
////    });
////    historyBloc.fetchHistoryList('mainTrx',1, perpage,"2019-10-01","2020-11-01","");
////    print(perpage);
////  }
////
////  @override
////  Widget build(BuildContext context) {
////    return new Scaffold(
////      appBar: new AppBar(
////        title: new Text('titil'),
////      ),
////      body: Container(
////        child: RefreshIndicator(
////          child:  StreamBuilder(
////            stream: historyBloc.getResult,
////            builder: (context, AsyncSnapshot<HistoryModel> snapshot) {
////              if (snapshot.hasData) {
////                return buildContent(snapshot, context);
////              } else if (snapshot.hasError) {
////                return Text(snapshot.error.toString());
////              }
////              return CircularProgressIndicator();
////            },
////          ),
////          onRefresh: _refresh,
////        ),
////      ),
////    );
////  }
////
////
////  Widget buildContent(AsyncSnapshot<HistoryModel> snapshot, BuildContext context){
////    return LoadMore(
////      isFinish: snapshot.data.result.data.length < perpage ,
////      onLoadMore: _loadMore,
////      child: ListView.builder(
////        itemBuilder: (BuildContext context, int index) {
////          return Container(
////            child: Column(
////              children: <Widget>[
////                Text("${snapshot.data.result.data[index].id}"),
////                Text("${snapshot.data.result.data[index].note}"),
////              ],
////            ),
////            height: 40.0,
////            alignment: Alignment.center,
////          );
////        },
////        itemCount: snapshot.data.result.data.length,
////      ),
////      whenEmptyLoad: false,
////      delegate: DefaultLoadMoreDelegate(),
////      textBuilder: DefaultLoadMoreTextBuilder.english,
////    );
////  }
////
//  Future<bool> _loadMore() async {
//    print("onLoadMore");
//    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
//    load();
//    return true;
//  }
//
//  Future<void> _refresh() async {
//    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
////    list.clear();
//    load();
//  }
//}
