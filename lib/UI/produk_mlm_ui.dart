
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thaibah/Constants/constants.dart';
import 'loginPhone.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:thaibah/Model/MLM/listCartModel.dart';
import 'package:thaibah/Model/productMlmSuplemenModel.dart';
import 'package:thaibah/UI/component/keranjang.dart';
import 'package:thaibah/bloc/productMlmBloc.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:thaibah/resources/gagalHitProvider.dart';
import 'package:thaibah/resources/productMlmSuplemenProvider.dart';

import 'Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'Widgets/loadMoreQ.dart';
import 'Widgets/skeletonFrame.dart';
import 'package:http/http.dart' as http;
import 'package:thaibah/UI/Widgets/tutorialClearData.dart';

class ProdukMlmUI extends StatefulWidget {


  @override
  _ProdukMlmUIState createState() => _ProdukMlmUIState();
}

class _ProdukMlmUIState extends State<ProdukMlmUI> with SingleTickerProviderStateMixin  {
  final GlobalKey<RefreshIndicatorState> _refresh = GlobalKey<RefreshIndicatorState>();
  bool isExpanded = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  double _height;
  double _width;
  bool isLoading = false;
  int inc = 0;
  int total = 0;
  final userRepository = UserRepository();
  String versionCode = '';
  bool versi = false;
  final _bloc = ProductMlmSuplemenBloc();
  bool retry=false;
  ProductMlmSuplemenModel productMlmSuplemenModel;
  bool moreThenOne = false;
  int counterHit =0;
  Future addCart(var id, var harga, var qty, var weight) async{
    setState(() {});
    var res = await ProductMlmSuplemenProvider().addProduct(id,harga,qty,weight);
    if(res.status == 'success'){
      countCart();
      UserRepository().notifNoAction(scaffoldKey, context,"Produk Berhasil Dimasukan Ke Keranjang","success");
//      return showInSnackBar("Produk Berhasil Dimasukan Ke Keranjang");
    }else{
      Navigator.pop(context);
      UserRepository().notifNoAction(scaffoldKey, context,res.msg,"failed");

//      return showInSnackBar(res.msg);
    }
  }
  Future<void> countCart() async{
    var res = await ProductMlmSuplemenProvider().fetchListCart();
    if(res is ListCartModel){
      ListCartModel results = res;
      if(results.status == 'success'){
        setState(() {});
        total = res.result.jumlah;
      }
    }else{
      setState(() {
        total = 0;
      });
    }
  }

  int perpage = 10;
  void load() {
    print("load $perpage");
    setState(() {isLoading = false;});

    loadData(1,perpage);
    print(perpage);
  }
  Future<void> refresh() async {
    Timer(Duration(seconds: 1), () {
      setState(() {
        isLoading = true;
      });
    });
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    load();
  }
  Future<bool> _loadMore() async {
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    setState(() {
      perpage = perpage += 10;
    });
    loadData(1,perpage);
    print(perpage);
    return true;
  }
  bool modeUpdate = false;



  Future loadData(var page, var limit) async{
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    final token = await userRepository.getDataUser('token');
    try{
      final jsonString = await http.get(
          ApiService().baseUrl+'product/mlm?page=$page&limit=$limit&category=suplemen',
          headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
      ).timeout(Duration(seconds: ApiService().timerActivity));
      if (jsonString.statusCode == 200) {
        final jsonResponse = json.decode(jsonString.body);
        productMlmSuplemenModel = new ProductMlmSuplemenModel.fromJson(jsonResponse);
        setState(() {
          isLoading = false;retry = false;
        });
      } else {
        throw Exception('Failed to load photos');
      }
    }catch(e){
      setState(() {
        isLoading = false;retry = true;
      });
      GagalHitProvider().fetchRequest('produk','brand = ${androidInfo.brand}, device = ${androidInfo.device}, model = ${androidInfo.model}');
    }

  }

  Color warna1;
  Color warna2;
  String statusLevel ='0';
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
    super.initState();
    countCart();
    loadTheme();
    print('####################### aktif ############################');
    versi = true;
    loadData(1,perpage);
    isLoading=true;
    moreThenOne=false;
    print("###################### $mounted ###########################");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false)..init(context);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[
                statusLevel!='0'?warna1:ThaibahColour.primary1,
                statusLevel!='0'?warna2:ThaibahColour.primary2
              ],
            ),
          ),
        ),

        actions: <Widget>[
          new Stack(
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  if(total!=0){
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => Keranjang()
                      ),
                    ).whenComplete(countCart);
//                    Navigator.of(context).push(new MaterialPageRoute(builder: (_) => Keranjang())).whenComplete(countCart);
                  }
                },
                child: Container(
                  margin:EdgeInsets.only(top:10.0),
                  child: SvgPicture.asset(
                    ApiService().assetsLocal+"Icon_Utama_Produk_abu.svg",
                    height: ScreenUtilQ.getInstance().setHeight(60),
                    width: ScreenUtilQ.getInstance().setWidth(60),
                    color: Colors.white,
                  ),
                ),

              ),

              total != 0 ?new Positioned(
                right: 5,
                top: 11,
                child: new Container(
                  padding: EdgeInsets.all(2),
                  decoration: new BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(minWidth: 14, minHeight: 14,),
                  child: Text('$total', style: TextStyle(color: Colors.white, fontSize: ScreenUtilQ.getInstance().setSp(24),fontFamily:ThaibahFont().fontQ), textAlign: TextAlign.center,),
                ),
              ):Container()
            ],
          ),
        ],
        centerTitle: false,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: new Text("Produk Kami", style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(60),color:Colors.white,fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ)),
      ),
      body: buildContent(context)
    );
  }

  Widget buildContent(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false);
    return  isLoading ? _loading() :  productMlmSuplemenModel.result.data.length > 0 ? RefreshIndicator(
      child: Padding(
          padding: const EdgeInsets.only(top:20.0,left:5.0,right:5.0,bottom:5.0),
          child: LoadMoreQ(
            child: ListView.builder(
              key: PageStorageKey<String>('some-list-key'),
              primary: false,
              physics: ScrollPhysics(),
              itemCount: productMlmSuplemenModel.result.data.length,
              itemBuilder: (context, index) {
                return  GestureDetector(
                  onTap: (){
                    PageStorage.of(context).writeState(context, 'Data saved', identifier: ValueKey("KEY-PAGE"));
                    if(productMlmSuplemenModel.result.data[index].qty != 0){
                      addCart(productMlmSuplemenModel.result.data[index].id,int.parse(productMlmSuplemenModel.result.data[index].totalPrice),"1",productMlmSuplemenModel.result.data[index].weight.toString());
                    }else{
                      print('gagal');
                    }
                  },
                  child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
                      child: new Column(
                        children: <Widget>[
                          new Stack(
                            children: <Widget>[
                              new Center(
                                child: Container(
                                  width:MediaQuery.of(context).size.width/1,
                                  height:MediaQuery.of(context).size.height/2,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        topRight: Radius.circular( 10.0)
                                    ),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: productMlmSuplemenModel.result.data[index].picture,
                                    placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator(strokeWidth:10,valueColor: new AlwaysStoppedAnimation<Color>(ThaibahColour.primary1)),
                                    ),
                                    errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                                    imageBuilder: (context, imageProvider) => Container(
                                      decoration: BoxDecoration(
                                        borderRadius: new BorderRadius.only(
                                            topLeft: Radius.circular(10.0),
                                            topRight: Radius.circular( 10.0)
                                        ),
                                        color: Colors.grey,
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
//                                  child: Image.network(snapshot.data.result.data[index].picture),
                                ),
                              ),
                            ],
                          ),
                          new Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: new Column(
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 10,
                                          child: Container(
                                            padding: EdgeInsets.all(5),
                                            child: Row(
                                              children: <Widget>[
                                                Text(productMlmSuplemenModel.result.data[index].title,style: TextStyle(color: Colors.green,fontFamily:ThaibahFont().fontQ,fontSize:ScreenUtilQ.getInstance().setSp(40),fontWeight: FontWeight.bold),),
                                                SizedBox(width: 5.0),
                                                productMlmSuplemenModel.result.data[index].isplatinum == 1 ?
                                                Container(
                                                  padding: EdgeInsets.all(2),
                                                  decoration: new BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius: BorderRadius.circular(6),
                                                  ),
                                                  constraints: BoxConstraints(
                                                    minWidth: ScreenUtilQ.getInstance().setWidth(40),
                                                    minHeight: 14,
                                                  ),
                                                  child: Text("PRODUK PLATINUM",style: TextStyle(color: Colors.white,fontFamily:ThaibahFont().fontQ,fontSize:ScreenUtilQ.getInstance().setSp(34),fontWeight: FontWeight.bold),),
                                                ) : Container()
                                              ],
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      child: Html(data: "Sisa : "+ productMlmSuplemenModel.result.data[index].qty.toString(), defaultTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,fontFamily:ThaibahFont().fontQ),),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      child: Html(data:"Harga : "+ productMlmSuplemenModel.result.data[index].satuan+"/${productMlmSuplemenModel.result.data[index].satuanBarang}", defaultTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize:14, fontFamily:ThaibahFont().fontQ),),
                                    ),
                                    productMlmSuplemenModel.result.data[index].isplatinum == 1 ?
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.all(5),
                                          child: Html(data:"Detail Produk Platinum", defaultTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize:14,fontFamily:ThaibahFont().fontQ),),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(3),
                                          child: Html(
                                            data: productMlmSuplemenModel.result.data[index].detail,
                                            defaultTextStyle: TextStyle(fontSize: 12,fontFamily:ThaibahFont().fontQ),
                                          ),
                                        )
                                      ],
                                    )
                                        : Container(),
                                    Container(
                                      padding: EdgeInsets.all(3),
                                      child: Html(
                                        data:productMlmSuplemenModel.result.data[index].descriptions,
                                        defaultTextStyle: TextStyle(fontFamily:ThaibahFont().fontQ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 7,
                                            child: Container(
                                              padding: EdgeInsets.all(5),
                                              // decoration: BoxDecoration(color: Styles.primaryColor),
                                              child: Text('',style: TextStyle(color: Colors.black54)),
                                            ),
                                          ),
                                          SizedBox(width: 5,),

                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              // padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(color:statusLevel!='0'?warna2:ThaibahColour.primary2),
                                                child: Align(
                                                    alignment: Alignment.center,
                                                    child: FlatButton(
                                                      child: Icon(Icons.add_shopping_cart, color: Colors.white),
                                                      onPressed: () {
                                                        if(productMlmSuplemenModel.result.data[index].qty != 0){
                                                          addCart(productMlmSuplemenModel.result.data[index].id,int.parse(productMlmSuplemenModel.result.data[index].totalPrice),"1",productMlmSuplemenModel.result.data[index].weight.toString());
//                                                        widget.onItemInteraction(snapshot.data.result.data[index].id,int.parse(snapshot.data.result.data[index].totalPrice),"1",snapshot.data.result.data[index].weight.toString());
                                                        }else{

                                                        }
                                                      },
                                                    )
                                                )
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                );
              },
            ),
            onLoadMore: _loadMore,
            whenEmptyLoad: true,
            delegate: DefaultLoadMoreDelegate(),
            textBuilder: DefaultLoadMoreTextBuilder.english,
            isFinish: productMlmSuplemenModel.result.data.length < perpage,
          )
      ),
      onRefresh: refresh,
      key: _refresh,
    ) : Container(child: Center(child:Text('Tidak Ada Data')));

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
                  color: statusLevel!='0'?warna1:ThaibahColour.primary1, // button color
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
  Widget _loading(){
    return Padding(
        padding: const EdgeInsets.only(top:20.0,left:5.0,right:5.0,bottom:5.0),
        child: ListView.builder(
          primary: false,
          physics: ScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            return new GestureDetector(
                onTap: (){
                },
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
                  child: new Column(
                    children: <Widget>[
                      new Stack(
                        children: <Widget>[
                          //new Center(child: new CircularProgressIndicator()),
                          new Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular( 10.0)
                              ),
                              child: SkeletonFrame(width: double.infinity,height: MediaQuery.of(context).size.height/2),
                            ),
                          ),
                        ],
                      ),
                      new Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: new Column(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 7,
                                      child: Container(
                                        padding: EdgeInsets.only(top:5.0),
                                        // decoration: BoxDecoration(color: Styles.primaryColor),
                                        child: SkeletonFrame(width:MediaQuery.of(context).size.height/2,height: 16.0),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                          padding: EdgeInsets.only(top:5.0),
                                          // decoration: BoxDecoration(color: Styles.primaryColor),
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: SkeletonFrame(width:MediaQuery.of(context).size.height/2,height: 16.0),
                                          )
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.only(top:5.0),
                                  child: SkeletonFrame(width:MediaQuery.of(context).size.height/2,height: 16.0),
                                ),

                                Container(
                                  padding: EdgeInsets.only(top:5.0),
                                  child: SkeletonFrame(width:MediaQuery.of(context).size.height/1,height: 100.0),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
            );
          },
        )
    );
  }
}
