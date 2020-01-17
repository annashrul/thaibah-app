import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/MLM/listCartModel.dart';
import 'package:thaibah/UI/Homepage/index.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/component/MLM/checkoutSuplemen.dart';
import 'package:thaibah/UI/component/address/addAddress.dart';
import 'package:thaibah/bloc/MLM/detailChekoutSuplemenBloc.dart';
import 'package:thaibah/bloc/productMlmBloc.dart';
import 'package:thaibah/resources/MLM/getDetailChekoutSuplemenProvider.dart';
import 'package:thaibah/resources/addressProvider.dart';
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
    print(total);
    print(newBerat);
    print(jumlahQty);
//    var cek = await DetailCheckoutSuplemenProvider().fetchDetailCheckoutSuplemen();
//    cek.result.address;
    var test = await AddressProvider().fetchAlamat();
    if(test.result.length > 0){
      setState(() {
        isLoading = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CheckOutSuplemen(total:total,berat: newBerat,totQty:jumlahQty),
        ),
      );
    }
    else{
      setState(() {
        isLoading  = false;
      });
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
          content: Text('Silahkan isi  alamat lengkap untuk pengiriman barang ke tempat anda',style: TextStyle(color:Colors.white,fontFamily: 'Rubik',fontWeight: FontWeight.bold),),
          action: SnackBarAction(
            textColor: Colors.green,
            label: 'Buat Alamat',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddAddress(),
                ),
              );
            },
          ),
        )
      );
    }
  }


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
  void initState() {
    // TODO: implement initState
    super.initState();
    listCartBloc.fetchListCart();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
//    listCartBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      bottomNavigationBar: _bottomNavBarBeli(context),
      key: scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.keyboard_backspace,color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
        elevation: 1.0,
        automaticallyImplyLeading: true,
        title: new Text("Keranjang Belanja", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),

      ),
      body: StreamBuilder(
        key: _refreshIndicatorKey,
        stream: listCartBloc.getResult,
        builder: (context, AsyncSnapshot<ListCartModel> snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: <Widget>[
                Expanded(
                  flex: 10,
                  child: buildContent(snapshot,context),
                ),
                Expanded(flex: 1,child: Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Total Tagihan", style: TextStyle(color: Colors.black54),),
                          SizedBox(height: 5.0),
                          Text("Rp ${formatter.format(snapshot.data.result.rawTotal)}", style: TextStyle(color: Colors.red,fontFamily: 'Rubik',fontWeight: FontWeight.bold),),

                        ],
                      ),
                      Container(
                          height: kBottomNavigationBarHeight,
                          child: FlatButton(
                            shape:RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10)),
                            ),
                            color: Colors.green,
                            onPressed: (){
                              setState(() {
                                isLoading = true;
                              });
                              cek(snapshot.data.result.rawTotal,weight,snapshot.data.result.jumlah);
                            },
                            child:isLoading?Text("Pengecekan Data ....", style: TextStyle(color: Colors.white)):Text("Lanjut", style: TextStyle(color: Colors.white)),

                          )
                      )

                    ],
                  ),
                ))
              ],
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
//          return _AnimatedFlutterLogoState();
          return Container(
            child: Center(
              child: Text('Data Tidak Ada'),
            ),
          );
        },
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
      print('pindah');
    }
  }

  @override
  Widget build(BuildContext context) {
      return Card(
        color: widget.warna,
        elevation: 0.0,
        child: Row(
          children: <Widget>[
            const SizedBox(width: 10.0),
            Container(
                height: 80.0,
                width: 100,
                child: Image.network(
                  widget.CartProdPicture,
                  height: 80.0,
                )
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: Container(
                height: 120.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(widget.CartProdName,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                    SizedBox(height: 10.0),
                    new Text("Rp ${formatter.format(updatePrice)}",style: TextStyle(color: Colors.red,fontFamily: 'Rubik'),),
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
                          content: Text("Anda Yakin Akan Menghapus produk Ini ???"),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("Batal", style: TextStyle(color: Colors.black)),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            FlatButton(
                              child: Text("Hapus", style: TextStyle(color: Colors.red),),
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
        Text(
          "${cartQty.toString()}",
          textAlign: TextAlign.right,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 10.0),
        InkWell(
          onTap: _subtract,
          child: Icon(Icons.remove_circle,color: Color(0xFF30cc23)),
        ),
      ],
    );
  }
}

class ChangeTotalState extends StatefulWidget {
  final CartTot;
  ChangeTotalState({this.CartTot});

  @override
  _ChangeTotalStateState createState() => _ChangeTotalStateState();
}

class _ChangeTotalStateState extends State<ChangeTotalState>   with WidgetsBindingObserver  {
  int total = 0;
  AppLifecycleState _lastLifecycleState;
  final formatter = new NumberFormat("#,###");

//
//  Future changeTotal() async{
//    var res = await ProductMlmSuplemenProvider().fetchListCart();
//    setState(() {});
//    total = res.result.rawTotal;
//  }

  @override
  void initState() {
//    changeTotal();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if(total != widget.CartTot){
      setState(() {
        total = widget.CartTot;
      });
    }


  }


//  @override
//  void setState(fn) {
//    // TODO: implement setState
//    super.setState(fn);
//    changeTotal();
//  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _lastLifecycleState = state;
    });
  }
  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }
  @override
  Widget build(BuildContext context) {
    return new Text('Rp ${formatter.format(total)}',style:TextStyle(color:Colors.red,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),);
  }
}