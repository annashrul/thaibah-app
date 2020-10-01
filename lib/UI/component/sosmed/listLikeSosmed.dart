import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/sosmed/listLikeSosmedModel.dart';
import 'package:thaibah/bloc/sosmed/sosmedBloc.dart';
import 'package:thaibah/config/user_repo.dart';

class ListLikeSosmed extends StatefulWidget {
  final String id;
  ListLikeSosmed({this.id});
  @override
  _ListLikeSosmedState createState() => _ListLikeSosmedState();
}

class _ListLikeSosmedState extends State<ListLikeSosmed> {

  final _bloc = LikeSosmedBloc();
  
  final userRepository = UserRepository();
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc.fetchListLikeSosmed(widget.id);
    initializeDateFormatting('id');
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
      appBar: UserRepository().appBarWithButton(context, "Daftar Orang Yang Menykaui Status Anda",(){Navigator.pop(context);},<Widget>[]),
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
          return UserRepository().loadingWidget();
        }
      ),
    );
  }

  Widget buildContent(AsyncSnapshot<ListLikeSosmedModel> snapshot, BuildContext context){

    return snapshot.data.result.length > 0 ? ListView.builder(
        itemCount: snapshot.data.result.length,
        itemBuilder: (context,index){
          return ListTile(
            leading: Container(
              height: 40.0,
              width: 40.0,
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                    fit: BoxFit.fill,
                    image: new NetworkImage(snapshot.data.result[index].picture)),
              ),
            ),
            title:UserRepository().textQ(snapshot.data.result[index].likers,12, Colors.black,FontWeight.bold,TextAlign.left),
            trailing: UserRepository().textQ(DateFormat.yMMMMEEEEd('id').format(snapshot.data.result[index].createdAt),12, Colors.black,FontWeight.bold,TextAlign.left),
          );

        }
    ) : Container();
  }
}
