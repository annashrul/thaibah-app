import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rich_alert/rich_alert.dart';
import 'package:thaibah/UI/Homepage/index.dart';
import 'package:thaibah/UI/Widgets/pin_screen.dart';
import 'package:thaibah/bloc/transferBloc.dart';
import 'package:thaibah/config/style.dart';
import 'package:thaibah/config/user_repo.dart';

class DetailTransfer extends StatefulWidget {
  final String nominal;
  final String fee_charge;
  final String total_bayar;
  final String penerima;
  final String picture;
  final String referralpenerima;
  final String pesan;
  final bool statusFee;
  DetailTransfer({this.nominal,this.fee_charge,this.total_bayar,this.penerima,this.picture,this.referralpenerima,this.pesan,this.statusFee});
  @override
  _DetailTransferState createState() => _DetailTransferState();
}

class _DetailTransferState extends State<DetailTransfer> {

  var scaffoldKey = GlobalKey<ScaffoldState>();

  final userRepository = UserRepository();
  final formatter = new NumberFormat("#,###");

  @override
  /*Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.90),
      body: detail(context),
      bottomNavigationBar: bottomButton(context),
    );
  }*/
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          headline: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          subhead: TextStyle(color: Colors.white54),
          body1: TextStyle(color: Colors.white54),
          subtitle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
          title: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
      ),
      home: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.keyboard_backspace,color: Colors.white),
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => DashboardThreePage()), (Route<dynamic> route) => false),
              ),
              centerTitle: false,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: <Color>[
                      Color(0xFF116240),
                      Color(0xFF30cc23)
                    ],
                  ),
                ),
              ),
              elevation: 1.0,
              automaticallyImplyLeading: true,
              title: new Text("Konfirmasi Transfer", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
            ),
//        backgroundColor: Color(0xff6d04ff),
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFF116240),
                    Color(0xFF30cc23)
                  ],
                ),
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(11.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Row(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black45,
                                      blurRadius: 3.0,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    widget.picture
                                  ),
                                ),
                              ),
                              SizedBox(width: 5.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                   widget.penerima,
                                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),
                                  ),
                                  Text(
                                    widget.referralpenerima,
                                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),


                        SizedBox(height: 5),

                        SizedBox(height: 11),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white30,
                            borderRadius: BorderRadius.circular(35),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FlatButton(
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.sync_problem,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      "Lanjutkan",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                                onPressed: () {
                                  print('tap');
                                  _pinBottomSheet(context);
                                },
                              ),

                            ],
                          ),
                        ),
                        SizedBox(height: 11),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(11.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(31),
                                  topRight: Radius.circular(31),
                                ),
                                color: Colors.white,
                              ),
                              child: Column(
                                children: <Widget>[

                                  Expanded(
                                    child: ListView(
                                      children: <Widget>[
                                        bottomCard(Icon(Icons.input,color: Colors.white),'Nominal Transfer','Rp. '+formatter.format(int.parse(widget.nominal))),
                                        widget.statusFee == true ? bottomCard(Icon(Icons.error,color: Colors.white),'Biaya Transfer','Rp. '+formatter.format(int.parse(widget.fee_charge))):Container(),
                                        bottomCard(Icon(Icons.note,color: Colors.white),'Catatan',widget.pesan!=''?widget.pesan:'-'),
                                        Divider(),
                                        SizedBox(height: 25.0),
                                        Row(
                                          children: <Widget>[
                                            SizedBox(width: 5.0),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Center(
                                                    child: Text("SUMBER DANA YANG DIGUNAKAN DARI SALDO UTAMA ANDA",style: TextStyle(color: Colors.black45,fontWeight: FontWeight.bold,fontFamily: 'Rubik',fontSize: 20.0,letterSpacing: 5.0),textAlign: TextAlign.center,),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        )

                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )

        ),
      ),
    );
  }

  Widget bottomCard(Widget iconQ, String title, String desc){
    return Row(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(11),
          margin: EdgeInsets.all(11),
          decoration: BoxDecoration(
            borderRadius:
            BorderRadius.circular(15),
            color: Colors.green,
          ),
          child: iconQ,
        ),
        SizedBox(width: 5.0),
        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: <Widget>[
              Text("$title",style: TextStyle(color: Colors.black87,fontFamily: 'Rubik')),
              Text("$desc",style: TextStyle(color: Colors.black45,fontFamily: 'Rubik')),
            ],
          ),
        ),
      ],
    );
  }


  Widget detail(BuildContext context){
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: new Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Text("Konfirmasi Transfer", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
              ),
              Divider(),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: 100.0,
                    width: 100.0,
                    child: CachedNetworkImage(
                      imageUrl: widget.picture,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))),
                      ),
                      errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Column(children: <Widget>[
                    Text(widget.penerima),
                    Text(widget.referralpenerima),
                  ],)
                ],),
              SizedBox(height: 15,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Sumber"),
                  Text("SALDO UTAMA"),
                ],),
              SizedBox(height: 15,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Pesan"),
                  Text("${widget.pesan!=''?widget.pesan:'-'}"),
                ],),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                      flex: 5,
                      child: Column(
                        children: <Widget>[
                          Text("Nominal Transfer"),
                          Text("Biaya Transfer"),
                        ],
                      )
                  ),
                  Expanded(
                      flex: 5,
                      child: Column(
                        children: <Widget>[
                          Text(formatter.format(int.parse(widget.nominal))),
                          Text(formatter.format(int.parse(widget.fee_charge))),
                        ],
                      )
                  )
                ],),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomButton(context){
    return Container(
      height: kBottomNavigationBarHeight,
      child: RaisedButton(
        color: Styles.primaryColor,
        onPressed: (){
          _pinBottomSheet(context);
        },
        child: Text("Bayar", style: TextStyle(color: Colors.white)))
    );
  }

  Future<void> _pinBottomSheet(context) async {
//    showDialog(
//        context: context,
//        builder: (BuildContext bc){
//          return PinScreen(callback: _callBackPin);
//        }
//    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PinScreen(callback: _callBackPin),
      ),
    );
  }

  _callBackPin(BuildContext context,bool isTrue) async{
    if(isTrue){
      setState(() {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: LinearProgressIndicator(),
            );
          },
        );

      });
      var res = await transferBloc.fetchTransfer(widget.nominal, widget.referralpenerima,"");

      if(res.status=="success"){
        setState(() {
          Navigator.pop(context);
        });
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return RichAlertDialog(
                alertTitle: richTitle("Transaksi Berhasil"),
                alertSubtitle: richSubtitle("Terimakasih Telah Melakukan Transaksi"),
                alertType: RichAlertType.SUCCESS,
                actions: <Widget>[
                  FlatButton(
                    child: Text("Kembali"),
                    onPressed: (){
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => DashboardThreePage()), (Route<dynamic> route) => false);
                    },
                  ),
                ],
              );
            }
        );
      }else{
        setState(() {
          Navigator.pop(context);
        });
        Navigator.pop(context);
        scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(res.msg)));
      }
    }else{
      setState(() {
        Navigator.pop(context);
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Pin Salah!"),
            content: new Text("Masukan pin yang sesuai."),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>
                    DetailTransfer(
                        nominal: widget.nominal,
                        fee_charge: widget.fee_charge,
                        total_bayar: widget.total_bayar,
                        penerima: widget.penerima,
                        picture: widget.picture,
                        referralpenerima: widget.referralpenerima,
                        pesan:widget.pesan
                    )
                  ), (Route<dynamic> route) => false);
                },
              ),
            ],
          );
        },
      );
    }
  }


}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.keyboard_backspace,color: Colors.white),
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_context)=>DashboardThreePage())),
          ),
          centerTitle: false,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[
                  Color(0xFF116240),
                  Color(0xFF30cc23)
                ],
              ),
            ),
          ),
          elevation: 1.0,
          automaticallyImplyLeading: true,
          title: new Text("Konfirmasi Transfer", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
        ),
//        backgroundColor: Color(0xff6d04ff),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFF116240),
                Color(0xFF30cc23)
              ],
            ),
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(11.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black45,
                                  blurRadius: 3.0,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                "https://media.licdn.com/dms/image/C4D03AQHHbvYjNiR49w/profile-displayphoto-shrink_100_100/0?e=1567641600&v=beta&t=qjaJ_J2KnplnSfMMVypYfN--eza4YyFpIKd8N6FF24A",
                              ),
                            ),
                          ),
                          SizedBox(width: 5.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Hey, Amazigh!",
                                style: Theme.of(context).textTheme.title,
                              ),
                              Text(
                                "Let's plan your bright future!",
                                style: Theme.of(context).textTheme.subhead,
                              ),
                            ],
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(
                              Icons.notifications,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 11),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "01234567-890",
                                style: Theme.of(context).textTheme.headline,
                              ),
                              SizedBox(height: 5.0),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 9.0, vertical: 5.0),
                                color: Colors.white12,
                                child: Text("Policy Number"),
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black45,
                                  blurRadius: 3.0,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(5.0),
                            child: IconButton(
                              icon: Icon(
                                Icons.compare_arrows,
                              ),
                              onPressed: () {},
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Divider(
                      color: Colors.white54,
                    ),
                    SizedBox(height: 5),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "\$1,231",
                            style: Theme.of(context).textTheme.subtitle,
                          ),
                          Text(
                            "\$3,231",
                            style: Theme.of(context).textTheme.subtitle,
                          ),
                          Text(
                            "05/07/2019",
                            style: Theme.of(context).textTheme.subtitle,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 11),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white30,
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.call_received,
                                  color: Colors.white,
                                ),
                                Text(
                                  "View My Policy",
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                            onPressed: () {},
                          ),
                          Container(
                            height: 30,
                            width: 1,
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: Colors.white54,
                                  width: 3.0,
                                ),
                              ),
                            ),
                          ),
                          FlatButton(
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "Make a Payment",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Icon(
                                  Icons.call_made,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 11),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(31),
                      topRight: Radius.circular(31),
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(11.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            MyIconButton(
                              buttonText: "Car",
                              buttonIcon: Icons.airport_shuttle,
                            ),
                            MyIconButton(
                              buttonText: "Hospital",
                              buttonIcon: Icons.local_hospital,
                            ),
                            MyIconButton(
                              buttonText: "Gym & Sport",
                              buttonIcon: Icons.fitness_center,
                            ),
                            MyIconButton(
                              buttonText: "Hotel",
                              buttonIcon: Icons.hotel,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(11.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(31),
                              topRight: Radius.circular(31),
                            ),
                            color: Colors.grey[200],
                          ),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Notifications: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  FlatButton(
                                    child: Text(
                                      "See All",
                                      style: TextStyle(
                                        color: Color(0xff6d04ff),
                                      ),
                                    ),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: 3,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Row(
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.all(11),
                                          margin: EdgeInsets.all(11),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(15),
                                            color: Color(0xff6d04ff),
                                          ),
                                          child: Icon(
                                            Icons.email,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "Email Verification",
                                                style: TextStyle(
                                                    color: Colors.black87),
                                              ),
                                              Text(
                                                "Lorem ipsum dolor sit amet consectetur adipisicing elit. Natus, enim hic.",
                                                style: TextStyle(
                                                    color: Colors.black45),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        )

      ),
    );
  }
}

class MyIconButton extends StatelessWidget {
  final String buttonText;
  final IconData buttonIcon;
  const MyIconButton({Key key, this.buttonText, this.buttonIcon})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.all(7.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[400],
                  blurRadius: 3.0,
                ),
              ],
            ),
            child: Icon(
              buttonIcon,
              color: Color(0xff6d04ff),
            ),
          ),
          Text(
            buttonText,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}