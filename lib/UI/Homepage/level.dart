import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thaibah/Model/royalti/levelModel.dart';
import 'package:thaibah/UI/component/royalti/level.dart';
import 'package:thaibah/bloc/royalti/royaltiBloc.dart';

class Level extends StatefulWidget {
  final Function(String param) onItemInteraction;
  Level({this.onItemInteraction});
  @override
  _LevelState createState() => _LevelState();
}

class _LevelState extends State<Level> {
  bool isLoading = false;
  bool aktif = false;
  @override
  void initState() {
    super.initState();
    if(mounted){
      royaltiLevelBloc.fetchLevelList();
    }
    aktif = true;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0.0,
      color: Colors.transparent,
      child: StreamBuilder(
        stream: royaltiLevelBloc.getResult,
        builder: (context, AsyncSnapshot<LevelModel> snapshot){
          if (snapshot.hasData) {
            return buildContent(snapshot, context);
          }
          else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return CircularProgressIndicator();
        }
      ),
    );
  }

  Widget buildContent(AsyncSnapshot<LevelModel> snapshot, BuildContext context){
    return Container(
        padding: EdgeInsets.all(0.0),
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: snapshot.data.result.data.length,
          itemBuilder: (context,index){
            return Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal:5),
                  child: InkWell(
                      onTap: () {
                        setState(() {
                          aktif = true;
                        });
                        print(aktif);
                        widget.onItemInteraction(snapshot.data.result.data[index].name);
                      },
                      child: ChoiceChip(aktif?Icons.graphic_eq:Icons.add, snapshot.data.result.data[index].name)
                  ),
                ),

              ],
            );
          },
        )
    );
  }
}

class ChoiceChip extends StatefulWidget {
  final IconData icon;
  final String text;
//  final bool isflightSelected;
  ChoiceChip(this.icon, this.text);
//  ChoiceChip(this.icon, this.text);
  @override
  _ChoiceChipState createState() => _ChoiceChipState();
}

class _ChoiceChipState extends State<ChoiceChip> {
  bool aktif = false;
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = false;
//    aktif = widget.isflightSelected;
  }
  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(.15),
          borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      child: Row(
        children: <Widget>[
          Icon(
            widget.icon,
            size: 20,
            color: Colors.white,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            widget.text,
            style: TextStyle(color: Colors.white, fontSize: 12),
            softWrap: true,
          )
        ],
      ),
    );
  }
}
