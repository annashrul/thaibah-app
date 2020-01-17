import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thaibah/Model/categoryModel.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/detailNewsPerCategory.dart';
import 'package:thaibah/bloc/categoryBloc.dart';
import 'package:thaibah/UI/Widgets/theme.dart' as AppTheme;

class NewsCategoryHomePage extends StatefulWidget {
  @override
  _NewsCategoryHomePageState createState() => _NewsCategoryHomePageState();
}

class _NewsCategoryHomePageState extends State<NewsCategoryHomePage> {
  List colors = [
    AppTheme.Colors.flatOrange,
    AppTheme.Colors.flatPurple,
    AppTheme.Colors.flatDeepPurple,
    AppTheme.Colors.flatRed,
    AppTheme.Colors.primaryColor,
  ];
  Random random = new Random();

  @override
  void initState() {
    super.initState();
    categoryBloc.fetchCategoryList();
  }

  @override
  void dispose() {
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: categoryBloc.allCategory,
      builder: (context, AsyncSnapshot<CategoryModel> snapshot) {
        if (snapshot.hasData) {
          return buildContent(snapshot, context);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Padding(
          padding: const EdgeInsets.only(left:0.0,right:0.0,top:0.0,bottom: 0.0),
          child: Container(
            padding: EdgeInsets.only(top:10.0,bottom:10.0,left:20.0,right:20.0),
            height: 80,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context,index){
                  return Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
                      child: InkWell(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Align(
                            alignment: Alignment.center,
                            child: Row(
                              children: <Widget>[
                                SkeletonFrame(width: 60,height: 16),
                                SizedBox(width: 5.0),
                              ],
                            ),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [BoxShadow(color: colors[random.nextInt(4)].withOpacity(0.4),blurRadius: 8,offset: Offset(0.0, 3))]
                          ),
                        ),
                      )
                  );
                }
            ),
          ),
        );
      },
    );
  }

  Widget buildContent(AsyncSnapshot<CategoryModel> snapshot, BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left:0.0,right:0.0,top:0.0,bottom: 0.0),
      child: Container(
        padding: EdgeInsets.only(top:10.0,bottom:10.0,left:20.0,right:20.0),
        height: 80,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data.result.length,
            itemBuilder: (context,index){
              return Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DetailNewsPerCategory(title: snapshot.data.result[index].title)));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Align(
                        alignment: Alignment.center,
                        child: Row(
                          children: <Widget>[
                            Text(snapshot.data.result[index].title,style:TextStyle(color:Colors.white)),
//                            SizedBox(width: 5.0),
//                            Container(
////                              child: Image.asset("assets/images/ic_wallet_100.png", width: 20, height: 20, color: Colors.white,),
//                              child: Image.network(snapshot.data.result[index].thumbnail, width: 20, height: 20, color: Colors.white,),
//                            ),
                          ],

                        ),
                      ),
//                      decoration: BoxDecoration(
//                          color: colors[random.nextInt(4)],
//                          borderRadius: BorderRadius.circular(8),
//                          boxShadow: [BoxShadow(color: colors[random.nextInt(4)].withOpacity(0.4),blurRadius: 8,offset: Offset(0.0, 3))]
//                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: <Color>[Color(0xFF116240),Color(0xFF30cc23)],
                        ),
                      ),
                    ),
                  )
              );
            }
        ),
      ),
    );
  }

}
