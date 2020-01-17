import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:thaibah/Model/generalInsertId.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/Model/myBankModel.dart';
import 'package:thaibah/UI/Widgets/listBank.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/bloc/myBankBloc.dart';
class Bank extends StatefulWidget {
  @override
  _BankState createState() => _BankState();
}

class _BankState extends State<Bank> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int currentCardIndex = 0;
  bool _addNewCard = false;
  TextEditingController accNoController, accNameController;
  String bankCodeController='';
  bool _isLoading = false;
  final _titleStyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );


  Future create() async{
    var res = await createMyBankBloc.fetchCreateMyBank("", bankCodeController, accNoController.text, accNameController.text);
    print(res);
    if(res is GeneralInsertId){
      GeneralInsertId result = res;
      if(result.status == 'success'){
        setState(() {
          _isLoading  = false;
          _addNewCard = false;
          accNameController.clear();
          accNoController.clear();
        });
        return showInSnackBar('Data Bank Berhasil Ditambahkan','sukses');
      }else{
        setState(() {_isLoading = false;});

        return showInSnackBar(result.msg,'gagal');
      }
    }else{
      General results = res;
      setState(() {_isLoading = false;});
      return showInSnackBar(results.msg,'gagal');
    }
  }

  Future delete(id) async{
    var res = await deleteMyBankBloc.fetchDeleteMyBank(id);
    if(res is General){
      General result = res;
      if(result.status == 'success'){
        setState(() {
          _isLoading = false;
        });
        return showInSnackBar('Data Bank Anda Berhasil Dihapus','sukses');
      }else{
        setState(() {_isLoading = false;});
        return showInSnackBar(result.msg,'gagal');
      }
    }else{
      General results = res;
      setState(() {_isLoading = false;});
      return showInSnackBar(results.msg,'gagal');
    }
  }

  @override
  void initState() {
    super.initState();
    accNoController = TextEditingController();
    accNameController = TextEditingController();
  }

  @override
  void dispose() {
    accNoController.dispose();
    accNameController.dispose();
    super.dispose();
  }
  void showInSnackBar(String value, String param) {
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
      backgroundColor: param == 'sukses' ? Colors.green:Colors.redAccent,
      duration: Duration(seconds: 3),
    ));
  }

  @override
  Widget build(BuildContext context) {
    myBankBloc.fetchMyBankList();
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      body: StreamBuilder(
        stream: myBankBloc.allBank,
        builder: (context, AsyncSnapshot<MyBankModel> snapshot) {
          if (snapshot.hasData) {
            return buildContent(snapshot, context);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return  Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 0.0, bottom: 0.0),
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 0.0,
                      margin: new EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                          leading: Container(
                            width: 80.0,
                            height: 80.0,
                            padding: EdgeInsets.all(10),
                            child: CircleAvatar(
                              minRadius: 150,
                              maxRadius: 150,
                              child: CachedNetworkImage(
                                imageUrl: "http://lequytong.com/Content/Images/no-image-02.png",
                                placeholder: (context, url) => Center(
                                  child: SkeletonFrame(width: 80,height:80),
                                ),
                                errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                                imageBuilder: (context, imageProvider) => Container(
                                  decoration: BoxDecoration(
                                    borderRadius: new BorderRadius.circular(0.0),
                                    color: Colors.white,
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          title: SkeletonFrame(width: MediaQuery.of(context).size.width/2,height:16),
                          subtitle: Row(
                            children: <Widget>[
                              SkeletonFrame(width: MediaQuery.of(context).size.width/2,height:16),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }


  getBank(val){
    bankCodeController = val;
    print(bankCodeController);
  }



  Widget buildContent(AsyncSnapshot<MyBankModel> snapshot, BuildContext context) {
    if(snapshot.data.result.length > 0){
      return  Column(
        children: <Widget>[
          (!_addNewCard) ? Text('') : _buildNewCard(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            child: Text(
              'Pilih dan Geser Untuk Menghapus Data Bank Anda',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,fontFamily: 'Rubik'),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 0.0, bottom: 0.0),

              itemCount: snapshot.data.result.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                    key: Key(index.toString()),
                    child: Card(
                      elevation: 0.0,
                      margin: new EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white),
                        child: ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                            leading: Container(
                              width: 80.0,
                              height: 80.0,
                              padding: EdgeInsets.all(10),
                              child: CircleAvatar(
                                minRadius: 150,
                                maxRadius: 150,
                                child: CachedNetworkImage(
                                  imageUrl: snapshot.data.result[index].picture,
                                  placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))),
                                  ),
                                  errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                                  imageBuilder: (context, imageProvider) => Container(
                                    decoration: BoxDecoration(
                                      borderRadius: new BorderRadius.circular(0.0),
                                      color: Colors.white,
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              snapshot.data.result[index].accName,style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Row(
                              children: <Widget>[
                                Text(snapshot.data.result[index].accNo, style: TextStyle(color: Colors.black))
                              ],
                            ),
                        ),
                      ),
                    ),
                    background: slideLeftBackground(),
                    confirmDismiss: (direction) async {
                      final bool res = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Text("Anda Yakin Akan Menghapus Data Ini ???"),
                            actions: <Widget>[
                              FlatButton(
                                child: Text("Cancel", style: TextStyle(color: Colors.black)),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: Text("Delete", style: TextStyle(color: Colors.red),),
                                onPressed: () async {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  delete(snapshot.data.result[index].id);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                );
              },
            ),
          ),
        ],
      );
    }else{
      return Column(
        children: <Widget>[
          (!_addNewCard) ? Text('') : _buildNewCard(),
          Container(
              child: Center(child:Text("Data Tidak Tersedia",style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 20,fontFamily: 'Rubik'),))
          ),
        ],
      );
    }

  }

  Widget _buildNewCard() {
    return Container(
      padding: const EdgeInsets.only(
          left: 22.0, right: 22.0, top: 18.0, bottom: 18.0),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        border: Border.all(color: Colors.blue[100]),
      ),
      child: _newCardForm(),
    );
  }

  Widget _newCardForm() {
    final height = 22.0;
    return Column(
      children: <Widget>[
        ListBank(callback: getBank),
        SizedBox(height: height),
        TextField(
          controller: accNoController,
          decoration: InputDecoration(
            labelText: 'No Rekening',
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: height),
        TextField(
          controller: accNameController,
          decoration: InputDecoration(
            labelText: 'Atas Nama',
          ),
          keyboardType: TextInputType.text,
        ),
        SizedBox(height: height),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton(
              onPressed: () {
                accNameController.clear();
                accNoController.clear();
                setState(() {
                  _addNewCard = false;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('BATAL', style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
              ),
              color: Colors.white,
            ),
            MaterialButton(
              onPressed: () {
                if(bankCodeController == '' || bankCodeController == null){
                  return showInSnackBar("No Rekening Harus Disi",'gagal');
                }
                else if(accNoController.text == ""){
                  return showInSnackBar("No Rekening Harus Disi",'gagal');
                }else if(accNameController.text == ""){
                  return showInSnackBar("Atas Nama Harus Disi",'gagal');
                }
                else {
                  setState(() {_isLoading = true;});
                  create();
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _isLoading?Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white))):Center(
                  child: Text("Daftar",style: TextStyle(color: Colors.white,fontFamily: "Rubik",fontSize: 16,fontWeight: FontWeight.bold,letterSpacing: 1.0)),
                ),
              ),
              color: Color(0xFF116240),
            )
          ],
        )
      ],
    );
  }



  Widget _buildAddCardButton() {
    return IconButton(
      icon: Icon(Icons.add, color: Colors.white),
      onPressed: () {
        setState(() {
          _addNewCard = true;
        });
      },
    );

  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  Widget _buildAppBar() {

    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.keyboard_backspace,
          color: Colors.white,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0.0,
      title: Text('Daftar Bank ', style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold)),
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
      actions: <Widget>[
        _buildAddCardButton()
      ],
    );
  }
}
