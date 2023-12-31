import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BillsRepository extends ChangeNotifier {
  final Box box = Hive.box('bills');

  int? _paymentTypeFilter;
  int? _selectedDay;

  Map<int, List> get list => getAll();
  Map<int, List> get notificationList => getAll(filters: false);
  double get totalValue {
    double total = 0;
    list.forEach((key, value) {
      for (var element in value) {
        total += element['value'] ?? 0;
      }
    });
    return total;
  }

  int? get paymentTypeFilter => _paymentTypeFilter;
  int? get selectedDay => _selectedDay;

  void setPaymentTypeFilter(int? paymentTypeFilter) {
    _paymentTypeFilter = paymentTypeFilter;

    notifyListeners();
  }

  void setSelectedDay(int? day) {
    _selectedDay = day;

    notifyListeners();
  }

  Map<int, List> getAll({bool filters = true}) {
    Map<dynamic, dynamic> collection = box.toMap();

    Map<int, List> collectionMap = Map.fromEntries(
      collection.entries.map((entry) {
        List<dynamic> billsList =
            entry.value.map((item) => jsonDecode(item)).toList();

        if (filters) {
          if (_paymentTypeFilter != null) {
            billsList = billsList
                .where((item) => item['paymentType'] == _paymentTypeFilter)
                .toList();
          }

          if (_selectedDay != null) {
            billsList =
                billsList.where((item) => entry.key == _selectedDay).toList();
          }
        }

        return MapEntry(entry.key, billsList);
      }),
    );

    return collectionMap;
  }

  List dayBills(int? day) {
    if (day == null) return [];

    final billsForDay = notificationList[day];

    return billsForDay ?? [];
  }

  void create(dynamic body, {required int day}) {
    List collection = box.get(day) ?? [];

    collection.add(jsonEncode(body));

    box.put(day, collection);

    notifyListeners();
  }

  void update(dynamic body, {required int day, required String id}) {
    List collection = box.get(day) ?? [];

    int index = collection.indexWhere((element) {
      Map<String, dynamic> parsedElement = jsonDecode(element);
      return parsedElement['id'] == id;
    });

    if (index != -1) {
      collection[index] = jsonEncode(body);

      box.put(day, collection);
    }

    notifyListeners();
  }

  void delete({required int day, required String id}) {
    List collection = box.get(day) ?? [];

    int index = collection.indexWhere((element) {
      Map<String, dynamic> parsedElement = jsonDecode(element);
      return parsedElement['id'] == id;
    });

    if (index != -1) {
      collection.removeAt(index);

      box.put(day, collection);
    }

    notifyListeners();
  }
}
