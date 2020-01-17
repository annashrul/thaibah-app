import 'package:rxdart/rxdart.dart';
import 'package:thaibah/Model/islamic/nearbyMosqueModel.dart';
import 'package:thaibah/bloc/base.dart';

class NearbyMosqueBloc extends BaseBloc{
  bool _isDisposed = false;
  final PublishSubject<NearbyMosqueModel> _serviceController = new PublishSubject<NearbyMosqueModel>();
  Observable<NearbyMosqueModel> get getResult => _serviceController.stream;
  fetchCariSurat(var lat, var lng) async {
    if(_isDisposed) {
      print('false');
    }else{
      NearbyMosqueModel nearbyMosque =  await repository.fetchAllNearbyMosque(lat, lng);
      _serviceController.sink.add(nearbyMosque);
    }
  }
  void dispose() {
    _serviceController.close();
    _isDisposed = true;
  }

}
final nearbyMosqueBloc  = NearbyMosqueBloc();
