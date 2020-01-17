import 'package:thaibah/Model/MLM/getDetailChekoutSuplemenModel.dart';
import 'package:thaibah/Model/royalti/levelModel.dart';
import 'package:thaibah/Model/royalti/royaltiMemberModel.dart';
import 'package:thaibah/bloc/base.dart';
import 'package:rxdart/rxdart.dart';

class RoyaltiLevelBloc extends BaseBloc{
  bool _isDisposed = false;
  final PublishSubject<LevelModel> _serviceController = new PublishSubject<LevelModel>();
  Observable<LevelModel> get getResult => _serviceController.stream;
  fetchLevelList() async {
    if(_isDisposed) {
      print('false');
    }else{
      LevelModel levelModel =  await repository.fetchLevel();
      _serviceController.sink.add(levelModel);
    }
  }
  void dispose() {
    _serviceController.close();
    _isDisposed = true;
  }
}


class RoyaltiMemberBloc extends BaseBloc{
  bool _isDisposed = false;
  final PublishSubject<RoyaltiMemberModel> _serviceController = new PublishSubject<RoyaltiMemberModel>();
  Observable<RoyaltiMemberModel> get getResult => _serviceController.stream;
  fetchRoyaltiMemberList(var param) async {
    if(_isDisposed) {
      print('false');
    }else{
      RoyaltiMemberModel royaltiMemberModel =  await repository.fetchRoyaltiMember(param);
      _serviceController.sink.add(royaltiMemberModel);
    }
  }
  void dispose() {
    _serviceController.close();
    _isDisposed = true;
  }
}



final royaltiLevelBloc  = RoyaltiLevelBloc();
final royaltiMemberBloc  = RoyaltiMemberBloc();
