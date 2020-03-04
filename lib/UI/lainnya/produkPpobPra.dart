import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thaibah/Model/PPOB/PPOBPraModel.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/component/tabData.dart';
import 'package:thaibah/UI/ppob/pulsa_detail_ui.dart';
import 'package:thaibah/bloc/PPOB/PPOBPraBloc.dart';

class ProdukPpobPra extends StatefulWidget{
  final String param,layanan,nohp;
  ProdukPpobPra({this.param,this.layanan,this.nohp});
  @override
  _ProdukPpobPraState createState() => _ProdukPpobPraState();
}

class _ProdukPpobPraState extends State<ProdukPpobPra> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  String param = '';




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.param == 'E_MONEY'){
      param = 'emoney|${widget.layanan}';
    }else{
      param = widget.param;
    }
    if(mounted){
      ppobPraBloc.fetchPpobPra("$param", widget.nohp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar:  AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: false,
        elevation: 0.0,
        title: Text('Produk ${widget.param}',style: TextStyle(color: Colors.white,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
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
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: StreamBuilder(
          stream: ppobPraBloc.getResult,
          builder: (context, AsyncSnapshot<PpobPraModel> snapshot) {
            if (snapshot.hasData) {
              return Scrollbar(child: vwPulsa(snapshot, context));
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return Container(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: EdgeInsets.all(10.0),
                    child: RaisedButton(
                        padding: EdgeInsets.all(20),
                        color: Colors.white,
                        child: Container(padding: EdgeInsets.only(left: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SkeletonFrame(width: MediaQuery.of(context).size.width/5,height: 50.0),
                                SizedBox(width: 10.0),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SkeletonFrame(width: MediaQuery.of(context).size.width/5,height: 16.0),
                                    SizedBox(height: 10.0),
                                    SkeletonFrame(width: MediaQuery.of(context).size.width/5,height: 16.0),
                                  ],
                                )

                              ],
                            ),
                          )
                          ,)
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget vwPulsa(AsyncSnapshot<PpobPraModel> snapshot, BuildContext context){
    var width = MediaQuery.of(context).size.width;
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(width: 750, height: 1334, allowFontScaling: true);
    if(snapshot.data.result.data.length > 0){
      return Container(
        child: ListView.builder(
          itemCount: snapshot.data.result.data.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              padding: EdgeInsets.all(10.0),
              child: RaisedButton(
                  padding: EdgeInsets.all(20),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).push(
                      new CupertinoPageRoute(builder: (context) => DetailPulsaUI(
                        param : "EMONEY",
                        cmd: snapshot.data.result.cmd,
                        no: snapshot.data.result.no,
                        code: snapshot.data.result.data[index].code,
                        provider: snapshot.data.result.data[index].prov,
                        nominal: snapshot.data.result.data[index].nominal.toString(),
                        price: snapshot.data.result.data[index].price.toString(),
                        note: snapshot.data.result.data[index].note,
                        imgUrl : snapshot.data.result.data[index].imgProv,
                        fee_charge: snapshot.data.result.data[index].feeCharge.toString(),
                        raw_price: snapshot.data.result.data[index].rawPrice.toString(),
                      )),
                    );
                  },
                  child: Container(padding: EdgeInsets.only(left: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          CircleImage(imgUrl : snapshot.data.result.data[index].imgProv),
                          SizedBox(width: 10.0),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(snapshot.data.result.data[index].note,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontFamily: 'Rubik',fontSize: 11),),
                              SizedBox(height: 10.0),
                              Text(snapshot.data.result.data[index].price, style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontFamily: 'Rubik',fontSize: 11),)
                            ],
                          )

                        ],
                      ),
                    )
                    ,)
              ),
            );
          },
        ),
      );
    }else{
      return Container(
        child: Center(child: Text("Data Tidak Ada",style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontFamily: 'Rubik'))),
      );
    }
  }

}
