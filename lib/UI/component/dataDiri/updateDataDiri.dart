
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/DBHELPER/userDBHelper.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/uploadImage.dart';
import 'package:thaibah/UI/component/home/widget_index.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:thaibah/resources/memberProvider.dart';

class UpdateDataDiri extends StatefulWidget {
  final String name;
  final String nohp;
  final String gender;
  final String picture;
  UpdateDataDiri({
    this.name,this.nohp,this.gender,this.picture
  });
  @override
  _UpdateDataDiriState createState() => _UpdateDataDiriState();
}

class _UpdateDataDiriState extends State<UpdateDataDiri> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var nameController = TextEditingController();
  var nohpController = TextEditingController();
  var jkController = TextEditingController();
  final FocusNode nameFocus       = FocusNode();
  final FocusNode nohpFocus       = FocusNode();
  String txtPath='photo belum dipilih';
  String dropdownValue = 'pria';
  File _image;
  String base64Image='';
  final userRepository = UserRepository();
  String codeCountry = '';
  Future loadUser() async{
    final no = widget.nohp;
    final name = widget.name;
    setState(() {
      nohpController.text = no;
      nameController.text = name;
    });
  }

  Future update() async {
    final dbHelper = DbHelper.instance;
    Map<String, dynamic> row;
    final id = await userRepository.getDataUser('id');
    if(base64Image!=''){
      row = {
        DbHelper.columnId   : id,
        DbHelper.columnName : nameController.text,
        DbHelper.columnPhone : nohpController.text,
        DbHelper.columnPicture : base64Image,
      };
    }
    else{
      base64Image = "";
      row = {
        DbHelper.columnId   : id,
        DbHelper.columnName : nameController.text,
        DbHelper.columnPhone : nohpController.text,
      };
    }
    var res = await MemberProvider().fetchUpdateMember(nameController.text,nohpController.text,dropdownValue, base64Image, '','');
    if(res is General){
      General result = res;
      if(result.status=='success'){
        Navigator.pop(context);
        UserRepository().notifNoAction(_scaffoldKey, context,result.msg,"success");
        await dbHelper.update(row);
        await Future.delayed(Duration(seconds: 0, milliseconds: 1000));
        Navigator.of(context, rootNavigator: true).push(
          new CupertinoPageRoute(builder: (context) => WidgetIndex(param: 'profile')),
        );
      }
      else{
        Navigator.pop(context);
        UserRepository().notifNoAction(_scaffoldKey, context,result.msg,"failed");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    loadUser();
    dropdownValue = 'pria';
  }

  @override
  void dispose() {
    nameController.dispose();
    nohpController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(width: 750, height: 1334, allowFontScaling: true);
    return Scaffold(
      key: _scaffoldKey,
      appBar: UserRepository().appBarWithButton(context, "Data Diri",(){Navigator.pop(context);},<Widget>[]),
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      body: _form(),
    );
  }

  Widget _form(){
    return ListView(
      padding: EdgeInsets.all(0.0),
      children: <Widget>[
        Container(
          padding:EdgeInsets.only(left:10.0,right:10.0,bottom: 10.0),
          decoration: BoxDecoration(
            boxShadow: [
              new BoxShadow(
                color: Colors.black26,
                offset: new Offset(0.0, 2.0),
                blurRadius: 25.0,
              )
            ],
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32)
            )
          ),
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    UserRepository().textQ("Nama",12,Colors.black,FontWeight.bold,TextAlign.left),
                    SizedBox(height: ScreenUtilQ.getInstance().setHeight(18)),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: TextFormField(
                        style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),fontWeight: FontWeight.bold,fontFamily: ThaibahFont().fontQ,color: Colors.grey),
                        controller: nameController,
                        maxLines: 1,
                        autofocus: false,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[200]),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          hintStyle: TextStyle(color: Colors.grey, fontSize:ScreenUtilQ.getInstance().setSp(30),fontFamily: ThaibahFont().fontQ),
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        focusNode: nameFocus,

                      ),
                    ),
                    SizedBox(height: ScreenUtilQ.getInstance().setHeight(18)),
                    UserRepository().textQ("No Handphone", 12, Colors.black,FontWeight.bold, TextAlign.left),
                    SizedBox(height: ScreenUtilQ.getInstance().setHeight(18)),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child:  TextFormField(
                        style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),fontWeight: FontWeight.bold,fontFamily: ThaibahFont().fontQ,color: Colors.grey),
                        controller: nohpController,
                        enabled: false,
                        maxLines: 1,
                        autofocus: false,
                        maxLength: 15,
                        decoration: InputDecoration(
                          counterText: '',
                          disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none,),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none,),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none,),
                          hintStyle: TextStyle(color: Colors.grey, fontSize:ScreenUtilQ.getInstance().setSp(30),fontFamily: ThaibahFont().fontQ),
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        focusNode: nohpFocus,
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                      ),
                    ),
                    SizedBox(height: ScreenUtilQ.getInstance().setHeight(18)),
                    UserRepository().textQ("Jenis Kelamin", 12, Colors.black,FontWeight.bold, TextAlign.left),
                    SizedBox(height: ScreenUtilQ.getInstance().setHeight(18)),
                    Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: DropdownButton<String>(
                          isDense: true,
                          isExpanded: true,
                          value: dropdownValue,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 20,
                          underline: SizedBox(),
                          onChanged: (value) {
                            setState(() {
                              dropdownValue = value;
                            });
                          },
                          items: <String>['pria', 'wanita'].map<DropdownMenuItem<String>>((String value) {
                            return new DropdownMenuItem<String>(
                              value: value,
                              child: Row(
                                children: [
                                  UserRepository().textQ(value,12,Colors.grey,FontWeight.bold,TextAlign.left)
                                ],
                              ),
                            );
                          }).toList(),

                        )
                    ),
                    SizedBox(height: ScreenUtilQ.getInstance().setHeight(18)),
                    UserRepository().textQ("Pilih photo profile", 12, Colors.black,FontWeight.bold, TextAlign.left),
                    SizedBox(height: ScreenUtilQ.getInstance().setHeight(18)),
                    InkWell(
                      onTap: (){
                        // final img = await userRepository.getImageFile(ImageSource.gallery);
                        // setState(() {
                        //   _image = img;
                        // });
                        UserRepository().myModal(context,UploadImage(
                          callback: (String img){
                            setState(() {
                              base64Image = img;
                            });
                            Navigator.pop(context);
                            // Uint8List bytes = base64Image.decode();
                            // Uint8List bytes = BASE64.decode(_base64);
                            // Base64Decoder().convert(base64Image);
                            // print("BASE ${Base64Decoder().convert(base64Image)}");
                          },
                        ));

                      },
                      child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Row(
                            mainAxisAlignment:MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(ApiService().noImage),
                                radius: 10.0,
                              ),
                              SizedBox(width:10.0),
                              UserRepository().textQ(base64Image!=''?(base64Image.length>40?base64Image.substring(0,40):base64Image):'photo belum dipilih', 12, Colors.grey, FontWeight.bold, TextAlign.left)
                            ],
                          )
                      ),
                    ),
                    SizedBox(height: ScreenUtilQ.getInstance().setHeight(18)),
                    UserRepository().buttonQ(context,(){
                      if (nameController.text == "") {
                        UserRepository().notifNoAction(_scaffoldKey, context,"Nama Harus Diisi","failed");
                        nameFocus.requestFocus();
                      }
                      else {
                        UserRepository().loadingQ(context);
                        update();
                      }
                    }, 'Simpan')


                  ],
                ),
              ),



            ],
          ),
        ),
      ],
    );
  }
}

