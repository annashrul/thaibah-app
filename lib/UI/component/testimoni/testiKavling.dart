import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loadmore/loadmore.dart';
import 'package:thaibah/Model/tertimoniModel.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/component/detailInspirasi.dart';
import 'package:thaibah/bloc/testiBloc.dart';

class TestiKavling extends StatefulWidget {
  @override
  _TestiKavlingState createState() => _TestiKavlingState();
}

class _TestiKavlingState extends State<TestiKavling> {
  int currentPos;
  String stateText;

  int perpage = 10;

  void load() {
    print("load $perpage");
    setState(() {
      perpage = perpage += 10;
    });
    testiBloc.fetchTesti(1,1,perpage);
    print(perpage);
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    testiBloc.fetchTesti(1,1,perpage);
  }

  Future<bool> _loadMore() async {
    print("onLoadMore");
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    print("load $perpage");
    setState(() {
      perpage = perpage += 10;
    });
    testiBloc.fetchTesti(1,1,perpage);
    print(perpage);
    return true;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    currentPos = 0;
    stateText = "Video not started";
    super.initState();
    testiBloc.fetchTesti(1,1,perpage);
  }
  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        Expanded(
          child: StreamBuilder(
            stream: testiBloc.allTesti,
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
                child: LoadMore(
                  child: ListView.builder(
                    itemCount: snapshot.data.result.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        padding: EdgeInsets.all(0.0),
                        child: Card(
                          color:Colors.black.withOpacity(0.5),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
                          child: Column(
                            children: <Widget>[
                              InkWell(
                                child: Container(
                                    padding: EdgeInsets.all(0),
                                    margin: EdgeInsets.only(top:0.0,bottom:0.0),
                                    alignment: Alignment.bottomLeft,
                                    height: ScreenUtil.getInstance().setHeight(400),
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
                                        )
                                    )
                                ),
                                onTap: (){
                                  Navigator.of(context, rootNavigator: true).push(
                                    new CupertinoPageRoute(builder: (context) => DetailInspirasi(param:'Testimoni Produk',video: snapshot.data.result.data[index].video,caption: snapshot.data.result.data[index].caption,rating:snapshot.data.result.data[index].rating.toString(),type: 'testimoni')),
                                  );
                                },
                              ),
                              InkWell(
                                child: Container(
                                  width: MediaQuery.of(context).size.width/1,
                                  height: ScreenUtil.getInstance().setHeight(100),
                                  color:Color(0xFF116240),
                                  child: InkWell(
                                    onTap: () async {
                                      Navigator.of(context, rootNavigator: true).push(
                                        new CupertinoPageRoute(builder: (context) => DetailInspirasi(param:'Testimoni Produk',video: snapshot.data.result.data[index].video,caption: snapshot.data.result.data[index].caption,rating:snapshot.data.result.data[index].rating.toString(),type: 'testimoni',)),
                                      );
                                    },
                                    child: Center(
                                      child: Text("Putar Video",style: TextStyle(color: Colors.white,fontFamily: "Rubik",fontSize: 16,fontWeight: FontWeight.bold,letterSpacing: 1.0)),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
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
