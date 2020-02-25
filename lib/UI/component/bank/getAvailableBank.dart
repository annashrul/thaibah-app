import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:thaibah/Model/depositManual/listAvailableBank.dart';
import 'package:thaibah/UI/component/History/detailDeposit.dart';
import 'package:thaibah/UI/component/detail/detailTopUp.dart';
import 'package:thaibah/bloc/depositManual/listAvailableBankBloc.dart';
import 'package:thaibah/resources/virtualAccount/virtualAccountProvider.dart';

class GetAvailableBank extends StatefulWidget {
  final String name,saldo;
  final int amount;
  GetAvailableBank({this.amount,this.name,this.saldo});
  @override
  _GetAvailableBankState createState() => _GetAvailableBankState();
}

class _GetAvailableBankState extends State<GetAvailableBank> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = false;

  int adminFee = 0;

  int totalPembayaran = 0;

  Future create(var id_bank,var picture, var bank_code) async {

    var res = await detailDepositBloc.fetchDetailDeposit(id_bank, widget.amount);
    if(res.status == 'success'){
      setState(() {_isLoading = false;});
      if(res.result.status == 1){
        Timer(Duration(seconds: 5), () {
          Navigator.of(context, rootNavigator: true).push(
            new CupertinoPageRoute(builder: (context) => DetailDeposit(
              amount: res.result.amount,
              bank_name: res.result.bankName,
              atas_nama: res.result.atasNama,
              no_rekening: res.result.noRekening,
              id_deposit: res.result.idDeposit,
              picture: res.result.picture,
              status: res.result.status,
              created_at: DateFormat.yMMMd().add_jm().format(res.result.createdAt.toLocal()),
              bukti: res.result.bukti,
              saldo: widget.saldo,
            )),
          );
        });
        scaffoldKey.currentState.showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
              content: Text('anda telah melakukan deposit, silahkan cancel untuk membuat deposit baru. Anda akan dialihkan ke halaman detail deposit',style: TextStyle(color:Colors.white,fontFamily: 'Rubik',fontWeight: FontWeight.bold),),
            )
        );

      }else{
        Navigator.of(context, rootNavigator: true).push(
          new CupertinoPageRoute(builder: (context) => DetailTopUp(
              amount: res.result.amount,
              raw_amount: res.result.rawAmount,
              unique: res.result.unique,
              bank_name: res.result.bankName,
              atas_nama: res.result.atasNama,
              no_rekening: res.result.noRekening,
              picture:picture,
              id_deposit:res.result.idDeposit,
              bank_code : bank_code
          )),
        );
      }

    }
  }
  Future cek() async{
    var test = await VirtualAccountProvider().fetchAvailableBank();
    adminFee = test.result.adminFee;
//    totalPembayaran = widget.amount - adminFee;
  }

  @override
  void initState() {
    super.initState();
    cek();
    listAvailableBankBloc.fetchListAvailableBank();

  }
  final formatter = new NumberFormat("#,###");
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
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
          leading: IconButton(
            icon: Icon(Icons.keyboard_backspace,color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          centerTitle: false,
          elevation: 1.0,
          automaticallyImplyLeading: true,
          title: new Text("Metode Pembayaran", style: TextStyle(fontSize:16,color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
        ),
        body: StreamBuilder(
          stream: listAvailableBankBloc.getResult,
          builder: (context, AsyncSnapshot<ListAvailableBankModel> snapshot) {
            if (snapshot.hasData) {
              return buildContent(snapshot, context);
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }

            return ListView(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 0.0, bottom: 0.0),
              children: <Widget>[
                GestureDetector(
                  child: Card(
                    elevation: 0.0,
                    margin: new EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
                    child: Container(
                      padding:EdgeInsets.all(5.0),
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
                                imageUrl: "http://lequytong.com/Content/Images/no-image-02.png",
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
                          title: LinearProgressIndicator(),
                          subtitle: LinearProgressIndicator()
                      ),
                    ),
                  ),
                )
              ],

            );
          },
        ),
        bottomNavigationBar: Container(
          width: ScreenUtil.getInstance().setWidth(710),
          height: ScreenUtil.getInstance().setHeight(100),
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF116240),Color(0xFF30CC23)]),
              borderRadius: BorderRadius.circular(0.0),
              boxShadow: [BoxShadow(color: Color(0xFF6078ea).withOpacity(.3),offset: Offset(0.0, 8.0),blurRadius: 8.0)]
          ),
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Nominal", style: TextStyle(fontFamily:'Rubik',fontSize: 14, color: Colors.white,fontWeight: FontWeight.bold),),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text("Rp ${formatter.format(widget.amount)}", style: TextStyle(fontSize: 14, color: Colors.white,fontWeight: FontWeight.bold),),
                ],
              ),
            ],
          ),
        )
    );
  }


  Widget buildContent(AsyncSnapshot<ListAvailableBankModel> snapshot, BuildContext context) {
    if(snapshot.data.result.length > 0){
      return  Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            child: Text(
              'Pilih Bank Yang Akan Dituju',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,fontFamily: 'Rubik'),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 0.0, bottom: 0.0),
                itemCount: snapshot.data.result.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: (){
                      setState(() {
                        _isLoading = true;
                      });
                      create(snapshot.data.result[index].idBank,snapshot.data.result[index].picture,snapshot.data.result[index].bankCode.toString());
                    },
                    child: _isLoading ? LinearProgressIndicator() : Card(
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
                                imageUrl: snapshot.data.result[index].picture,
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
                          title: Text(
                            snapshot.data.result[index].atasNama,style: TextStyle(fontFamily:'Rubik',color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Row(
                            children: <Widget>[
                              Text(snapshot.data.result[index].noRekening, style: TextStyle(fontFamily:'Rubik',color: Colors.black))
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
          )
        ],
      );
    }else{
      return Column(
        children: <Widget>[
          Container(
              child: Center(child:Text("Data Tidak Tersedia",style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 20,fontFamily: 'Rubik'),))
          ),
        ],
      );
    }

  }
}
