import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thaibah/Model/profileModel.dart';
import 'package:thaibah/UI/Widgets/alertq.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/component/History/historyDeposit.dart';
import 'package:thaibah/UI/component/History/historyPenarikan.dart';
import 'package:thaibah/UI/component/History/indexHistory.dart';
import 'package:thaibah/UI/component/dataDiri/indexMember.dart';
import 'package:thaibah/UI/component/penukaranBonus.dart';
import 'package:thaibah/UI/component/privacyPolicy.dart';
import 'package:thaibah/UI/jaringan_ui.dart';
import 'package:thaibah/bloc/profileBloc.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:thaibah/resources/gagalHitProvider.dart';
import 'package:thaibah/resources/memberProvider.dart';
import 'package:thaibah/resources/profileProvider.dart';
import 'component/sosmed/myFeed.dart';
import 'loginPhone.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';
import 'package:device_info/device_info.dart';

class ProfileUI extends StatefulWidget {
  @override
  _ProfileUIState createState() => _ProfileUIState();
}

class _ProfileUIState extends State<ProfileUI> {
  StreamSubscription streamConnectionStatus;
  ProfileModel profileModel;
  bool isExpanded = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  double _height;
  double _width;
  bool isLoading = false;
//  String spCover, spPicture, spName, spReff, spUnique, id;
  bool loginStatus;
  Future<File> file;
  File _image;
  String base64Image;
  final formatter = new NumberFormat("#,###");
  final userRepository = UserRepository();
  String versionCode = '';
  bool versi = false;
  bool retry=false;
  final _bloc=ProfileBloc();
  Future cekVersion() async {
//    String id = await userRepository.getID();
//    var jsonString = await http.get(ApiService().baseUrl+'info?id='+id);
//    if (jsonString.statusCode == 200) {
//      final jsonResponse = json.decode(jsonString.body);
//      Info response = new Info.fromJson(jsonResponse);
//      versionCode = (response.result.versionCode);
//      if(versionCode != ApiService().versionCode){
//        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => UpdatePage()), (Route<dynamic> route) => false);
//      }
//      setState(() {
//        isLoading = false;
//      });
//      print("###########################################################LOAD DATA HOME###############################################################");
//      print(jsonResponse);
//    } else {
//      throw Exception('########################################################### FALIED LOAD DATA HOME###############################################################');
//    }
  }
  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
//    profileBloc.fetchProfileList();
    _bloc.fetchProfileList();
  }

  int jumlahJaringan=0;
  String name='',picture='',cover='',kdReferral='',saldo='',rawSaldo='',saldoMain='',saldoBonus='',downline='';
  String kaki1='',kaki2='',kaki3='',privacyPolicy='',omsetJaringan='',id='';
  bool modeUpdate=false;
  Future<void> loadData() async{
    final prefs = await SharedPreferences.getInstance();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print('abus');
    var res = await ProfileProvider().fetchProfile();
    if(prefs.get('pin') == null || prefs.get('pin') == ''){
      print('pin kosong');
      setState(() {
        isLoading = false;modeUpdate = true;
      });
      GagalHitProvider().fetchRequest('profile','kondisi = pin kosong, brand = ${androidInfo.brand}, device = ${androidInfo.device}, model = ${androidInfo.model}');
    }else{
      if(res is ProfileModel){
        setState(() {
          isLoading = false; retry = false;
          var result = res.result;
          jumlahJaringan=result.jumlahJaringan;
          name=result.name;picture=result.picture;cover=result.cover;kdReferral=result.kdReferral;saldo=result.saldo;rawSaldo=result.rawSaldo;saldoMain=result.saldoMain;
          saldoBonus=result.saldoBonus;downline=result.downline;kaki1=result.kaki1;kaki2=result.kaki2;kaki3=result.kaki3;privacyPolicy=result.privacy;omsetJaringan=result.omsetJaringan;
          id=result.id;
        });
      }
      else{
        GagalHitProvider().fetchRequest('profile','brand = ${androidInfo.brand}, device = ${androidInfo.device}, model = ${androidInfo.model}');
        setState(() {
          isLoading = false;retry = true;
        });
      }
    }

  }


  void showInSnackBar(String value) {
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
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 3),
    ));
  }
  Future logout() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return AlertQ(
      style: AlertStyle(
          titleStyle: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),
          descStyle: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontFamily: 'Rubik')
      ),
      context: context,
      type: AlertType.warning,
      title: "ANDA YAKIN",
      desc: "Akan Keluar Aplikasi Ini ??",
      buttons: [
        DialogButton(
          child: Text("TIDAK",style: TextStyle(color: Colors.white, fontSize: 20)),
          onPressed: () => Navigator.of(context).pop(false),
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          child: Text("YA",style: TextStyle(color: Colors.white, fontSize: 20)),
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            var res = await MemberProvider().logout();
            if(res.status == 'success'){
//              clearData();
              prefs.clear();
              prefs.commit();
              prefs.setBool('cek', true);
              prefs.setString('id', null);
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPhone()), (Route<dynamic> route) => false);
            }
          },
          gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
        )
      ],
    ).show();
  }

  Future<void> refresh() async {
    Timer(Duration(seconds: 1), () {
      setState(() {
        isLoading = true;
      });
    });
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    loadData();
  }

  @override
  void initState() {
    super.initState();
    loadData();
    isLoading=true;
  }



  bool isLoadingShare = false;
  Future share(param) async{
    setState(() {
      isLoadingShare = true;
    });
    Timer(Duration(seconds: 1), () async {
      setState(() {
        isLoadingShare = false;
      });
      await WcFlutterShare.share(
          sharePopupTitle: 'Thaibah Share Link',
          subject: 'Thaibah Share Link',
          text: "https://thaibah.com/signup/$param\n\n\nAyo Buruan daftar",
          mimeType: 'text/plain'
      );
    });

  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: scaffoldKey,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: modeUpdate == true ? modeUpdateBuild() : isLoading ? _loading() : retry == true ? UserRepository().requestTimeOut((){
        setState(() {
          retry=false;
          isLoading=true;
        });
        loadData();
      }) : RefreshIndicator(
          child: Container(
            height: _height,
            width: _width,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _headerProfile(),
                  _menuMember(),
                ],
              ),
            ),
          ),
          onRefresh: refresh
      ),

    );
  }
  Widget modeUpdateBuild(){
    return Container(
      padding:EdgeInsets.all(10.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox.fromSize(
              size: Size(100, 100), // button width and height
              child: ClipOval(
                child: Material(
                  color: Colors.green, // button color
                  child: InkWell(
                    splashColor: Colors.green, // splash color
                    onTap: () async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.clear();
                      prefs.commit();
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPhone()), (Route<dynamic> route) => false);
                    }, // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.power_settings_new,color: Colors.white,), // icon
                        Text("Keluar",style:TextStyle(color:Colors.white,fontWeight: FontWeight.bold)), // text
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0,),
            Text("anda baru saja mengupgdate aplikasi thaibah.",textAlign: TextAlign.center,style:TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
            Text("tekan tombol keluar untuk melanjutkan proses pemakaian aplikasi thaibah",textAlign: TextAlign.center,style:TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
          ],
        ),
      ),
    );
  }
  Widget _headerProfile(){
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: (){
          },
          child: Container(
            height: MediaQuery.of(context).size.height/2.5,
            decoration: new BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              image: new DecorationImage(
                fit: BoxFit.cover,
                colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.dstATop),
                image: new NetworkImage(
                  cover,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          // bottom: _height/6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 80.0,
                  height: 80.0,
                  margin: EdgeInsets.only(top:0.0),
                  padding: EdgeInsets.all(10),
                  child: CircleAvatar(
                    minRadius: 90,
                    maxRadius: 150,
                    child: CachedNetworkImage(
                      imageUrl: picture,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))),
                      ),
                      errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: new BorderRadius.circular(50.0),
                          color: Colors.grey,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Text(name, style: TextStyle(color: Colors.white,fontSize: 20,fontFamily: 'Rubik', fontWeight: FontWeight.bold, shadows: [Shadow(
                  blurRadius: 5.0,
                  color: Colors.black,
                  offset: Offset(0.0, 1.0),
                ),
                ]),),
                GestureDetector(
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          kdReferral,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white,fontFamily: 'Rubik',
                              shadows: [
                                Shadow(
                                  blurRadius: 5.0,
                                  color: Colors.black,
                                  offset: Offset(0.0, 1.0),
                                ),
                              ]
                          ),
                        ),
                        SizedBox(width: 5),
                        Icon(Icons.content_copy, color: Colors.white, size: 15,),]),
                  onTap: () {
                    Clipboard.setData(new ClipboardData(text: kdReferral));
                    scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text("Kode Referral Berhasil Disalin")));
                  },
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: EdgeInsets.only(left:10.0,right:10.0),
                  child:Container(
                    decoration: new BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                    ),
                    padding: EdgeInsets.all(0.0),
                    width: MediaQuery.of(context).size.width/1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          child: Column(
                            children: <Widget>[
                              InkWell(
                                onTap: (){
                                  _lainnyaModalBottomSheet(context,'barcode','https://pngimg.com/uploads/qr_code/qr_code_PNG2.png');
                                },
                                child: Container(
                                  child: isLoading?SkeletonFrame(width: 50.0,height: MediaQuery.of(context).size.height/15):Image.network(
                                    'https://pngimg.com/uploads/qr_code/qr_code_PNG2.png',
                                    height: MediaQuery.of(context).size.height/20,
                                  ),
                                ),
                              ),
                              SizedBox(height: 7.0),
                              isLoading? SkeletonFrame(width: 60.0,height: 12.0):Text('QR Code',style: TextStyle(fontSize:16.0,color:Colors.black,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                              SizedBox(height: 5.0),
                              isLoading? SkeletonFrame(width: 70.0,height: 12.0):Text('Untuk Transfer',style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                              SizedBox(height: 2.0),
                              isLoading? SkeletonFrame(width: 80.0,height: 12.0):Text('Ke Sesama Member',style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                            ],
                          ),
                        ),
                        Container(
                          width:2.0,
                          decoration: new BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                          ),
                          height: 110.0,
                        ),
                        Container(
                          child: Column(

                            children: <Widget>[
                              InkWell(
                                onTap: () async {
                                  setState(() {
                                    isLoadingShare=true;
                                  });
                                  share(kdReferral);

                                },
                                child: isLoadingShare?CircularProgressIndicator(): Container(
                                  child: isLoading?SkeletonFrame(width: 50.0,height: MediaQuery.of(context).size.height/15):SvgPicture.asset(
                                    ApiService().assetsLocal+'Icon_Share.svg',
                                    height: MediaQuery.of(context).size.height/20,
                                  ),
                                ),
                              ),
                              SizedBox(height: 7.0),
                              isLoading? SkeletonFrame(width: 60.0,height: 12.0):Text('Share',style: TextStyle(fontSize:16.0,color:Colors.black,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                              SizedBox(height: 5.0),
                              isLoading? SkeletonFrame(width: 70.0,height: 12.0):Text('Share Link',style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                              SizedBox(height: 2.0),
                              isLoading? SkeletonFrame(width: 80.0,height: 12.0):Text('Ke Kerabat Anda',style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )
        ),

//        Positioned(
//            bottom: 0.0,
//            child: Container(
//                padding: EdgeInsets.all(15),
//                width: _width,
//                margin: EdgeInsets.only(top:5),
//                // color: Colors.white,
//                decoration: BoxDecoration(
//                    shape: BoxShape.rectangle,
//                    color: Colors.white
//                ),
//                child: Column(
//                    children: <Widget>[
//                      Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                        crossAxisAlignment: CrossAxisAlignment.start,
//                        children: <Widget>[
//                          FlatButton(
//                            onPressed: (){
//                              print("tapped");
//                              Navigator.of(context, rootNavigator: true).push(
//                                new CupertinoPageRoute(builder: (context) => HistoryUI(page: 'profile')),
//                              );
//                            },
//                            child: Row(children: <Widget>[
//                              Container(
//                                width: 40.0,
//                                height: 50.0,
//                                // color: Colors.white,
//                                padding: EdgeInsets.fromLTRB(0,10,10,10),
//                                child: Image.asset('assets/images/ic_money_bag_100.png'),
//                              ),
//                              Column(
//                                crossAxisAlignment: CrossAxisAlignment.end,
//                                children: <Widget>[
//                                  Text("Bonus Saya", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,fontFamily: 'Rubik')),
//                                  Text(saldoBonus, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,fontFamily: 'Rubik')),
//                                ],
//                              ),
//                            ]
//                            ),
//                          ),
//                          FlatButton(
//                            onPressed: (){
//                              print("tapped");
//                              Navigator.of(context, rootNavigator: true).push(
//                                new CupertinoPageRoute(builder: (context) => JaringanUI(kdReferral:kdRefferal)),
//                              );
//                            },
//                            child: Row(
//                              children: <Widget>[
//                                Container(
//                                  width: 40.0,
//                                  height: 50.0,
//                                  // color: Colors.white,
//                                  padding: EdgeInsets.fromLTRB(0,10,10,10),
//                                  child: Image.asset('assets/images/icons8-tree-structure-100.png'),
//                                ),
//                                Column(
//                                  crossAxisAlignment: CrossAxisAlignment.end,
//                                  children: <Widget>[
//                                    Text("Jaringan Saya", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,fontFamily: 'Rubik')),
//                                    Text(jumlahJaringan, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,fontFamily: 'Rubik')),
//                                  ],
//                                ),
//                              ]
//                            ),
//                          )
//                        ],
//                      ),
//                    ]
//                )
//            )
//        )
      ],


    );

  }

  Widget _menuMember(){
    return Container(
      margin: EdgeInsets.only(top: 5),
      color: Colors.white,
      child: Column(
        children: <Widget>[
//          FlatButton(
//              onPressed: (){
//                Navigator.of(context, rootNavigator: true).push(
//                  new CupertinoPageRoute(builder: (context) => VideoListUI()),
//                );
//              },
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: <Widget>[
//                  Column(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    children: <Widget>[
//                      Text("Debugging", style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
//                      Text("Permintaan untuk isi saldo", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12,fontFamily: 'Rubik')),
//                    ],),
//                  Icon(Icons.arrow_right)
//                ],
//              )
//          ),
//          Divider(),
//          FlatButton(
//              onPressed: (){
//                Navigator.of(context, rootNavigator: true).push(
//                  new CupertinoPageRoute(builder: (context) => SaldoUI(page:'profile',saldo: saldoMain,name: name)),
//                );
//              },
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: <Widget>[
//                  Column(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    children: <Widget>[
//                      Text("Topup Saldo", style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
//                      Text("Permintaan untuk isi saldo", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12,fontFamily: 'Rubik')),
//                    ],),
//                  Icon(Icons.arrow_right)
//                ],
//              )
//          ),
//          Divider(),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Container(
                color: Color(0xFF116240),
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[

                    InkWell(
                      onTap: (){
                        Navigator.of(context, rootNavigator: true).push(
                          new CupertinoPageRoute(builder: (context) => JaringanUI(kdReferral: kdReferral,name:name)),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Omset Jaringan Anda", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                          Text("Rp ${formatter.format(int.parse(omsetJaringan))}", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                        ],
                      ),
                    ),
                    Divider(),
                    InkWell(
                      onTap: (){
                        Navigator.of(context, rootNavigator: true).push(
                          new CupertinoPageRoute(builder: (context) => JaringanUI(kdReferral: kdReferral,name:name)),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Jaringan Saya", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                          Text("$jumlahJaringan ( Orang )", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                        ],
                      ),
                    ),
                    Divider(),
                    InkWell(
                      onTap: (){
                        Navigator.of(context, rootNavigator: true).push(
                          new CupertinoPageRoute(builder: (context) => JaringanUI(kdReferral: kdReferral,name:name)),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Kaki Besar 1", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                          Text("$kaki1 ( STP )", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                        ],
                      ),
                    ),
                    Divider(),
                    InkWell(
                      onTap: (){
                        Navigator.of(context, rootNavigator: true).push(
                          new CupertinoPageRoute(builder: (context) => JaringanUI(kdReferral: kdReferral,name:name)),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Kaki Besar 2", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                          Text("$kaki2 ( STP )", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                        ],
                      ),
                    ),
                    Divider(),
                    InkWell(
                      onTap: (){
                        Navigator.of(context, rootNavigator: true).push(
                          new CupertinoPageRoute(builder: (context) => JaringanUI(kdReferral: kdReferral,name:name)),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Kaki Besar 3", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                          Text("$kaki3 ( STP )", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                        ],
                      ),
                    )

                  ],
                )
            ),

          ),
          SizedBox(height:4.0,child: Container(color: Color(0xFFf5f5f5)),),

          FlatButton(
              onPressed: (){
                Navigator.of(context, rootNavigator: true).push(
                  new CupertinoPageRoute(builder: (context) => PenukaranBonus(saldo: saldoMain, saldoBonus:saldoBonus)),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Penukaran Bonus", style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                      Text("Permintaan Untuk Penukaran Bonus", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12,fontFamily: 'Rubik')),
                    ],),
                  Icon(Icons.arrow_right)
                ],
              )
          ),
          Divider(),
//          FlatButton(
//              onPressed: (){
//                Navigator.of(context, rootNavigator: true).push(
//                  new CupertinoPageRoute(builder: (context) => Penarikan(saldoMain: saldoMain)),
//                );
//              },
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: <Widget>[
//                  Column(
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      children: <Widget>[
//                        Text("Penarikan", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Rubik'),),
//                        Text("Penarikan dana ke rekening anda", style: TextStyle(fontFamily: 'Rubik',fontWeight: FontWeight.normal, fontSize: 12)),
//                      ]
//                  ),
//                  Icon(Icons.arrow_right)
//                ],
//              )
//          ),
//          Divider(),
          FlatButton(
              onPressed: (){
                Navigator.of(context, rootNavigator: true).push(
                  new CupertinoPageRoute(builder: (context) => HistoryPenarikan()),
                );
                print('Routing to Electronics item list');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Riwayat Penarikan", style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                      Text("Permintaan untuk melihat riwayat penarikan", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12,fontFamily: 'Rubik')),
                    ],),
                  Icon(Icons.arrow_right)
                ],
              )
          ),
          Divider(),
//          FlatButton(
//              onPressed: (){
//                Navigator.of(context, rootNavigator: true).push(
//                  new CupertinoPageRoute(builder: (context) => HistoryUI(page: 'profile')),
//                );
//                print('Routing to Electronics item list');
//              },
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: <Widget>[
//                  Column(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    children: <Widget>[
//                      Text("Riwayat Transaksi", style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
//                      Text("Permintaan untuk melihat riwayat transaksi", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12,fontFamily: 'Rubik')),
//                    ],),
//                  Icon(Icons.arrow_right)
//                ],
//              )
//          ),
//          Divider(),
          FlatButton(
              onPressed: (){
                print("tapped");
                Navigator.of(context, rootNavigator: true).push(
                  new CupertinoPageRoute(builder: (context) => IndexHistory()),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Riwayat Pembelian", style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                      Text("Permintaan untuk melihat riwayat pembelian", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12,fontFamily: 'Rubik')),
                    ],),
                  Icon(Icons.arrow_right)
                ],
              )
          ),
          Divider(),
          FlatButton(
              onPressed: (){
                print("tapped");
                Navigator.of(context, rootNavigator: true).push(
                  new CupertinoPageRoute(builder: (context) => HistoryDeposit()),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Riwayat Topup", style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                      Text("Permintaan untuk melihat riwayat topup", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12,fontFamily: 'Rubik')),
                    ],),
                  Icon(Icons.arrow_right)
                ],
              )
          ),
          Divider(),
          FlatButton(
              onPressed: (){
                Navigator.of(context, rootNavigator: true).push(
                  new CupertinoPageRoute(builder: (context) => MyFeed()),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Sosial Media", style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                      Text("Riwayat Postingan Sosial Media Saya", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12,fontFamily: 'Rubik')),
                    ],),
                  Icon(Icons.arrow_right)
                ],
              )
          ),
          Divider(),
          FlatButton(
              onPressed: (){
                Navigator.of(context, rootNavigator: true).push(
                  new CupertinoPageRoute(builder: (context) => IndexMember(id: id)),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Edit Profile", style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                      Text("Permintaan untuk mengedit profile", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12,fontFamily: 'Rubik')),
                    ],),
                  Icon(Icons.arrow_right)
                ],
              )
          ),
//          Divider(),
//          FlatButton(
//              onPressed: (){
//                Navigator.of(context, rootNavigator: true).push(
//                  new CupertinoPageRoute(builder: (context) => ListFeed()),
//                );
//              },
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: <Widget>[
//                  Column(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    children: <Widget>[
//                      Text("Sosial Media", style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
//                      Text("Membuat Member Saling Bersilaturhami", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12,fontFamily: 'Rubik')),
//                    ],),
//                  Icon(Icons.arrow_right)
//                ],
//              )
//          ),
          Divider(),
          FlatButton(
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).push(
                  new CupertinoPageRoute(builder: (context) => PrivacyPolicy(privasi: privacyPolicy)),
                );
//                logout();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Kebijakan & Privasi", style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                      Text("Informasi Tentang Kebijakan & Privasi", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12,fontFamily: 'Rubik')),
                    ],
                  ),
                  Icon(Icons.arrow_right)
                ],
              )
          ),
          Divider(),
          FlatButton(
              onPressed: () async {
                logout();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Keluar", style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                      Text("Permintaan untuk keluar sesi aplikasi", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12,fontFamily: 'Rubik')),
                    ],
                  ),
                  Icon(Icons.arrow_right)
                ],
              )
          ),

        ],
      ),
    );
  }


  Widget _loading(){
    return Column(
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: (){

              },
              child: Container(
                height: 300,
                child: SkeletonFrame(height: 300,width: MediaQuery.of(context).size.width/1,),
              ),
            ),

            Positioned(
              // bottom: _height/6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: 80.0,
                      height: 80.0,
                      padding: EdgeInsets.all(10),
                      child: CircleAvatar(
                        minRadius: 90,
                        maxRadius: 150,
                        child: CachedNetworkImage(
                          imageUrl: "",
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))),
                          ),
                          errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              borderRadius: new BorderRadius.circular(50.0),
                              color: Colors.grey,
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SkeletonFrame(width: 80.0, height: 16.0),

                    GestureDetector(
                      child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SkeletonFrame(width: 80.0, height: 16.0),
                            SizedBox(width: 5),
                            Icon(Icons.content_copy, color: Colors.white, size: 15,),]),

                    ),
                    SizedBox(height: 20,),
                  ],
                )
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(top:5),
          color: Colors.white,
          child: Column(
            children: <Widget>[
              FlatButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SkeletonFrame(width: 80.0, height: 16.0),
                          SizedBox(height:5.0),
                          SkeletonFrame(width: 250.0, height: 16.0),
                        ],
                      ),
                      Icon(Icons.arrow_right)
                    ],
                  )
              ),
              Divider(),
              FlatButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SkeletonFrame(width: 80.0, height: 16.0),
                          SizedBox(height:5.0),
                          SkeletonFrame(width: 250.0, height: 16.0),
                        ],
                      ),
                      Icon(Icons.arrow_right)
                    ],
                  )
              ),
              Divider(),
              FlatButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SkeletonFrame(width: 80.0, height: 16.0),
                          SizedBox(height:5.0),
                          SkeletonFrame(width: 250.0, height: 16.0),
                        ],
                      ),
                      Icon(Icons.arrow_right)
                    ],
                  )
              ),
              Divider(),
              FlatButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SkeletonFrame(width: 80.0, height: 16.0),
                          SizedBox(height:5.0),
                          SkeletonFrame(width: 250.0, height: 16.0),
                        ],
                      ),
                      Icon(Icons.arrow_right)
                    ],
                  )
              ),
              Divider(),
              FlatButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SkeletonFrame(width: 80.0, height: 16.0),
                          SizedBox(height:5.0),
                          SkeletonFrame(width: 250.0, height: 16.0),
                        ],
                      ),
                      Icon(Icons.arrow_right)
                    ],
                  )
              ),
              Divider(),
              FlatButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SkeletonFrame(width: 80.0, height: 16.0),
                          SizedBox(height:5.0),
                          SkeletonFrame(width: 250.0, height: 16.0),
                        ],
                      ),
                      Icon(Icons.arrow_right)
                    ],
                  )
              ),
              Divider(),
              FlatButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SkeletonFrame(width: 80.0, height: 16.0),
                          SizedBox(height:5.0),
                          SkeletonFrame(width: 250.0, height: 16.0),
                        ],
                      ),
                      Icon(Icons.arrow_right)
                    ],
                  )
              ),
              Divider(),
            ],
          ),
        )
      ],
    );
  }

  void _lainnyaModalBottomSheet(context, String param,String _qr){
    showModalBottomSheet(
        isScrollControlled: param == 'barcode' ? false : true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc){
          return Wrap(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width/1,
                child: Material(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
                    elevation: 5.0,
                    color:Colors.grey[50],
                    child: Column(
                        children: <Widget>[
                          SizedBox(height: 20,),
                          Text("Scan Kode Referral Anda ..", style: TextStyle(color: Colors.black,fontSize: 14,fontFamily: 'Rubik',fontWeight: FontWeight.bold),),
                          SizedBox(height: 10.0,),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Image.network(_qr,fit: BoxFit.contain,),
                          )
                        ]
                    )
                ),
              )
            ],
          );
        }
    );
  }

}