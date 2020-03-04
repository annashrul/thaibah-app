//import 'package:flutter/material.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
//import 'package:thaibah/config/style.dart';
//
//class Test extends StatelessWidget {
//
//  @override
//  Widget build(BuildContext context) {
//    return new Scaffold(
//        appBar: new AppBar(
//          title: new Text('Example 01'),
//        ),
//        body: new Padding(
//            padding: const EdgeInsets.all(5.0),
//            child: new StaggeredGridView.countBuilder(
//              primary: false,
//              crossAxisCount: 4,
//              mainAxisSpacing: 2.0,
//              crossAxisSpacing: 2.0,
//              itemCount: 7,
//              itemBuilder: (context, index) => new _Tile(),
//              staggeredTileBuilder: (index) => new StaggeredTile.fit(2),
//            )));
//  }
//}
//
//class _Tile extends StatelessWidget {
//  // const _Tile(this.index, this.size);
//
//  // final IntSize size;
//  // final int index;
//
//  @override
//  Widget build(BuildContext context) {
//
//    double _height;
//    double _width;
//    _height = MediaQuery.of(context).size.height;
//    _width = MediaQuery.of(context).size.width;
//    return new Card(
//      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
//      child: new Column(
//        children: <Widget>[
//          new Stack(
//            children: <Widget>[
//              //new Center(child: new CircularProgressIndicator()),
//              new Center(
//                child: ClipRRect(
//                borderRadius: BorderRadius.only(
//                topLeft: Radius.circular(10.0),
//                topRight: Radius.circular( 10.0)
//          ),
//                child: Image.asset("assets/images/samsuns9+.jpg"),
//              ),
//              ),
//            ],
//          ),
//          new Padding(
//            padding: const EdgeInsets.all(4.0),
//            child: new Column(
//              children: <Widget>[
//                Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: <Widget>[
//                    Text("nama produk", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
//                    Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                      children: <Widget>[
//                      Text("Rp. xx.xxxx", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15, color: Styles.primaryColor)),
//                      Text("Kategori", style: TextStyle(fontWeight: FontWeight.normal, fontStyle: FontStyle.italic, fontSize: 15, color: Colors.black54))
//                    ],)
//                  ],
//                )
//              ],
//            ),
//          )
//        ],
//      ),
//    );
//  }
//}
