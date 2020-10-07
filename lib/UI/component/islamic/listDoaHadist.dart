import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/islamic/doaModel.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/bloc/islamic/islamicBloc.dart';
import 'package:thaibah/config/user_repo.dart';

class ListDoaHadist extends StatefulWidget {
  final String type,id,title,search;
  ListDoaHadist({this.title,this.type,this.id,this.search});
  @override
  _ListDoaHadistState createState() => _ListDoaHadistState();
}

class _ListDoaHadistState extends State<ListDoaHadist> {
  String typeLocal = '';
  String idLocal = '';


  var scaffoldKey = GlobalKey<ScaffoldState>();
  String title='';
  bool isLoading = false;
  bool isChecked = false;
  bool isNote = false;
  bool isFavorite = false;
  String param = '';
  String search = '';
  Duration duration;
  Duration position;

  String localFilePath;
  String titleApp = '';





  void showInSnackBar(String value,String param) {
    FocusScope.of(context).requestFocus(new FocusNode());
    scaffoldKey.currentState?.removeCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            fontFamily: "Rubik"),
      ),
      backgroundColor: param == 'sukses' ? Colors.green : Colors.red,
      duration: Duration(seconds: 3),
    ));
  }


  Color warna1;
  Color warna2;
  String statusLevel ='0';
  final userRepository = UserRepository();
  Future loadTheme() async{
    final levelStatus = await userRepository.getDataUser('statusLevel');
    final color1 = await userRepository.getDataUser('warna1');
    final color2 = await userRepository.getDataUser('warna2');
    setState(() {
      warna1 = hexToColors(color1);
      warna2 = hexToColors(color2);
      statusLevel = levelStatus;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    typeLocal = widget.type;
    idLocal = widget.id;
    title = widget.title;
    search = widget.search;
    if(search!=''){
      doaBloc.fetchDoa(typeLocal, null,search);
      titleApp = '${title.toUpperCase()}';
    }else{
      titleApp = '${title.toUpperCase()}';
      doaBloc.fetchDoa(typeLocal, idLocal, '');
    }
    loadTheme();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: UserRepository().appBarWithButton(context, titleApp,(){Navigator.pop(context);},<Widget>[]),

      // appBar:UserRepository().appBarWithButton(context, titleApp,warna1,warna2,(){Navigator.pop(context);},Container()),
      body: StreamBuilder(
        stream:doaBloc.getResult,
        builder: (context, AsyncSnapshot<DoaModel> snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: <Widget>[
                Expanded(
                  flex: 10,
                  child: buildContent(snapshot,context),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          return _loading();
        },
      ),
    );
  }

  Widget buildContent(AsyncSnapshot<DoaModel> snapshot, BuildContext context){
    if(snapshot.data.result.length > 0){
      return isLoading? _loading() : ListView.builder(
        itemCount: snapshot.data.result.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: (){
              print("object");
            },
            child:  Container(
              padding: EdgeInsets.only(left:10.0,right:10),
              child: Card(
                elevation: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top:10.0),
                      child: new ListTile(
                        title: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Align(
                            alignment: Alignment.topRight,
                            child:UserRepository().textQ(snapshot.data.result[index].arabic, 16, Colors.black,FontWeight.bold,TextAlign.right),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left:16.0,bottom:10.0, right:16.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Html(
                          defaultTextStyle: TextStyle(fontFamily:ThaibahFont().fontQ,fontSize: 12,color:Colors.grey,fontStyle: FontStyle.italic),
                          data: snapshot.data.result[index].latin.replaceAll(r'\', r' '),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left:16.0,bottom:10.0, right:16.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Html(
                          defaultTextStyle: TextStyle(fontFamily:ThaibahFont().fontQ,fontSize: 12,color:Colors.black),
                          data: snapshot.data.result[index].terjemahan.replaceAll(r'\', r' '),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),

          );
        },
      );
    }else{
      return Container(
        child: Center(
          child: Text('Data Tidak Ada',style:TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontFamily: ThaibahFont().fontQ)),
        ),
      );
    }
  }

  Widget _loading(){
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return GestureDetector(
          child:  Container(
            padding: EdgeInsets.all(10.0),
            child: Card(
              elevation: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top:10.0),
                    child: new ListTile(
                      title: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: SkeletonFrame(width: MediaQuery.of(context).size.width/1,height: 16),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left:16.0,bottom:10.0, right:16.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child:SkeletonFrame(width: MediaQuery.of(context).size.width/1,height: 16),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left:16.0,bottom:10.0, right:16.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child:SkeletonFrame(width: MediaQuery.of(context).size.width/3,height: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),

        );
      },
    );
  }


//  void _lainnyaModalBottomSheet(context,id,String note){
//    print(note);
//    noteController.text = note;
//    showModalBottomSheet(
//        context: context,
//        backgroundColor: Colors.transparent,
//        builder: (BuildContext bc){
//          return Container(
//            height: MediaQuery.of(context).size.height/1,
//            child: Material(
//                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
//                elevation: 5.0,
//                color:Colors.grey[50],
//                child: Column(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    crossAxisAlignment: CrossAxisAlignment.center,
//                    children: <Widget>[
//                      SizedBox(height: 20,),
//                      SizedBox(height: 10.0,),
//                      Expanded(
//                        flex: 10,
//                        child: Container(
//                          margin: EdgeInsets.only(left: 10.0,right: 10.0),
//                          child: TextFormField(
//                            autofocus: true,
//                            controller:  noteController,
//                            keyboardType: TextInputType.text,
//                            textInputAction: TextInputAction.done,
//                            minLines: null,
//                            focusNode: noteFocus,
//                            onFieldSubmitted: (value){
//                              if(noteController.text == ''){
//                                return showInSnackBar("Form tidak boleh kosong",'gagal');
//                              }else{
//                                Navigator.pop(context);
//                                setState(() {
//                                  isLoading = true;
//                                });
//                                noteFocus.unfocus();
//                                Note(id);
//                              }
//                            },
//                            decoration: InputDecoration(
//                                hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0),
//                                hintText: 'Tulis sesuatu disini .....'
//                            ),
//                          ),
//                        ),
//                      ),
//                    ]
//                )
//            ),
//          );
//        }
//    );
//  }
}
