import 'package:thaibah/Model/categoryModel.dart';
import 'package:thaibah/bloc/base.dart';
import 'package:rxdart/rxdart.dart';

class CategoryBloc extends BaseBloc{
  bool _isDisposed = false;
  final PublishSubject<CategoryModel> _serviceController = new PublishSubject<CategoryModel>();
  Observable<CategoryModel> get allCategory => _serviceController.stream;
  fetchCategoryList() async {
    if(_isDisposed) {
      print('false');
    }else{
      CategoryModel categoryModel =  await repository.fetchAllCategory();
      _serviceController.sink.add(categoryModel);
    }
  }
  void dispose() {
    _serviceController.close();
    _isDisposed = true;
  }
}


final categoryBloc  = CategoryBloc();
