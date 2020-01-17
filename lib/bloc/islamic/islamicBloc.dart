import 'package:thaibah/Model/islamic/ayatModel.dart';
import 'package:thaibah/Model/islamic/categoryDoaModel.dart';
import 'package:thaibah/Model/islamic/checkedModel.dart';
import 'package:thaibah/Model/islamic/doaModel.dart';
import 'package:thaibah/Model/islamic/kalenderHijriahModel.dart';
import 'package:thaibah/Model/islamic/subCategoryDoaModel.dart';
import 'package:thaibah/Model/suratModel.dart';
import 'package:thaibah/bloc/base.dart';
import 'package:rxdart/rxdart.dart';

class SuratBloc extends BaseBloc{
  bool _isDisposed = false;
  final PublishSubject<SuratModel> _serviceController = new PublishSubject<SuratModel>();
  Observable<SuratModel> get allSurat => _serviceController.stream;
  fetchSuratList() async {
    if(_isDisposed) {
      print('false');
    }else{
      SuratModel surat =  await repository.fetchSurat();
      _serviceController.sink.add(surat);
    }
  }
  void dispose() {
    _serviceController.close();
    _isDisposed = true;
  }

}


class AyatBloc extends BaseBloc<AyatModel>{
  bool _isDisposed = false;
  final PublishSubject<AyatModel> _serviceController = new PublishSubject<AyatModel>();
  Observable<AyatModel> get allAyat => _serviceController.stream;
  fetchAyatList(var idSurat, var param,var page,var limit) async {
    if(_isDisposed) {
      print('false');
    }else{
      AyatModel ayat =  await repository.fetchAyat(idSurat, param,page,limit);
      _serviceController.sink.add(ayat);
    }
  }
  void dispose() {
    _serviceController.close();
    _isDisposed = true;
  }
}

class CheckFavBloc extends BaseBloc{
  bool _isDisposed = false;
  final PublishSubject<CheckFavModel> _serviceController = new PublishSubject<CheckFavModel>();
  Observable<CheckFavModel> get getResult => _serviceController.stream;
  fetchCheckFav(var param) async {
    if(_isDisposed) {
      print('false');
    }else{
      CheckFavModel checkfav =  await repository.fetchCheckFav(param);
      _serviceController.sink.add(checkfav);
    }
  }
  void dispose() {
    _serviceController.close();
    _isDisposed = true;
  }

}

class CategoryDoaBloc extends BaseBloc{
  bool _isDisposed = false;
  final PublishSubject<CategoryDoaModel> _serviceController = new PublishSubject<CategoryDoaModel>();
  Observable<CategoryDoaModel> get getResult => _serviceController.stream;
  fetchCategoryDoa(var type) async {
    if(_isDisposed) {
      print('false');
    }else{
      CategoryDoaModel categoryDoaModel =  await repository.fetchCategoryDoaHadist(type);
      _serviceController.sink.add(categoryDoaModel);
    }
  }
  void dispose() {
    _serviceController.close();
    _isDisposed = true;
  }

}

class SubCategoryDoaHadistBloc extends BaseBloc{
  bool _isDisposed = false;
  final PublishSubject<SubCategoryDoaModel> _serviceController = new PublishSubject<SubCategoryDoaModel>();
  Observable<SubCategoryDoaModel> get getResult => _serviceController.stream;
  fetchSubCategoryDoaHadist(var type,var id) async {
    if(_isDisposed) {
      print('false');
    }else{
      SubCategoryDoaModel subCategoryDoaModel =  await repository.fetchSubCategoryDoaHadist(type,id);
      _serviceController.sink.add(subCategoryDoaModel);
    }
  }
  void dispose() {
    _serviceController.close();
    _isDisposed = true;
  }

}


class KalenderHijriahBloc extends BaseBloc{
  bool _isDisposed = false;
  final PublishSubject<KalenderHijriahModel> _serviceController = new PublishSubject<KalenderHijriahModel>();
  Observable<KalenderHijriahModel> get getResult => _serviceController.stream;
  fetchKalenderHijriah(var bln, var thn) async {
    if(_isDisposed) {
      print('false');
    }else{
      KalenderHijriahModel kalenderHijriahModel =  await repository.fetchKalendetHijriah(bln, thn);
      _serviceController.sink.add(kalenderHijriahModel);
    }
  }
  void dispose() {
    _serviceController.close();
    _isDisposed = true;
  }

}


class DoaBloc extends BaseBloc{
  bool _isDisposed = false;
  final PublishSubject<DoaModel> _serviceController = new PublishSubject<DoaModel>();
  Observable<DoaModel> get getResult => _serviceController.stream;
  fetchDoa(var type, var id, var q) async {
    if(_isDisposed) {
      print('false');
    }else{
      DoaModel doaModel =  await repository.fetchDoaHadist(type, id, q);
      _serviceController.sink.add(doaModel);
    }
  }
  void dispose() {
    _serviceController.close();
    _isDisposed = true;
  }

}


final suratBloc  = SuratBloc();
final ayatBloc = AyatBloc();
final checkFavBloc = CheckFavBloc();
final categoryDoaBloc = CategoryDoaBloc();
final subCategoryDoaHadistBloc = SubCategoryDoaHadistBloc();
final kalenderHijriahBloc = KalenderHijriahBloc();
final doaBloc = DoaBloc();
