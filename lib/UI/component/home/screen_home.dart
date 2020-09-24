import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:location/location.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/islamic/imsakiyahModel.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/component/home/widget_donasi.dart';
import 'package:thaibah/UI/component/home/widget_top_slider.dart';
import 'package:thaibah/bloc/islamic/prayerBloc.dart';
import 'package:thaibah/config/user_repo.dart';

class ScreenHome extends StatefulWidget {
  @override
  _ScreenHomeState createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  final GlobalKey<RefreshIndicatorState> _refresh = GlobalKey<RefreshIndicatorState>();
  ScrollController _controller = new ScrollController();
  final userRepository = UserRepository();
  static String latitude = '';
  static String longitude = '';
  bool isLoading=false;
  Future<void> loadData() async {
    final lat = await userRepository.getDataUser('latitude');
    final lng = await userRepository.getDataUser('longitude');
    setState(() {
      latitude = lat;
      longitude = lng;
    });
    prayerBloc.fetchPrayerList(lng,lat);
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    setState(() {
      isLoading=false;
    });
    // prayerBloc.fetchPrayerList(widget.lng, widget.lat);
  }
  Future<void> refresh() async {
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    // loadData();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
    isLoading=true;
  }

  @override
  Widget build(BuildContext context) {
    return LiquidPullToRefresh(
      color: ThaibahColour.primary2,
      backgroundColor:Colors.white,
      key: _refresh,
      onRefresh: refresh,
      child: SingleChildScrollView(
        primary: true,
        scrollDirection: Axis.vertical,
        physics: ClampingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.0),
            WidgetTopSlider(),
            SizedBox(height: 10.0),
            cardSecondSection(context),
            SizedBox(height: 10.0),
            cardThreeSection(context),
            SizedBox(height: 15.0),
            lineSection(context),
            titleSection(context,"Donasi Terbaru $isLoading","Mari kita bantu mereka yang membutuhkan"),
            WidgetDonasi(),
            UserRepository().buttonQ(context, ThaibahColour.primary1,ThaibahColour.primary2,(){},false,"Lihat Semua"),
            lineSection(context),
            titleSection(context,"Artikel Untuk Kamu","Berita terbaru disekitar kitas"),
            cardSixSection(context),
            UserRepository().buttonQ(context, ThaibahColour.primary1,ThaibahColour.primary2,(){},false,"Lihat Semua"),
          ],
        ),
      ),
    );

  }
  Widget titleSection(BuildContext context,title,desc){
    return Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserRepository().textQ(title,14,Colors.black,FontWeight.bold,TextAlign.left),
            UserRepository().textQ(desc,12,Colors.grey,FontWeight.normal,TextAlign.left),
          ],
        )
    );
  }
  Widget lineSection(BuildContext context){
    return Container(
      color: Colors.grey[200],
      width: MediaQuery.of(context).size.width,
      height: 10.0,
    );
  }

  Widget cardSecondSection(BuildContext context){
    return IntrinsicHeight(
      child: Padding(
        padding: EdgeInsets.only(left: 10.0,right: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isLoading?Flexible(
              flex: 1,
              child: InkWell(
                onTap: (){},
                child: Card(
                  elevation: 0.50,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: SkeletonFrame(width: 100,height: 50),
                ),
              ),
              fit: FlexFit.tight,
            ):Flexible(
              flex: 1,
              child: InkWell(
                onTap: (){},
                child: Card(
                  elevation: 0.50,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    title:UserRepository().textQ("Hitung Zakat Anda",11,Colors.black,FontWeight.bold,TextAlign.left),
                    leading: CircleAvatar(
                        radius:20.0,
                        backgroundImage: AssetImage('assets/images/logoOnBoardTI.png')
                    ),
                    subtitle: UserRepository().textQ("#kalkulator zakat",12,Colors.grey,FontWeight.normal,TextAlign.left),

                  ),
                ),
              ),
              fit: FlexFit.tight,
            ),
            isLoading?Flexible(
              flex: 1,
              child: InkWell(
                onTap: (){},
                child: Card(
                  elevation: 0.50,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: SkeletonFrame(width: 100,height: 50),
                ),
              ),
              fit: FlexFit.tight,
            ):Flexible(
              flex: 1,
              child: InkWell(
                onTap: (){},
                child: Card(
                  elevation: 0.50,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    title:UserRepository().textQ("Hitung Zakat Anda",11,Colors.black,FontWeight.bold,TextAlign.left),
                    leading: CircleAvatar(
                        radius:20.0,
                        backgroundImage: AssetImage('assets/images/logoOnBoardTI.png')
                    ),
                    subtitle: UserRepository().textQ("#kalkulator zakat",12,Colors.grey,FontWeight.normal,TextAlign.left),

                  ),
                ),
              ),
              fit: FlexFit.tight,
            ),
          ],
        ),
      ),
    );
  }

  Widget cardThreeSection(BuildContext context) {
    return StreamBuilder(
        stream: prayerBloc.allPrayer,
        builder: (context, AsyncSnapshot<PrayerModel> snapshot) {
          if(snapshot.hasData){
            return Container(
              padding: EdgeInsets.only(left:15,right:15),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius:  BorderRadius.circular(10.0),
                  image: DecorationImage(
                      image: NetworkImage("https://dekdun.files.wordpress.com/2011/05/picture1.png"),
                      fit: BoxFit.cover
                  ),
                ),
                child: new Align(
                  child: new Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius:  BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 10.0),
                            UserRepository().textQ("Waktu Sholat Selanjutnya",12,Colors.white,FontWeight.bold,TextAlign.left),
                            SizedBox(height: 10.0),
                            UserRepository().textQ(snapshot.data.result.rawMaghrib,24,Colors.white,FontWeight.bold,TextAlign.left),
                            SizedBox(height: 10.0),
                            UserRepository().textQ("-1 Jam : 32 Menit menuju Ashar",12,Colors.white,FontWeight.bold,TextAlign.left),
                            SizedBox(height: 10.0),
                            Row(
                              children: [
                                Icon(Icons.place,color: Colors.white),
                                Container(
                                  width:  MediaQuery.of(context).size.width/1.7,
                                  child: UserRepository().textQ(snapshot.data.result.city,12,Colors.white,FontWeight.bold,TextAlign.left),
                                )
                              ],
                            )
                          ],
                        ),
                        new Column(
                          children: [
                            RaisedButton(
                                child: UserRepository().textQ("Doa Harian",12,Colors.white,FontWeight.bold,TextAlign.center),
                                onPressed: (){},
                                color: Colors.transparent,
                                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0), side: BorderSide(color: Colors.white))
                            ),
                            RaisedButton(
                                child: UserRepository().textQ("Arah Kiblat",12,Colors.white,FontWeight.bold,TextAlign.center),
                                onPressed: (){},
                                color: Colors.transparent,
                                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0), side: BorderSide(color: Colors.white))
                            )
                          ],
                        )
                      ],
                    ),

                    width: double.infinity,
                  ),

                ),
              ),
            );
          }else if(snapshot.hasError){
            return Text(snapshot.error.toString());
          }
          return Container(
            padding: EdgeInsets.only(left:15,right:15),
            child: SkeletonFrame(width: MediaQuery.of(context).size.width/1,height: 150),
          );
        }
    );

  }



  Widget cardSixSection(BuildContext context){
    return Padding(
      padding: EdgeInsets.only(left:5.0,right:5.0),
      child: ListView.builder(
          primary: true,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: 10,
          itemBuilder:(context,index){
            return InkWell(
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: new Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    new Hero(
                      tag: 'tagImage$index',
                      child:ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child:  new Image.network("https://dekdun.files.wordpress.com/2011/05/picture1.png", fit: BoxFit.cover)
                      ),
                      // child: new Image.network("https://dekdun.files.wordpress.com/2011/05/picture1.png", fit: BoxFit.cover),
                    ),
                    new Align(
                      child: new Container(
                        padding: const EdgeInsets.all(6.0),
                        child: new Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding:const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [Colors.green,Colors.green]),
                                  borderRadius: BorderRadius.circular(10.0),
                                  boxShadow: [BoxShadow(color: Color(0xFF6078ea).withOpacity(.3),offset: Offset(0.0, 8.0),blurRadius: 8.0)]
                              ),
                              child: UserRepository().textQ("Artikel $index",10,Colors.white,FontWeight.bold,TextAlign.center),
                            ),
                            SizedBox(height: 5.0),
                            new Html(data:"I'm not able to write a full answer at the moment", defaultTextStyle: new TextStyle(fontFamily: ThaibahFont().fontQ,color: Colors.white, fontWeight: FontWeight.bold, fontSize:14)),
                            Html(
                              data: "I'm not able to write a full answer at the moment but I'd advise you to look into using CustomPaint and the canvas. Using the canvas you can draw gradients & images to your heart's content and then apply filters",
                              defaultTextStyle: new TextStyle(color: Colors.white,fontFamily: ThaibahFont().fontQ, fontSize: 12.0) ,
                            )
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        width: double.infinity,
                      ),
                      alignment: Alignment.bottomCenter,
                    ),
                  ],
                ),
              ),
              onTap: (){},
            );
          }
      ),
    );
  }
}
