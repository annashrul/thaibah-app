import 'package:flutter/material.dart';
class MainCompass extends StatefulWidget {
  @override
  _MainCompassState createState() => _MainCompassState();
}

class _MainCompassState extends State<MainCompass> {
  int _currentPage = 0;
  final _pages = <Widget>[
    Compass(),
//    Schedule(),
//    Settings()
  ];
  final _pageNames = <String>[
    'Kiblat',
    'Jadwal Sholat',
    'Pengaturan'
  ];
  PageStorageBucket _pageStorageBucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    return PageStorage(
      bucket: _pageStorageBucket,
      child: _pages[_currentPage],
    );
  }
}


class Compass extends StatefulWidget {

  @override
  _CompassState createState() => _CompassState();
}

class _CompassState extends State<Compass> with TickerProviderStateMixin {
//  double _directionDeg = 0,
//      _beforedeg = 0,
//      _kaabahX = 0,
//      _kaabahY = 0,
//      _headingAngleDeg = 294.22;
//  AnimationController _rotateController;
//  Animation rotateTween, rotateTweenInside;
//
//  double _degToRad(double deg) {
//    return deg * (Math.pi / 180.0);
//  }
//
//  double _getPosXKaabah(double angle, double rad) {
//    return cos(_degToRad(angle))*rad;
//  }
//
//  double _getPosYKaabah(double angle, double rad) {
//    return sin(_degToRad(angle))*rad;
//  }
//
//  @override
//  void initState() {
//    _headingAngleDeg -= 90;
//    _kaabahX = _getPosXKaabah(_headingAngleDeg, 1);
//    _kaabahY = _getPosYKaabah(_headingAngleDeg, 1);
//
//    print(_kaabahX);
//    print(_kaabahY);
//    _rotateController = AnimationController(
//      duration: Duration(milliseconds: 200),
//      vsync: this,
//    );
//
//    FlutterCompass.events.listen((double direction) {
//      setState(() {
//        _rotateController.stop();
//        _beforedeg = rotateTween.value;
//        _directionDeg = -((direction ?? 0)/360);
//        if ((_directionDeg - _beforedeg).abs() > ((_directionDeg-1) - _beforedeg).abs()) {
//          _directionDeg = _directionDeg-1;
//        }
//        _rotateController.forward(from: _beforedeg);
//      });
//    });
//
//    _rotateController.forward();
//
//    super.initState();
//  }
//
//  @override
//  void dispose() {
//    _rotateController.dispose();
//    FlutterCompass.events.listen(null);
//    super.dispose();
//  }

  @override
  Widget build(BuildContext context) {
//    rotateTween = Tween(
//        begin: _beforedeg,
//        end: _directionDeg
//    ).animate(CurvedAnimation(
//        parent: _rotateController,
//        curve: Curves.easeOut
//    ));
//
//    rotateTweenInside = Tween(
//        begin: -_beforedeg,
//        end: -_directionDeg
//    ).animate(CurvedAnimation(
//        parent: _rotateController,
//        curve: Curves.easeOut
//    ));
//
//    return Scaffold(
//        body: SingleChildScrollView(
//
//          child: Column(
//            mainAxisSize: MainAxisSize.max,
//            children: <Widget>[
//              SizedBox(height: 20.0,),
//              Center(
//                child: Text("Arah Kiblat", style: TextStyle(color: Colors.black,fontSize: 16,fontFamily: 'Rubik',fontWeight: FontWeight.bold),),
//              ),
//              SizedBox(height: 20.0,),
//              Container(
//                padding: EdgeInsets.all(20),
//                alignment: Alignment.center,
//                width: MediaQuery.of(context).size.width,
//                child: RotationTransition(
//                    turns: rotateTween,
//                    child: Stack(
//                      children: <Widget>[
//
//
//                        Container(
//                          width: MediaQuery.of(context).size.width,
//                          alignment: Alignment.center,
//                          child: SvgPicture.asset(
//                              'assets/images/Compass.svg',
//                              semanticsLabel: 'Compass Rotate',
//                              width: MediaQuery.of(context).size.width * 0.8,
//                              height: MediaQuery.of(context).size.width * 0.8
//                          ),
//                        ),
//                        Container(
//                            width: MediaQuery.of(context).size.width,
//                            height: MediaQuery.of(context).size.width * 0.8,
//                            alignment: Alignment.center,
//                            child: Transform.translate(
//                                offset: Offset(
//                                  // _getPosXKaabah(_headingAngleDeg, MediaQuery.of(context).size.width * 0.4),
//                                  // _getPosYKaabah(_headingAngleDeg, MediaQuery.of(context).size.width * 0.4),
//                                    _kaabahX * MediaQuery.of(context).size.width * 0.4,
//                                    _kaabahY * MediaQuery.of(context).size.width * 0.4
//                                ),
//                                child: RotationTransition(
//                                  turns: rotateTweenInside,
//                                  child: SvgPicture.asset(
//                                      'assets/images/kabah.svg',
//                                      semanticsLabel: 'Kaabah',
//                                      width: MediaQuery.of(context).size.width * 0.1
//                                  ),
//                                )
//                            )
//                        ),
//                      ],
//                    )
//                ),
//              )
//            ],
//          ),
//        )
//    );
  }
}