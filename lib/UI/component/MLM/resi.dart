import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:thaibah/Model/MLM/resiModel.dart';
import 'dart:math' as math;

import 'package:thaibah/bloc/historyPembelianBloc.dart';

class Resi extends StatefulWidget {
  final String resi, kurir;
  Resi({this.resi,this.kurir});
  @override
  _ResiState createState() => _ResiState();
}

class _ResiState extends State<Resi> {
  final GlobalKey<AnimatedListState> _listKey = new GlobalKey<AnimatedListState>();
  final double _imageHeight = 256.0;
//  ListModel listModel;
  bool showOnlyCompleted = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  String resiLocal = '';
  String kurirLocal = '';



  @override
  void initState() {
    super.initState();
    resiLocal = widget.resi;
    kurirLocal = widget.kurir;
    resiBloc.fetchResi(resiLocal, kurirLocal);
//    listModel = new ListModel(_listKey, tasks);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: scaffoldKey,
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
        title: new Text("Lacak Resi", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
      ),
      body: Stack(
        children: <Widget>[
          _buildTimeline(),
          buildContent(context),
        ],
      ),
    );
  }

  Widget buildContent(BuildContext context){
    return Container(
//      color: Colors.white,
      child: StreamBuilder(
          stream: resiBloc.getResult,
          builder: (context, AsyncSnapshot<ResiModel> snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: new EdgeInsets.only(top: 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(color: Colors.white),
                      padding:EdgeInsets.only(top: 20.0, bottom: 0.0, left: 15.0, right: 15.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('No.Resi', style: TextStyle(color:Colors.grey,fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                              Text(snapshot.data.result.resi, style: TextStyle(color:Colors.black,fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold))
                            ],
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Tanggal Pengiriman', style: TextStyle(color:Colors.grey,fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                              Text(snapshot.data.result.ongkir.details.waybillDate+' '+snapshot.data.result.ongkir.details.waybillTime, style: TextStyle(color:Colors.black,fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold))
                            ],
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Service Code', style: TextStyle(color:Colors.grey,fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                              Text(snapshot.data.result.ongkir.summary.serviceCode, style: TextStyle(color:Colors.black,fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold))
                            ],
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Pembeli', style: TextStyle(color:Colors.grey,fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                              Text(snapshot.data.result.ongkir.details.receiverName, style: TextStyle(color:Colors.black,fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold))
                            ],
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Status', style: TextStyle(color:Colors.grey,fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                              Text(snapshot.data.result.ongkir.deliveryStatus.status, style: TextStyle(color:Colors.black,fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold))
                            ],
                          ),
                          SizedBox(height: 20.0),
                        ],
                      ),
                    ),

                    _buildTasksList(snapshot,context)
                  ],
                ),
              );
            }else if(snapshot.hasError){
              return Text(snapshot.error.toString());
            }
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
      ),
    );
  }



  Widget _buildTasksList(AsyncSnapshot<ResiModel> snapshot, BuildContext context) {
//    return Text('acuy');
    return new Expanded(
      child: new AnimatedList(
        initialItemCount: snapshot.data.result.ongkir.manifest.length,
        key: _listKey,
        itemBuilder: (context, index, animation) {
          return new FadeTransition(
            opacity: animation,
            child: new SizeTransition(
              sizeFactor: animation,
              child: new Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: new Row(
                  children: <Widget>[
                    new Padding(
                      padding:
                      new EdgeInsets.symmetric(horizontal: 32.0 - 12.0 / 2),
                      child: new Container(
                        height: 12.0,
                        width: 12.0,
                        decoration: new BoxDecoration(shape: BoxShape.circle, color: Colors.green),
                      ),
                    ),
                    new Expanded(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text(
                            DateFormat.yMd().format(snapshot.data.result.ongkir.manifest[index].manifestDate.toUtc()),
                            style: new TextStyle(fontSize: 12.0),
                          ),
                          new Text(
                            snapshot.data.result.ongkir.manifest[index].manifestDescription.toLowerCase(),
                            style: new TextStyle(fontSize: 12.0, color: Colors.grey),
                          )
                        ],
                      ),
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: new Text(
                        snapshot.data.result.ongkir.manifest[index].manifestTime,
                        style: new TextStyle(fontSize: 12.0, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }


  Widget _buildTimeline() {
    return new Positioned(
      top: 0.0,
      bottom: 0.0,
      left: 32.0,
      child: new Container(
        width: 1.0,
        color: Colors.grey[300],
      ),
    );
  }
}

class Task {
  final String name;
  final String category;
  final String time;
  final Color color;
  final bool completed;

  Task({this.name, this.category, this.time, this.color, this.completed});
}
List<Task> tasks = [
  new Task(
      name: "Catch up with Brian",
      category: "Mobile Project",
      time: "5pm",
      color: Colors.orange,
      completed: false),
  new Task(
      name: "Make new icons",
      category: "Web App",
      time: "3pm",
      color: Colors.cyan,
      completed: true),
  new Task(
      name: "Design explorations",
      category: "Company Website",
      time: "2pm",
      color: Colors.pink,
      completed: false),
  new Task(
      name: "Lunch with Mary",
      category: "Grill House",
      time: "12pm",
      color: Colors.cyan,
      completed: true),
  new Task(
      name: "Teem Meeting",
      category: "Hangouts",
      time: "10am",
      color: Colors.cyan,
      completed: true),

];

class ListModel {
  ListModel(this.listKey, items) : this.items = new List.of(items);

  final GlobalKey<AnimatedListState> listKey;
  final List<Task> items;

  AnimatedListState get _animatedList => listKey.currentState;

  void insert(int index, Task item) {
    items.insert(index, item);
    _animatedList.insertItem(index, duration: new Duration(milliseconds: 150));
  }

  Task removeAt(int index) {
    final Task removedItem = items.removeAt(index);
    if (removedItem != null) {
      _animatedList.removeItem(
          index,
              (context, animation) => new TaskRow(
            task: removedItem,
            animation: animation,
          ),
          duration: new Duration(milliseconds: (150 + 200*(index/length)).toInt())
      );
    }
    return removedItem;
  }

  int get length => items.length;

  Task operator [](int index) => items[index];

  int indexOf(Task item) => items.indexOf(item);
}

class TaskRow extends StatelessWidget {
  final Task task;
  final double dotSize = 12.0;
  final Animation<double> animation;

  const TaskRow({Key key, this.task, this.animation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new FadeTransition(
      opacity: animation,
      child: new SizeTransition(
        sizeFactor: animation,
        child: new Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: new Row(
            children: <Widget>[
              new Padding(
                padding:
                new EdgeInsets.symmetric(horizontal: 32.0 - 12.0 / 2),
                child: new Container(
                  height: 12.0,
                  width: 12.0,
                  decoration: new BoxDecoration(shape: BoxShape.circle, color: Colors.green),
                ),
              ),
              new Expanded(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      '22 Nov 2019',
                      style: new TextStyle(fontSize: 18.0),
                    ),
                    new Text(
                      'desktipsi',
                      style: new TextStyle(fontSize: 12.0, color: Colors.grey),
                    )
                  ],
                ),
              ),
              new Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: new Text(
                  '18.00',
                  style: new TextStyle(fontSize: 12.0, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}