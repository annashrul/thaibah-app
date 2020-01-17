import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:thaibah/config/user_repo.dart';

class PinScreen extends StatefulWidget {
  final Function(BuildContext context, bool isTrue) callback;
  PinScreen({this.callback});

  @override
  PinScreenState createState() => new PinScreenState();
}

class PinScreenState extends State<PinScreen> {

  @override
  void initState() {
    super.initState();
  }
  final userRepository = UserRepository();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.keyboard_backspace,color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
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
        title: new Text("Keamanan", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
      ),
      key: _scaffoldKey,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 30),
              Image.asset(
                'assets/images/verify.png',
                height: MediaQuery.of(context).size.height / 3,
                fit: BoxFit.fitHeight,
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Masukan Pin',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22,fontFamily: 'Rubik'),textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
                  child: Builder(
                    builder: (context) => Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Center(

                        child: pinInput(),
                      ),
                    ),
                  )
              ),

            ],
          ),
        ),
      ),
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
//            onClear: () => _scaffoldKey.currentState.r,
            actionButtonsEnabled: false,
            clearInput: true,
            clearButtonIcon: Icon(Icons.backspace),
          ),
        ),
      ),
    );
  }

  Future _check(String txtPin, BuildContext context) async {
    int herPin = await userRepository.getPin();
    print("PIN: $herPin");
    if (int.parse(txtPin) == herPin) {
      widget.callback(context, true);
    } else {
      widget.callback(context, false);
    }

  }



}
