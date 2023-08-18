import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:agenda/utils/appointments.dart';
import 'package:agenda/utils/models.dart';

class MyCalendar extends StatelessWidget {
  const MyCalendar({
    Key? key,
    required this.focusedDay,
    required this.billsOfMonth,
    required this.onDaySelected,
    required this.onPageChanged,
  }) : super(key: key);

  final DateTime focusedDay;
  final List<ModelAgendamento> billsOfMonth;
  final OnDaySelected onDaySelected;
  final Function(DateTime)? onPageChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: TableCalendar(
        locale: 'pt_BR',
        focusedDay: focusedDay,
        firstDay: DateTime(2000),
        lastDay: DateTime(2100),
        onDaySelected: onDaySelected,
        onPageChanged: onPageChanged,
        availableGestures: AvailableGestures.horizontalSwipe,
        headerStyle: HeaderStyle(
          titleTextFormatter: (date, locale) =>
              '${months[date.month - 1]} ${date.year}',
          titleTextStyle: const TextStyle(fontWeight: FontWeight.w500),
          formatButtonVisible: false,
          titleCentered: true,
          headerPadding: const EdgeInsets.only(bottom: 18),
          leftChevronPadding: const EdgeInsets.all(0),
          rightChevronPadding: const EdgeInsets.all(0),
          leftChevronIcon: Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.chevron_left,
              color: Colors.white,
              size: 32,
            ),
          ),
          rightChevronIcon: Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.chevron_right,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
        weekendDays: const [7, 6],
        daysOfWeekStyle: DaysOfWeekStyle(
          dowTextFormatter: (date, locale) =>
              DateFormat.E('pt_BR')
                  .format(date)
                  .toLowerCase()[0]
                  .toUpperCase() +
              DateFormat.E('pt_BR').format(date).toLowerCase().substring(1, 3),
          weekendStyle: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        /* calendarBuilders: CalendarBuilders(
            /* markerBuilder: (context, day, events) {
            int index = 0;
            int sameDayBills = 0;
            List sameDayBillsTypes = [];

            for (var element in billsOfMonth) {
              if (DateTime.parse(element.date.toString().substring(0, 23))
                  .isAtSameMomentAs(
                      DateTime.parse(day.toString().substring(0, 23)))) {
                sameDayBills++;
                sameDayBillsTypes.add(element.type);
              }

              if (index == billsOfMonth.length - 1) {
                return SizedBox(
                  height: 8,
                  child: Center(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: sameDayBills <= 3 ? sameDayBills : 3,
                      itemBuilder: (context, index) {
                        if (index == 2 && sameDayBills > 3) {
                          return Container(
                            height: 8,
                            width: 8,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 8,
                            ),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 1),
                          child: Container(
                            height: 8,
                            width: sameDayBills == 1
                                ? 24
                                : sameDayBills == 2
                                    ? 12
                                    : 8,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }
              index++;
            }
            return null;
          }, */
            /* todayBuilder: (context, day, focusedDay) {
            return AspectRatio(
              aspectRatio: 1,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      day.day.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }, */
            /* defaultBuilder: (context, day, focusedDay) {
            return AspectRatio(
              aspectRatio: 1,
              child: Center(
                child: Text(
                  day.day.toString(),
                ),
              ),
            );
          }, */
            ), */
      ),
    );
  }
}
