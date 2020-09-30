import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/checkerMemberModel.dart';
import 'package:thaibah/Model/checkerModel.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/alertq.dart';
import 'package:thaibah/UI/loginPhone.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/resources/configProvider.dart';
import 'package:thaibah/DBHELPER/userDBHelper.dart';
import 'package:thaibah/resources/gagalHitProvider.dart';


class UserRepository {
  fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  noData(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          textQ("Data Tidak Tersedia",14,Colors.black,FontWeight.bold,TextAlign.center)
        ],
      ),
    );
  }

  loadingWidget(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(strokeWidth: 10.0, valueColor: new AlwaysStoppedAnimation<Color>(ThaibahColour.primary1)),
          SizedBox(height: 10),
          textQ("Tunggu Sebentar",14,Colors.black,FontWeight.bold,TextAlign.center)
        ],
      ),
    );
  }


  notifAlertQ(BuildContext context,param,title,desc,txtBtn1,txtBtn2,Function callback1,Function callback2){
    AlertType alertType;
    if(param=='success'){
      alertType = AlertType.success;
    }
    if(param=='warning'){
      alertType = AlertType.warning;
    }
    if(param=='error'){
      alertType = AlertType.error;
    }
    return AlertQ(
      context: context,
      type: alertType,
      title:title,
      desc:desc,
      buttons: [
        DialogButton(
          child:RichText(text: TextSpan(text:txtBtn1, style: TextStyle(color: Colors.white, fontSize: 14,fontFamily:  ThaibahFont().fontQ))),
          onPressed:callback1,
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          child:RichText(text: TextSpan(text:txtBtn2, style: TextStyle(color: Colors.white, fontSize: 14,fontFamily:  ThaibahFont().fontQ))),
          onPressed:callback2,
          gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
        )
      ],
    ).show();
  }
  loadingQ(BuildContext context){
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 100.0),
            child: AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CircularProgressIndicator(strokeWidth: 10.0, valueColor: new AlwaysStoppedAnimation<Color>(ThaibahColour.primary1)),
                  SizedBox(height:10.0),
                  Html(customTextAlign: (_) => TextAlign.center, data:"Tunggu Sebentar .....",defaultTextStyle:TextStyle(fontSize:12,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold))
                ],
              ),
            )
        );

      },
    );
  }

  requestTimeOut(Function callback){
    return Container(
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
                    onTap: () {
                      callback();
                    }, // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.refresh,color: Colors.white,), // icon
                        Text("coba lagi",style:TextStyle(color:Colors.white,fontWeight: FontWeight.bold)), // text
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0,),
            Text("gagal memuat. harap periksa koneksi internet anda !!"),
          ],
        ),
      ),
    );
  }
  moreThenOne(BuildContext context, Function callback){
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
            Text("percobaan anda sudah melebihi 1x.",textAlign: TextAlign.center,style:TextStyle(fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ)),
            Text("silahkan keluar aplikasi terlebih dahulu, apabila masih ada kendala silahkan hubungi admin atau klik tombol di bawah ini",textAlign: TextAlign.center,style:TextStyle(fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ)),
            SizedBox(height: 20.0),
            Container(
              child: Center(
                child: FlatButton(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.green)
                  ),
                  color: Colors.white,
                  textColor: Colors.green,
                  padding: EdgeInsets.all(20.0),
                  onPressed: () {
                    callback();

//                    AppSettings.openAppSettings();
//                    updateApk();
                  },
                  child: Text(
                    "cara clear data".toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.0,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  modeUpdate(BuildContext context){
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false);
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
                      final dbHelper = DbHelper.instance;
                      final id = await getDataUser('id');
                      Map<String, dynamic> row = {
                        DbHelper.columnId   : id,
                        DbHelper.columnStatus : '0',
                        DbHelper.columnStatusOnBoarding  : "1",
                        DbHelper.columnStatusExitApp  : "1"
                      };
                      await dbHelper.update(row);
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPhone()), (Route<dynamic> route) => false);
                    }, // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.power_settings_new,color: Colors.white,), // icon
                        Text("Keluar",style:TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(34),fontFamily:ThaibahFont().fontQ,color:Colors.white,fontWeight: FontWeight.bold)), // text
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0,),
            Text("Token Belum Terpasang Pada Akun Thaibah Anda.",textAlign: TextAlign.center,style:TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(34),fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ)),
            Text("Silahkan Keluar dan Masuk Kembali Ke Aplikasi Thaibah Agar Akun Anda Mempunyai Token",textAlign: TextAlign.center,style:TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(34),fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ)),
          ],
        ),
      ),
    );
  }
  appBarNoButton(BuildContext context, title,List<Widget> widget){
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false)..init(context);
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.white, // status bar color
      brightness: Brightness.light,
      title: UserRepository().textQ(title,18,Colors.black,FontWeight.bold,TextAlign.left),
      leading: Padding(
        padding: EdgeInsets.all(8.0),
        child: CircleAvatar(
            radius:20.0,
            backgroundImage: AssetImage('assets/images/logoOnBoardTI.png')
        ),
      ),
      actions:widget,// status bar brightness
    );

  }
  appBarWithButton(BuildContext context, title,Function callback,List<Widget> widget){
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false)..init(context);
    return  AppBar(
      elevation: 0.0,
      backgroundColor: Colors.white, // status bar color
      brightness: Brightness.light,
      title:UserRepository().textQ(title,18,Colors.black,FontWeight.bold,TextAlign.left),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios,color: Colors.black),
        onPressed: (){
          callback();
        },
      ),
      actions:widget,// status bar brightness
    );
  }
  appBarWithTab(BuildContext context, title,Map<String,dynamic> lbl){
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false);
    List<Tab> tab = new List();
    lbl.forEach((key, value) {
      tab.add(Tab(text: value));
    });

    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.white, // status bar color
      brightness: Brightness.light,
      title:UserRepository().textQ(title,18,Colors.black,FontWeight.bold,TextAlign.left),
      leading: Padding(
        padding: EdgeInsets.all(8.0),
        child:  CircleAvatar(
            radius:20.0,
            backgroundImage: AssetImage('assets/images/logoOnBoardTI.png')
        ),
      ),

      bottom: TabBar(
          indicatorColor: Colors.green,
          labelColor: Colors.green,
          unselectedLabelColor: Colors.grey[400],
          indicatorWeight: 2,
          labelStyle: TextStyle(fontWeight:FontWeight.bold,color: Colors.white, fontFamily:ThaibahFont().fontQ,fontSize: ScreenUtilQ.getInstance().setSp(36)),
          tabs: tab
      ),// status bar brightness
    );


  }
  appBarWithTabButton(BuildContext context, title,Color color1, Color color2,Map<String,dynamic> lbl,Function callback){
    List<Tab> tab = new List();
    lbl.forEach((key, value) {
      tab.add(Tab(text: value));
    });
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false);
    var cek = new AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios,color: Colors.black),
        onPressed: (){
          callback!=null?callback():Navigator.of(context).pop();
        },
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: <Color>[
              Colors.white,
              Colors.white,
            ],
          ),
        ),
      ),
      centerTitle: false,
      elevation: 0.0,
      title:textQ(title,18,Colors.black,FontWeight.bold,TextAlign.left),
      bottom: TabBar(
          indicatorColor: Colors.green,
          labelColor: Colors.green,
          unselectedLabelColor: Colors.grey[400],
          indicatorWeight: 5 ,
          labelStyle: TextStyle(fontWeight:FontWeight.bold,color: Colors.white, fontFamily:ThaibahFont().fontQ,fontSize: ScreenUtilQ.getInstance().setSp(40)),
          tabs: tab
      ),
      actions: <Widget>[
        //Add the dropdown widget to the `Action` part of our appBar. it can also be among the `leading` part
      ],
    );
    return cek;
  }
  buttonQ(BuildContext context,Function callback,label){
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false);
    var btn = InkWell(
      onTap:callback,
      child: Center(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.green,Colors.green]),
              borderRadius: BorderRadius.circular(10.0),
          ),
          child: UserRepository().textQ(label,14,Colors.white,FontWeight.bold,TextAlign.center),
        ),
      ),
    );

    return btn;
  }
  buttonLoadQ(BuildContext context,Color color1,Color color2,Function callback,bool isLoading){
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false);
    var cek = Container(
      padding: EdgeInsets.all(10.0),
      // margin: EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width/1,
      height: ScreenUtilQ.getInstance().setHeight(100),
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [color1!=null?color1:ThaibahColour.primary1,color2!=null?color2:ThaibahColour.primary2]),
          borderRadius: BorderRadius.circular(6.0),
          boxShadow: [BoxShadow(color: Color(0xFF6078ea).withOpacity(.3),offset: Offset(0.0, 8.0),blurRadius: 8.0)]
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap:callback,
          child: Center(
            child:  isLoading ? CircularProgressIndicator(strokeWidth: 10, valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFFFFFFFF))):
            textQ("Tampilkan Lebih Banyak", 14, Colors.white, FontWeight.bold, TextAlign.center)
          ),
        ),
      ),
    );
    return cek;
  }
  textQ(String txt,double size,Color color,FontWeight fontWeight,TextAlign textAlign){
    return RichText(
      textAlign: textAlign,
      softWrap: true,

      text: TextSpan(
        text:txt,
        style: TextStyle(
          fontSize:size,color: color,fontFamily:ThaibahFont().fontQ,fontWeight:fontWeight,
        ),

      )
    );
  }
  void notifNoAction(_scaffoldKey,BuildContext context,String value,param) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: textQ(value, 12, Colors.white, FontWeight.bold, TextAlign.center),
      backgroundColor: param=='failed' ? Colors.redAccent : ThaibahColour.primary2,
      duration: Duration(seconds: 3),
    ));
    return;
  }
  void notifWithAction(_scaffoldKey,BuildContext context,String value,param,label,Function callback) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: textQ(value, 12, Colors.white, FontWeight.bold, TextAlign.center),
      action: SnackBarAction(
        textColor: Colors.white,
        label:label,
        onPressed:callback(),
      ),
      backgroundColor: param=='failed' ? Colors.redAccent : Colors.greenAccent,
      duration: Duration(seconds: 3),
    ));
    return;
  }
  Future getDeviceId() async{
    OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
    var settings = {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.promptBeforeOpeningPushUrl: true
    };
    OneSignal.shared.init(ApiService().deviceId, iOSSettings: settings);
    var status = await OneSignal.shared.getPermissionSubscriptionState();
    String onesignalUserId = status.subscriptionStatus.userId;
    return onesignalUserId;
  }
  Future<bool> cekVersion() async {

    var res = await ConfigProvider().cekVersion();
    if(res is Checker){
      Checker results = res;
      var versionCode = results.result.versionCode;
      print("##################################### $versionCode ###########################");
      if(versionCode != ApiService().versionCode){
        return true;
      }
    }
    return false;
  }
  Future<bool> cekStatusMember() async {
    var res = await ConfigProvider().cekVersion();
    if(res is Checker){
      Checker results = res;
      var statusMember = results.result.statusMember;
      if(statusMember == 0){
        return true;
      }
    }
    return false;
  }
  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }
  Future getImageFile(ImageSource source) async {
    var image = await ImagePicker.pickImage(source: source);
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Thaibah Cropper Image',
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

    return result;


  }
  Future getDataUser(param) async{
    int id;
    String idServer='';
    String name='';
    String address='';
    String email='';
    String picture='';
    String cover='';
    String socketId='';
    String kdUnique='';
    String token='';
    String phone='';
    String pin='';
    String referral='';
    String status='0';
    String ktp='';
    String statusOnBoarding='0';
    String statusExitApp='1';
    String statusLevel='0';
    String warna1='';
    String warna2='';
    // String latitude='';
    // String longitude='';
    String isStatus='';
    final dbHelper = DbHelper.instance;
    final allRows = await dbHelper.queryAllRows();
    print("TABLE USER $allRows");
    allRows.forEach((row){
      id = row['id'];
      idServer = row['id_server'];
      name = row['name'];
      address = row['address'];
      email = row['email'];
      picture = row['picture'];
      cover = row['cover'];
      socketId = row['socket_id'];
      kdUnique = row['kd_unique'];
      token = row['token'];
      phone = row['phone'];
      pin = row['pin'];
      referral = row['referral'];
      status = row['status'];
      ktp = row['ktp'];
      statusOnBoarding = row['status_on_boarding'];
      statusExitApp = row['status_exit_app'];
      statusLevel = row['status_level'];
      warna1 = row['warna1'];
      warna2 = row['warna2'];
      // latitude = row['latitude'];
      // longitude = row['longitude'];
      isStatus = row['isStatus'];

    });
    if(param=='id'){return id;}
    if(param=='idServer'){return idServer;}
    if(param=='name'){return name;}
    if(param=='address'){return address;}
    if(param=='email'){return email;}
    if(param=='picture'){return picture;}
    if(param=='cover'){return cover;}
    if(param=='socketId'){return socketId;}
    if(param=='kdUnique'){return kdUnique;}
    if(param=='token'){return token;}
    if(param=='phone'){return phone;}
    if(param=='pin'){return pin;}
    if(param=='referral'){return referral;}
    if(param=='status'){return status;}
    if(param=='ktp'){return ktp;}
    if(param=='statusOnBoarding'){return statusOnBoarding;}
    if(param=='statusExitApp'){return statusExitApp;}
    if(param=='statusLevel'){return statusLevel;}
    if(param=='warna1'){return warna1;}
    if(param=='warna2'){return warna2;}
    // if(param=='latitude'){return latitude;}
    // if(param=='longitude'){return longitude;}
    if(param=='isStatus'){return isStatus;}
  }
  Future<bool> checker() async{
    var cekMember = await ConfigProvider().checkerMember();
    if(cekMember is CheckerMember){
      CheckerMember ceking = cekMember;
      if(ceking.status == 'success'){
        print("######################### STATUS CODE CHECK MEMBER ${ceking.status} ###########################");
        if(ceking.result.statusMember == 0){
          final dbHelper = DbHelper.instance;
          await dbHelper.deleteAll();
          return true;
        }
      }else{
        GagalHitProvider().fetchRequest('home','kondisi = STATUS FAILED');
        print("######################### STATUS CODE CHECK MEMBER ${ceking.status} ###########################");
      }
    }else{
      GagalHitProvider().fetchRequest('home','kondisi = ERROR');
      print("######################### CHECK MEMBER ERROR  ###########################");
    }
    return false;
  }

}

