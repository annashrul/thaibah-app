
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thaibah/Model/categoryModel.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'file:///E:/THAIBAH/mobile/thaibah-app/lib/UI/component/news/detailNewsPerCategory.dart';
import 'package:thaibah/bloc/categoryBloc.dart';

class CategoryHome extends StatefulWidget {
  @override
  _CategoryHomeState createState() => _CategoryHomeState();
}

class _CategoryHomeState extends State<CategoryHome> {
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
          return buildContent(snapshot, context);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return _loading();
      },
    );
  }
  Widget buildContent(AsyncSnapshot<CategoryModel> snapshot, BuildContext context){
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: width / 2,
      width:  width / 1,
      margin: EdgeInsets.only(bottom: 10, top: 13),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: snapshot.data.result.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: ()=>{
              Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => DetailNewsPerCategory(title: snapshot.data.result[index].title),
               ),
              )
            },
            child: _buildItem(snapshot.data.result[index].thumbnail,snapshot.data.result[index].title,snapshot.data.result[index].countcontent,width/3.0),
          );
        },
      ),
    );
  }

  _buildItem(String imagePath, String title, String counter, double itemHeight) {
    return Container(
      width:itemHeight+(itemHeight/10),
      child: Card(

        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 3.0,
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 20),
        child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
          return Stack(
            children: <Widget>[
              Container(
                height: constraints.biggest.height,
                width: constraints.biggest.width,
                child: CachedNetworkImage(
                  imageUrl: "$imagePath",
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
              ),
              Container(
                margin: EdgeInsets.only(top:10.0,bottom:20.0),
                alignment: Alignment.bottomLeft,
                width: constraints.biggest.width,
                height: constraints.biggest.height,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: <Widget>[
                      Text("$title",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold,fontFamily: 'Rubik',),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                width: constraints.biggest.width,
                height: constraints.biggest.height,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: <Widget>[
                      Text("Total Berita $counter",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white,fontSize: 12,fontFamily: 'Rubik',),
                      ),

                    ],
                  ),
                ),
              )
            ],
          );
        }),
      ),
    );
  }


  _loading(){
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: width / 2,
      width:  width / 1,
      margin: EdgeInsets.only(bottom: 10, top: 13),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            width:width/3.0,
            child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 3.0,
              margin: EdgeInsets.only(left: 10, right: 10, bottom: 20),
              child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                return Stack(
                  children: <Widget>[
                    Container(
                      height: constraints.biggest.height,
                      width: constraints.biggest.width,
                      child: CachedNetworkImage(
                        imageUrl: "http://lequytong.com/Content/Images/no-image-02.png",
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
                    ),
                    Container(
                      margin: EdgeInsets.only(top:10.0,bottom:20.0),
                      alignment: Alignment.bottomLeft,
                      width: constraints.biggest.width,
                      height: constraints.biggest.height,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          children: <Widget>[
                            SkeletonFrame(width: 80.0, height: 16.0),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      width: constraints.biggest.width,
                      height: constraints.biggest.height,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          children: <Widget>[
                            SkeletonFrame(width: 80.0, height: 16.0),

                          ],
                        ),
                      ),
                    )
                  ],
                );
              }),
            ),
          );
        },
      ),
    );
  }
}

