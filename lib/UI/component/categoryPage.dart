//import 'package:cached_network_image/cached_network_image.dart';
//import 'package:flutter/material.dart';
//import 'package:thaibah/Model/categoryModel.dart';
//import 'package:thaibah/UI/Homepage/index.dart';
//import 'package:thaibah/UI/detailNewsPerCategory.dart';
//import 'package:thaibah/bloc/categoryBloc.dart';
//
//class CategoryPage extends StatefulWidget {
//  @override
//  _CategoryPageState createState() => _CategoryPageState();
//}
//
//class _CategoryPageState extends State<CategoryPage> {
//
//  void rebuildAllChildren(BuildContext context) {
//    void rebuild(Element el) {
//      el.markNeedsBuild();
//      el.visitChildren(rebuild);
//    }
//    (context as Element).visitChildren(rebuild);
//  }
//  @override
//  Widget build(BuildContext context) {
//    rebuildAllChildren(context);
//    categoryBloc.fetchCategoryList();
//    return Scaffold(
//      appBar: AppBar(
//        leading: IconButton(
//          icon: Icon(
//            Icons.keyboard_backspace,
//            color: Colors.black,
//          ),
//          onPressed: () {
//            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardThreePage()));
//          },
//        ),
//        centerTitle: true,
//        backgroundColor: Colors.white,
//        elevation: 0.0,
//        title: Text('Kategori Berita', style: TextStyle(color:Colors.black)),
//
//      ),
//      body: RefreshIndicator(
//        child: StreamBuilder(
//          stream: categoryBloc.allCategory,
//          builder: (context, AsyncSnapshot<CategoryModel> snapshot) {
//            if (snapshot.hasData) {
//              return buildContent(snapshot, context);
//            } else if (snapshot.hasError) {
//              return Text(snapshot.error.toString());
//            }
//            return Container(
//                padding: EdgeInsets.all(20.0),
//                child: Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23)))));
//          },
//        ),
//        onRefresh: () async{
//          return  categoryBloc.allCategory;
//        }
//      ),
//    );
//  }
//  Widget buildContent(AsyncSnapshot<CategoryModel> snapshot, BuildContext context) {
//    var width = MediaQuery.of(context).size.width;
//    return NotificationListener(
//      child: new GridView.builder(
//        padding: EdgeInsets.only(
//          top: 5.0,
//        ),   // EdgeInsets.only
//        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//          crossAxisCount: 2,
//          childAspectRatio: 0.85,
//        ),  // SliverGridDelegateWithFixedCrossAxisCount
//        itemCount: snapshot.data.result.length,
//        physics: const AlwaysScrollableScrollPhysics(),
//        itemBuilder: (_, index) {
//          return InkWell(
//            onTap: ()=>{
//              Navigator.push(
//                context,
//                MaterialPageRoute(
//                  builder: (context) => DetailNewsPerCategory(title: snapshot.data.result[index].title),
//                ),
//              )
//            },
//            child: _buildItem(snapshot.data.result[index].thumbnail,snapshot.data.result[index].title,snapshot.data.result[index].countcontent,width/3.0),
//          );
//        },
//      ),  // GridView.builder
//    );
//  }
//
//  Widget _buildItem(String imagePath, String title, String counter, double itemHeight) {
//    return Container(
//      width:itemHeight+(itemHeight/10),
//      child: Card(
//        clipBehavior: Clip.antiAliasWithSaveLayer,
//        elevation: 3.0,
//        margin: EdgeInsets.only(left: 10, right: 10, bottom: 20),
//        child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
//          return Stack(
//            children: <Widget>[
//
//              Container(
//                height: constraints.biggest.height,
//                width: constraints.biggest.width,
//                child: CachedNetworkImage(
//                  imageUrl: "$imagePath",
//                  placeholder: (context, url) => Center(
//                    child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))),
//                  ),
//                  errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
//                  imageBuilder: (context, imageProvider) => Container(
//                    decoration: BoxDecoration(
//                      borderRadius: BorderRadius.circular(0),
//                      image: DecorationImage(
//                        image: imageProvider,
//                        fit: BoxFit.fill,
//                      ),
//                    ),
//                  ),
//                ),
//              ),
//              Container(
//                margin: EdgeInsets.only(top:10.0,bottom:20.0),
//                alignment: Alignment.bottomLeft,
//                width: constraints.biggest.width,
//                height: constraints.biggest.height,
//                child: Padding(
//                  padding: const EdgeInsets.all(15.0),
//                  child: Row(
//                    children: <Widget>[
//                      Text("$title",
//                        overflow: TextOverflow.ellipsis,
//                        style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold,fontFamily: 'Rubik',),
//                      ),
//                    ],
//                  ),
//                ),
//              ),
//              Container(
//                alignment: Alignment.bottomLeft,
//                width: constraints.biggest.width,
//                height: constraints.biggest.height,
//                child: Padding(
//                  padding: const EdgeInsets.all(15.0),
//                  child: Row(
//                    children: <Widget>[
//                      Text("Total Berita $counter",
//                        overflow: TextOverflow.ellipsis,
//                        style: TextStyle(color: Colors.white,fontSize: 12,fontFamily: 'Rubik',),
//                      ),
//
//                    ],
//                  ),
//                ),
//              )
//            ],
//          );
//        }),
//      ),
//    );
//  }
//}
