import 'package:thaibah/Model/sosmed/listDetailSosmedModel.dart';
import 'package:thaibah/Model/sosmed/listInboxSosmedModel.dart';
import 'package:thaibah/Model/sosmed/listLikeSosmedModel.dart';
import 'package:thaibah/Model/sosmed/listSosmedModel.dart';
import 'package:thaibah/bloc/base.dart';
import 'package:rxdart/rxdart.dart';

class SosmedBloc extends BaseBloc{
  bool _isDisposed = false;
  final PublishSubject<ListSosmedModel> _serviceController = new PublishSubject<ListSosmedModel>();
  Observable<ListSosmedModel> get getResult => _serviceController.stream;
  fetchListSosmed(var page, var limit,var param) async {
    if(_isDisposed) {
      print('false');
    }else{
      ListSosmedModel listSosmedModel =  await repository.fetchListSosmed(page,limit,param);
      _serviceController.sink.add(listSosmedModel);
    }
  }
  void dispose() {
    _serviceController.close();
    _isDisposed = true;
  }
}

class InboxSosmedBloc extends BaseBloc{
  bool _isDisposed = false;
  final PublishSubject<ListInboxSosmedModel> _serviceController = new PublishSubject<ListInboxSosmedModel>();
  Observable<ListInboxSosmedModel> get getResult => _serviceController.stream;
  fetchListInboxSosmed(var page, var limit) async {
    if(_isDisposed) {
      print('false');
    }else{
      ListInboxSosmedModel listInboxSosmedModel =  await repository.fetchListInboxSosmed(page,limit);
      _serviceController.sink.add(listInboxSosmedModel);
    }
  }
  void dispose() {
    _serviceController.close();
    _isDisposed = true;
  }
}



class DetailSosmedBloc extends BaseBloc{
  bool _isDisposed = false;
  final PublishSubject<ListDetailSosmedModel> _serviceController = new PublishSubject<ListDetailSosmedModel>();
  Observable<ListDetailSosmedModel> get getResult => _serviceController.stream;
  fetchListDetailSosmed(var id) async {
    if(_isDisposed) {
      print('false');
    }else{
      ListDetailSosmedModel listDetailSosmedModel =  await repository.fetchListDetailSosmed(id);
      _serviceController.sink.add(listDetailSosmedModel);
    }
  }
  void dispose() {
    _serviceController.close();
    _isDisposed = true;
  }
}

class LikeSosmedBloc extends BaseBloc{
  bool _isDisposed = false;
  final PublishSubject<ListLikeSosmedModel> _serviceController = new PublishSubject<ListLikeSosmedModel>();
  Observable<ListLikeSosmedModel> get getResult => _serviceController.stream;
  fetchListLikeSosmed(var id) async {
    if(_isDisposed) {
      print('false');
    }else{
      ListLikeSosmedModel listLikeSosmedModel =  await repository.fetchListLikeSosmed(id);
      _serviceController.sink.add(listLikeSosmedModel);
    }
  }
  void dispose() {
    _serviceController.close();
    _isDisposed = true;
  }
}


final sosmedBloc  = SosmedBloc();
final detailSosmedBloc  = DetailSosmedBloc();
final inboxSosmedBloc  = InboxSosmedBloc();
final likeSosmedBloc  = LikeSosmedBloc();
