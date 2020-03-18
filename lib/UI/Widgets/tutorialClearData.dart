import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:thaibah/Model/pageViewModel.dart';
import 'package:thaibah/UI/splash/introViews.dart';

class TutorialClearData extends StatefulWidget {
  @override
  _TutorialClearDataState createState() => _TutorialClearDataState();
}

class _TutorialClearDataState extends State<TutorialClearData> {
  @override
  Widget build(BuildContext context) {
    return buildContent(context);
  }
  final pages = [
    PageViewModel(
      pageColor: Colors.white,
      bubbleBackgroundColor: Colors.indigo,
      title: Container(),
      body: Column(
        children: <Widget>[
          Text('Langkah Pertama',style: TextStyle(fontFamily: 'Rubik',color: Color(0xFF116240),fontWeight: FontWeight.bold)),
          Text('Tekan Tombol Pengaturan Yang Berada Di Slide Akhir',style: TextStyle(fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
        ],
      ),
      mainImage: Image.network(
        'https://pngimage.net/wp-content/uploads/2018/06/one-png-5.png',
        width: 285.0,
        alignment: Alignment.center,
      ),
      textStyle: TextStyle(color: Colors.black,fontFamily: 'Rubik',),
    ),
    PageViewModel(
      pageColor: Colors.white,
      bubbleBackgroundColor: Colors.indigo,
      title: Container(),
      body: Column(
        children: <Widget>[
          Text('Langkah Kedua',style: TextStyle(fontFamily: 'Rubik',color: Color(0xFF116240),fontWeight: FontWeight.bold)),
          Text('Pilih Penyimpanan atau Storage ( pada beberapa hp tahap ini tidak diperlukan, maka langsung saja ke tahap berikutnya )',style: TextStyle(fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
        ],
      ),
      mainImage: Image.network(
        'https://i.ya-webdesign.com/images/number-2-png-7.png',
        width: 285.0,
        alignment: Alignment.center,
      ),
      textStyle: TextStyle(color: Colors.black,fontFamily: 'Rubik',),
    ),
    PageViewModel(
      pageColor: Colors.white,
      bubbleBackgroundColor: Colors.indigo,
      title: Container(),
      body: Column(
        children: <Widget>[
          Text('Langkah Ketiga',style: TextStyle(fontFamily: 'Rubik',color: Color(0xFF116240),fontWeight: FontWeight.bold)),
          Text('Tekan Tombol Hapus Data atau Clear Data',style: TextStyle(fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
        ],
      ),
      mainImage: Image.network(
        'https://cdn.onlinewebfonts.com/svg/img_29115.png',
        width: 285.0,
        alignment: Alignment.center,
      ),
      textStyle: TextStyle(color: Colors.black,fontFamily: 'Rubik',),
    ),
    PageViewModel(
      pageColor: Colors.white,
      bubbleBackgroundColor: Colors.indigo,
      title: Container(),
      body: Column(
        children: <Widget>[
          Text('Langkah Keempat',style: TextStyle(fontFamily: 'Rubik',color: Color(0xFF116240),fontWeight: FontWeight.bold)),
          Text('Setalah Langkah 1 sampai 3 Beres, Masuk Kembali Ke Aplikasi Thaibah',style: TextStyle(fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
        ],
      ),
      mainImage: Image.network(
        'https://cdn.onlinewebfonts.com/svg/img_29008.png',
        width: 285.0,
        alignment: Alignment.center,
      ),
      textStyle: TextStyle(color: Colors.black,fontFamily: 'Rubik',),
    ),
    PageViewModel(
      pageColor: Colors.white,
      bubbleBackgroundColor: Colors.indigo,
      title: Container(),
      body: Column(
        children: <Widget>[
          Text('Sentuh Tulisan Pengaturan Di pojok kanan bawah layar anda',style: TextStyle(fontFamily: 'Rubik',color: Color(0xFF116240),fontWeight: FontWeight.bold)),
        ],
      ),
      mainImage: Image.asset(
        'assets/images/diterima.png',
        width: 285.0,
        alignment: Alignment.center,
      ),
      textStyle: TextStyle(color: Colors.black,fontFamily: 'Rubik',),
    ),
  ];

  Widget buildContent(BuildContext context){
    return new Scaffold(
        body: Stack(
          children: <Widget>[
            IntroViewsFlutter(
              pages,
              onTapDoneButton: (){
                AppSettings.openAppSettings();
//                go();
              },
              showSkipButton: false,
              doneText: Text("PENGATURAN",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
              pageButtonsColor: Colors.green,
              pageButtonTextStyles: new TextStyle(
                  fontSize: 12.0,
                  fontFamily: "Rubik",
                  fontWeight: FontWeight.bold
              ),
            ),
            Positioned(
                top: 20.0,
                left: MediaQuery.of(context).size.width/2 - 50,
                child: Image.asset('assets/images/logoOnBoardTI.png', width: 100,)
            )
          ],
        )
    );
  }
}
