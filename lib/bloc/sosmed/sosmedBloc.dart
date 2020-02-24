import 'package:thaibah/Model/sosmed/listCommentSosmedModel.dart';
import 'package:thaibah/Model/sosmed/listSosmedModel.dart';
import 'package:thaibah/bloc/base.dart';
import 'package:rxdart/rxdart.dart';

class SosmedBloc extends BaseBloc{
  bool _isDisposed = false;
  final PublishSubject<ListSosmedModel> _serviceController = new PublishSubject<ListSosmedModel>();
  Observable<ListSosmedModel> get getResult => _serviceController.stream;
  fetchListSosmed(var page, var limit) async {
    if(_isDisposed) {
      print('false');
    }else{
      ListSosmedModel listSosmedModel =  await repository.fetchListSosmed(page,limit);
      _serviceController.sink.add(listSosmedModel);
    }
  }
  void dispose() {
    _serviceController.close();
    _isDisposed = true;
  }
}
class CommentSosmedBloc extends BaseBloc{
  bool _isDisposed = false;
  final PublishSubject<ListCommentSosmedModel> _serviceController = new PublishSubject<ListCommentSosmedModel>();
  Observable<ListCommentSosmedModel> get getResult => _serviceController.stream;
  fetchListCommentSosmed(var id) async {
    if(_isDisposed) {
      print('false');
    }else{
      ListCommentSosmedModel listCommentSosmedModel =  await repository.fetchListCommentSosmed(id);
      _serviceController.sink.add(listCommentSosmedModel);
    }
  }
  void dispose() {
    _serviceController.close();
    _isDisposed = true;
  }
}



final sosmedBloc  = SosmedBloc();
final commentSosmedBloc  = CommentSosmedBloc();
