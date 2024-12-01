import 'package:flutter/material.dart';
import 'package:hydrapet/data/data_models/schedule_model.dart';
import 'package:hydrapet/data/repository/schedule_model_repository.dart';

class HomePageViewModel extends ChangeNotifier {
  ScheduleModel _schedule = ScheduleModel();
  ScheduleModel get schedule => _schedule;

  ScheduleRepository repository;
  HomePageViewModel({required this.repository});

  void updateWaterAmount(double value) {
    repository.changeWaterAmount(_schedule, value);
    notifyListeners();
  }

  void updateMorningTime(TimeOfDay newTime) {
    repository.changeMorningTime(_schedule, newTime);
    notifyListeners();
  }

  void updateAfternoonTime(TimeOfDay newTime) {
    repository.changeAfternoonTime(_schedule, newTime);
    notifyListeners();
  }

  void updateEveningTime(TimeOfDay newTime) {
    repository.changeEveningTime(_schedule, newTime);
    notifyListeners();
  }

  void loadWaterAmountFromLocalStorage() async {
    try {
      final newSchedule = await repository.getScheduleFromLocalStorage();
      _schedule = newSchedule;
      notifyListeners();
      debugPrint(
          'Wczytano dane z lokalnej bazy danych: ${schedule.morningTime}');
    } catch (e) {
      debugPrint('[vm] Błąd przy pobieraniu z repo: $e');
    }
  }

  //tu zapisujemy wszystkie dane do lokalnej bazy danych (dni, pory, ilosc wody)
  //aktualniue jest tylko ilosc wody bo nie ma jeszcze modeli dla dni i por
  void saveScheduleToLocalStorage() {
    repository.saveScheduleToLocalStorage(_schedule);
    debugPrint('Zapisano dane do lokalnej bazy danych');
  }
}
