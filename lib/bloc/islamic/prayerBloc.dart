import 'package:thaibah/Model/islamic/imsakiyahModel.dart';
import 'package:thaibah/bloc/base.dart';
import 'package:rxdart/rxdart.dart';
class PrayerBloc extends BaseBloc<PrayerModel>{
  Observable<PrayerModel> get allPrayer => fetcher.stream;
  fetchPrayerList(var long,var lat) async {
    PrayerModel prayer =  await repository.fetchPrayer(long,lat);
    fetcher.sink.add(prayer);
  }
}

final prayerBloc = PrayerBloc();
