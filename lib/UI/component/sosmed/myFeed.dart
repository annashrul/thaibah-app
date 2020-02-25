import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thaibah/Model/generalInsertId.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/Model/sosmed/listSosmedModel.dart';
import 'package:thaibah/UI/Widgets/loadMoreQ.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/component/sosmed/detailSosmed.dart';
import 'package:thaibah/UI/component/sosmed/inboxSosmed.dart';
import 'package:thaibah/bloc/sosmed/sosmedBloc.dart';
import 'package:thaibah/resources/sosmed/sosmed.dart';

class MyFeed extends StatefulWidget {
  final String id;
  MyFeed({this.id});
  @override
  _MyFeedState createState() => _MyFeedState();
}

class _MyFeedState extends State<MyFeed> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refresh = GlobalKey<RefreshIndicatorState>();
  final _bloc = SosmedBloc();
  int perpage = 10;
  bool isLoading = false;
  Future<File> file;
  String base64Image;
  File tmpFile;
  String fileName;



  Future sendFeed(caption,img) async{
    if(img != null){
      fileName = img.path.split("/").last;
      var type = fileName.split('.');
      base64Image = 'data:image/' + type[1] + ';base64,' + base64Encode(img.readAsBytesSync());
    }
    else{
      base64Image = "";
    }
    var res = await SosmedProvider().sendFeed(caption, base64Image);
    if(res is GeneralInsertId){

      GeneralInsertId results = res;
      if(results.status == 'success'){
        _bloc.fetchListSosmed(1, perpage);
        setState(() {
          isLoading = false;
        });

        return showInSnackBar(results.msg,'sukses');
      }else{
        setState(() {isLoading = false;});
        print(results.msg);

        return showInSnackBar(results.msg,'gagal');
      }
    }
    else{
      General results = res;
      print(results.msg);
      setState(() {isLoading = false;});

      return showInSnackBar(results.msg,'gagal');
    }
  }
  Future deleteFeed(var id) async{
    var res = await SosmedProvider().deleteFeed(id);
    if(res is General){
      General results = res;
      if(results.status == 'success'){
        setState(() {
          isLoading = false;
        });
        _bloc.fetchListSosmed(1, perpage);
        return showInSnackBar(results.msg,'sukses');
      }else{
        setState(() {isLoading = false;});
        return showInSnackBar(results.msg,'gagal');
      }
    }
    else{
      General results = res;
      print(results.msg);
      setState(() {isLoading = false;});
      return showInSnackBar(results.msg,'gagal');

    }
  }
  void load() {
    perpage = perpage += 10;
    print("PERPAGE ${perpage}");
    setState(() {});
    _bloc.fetchListSosmed(1,perpage);

  }
  Future<void> refresh() async {
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    load();
  }
  Future<bool> _loadMore() async {
    print("onLoadMore");
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    load();
    return true;
  }

  void showInSnackBar(String value, String param) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            fontFamily: "Rubik"),
      ),
      backgroundColor: param == 'sukses' ? Colors.green:Colors.redAccent,
      duration: Duration(seconds: 3),
    ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc.fetchListSosmed(1, perpage);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text('Riwayat Postingan ', style: TextStyle(fontFamily:'Rubik',color:Colors.white,fontWeight: FontWeight.bold)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[
                Color(0xFF116240),
                Color(0xFF30cc23)
              ],
            ),
          ),
        ),
        actions: <Widget>[
          new Stack(
            children: <Widget>[
              new IconButton(
                icon: Icon(Icons.notifications_none),
                onPressed: () {
                  print('tap');
                  Navigator.of(context, rootNavigator: true).push(
                    new CupertinoPageRoute(builder: (context) => InboxSosmed()),
                  );
                }
              ),
              new Positioned(
                right: 11,
                top: 11,
                child: new Container(
                  padding: EdgeInsets.all(2),
                  decoration: new BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(minWidth: 14, minHeight: 14,),
                  child: Text('1', style: TextStyle(color: Colors.white, fontSize: 8,), textAlign: TextAlign.center),
                ),
              )
            ],
          ),
        ],
      ),
      body: StreamBuilder(
          stream: _bloc.getResult,
          builder: (context, AsyncSnapshot<ListSosmedModel> snapshot){
            if (snapshot.hasData) {
              return Column(
                children: <Widget>[
                  Expanded(child: buildContent(snapshot, context))
                ],
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return _loading();
          }
      ),
      floatingActionButton: new FloatingActionButton(
          elevation: 0.0,
          child: new Icon(FontAwesomeIcons.penAlt),
          backgroundColor: new Color(0xFF30cc23),
          onPressed: (){_lainnyaModalBottomSheet(context);}
      )

    );
  }

  Widget buildContent(AsyncSnapshot<ListSosmedModel> snapshot, BuildContext context){
    return snapshot.data.result.data.length > 0 ? isLoading ?_loading():Container(
      child:  RefreshIndicator(
        key: _refresh,
        onRefresh:refresh,
        child: LoadMoreQ(
          child: ListView.builder(
              primary: true,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data.result.data.length,
              itemBuilder: (context,index){
                return Dismissible(
                    key: Key(index.toString()),
                    child: InkWell(
                      onTap: (){
                        Navigator.of(context, rootNavigator: true).push(
                          new CupertinoPageRoute(builder: (context) => DetailSosmed(
                            id: snapshot.data.result.data[index].id,
                          )),
                        ).whenComplete(_bloc.fetchListSosmed(1, perpage));
                      },
                      child: Container(
                        padding: EdgeInsets.only(bottom: 10.0,left:15.0,right:15.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  child: Flexible(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[

                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            child: Html(
                                              data:snapshot.data.result.data[index].caption, defaultTextStyle:TextStyle(fontSize:10.0,color:Colors.black,fontFamily:'Rubik',fontWeight:FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 0.0),
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(top: 3.0),
                                        height: 80.0,
                                        width: 100.0,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12.0),
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: snapshot.data.result.data[index].picture,
                                          placeholder: (context, url) => Center(
                                            child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))),
                                          ),
                                          errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                                          imageBuilder: (context, imageProvider) => Container(
                                            decoration: BoxDecoration(
                                              borderRadius: new BorderRadius.circular(10.0),
                                              color: Colors.grey,
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                ),

                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                      child: Row(
                                        children: <Widget>[
                                          Icon(FontAwesomeIcons.penAlt,color: Colors.grey,size: 12.0),
                                          SizedBox(width: 5.0),
                                          Text(snapshot.data.result.data[index].penulis,style:TextStyle(fontSize:10.0,color:Colors.grey,fontFamily:'Rubik',fontWeight:FontWeight.bold)),
                                        ],
                                      )
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                      child: Row(
                                        children: <Widget>[
                                          Icon(FontAwesomeIcons.comment,color: Colors.grey,size: 12.0),
                                          SizedBox(width: 5.0),
                                          Text(snapshot.data.result.data[index].comments+" komentar",style:TextStyle(fontSize:10.0,color:Colors.grey,fontFamily:'Rubik',fontWeight:FontWeight.bold)),
                                        ],
                                      )
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                      child: Row(
                                        children: <Widget>[
                                          Icon(FontAwesomeIcons.clock,color: Colors.grey,size: 12.0),
                                          SizedBox(width: 5.0),
                                          Text("${snapshot.data.result.data[index].createdAt}",style:TextStyle(fontSize:10.0,color:Colors.grey,fontFamily:'Rubik',fontWeight:FontWeight.bold)),
                                        ],
                                      )
                                  ),
                                ),
                              ],
                            ),
                            Divider()
                          ],
                        ),
                      ),
                    ),
                    background: slideLeftBackground(),
                    confirmDismiss: (direction) async {
                      final bool res = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Text("Anda Yakin Akan Menghapus Data Ini ???"),
                            actions: <Widget>[
                              FlatButton(
                                child: Text("Cancel", style: TextStyle(color: Colors.black)),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: Text("Delete", style: TextStyle(color: Colors.red),),
                                onPressed: () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  deleteFeed(snapshot.data.result.data[index].id);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                );
              }
          ),
          whenEmptyLoad: true,
          delegate: DefaultLoadMoreDelegate(),
          textBuilder: DefaultLoadMoreTextBuilder.english,
          isFinish: snapshot.data.result.data.length < perpage,
          onLoadMore: _loadMore,
        ),
      ),
    ) : Container(child:Center(child:Text("Data Tida Tersedia",style:TextStyle(fontWeight:FontWeight.bold,fontFamily: 'Rubik'))));
  }
  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }
  Widget _loading(){
    return ListView.builder(
        primary: true,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: 5,
        itemBuilder: (context,index){
          return InkWell(
            onTap: (){
            },
            child: Container(
              padding: EdgeInsets.only(bottom: 10.0,left:15.0,right:15.0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        child: Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[

                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  child: SkeletonFrame(width: MediaQuery.of(context).size.width/2,height: 30),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 0.0),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 3.0),
                              height: 80.0,
                              width: 100.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: SkeletonFrame(width: 100,height: 80),
                            ),

                          ],
                        ),
                      ),

                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            child: Row(
                              children: <Widget>[
                                SkeletonFrame(width: MediaQuery.of(context).size.width/2,height: 15),
                              ],
                            )
                        ),
                      ),

                    ],
                  ),
                  SizedBox(height: 10.0)
                ],
              ),
            ),
          );
        }
    );
  }

  void _lainnyaModalBottomSheet(context){
    showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        backgroundColor: Colors.black,
        context: context,
        isScrollControlled: true,
        builder: (context){
          return StatefulBuilder(
            builder: (context, state){
              return BottomWidget(sendFeed: (String caption, File img){
                setState(() {
                  isLoading = true;
                });
                sendFeed(caption,img);
              });
            }
          );
        }
    );
  }

}


class BottomWidget extends StatefulWidget {
  final Function(String caption, File _image) sendFeed;
  BottomWidget({this.sendFeed});
  @override
  _BottomWidgetState createState() => _BottomWidgetState();
}

class _BottomWidgetState extends State<BottomWidget> {
  var captionController = TextEditingController();
  Future<File> file;
  String base64Image;
  File tmpFile;
  File _image;
  String fileName;
  final FocusNode captionFocus = FocusNode();
  Future<Directory> getTemporaryDirectory() async {
    return Directory.systemTemp;
  }
  getImageFile() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.green,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false
      ),
      iosUiSettings: IOSUiSettings(
        minimumAspectRatio: 1.0,
      ),
      maxWidth: 512,
      maxHeight: 512,
    );
    final quality = 90;
    final tmpDir = (await getTemporaryDirectory()).path;
    final target ="$tmpDir/${DateTime.now().millisecondsSinceEpoch}-$quality.png";

    var result = await FlutterImageCompress.compressAndGetFile(
      croppedFile.path,
      target,
      format: CompressFormat.png,
      quality: 90,
    );

    setState(() {
      _image = result;
      print(_image.lengthSync());
      print("############################## $_image #################################");
    });
  }




  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:18,vertical: 18 ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          InkWell(
            onTap: (){
              getImageFile();
            },
            child: Container(
              padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.green,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.all(
                    Radius.circular(5.0)
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        height: 40.0,
                        width: 40.0,
                        child:_image != null ? Image.file(_image) :Image.network("https://vignette.wikia.nocookie.net/solo-leveling/images/5/5a/WK_No_Image.png/revision/latest?cb=20190324133049"),
                      ),
                      new SizedBox(width: 10.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Text("Upload Gambar",style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
                                SizedBox(width: 10.0),
                                Icon(Icons.backup,color: Colors.white,)
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: TextFormField(
              style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),
              controller: captionController,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              focusNode: FocusNode(),
              autofocus: true,
              onFieldSubmitted: (value){
                if(captionController.text == ''){
                  FocusScope.of(context).requestFocus(FocusNode());
                }else{
                  Navigator.of(context).pop();
                  captionFocus.unfocus();
                  widget.sendFeed(captionController.text,_image);
                  captionController.text = '';
                  _image = null;
                }
              },
              decoration: new InputDecoration(
                hintStyle: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),
                border: InputBorder.none,
                hintText: "Buat Caption Status ...",
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}

