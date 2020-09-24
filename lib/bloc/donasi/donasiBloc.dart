import 'package:thaibah/Model/donasi/listDonasiModel.dart';
import 'package:thaibah/bloc/base.dart';
import 'package:rxdart/rxdart.dart';

class ListDonasiBloc extends BaseBloc<ListDonasiModel>{
  Observable<ListDonasiModel> get getResult => fetcher.stream;
  fetchListDonasi(var where) async {
    ListDonasiModel listDonasiModel =  await repository.fetchListDonasi(where);
    fetcher.sink.add(listDonasiModel);
  }
}

final listDonasiBloc   = ListDonasiBloc();
