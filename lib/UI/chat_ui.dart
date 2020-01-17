//import 'dart:convert';
//
//import 'package:flutter/material.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:thaibah/Model/member/contactModel.dart';
//import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
//import 'package:thaibah/UI/chat_room_ui.dart';
//import 'package:thaibah/bloc/memberBloc.dart';
//import 'package:adhara_socket_io/adhara_socket_io.dart';
//const String URI = "http://192.168.1.9:3010/";
//
//class ChatUI extends StatefulWidget {
//  @override
//  _ChatUIState createState() => _ChatUIState();
//}
//
//class _ChatUIState extends State<ChatUI> {
//
//
////  List<String> toPrint = ["trying to connect"];
////  SocketIOManager manager;
////  Map<String, SocketIO> sockets = {};
////  Map<String, bool> _isProbablyConnected = {};
////
////
////  initSocket(String identifier) async {
////    setState(() => _isProbablyConnected[identifier] = true);
////    SocketIO socket = await manager.createInstance(SocketOptions(
////      //Socket IO server URI
////        URI,
////        //Query params - can be used for authentication
////        query: {
////          'id' : '45498967-168a-4677-813f-04bf696a2879'
////        },
////        //Enable or disable platform channel logging
////        enableLogging: false,
////        transports: [Transports.WEB_SOCKET/*, Transports.POLLING*/] //Enable required transport
////    ));
////    socket.onConnect((data) {
////      pprint("connected...");
////      pprint(data);
////      sendMessage(identifier);
////    });
////    socket.onConnectError(pprint);
////    socket.onConnectTimeout(pprint);
////    socket.onError(pprint);
////    socket.onDisconnect(pprint);
////    socket.on("type:string", (data) => pprint("type:string | $data"));
////    socket.on("type:bool", (data) => pprint("type:bool | $data"));
////    socket.on("type:number", (data) => pprint("type:number | $data"));
////    socket.on("type:object", (data) => pprint("type:object | $data"));
////    socket.on("type:list", (data) => pprint("type:list | $data"));
////    socket.on("message", (data) => pprint(data));
////    socket.connect();
////    sockets[identifier] = socket;
////  }
////
////  bool isProbablyConnected(String identifier){
////    return _isProbablyConnected[identifier]??false;
////  }
////
////  disconnect(String identifier) async {
////    await manager.clearInstance(sockets[identifier]);
////    setState(() => _isProbablyConnected[identifier] = false);
////  }
////
////  sendMessage(identifier) {
////    if (sockets[identifier] != null) {
////      pprint("sending message from '$identifier'...");
////      sockets[identifier].emit("message", [
////        {
////          'from': '45498967-168a-4677-813f-04bf696a2879',
////          'to'  : '45498967-168a-4677-813f-04bf696a2879',
////          'msg' : 'test pesan daya'
////        },
////      ]);
////      pprint("Message emitted from '$identifier'...");
////    }
////  }
////
////
////
////  pprint(data) {
////    setState(() {
////      if (data is Map) {
////        data = json.encode(data);
////      }
////      print(data);
////      toPrint.add(data);
////    });
////  }
//
//
//
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    contactBloc.fetchContactList();
////    manager = SocketIOManager();
////    initSocket("default");
//  }
//
//  @override
//  void dispose() {
//    // TODO: implement dispose
//    super.dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
////    contactBloc.fetchContactList();
//    return Scaffold(
//      appBar: AppBar(
//        flexibleSpace: Container(
//          decoration: BoxDecoration(
//            gradient: LinearGradient(
//              begin: Alignment.centerLeft,
//              end: Alignment.centerRight,
//              colors: <Color>[
//                Color(0xFF116240),
//                Color(0xFF30cc23)
//              ],
//            ),
//          ),
//        ),
//        title: Text("Daftar Kontak",style: TextStyle(color: Colors.white,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
//      ),
//      body: StreamBuilder(
//          stream: contactBloc.getResult,
//          builder: (context, AsyncSnapshot<ContactModel> snapshot) {
//            if(snapshot.hasData){
//              return buildContent(snapshot, context);
//            }else if(snapshot.hasError){
//              return Text(snapshot.error.toString());
//            }
//            return _loading();
//          }
//      ),
//    );
//  }
//
//  Widget buildContent(AsyncSnapshot<ContactModel> snapshot, BuildContext context){
//    return Center(
//      child: Padding(
//        padding: const EdgeInsets.fromLTRB(13.0,5.0,14.0,0.0),
//        child: Container(
//          child: ListView.builder(
//            itemCount: snapshot.data.result.length,
//            itemBuilder: (BuildContext context, int index) {
//              var color  = (index % 2 == 0) ? Colors.white : Color(0xFFF7F7F9);
//              return Container(
//                color: color,
//                alignment: Alignment.topRight,
//                child: ListTile(
//                  contentPadding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
//                  leading: Container(
//                      padding: EdgeInsets.only(right: 1.0),
//                      child: CircleAvatar(
//                        radius: 30.0,
//                        backgroundImage:
//                        NetworkImage(snapshot.data.result[index].picture),
//                        backgroundColor: Colors.transparent,
//                      )
//                  ),
//                  title: Text(
//                    snapshot.data.result[index].name,
//                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontFamily: 'Rubik'),
//                  ),
//                  subtitle: Row(
//                    children: <Widget>[
//                      Text(snapshot.data.result[index].referral, style: TextStyle(color: Colors.black,fontFamily: 'Rubik'))
//                    ],
//                  ),
//                  onTap: (){
//                    Navigator.of(context).push(
//                        CupertinoPageRoute(builder: (BuildContext context){
//                          return ChatRoomUI(
//                              name:snapshot.data.result[index].name,
//                              id:snapshot.data.result[index].id
//                          );
//                        })
//                    );
//                  },
//                ),
//              );
//            },
//          ),
//        ),
//      ),
//    );
//  }
//
//  Widget _loading(){
//    return Center(
//      child: Padding(
//        padding: const EdgeInsets.fromLTRB(13.0,5.0,14.0,0.0),
//        child: Container(
//          child: ListView.builder(
//            itemCount: 9,
//            itemBuilder: (BuildContext context, int index) {
//              return Stack(
//                alignment: Alignment.topRight,
//                children: <Widget>[
//                  ListTile(
//                    contentPadding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
//                    leading: Container(
//                        padding: EdgeInsets.only(right: 1.0),
//                        child: CircleAvatar(
//                          radius: 30.0,
//                          backgroundImage:
//                          NetworkImage("http://lequytong.com/Content/Images/no-image-02.png"),
//                          backgroundColor: Colors.transparent,
//                        )
//                    ),
//                    title: SkeletonFrame(width: MediaQuery.of(context).size.width/2,height: 16.0),
//                    subtitle: Row(
//                      children: <Widget>[
//                        SkeletonFrame(width: MediaQuery.of(context).size.width/2,height: 16.0),
//                      ],
//                    ),
//                  ),
//                ],
//              );
//            },
//          ),
//        ),
//      ),
//    );
//  }
//}
