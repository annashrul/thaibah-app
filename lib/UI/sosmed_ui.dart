
import 'package:flutter/material.dart';

class SosmedUI extends StatefulWidget {
  @override
  _SosmedUIState createState() => _SosmedUIState();
}

class _SosmedUIState extends State<SosmedUI> {
  bool isExpanded = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  double _height;
  double _width;

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => index == 0
          ?
      new Card(
        child: new Container(
          padding: EdgeInsets.all(10),
          child: Column(children: <Widget>[
            Row(children: <Widget>[
              Container(
                height: 40.0,
                width: 40.0,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: new ExactAssetImage("assets/images/canon.jpg")),
                ),
              ),
              SizedBox(width: 10,),
              Expanded(
                child: new TextField(
                  decoration: new InputDecoration(
                    border: InputBorder.none,
                    hintText: "Apa yang anda pikirkan?",
                  ),
                ),
              ),
              Container(
                  height: 40.0,
                  width: 40.0,
                  child: Icon(Icons.photo_camera)
              ),
            ],),
            Divider(),
          ],),
        ),
        // height: deviceSize.height * 0.15,
      )
      //     new Scaffold(
      //       appBar: AppBar(
      //   title: Text("Sosial Media", style: TextStyle(color:Colors.white)),
      //   iconTheme: new IconThemeData(color: Colors.white),
      // ),
      //     )
          : Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 0.0, 8.0, 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    new Container(
                      height: 40.0,
                      width: 40.0,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: new ExactAssetImage("assets/images/canon.jpg")),
                      ),
                    ),
                    new SizedBox(
                      width: 10.0,
                    ),
                    new Text(
                      "Camera anyar",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                new IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: null,
                )
              ],
            ),
          ),
          Flexible(
            fit: FlexFit.loose,
            child: new Image.asset("assets/images/canon.jpg",
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Icon(
                      Icons.favorite,
                    ),
                    new SizedBox(
                      width: 16.0,
                    ),
                    new Icon(
                      Icons.chat_bubble,
                    ),
                    new SizedBox(
                      width: 16.0,
                    ),
                    new Icon(Icons.share),
                  ],
                ),
                new Icon(Icons.bookmark)
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: new ExactAssetImage("assets/images/samsuns9+.jpg")),
                  ),
                ),
                new SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: new TextField(
                    decoration: new InputDecoration(
                      border: InputBorder.none,
                      hintText: "Tambah Komentar",
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child:
            Text("1 hari yang lalu", style: TextStyle(color: Colors.grey)),
          )
        ],
      ),
    );
  }
}