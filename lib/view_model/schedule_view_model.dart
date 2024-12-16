import 'package:flutter/material.dart';
import 'package:hydrapet/model/schedule_model.dart';
import 'package:hydrapet/repository/schedule_model_repository.dart';

class ScheduleViewModel extends ChangeNotifier {
  ScheduleModel _schedule = ScheduleModel();
  ScheduleModel get schedule => _schedule;

  ScheduleRepository repository;
  ScheduleViewModel({required this.repository}) {
    loadScheduleFromLocalStorage();
  }

  ScheduleModel getSchedule() {
    return _schedule;
  }

  void setNewSchedule(ScheduleModel newSchedule) {
    _schedule = newSchedule;
    // debugPrint('Ustawiono nowy schedule: ${_schedule.morningTime}');
    notifyListeners();
  }

  void updateWaterAmount(double value) {
    repository.changeWaterAmount(_schedule, value);
    notifyListeners();
  }

  void addNewWateringTime(DateTime newTime) {
    debugPrint("time in vm: $newTime");
    repository.addNewWateringTime(_schedule, newTime);
    notifyListeners();
  }

  Future<void> loadScheduleFromLocalStorage() async {
    try {
      final newSchedule = await repository.loadScheduleModel();
      if (newSchedule != null) {
        setNewSchedule(newSchedule);
      }
      debugPrint(
          'Wczytano dane z lokalnej bazy danych: ${schedule.wateringTimes}');
    } catch (e) {
      debugPrint('[vm] Błąd przy pobieraniu z repo: $e');
    }
  }

  void saveScheduleToLocalStorage() {
    repository.saveScheduleToLocalStorage(_schedule);
    debugPrint("Zapisano dane do pamięci lokalnej");
  }
}