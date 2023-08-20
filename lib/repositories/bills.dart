import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BillsRepository extends ChangeNotifier {
  final Box box = Hive.box('bills');

  int? _paymentTypeFilter;
  int? _selectedDay = DateTime.now().day;

  Map<int, List> get list => getAll();
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

  Map<int, List> getAll() {
    Map<dynamic, dynamic> collection = box.toMap();

    Map<int, List> collectionMap = Map.fromEntries(
      collection.entries.map((entry) {
        List<dynamic> billsList =
            entry.value.map((item) => jsonDecode(item)).toList();

        billsList = billsList
            .where((item) =>
                _paymentTypeFilter == null ||
                item['paymentType'] == _paymentTypeFilter)
            .toList();

        return MapEntry(entry.key, billsList);
      }),
    );

    return collectionMap;
  }

  List dayBills(int? day) {
    if (day == null) return [];

    final billsForDay = list[day];

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
