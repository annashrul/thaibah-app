import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:thaibah/Model/sosmed/listLikeSosmedModel.dart';
import 'package:thaibah/bloc/sosmed/sosmedBloc.dart';

class ListLikeSosmed extends StatefulWidget {
  final String id;
  ListLikeSosmed({this.id});
  @override
  _ListLikeSosmedState createState() => _ListLikeSosmedState();
}

class _ListLikeSosmedState extends State<ListLikeSosmed> {

  final _bloc = LikeSosmedBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc.fetchListLikeSosmed(widget.id);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text('Daftar Orang Yang Menyukai ', style: TextStyle(fontFamily:'Rubik',color:Colors.white,fontWeight: FontWeight.bold)),
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

      ),
      body: StreamBuilder(
        stream: _bloc.getResult,
        builder: (context, AsyncSnapshot<ListLikeSosmedModel> snapshot){
          if (snapshot.hasData) {
            return Container(
              padding: EdgeInsets.all(10.0),
              child: buildContent(snapshot, context),
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Container(child:Center(child:CircularProgressIndicator()));
        }
      ),
    );
  }

  Widget buildContent(AsyncSnapshot<ListLikeSosmedModel> snapshot, BuildContext context){
    return snapshot.data.result.length > 0 ? ListView.builder(
        primary: true,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: snapshot.data.result.length,
        itemBuilder: (context,index){
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      height: 40.0,
                      width: 40.0,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: new NetworkImage(snapshot.data.result[index].picture)),
                      ),
                    ),
                    new SizedBox(width: 10.0),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Html(data: snapshot.data.result[index].likers,defaultTextStyle: TextStyle(fontSize:12.0,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
                        ],
                      ),
                    ),
                    new SizedBox(width: 10.0),
                    Text("${snapshot.data.result[index].createdAt}",style: TextStyle(fontFamily: 'Rubik',color: Colors.grey,fontSize: 8.0)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                child: Divider(),
              )
            ],
          );
        }
    ) : Container();
  }
}
