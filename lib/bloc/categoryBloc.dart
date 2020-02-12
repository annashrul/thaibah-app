import 'package:thaibah/Model/categoryModel.dart';
import 'package:thaibah/bloc/base.dart';
import 'package:rxdart/rxdart.dart';
import 'package:thaibah/resources/categoryProvider.dart';

class CategoryBloc extends BaseBloc{
  bool _isDisposed = false;
  final PublishSubject<CategoryModel> _serviceController = new PublishSubject<CategoryModel>();
  Observable<CategoryModel> get getResult => _serviceController.stream;
  fetchCategoryList() async {
    if(_isDisposed) {
      print('false');
    }else{
      CategoryModel categoryModel =  await repository.fetchAllCategory();
      _serviceController.sink.add(categoryModel);
    }
  }
  dispose() async {
    _serviceController.close();
    _isDisposed = true;
    _serviceController.drain();
  }


//  final CategoryProvider _repository = CategoryProvider();
//  final BehaviorSubject<CategoryModel> getResult =
//  BehaviorSubject<CategoryModel>();
//  fetchCategoryList() async {
//    CategoryModel response = await _repository.fetchCategory();
//    getResult.sink.add(response);
//  }
//  dispose() {
//    getResult.close();
//  }
//  BehaviorSubject<CategoryModel> get subject => getResult;


}


final categoryBloc  = CategoryBloc();
