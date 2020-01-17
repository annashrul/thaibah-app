//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
//import 'package:flutter_html/flutter_html.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
//import 'package:thaibah/Constants/constants.dart';
//import 'package:thaibah/Model/productMlmSuplemenModel.dart';
//import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
//import 'package:thaibah/UI/detail_produk_mlm_suplemen_ui.dart';
//import 'package:thaibah/bloc/productMlmBloc.dart';
//import 'package:thaibah/config/style.dart';
//
//class TabSuplemenUI extends StatefulWidget {
//  final Function(String id,int harga, String qty, String weight) onItemInteraction;
//  TabSuplemenUI({Key key, this.onItemInteraction}) : super(key: key);
//
////  TabSuplemenUI({Key key}) : super(key: key);
//  @override
//  _TabSuplemenUIState createState() => _TabSuplemenUIState();
//}
//
//class _TabSuplemenUIState extends State<TabSuplemenUI> {
//
//  bool isExpanded = false;
//  var scaffoldKey = GlobalKey<ScaffoldState>();
//
//
//  bool isLoading = false;
//  int totalQuantity=1;
//
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    productMlmSuplemenBloc.fetchProductMlmSuplemenList();
//
//  }
//
//
//  @override
//  void dispose() {
//    // TODO: implement dispose
//    super.dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return StreamBuilder(
//      stream: productMlmSuplemenBloc.allProductMlmSuplemen,
//      builder: (context, AsyncSnapshot<ProductMlmSuplemenModel> snapshot) {
//        // print(snapshot.hasData);
//        if (snapshot.hasData) {
//          return buildContent(snapshot, context);
//        } else if (snapshot.hasError) {
//          return Text(snapshot.error.toString());
//        }
//        return Container(
//          child: Padding(
//              padding: const EdgeInsets.all(5.0),
//              child: new StaggeredGridView.countBuilder(
//                primary: false,
//                physics: ScrollPhysics(),
//                crossAxisCount: 4,
//                mainAxisSpacing: 2.0,
//                crossAxisSpacing: 2.0,
//                itemCount: 4,
//                itemBuilder: (context, index) {
//                  return new GestureDetector(
//                      child: Card(
//                        elevation: 0,
//                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
//                        child: new Column(
//                          children: <Widget>[
//                            new Stack(
//                              children: <Widget>[
//                                new Center(
//                                  child: ClipRRect(
//                                    borderRadius: BorderRadius.only(
//                                      topLeft: Radius.circular(10.0),
//                                      topRight: Radius.circular( 10.0)
//                                    ),
//                                    child: Image.network("http://lequytong.com/Content/Images/no-image-02.png"),
//                                  ),
//                                ),
//                              ],
//                            ),
//                            new Padding(
//                              padding: const EdgeInsets.all(0.0),
//                              child: new Column(
//                                children: <Widget>[
//                                  Column(
//                                    crossAxisAlignment: CrossAxisAlignment.start,
//                                    children: <Widget>[
//                                      Container(
//                                        padding: EdgeInsets.all(5),
//                                        child: SkeletonFrame(width: MediaQuery.of(context).size.width/1,height: 16),
//                                      ),
//                                      Container(
//                                        padding: EdgeInsets.all(5),
//                                        child: SkeletonFrame(width: MediaQuery.of(context).size.width/1,height: 16),
//                                      ),
//                                      Padding(
//                                        padding: const EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
//                                        child: Row(children: <Widget>[
//                                          Expanded(
//                                            flex: 7,
//                                            child: Container(
//                                                padding: EdgeInsets.all(5),
//                                                // decoration: BoxDecoration(color: Styles.primaryColor),
//                                                child: SkeletonFrame(width: MediaQuery.of(context).size.width/2,height: 16),
//                                            ),
//                                          ),
//                                          SizedBox(width: 5,),
//                                          Expanded(
//                                            flex: 3,
//                                            child: Container(
//                                              // padding: EdgeInsets.all(5),
//                                                decoration: BoxDecoration(color: Colors.white),
//                                                child: Align(
//                                                    alignment: Alignment.center,
//                                                    child: FlatButton(
//                                                      child: SkeletonFrame(width: MediaQuery.of(context).size.width/1,height: 30),
//                                                    )
//                                                )
//                                            ),
//                                          ),
//                                        ],),
//                                      ),
//                                    ],
//                                  )
//                                ],
//                              ),
//                            )
//                          ],
//                        ),
//                      )
//                  );
//                },
//                staggeredTileBuilder: (index) => new StaggeredTile.fit(2),
//              )
//          ),
//        );
//      },
//    );
//  }
//
//  Widget buildContent(AsyncSnapshot<ProductMlmSuplemenModel> snapshot, BuildContext context) {
//    return Container(
//      child: Padding(
//          padding: const EdgeInsets.only(top:20.0,left:5.0,right:5.0,bottom:5.0),
//          child: new StaggeredGridView.countBuilder(
//            primary: false,
//            physics: ScrollPhysics(),
//            crossAxisCount: 2,
//            mainAxisSpacing: 2.0,
//            crossAxisSpacing: 2.0,
////            crossAxisCount: 4,
////            mainAxisSpacing: 2.0,
////            crossAxisSpacing: 2.0,
//            itemCount: snapshot.data.result.data.length,
//            itemBuilder: (context, index) {
//              return new GestureDetector(
//                  onTap: (){
//                    Navigator.of(context, rootNavigator: true).push(
//                      new CupertinoPageRoute(
//                        fullscreenDialog: true,
//                        builder: (context) => DetailProdukMlmSuplemeniUI(
//                          id:snapshot.data.result.data[index].id,
//                          penjual: snapshot.data.result.data[index].penjual,
//                          title: snapshot.data.result.data[index].title,
//                          type: snapshot.data.result.data[index].type.toString(),
//                          price: snapshot.data.result.data[index].price,
//                          satuan: snapshot.data.result.data[index].satuan,
//                          raw_price: int.parse(snapshot.data.result.data[index].rawPrice),
//                          ppn: snapshot.data.result.data[index].ppn,
//                          total_ppn: snapshot.data.result.data[index].totalPpn,
//                          weight: snapshot.data.result.data[index].weight,
//                          qty: snapshot.data.result.data[index].qty.toString(),
//                          picture: snapshot.data.result.data[index].picture,
//                          descriptions: snapshot.data.result.data[index].descriptions,
//                          category: snapshot.data.result.data[index].category,
//                        ),
//                      ),
//                    );
//                  },
//                  child: Card(
//                    elevation: 0,
//                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
//                    child: new Column(
//                      children: <Widget>[
//                        new Stack(
//                          children: <Widget>[
//                            //new Center(child: new CircularProgressIndicator()),
//                            new Center(
//                              child: ClipRRect(
//                                borderRadius: BorderRadius.only(
//                                    topLeft: Radius.circular(10.0),
//                                    topRight: Radius.circular( 10.0)
//                                ),
//                                child: Image.network(snapshot.data.result.data[index].picture),
//                              ),
//                            ),
//                          ],
//                        ),
//                        new Padding(
//                          padding: const EdgeInsets.all(0.0),
//                          child: new Column(
//                            children: <Widget>[
//                              Column(
//                                crossAxisAlignment: CrossAxisAlignment.start,
//                                children: <Widget>[
//                                  Row(
//                                    children: <Widget>[
//                                      Expanded(
//                                        flex: 7,
//                                        child: Container(
//                                            padding: EdgeInsets.all(5),
//                                            // decoration: BoxDecoration(color: Styles.primaryColor),
//                                          child: Text(snapshot.data.result.data[index].title,style: TextStyle(color: Colors.green,fontFamily: 'Rubik',fontSize: 20.0,fontWeight: FontWeight.bold),),
//                                        ),
//                                      ),
//                                      Expanded(
//                                        flex: 3,
//                                        child: Container(
//                                            padding: EdgeInsets.all(5),
//                                            // decoration: BoxDecoration(color: Styles.primaryColor),
//                                            child: Align(
//                                              alignment: Alignment.topRight,
//                                              child: Text("Sisa "+snapshot.data.result.data[index].qty.toString()+" ${snapshot.data.result.data[index].satuanBarang.substring(snapshot.data.result.data[index].satuanBarang.length - 3)}", style: TextStyle(color: Colors.black54),),
//                                            )
//                                        ),
//                                      ),
//                                    ],
//                                  ),
//                                  Container(
//                                    padding: EdgeInsets.all(5),
//                                    child: Text("Harga : "+ snapshot.data.result.data[index].satuan+"/${snapshot.data.result.data[index].satuanBarang}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Rubik'),),
//                                  ),
//
//                                  Container(
//                                    padding: EdgeInsets.all(5),
//                                    child: Html(
//                                        data: snapshot.data.result.data[index].descriptions,
//                                      defaultTextStyle: TextStyle(fontFamily: 'Rubik'),
//                                    ),
//                                  ),
//                                  Padding(
//                                    padding: const EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
//                                    child: Row(
//                                      children: <Widget>[
//                                      Expanded(
//                                        flex: 7,
//                                        child: Container(
//                                            padding: EdgeInsets.all(5),
//                                            // decoration: BoxDecoration(color: Styles.primaryColor),
//                                            child: Text('',style: TextStyle(color: Colors.black54)),
//                                        ),
//                                      ),
//                                      SizedBox(width: 5,),
////                                      ChangeQty(
////                                          valueChanged: (int newValue){
////                                            setState(() {
////                                              totalQuantity = newValue;
////                                            });
////                                          },
////
////                                          cartQty: int.parse('${totalQuantity.toString()}')
////                                      ),
//                                      Expanded(
//                                        flex: 2,
//                                        child: Container(
//                                          // padding: EdgeInsets.all(5),
//                                            decoration: BoxDecoration(color: Styles.primaryColor),
//                                            child: Align(
//                                                alignment: Alignment.center,
//                                                child: FlatButton(
//                                                  child: Icon(Icons.add_shopping_cart, color: Colors.white),
//                                                  onPressed: () {
//                                                    if(snapshot.data.result.data[index].qty != 0){
//                                                      widget.onItemInteraction(snapshot.data.result.data[index].id,int.parse(snapshot.data.result.data[index].totalPrice),"1",snapshot.data.result.data[index].weight.toString());
//                                                    }else{
//
//                                                    }
//                                                  },
//                                                )
//                                            )
//                                        ),
//                                      ),
//                                    ],
//                                    ),
//                                  ),
//                                ],
//                              )
//                            ],
//                          ),
//                        )
//                      ],
//                    ),
//                  )
//              );
//            },
//            staggeredTileBuilder: (index) => new StaggeredTile.fit(2),
//          )
//      ),
//    );
//  }
//
//}
