import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_villains/villain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thaibah/UI/Homepage/index.dart';
import 'package:thaibah/UI/component/keranjang.dart';
import 'package:thaibah/UI/produk_mlm_ui.dart';
import 'package:thaibah/config/style.dart';
import 'package:thaibah/resources/addressProvider.dart';
import 'package:thaibah/resources/productMlmSuplemenProvider.dart';

class DetailProdukMlmSuplemeniUI extends StatefulWidget {
  final String id,penjual,title,type,price,satuan,qty,picture,descriptions,category,total_ppn;
  final int raw_price,ppn,weight;

  DetailProdukMlmSuplemeniUI({
    this.id,
    this.penjual,
    this.title,
    this.type,
    this.price,
    this.satuan,
    this.raw_price,
    this.ppn,
    this.total_ppn,
    this.weight,
    this.qty,
    this.picture,
    this.descriptions,
    this.category,
  });
  @override
  _DetailProdukMlmUIState createState() => _DetailProdukMlmUIState();
}

class _DetailProdukMlmUIState extends State<DetailProdukMlmSuplemeniUI> with WidgetsBindingObserver {
  int harga = 0;
  SharedPreferences sharedPreferences;

  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static SharedPreferences _preferences;

  var idOld;



  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    idOld = widget.id;
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  bool isLoading = false;
  bool isExpanded = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  PersistentBottomSheetController _controller; // <------ Instance variable

  double _height;
  double _width;
  int qtyinc = 1;
  String name='';
  String id='';
  String picture='';
  int qty=0;

  add() {
    print(qtyinc);

    qtyinc= qtyinc+1;
  }
  minus() {
    if (qtyinc != 0)  qtyinc-=1;
  }



  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
//      bottomNavigationBar: _bottomBarBeli(context),
      key: scaffoldKey,
      //backgroundColor: Colors.transparent,
      body: Villain(
        villainAnimation: VillainAnimation.fromBottom(
          curve: Curves.fastOutSlowIn,
          relativeOffset: 0.05,
          from: Duration(milliseconds: 200),
          to: Duration(milliseconds: 400),
        ),
        secondaryVillainAnimation: VillainAnimation.fade(),
        animateExit: true,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: Styles.primaryColor,
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(widget.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        )
                    ),
                    background: Image.network(
                      widget.picture,
                      fit: BoxFit.cover,
                    )
                ),
              ),
            ];
          },
          body: ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0,12.0,12.0,12.0),
                    child: Row(children: <Widget>[
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(widget.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Rubik'),),
                            Text("Stok Tersedia ( "+widget.qty+" )", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'Rubik'),),
                            Text("Berat ${widget.weight} Gram", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'Rubik'),),
                            Text("Harga ini sudah termasuk PPN ${widget.ppn}%", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'Rubik'),),
                          ],),
                      ),

                      SizedBox(width: 5,),

                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)),color: Styles.primaryColor),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(widget.satuan, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Rubik'),),
                          )
                        ),
                      ),

                    ],
                  ),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.all(10),
                  child:  Html(
                    data: widget.descriptions,
                  ),
                )
              ],
            )
          ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }


  Future<void> _detailBeliModalBottomSheet(context) async {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc){
          return ModalBottomSheet(
            nama: widget.title,
            id:widget.id,
            harga: widget.raw_price,
            qty: int.parse(widget.qty),
            qtyinc: qtyinc,
            picture: widget.picture,
            price : widget.price,
            add: add(),
            sub: minus(),
          );
        }
    );
  }
  Widget _bottomBarBeli(BuildContext context) {
    return BottomAppBar(
      //notchMargin: 4,
      shape: AutomaticNotchedShape(RoundedRectangleBorder(),RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      child:  Container(
        //margin: EdgeInsets.only(left: 50, right: 50),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(30)
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: kBottomNavigationBarHeight,
              child: FlatButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(
                  // bottomRight: Radius.circular(25.0),
                    topRight: Radius.circular( 25.0))
                ),
                color: Styles.primaryColor,
                child: Row(children: <Widget>[
                  Icon(Icons.shopping_basket, color: Colors.white,),
                  SizedBox(width: 5,),
                  Text("Beli", style: TextStyle(fontSize: 15, color: Colors.white),)
                ],),
                onPressed: () {
                  _detailBeliModalBottomSheet(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

}

class ModalBottomSheet extends StatefulWidget {
  ModalBottomSheet({this.nama,this.id,this.harga,this.qty,this.qtyinc,this.picture,this.price,this.add,this.sub});
  final String nama;
  final String id;
  final int harga;
  final int qty;
  final int qtyinc;
  final String picture;
  final String price;
  final Function() add;
  final Function() sub;
  _ModalBottomSheetState createState() => _ModalBottomSheetState();
}

class _ModalBottomSheetState extends State<ModalBottomSheet> with SingleTickerProviderStateMixin {
  var heightOfModalBottomSheet = 100.0;
  int inc=1;
  bool isLoading = false;
  int row;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  String notif = '';

  Future cek() async{
    var test = await AddressProvider().fetchAlamat();
    row = test.result.length;
    if(row > 0){
      setState(() {
        isLoading  = false;
      });
      _navigatetoBayar(context,widget.nama,widget.id,inc,(widget.harga*inc),widget.picture,widget.price);
    }else{
      setState(() {
        isLoading  = false;
      });
      return Alert(
        style: AlertStyle(
            titleStyle: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),
            descStyle: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontFamily: 'Rubik')
        ),
        context: context,
        type: AlertType.warning,
        title: "Maaf, Anda Belum Mempunyai Alamat",
        desc: "",
        buttons: [
          DialogButton(
            child: Text(
              "Kembali",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DashboardThreePage(),
                ),
              )
            },
            gradient: LinearGradient(colors: [
              Color.fromRGBO(116, 116, 191, 1.0),
              Color.fromRGBO(52, 138, 199, 1.0)
            ]),
          )
        ],
      ).show();
    }
  }

//  Future addProduct() async{
//    var res = await ProductMlmSuplemenProvider().addProduct(widget.id,widget.harga,inc);
//    if(res.status == 'success'){
////      Navigator.pop(context, "success");
//      return showInSnackBar("Produk Berhasil Dimasukan Ke Keranjang");
//    }else{
//      return showInSnackBar(res.msg);
//    }
//  }


  void showInSnackBar(String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    scaffoldKey.currentState?.removeCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            fontFamily: "Rubik"),
      ),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 3),
    ));
  }


  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return  Scaffold(

      key: scaffoldKey,
      body: Container(
          height: MediaQuery.of(context).size.height/3,
          padding: EdgeInsets.only(left: 10, right: 10),
          //margin: EdgeInsets.only(top: 10),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 10,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Image.network(widget.picture, width: _width/4, height: _width/4, fit: BoxFit.cover,),
                    SizedBox(width: 5,),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("${widget.nama}"),
                          Text("${widget.price}"),
                          Text("Stok : ${widget.qty}")
                        ],
                      ),
                    ),
                    SizedBox(width: _width/9,),
                    Container(
                      // width: _width/2,
                      // height: _width/4,
                        child: Column(
                          children: <Widget>[
                            Text("Jumlah"),
                            Row(
                              children: <Widget>[
                                Container(
                                  height:30.0,
                                  width: 30.0,
                                  child: new FloatingActionButton(
                                    onPressed: () async { inc+=1;WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));},
                                    child: new Icon(Icons.add, color: Colors.black,),
                                    backgroundColor: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 10.0,),
                                new Text("$inc",style: new TextStyle(fontSize: 20.0)),
                                SizedBox(width: 10.0,),

                                Container(
                                  height:30.0,
                                  width: 30.0,
                                  child: new FloatingActionButton(
                                    onPressed: () async { if(inc!=1)inc-=1;WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));},
                                    child: new Icon(
                                        const IconData(0xe15b, fontFamily: 'MaterialIcons'),
                                        color: Colors.black
                                    ),
                                    backgroundColor: Colors.white,
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                    )
                  ],
                ),
                SizedBox(height: 5,),
                Divider(),
                ConstrainedBox(
                  constraints: new BoxConstraints(
                    minHeight: 35.0,
                    maxHeight: _height/3,
                  ),

                  child: new ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      SizedBox(height: 20),
                      ConstrainedBox(
                        constraints: const BoxConstraints(minWidth: double.infinity),
                        child: new FlatButton(
                          color: Styles.primaryColor,
                          onPressed: () {
                            print('proses');
//                            addProduct();
                          },
                          child: Text("Beli", style: TextStyle(color: Colors.white),),
                        ),
                      ),

                    ],
                  ),
                )
              ]
          )
      ),
    );
  }

  _navigatetoBayar(BuildContext context,name,id,qty,harga,picture,price) {
//    Navigator.push(
//      context,
//      MaterialPageRoute(
//        builder: (context) => BayarProdukMlmUI(
//            name:name,
//            id: id,
//            qty:qty,
//            harga:harga,
//            picture:picture,
//            price:price
//        ),
//      ),
//    );
  }
}
//
//class Mclipper extends CustomClipper<Path> {
//  @override
//  Path getClip(Size size) {
//    var path = new Path();
//    path.lineTo(0.0, size.height - 10.0);
//
//    var controlPoint = Offset(size.width / 4, size.height);
//    var endpoint = Offset(size.width / 2, size.height);
//
//    path.quadraticBezierTo(
//        controlPoint.dx, controlPoint.dy, endpoint.dx, endpoint.dy);
//
//    var controlPoint2 = Offset(size.width * 3 / 4, size.height);
//    var endpoint2 = Offset(size.width, size.height - 40.0);
//
//    path.quadraticBezierTo(
//        controlPoint2.dx, controlPoint2.dy, endpoint2.dx, endpoint2.dy);
//
//    path.lineTo(size.width, 0.0);
//
//    return path;
//  }
//
//  @override
//  bool shouldReclip(CustomClipper<Path> oldClipper) {
//    return true;
//  }
//}
