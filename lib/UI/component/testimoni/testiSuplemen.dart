import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:thaibah/Model/tertimoniModel.dart';
import 'package:thaibah/UI/Widgets/loadMoreQ.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/component/detailInspirasi.dart';
import 'package:thaibah/bloc/testiBloc.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';
import 'dart:async';

class TestiSuplemen extends StatefulWidget {
  @override
  _TestiSuplemenState createState() => _TestiSuplemenState();
}

class _TestiSuplemenState extends State<TestiSuplemen> {


  int perpage = 10;

  void load() {
    print("load $perpage");
    setState(() {
      perpage = perpage += 10;
    });
    testiBloc.fetchTesti(0,1,perpage);
    print(perpage);
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    testiBloc.fetchTesti(0,1,perpage);
  }

  Future<bool> _loadMore() async {
    print("onLoadMore");
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    print("load $perpage");
    setState(() {
      perpage = perpage += 10;
    });
    testiBloc.fetchTesti(0,1,perpage);
    print(perpage);
    return true;
  }
  @override
  void initState() {
    super.initState();
    testiBloc.fetchTesti(0,1,perpage);
  }

  @override
  void dispose() {
    super.dispose();
//    _bloc.dispose();
  }


  bool isLoadingShare = false;
  int cek = 0;
  Future share(param,index) async{
    setState(() {
      isLoadingShare = true;
      cek = index;

    });

    Timer(Duration(seconds: 1), () async {
      setState(() {
        isLoadingShare = false;
      });
      await WcFlutterShare.share(
          sharePopupTitle: 'Thaibah Share Testimoni Produk',
          subject: 'Thaibah Share Testimoni Produk',
          text: "$param",
          mimeType: 'text/plain'
      );
    });
  }


  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        Expanded(
          child: StreamBuilder(
            stream: testiBloc.getResult,
            builder: (context, AsyncSnapshot<TestimoniModel> snapshot) {
              if (snapshot.hasData) {
                return buildContent(snapshot, context);
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return _loading(context);
            },
          ),
        )
      ],
    );
  }



  Widget buildContent(AsyncSnapshot<TestimoniModel> snapshot, BuildContext context){
    if(snapshot.data.result.data.length > 0){
      return Column(
        children: <Widget>[
          Expanded(
            child: RefreshIndicator(
              child: LoadMoreQ(
                child: ListView.builder(
                  itemCount: snapshot.data.result.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: ()=>{

                      },
                      child: Container(
                          decoration: new BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                          ),
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              new Stack(
                                children: <Widget>[
                                  Container(
                                    height: ScreenUtil.getInstance().setHeight(450),
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data.result.data[index].thumbnail,
                                      placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))),
                                      ),
                                      errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                                      imageBuilder: (context, imageProvider) => Container(
                                        decoration: BoxDecoration(
                                          borderRadius: new BorderRadius.circular(0.0),
                                          color: Colors.grey,
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    color:Colors.black.withOpacity(0.5),
                                    height:ScreenUtil.getInstance().setHeight(450),
                                    margin: EdgeInsets.only(top:0.0,bottom:0.0),
                                    alignment: Alignment.bottomLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(top:100.0,bottom:0.0),
                                        alignment: Alignment.bottomLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Center(
                                            child: SizedBox.fromSize(
                                              size: Size(56, 56), // button width and height
                                              child: ClipOval(
                                                child: Container(
                                                  decoration: new BoxDecoration(
                                                    color: Colors.white.withOpacity(0.5),
                                                  ), // button color
                                                  child: InkWell(
                                                    splashColor: Colors.green, // splash color
                                                    onTap: () {
                                                      Navigator.of(context, rootNavigator: true).push(
                                                        new CupertinoPageRoute(builder: (context) => DetailInspirasi(param:'Testimoni Produk',video: snapshot.data.result.data[index].video,caption: snapshot.data.result.data[index].caption,rating:snapshot.data.result.data[index].rating.toString())),
                                                      );
                                                    }, // button pressed
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: <Widget>[
                                                        Icon(Icons.play_arrow), // icon
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top:100.0,bottom:0.0),
                                        alignment: Alignment.bottomLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Center(
                                            child: SizedBox.fromSize(
                                              size: Size(56, 56), // button width and height
                                              child: ClipOval(
                                                child: Container(
                                                  decoration: new BoxDecoration(
                                                    color: Colors.white.withOpacity(0.5),
                                                  ), // button color
                                                  child: InkWell(
                                                    splashColor: Colors.green, // splash color
                                                    onTap: () {
                                                      setState(() {
                                                        isLoadingShare = true;
                                                      });
                                                      print(cek);
                                                      share(snapshot.data.result.data[index].video,index);
                                                    }, // button pressed
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: <Widget>[
                                                        index == cek ? isLoadingShare?CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))):Icon(Icons.share) : Icon(Icons.share), // icon
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )

                                ],
                              ),
                            ],
                          )
                      ),
                    );
                  },
                ),
                onLoadMore: _loadMore,
                whenEmptyLoad: true,
                delegate: DefaultLoadMoreDelegate(),
                textBuilder: DefaultLoadMoreTextBuilder.english,
                isFinish: snapshot.data.result.data.length < perpage,
              ),
              onRefresh: _refresh
            ),
          ),
        ],
      );
    }else{
      return Container(
        child: Center(
          child: Text("Data Tidak Tersedia",style: TextStyle(color: Colors.black,fontFamily: 'Rubik',fontWeight: FontWeight.bold),),
        ),
      );
    }

  }

  Widget _loading(BuildContext context){
    return Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.only(right: 0.0),
                  child: Column(
                    children: <Widget>[
                      SkeletonFrame(width: MediaQuery.of(context).size.width/1,height: MediaQuery.of(context).size.height/3),
                      SizedBox(height: 16.0)
                    ],
                  ),
                );
              },
            ),
          ),

        ],
      );
  }

}
