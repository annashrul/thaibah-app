//import 'dart:convert';
//import 'dart:io';
//
//import 'package:flutter/material.dart';
//import 'package:thaibah/UI/obrolan/buble.dart';
//import 'package:adhara_socket_io/adhara_socket_io.dart';
//import 'package:thaibah/config/user_repo.dart';
//import 'package:http/http.dart' as http;
//
//const String URI = "http://192.168.1.9:3010/";
//bool gbolSIOConnected = false;
//String socketUrl;
//List<String> logRows = new List<String>();
//class ChatRoomUI extends StatefulWidget {
//  String name;
//  String id;
//
//  ChatRoomUI({this.name,this.id,});
//  @override
//  _ChatRoomUIState createState() => _ChatRoomUIState();
//}
//
//class _ChatRoomUIState extends State<ChatRoomUI> {
//
////  var msgController = new TextEditingController();
////  String ID_LAWAN = '';
////  final userRepository = UserRepository();
////
////  SocketIOManager manager;
////  Map<String, SocketIO> sockets = {};
////  SocketIO socket;
////  TextEditingController _controller = TextEditingController();
////  String _chat;
////  // StreamController _rcontroller;
////
////  void initState() {
////    manager = SocketIOManager();
////    // _rcontroller = StreamController();
////    _chat = '.text';
////
////    this.socketConnectionJT();
////  }
////
////  Future socketConnectionJT() async {
////    final ID = await userRepository.getID();
////    socket = await manager.createInstance(SocketOptions(
////        URI,
////        //Query params - can be used for authentication
////        query: {
////          "id": "$ID",
////        },
////        //Enable or disable platform channel logging
////        enableLogging: false,
////        transports: [
////          Transports.WEB_SOCKET,
////          Transports.POLLING
////        ] //Enable required transport
////    ));
////
////    socket.onConnect((data) {
////      print("connected...");
////      print(data);
////    });
////    socket.connect();
////    socket.on('message', (data) {
////      print(data);
////
////      setState(() {
////        if (data == null) {
////          _chat = '_controller.text'; // TODO: implement setState
////        } else {
////          _chat = data.toString();
////        }
////      });
////
////
////    });
////
////
////  }
////
////  void _sendmsg() async {
////    final ID = await userRepository.getID();
////    socket.emit('message', [
////      {
////        'from': ID,
////        'to'  : widget.id,
////        'msg' : _controller.text
////      }
////
////    ]);
////
////
////  }
//
//  /* @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('socket'),
//      ),
//      body: Container(
//        child: RaisedButton(
//            child: Text('Launch screen'),
//              onPressed: _sendmsg,
//            ),
//      ),
//    );
//  }*/
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('Sockets'),
//      ),
//      body: Padding(
//        padding: const EdgeInsets.all(20.0),
//        child: Column(
//          crossAxisAlignment: CrossAxisAlignment.start,
//          children: <Widget>[
//            Form(
//              child: TextFormField(
//                //esto captura el dato desde el input grafico
//
//                decoration: InputDecoration(labelText: 'Send a message'),
//              ),
//            ),
//
//            /*StreamBuilder(
//              stream: _rcontroller.stream,
//              builder: (context, snapshot) {
//                return Padding(
//                  padding: const EdgeInsets.symmetric(vertical: 24.0),
//                  child: Text(snapshot.hasData ? '${snapshot.data}' : ''),
//                );
//              },
//            )*/
//          ],
//        ),
//      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: (){},
//        tooltip: 'Send message',
//        child: Icon(Icons.send),
//      ), // This trailing comma makes auto-formatting nicer for build methods.
//    );
//  }
//
//
//
////  @override
////  Widget build(BuildContext context) {
////    return Scaffold(
////      appBar: AppBar(
////        title: Text("${widget.name} ${widget.id}", style: TextStyle(color:Colors.white)),
////        iconTheme: new IconThemeData(color: Colors.white),
////      ),
////      body: Column(
////        children: <Widget>[
////          Expanded(
////            child: ListView.builder(
////              reverse: true,
////              itemCount: 100,
////              itemBuilder: (BuildContext context, int index) {
////                return (index % 2 == 0) ?
////                Bubble(message: 'Whatsapp like bubble talk',time: '12:01', delivered: true, isMe: false):
////                Bubble(message: 'Whatsapp like bubble talk',time: '12:01', delivered: true, isMe: true);
////              },
////            ),
////          ),
////          inputMsg("default")
////        ],
////      ),
////    );
////  }
////
////  Widget message (int index) {
////    return Card(
////      child: Column(
////        mainAxisSize: MainAxisSize.min,
////        children: <Widget>[
////          Padding(
////            padding: const EdgeInsets.fromLTRB(0.0, 5.0, 15.0, 3.0),
////            child: Stack(
////            alignment: Alignment.topRight,
////              children: <Widget>[
////                ListTile(
////                  title: Padding(
////                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
////                    child: Text(
////                      widget.name,
////                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
////                    ),
////                  ),
////                  subtitle: Row(
////                    children: <Widget>[
////                      Expanded(
////                        child: Text("Laborum pariatur Lorem non proident ex consequat ex proident. Qui tempor nulla nisi nostrud amet elit ipsum esse. Dolore laborum ea non laborum nostrud quis tempor.", textAlign: TextAlign.left, style: TextStyle(color: Colors.black))
////                      )
////                    ],
////                  ),
////                  onTap: (){
////                    print("Tapped");
////                  },
////                ),
////                Text("Just now", style: TextStyle(color: Colors.black),)
////              ],
////            ),
////          ),
////
////        ],
////      ),
////    );
////  }
////
////
////  Widget inputMsg(String identifier){
////    return Container(
////      child: Card(
////        child: Padding(
////          padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
////          child: Row(
////            children: <Widget>[
////              Expanded(
////                flex: 5,
////                child: TextFormField(
////                  autofocus: true,
////                  decoration: InputDecoration(
////                      border: InputBorder.none,
////                      hintText: 'Tulis pesan  ...'
////                  ),
////                  validator: (value) {
////                    if(value.isEmpty) {
////                      return 'Masukan pesan';
////                    }
////                  },
////                  controller: msgController,
////                ),
////              ),
////              Expanded(
////                flex: 1,
////                child: IconButton(
////                  icon: Icon(Icons.send),
////                  onPressed: isProbablyConnected?sendMessage:null,
////                ),
////              )
////            ],
////          ),
////        ),
////      ),
////    );
////  }
//}
