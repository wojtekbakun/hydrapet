import 'package:flutter/material.dart';
import 'package:hydrapet/models/home_page_model.dart';

class HomePageViewModel extends ChangeNotifier {
  double _waterAmount = 100;
  double get waterAmount => _waterAmount;

  //nie wiem czy tak tworzy sie (profesjonalnie) instancje modelu, do sprawdzenia
  final HomePageModel homePageModel = HomePageModel();

  void updateWaterAmount(double value) {
    _waterAmount = value;
    notifyListeners();
  }

  void loadWaterAmountFromLocalStorage() {
    homePageModel.getWaterAmount().then(
      (value) {
        _waterAmount = value;
        notifyListeners();
      },
    );
  }

  //tu zapisujemy wszystkie dane do lokalnej bazy danych (dni, pory, ilosc wody)
  //aktualniue jest tylko ilosc wody bo nie ma jeszcze modeli dla dni i por
  void saveAllDataToLocalStorage() {
    debugPrint('Zapisano dane do lokalnej bazy danych');
    homePageModel.saveWaterAmount(_waterAmount);
  }

  void loadAllDataFromLocalStorage() {
    debugPrint('Załadowano dane z lokalnej bazy danych');
    loadWaterAmountFromLocalStorage();
  }
}
