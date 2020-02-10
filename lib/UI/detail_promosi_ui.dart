import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_villains/villain.dart';
import 'package:thaibah/UI/Widgets/theme.dart' as prefix0;
import 'package:thaibah/config/api.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Homepage/index.dart';
import 'Widgets/pin_screen.dart';


class DetailPromosiUI extends StatefulWidget {
  DetailPromosiUI({this.id,this.penulis, this.title, this.picture, this.caption, this.createdAt,this.link});
  final String id;
  final String penulis;
  final String title;
  final String picture;
  final String caption;
  final String createdAt;
  final String link;
  @override
  _DetailPromosiUIState createState() => _DetailPromosiUIState();
}

class _DetailPromosiUIState extends State<DetailPromosiUI> {
  bool isExpanded = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
            color: Colors.white,
          ),
          onPressed: (){

            Navigator.of(context).pop();
          },
        ),
        centerTitle: false,
        elevation: 0.0,
        title: Text(widget.title,style: TextStyle(color: Colors.white,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
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
      body: Villain(
          villainAnimation: VillainAnimation.fromBottom(
            curve: Curves.fastOutSlowIn,
            relativeOffset: 0.05,
            from: Duration(milliseconds: 200),
            to: Duration(milliseconds: 400),
          ),
          secondaryVillainAnimation: VillainAnimation.fade(),
          animateExit: true,
          child:Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              ListView(
                children: <Widget>[
                  _buildBackdrop(context),
                  SizedBox(height: 24.0),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      '${(widget.createdAt)}',
                      style: Theme.of(context).textTheme.body1.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                          fontFamily: 'Rubik'
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),

                  title(context),

                  SizedBox(height: 8.0),

                  source(context),

                  SizedBox(height: 20.0),

                  preview(context),

                  SizedBox(height: 15.0),
                ],
              )
            ],
          )
      ),
      bottomNavigationBar: widget.link == '-' || widget.link == null ? Text(''):  InkWell(
        onTap: () async {
          String url = '${widget.link}';
          if (await canLaunch(url)) {
            await launch(url);
          }else{
            scaffoldKey.currentState.showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 5),
                  content: Text('Tidak Ada Link Terkait',style: TextStyle(color:Colors.white,fontFamily: 'Rubik',fontWeight: FontWeight.bold),),
                )
            );
          }
        },
        child: Container(
          width: ScreenUtil.getInstance().setWidth(710),
          height: ScreenUtil.getInstance().setHeight(100),
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF116240),Color(0xFF30CC23)]),
              borderRadius: BorderRadius.circular(0.0),
              boxShadow: [BoxShadow(color: Color(0xFF6078ea).withOpacity(.3),offset: Offset(0.0, 8.0),blurRadius: 8.0)]
          ),
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
//          crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("DOWNLOAD DISINI SEKARANG", style: TextStyle(fontFamily:'Rubik',fontSize: 14, color: Colors.white,fontWeight: FontWeight.bold),),
            ],
          ),
        ),
      ),
    );
  }


  _buildBackdrop(BuildContext context) {
    return Container(
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            var width = constraints.biggest.width;
            return Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ClipPath(
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: Colors.white, boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                offset: Offset(0.0, 10.0),
                                blurRadius: 10.0)
                          ]),
                          child: Container(
                            width: width,
                            height: width,
                            child: Image.network("${widget.picture}", fit: BoxFit.fill,),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[

                            Expanded(
                              child: Container(),
                            ),
                            // IconButton(icon: Icon(Icons.share,), onPressed: () {
                            //   // _share();
                            // },),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

              ],
            );
          }

      ),
    );
  }


  Widget title(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Text("${widget.title}",
          style: TextStyle(color: prefix0.Colors.black,fontFamily: 'Rubik',fontWeight: FontWeight.bold,fontSize: 20)
      ),
    );
  }

  Widget source(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("${widget.penulis}",
            style: Theme.of(context).textTheme.body1.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.black54,fontFamily: 'Rubik'
            ),
          ),

        ],
      ),
    );
  }

  Widget preview(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child:Html(data: widget.caption,linkStyle: TextStyle(color: Colors.black,fontFamily: 'Rubik'),) ,
//        child:  Text(
//          "${widget.caption}",
//          style: Theme.of(context).textTheme.body1.copyWith(
//            fontSize: 16.0,
//            height: 1.3,
//          ),
//        ),
    );
  }
  void _onBackPressed() {
    Navigator.of(context).pop();
  }
}

class Mclipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0.0, size.height - 40.0);

    var controlPoint = Offset(size.width / 4, size.height);
    var endpoint = Offset(size.width / 2, size.height);

    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, endpoint.dx, endpoint.dy);

    var controlPoint2 = Offset(size.width * 3 / 4, size.height);
    var endpoint2 = Offset(size.width, size.height - 40.0);

    path.quadraticBezierTo(
        controlPoint2.dx, controlPoint2.dy, endpoint2.dx, endpoint2.dy);

    path.lineTo(size.width, 0.0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
