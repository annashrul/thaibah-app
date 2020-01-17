import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/config/style.dart';

class DetailTagihan extends StatefulWidget {
  DetailTagihan({
    this.tagihan_id,this.code,this.product_name,this.type,this.phone,this.no_pelanggan,this.nama,
    this.periode,this.jumlah_tagihan,this.admin,this.jumlah_bayar,this.status
  });
  final String tagihan_id;
  final String code;
  final String product_name;
  final String type;
  final String phone;
  final String no_pelanggan;
  final String nama;
  final String periode;
  final int jumlah_tagihan;
  final int admin;
  final int jumlah_bayar;
  final String status;
  @override
  _DetailTagihanState createState() => _DetailTagihanState();
}

class _DetailTagihanState extends State<DetailTagihan> {
//  final int JumlahTagihan = widget.jumlah_tagihan;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.90),
      body: detail(context),
      bottomNavigationBar: bottomButton(context),
    );
  }


  Widget detail(BuildContext context){
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: new Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text("Detail Tagihan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
            ),
            Divider(),
            Row(
              children: <Widget>[
                Expanded(
                    flex: 3, // 20%
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Order No"),
                        Text("ID Pelanggan"),
                        Text("Code"),
                        Text("Type"),
                        Text("No Handphone"),
                        Text("No Pelanggan"),
                        Text("Nama Pelanggan"),
                        Text("Periode"),
                        Text("Jumlah Tagihan"),
                        Text("Admin"),
                        Text("Status"),
                      ],
                    )
                ),
                Expanded(
                    flex: 1, // 60%
                    child: Column(
                      children: <Widget>[
                        Text(":"),
                        Text(":"),
                        Text(":"),
                        Text(":"),
                        Text(":"),
                        Text(":"),
                        Text(":"),
                        Text(":"),
                        Text(":"),
                        Text(":"),
                        Text(":"),
                      ],
                    )
                ),
                Expanded(
                    flex: 5, // 20%
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(widget.tagihan_id),
                        Text(widget.code),
                        Text(widget.product_name),
                        Text(widget.type),
                        Text(widget.phone),
                        Text(widget.no_pelanggan),
                        Text(widget.nama),
                        Text(widget.periode),
                        Text(widget.jumlah_tagihan.toString()),
                        Text(widget.admin.toString()),
                        Text(widget.status),
                      ],
                    )
                ),
              ],
            ),
            SizedBox(height: 20,),
            Text(widget.jumlah_bayar.toString(), style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),)
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
          print("object");
          _pinModalBottomSheet(context);
        },
        child: Text("Bayar", style: TextStyle(color: Colors.white),),),);
  }

  void _pinModalBottomSheet(context){
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              // padding: EdgeInsets.only(left: 10, right: 10),
              //margin: EdgeInsets.only(top: 10),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text("Masukan PIN Anda"),
                      Divider(),
                      pinInput(),
                      // progressWidget()
                    ]
                )
            ),
          );
        }
    );
  }

  Widget pinInput() {
    return Builder(
      builder: (context) => Padding(
        padding: const EdgeInsets.all(5.0),
        child: Center(
          child: PinPut(
            fieldsCount: 6,
            isTextObscure: true,
            onSubmit: (String txtPin) => _check(txtPin, context),
            actionButtonsEnabled: false,
          ),
        ),
      ),
    );
  }

  Future _check(String txtPin, BuildContext context) async {

    if (txtPin == "123456") {
      // Navigator.of(context).pop();
      Navigator.of(context).popAndPushNamed(DETAIL_STATUS_PENDING_UI);
    } else {
      // setState(() {
      //     _apiCall = true;
      //   });
    }
  }
}
