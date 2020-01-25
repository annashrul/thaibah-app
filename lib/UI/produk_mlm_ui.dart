
import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:loadmore/loadmore.dart';
import 'package:thaibah/Model/MLM/listCartModel.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/Model/mainUiModel.dart';
import 'package:thaibah/Model/productMlmSuplemenModel.dart';
import 'package:thaibah/UI/Homepage/index.dart';
import 'package:thaibah/UI/Widgets/tab_kavling_ui.dart';
import 'package:thaibah/UI/Widgets/tab_suplemen_ui.dart';
import 'package:thaibah/UI/component/keranjang.dart';
import 'package:thaibah/bloc/productMlmBloc.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/style.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:thaibah/resources/configProvider.dart';
import 'package:thaibah/resources/productMlmSuplemenProvider.dart';

import 'Widgets/skeletonFrame.dart';
import 'package:http/http.dart' as http;

class ProdukMlmUI extends StatefulWidget {


  @override
  _ProdukMlmUIState createState() => _ProdukMlmUIState();
}

class _ProdukMlmUIState extends State<ProdukMlmUI> with SingleTickerProviderStateMixin  {

  bool isExpanded = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  double _height;
//  ScrollController _scrollViewController;
  TabController _tabController;
  double _width;
  bool isLoading = false;
  int inc = 0;
  int total = 0;
  final userRepository = UserRepository();
  String versionCode = '';
  bool versi = false;
  Future cekVersion() async {
    String id = await userRepository.getID();
    var jsonString = await http.get(ApiService().baseUrl+'info?id='+id);
    if (jsonString.statusCode == 200) {
      final jsonResponse = json.decode(jsonString.body);
      Info response = new Info.fromJson(jsonResponse);
      versionCode = (response.result.versionCode);
      setState(() {
        isLoading = false;
      });
      if(versionCode != ApiService().versionCode){
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => UpdatePage()), (Route<dynamic> route) => false);
      }
      print("###########################################################LOAD DATA HOME###############################################################");
      print(jsonResponse);
    } else {
      throw Exception('Failed to load info');
    }

  }

  Future addCart(var id, var harga, var qty, var weight) async{
    setState(() {});
//    print(harga);
    var res = await ProductMlmSuplemenProvider().addProduct(id,harga,qty,weight);
    if(res.status == 'success'){
      countCart();
      return showInSnackBar("Produk Berhasil Dimasukan Ke Keranjang");
    }else{
      Navigator.pop(context);
      return showInSnackBar(res.msg);
    }
  }

  Future<void> countCart() async{
    var res = await ProductMlmSuplemenProvider().fetchListCart();
    if(res is ListCartModel){
      ListCartModel results = res;
      if(results.status == 'success'){
        setState(() {});
        total = res.result.jumlah;
      }
    }else{
      setState(() {
        total = 0;
      });
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
      backgroundColor: Colors.green,
      duration: Duration(seconds: 3),
    ));
  }

  int perpage = 10;

  void load() {
    print("load $perpage");
    setState(() {
      perpage = perpage += 10;
    });
    productMlmSuplemenBloc.fetchProductMlmSuplemenList(1,perpage);
    print(perpage);
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    productMlmSuplemenBloc.fetchProductMlmSuplemenList(1,perpage);
  }

  Future<bool> _loadMore() async {
    print("onLoadMore");
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    print("load $perpage");
    setState(() {
      perpage = perpage += 10;
    });
    productMlmSuplemenBloc.fetchProductMlmSuplemenList(1,perpage);
    print(perpage);
    return true;
  }






  @override
  void initState() {
    super.initState();
    countCart();
    cekVersion();
    versi = true;
    if(mounted){
      productMlmSuplemenBloc.fetchProductMlmSuplemenList(1,perpage);
    }
    print("###################### $mounted ###########################");
  }
//
  @override
  void dispose() {
    super.dispose();
  }


//  @override
//  void dispose() {
//    _tabController.dispose();
//    super.dispose();
//  }
//
//  @override
//  void initState() {
//    countCart();
//    super.initState();
//    _tabController = new TabController(vsync: this, length: 2);
//    productMlmSuplemenBloc.fetchProductMlmSuplemenList(1,1);
//
//  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        actions: <Widget>[
          new Stack(
            children: <Widget>[
              new IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {
                if(total!=0){
                  Navigator.of(context).push(new MaterialPageRoute(builder: (_) => Keranjang())).whenComplete(countCart);
                }
              }),
              total != 0 ?new Positioned(
                right: 11,
                top: 11,
                child: new Container(
                  padding: EdgeInsets.all(2),
                  decoration: new BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(minWidth: 14, minHeight: 14,),
                  child: Text('$total', style: TextStyle(color: Colors.white, fontSize: 8,), textAlign: TextAlign.center),
                ),
              ):Container()
            ],
          ),
        ],
        centerTitle: false,
        elevation: 0.0,
        automaticallyImplyLeading: true,
        title: new Text("Produk Kami", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
      ),
      body: StreamBuilder(
        stream: productMlmSuplemenBloc.allProductMlmSuplemen,
        builder: (context, AsyncSnapshot<ProductMlmSuplemenModel> snapshot) {
          // print(snapshot.hasData);
          if (snapshot.hasData) {
            return buildContent(snapshot, context);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Padding(
              padding: const EdgeInsets.only(top:20.0,left:5.0,right:5.0,bottom:5.0),
              child: ListView.builder(
                primary: false,
                physics: ScrollPhysics(),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return new GestureDetector(
                      onTap: (){
                      },
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
                        child: new Column(
                          children: <Widget>[
                            new Stack(
                              children: <Widget>[
                                //new Center(child: new CircularProgressIndicator()),
                                new Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        topRight: Radius.circular( 10.0)
                                    ),
                                    child: SkeletonFrame(width: double.infinity,height: MediaQuery.of(context).size.height/2),
                                  ),
                                ),
                              ],
                            ),
                            new Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: new Column(
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 7,
                                            child: Container(
                                              padding: EdgeInsets.only(top:5.0),
                                              // decoration: BoxDecoration(color: Styles.primaryColor),
                                              child: SkeletonFrame(width:MediaQuery.of(context).size.height/2,height: 16.0),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Container(
                                                padding: EdgeInsets.only(top:5.0),
                                                // decoration: BoxDecoration(color: Styles.primaryColor),
                                                child: Align(
                                                  alignment: Alignment.topRight,
                                                  child: SkeletonFrame(width:MediaQuery.of(context).size.height/2,height: 16.0),
                                                )
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top:5.0),
                                        child: SkeletonFrame(width:MediaQuery.of(context).size.height/2,height: 16.0),
                                      ),

                                      Container(
                                        padding: EdgeInsets.only(top:5.0),
                                        child: SkeletonFrame(width:MediaQuery.of(context).size.height/1,height: 100.0),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                  );
                },
              )
          );
        },
      ),
    );
  }

  Widget buildContent(AsyncSnapshot<ProductMlmSuplemenModel> snapshot, BuildContext context) {
    if(snapshot.data.result.data.length > 0){
      return RefreshIndicator(
          child: Padding(
              padding: const EdgeInsets.only(top:20.0,left:5.0,right:5.0,bottom:5.0),
              child: LoadMore(
                child: ListView.builder(
                  primary: false,
                  physics: ScrollPhysics(),
                  itemCount: snapshot.data.result.data.length,
                  itemBuilder: (context, index) {
//                    print(snapshot.data.result.data[index].satuanBarang);
//                    print(snapshot.data.result.data[index].satuanBarang.substring(snapshot.data.result.data[index].satuanBarang.length - 3));
//                    String satuanBrg = '';
//                    if(snapshot.data.result.data[index].satuanBarang.substring(snapshot.data.result.data[index].satuanBarang.length - 3) == 'btl'){
//                      print("substring");
//                      satuanBrg = snapshot.data.result.data[index].satuanBarang.substring(snapshot.data.result.data[index].satuanBarang.length - 3);
////                      print(snapshot.data.result.data[index].satuanBarang.substring(snapshot.data.result.data[index].satuanBarang.length - 3));
//                    }else{
//                      print("glebegan");
//                      satuanBrg = snapshot.data.result.data[index].satuanBarang.substring(snapshot.data.result.data[index].satuanBarang.length - 2);
////                      print(snapshot.data.result.data[index].satuanBarang);
//                      print(snapshot.data.result.data[index].satuanBarang);
//                    }
//                    if()
//                    print("pure = "+ snapshot.data.result.data[index].satuanBarang);
//                    print("teu pure = "+ snapshot.data.result.data[index].satuanBarang.split(" ").elementAt(1));
                    return  GestureDetector(
                        onTap: (){
                          if(snapshot.data.result.data[index].qty != 0){
                            addCart(snapshot.data.result.data[index].id,int.parse(snapshot.data.result.data[index].totalPrice),"1",snapshot.data.result.data[index].weight.toString());
                          }else{
                            print('gagal');
                          }
                        },
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
                          child: new Column(
                            children: <Widget>[
                              new Stack(
                                children: <Widget>[
                                  //new Center(child: new CircularProgressIndicator()),
                                  new Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10.0),
                                          topRight: Radius.circular( 10.0)
                                      ),
                                      child: Image.network(snapshot.data.result.data[index].picture),
                                    ),
                                  ),
                                ],
                              ),
                              new Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: new Column(
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 7,
                                              child: Container(
                                                padding: EdgeInsets.all(5),
                                                // decoration: BoxDecoration(color: Styles.primaryColor),
                                                child: Text(snapshot.data.result.data[index].title,style: TextStyle(color: Colors.green,fontFamily: 'Rubik',fontSize: 20.0,fontWeight: FontWeight.bold),),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Container(
                                                  padding: EdgeInsets.all(5),
                                                  // decoration: BoxDecoration(color: Styles.primaryColor),
                                                  child: Align(
                                                    alignment: Alignment.topRight,
                                                    child: Text("Sisa "+snapshot.data.result.data[index].qty.toString(), style: TextStyle(fontFamily: 'Rubik',color: Colors.black54),),
                                                  )
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(5),
                                          child: Text("Harga : "+ snapshot.data.result.data[index].satuan+"/${snapshot.data.result.data[index].satuanBarang}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Rubik'),),
                                        ),

                                        Container(
                                          padding: EdgeInsets.all(5),
                                          child: Html(
                                            data: snapshot.data.result.data[index].descriptions,
                                            defaultTextStyle: TextStyle(fontFamily: 'Rubik'),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex: 7,
                                                child: Container(
                                                  padding: EdgeInsets.all(5),
                                                  // decoration: BoxDecoration(color: Styles.primaryColor),
                                                  child: Text('',style: TextStyle(color: Colors.black54)),
                                                ),
                                              ),
                                              SizedBox(width: 5,),

                                              Expanded(
                                                flex: 2,
                                                child: Container(
                                                  // padding: EdgeInsets.all(5),
                                                    decoration: BoxDecoration(color:Colors.green),
                                                    child: Align(
                                                        alignment: Alignment.center,
                                                        child: FlatButton(
                                                          child: Icon(Icons.add_shopping_cart, color: Colors.white),
                                                          onPressed: () {
                                                            if(snapshot.data.result.data[index].qty != 0){
                                                              addCart(snapshot.data.result.data[index].id,int.parse(snapshot.data.result.data[index].totalPrice),"1",snapshot.data.result.data[index].weight.toString());
//                                                        widget.onItemInteraction(snapshot.data.result.data[index].id,int.parse(snapshot.data.result.data[index].totalPrice),"1",snapshot.data.result.data[index].weight.toString());
                                                            }else{

                                                            }
                                                          },
                                                        )
                                                    )
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                    );
                  },
                ),
                onLoadMore: _loadMore,
                whenEmptyLoad: true,
                delegate: DefaultLoadMoreDelegate(),
                textBuilder: DefaultLoadMoreTextBuilder.english,
                isFinish: snapshot.data.result.data.length < perpage,
              )
          ),
          onRefresh: _refresh
      );
    }else{
      return Container(
        child: Center(
          child:Text('Tida Ada Data')
        ),
      );
    }
  }
}
