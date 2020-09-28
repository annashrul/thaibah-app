import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/newsModel.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/bloc/newsBloc.dart';

import '../../detail_berita_ui.dart';

class WidgetTopSlider extends StatefulWidget {
  @override
  _WidgetTopSliderState createState() => _WidgetTopSliderState();
}

class _WidgetTopSliderState extends State<WidgetTopSlider> with AutomaticKeepAliveClientMixin {
  final _bloc = NewsBloc();
  SwiperController controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    controller = new SwiperController();
    _bloc.fetchNewsList(1, 6,'Pengumuman');
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder(
      stream: _bloc.allNews,
      builder: (context, AsyncSnapshot<NewsModel> snapshot) {
        if (snapshot.hasData) {
          return buildContent(snapshot, context);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return _loading(context);
      },
    );
  }

  Widget buildContent(AsyncSnapshot<NewsModel> snapshot, BuildContext context){
    return Container(
      height: MediaQuery.of(context).size.height/4,
      color: Colors.transparent,
      padding: EdgeInsets.only(left:15.0,right:15.0),
      child: Swiper(
        key: _scaffoldKey,
        controller: controller,
        autoplay: true,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: (){
              Navigator.of(context, rootNavigator: true).push(
                  new CupertinoPageRoute(
                      builder: (context) => DetailBeritaUI(
                          id: snapshot.data.result.data[index].id,
                          category: snapshot.data.result.data[index].category,
                          link:snapshot.data.result.data[index].link
                      )
                  )
              );
            },
            child: Column(
              children: <Widget>[
                Container(
                  height:  MediaQuery.of(context).size.height/4,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0),bottomLeft: Radius.circular(10.0), bottomRight: Radius.circular(10.0)),
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(snapshot.data.result.data[index].picture==''||snapshot.data.result.data[index].picture==null?IconImgs.noImage:snapshot.data.result.data[index].picture),
                          fit: BoxFit.fill
                      )
                  ),
                ),

              ],
            ),
          );
        },
        itemCount: snapshot.data.result.data.length,
//        scale:1,
        fade:0.8,
//        viewportFraction: 1,
        viewportFraction: 0.9,
        scale: 0.9,
//        scale: 1,
//        pagination: new SwiperPagination(
//            builder: new DotSwiperPaginationBuilder(
//                color: ThaibahColour.primary2, activeColor: ThaibahColour.primary1
//            )
//        ),
      ),
    );
  }

  Widget _loading(BuildContext context){
    return Container(
      height: MediaQuery.of(context).size.height/3.5,
      color: Colors.transparent,
      padding: EdgeInsets.only(left:15.0,right:15.0),
      child: Column(
        children: <Widget>[
          Container(
            child: SkeletonFrame(width: double.infinity,height: MediaQuery.of(context).size.height/3.5),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
