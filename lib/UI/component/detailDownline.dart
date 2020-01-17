import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thaibah/Model/downlineModel.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/component/dataDiri/createMember.dart';
import 'package:thaibah/bloc/downlineBloc.dart';


class DetailDownline extends StatefulWidget {
//  DetailDownline(this.kdReff,this.downlineNmae, {Key key}) : super(key: key);
  DetailDownline({this.kdReff,this.downlineNmae,Key key}) : super(key: key);
  final String kdReff;
  final String downlineNmae;

//  UsefulKdreff kdreff;
//  DetailDownline device;
//  Use device;

  @override
  _DetailDownlineState createState() => _DetailDownlineState();
}

class _DetailDownlineState extends State<DetailDownline> with WidgetsBindingObserver  {
//  _DetailDownlineState(this.kdReff,this.downlineName);
  bool isExpanded = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  double _height;
  double _width;

  var localKdReff;
  var localDownlineReff;
  final formatter = new NumberFormat("#,###");

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    localKdReff = widget.kdReff;
    localDownlineReff = widget.downlineNmae;
    super.initState();
    detailDownlineBloc.fetchDetailDownlineList(localKdReff);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
          onPressed: () => Navigator.of(context).pop(),
        ),
//        centerTitle: true,
        elevation: 0.0,
        title: Text("Jaringan Member "+localDownlineReff,style: TextStyle(fontSize:14,color: Colors.white,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
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
      body: StreamBuilder(
          stream: detailDownlineBloc.allDetailDownline,
          builder: (context, AsyncSnapshot<DownlineModel> snapshot) {
            if(snapshot.hasData){
              return buildContent(snapshot, context);
            }else if(snapshot.hasError){
              return Text(snapshot.error.toString());
            }
            return _loading();
          }
      ),
    );
  }

  @override
  Widget buildContent(AsyncSnapshot<DownlineModel> snapshot, BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    if(snapshot.data.result.length > 0){
      return Container(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: snapshot.data.result.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              elevation: 0.0,
              margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Container(
                decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0)),
                child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    leading: Container(
                      padding: EdgeInsets.all(10),
                      child: CircleAvatar(
//                        radius: 35.0,
                        child: CachedNetworkImage(
                          imageUrl: snapshot.data.result[index].downlinePicture,
                          imageBuilder: (context, imageProvider) => Container(
                            width: 100.0,
                            height: 100.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                            ),
                          ),
                          placeholder: (context, url) => SkeletonFrame(width: 80.0,height: 80.0),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                      ),
                    ),

                    title: InkWell(
                      onTap: (){
                        Navigator.push(context,MaterialPageRoute(builder: (context) => DetailDownline(kdReff: snapshot.data.result[index].downlineReferralRaw,downlineNmae: snapshot.data.result[index].downlineName)));
                      },
                      child: RichText(
                        text: TextSpan(
                          text: '${snapshot.data.result[index].downlineName}',
                          style: TextStyle(fontSize:11.0,color: Colors.black, fontWeight: FontWeight.bold,fontFamily: 'Rubik'),
                          children: <TextSpan>[
                            TextSpan(text: ' ( ${snapshot.data.result[index].downlineReferral} )', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green,fontFamily: 'Rubik',fontSize: 11.0)),
                          ],
                        ),
                      ),

                    ),
                    // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                    subtitle: InkWell(
                      onTap: (){
                        Navigator.push(context,MaterialPageRoute(builder: (context) => DetailDownline(kdReff: snapshot.data.result[index].downlineReferralRaw,downlineNmae: snapshot.data.result[index].downlineName)));
                      },

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              RichText(
                                text: TextSpan(
                                  text: 'Jumlah Downline :',
                                  style: TextStyle(fontSize:11.0,color: Colors.grey, fontWeight: FontWeight.bold,fontFamily: 'Rubik'),
                                  children: <TextSpan>[
                                    TextSpan(text: ' ${snapshot.data.result[index].downline} Orang', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green,fontFamily: 'Rubik',fontSize: 11.0)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              RichText(
                                text: TextSpan(
                                  text: 'Jumlah Omset :',
                                  style: TextStyle(fontSize:11.0,color: Colors.grey, fontWeight: FontWeight.bold,fontFamily: 'Rubik'),
                                  children: <TextSpan>[
                                    TextSpan(text: ' Rp ${formatter.format(int.parse(snapshot.data.result[index].downlineOmset))}', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green,fontFamily: 'Rubik',fontSize: 11.0)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    trailing: InkWell(
                      onTap: (){
                        Navigator.push(context,MaterialPageRoute(builder: (context) => CreateMember(kdReff: snapshot.data.result[index].downlineReferral,)));
                      },
                      child: Icon(Icons.group_add, color: Colors.black, size: 30.0),
                    )
                ),
              ),
            );
          },
        ),
      );
    }else{
      return Container(
          child: Center(child:Text("Data Tidak Tersedia",style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 20,fontFamily: 'Rubik'),))
      );
    }

  }
  Widget _loading() {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: 7,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 0.0,
            margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: Container(
              decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0)),
              child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  leading: Container(
                    width: 80.0,
                    height: 130.0,
                    padding: EdgeInsets.all(10),
                    child: CircleAvatar(
                      minRadius: 150,
                      maxRadius: 150,
                      child: CachedNetworkImage(
                        imageUrl: "http://lequytong.com/Content/Images/no-image-02.png",
                        placeholder: (context, url) => Center(
                          child: SkeletonFrame(width: 80.0,height:130.0),
                        ),
                        errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            borderRadius: new BorderRadius.circular(0.0),
                            color: Colors.white,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  title: InkWell(
                      child:SkeletonFrame(width: MediaQuery.of(context).size.width/3,height: 16.0)
                  ),
                  // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                  subtitle: InkWell(

                    child: Row(
                      children: <Widget>[
                        SkeletonFrame(width: MediaQuery.of(context).size.width/3,height: 16.0)
                      ],
                    ),
                  ),
                  trailing: InkWell(
                    child: SkeletonFrame(width: MediaQuery.of(context).size.width/10,height: 30.0),
                  )
              ),
            ),
          );
        },
      ),
    );

  }
}
