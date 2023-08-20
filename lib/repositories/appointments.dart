import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AppointmentsRepository extends ChangeNotifier {
  final Box box = Hive.box('appointments');

  DateTime? _selectedDate = DateTime.now();
  bool _isMultiSelectActive = false;
  final List<DateTime> _multiSelectedDates = [];

  Map<DateTime, List> get list => getAll();
  DateTime? get selectedDate => _selectedDate;
  bool get isMultiSelectActive => _isMultiSelectActive;
  List<DateTime> get multiSelectedDates => _multiSelectedDates;

  void setSelectedDate(DateTime? date) {
    _selectedDate = date;

    notifyListeners();
  }

  void setIsMultiSelectActive(bool isActive) {
    _isMultiSelectActive = isActive;

    notifyListeners();
  }

  void setMultiSelectedDates(DateTime date) {
    if (_multiSelectedDates.contains(date)) {
      _multiSelectedDates.remove(date);
      if (_multiSelectedDates.isEmpty) {
        setIsMultiSelectActive(false);
      }
    } else {
      _multiSelectedDates.add(date);
    }

    notifyListeners();
  }

  Map<DateTime, List> getAll() {
    Map<dynamic, dynamic> collection = box.toMap();

    Map<DateTime, List> collectionMap =
        Map.fromEntries(collection.entries.map((entry) {
      DateTime dateTime = DateTime.parse(entry.key);
      final formattedDay =
          DateTime(dateTime.year, dateTime.month, dateTime.day);

      List<dynamic> eventList =
          entry.value.map((item) => jsonDecode(item)).toList();

      return MapEntry(formattedDay, eventList);
    }));

    return collectionMap;
  }

  List dayAppointments(DateTime? date) {
    if (date == null) return [];

    final formattedDate = DateTime(date.year, date.month, date.day);

    final appointmentsForDate = list[formattedDate];

    return appointmentsForDate ?? [];
  }

  void create(dynamic body, {required DateTime date}) {
    List collection = box.get(date.toString()) ?? [];

    collection.add(jsonEncode(body));

    box.put(date.toString(), collection);

    notifyListeners();
  }

  void update(dynamic body, {required DateTime date, required String id}) {
    List collection = box.get(date.toString()) ?? [];

    int index = collection.indexWhere((element) {
      Map<String, dynamic> parsedElement = jsonDecode(element);
      return parsedElement['id'] == id;
    });

    if (index != -1) {
      collection[index] = jsonEncode(body);

      box.put(date.toString(), collection);
    }

    notifyListeners();
  }

  void delete({required DateTime date, required String id}) {
    List collection = box.get(date.toString()) ?? [];

    int index = collection.indexWhere((element) {
      Map<String, dynamic> parsedElement = jsonDecode(element);
      return parsedElement['id'] == id;
    });

    if (index != -1) {
      collection.removeAt(index);

      box.put(date.toString(), collection);
    }

    notifyListeners();
  }
}
