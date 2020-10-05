import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/component/History/buktiTransfer.dart';
import 'package:thaibah/UI/component/home/widget_index.dart';
import 'package:thaibah/bloc/depositManual/listAvailableBankBloc.dart';
import 'package:thaibah/config/richAlertDialogQ.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:thaibah/resources/donasi/donasiProvider.dart';

class ScreenSuccessDonasi extends StatefulWidget {
  final String amount,raw_amount,unique,bank_name,atas_nama,no_rekening,picture,id_deposit,bank_code;
  ScreenSuccessDonasi({
    this.amount,this.raw_amount,this.unique,this.bank_name,this.atas_nama,this.no_rekening,this.picture,this.id_deposit,this.bank_code
  });
  @override
  _ScreenSuccessDonasiState createState() => _ScreenSuccessDonasiState();
}

class _ScreenSuccessDonasiState extends State<ScreenSuccessDonasi> {
  double _height;
  double _width;
  File _image;
  Future<File> file;
  String base64Image;
  File tmpFile;
  bool isLoading = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  String fileName;
  var hari  = DateFormat.d().format( DateTime.now().add(Duration(days: 3)));
  var bulan = DateFormat.M().format( DateTime.now());
  var tahun = DateFormat.y().format( DateTime.now());

  Future upload(File img) async{
    UserRepository().loadingQ(context);
    if(img != null){
      fileName = img.path.split("/").last;
      var type = fileName.split('.');
      base64Image = 'data:image/' + type[1] + ';base64,' + base64Encode(img.readAsBytesSync());
    }else{
      base64Image = "";
    }
    var res = await CheckoutDonasiProvider().uploadBuktiTransferDonasi(widget.id_deposit,base64Image);
    if(res is General){
      General result = res;
      if(result.status=='success'){
        setState(() {Navigator.pop(context);});
        UserRepository().notifAlertQ(context, "success","Donasi Anda Akan Segera Di Proses", "Harap Menuggu Paling Lambat 15 Menit","Kembali","Beranda", ()=>Navigator.pop(context), (){
          Navigator.of(context).pushAndRemoveUntil(CupertinoPageRoute(builder: (BuildContext context) => WidgetIndex(param: '',)), (Route<dynamic> route) => false);
        });
      }
      else{

        setState(() {Navigator.pop(context);});
        UserRepository().notifNoAction(scaffoldKey, context,result.msg,"failed");
      }
    }
  }

  void _lainnyaModalBottomSheet(context){
    showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
          padding: const EdgeInsets.symmetric(horizontal:18,vertical: 10 ),
          child: WidgetUploadBuktiTransferDonasi(callback: (File img){
            upload(img);
          }),
        )
    );
  }


  final userRepository = UserRepository();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    final key = new GlobalKey<ScaffoldState>();
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false)..init(context);

    return Scaffold(
        key: key,
        appBar: UserRepository().appBarWithButton(context, "Transaksi Berhasil",(){
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => WidgetIndex(param: '',)), (Route<dynamic> route) => false);
        },<Widget>[]),


        resizeToAvoidBottomInset: false,

        body: Scrollbar(
            child: ListView(
              children: <Widget>[
                SizedBox(height: 30),
                Image.asset(
                  'assets/images/checkmark.gif',
                  height: MediaQuery.of(context).size.height / 7,
                  fit: BoxFit.fitHeight,
                ),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 8.0),
                  child: UserRepository().textQ("Silahkan transfer tepat sebesar :", 12, Colors.black, FontWeight.bold, TextAlign.left),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color:Colors.green,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 10.0),
                      child:UserRepository().textQ(widget.amount, 18, Colors.white, FontWeight.bold, TextAlign.center),
                    )
                ),


                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 8.0),
                  child: UserRepository().textQ("Pembayaran dapat dilakukan ke rekening berikut : ", 12, Colors.black, FontWeight.bold, TextAlign.left),
                ),
                Card(
                  elevation: 0.0,
                  margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  child: Container(
                    padding: new EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                      leading: Container(
                        width: 90.0,
                        height: 50.0,
                        padding: EdgeInsets.all(10),
                        child: CircleAvatar(
                          minRadius: 150,
                          maxRadius: 150,
                          child: CachedNetworkImage(
                            imageUrl: widget.picture,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))),
                            ),
                            errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                borderRadius: new BorderRadius.circular(0.0),
                                color: Colors.white,
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // title: Text(widget.atas_nama,style: TextStyle(fontSize:  ScreenUtilQ.getInstance().setSp(30),fontFamily: 'Rubik',fontWeight: FontWeight.bold),),
                      title:UserRepository().textQ(widget.atas_nama, 12, Colors.black, FontWeight.bold,TextAlign.left),
                      subtitle: GestureDetector(
                        onTap: () {
                          Clipboard.setData(new ClipboardData(text: widget.no_rekening));
                          key.currentState.showSnackBar(new SnackBar(content:UserRepository().textQ("no rekening berhasil disalin", 12, Colors.white, FontWeight.bold,TextAlign.center)));
                        },
                        child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              UserRepository().textQ(widget.no_rekening, 12, Colors.black.withOpacity(0.7), FontWeight.bold,TextAlign.left),
                              SizedBox(width: 5),
                              Icon(Icons.content_copy, color: Colors.black, size: 15,),
                            ]
                        ),

                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color:Colors.green,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 10.0),
                      child: Text(
                        'VERIFIKASI PENERIMAAN TRANSFER ANDA AKAN DIPROSES SELAMA 5-10 MENIT',
                        style: TextStyle(fontSize:  ScreenUtilQ.getInstance().setSp(30),fontFamily:ThaibahFont().fontQ,color:Colors.white,fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    )
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 8.0),
                    child: Container(
                      color: const Color(0xffF4F7FA),
                      padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 8.0),
                      child: RichText(
                        text: TextSpan(
                            text: 'Anda Dapat Melakukan Transfer Menggunakan ATM, Mobile Banking atau SMS Banking Dengan Memasukan Kode Bank',
                            style: TextStyle(fontSize: 12,fontFamily:ThaibahFont().fontQ,color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(text: ' ${widget.bank_name} ${widget.bank_code}',style: TextStyle(color:ThaibahColour.primary2, fontSize: 12,fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ)),
                              TextSpan(text: ' Di Depan No Rekening Atas Nama',style: TextStyle(fontSize: 12,fontFamily:ThaibahFont().fontQ)),
                              TextSpan(text: ' ${widget.atas_nama}',style: TextStyle(color: ThaibahColour.primary2, fontSize: 12,fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ)),
                            ]
                        ),
                      ),
                    )
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 8.0),
                    child: Container(
                      color: const Color(0xffF4F7FA),
                      padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 8.0),
                      child: Text(
                        'mohon transfer tepat hingga 3 digit terakhir agar tidak menghambat proses verifikasi',
                        style: TextStyle(fontSize:  ScreenUtilQ.getInstance().setSp(30),fontFamily:ThaibahFont().fontQ),
                        textAlign: TextAlign.left,
                      ),
                    )
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 10.0),
                    child: Container(
                      color: const Color(0xffF4F7FA),
                      padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 10.0),
                      child: Text(
                        'Pastikan anda transfer sebelum tanggal $hari-$bulan-$tahun 23:00 WIB atau transaksi anda otomatis dibatalkan oleh sistem. jika sudah melakukan transfer segera upload bukti transfer disini atau di halaman riwayat topup',
                        style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),fontFamily: ThaibahFont().fontQ),
                        textAlign: TextAlign.left,
                      ),
                    )
                ),
              ],
            )
        ),
        bottomNavigationBar: _bottomNavBarBeli(context)
    );
  }

  Widget _bottomNavBarBeli(BuildContext context){
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false)..init(context);

    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Container(
        width:double.infinity,
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        height: kBottomNavigationBarHeight,
        child: UserRepository().buttonQ(context,(){_lainnyaModalBottomSheet(context);},"Saya sudah transfer"),
      ),
    );
  }
}

class WidgetUploadBuktiTransferDonasi extends StatefulWidget {
  final Function(File bukti) callback;
  WidgetUploadBuktiTransferDonasi({this.callback});
  @override
  _WidgetUploadBuktiTransferDonasiState createState() => _WidgetUploadBuktiTransferDonasiState();
}

class _WidgetUploadBuktiTransferDonasiState extends State<WidgetUploadBuktiTransferDonasi> {
  File _image;
  Future<File> file;
  String base64Image;
  File tmpFile;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height:10.0),
        Container(
          padding: EdgeInsets.only(top:10.0),
          width: 50,
          height: 10.0,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius:  BorderRadius.circular(10.0),
          ),
        ),
        InkWell(
          onTap: () async {
            try{
              var image = await ImagePicker.pickImage(
                source: ImageSource.gallery,
                maxHeight: 800, maxWidth: 600,
              );
              setState(() {
                _image = image;
              });
            }catch(e){
              print(e);
            }
          },
          child: ListTile(
            contentPadding: EdgeInsets.all(0.0),
            title: UserRepository().textQ("Upload Bukti Transfer",12,Colors.grey,FontWeight.bold,TextAlign.left),
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Center(child: Icon(Icons.satellite, color: Colors.grey)),
            ),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey,size: 20,),
          ),
        ),
        Divider(),
        Container(
          padding:EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:  BorderRadius.circular(100.0),
          ),
          child: _image == null ?Image.network("http://lequytong.com/Content/Images/no-image-02.png"): new Image.file(_image,width: 1300,height: MediaQuery.of(context).size.height/2,filterQuality: FilterQuality.high,),
        ),
        UserRepository().buttonQ(context, ()=>widget.callback(_image),'Simpan')
      ],
    );


  }
}

