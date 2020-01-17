import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/PPOB/PPOBPraModel.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/ppob/pulsa_detail_ui.dart';
import 'package:thaibah/bloc/PPOB/PPOBPraBloc.dart';

class TabTokenPra extends StatefulWidget {
  TabTokenPra({this.nohp});
  final String nohp;
  @override
  _TabTokenPraState createState() => _TabTokenPraState();
}

class _TabTokenPraState extends State<TabTokenPra> {
  double _height;
  double _width;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ppobPraBloc.fetchPpobPra("TOKEN", widget.nohp);
  }

  @override
  Widget build(BuildContext context) {
//    ppobPraBloc.fetchPpobPra("TOKEN", widget.nohp);
//    pulsaBloc.fetchPulsa("TOKEN", widget.nohp);
    return StreamBuilder(
      stream: ppobPraBloc.getResult,
      builder: (context, AsyncSnapshot<PpobPraModel> snapshot) {
        if (snapshot.hasData) {
          return vwPulsa(snapshot, context);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Container(
            padding: EdgeInsets.all(20.0),
            child: Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF116240)))));
      },
    );
  }

  Widget vwPulsa(AsyncSnapshot<PpobPraModel> snapshot, BuildContext context){
    return Container(
      padding: EdgeInsets.all(15.0),
      child: GridView.builder(
        itemCount: snapshot.data.result.data.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: (){
              if(widget.nohp != ""){
                Navigator.of(context, rootNavigator: true).push(
                  new CupertinoPageRoute(builder: (context) =>
                      DetailPulsaUI(
                        param : "TOKEN",
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
                      )
                  ),
                );
              }else{
                print('eusian');
              }
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
                        "Rp. ${snapshot.data.result.data[index].price}",
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
//                    shape: BoxShape.circle,
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