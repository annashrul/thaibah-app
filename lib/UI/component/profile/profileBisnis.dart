
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/cardSaldo.dart';
import 'package:thaibah/UI/component/History/mainHistoryTransaksi.dart';
import 'package:thaibah/UI/component/MLM/history_product.dart';
import 'package:thaibah/UI/component/MLM/jaringan_ui.dart';
import 'package:thaibah/UI/component/deposit/formDeposit.dart';
import 'package:thaibah/UI/component/deposit/historyDeposit.dart';
import 'package:thaibah/UI/component/penarikan/historyPenarikan.dart';
import 'package:thaibah/UI/component/penarikan/penarikan.dart';
import 'package:thaibah/UI/component/penukaran_bonus/penukaranBonus.dart';
import 'package:thaibah/UI/component/profile/myProfile.dart';
import 'package:thaibah/UI/component/transfer/transfer_ui.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

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

class _ProfileBisnisState extends State<ProfileBisnis>{
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
                    Scrollbar(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height/13,
                        child: ListView.builder(
                          // padding: EdgeInsets.only(bottom:5.0),
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
                        ),
                      )
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                      child: SizedBox(
                        child: Container(height: 1.0,color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 10),
                    Scrollbar(
                      child: SizedBox(
                          height: MediaQuery.of(context).size.height/13,
                          child: ListView.builder(
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
                      )
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
                            customlistDetails(context,'Deposit','lakukan deposit untuk belanja produk', FormDeposit(saldo: widget.saldoUtama,name:widget.name),(){}),
                            customlistDetails(context,'Transfer','halaman transfer saldo anda', TransferUI(saldo:widget.saldoUtama,qr:widget.qr),(){}),
                            customlistDetails(context,'Penarikan','halaman penarikan saldo anda', Penarikan(saldoMain: widget.saldoUtama),(){}),
                            customlistDetails(context,'Penukaran Bonus','penukaran saldo bonus ke saldo utama', PenukaranBonus(saldo: widget.saldoUtama, saldoBonus:widget.saldoBonus),(){}),
                            customlistDetails(context,'Riwayat Transaksi','lihat riwayat transaksi anda', MainHistoryTransaksi(page: 'home'),(){}),
                            customlistDetails(context,'Riwayat Penarikan','lihat riwayat penarikan anda', HistoryPenarikan(),(){}),
                            customlistDetails(context,'Riwayat Pembelian','lihat riwayat pembelian produk anda',HistoryProduct(),(){}),
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