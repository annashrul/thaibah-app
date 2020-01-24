import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loadmore/loadmore.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/historyPenarikanModel.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/bloc/withdrawBloc.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;

class HistoryPenarikan extends StatefulWidget {
  @override
  _HistoryPenarikanState createState() => _HistoryPenarikanState();
}

class _HistoryPenarikanState extends State<HistoryPenarikan> {
  final userRepository = UserRepository();
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
  final searchController = TextEditingController();
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
    if(dateController.text != ''){
      historyPenarikanBloc.fetchHistoryPenarikan(1, perpage, from, to);
    }
    if(dateController.text == ''){
      historyPenarikanBloc.fetchHistoryPenarikan(1, perpage, from, to);
    }
    return;
  }

  void load() {
    print("load $perpage");
    setState(() {
      perpage = perpage += 20;
    });
    DateTime today = new DateTime.now();
    DateTime fiftyDaysAgo = today.subtract(new Duration(days: 30));
    historyPenarikanBloc.fetchHistoryPenarikan(1, perpage,fiftyDaysAgo,'${tahun}-${toBulan}-${toHari}');
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
    historyPenarikanBloc.fetchHistoryPenarikan(1, perpage,fiftyDaysAgo,'${tahun}-${toBulan}-${toHari}');
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  final formatter = new NumberFormat("#,###");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        automaticallyImplyLeading: true,
        title: new Text("Riwayat Penarikan", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
        centerTitle: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[
                Color(0xFF116240),
                Color(0xFF30cc23)
              ],
            ),
          ),
        ),
        elevation: 0.0,
      ),
      body: Column(
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
                  icon: Icon(Icons.search),
                  tooltip: 'Cari',
                  onPressed: () async{
                    _search();
                  },
                ),
              )
            ],
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
    return Column(
      children: <Widget>[
        Expanded(
            child: RefreshIndicator(
                child: Container(
                  margin: EdgeInsets.all(15.0),
                  child: LoadMore(
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
                                            style: TextStyle(fontSize: 12,fontFamily: 'Rubik',color: Colors.black,fontWeight: FontWeight.bold),
                                            children: <TextSpan>[
                                              TextSpan(text: ' (${snapshot.data.result.data[index].accNumber})',style: TextStyle(color: Colors.grey, fontSize: 10,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
                                            ]
                                        ),
                                      ),
//                                      Text("${snapshot.data.result.data[index].accHolderName} (${snapshot.data.result.data[index].accNumber}) ",style: TextStyle(fontFamily:'Rubik',color: Colors.grey, fontWeight: FontWeight.bold),),
                                      Text("$cek",style: TextStyle(fontSize:12.0,fontFamily:'Rubik',color:warna, fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                  subtitle: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text("Rp ${formatter.format(int.parse(snapshot.data.result.data[index].amount))}", style: TextStyle(fontFamily:'Rubik',color: Colors.red, fontWeight: FontWeight.bold)),
                                      Text("${DateFormat.yMd().add_jm().format(snapshot.data.result.data[index].createdAt.toLocal())}",style: TextStyle(fontSize:12.0,fontFamily:'Rubik',color: Colors.grey, fontWeight: FontWeight.bold),),
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
