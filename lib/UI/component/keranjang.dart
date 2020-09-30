import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/MLM/getDetailChekoutSuplemenModel.dart';
import 'package:thaibah/Model/MLM/listCartModel.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/component/MLM/checkoutSuplemen.dart';
import 'package:thaibah/UI/component/address/formAddress.dart';
import 'package:thaibah/bloc/productMlmBloc.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:thaibah/resources/MLM/getDetailChekoutSuplemenProvider.dart';
import 'package:thaibah/resources/productMlmSuplemenProvider.dart';

class Keranjang extends StatefulWidget {
  @override
  _KeranjangState createState() => _KeranjangState();
}

class _KeranjangState extends State<Keranjang> {
  int subTotal = 0;
  int weight = 0;
  int qty = 0;
  int rawPrice = 0;
  bool isLoading = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  final formatter = new NumberFormat("#,###");


  Future cek(var total,var berat, var jumlahQty) async{
    var newBerat = berat*jumlahQty;
    var test = await DetailCheckoutSuplemenProvider().fetchDetailCheckoutSuplemen();

    if(test is GetDetailChekoutSuplemenModel){
      GetDetailChekoutSuplemenModel results = test;
      setState(() {Navigator.pop(context);});
      if(test.status == 'success'){
        Navigator.push(context, CupertinoPageRoute(builder: (context) => CheckOutSuplemen(
                total:total,
                berat: newBerat,
                totQty:jumlahQty,
                saldoVoucher:results.result.saldoVoucher,
                saldoMain: results.result.saldoMain,
                address: results.result.address,
                kdKec: results.result.kdKec,
                kecPengirim: results.result.kecPengirim,
                masaVoucher: results.result.masaVoucher,
                showPlatinum: results.result.platinumShow,
                saldoPlatinum: results.result.saldoPlatinum,
                saldoGabungan: results.result.saldoGabunganUtama,
              )));
      }else{
        UserRepository().notifNoAction(scaffoldKey, context,results.msg,"failed");
      }
    }
    else{
      setState(() {Navigator.pop(context);});
      General results = test;
      if(results.msg == 'Alamat kosong.'){
        setState(() {isLoading  = false;});
        UserRepository().notifWithAction(scaffoldKey, context, 'Silahkan isi  alamat lengkap untuk pengiriman barang ke tempat anda', 'failed','BUAT ALAMAT',(){
          Navigator.push(context, CupertinoPageRoute(builder: (context) =>  FormAddress(param: '')));
        });
      }else{
        UserRepository().notifNoAction(scaffoldKey, context,results.msg,"failed");
      }

    }

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
    // TODO: implement initState
    super.initState();
    loadTheme();
    listCartBloc.fetchListCart();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false)..init(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: UserRepository().appBarWithButton(context, "Keranjang Belanja",(){Navigator.pop(context);},<Widget>[]),

      // appBar:UserRepository().appBarWithButton(context, "Keranjang Belanja",warna1,warna2,(){Navigator.of(context).pop();},Container()),
      body: StreamBuilder(
        key: _refreshIndicatorKey,
        stream: listCartBloc.getResult,
        builder: (context, AsyncSnapshot<ListCartModel> snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: <Widget>[
                Expanded(
                  flex: 9,
                  child: buildContent(snapshot,context),
                ),

              ],
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Container(
            child: Center(
              child:RichText(text: TextSpan(text:'Data Tidak Tersedia', style: TextStyle(fontSize:14,color: Colors.black,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold))),
            ),
          );
        },
      ),
      bottomNavigationBar: StreamBuilder(

        stream: listCartBloc.getResult,
        builder: (context, AsyncSnapshot<ListCartModel> snapshot) {
          if (snapshot.hasData) {
            return _bottomNavBarBeli(context, snapshot.data.result.rawTotal,snapshot.data.result.jumlah);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Text('');
        },
      ),

    );
  }

  Widget _bottomNavBarBeli(BuildContext context,total,jumlah){
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RichText(text: TextSpan(text:'Total Belanja', style: TextStyle(fontSize: 12.0,color: Colors.grey,fontWeight: FontWeight.bold,fontFamily: ThaibahFont().fontQ))),
              RichText(text: TextSpan(text:'Rp ${formatter.format(total)}', style: TextStyle(fontSize: 12.0,color: Colors.red,fontWeight: FontWeight.bold,fontFamily: ThaibahFont().fontQ))),
            ],
          ),
          Container(
              height: kBottomNavigationBarHeight,
              child: FlatButton(
                shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10)),
                ),
                color: ThaibahColour.primary2,
                onPressed: (){
                  setState(() {
                    UserRepository().loadingQ(context);
                  });
                  cek(total,weight,jumlah);
                },
                child:RichText(text: TextSpan(text:'Lanjut', style: TextStyle(fontSize: 14.0,color: Colors.white,fontWeight: FontWeight.bold,fontFamily: ThaibahFont().fontQ))),
              )
          )
        ],
      ),
    );
  }


  Widget buildContent(AsyncSnapshot<ListCartModel> snapshot, BuildContext context){
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;

    if(snapshot.data.result.data.length > 0){
      return  Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
                itemCount: snapshot.data.result.data.length,
                itemBuilder: (context,index){
                  weight = int.parse(snapshot.data.result.data[index].weight)+int.parse(snapshot.data.result.data[index].weight);
                  qty = int.parse(snapshot.data.result.data[index].qty)+int.parse(snapshot.data.result.data[index].qty);
                  rawPrice = snapshot.data.result.data[index].rawTotalPrice;
                  subTotal = snapshot.data.result.rawTotal;
                  print(subTotal);
                  return SingleCartProduct(
                    height: _height,
                    width: _width,
                    CartProdName: snapshot.data.result.data[index].title,
                    CartProdPicture: snapshot.data.result.data[index].picture,
                    CartProdPrice: int.parse(snapshot.data.result.data[index].rawPrice),
                    CartProdQuantity: int.parse(snapshot.data.result.data[index].qty),
                    CardProdId: snapshot.data.result.data[index].id,
                    CardProdTotal: subTotal,
                    warna: (index % 2 == 0) ? Colors.white : Color(0xFFF7F7F9),
                  );
                }
            ),
          ),


        ],
      );
    }else{
      return Container(
        child: Center(
          child: Text("Keranjang Kosong"),
        ),
      );
    }

  }


}

class SingleCartProduct extends StatefulWidget {
  final height;final width;
  final CartProdName;
  final CartProdPicture;
  final CartProdPrice;
  final CartProdQuantity;
  final CardProdId;
  final CardProdTotal;
  Color warna;
  Function() onDelete;

  SingleCartProduct({
    this.height,this.width,
    this.CartProdName,
    this.CartProdPicture,
    this.CartProdPrice,
    this.CartProdQuantity,
    this.CardProdId,
    this.CardProdTotal,
    this.warna,
    this.onDelete
  });

  @override
  State<StatefulWidget> createState() {
    return SingleCartProductState();
  }

}
class SingleCartProductState extends State<SingleCartProduct> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  int totalQuantity=1;int updateStok;int updatePrice;String id='';
  final formatter = new NumberFormat("#,###");
  bool _isLoading = false;
  @override
  void initState() {
    totalQuantity = widget.CartProdQuantity;
    updatePrice = widget.CartProdPrice*totalQuantity;
    updateStok = widget.CartProdQuantity;
    id = widget.CardProdId;
//    ChangeTotalState();
    super.initState();
//    listCartBloc.fetchListCart();

  }
  void setState(fn) {
    // TODO: implement setState
    super.setState(fn);
    id = widget.CardProdId;
    if(totalQuantity>1){
      updatePrice = widget.CartProdPrice*totalQuantity;
//      ChangeTotalState();

    }

    if(totalQuantity == 1){
      updatePrice = widget.CartProdPrice;
//      ChangeTotalState();
    }

  }

  Future delete(id) async{
    var res = await ProductMlmSuplemenProvider().deleteProduct(id);
    if(res.status == 'success'){

      listCartBloc.fetchListCart();

    }else{
      print("#################### GAGAL MENGHAPUS DATA PRODUCT ###########################");
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Card(
        color: widget.warna,
        elevation: 0.0,
        child: Row(
          children: <Widget>[
            const SizedBox(width: 10.0),
            Container(
              height: 80.0,
              width: 100,
              child: CachedNetworkImage(
                imageUrl: widget.CartProdPicture,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))),
                ),
                errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: new BorderRadius.circular(10.0),
                    color: Colors.transparent,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.fill,
                    ),
                    boxShadow: [new BoxShadow(color:Colors.transparent,blurRadius: 5.0,offset: new Offset(2.0, 5.0))],
                  ),
                ),
              ),
//
//                child: Image.network(
//                  widget.CartProdPicture,
//                  height: 80.0,
//                )
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: Container(
                height: 120.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    RichText(text: TextSpan(text:widget.CartProdName, style: TextStyle(fontSize:12,color: Colors.black,fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ))),
                    SizedBox(height: 10.0),
                    RichText(text: TextSpan(text:"Rp ${formatter.format(updatePrice)}", style: TextStyle(fontSize:12,color: Colors.red,fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ))),
                    SizedBox(height: 10.0),
                    ChangeQuantity(
                        valueChanged: (int newValue){
                          setState(() {
                            totalQuantity = newValue;
                          });
                        },
                        total:widget.CardProdTotal,
                        id: widget.CardProdId,
                        cartQty: int.parse('${totalQuantity.toString()}')
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10.0),
            Row(
              children: <Widget>[
                InkWell(
                  onTap: (){
                    showDialog(
                        context: context,
                        builder: (BuildContext context){
                          return AlertDialog(
                            content: RichText(text: TextSpan(text:"Anda Yakin Akan Menghapus produk Ini ???", style: TextStyle(fontSize:12,color: Colors.black,fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ))),
                            actions: <Widget>[
                              FlatButton(
                                // child: Text("Batal", style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(26),color: Colors.black,fontFamily: ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
                                child:RichText(text: TextSpan(text:"Batal", style: TextStyle(fontSize:12,color: Colors.black,fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ))),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child:RichText(text: TextSpan(text:"Hapus", style: TextStyle(fontSize:12,color: Colors.red,fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ))),
                                onPressed: () async {
                                  setState(() {});
                                  delete(widget.CardProdId);
//                                setState(() {
//                                  _isLoading = true;
//                                });
//                                delete(id);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        }
                    );
                  },
                  child: Icon(Icons.cancel,color: Colors.redAccent,),
                )
              ],
            ),

            const SizedBox(width: 10.0),
          ],
        ),
      );

  }
}

class ChangeQuantity extends StatelessWidget {
  ChangeQuantity({Key key, this.cartQty,this.total, this.id, this.valueChanged}): super(key: key);
  final int cartQty; final String id; final int total;
  final ValueChanged<int> valueChanged;

  _add() {
    int cartTotalQty = cartQty;
    cartTotalQty++;
    valueChanged(cartTotalQty);
    update(id,cartTotalQty);
//    ChangeTotalState();
  }
  _subtract() {
    int cartTotalQty = cartQty;
    if (cartTotalQty != 1) cartTotalQty--;
    valueChanged(cartTotalQty);
    update(id,cartTotalQty);
  }

  Future update(id,qty) async{
    var res = await ProductMlmSuplemenProvider().updateProduct(id, qty);
    if(res.status == 'success'){
      listCartBloc.fetchListCart();
    }else{
      print(res.msg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        InkWell(
          onTap: _add,
          child: Icon(Icons.add_circle,color: Color(0xFF116240)),
        ),
        SizedBox(width: 10.0),
        RichText(textAlign: TextAlign.right,text: TextSpan(text:"${cartQty.toString()}", style: TextStyle(fontSize:12,color: Colors.black,fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ))),

        SizedBox(width: 10.0),
        InkWell(
          onTap: _subtract,
          child: Icon(Icons.remove_circle,color: Color(0xFF30cc23)),
        ),
      ],
    );
  }
}
