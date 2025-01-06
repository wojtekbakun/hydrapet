import 'package:flutter/material.dart';
import 'package:hydrapet/model/mini_schedule_model.dart';
import 'package:hydrapet/model/schedule_model.dart';
import 'package:hydrapet/repository/schedule_model_repository.dart';

class ScheduleViewModel extends ChangeNotifier {
  List<ScheduleModel> _schedules = [];
  List<ScheduleModel> get schedules => _schedules;

  DateTime _pickedDate = DateTime.now();
  DateTime get pickedDate => _pickedDate;

  ScheduleRepository repository;
  ScheduleViewModel({required this.repository}) {
    // loadScheduleFromLocalStorage();
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

  void addNewSchedule(MiniScheduleModel newMiniSchedule) {
    // check if date already exists, if yes then add mini schedule to it else add new schedule to days schedule
    if (_schedules.isEmpty) {
      _schedules.add(ScheduleModel(date: _pickedDate, miniSchedule: []));
      addNewMiniSchedule(_schedules[0], newMiniSchedule);
      return;
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

  void editMiniSchedule(int index, MiniScheduleModel newMiniSchedule) {
    getSchedule()?.miniSchedules[index] = newMiniSchedule;
    notifyListeners();
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
