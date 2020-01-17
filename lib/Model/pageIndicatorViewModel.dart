//view model for page indicator
import 'package:thaibah/Model/pageViewModel.dart';
import 'package:thaibah/Constants/constants.dart';

class PagerIndicatorViewModel {
  final List<PageViewModel> pages;
  final int activeIndex;
  final SlideDirection slideDirection;
  final double slidePercent;

  PagerIndicatorViewModel(
      this.pages,
      this.activeIndex,
      this.slideDirection,
      this.slidePercent,
      );
}
