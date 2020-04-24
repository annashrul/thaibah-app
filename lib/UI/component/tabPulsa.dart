import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thaibah/Model/PPOB/PPOBPraModel.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/ppob/pulsa_detail_ui.dart';
import 'package:thaibah/bloc/PPOB/PPOBPraBloc.dart';

class TabPulsa extends StatefulWidget {
  TabPulsa({this.nohp});
  final String nohp;
  @override
  _TabPulsaState createState() => _TabPulsaState();
}

class _TabPulsaState extends State<TabPulsa> {
  double _height;
  double _width;
  final formatter = new NumberFormat("#,###");
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ppobPraBloc.fetchPpobPra("PULSA", widget.nohp);
  }

  @override
  Widget build(BuildContext context) {
//    pulsaBloc.fetchPulsa("PULSA", widget.nohp);
    return StreamBuilder(
      stream: ppobPraBloc.getResult,
      builder: (context, AsyncSnapshot<PpobPraModel> snapshot) {
        print(snapshot.hasData);
        print(snapshot.hasError);
        print(snapshot.hashCode);
        if (snapshot.hasData) {
          return vwPulsa(snapshot, context);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }

        return GridView.builder(
          itemCount: 9,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              child: Container(
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.all(1.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 0.5)
                ),
                child: Center(
                  child: GridTile(
                      header: SkeletonFrame(width: MediaQuery.of(context).size.width/1,height: 16),
                      footer: SkeletonFrame(width: MediaQuery.of(context).size.width/1,height: 16),
                      child: Container(
                        padding: EdgeInsets.all(20.0),
                        child: Center(
                          child: CircleImage(imgUrl: 'http://lequytong.com/Content/Images/no-image-02.png'),
                        ),
                      )
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
  Widget vwPulsa(AsyncSnapshot<PpobPraModel> snapshot, BuildContext context){
    return Scrollbar(
      child: GridView.builder(
        itemCount: snapshot.data.result.data.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
//      physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: ()=>{
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
              )
            },
            child: Container(
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.all(1.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  border: Border.all(color: Colors.grey, width: 0.5)
              ),
              child: Center(
                child: GridTile(
                    header: Text(snapshot.data.result.data[index].prov,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontFamily: "Rubik",fontWeight: FontWeight.bold),
                    ),
                    footer: Text(
                        "Rp. ${snapshot.data.result.data[index].nominal}",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontFamily: "Rubik",fontWeight: FontWeight.bold)
                    ),
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      child: Center(
                        child: CircleAvatar(
                          radius: 35.0,
                          child: CachedNetworkImage(
                            imageUrl: snapshot.data.result.data[index].imgProv,
                            imageBuilder: (context, imageProvider) => Container(
                              width: 100.0,
                              height: 100.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                              ),
                            ),
                            placeholder: (context, url) => SkeletonFrame(width: 80.0,height: 80.0),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          ),
                        ),
                      ),
                    )
                ),
              ),
            ),
          );
        },
      )
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