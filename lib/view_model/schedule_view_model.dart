import 'package:flutter/material.dart';
import 'package:hydrapet/model/mini_schedule_model.dart';
import 'package:hydrapet/model/schedule_model.dart';
import 'package:hydrapet/repository/schedule_model_repository.dart';

class ScheduleViewModel extends ChangeNotifier {
  List<ScheduleModel> _schedules = [];
  List<ScheduleModel> get schedules => _schedules;

  DateTime _pickedDate = DateTime.now();
  DateTime get pickedDate => _pickedDate;

  int _defaultWaterAmount = 0;
  int get defaultWaterAmount => _defaultWaterAmount;

  int _maxWaterAmount = 1000;
  int get maxWaterAmount => _maxWaterAmount;

  ScheduleRepository repository;
  ScheduleViewModel({required this.repository}) {
    // loadScheduleFromLocalStorage();
  }

  void setDefaultWaterAmount(int newWaterAmount) {
    _defaultWaterAmount = newWaterAmount;
    notifyListeners();
  }

  void setMaxWaterAmount(int newMaxWaterAmount) {
    _maxWaterAmount = newMaxWaterAmount;
    notifyListeners();
  }

  int getTotalWaterAmount() {
    int totalWaterAmount = 0;
    getSchedule()?.miniSchedules.forEach((element) {
      totalWaterAmount += element.waterAmount.floor();
    });
    return totalWaterAmount;
  }

  void removeMiniSchedule(int index) {
    getSchedule()?.miniSchedules.removeAt(index);
    notifyListeners();
  }

  void setPickedDate(DateTime date) {
    _pickedDate = date;
    debugPrint('Wybrana data: $date');
    notifyListeners();
  }

  int addNewSchedule(MiniScheduleModel newMiniSchedule) {
    // check if date already exists, if yes then add mini schedule to it else add new schedule to days schedule
    // ! check if totalWaterAmount is not greater than maxWaterAmount
    if (getTotalWaterAmount() + newMiniSchedule.waterAmount > maxWaterAmount) {
      debugPrint('Przekroczono maksymalną ilość wody');
      return -1;
    }

    if (_schedules.isEmpty) {
      _schedules.add(ScheduleModel(date: _pickedDate, miniSchedule: []));
      addNewMiniSchedule(_schedules[0], newMiniSchedule);
      return 0;
    }
    for (var i = 0; i < schedules.length;) {
      if (_schedules[i].date == _pickedDate) {
        addNewMiniSchedule(_schedules[i], newMiniSchedule);
        break;
      } else {
        i++;
        if (i == schedules.length) {
          _schedules.add(ScheduleModel(date: _pickedDate, miniSchedule: []));
          addNewMiniSchedule(_schedules[i], newMiniSchedule);
          break;
        }
      }
    }
    debugPrint("time in vm: $_pickedDate, schedule: ${schedules.length}");
    return 0;
  }

  ScheduleModel? getSchedule() {
    for (var i = 0; i < _schedules.length; i++) {
      if (_schedules[i].date == _pickedDate) {
        debugPrint('Znaleziono date: ${_schedules[i].date}');
        debugPrint('Znaleziono miniSchedule: ${_schedules[i].miniSchedules}');
        debugPrint('Łączna ilość wody: ${_schedules[i].totalWaterAmount}');
        return _schedules[i];
      } else {
        _schedules.add(ScheduleModel(date: _pickedDate, miniSchedule: []));
        debugPrint('Dodano date: ${_schedules[i].date}');
      }
    }
    debugPrint('Nie znaleziono schedule dla daty: $_pickedDate');
    return null;
  }

  List<MiniScheduleModel> getMiniSchedules() {
    if (getSchedule() != null) {
      return getSchedule()!.miniSchedules;
    } else {
      return [];
    }
  }

  int editMiniSchedule(int index, MiniScheduleModel newMiniSchedule) {
    if (getTotalWaterAmount() + newMiniSchedule.waterAmount > maxWaterAmount) {
      debugPrint('Przekroczono maksymalną ilość wody');
      return -1;
    }
    getSchedule()?.miniSchedules[index] = newMiniSchedule;

    notifyListeners();
    return 0;
  }

  void addNewMiniSchedule(
      ScheduleModel schedule, MiniScheduleModel newMiniSchedule) {
    schedule.miniSchedules.add(newMiniSchedule);
    notifyListeners();
  }

  // Future<void> loadScheduleFromLocalStorage() async {
  //   try {
  //     final newSchedule = await repository.loadScheduleModel();
  //     if (newSchedule != null) {
  //       setNewSchedule(newSchedule);
  //     }
  //     // debugPrint(
  //     //     'Wczytano dane z lokalnej bazy danych: ${schedule.wateringTimes}');
  //   } catch (e) {
  //     debugPrint('[vm] Błąd przy pobieraniu z repo: $e');
  //   }
  // }

  // void saveScheduleToLocalStorage() {
  //   repository.saveScheduleToLocalStorage(_schedule);
  //   debugPrint("Zapisano dane do pamięci lokalnej");
  // }
}
