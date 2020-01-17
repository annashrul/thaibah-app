import 'package:thaibah/Model/inspirationModel.dart';
import 'package:thaibah/bloc/base.dart';
import 'package:rxdart/rxdart.dart';

class InspirationBloc extends BaseBloc{
  bool _isDisposed = false;
  final PublishSubject<InspirationModel> _serviceController = new PublishSubject<InspirationModel>();
  Observable<InspirationModel> get allInspiration => _serviceController.stream;
  fetchInspirationList(var page, var limit) async {
    if(_isDisposed) {
      print('false');
    }else{
      InspirationModel inspiration =  await repository.fetchInspiration(page,limit);
      _serviceController.sink.add(inspiration);
    }
  }
  void dispose() {
    _serviceController.close();
    _isDisposed = true;
  }
}

final inspirationBloc  = InspirationBloc();
