import 'package:flutter/material.dart';
import 'package:hydrapet/models/home_page_model.dart';

class HomePageViewModel extends ChangeNotifier {
  double _waterAmount = 100;
  double get waterAmount => _waterAmount;

  //nie wiem czy tak tworzy sie instancje modelu, do sprawdzenia
  final HomePageModel homePageModel = HomePageModel();

  void setWaterAmount(double value) {
    _waterAmount = value;
    homePageModel.saveWaterAmount(value);
    notifyListeners();
  }

  void loadWaterAmountFromStorage() {
    homePageModel.getWaterAmount().then((value) {
      _waterAmount = value;
      notifyListeners();
    });
  }
}
