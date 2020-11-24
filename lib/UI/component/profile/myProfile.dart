import 'dart:async';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/profileModel.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/component/auth/loginPhone.dart';
import 'package:thaibah/UI/component/dataDiri/indexMember.dart';
import 'package:thaibah/UI/component/donasi/history_donasi.dart';
import 'package:thaibah/UI/component/profile/privacyPolicy.dart';
import 'package:thaibah/UI/component/profile/profileBisnis.dart';
import 'package:thaibah/UI/component/sosmed/myFeed.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:thaibah/resources/gagalHitProvider.dart';
import 'package:thaibah/resources/memberProvider.dart';
import 'package:thaibah/resources/profileProvider.dart';
import 'package:thaibah/DBHELPER/userDBHelper.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final formatter = new NumberFormat("#,###");
  final userRepository = UserRepository();
  bool isLoading=false, modeUpdate=false,moreThenOne=false,isLoadingShare=false;
  int retry=0;
  int jumlahJaringan=0,counterHit=0;
  String name='',picture='',qr='',kdReferral='',saldo='',rawSaldo='',saldoMain='',saldoBonus='',saldoVoucher='',saldoPlatinum='',downline='';
  String kaki1='',kaki2='',kaki3='',privacyPolicy='',omsetJaringan='',id='';
  String sponsor='';
  int levelPlatinum=0;
  bool isTimeout=false;
  Future<void> loadData() async{
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    var res = await ProfileProvider().fetchProfile();
    if(res is ProfileModel){
      setState(() {
        isTimeout=false;
        isLoading = false;
        var result = res.result;
        jumlahJaringan=result.jumlahJaringan;
        name=result.name;picture=result.picture;qr=result.qr;kdReferral=result.kdReferral;saldo=result.saldo;
        rawSaldo=result.rawSaldo;
        saldoMain=result.rawSaldo;
        saldoBonus=result.saldoBonusRaw;
        saldoVoucher=result.saldoVoucher;
        saldoPlatinum=result.saldoPlatinum;
        downline=result.downline;kaki1=result.kaki1;kaki2=result.kaki2;kaki3=result.kaki3;privacyPolicy=result.privacy;omsetJaringan=result.omsetJaringan;
        id=result.id;
        sponsor=result.sponsor;
        levelPlatinum = result.levelPlatinumRaw;
      });
    }
    else{
      GagalHitProvider().fetchRequest('profile','brand = ${androidInfo.brand}, device = ${androidInfo.device}, model = ${androidInfo.model}');
      setState(() {
        isLoading = false;
        isTimeout=true;
      });
    }

  }
  @override
  void initState() {
    super.initState();
    loadData();
    isLoading=true;
    moreThenOne = false;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar:UserRepository().appBarNoButton(context,"Profile",<Widget>[]),
      body: isLoading?UserRepository().loadingWidget():isTimeout?UserRepository().requestTimeOut((){
        setState(() {
          retry+=1;
          isLoading=true;
        });
        loadData();
      }):Container(
        padding: EdgeInsets.only(top:10.0),
        color: Colors.white,
        child: LiquidPullToRefresh(
            color: ThaibahColour.primary2,
            backgroundColor:Colors.white,
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                customlistDetails(context,'Bisnis','halaman dashboard bisnis anda',ProfileBisnis(
                  id:id,
                  qr:qr,
                  name:name,
                  kdReferral: kdReferral,
                  picture: picture,
                  privacyPolicy: privacyPolicy,
                  saldoUtama: saldoMain,
                  saldoBonus: saldoBonus,
                  saldoVoucher: saldoVoucher,
                  saldoPlatinum: saldoPlatinum,
                  jmlJaringan: jumlahJaringan.toString(),
                  omsetJaringan: omsetJaringan.toString(),
                  downline: downline.toString(),
                  sponsor: sponsor,
                  membership: saldoBonus,
                  levelRoyalti: saldoBonus,
                  levelPlatinum: levelPlatinum,
                ), (){}),
                customlistDetails(context,'Donasi','halaman riwayat donasi anda',HistoryDonasi(),(){}),
                customlistDetails(context,'Sosial Media','posting kegiatan anda',MyFeed(),(){}),
                customlistDetails(context,'Kebijakan & Privasi','kebijakan & privasi aplikasi thaibah',PrivacyPolicy(privasi: privacyPolicy),(){}),
                customlistDetails(context,'Pengaturan','atur identitas dan keamanan akun anda',IndexMember(id: id),(){}),
                customlistDetails(context,'Keluar','keluar aplikasi thaibah',null,()async{
                  UserRepository().loadingQ(context);
                  var res = await MemberProvider().logout();
                  if(res.status == 'success'){
                    setState(() {
                      Navigator.pop(context);
                    });
                    final dbHelper = DbHelper.instance;
                    final id = await userRepository.getDataUser('id');
                    Map<String, dynamic> row = {
                      DbHelper.columnId   : id,
                      DbHelper.columnStatus : '0',
                      DbHelper.columnStatusOnBoarding  : "1",
                      DbHelper.columnStatusExitApp  : "1"
                    };
                    await dbHelper.update(row);
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.clear();
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPhone()), (Route<dynamic> route) => false);
                  }else{
                    setState(() {
                      Navigator.pop(context);
                    });
                    UserRepository().notifNoAction(scaffoldKey, context, res.msg,"failed");
                  }


                })
              ],
            ),
            onRefresh: refresh
        ),
      ),

    );
  }

  Future<void> refresh() async {
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    setState(() {
      isLoading = true;
    });

    loadData();
  }
}




customlistDetails(BuildContext context,String title,String desc,Widget xWidget,Function callback) {
  return InkWell(
    onTap: () async {
      title == 'Keluar' ? UserRepository().notifAlertQ(context,"warning", "Keluar", "Anda Yakin Akan Keluar Aplikasi ?", "Oke", "Batal", callback, (){
        Navigator.of(context).pop();
      }): Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => xWidget));
    },
    child: ListTile(
      title: UserRepository().textQ(title,14,Colors.black.withOpacity(0.7),FontWeight.bold,TextAlign.left),
      subtitle: UserRepository().textQ(desc,12,Colors.grey.withOpacity(0.7),FontWeight.normal,TextAlign.left),
      leading: CircleAvatar(
        backgroundColor: Colors.grey[200],
        child: Center(child: Icon(Icons.list, color: Color(0xFF333333))),
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
    ),
  );
}
