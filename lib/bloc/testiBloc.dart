import 'package:thaibah/Model/tertimoniModel.dart';
import 'package:thaibah/bloc/base.dart';

import 'package:rxdart/rxdart.dart';

class TestiBloc extends BaseBloc<TestimoniModel>{
  Observable<TestimoniModel> get allTesti => fetcher.stream;

  fetchTesti(var param,var page, var limit) async {
    TestimoniModel promosi =  await repository.fetchTesti(param,page,limit);
    fetcher.sink.add(promosi);
  }

}

final testiBloc = TestiBloc();