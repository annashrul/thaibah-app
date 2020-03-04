import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thaibah/Model/PPOB/PPOBPraModel.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/ppob/pulsa_detail_ui.dart';
import 'package:thaibah/bloc/PPOB/PPOBPraBloc.dart';

class TabData extends StatefulWidget {
  TabData({this.nohp});
  final String nohp;
  @override
  _TabDataState createState() => _TabDataState();
}

class _TabDataState extends State<TabData> {
  double _height;
  double _width;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ppobPraBloc.fetchPpobPra("DATA", widget.nohp);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ppobPraBloc.getResult,
      builder: (context, AsyncSnapshot<PpobPraModel> snapshot) {
        if (snapshot.hasData) {
          return vwPulsa(snapshot, context);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }

        return Container(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 6,
            itemBuilder: (BuildContext context, int index) {
              return SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          GridView.count(
                            padding: EdgeInsets.only(top:0, bottom: 10,),
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            crossAxisCount: 1,
                            physics: NeverScrollableScrollPhysics(),
                            childAspectRatio: 5,
                            shrinkWrap: true,
                            children: <Widget>[
                              RaisedButton(
                                  padding: EdgeInsets.all(1),
                                  color: Colors.transparent,
                                  child: Container(padding: EdgeInsets.only(left: 10),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        // mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          CircleImage(imgUrl : 'http://lequytong.com/Content/Images/no-image-02.png'),
                                          SizedBox(width: 10.0),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              SkeletonFrame(width: MediaQuery.of(context).size.width/2,height: 16),
                                              SizedBox(height: 10.0),
                                              SkeletonFrame(width: MediaQuery.of(context).size.width/2,height: 16)
                                            ],
                                          )

                                        ],
                                      ),
                                    )
                                    ,)
                              ),
                            ],
                          ),
                        ]
                    ),
                  )

              );
            },
          ),
        );
      },
    );
  }

  Widget vwPulsa(AsyncSnapshot<PpobPraModel> snapshot, BuildContext context){
    var width = MediaQuery.of(context).size.width;
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(width: 750, height: 1334, allowFontScaling: true);
    return Container(
      child: ListView.builder(
//        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: snapshot.data.result.data.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: EdgeInsets.all(10.0),
            child: RaisedButton(
                padding: EdgeInsets.all(1),
                color: Colors.white,
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).push(
                    new CupertinoPageRoute(builder: (context) => DetailPulsaUI(
                      param : "PULSA",
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
  }
}

class CircleImage extends StatelessWidget {
  CircleImage({this.imgUrl});
  final String imgUrl;
  @override
  Widget build(BuildContext context) {
    double _size = 50.0;
    return Center(
      child: Container(
          width: _size,
          height: _size,
          child: Stack(
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: imgUrl,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))),
                ),
                errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),

            ],
          )
      ),
    );
  }

}