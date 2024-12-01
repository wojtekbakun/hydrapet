import 'package:flutter/material.dart';
import 'package:hydrapet/data/data_models/schedule_model.dart';
import 'package:hydrapet/data/repository/schedule_model_repository.dart';

class HomePageViewModel extends ChangeNotifier {
  ScheduleModel _schedule = ScheduleModel();
  ScheduleModel get schedule => _schedule;

  final Map<PartOfTheDay, TimeOfDay?> _unsavedTimes = {
    PartOfTheDay.morning: null,
    PartOfTheDay.afternoon: null,
    PartOfTheDay.evening: null,
  };

  Map<PartOfTheDay, TimeOfDay?> get unsavedTimes => _unsavedTimes;

  ScheduleRepository repository;
  HomePageViewModel({required this.repository}) {
    loadScheduleFromLocalStorage();
  }

  ScheduleModel getSchedule() {
    return _schedule;
  }

  void setNewSchedule(ScheduleModel newSchedule) {
    _schedule = newSchedule;
    debugPrint('Ustawiono nowy schedule: ${_schedule.morningTime}');
    notifyListeners();
  }

  String getTimeString(PartOfTheDay partOfTheDay) {
    TimeOfDay? time;
    switch (partOfTheDay) {
      case PartOfTheDay.morning:
        time = _schedule.morningTime;
      case PartOfTheDay.afternoon:
        time = _schedule.afternoonTime;
      case PartOfTheDay.evening:
        time = _schedule.eveningTime;
    }
    if (time == null) {
      debugPrint('time is null for $partOfTheDay');
      return 'ustaw';
    } else {
      debugPrint('time is not null for $partOfTheDay: $time');
      return '${time.hour}:${time.minute < 10 ? '0' : ''}${time.minute}';
    }
  }

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

  Future<void> loadScheduleFromLocalStorage() async {
    try {
      final newSchedule = await repository.getScheduleFromLocalStorage();
      setNewSchedule(newSchedule);
      debugPrint(
          'Wczytano dane z lokalnej bazy danych: ${schedule.morningTime} ${schedule.afternoonTime} ${schedule.eveningTime}');
    } catch (e) {
      debugPrint('[vm] Błąd przy pobieraniu z repo: $e');
    }
  }

  void addOnePartOfTheDay(PartOfTheDay partOfTheDay, TimeOfDay newTime) {
    repository.changeTime(_schedule, partOfTheDay, newTime);
    notifyListeners();
  }

  //tu zapisujemy wszystkie dane do lokalnej bazy danych (dni, pory, ilosc wody)
  //aktualniue jest tylko ilosc wody bo nie ma jeszcze modeli dla dni i por
  void saveScheduleToLocalStorage() {
    // for (var part in _unsavedTimes.keys) {
    //   if (_unsavedTimes[part] != null) {
    //     debugPrint('Zapisuje dane dla $part');
    //     repository.changeTime(_schedule, part, _unsavedTimes[part]!);
    //   }
    // }
    repository.saveScheduleToLocalStorage(_schedule);
  }
}
