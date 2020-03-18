import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thaibah/Model/historyPembelianTanahModel.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/component/History/detailHistoryTanah.dart';
import 'package:thaibah/bloc/historyPembelianBloc.dart';
//import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:thaibah/config/dateRangePickerQ.dart' as DateRagePicker;


class HistoryTanah extends StatefulWidget {
  @override
  _HistoryTanahState createState() => _HistoryTanahState();
}

class _HistoryTanahState extends State<HistoryTanah> {
  bool isLoading = false;
  bool loadingLoadMore = false;
  String label  = 'Periode';
  String from   = '';
  String to     = '';
  int perpage=10;
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

    }
  }

  Future _search() async{
    if(dateController.text != '' ){
      setState(() {
        isLoading = false;
      });
      historyPembelianTanahBloc.fetchHistoryPemblianTanahList(1,perpage,'$from','$to');
    }
    if(dateController.text == ''){
      historyPembelianTanahBloc.fetchHistoryPemblianTanahList(1,perpage,'$tahun-${fromBulan}-${fromHari}','${tahun}-${toBulan}-${toHari}');
    }
    return;
  }
  @override
  void initState() {
    super.initState();
    historyPembelianTanahBloc.fetchHistoryPemblianTanahList(1,perpage,'${tahun}-${fromBulan}-${fromHari}','${tahun}-${toBulan}-${toHari}');
  }
  @override
  void dispose() {
    super.dispose();
  }
  void _moreContent({int step:10}) {
    setState(() {
      perpage = perpage += step;
    });
    if(dateController.text != ''){
      historyPembelianTanahBloc.fetchHistoryPemblianTanahList(1,perpage,'$from','$to');
    }
    if(dateController.text == ''){
      historyPembelianTanahBloc.fetchHistoryPemblianTanahList(1,perpage,'$tahun-${fromBulan}-${fromHari}','${tahun}-${toBulan}-${toHari}');
    }

    return;
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
                  setState(() {
                    isLoading = true;
                  });
                  _search();
                },
              ),
            ),
          ],
        ),
        Expanded(
          child:  StreamBuilder(
            stream: historyPembelianTanahBloc.getResult,
            builder: (context, AsyncSnapshot<HistoryPembelianTanahModel> snapshot) {
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

  Widget buildContent(AsyncSnapshot<HistoryPembelianTanahModel> snapshot, BuildContext context) {
    final Widget readMore = FlatButton(
      child: loadingLoadMore ? CircularProgressIndicator() : Text(
          'Load More', style: Theme
          .of(context)
          .textTheme
          .button
          .copyWith(fontSize: 18.0)),
      onPressed: () {
        _moreContent();
      },
    );
    if (snapshot.data.result.data.length > 0) {
      return Column(
        children: <Widget>[
          Expanded(
              child: Container(
                margin: EdgeInsets.all(15.0),
                child: ListView.builder(
                    itemCount: snapshot.data.result.data.length,
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
                              builder: (context) => DetailHistoryTanah(
                                namaProduk: snapshot.data.result.data[index].namaProduk,
                                status: snapshot.data.result.data[index].status,
                                price: snapshot.data.result.data[index].price.toString(),
                                namaPembeli: snapshot.data.result.data[index].namaPembeli,
                                noHpPembeli: snapshot.data.result.data[index].nohpPembeli,
                                pekerjaanPembeli: snapshot.data.result.data[index].pekerjaanPembeli,
                                alamatPembeli: snapshot.data.result.data[index].alamatPembeli,
                                ktpPembeli: snapshot.data.result.data[index].ktpPembeli,
                                kkPembeli: snapshot.data.result.data[index].kkPembeli,
                                npwpPembeli: snapshot.data.result.data[index].npwpPembeli,
                                tanggal: DateFormat.yMMMd().add_jm().format(snapshot.data.result.data[index].createdAt.toLocal()),
                              ),
                            ),
                          );
                        },
                        child: accountItems(
                            "",
                            snapshot.data.result.data[index].namaProduk,
                            "${status}",
                            statColor,
                            snapshot.data.result.data[index].price.toString(),
                            DateFormat.yMMMd().add_jm().format(snapshot.data.result.data[index].createdAt.toLocal()),
                            oddColour: (index % 2 == 0) ? Colors.white : Color(0xFFF7F7F9)
                        ),
                      );
                    }
                ),
              )
          ),
          (perpage - snapshot.data.result.data.length == 10 &&
              snapshot.data.status == 'success') ? Stack(
              children: <Widget>[
                CircularProgressIndicator()
              ]) : Container(),
          readMore,
        ],
      );
    }else{
      return Container(
        child: Center(
          child: Text("Data Tidak Tersedia",style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      );
    }
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

