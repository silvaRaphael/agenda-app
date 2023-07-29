import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

class AppointmentsRepository {
  final dynamic key;
  AppointmentsRepository(this.key);

  Box appointments = Hive.box('appointments');

  Map<DateTime, List> getAll() {
    Map<dynamic, dynamic> collection = appointments.toMap();

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

  dynamic getOne({required String id}) {
    List collection = appointments.get(key.toString()) ?? [];

    int index = collection.indexWhere((element) {
      Map<String, dynamic> parsedElement = jsonDecode(element);
      return parsedElement['id'] == id;
    });

    return collection[index] ?? [];
  }

  void create(dynamic body) {
    List collection = appointments.get(key.toString()) ?? [];

    collection.add(jsonEncode(body));

    appointments.put(key.toString(), collection);
  }

  void update(dynamic body, {required String id}) {
    List collection = appointments.get(key.toString()) ?? [];

    int index = collection.indexWhere((element) {
      Map<String, dynamic> parsedElement = jsonDecode(element);
      return parsedElement['id'] == id;
    });

    if (index != -1) {
      collection[index] = jsonEncode(body);

      appointments.put(key.toString(), collection);
    }
  }

  void delete({required String id}) {
    List collection = appointments.get(key.toString()) ?? [];

    int index = collection.indexWhere((element) {
      Map<String, dynamic> parsedElement = jsonDecode(element);
      return parsedElement['id'] == id;
    });

    if (index != -1) {
      collection.removeAt(index);

      appointments.put(key.toString(), collection);
    }
  }
}
