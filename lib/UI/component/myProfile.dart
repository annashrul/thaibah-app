import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/profileModel.dart';
import 'package:thaibah/UI/Homepage/beranda.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/alertq.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/Widgets/tutorialClearData.dart';
import 'package:thaibah/UI/component/History/historyDeposit.dart';
import 'package:thaibah/UI/component/History/historyPenarikan.dart';
import 'package:thaibah/UI/component/History/indexHistory.dart';
import 'package:thaibah/UI/component/dataDiri/indexMember.dart';
import 'package:thaibah/UI/component/donasi/history_donasi.dart';
import 'package:thaibah/UI/component/penarikan.dart';
import 'package:thaibah/UI/component/penukaranBonus.dart';
import 'package:thaibah/UI/component/privacyPolicy.dart';
import 'package:thaibah/UI/component/sosmed/myFeed.dart';
import 'package:thaibah/UI/jaringan_ui.dart';
import 'package:thaibah/UI/loginPhone.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/richAlertDialogQ.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:thaibah/resources/gagalHitProvider.dart';
import 'package:thaibah/resources/memberProvider.dart';
import 'package:thaibah/resources/profileProvider.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';
import 'dart:ui' as ui;
import 'package:thaibah/DBHELPER/userDBHelper.dart';

import '../history_ui.dart';
import '../saldo_ui.dart';
import '../transfer_ui.dart';
import '../upgradePlatinum.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final formatter = new NumberFormat("#,###");
  final userRepository = UserRepository();
  bool isLoading=false, modeUpdate=false,moreThenOne=false,isLoadingShare=false,retry=false;
  int jumlahJaringan=0,counterHit=0;
  String name='',picture='',qr='',kdReferral='',saldo='',rawSaldo='',saldoMain='',saldoBonus='',saldoVoucher='',saldoPlatinum='',downline='';
  String kaki1='',kaki2='',kaki3='',privacyPolicy='',omsetJaringan='',id='';
  String sponsor='';
  int levelPlatinum=0;
  Future<void> loadData() async{
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    var res = await ProfileProvider().fetchProfile();
    if(res is ProfileModel){
      setState(() {
        isLoading = false; retry = false;
        var result = res.result;
        jumlahJaringan=result.jumlahJaringan;
        name=result.name;picture=result.picture;qr=result.qr;kdReferral=result.kdReferral;saldo=result.saldo;
        rawSaldo=result.rawSaldo;
        saldoMain=result.saldoMain;
        saldoBonus=result.saldoBonus;
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
        isLoading = false;retry = true;
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
      appBar:AppBar(
        elevation: 1.0,
        backgroundColor: Colors.white, // status bar color
        brightness: Brightness.light,
        title: isLoading?ListTile(
          contentPadding: EdgeInsets.only(top:10,bottom:10),
          title: SkeletonFrame(width: 50,height:15),
          subtitle: SkeletonFrame(width: 50,height:15),
          leading: CircleAvatar(
              radius:20.0,
              backgroundImage: NetworkImage(ApiService().noImage)
          ),

        ):ListTile(
          contentPadding: EdgeInsets.only(top:10,bottom:10),
          title: UserRepository().textQ(name,14,Colors.black.withOpacity(0.7),FontWeight.bold,TextAlign.left),
          subtitle: GestureDetector(
            child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  UserRepository().textQ(kdReferral,12,Colors.grey.withOpacity(0.7),FontWeight.bold,TextAlign.left),
                  SizedBox(width: 5),
                  Icon(Icons.content_copy, color: Colors.grey, size: 15,),
                ]
            ),
            onTap: () {
              Clipboard.setData(new ClipboardData(text: '$kdReferral'));
              UserRepository().notifNoAction(scaffoldKey, context,"Kode Referral Berhasil Disalin","success");
            },
          ),
          leading: CircleAvatar(
              radius:20.0,
              backgroundImage: NetworkImage(picture)
          ),
        ),
      ),
      body: isLoading?UserRepository().loadingWidget():Container(
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



class ProfileBisnis extends StatefulWidget {
  final String id;
  final String qr;
  final String name;
  final String kdReferral;
  final String picture;
  final String privacyPolicy;
  final String saldoUtama;
  final String saldoBonus;
  final String saldoVoucher;
  final String saldoPlatinum;
  final String jmlJaringan;
  final String omsetJaringan;
  final String downline;
  final String sponsor;
  final String membership;
  final String levelRoyalti;
  final int levelPlatinum;
  ProfileBisnis({
    this.id,
    this.qr,
    this.name,
    this.kdReferral,
    this.picture,
    this.privacyPolicy,
    this.saldoUtama,
    this.saldoBonus,
    this.saldoVoucher,
    this.saldoPlatinum,
    this.jmlJaringan,
    this.omsetJaringan,
    this.downline,
    this.sponsor,
    this.membership,
    this.levelRoyalti,
    this.levelPlatinum,
  });
  @override
  _ProfileBisnisState createState() => _ProfileBisnisState();
}

class _ProfileBisnisState extends State<ProfileBisnis> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final formatter = new NumberFormat("#,###");

  var titleJaringan=['Omset Jaringan','Jumlah Jaringan','Downline','Sponsor'];
  var valueJaringan=[];
  var titleSaldo=['Saldo Utama','Saldo Bonus','Saldo Voucher','Saldo Platinum'];
  var valueSaldo=[];
  loadArr(){
    valueJaringan.add(widget.omsetJaringan);
    valueJaringan.add("${widget.jmlJaringan} Orang");
    valueJaringan.add("${widget.downline} Orang");
    valueJaringan.add("${widget.sponsor} Orang");

    valueSaldo.add(widget.saldoUtama);
    valueSaldo.add(widget.saldoBonus);
    valueSaldo.add(widget.saldoVoucher);
    valueSaldo.add(widget.saldoPlatinum);

  }
  Future share() async{
    Timer(Duration(seconds: 1), () async {
      Navigator.of(context).pop(false);
      await WcFlutterShare.share(
          sharePopupTitle: 'Thaibah Share Link',
          subject: 'Thaibah Share Link',
          text: "https://thaibah.com/signup/${widget.kdReferral}\n\n\nAyo Buruan daftar",
          mimeType: 'text/plain'
      );
    });

  }
  Future<void> refresh() async {
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadArr();


    print(titleJaringan);
  }
  final _scrollController1 = ScrollController();
  final _scrollController2 = ScrollController();

  @override
  Widget build(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar:AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white, // status bar color
        brightness: Brightness.light,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: ListTile(
          contentPadding: EdgeInsets.only(left:0.0),
          title:GestureDetector(
           child:  Row(
             children: [
               UserRepository().textQ(widget.name,14,Colors.black.withOpacity(0.7),FontWeight.bold,TextAlign.left),
               SizedBox(width: 5),
               widget.levelPlatinum == 0 ?Container(
                   padding: EdgeInsets.all(2),
                   decoration: new BoxDecoration(
                     color: Colors.red,
                     borderRadius: BorderRadius.circular(6),
                   ),
                   constraints: BoxConstraints(
                     minWidth: 14,
                     minHeight: 14,
                   ),
                   child:UserRepository().textQ('upgrade',10,Colors.white,FontWeight.bold,TextAlign.center),
               ):(widget.levelPlatinum == 1 ? Container(child:Image.asset("${ApiService().assetsLocal}thaibah_platinum.png",height:20.0,width:20.0)) :
               Container(child:Image.asset("${ApiService().assetsLocal}thaibah_platinum_vvip.png",height:20.0,width:20.0)))
               // Image.asset("${ApiService().assetsLocal}thaibah_platinum.png",height:20.0,width:20.0)
               // Icon(Icons.content_copy, color: Colors.grey, size: 15,),
             ],
           ),
          ),
          subtitle: GestureDetector(
            child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  UserRepository().textQ(widget.kdReferral,12,Colors.grey.withOpacity(0.7),FontWeight.bold,TextAlign.left),
                  SizedBox(width: 5),
                  Icon(Icons.content_copy, color: Colors.grey, size: 15,),
                ]
            ),
            onTap: () {
              Clipboard.setData(new ClipboardData(text: '${widget.name}'));
              UserRepository().notifNoAction(scaffoldKey, context,"Kode Referral Berhasil Disalin","success");
            },
          ),
          leading: CircleAvatar(
              radius:20.0,
              backgroundImage: NetworkImage(widget.picture)
          ),
          trailing: InkWell(
            child: Icon(Icons.share,color: Colors.grey),
            onTap: (){
              UserRepository().loadingQ(context);
              share();
            },
          ),
        ),

        actions: [
          InkWell(
            child: Container(
              padding: EdgeInsets.only(right:10),
              child: Icon(Icons.settings_overscan,color: Colors.grey),
            ),
            onTap:(){
              _lainnyaModalBottomSheet(context,'barcode',widget.qr);
            }
          ),
        ],//
      ),
      body:Column(
        children: <Widget>[
          Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Container(
                height:MediaQuery.of(context).size.height/3,width: double.infinity,
                decoration: BoxDecoration(
                  color:Colors.grey[200],
                  borderRadius: BorderRadius.only(
                    topLeft:Radius.circular(20.0),
                    topRight:Radius.circular(20.0),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left:10.0,right:10.0,top:10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height/13,
                      child: Scrollbar(
                        controller: _scrollController1,
                        isAlwaysShown: true,
                        child: ListView.builder(
                          padding: EdgeInsets.only(bottom:5.0),
                          physics: ClampingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: titleJaringan.length,
                          itemBuilder: (BuildContext context, int index) {
                            double wdt;
                            wdt = titleJaringan.length-1 == index?0.0:1.5;

                            return CardSaldo(
                              title: titleJaringan[index],
                              desc: valueJaringan[index],
                              wdt: wdt,
                            );
                          },
                        )
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                      child: SizedBox(
                        child: Container(height: 1.0,color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 10),
                    Scrollbar(
                      controller: _scrollController1,
                      isAlwaysShown: true,
                      child: SizedBox(
                          height: MediaQuery.of(context).size.height/13,
                        child: ListView.builder(
                          padding: EdgeInsets.only(bottom:5.0),
                          physics: ClampingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: titleSaldo.length,
                          itemBuilder: (BuildContext context, int index) {
                            double wdt;
                            wdt = titleJaringan.length-1 == index?0.0:1.5;
                            return CardSaldo(
                              title: titleSaldo[index],
                              desc: valueSaldo[index],
                              wdt: wdt,
                            );
                          },
                        )
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top:10,bottom:10,left:0,right:10),
                        height: MediaQuery.of(context).size.height/1.6,
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child:ListView(
                        padding: EdgeInsets.only(bottom:5.0),
                        physics: ClampingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: [
                          customlistDetails(context,'Jaringan Saya','lihat siapa saja jaringan di bawah anda', JaringanUI(kdReferral: widget.kdReferral,name:widget.name),(){}),
                          customlistDetails(context,'Top Up','lakukan top up untuk belanja produk', SaldoUI(saldo: widget.saldoUtama,name:widget.name),(){}),
                          customlistDetails(context,'Transfer','halaman transfer saldo anda', TransferUI(saldo:widget.saldoUtama,qr:widget.qr),(){}),
                          customlistDetails(context,'Penarikan','halaman penarikan saldo anda', Penarikan(saldoMain: widget.saldoUtama),(){}),
                          customlistDetails(context,'Penukaran Bonus','penukaran saldo bonus ke saldo utama', PenukaranBonus(saldo: widget.saldoUtama, saldoBonus:widget.saldoBonus),(){}),
                          customlistDetails(context,'Riwayat Transaksi','lihat riwayat transaksi anda', HistoryUI(page: 'home'),(){}),
                          customlistDetails(context,'Riwayat Penarikan','lihat riwayat penarikan anda', HistoryPenarikan(),(){}),
                          customlistDetails(context,'Riwayat Pembelian','lihat riwayat pembelian produk anda',IndexHistory(),(){}),
                          customlistDetails(context,'Riwayat Top Up','lihat riwayat top up anda',HistoryDeposit(saldo: widget.saldoUtama),(){}),
                        ],
                      )
                    ),
                  ],
                ),
              )
            ],
          ),

        ],
      ),
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
                          Text("Scan Kode Referral Anda ..", style: TextStyle(color: Colors.black,fontSize: 14,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold),),
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

customlistDetails(BuildContext context,String title,String desc,Widget xWidget,Function callback) {
  return InkWell(
    onTap: () async {
      title == 'Keluar' ? showDialog(
          context: context,
          builder: (BuildContext context) {
            return RichAlertDialogQ(
              alertTitle: richTitle("Keluar"),
              alertSubtitle: richSubtitle("Anda Yakin Akan Keluar Aplikasi ?"),
              alertType: RichAlertType.WARNING,
              actions: <Widget>[
                Container(
                  color: Colors.green,
                  child: FlatButton(
                    child: Text("YA", style: TextStyle(color: Colors.white,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold),),
                    onPressed:callback
                  ),
                ),
                SizedBox(width: 10.0),
                Container(
                  color:Colors.red,
                  child: FlatButton(
                    child: Text("TIDAK", style: TextStyle(color: Colors.white,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold),),
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                  ),
                )
              ],
            );
          }
      ) : Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => xWidget));
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
