import 'dart:async';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/categoryModel.dart';
import 'package:thaibah/Model/newsDetailModel.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/Widgets/theme.dart' as AppTheme;
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:thaibah/UI/component/news/categoryNewsDetail.dart';
import 'package:thaibah/UI/detailNewsPerCategory.dart';
import 'package:thaibah/bloc/categoryBloc.dart';
import 'package:thaibah/bloc/newsBloc.dart';
import 'package:thaibah/config/api.dart';

import 'Homepage/index.dart';
import 'Widgets/pin_screen.dart';

class DetailBeritaUI extends StatefulWidget {
  final String id;
  final String category;
  DetailBeritaUI({this.id,this.category,Key key})  : super(key: key);
  @override
  _DetailBeritaUIState createState() => _DetailBeritaUIState();
}

class _DetailBeritaUIState extends State<DetailBeritaUI> with WidgetsBindingObserver {
  List colors = [
    AppTheme.Colors.flatOrange,
    AppTheme.Colors.flatPurple,
    AppTheme.Colors.flatDeepPurple,
    AppTheme.Colors.flatRed,
    AppTheme.Colors.primaryColor,
  ];
  Random random = new Random();
  var localId;
  var localCategory;




  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    localId = widget.id;
    localCategory = widget.category;
    newsDetailBloc.fetchNewsDetail(localId);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              new SliverAppBar(
                floating: true,
                elevation: 0,
                snap: true,
                backgroundColor: AppTheme.Colors.white,
                brightness: Brightness.light,
                actions: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 40,
                          child: IconButton(
                            icon: Icon(Icons.arrow_back_ios),
                            color: AppTheme.Colors.black,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Expanded(
                          child: ToggleButton(),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ];
          },
          body: Container(
            color: AppTheme.Colors.white,
            child: ListView(
              children: <Widget>[
                StreamBuilder(
                  stream: newsDetailBloc.allDetailNews,
                  builder: (context,AsyncSnapshot<NewsDetailModel> snapshot){
                    return snapshot.hasData ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                          Container(
                              height: 200,
                              child: Stack(
                                children: <Widget>[
                                  CachedNetworkImage(
                                    imageUrl: snapshot.data.result.picture,
                                    placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                                    imageBuilder: (context, imageProvider) => Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                    ),
                                  ),

                                ],
                              )
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  snapshot.data.result.category,
                                  style: TextStyle(color:  Color(0xFFB1B1B1),fontFamily: 'Rubik',fontWeight: FontWeight.w500,fontSize: 16),
                                ),
                                Text(
                                  snapshot.data.result.createdAt,
                                  style: TextStyle(color:  Color(0xFFB1B1B1),fontFamily: 'Rubik',fontWeight: FontWeight.w500,fontSize: 16),
                                )
                              ],
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(bottom: 10.0),
                              child: Text(snapshot.data.result.title,style: TextStyle(fontFamily: 'Rubik',color: Colors.black,fontWeight: FontWeight.bold),)
                          ),
                          Container(
                              margin: EdgeInsets.only(bottom: 10.0),
                              child: Text(snapshot.data.result.penulis,style: TextStyle(fontFamily: 'Rubik',color: Color(0xFFB1B1B1),fontWeight: FontWeight.bold),)
                          ),
                          Padding(
                              padding: const EdgeInsets.only(right: 0),
                              child: Html(data:removeAllHtmlTags(snapshot.data.result.caption))
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30, bottom: 10),
                            child: RichText(
                              text: TextSpan(children: [
                                TextSpan(text: "Berita ",style: AppTheme.TextTheme.titleRegularBlack),
                                TextSpan(text: "Lainnya",style: AppTheme.TextTheme.titleRegularOrange),
                              ]),
                            ),
                          ),

                        ],
                      ),

                    ):
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              height: 200,
                              child: Stack(
                                children: <Widget>[
                                  CachedNetworkImage(
                                    imageUrl: "http://lequytong.com/Content/Images/no-image-02.png",
                                    placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                                    imageBuilder: (context, imageProvider) => Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),

                                ],
                              )
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                SkeletonFrame(width: 150,height: 16),
                                SkeletonFrame(width: 150,height: 16),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 10.0),
                            child: SkeletonFrame(width: MediaQuery.of(context).size.width/1,height: 16),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 10.0),
                            child: SkeletonFrame(width: 150,height: 16),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 0),
                            child: SkeletonFrame(width: MediaQuery.of(context).size.width/1,height: 300),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30, bottom: 10),
                            child: RichText(
                              text: TextSpan(children: [
                                TextSpan(text: "Berita ",style: AppTheme.TextTheme.titleRegularBlack),
                                TextSpan(text: "Lainnya",style: AppTheme.TextTheme.titleRegularOrange),
                              ]),
                            ),
                          ),

                        ],
                      ),

                    );
                  },
                ),
                CategoryNewsDetail(category:localCategory)
                //ieu
              ],
            ),
          ),
        )
    );
  }
}


class ToggleButton extends StatefulWidget {
  @override
  _ToggleButtonState createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  List colors = [
    AppTheme.Colors.flatOrange,
    AppTheme.Colors.flatPurple,
    AppTheme.Colors.flatDeepPurple,
    AppTheme.Colors.flatRed,
    AppTheme.Colors.primaryColor,
  ];
  Random random = new Random();

  final _bloc = CategoryBloc();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc.fetchCategoryList('berita');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _bloc.getResult,
      builder: (context, AsyncSnapshot<CategoryModel> snapshot) {
        if (snapshot.hasData) {
          return buildCategory(snapshot, context);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          itemBuilder: (context,index){
            return Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
                child: InkWell(

                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                        alignment: Alignment.center,
                        child: SkeletonFrame(width: 50,height: 16,)
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(color: colors[random.nextInt(4)].withOpacity(0.4),blurRadius: 8,offset: Offset(0.0, 3))
                        ]),
                  ),
                )
            );
          },
        );
      },
    );
  }

  Widget buildCategory(AsyncSnapshot<CategoryModel> snapshot, BuildContext context){
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: snapshot.data.result.length,
      itemBuilder: (context,index){
        return Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
          child: InkWell(
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DetailNewsPerCategory(title: snapshot.data.result[index].title)));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  snapshot.data.result[index].title,
                  style: AppTheme.TextTheme.regularTextWhite,
                ),
              ),
              decoration: BoxDecoration(
                color: colors[random.nextInt(4)],
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(color: colors[random.nextInt(4)].withOpacity(0.4),blurRadius: 8,offset: Offset(0.0, 3))
                ]),
            ),
          )
        );
      },
    );

  }
}