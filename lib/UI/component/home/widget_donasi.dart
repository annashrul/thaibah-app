import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/donasi/listDonasiModel.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/bloc/donasi/donasiBloc.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';

class WidgetDonasi extends StatefulWidget {
  @override
  _WidgetDonasiState createState() => _WidgetDonasiState();
}

class _WidgetDonasiState extends State<WidgetDonasi> {
  Future<void> loadData() async {
    listDonasiBloc.fetchListDonasi('&perpage=5');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: listDonasiBloc.getResult,
        builder: (context, AsyncSnapshot<ListDonasiModel> snapshot) {
          if(snapshot.hasData){
            return buildContent(context,snapshot);
          }else if(snapshot.hasError){
            return Text(snapshot.error.toString());
          }
          return _loading();
        }
    );
  }

  Widget buildContent(BuildContext context, AsyncSnapshot<ListDonasiModel> snapshot){
    return Padding(
      padding: EdgeInsets.only(left:5.0,right:5.0),
      child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: snapshot.data.result.data.length,
          itemBuilder: (context,index){
            return InkWell(
              onTap: () async{},
              child: Column(
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(left:10.0,right:5.0),
                        width:170.0,
                        height:120.0,
                        child:CachedNetworkImage(
                          imageUrl: snapshot.data.result.data[index].gambar,
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(strokeWidth:10,valueColor: new AlwaysStoppedAnimation<Color>(ThaibahColour.primary1)),
                          ),
                          errorWidget: (context, url, error) => Container(
                            decoration: BoxDecoration(
                              borderRadius:  BorderRadius.circular(10.0),
                              image: DecorationImage(
                                  image: NetworkImage(ApiService().noImage),
                                  fit: BoxFit.cover
                              ),
                            ),
                          ),
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              borderRadius:  BorderRadius.circular(10.0),
                              color: Colors.grey,
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      new Expanded(
                          child: new Container(
                            margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                            child: new Column(
                              children: [
                                UserRepository().textQ(snapshot.data.result.data[index].title, 12, Colors.black, FontWeight.bold, TextAlign.left),
                                SizedBox(height: 10.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    UserRepository().textQ(snapshot.data.result.data[index].penggalang, 10, Colors.grey, FontWeight.bold, TextAlign.left),
                                    SizedBox(width: 2.0),
                                    Container(
                                        padding:const EdgeInsets.all(0.0),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(colors: [Colors.green,Colors.green]),
                                          borderRadius: BorderRadius.circular(100.0),
                                        ),
                                        child: Icon(Icons.check,color: Colors.white,size: 10.0)
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.0),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    height: 5,
                                    child: LinearProgressIndicator(
                                      value: snapshot.data.result.data[index].persentase, // percent filled
                                      valueColor: AlwaysStoppedAnimation<Color>(ThaibahColour.primary2),
                                      backgroundColor: Colors.grey,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                UserRepository().textQ('Rp 323.000', 12, Colors.black, FontWeight.bold, TextAlign.left),
                                UserRepository().textQ('Sampai 31 Desember 2020', 10, Colors.grey, FontWeight.bold, TextAlign.left),
                              ],
                              crossAxisAlignment: CrossAxisAlignment.start,
                            ),
                          )),
                    ],
                  ),
                  Container(
                    padding:EdgeInsets.only(left:10.0,right:10.0),
                    child: Divider(),
                  )
                ],
              ),
            );
          }
      ),
    );
  }


  Widget _loading(){
    return Padding(
      padding: EdgeInsets.only(left:5.0,right:5.0),
      child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: 5,
          itemBuilder: (context,index){
            return InkWell(
              onTap: () async{},
              child: Column(
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(left:10.0,right:5.0),
                        width:170.0,
                        height:120.0,
                        child:SkeletonFrame(width: 170,height: 120),
                      ),
                      new Expanded(
                          child: new Container(
                            margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                            child: new Column(
                              children: [
                                SkeletonFrame(width: MediaQuery.of(context).size.width/2,height: 15),
                                SizedBox(height: 10.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SkeletonFrame(width: 100,height: 15),
                                  ],
                                ),
                                SizedBox(height: 10.0),
                                SkeletonFrame(width: 100,height: 15),
                                SizedBox(height: 5.0),
                                SkeletonFrame(width: 100,height: 15),
                              ],
                              crossAxisAlignment: CrossAxisAlignment.start,
                            ),
                          )),
                    ],
                  ),
                  Container(
                    padding:EdgeInsets.only(left:10.0,right:10.0),
                    child: Divider(),
                  )
                ],
              ),
            );
          }
      ),
    );
  }
}
