import 'package:thaibah/Model/MLM/getDetailChekoutSuplemenModel.dart';
import 'package:thaibah/bloc/base.dart';
import 'package:rxdart/rxdart.dart';

class DetailChekoutSuplemenBloc extends BaseBloc{
  bool _isDisposed = false;
  final PublishSubject<GetDetailChekoutSuplemenModel> _serviceController = new PublishSubject<GetDetailChekoutSuplemenModel>();
  Observable<GetDetailChekoutSuplemenModel> get getResult => _serviceController.stream;
  fetchDetailChekoutSuplemenList() async {
    if(_isDisposed) {
      print('false');
    }else{
      GetDetailChekoutSuplemenModel detailCheckoutSuplemen =  await repository.fetchDetailCheckoutSuplemen();
      _serviceController.sink.add(detailCheckoutSuplemen);
    }
  }
  void dispose() {
    _serviceController.close();
    _isDisposed = true;
  }
}



final detailChekoutSuplemenBloc  = DetailChekoutSuplemenBloc();
