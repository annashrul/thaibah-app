import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/newsModel.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/detail_berita_ui.dart';
import 'package:thaibah/bloc/newsBloc.dart';


class NewsHomePage extends StatefulWidget {
  @override
  _NewsHomePageState createState() => _NewsHomePageState();
}

class _NewsHomePageState extends State<NewsHomePage> {
  final _bloc = NewsBloc();
  @override
  void initState() {
    super.initState();
    _bloc.fetchNewsList(1, 4);
//    newsBloc.fetchNewsList(1,4);
  }

  @override
  void dispose() {
//    newsBloc.dispose();
    super.dispose();
    _bloc.dispose();
  }
  @override
  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(),
    );
  }
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _bloc.allNews,
      builder: (context, AsyncSnapshot<NewsModel> snapshot) {
        if (snapshot.hasData) {
          return buildContent(snapshot, context);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Container(
          height: MediaQuery.of(context).size.height/5,
          color: Colors.transparent,
          padding: EdgeInsets.all(16.0),
          child: Swiper(
            autoplay: true,
            fade: 0.0,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height/5,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
                          image: DecorationImage(
                              image: CachedNetworkImageProvider("http://lequytong.com/Content/Images/no-image-02.png"),
                              fit: BoxFit.fill
                          )
                      ),
                    ),
                  ],
                ),
              );
            },
            itemCount: 6,
            viewportFraction: 0.8,
            scale: 0.9,
//              pagination: SwiperPagination(),
          ),
        );
      },
    );
  }

  Widget buildContent(AsyncSnapshot<NewsModel> snapshot, BuildContext context){
    return Container(
      height: MediaQuery.of(context).size.height/5,
      color: Colors.transparent,
      padding: EdgeInsets.only(left:16.0,right:16.0),
      child: Swiper(
        physics: const NeverScrollableScrollPhysics(),
        autoplay: true,
        fade: 0.0,
        itemBuilder: (BuildContext context, int index) {
          var cap = ""; var tit = "";
          if(snapshot.data.result.data[index].title.length > 40){
            tit = snapshot.data.result.data[index].title.substring(0,40)+" ...";
          }else{
            tit = snapshot.data.result.data[index].title;
          }
          if(snapshot.data.result.data[index].caption.length > 40){
            cap = snapshot.data.result.data[index].caption.substring(0,40)+" ...";
          }else{
            cap = snapshot.data.result.data[index].caption;
          }

          return GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailBeritaUI(id: snapshot.data.result.data[index].id, category: snapshot.data.result.data[index].category)
                ),
              );
            },
            child: Column(
              children: <Widget>[
                Container(
                  height:  MediaQuery.of(context).size.height/5,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0),bottomLeft: Radius.circular(10.0), bottomRight: Radius.circular(10.0)),
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(snapshot.data.result.data[index].picture==''||snapshot.data.result.data[index].picture==null?IconImgs.noImage:snapshot.data.result.data[index].picture),
//                                image: CachedNetworkImageProvider(IconImgs.noImage),
                          fit: BoxFit.fill
                      )
                  ),
                ),

              ],
            ),
          );
        },
        itemCount: snapshot.data.result.data.length,
        viewportFraction: 1,
        scale: 1,
        itemWidth: double.infinity,
        itemHeight: MediaQuery.of(context).size.height/5,
        layout: SwiperLayout.TINDER,
//        control: new SwiperControl(color: Colors.black),
//              pagination: SwiperPagination(),
      ),
    );
  }
}
