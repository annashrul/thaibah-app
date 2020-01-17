import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:thaibah/Model/promosiModel.dart';
import 'package:thaibah/UI/detail_promosi_ui.dart';
import 'package:thaibah/bloc/promosiBloc.dart';
import 'package:flutter/material.dart';

class PromoCard extends StatefulWidget {

  @override
  State createState() => _PromoCardState();
}

class _PromoCardState extends State<PromoCard> {
  @override
  Widget build(BuildContext context) {
    promosiBloc.fetchPromosiList();
    return StreamBuilder(
      stream: promosiBloc.allPromosi,
      builder: (context, AsyncSnapshot<PromosiModel> snapshot) {
        if (snapshot.hasData) {
          return buildContent(snapshot, context);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Container(padding: EdgeInsets.all(20.0),child: Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23)))));
      },
    );
  }

  Widget buildContent(AsyncSnapshot<PromosiModel> snapshot, BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: width / 2,
      width:  width / 1,
      margin: EdgeInsets.only(bottom: 10, top: 13),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: snapshot.data.result.data.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: ()=>{
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPromosiUI(
                      id:snapshot.data.result.data[index].id,
                      title: snapshot.data.result.data[index].title,
                      picture: snapshot.data.result.data[index].thumbnail,
                      caption: snapshot.data.result.data[index].caption,
                      penulis: snapshot.data.result.data[index].penulis,
                      createdAt: snapshot.data.result.data[index].createdAt
                    ),
                  ),
                )
            },
            child:  _buildItem(snapshot.data.result.data[index].thumbnail,
                snapshot.data.result.data[index].title, snapshot.data.result.data[index].caption,
                width/3.0),
          );
        },
      ),
    );
  }

  _buildItem(String imagePath, String cate, String caption, double itemHeight) {
    return Container(
      width:itemHeight+(itemHeight/10),
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 3.0,
        margin: EdgeInsets.only(left: 10, right: 0, bottom: 20),
        child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: constraints.biggest.height,
                    width: constraints.biggest.width,
                    child: CachedNetworkImage(
                      imageUrl: "$imagePath",
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))),
                      ),
                      errorWidget: (context, url, error) => Center(
                        child: Image.network('https://www.nocowboys.co.nz/images/v3/no-image-available.png')
                      ),
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
                    margin: EdgeInsets.only(top:0.0,bottom:0.0),
                    alignment: Alignment.bottomLeft,
                    width: constraints.biggest.width,
                    height: constraints.biggest.height,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: <Widget>[
                          Text(cate,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.bold,fontFamily: 'Rubik',),
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              )
            ],
          );
        }),
      ),
    );
  }

}