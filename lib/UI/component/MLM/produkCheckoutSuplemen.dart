import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:thaibah/Model/MLM/getDetailChekoutSuplemenModel.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/bloc/MLM/detailChekoutSuplemenBloc.dart';

class ProdukCheckoutSuplemen extends StatefulWidget {
  @override
  _ProdukCheckoutSuplemenState createState() => _ProdukCheckoutSuplemenState();
}

class _ProdukCheckoutSuplemenState extends State<ProdukCheckoutSuplemen> {
  var totBar = '';
  final formatter = new NumberFormat("#,###");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    detailChekoutSuplemenBloc.fetchDetailChekoutSuplemenList();

  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: detailChekoutSuplemenBloc.getResult,
        builder: (context, AsyncSnapshot<GetDetailChekoutSuplemenModel> snapshot){
          if (snapshot.hasData) {
            totBar = snapshot.data.result.totalQty.toString();
            return buildProduk(snapshot,context);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return _loadingProduk(context);
        }
    );
  }

  Widget buildProduk(AsyncSnapshot<GetDetailChekoutSuplemenModel> snapshot, BuildContext context){
    var width = MediaQuery.of(context).size.width;
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    return Container(
      width:  width / 1,
      color: Colors.white,
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: snapshot.data.result.produk.length,
          shrinkWrap: true,
          itemBuilder: (context, i) {
            return new FlatButton(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      new Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: new Row(
                          children: <Widget>[
                            Container(
                                margin: const EdgeInsets.only(left:10.0,right:5.0),
                                width: 70.0,
                                height: 70.0,
                                child: Stack(
                                  children: <Widget>[
                                    CachedNetworkImage(
                                      imageUrl: snapshot.data.result.produk[i].picture,
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
                                  ],
                                )
                            )
                          ],
                        ),
                      ),
                      new Expanded(
                          child: new Container(
                            margin: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                            child: new Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(0.0),
                                  child: new Text('${snapshot.data.result.produk[i].title}',style: new TextStyle(fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold,color: Colors.black),),
                                ),
                                SizedBox(height: 5.0),
                                Text('${snapshot.data.result.produk[i].qty} Barang (${snapshot.data.result.produk[i].weight} Gram) x Rp ${formatter.format(int.parse(snapshot.data.result.produk[i].rawPrice))}',style: TextStyle(fontSize: 10,fontFamily: 'Rubik',color:Colors.grey,fontWeight: FontWeight.bold),),
                                SizedBox(height: 5.0),
                                Text('Rp ${formatter.format(int.parse(snapshot.data.result.produk[i].rawPrice)*int.parse(snapshot.data.result.produk[i].qty) )}',style: TextStyle(fontSize: 12,fontFamily: 'Rubik',color: Colors.redAccent,fontWeight: FontWeight.bold),)
                              ],
                              crossAxisAlignment: CrossAxisAlignment.start,
                            ),
                          )
                      ),
                    ],
                  ),
                  Container(
                    padding:EdgeInsets.only(top: 0.0, bottom: 0.0, left: 15.0, right: 15.0),
                    color: Colors.white,
                    child: Divider(),
                  ),
//                  SizedBox(height: 10.0,child: Container(color: Colors.transparent)),
                ],
              ),
              padding: const EdgeInsets.all(0.0),
              onPressed: () {

              },
//              color: Colors.white,
            );
          }),
    );
  }

  Widget _loadingProduk(BuildContext context){
    var width = MediaQuery.of(context).size.width;
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    return Container(
      width:  width / 1,
      color: Colors.white,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: 3,
        shrinkWrap: true,
        itemBuilder: (context, i) {
          return new FlatButton(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: new Row(
                        children: <Widget>[
                          Container(
                              margin: const EdgeInsets.only(left:10.0,right:5.0),
                              width: 70.0,
                              height: 70.0,
                              child: Stack(
                                children: <Widget>[
                                  CachedNetworkImage(
                                    imageUrl: 'http://design-ec.com/d/e_others_50/l_e_others_500.png',
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

                                ],
                              )
                          )
                        ],

                      ),
                    ),
                    new Expanded(
                        child: new Container(
                          margin: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                          child: new Column(
                            children: [
                              Container(
                                  padding: const EdgeInsets.all(0.0),
                                  child: SkeletonFrame(width: MediaQuery.of(context).size.width/2,height: 16.0)
                              ),
                              SizedBox(height: 5.0),
                              SkeletonFrame(width: MediaQuery.of(context).size.width/2,height: 16.0),
                              SizedBox(height: 5.0),
                              SkeletonFrame(width: MediaQuery.of(context).size.width/2,height: 16.0)
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                        )),
                  ],
                ),
                Container(
                  padding:EdgeInsets.only(top: 0.0, bottom: 0.0, left: 15.0, right: 15.0),
                  color: Colors.white,
                  child: Divider(),
                ),
//                  SizedBox(height: 10.0,child: Container(color: Colors.transparent)),
              ],
            ),
            padding: const EdgeInsets.all(0.0),
            onPressed: () {

            },
          );
        }),
    );
  }
}
