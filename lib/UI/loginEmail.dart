import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thaibah/UI/loginPhone.dart';
import 'package:thaibah/UI/regist_ui.dart';
import 'package:thaibah/bloc/authBloc.dart';

import 'Widgets/SCREENUTIL/ScreenUtilQ.dart';

class LoginEmail extends StatefulWidget {
  @override
  _LoginEmailState createState() => _LoginEmailState();
}

class _LoginEmailState extends State<LoginEmail> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool alreadyLogin = false;
  bool _secureText = true;
  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }
  Future<bool> getLoginStatus() async{
    final prefs = await SharedPreferences.getInstance();
    bool loginStatus = prefs.getBool('login') ?? false;
    print('login status $loginStatus');
    return loginStatus;
  }

  signIn(String email, password) async {
    var res = await authEmailBloc.fetchAuthEmail(email, password);
    print(res.status);
    if(res.status=="success"){
      print(res.result.email);
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _isLoading = false;
      });
      alreadyLogin = true;
      prefs.setBool('login', alreadyLogin);
      prefs.setString('id', res.result.id);
      prefs.setString('name', res.result.name);
      prefs.setString('address', res.result.address.toString());
      prefs.setString('email', res.result.email.toString());
      prefs.setString('picture', res.result.picture.toString());
      prefs.setString('cover',res.result.cover.toString());
      prefs.setString('socketid', res.result.socketid.toString());
      prefs.setString('kd_referral', res.result.kdReferral.toString());
      prefs.setString('kd_unique',res.result.kdUnique.toString());
      prefs.setString('token', res.result.token.toString());
      prefs.setString('pin', res.result.pin.toString());
//      Navigator.push(
//          context,
//          MaterialPageRoute(
//            builder: (context) => BottomTabsControl(),
//          )
//      );
    }else{
      setState(() {
        _isLoading = false;
      });
      return showInSnackBar(res.msg);
    }

  }
  void showInSnackBar(String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            fontFamily: "Rubik"),
      ),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 3),
    ));
  }
  @override
  Widget build(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(width: 750, height: 1334, allowFontScaling: true);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Image.asset("assets/images/image_01.png"),
              ),
              Expanded(
                child: Container(),
              ),
              Image.asset("assets/images/image_02.png")
            ],
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 60.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Image.asset(
                        "assets/images/logoOnBoardTI.png",
                        width: ScreenUtilQ.getInstance().setWidth(150),
                        height: ScreenUtilQ.getInstance().setHeight(150),
                      ),
                    ],
                  ),
                  SizedBox(height: ScreenUtilQ.getInstance().setHeight(180)),
                  Container(
                    width: double.infinity,
                    height: ScreenUtilQ.getInstance().setHeight(470),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(0.0),
                        boxShadow: [
                          BoxShadow(color: Colors.black12,offset: Offset(0.0, 0.0),blurRadius: 0.0),
                          BoxShadow(color: Colors.black12,offset: Offset(0.0, -5.0),blurRadius: 10.0),
                        ]
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Masuk",style: TextStyle(fontSize: ScreenUtilQ.getInstance().setSp(45),fontFamily: "Rubik",letterSpacing: .6,fontWeight: FontWeight.bold)),
                          SizedBox(height: ScreenUtilQ.getInstance().setHeight(30)),
                          Text("Email",style: TextStyle(fontFamily: "Rubik",fontSize: ScreenUtilQ.getInstance().setSp(26))),
                          TextField(
                            textInputAction: TextInputAction.next,
                            controller: emailController,
                            decoration: InputDecoration(hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(height: ScreenUtilQ.getInstance().setHeight(30)),
                          Text("Password",style: TextStyle(fontFamily: "Rubik",fontSize: ScreenUtilQ.getInstance().setSp(26))),
                          TextField(
                            textInputAction: TextInputAction.done,
                            obscureText: _secureText,
                            controller: passwordController,
                            decoration: InputDecoration(
                                suffixIcon: IconButton(onPressed: showHide,icon: Icon(_secureText? Icons.visibility_off: Icons.visibility)),
                                hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)
                            ),
//                            suffixIcon: IconButton(onPressed: showHide,icon: Icon(_secureText? Icons.visibility_off: Icons.visibility)),
                            keyboardType: TextInputType.visiblePassword,
                          ),
                          SizedBox(height: ScreenUtilQ.getInstance().setHeight(35)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LoginPhone(),
                                      ),
                                    );
                                  },
                                  child: Text("Masuk Menggunakan No Handphone ?",style: TextStyle(fontWeight:FontWeight.bold,color: const Color(0xFF116240),fontFamily: "Rubik",fontSize: ScreenUtilQ.getInstance().setSp(20)),)

                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtilQ.getInstance().setHeight(40)),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          width: ScreenUtilQ.getInstance().setWidth(330),
                          height: ScreenUtilQ.getInstance().setHeight(100),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [Color(0xFF116240),Color(0xFF30CC23)]),
                              borderRadius: BorderRadius.circular(6.0),
                              boxShadow: [BoxShadow(color: Color(0xFF6078ea).withOpacity(.3),offset: Offset(0.0, 8.0),blurRadius: 8.0)]
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                RegExp regex = new RegExp(pattern);

                                if (emailController.text == "") {
                                  return showInSnackBar("Email Harus Disi");
                                }else if(passwordController.text == ""){
                                  return showInSnackBar("Password Harus Disi");
                                }  else {
                                  if(!regex.hasMatch(emailController.text)){
                                    return showInSnackBar("Email Tidak Valid");
                                  }else{
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    signIn(emailController.text,passwordController.text);
                                  }

                                }
                              },
                              child: _isLoading?Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white))):Center(
                                child: Text("Masuk",style: TextStyle(color: Colors.white,fontFamily: "Rubik",fontSize: 16,fontWeight: FontWeight.bold,letterSpacing: 1.0)),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: ScreenUtilQ.getInstance().setHeight(40)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      horizontalLine(),
                      Text("Atau",style: TextStyle(fontSize: 16.0, fontFamily: "Rubik", fontWeight: FontWeight.bold)),
                      horizontalLine()
                    ],
                  ),
                  SizedBox(height: ScreenUtilQ.getInstance().setHeight(30)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Buat Akun ? ",style: TextStyle(fontFamily: "Rubik"),),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Regist(),
                            ),
                          );
                        },
                        child: Text("Daftar disini",style: TextStyle(color: Color(0xFF5d74e3),fontFamily: "Poppins-Bold")),
                      )
                    ],
                  )

                ],
              ),
            ),
          )
        ],
      ),

    );
  }



  Widget horizontalLine() => Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    child: Container(
      width: ScreenUtilQ.getInstance().setWidth(120),
      height: 1.0,
      color: Colors.black26.withOpacity(.2),
    ),
  );
}
