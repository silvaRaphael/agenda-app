import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:agenda/components/my_tab.dart';
import 'package:agenda/components/appointments_list_tile.dart';

import 'package:agenda/utils/week_days.dart';
import 'package:agenda/utils/constants.dart';
import 'package:agenda/utils/appointments.dart';

class CalendarTab extends StatefulWidget {
  final Function(Map<String, dynamic>, DateTime?) openEditScreen;
  final List<dynamic> Function(DateTime) getAppointmentsForDay;
  DateTime? selectedDay;
  final Function(DateTime?) setSelectedDay;
  final Function(bool) multiSelectDays;
  final Function(List<DateTime>) multiSelectedDays;
  final Function(List) setDayAppointments;

  CalendarTab({
    required this.openEditScreen,
    required this.getAppointmentsForDay,
    required this.selectedDay,
    required this.setSelectedDay,
    required this.multiSelectDays,
    required this.multiSelectedDays,
    required this.setDayAppointments,
    super.key,
  });

  @override
  State<CalendarTab> createState() => _CalendarTabState();
}

class _CalendarTabState extends State<CalendarTab> {
  bool multiSelectDays = false;
  DateTime _focusedDay = DateTime.now();
  final List<DateTime> _multiSelectedDays = [];

  List _dayAppointments = [];

  void _getDayAppointments(List<DateTime?> days) {
    List setDayAppointments = [];

    for (var day in days) {
      if (day == null) continue;
      setDayAppointments = widget.getAppointmentsForDay(day);
    }

    setState(() {
      _dayAppointments = setDayAppointments;
    });

    widget.setDayAppointments(_dayAppointments);
  }

  @override
  Widget build(BuildContext context) {
    return MyTab(
      children: [
        Padding(
          padding: const EdgeInsets.all(30),
          child: TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime(2000),
            lastDay: DateTime(2100),
            availableGestures: AvailableGestures.horizontalSwipe,
            weekendDays: const [7, 6],
            startingDayOfWeek: StartingDayOfWeek.sunday,
            eventLoader: widget.getAppointmentsForDay,
            onPageChanged: (focusedDay) {
              setState(() {
                widget.selectedDay = null;
                _focusedDay = focusedDay;
              });
              widget.setSelectedDay(widget.selectedDay);
              widget.multiSelectDays(multiSelectDays);
              widget.multiSelectedDays(_multiSelectedDays);
              _getDayAppointments([widget.selectedDay]);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (selectedDay.month != focusedDay.month) return;
              setState(() {
                if (multiSelectDays) {
                  if (_multiSelectedDays.contains(selectedDay)) {
                    _multiSelectedDays.remove(selectedDay);
                    if (_multiSelectedDays.isEmpty) {
                      multiSelectDays = false;
                    }
                  } else {
                    _multiSelectedDays.add(selectedDay);
                  }
                } else {
                  widget.selectedDay =
                      widget.selectedDay == selectedDay ? null : selectedDay;
                  _focusedDay = focusedDay;
                }
              });
              widget.setSelectedDay(widget.selectedDay);
              widget.multiSelectDays(multiSelectDays);
              widget.multiSelectedDays(_multiSelectedDays);
              _getDayAppointments(
                  multiSelectDays ? _multiSelectedDays : [widget.selectedDay]);
            },
            onDayLongPressed: (selectedDay, focusedDay) {
              if (selectedDay.month != focusedDay.month) return;
              setState(() {
                if (multiSelectDays == true) {
                  _multiSelectedDays.clear();
                  multiSelectDays = false;
                } else {
                  _multiSelectedDays.add(selectedDay);
                  multiSelectDays = true;
                  widget.selectedDay = null;
                  _focusedDay = focusedDay;
                }
              });
              widget.setSelectedDay(widget.selectedDay);
              widget.multiSelectDays(multiSelectDays);
              widget.multiSelectedDays(_multiSelectedDays);
              _getDayAppointments([widget.selectedDay]);
            },
            selectedDayPredicate: (day) {
              return isSameDay(widget.selectedDay, day);
            },
            headerStyle: HeaderStyle(
              titleTextFormatter: (date, locale) =>
                  '${months[date.month - 1]} ${date.year}',
              titleTextStyle: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
              ),
              formatButtonVisible: false,
              titleCentered: true,
              headerPadding: const EdgeInsets.only(bottom: 18),
              leftChevronPadding: const EdgeInsets.all(0),
              rightChevronPadding: const EdgeInsets.all(0),
              leftChevronIcon: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: AppColors.grey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.chevron_left,
                  color: AppColors.primary,
                  size: 32,
                ),
              ),
              rightChevronIcon: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: AppColors.grey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.chevron_right,
                  color: AppColors.primary,
                  size: 32,
                ),
              ),
            ),
            availableCalendarFormats: const {
              CalendarFormat.month: 'Mês',
              CalendarFormat.week: 'Semana',
            },
            calendarBuilders: CalendarBuilders(
              selectedBuilder: (context, day, focusedDay) => MyCalendarDay(
                day: day,
                backgroundColor: Colors.indigo,
                color: AppColors.white,
              ),
              todayBuilder: (context, day, focusedDay) => MyCalendarDay(
                day: day,
                backgroundColor:
                    multiSelectDays && _multiSelectedDays.contains(day)
                        ? Colors.greenAccent[700]
                        : AppColors.grey,
                color: multiSelectDays && _multiSelectedDays.contains(day)
                    ? AppColors.white
                    : AppColors.primary,
              ),
              markerBuilder: (context, day, appointments) {
                if (appointments.isEmpty) return Container();
                int index = 0;

                return Positioned(
                  bottom: 2,
                  child: Row(
                    children: appointments.take(3).map((appointment) {
                      Map<String, dynamic> appointmentMap =
                          appointment as Map<String, dynamic>;
                      index++;

                      if (appointments.length > 3 && index == 3) {
                        return SizedBox(
                          height: 7,
                          child: Icon(
                            Icons.add_circle_outline,
                            color: AppColors.error,
                            size: 8,
                          ),
                        );
                      }

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: appointmentMap['marker'].runtimeType == int
                              ? markers[
                                  appointmentMap['marker']] // Cor do marcador
                              : AppColors.primary,
                        ),
                        width: 7,
                        height: 7,
                      );
                    }).toList(),
                  ),
                );
              },
              // default builders
              dowBuilder: (context, day) => Text(
                weekDays[day.weekday - 1].substring(0, 3),
                style: TextStyle(
                  color: [6, 7].contains(day.weekday)
                      ? AppColors.error
                      : AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
              defaultBuilder: (context, day, focusedDay) => MyCalendarDay(
                day: day,
                backgroundColor:
                    multiSelectDays && _multiSelectedDays.contains(day)
                        ? Colors.greenAccent[700]
                        : null,
                color: multiSelectDays && _multiSelectedDays.contains(day)
                    ? AppColors.white
                    : [6, 7].contains(day.weekday)
                        ? AppColors.error
                        : AppColors.primary,
              ),
            ),
          ),
        ),
        _dayAppointments.isEmpty || widget.selectedDay == null
            ? Container()
            : Column(
                children: [
                  Text(
                    'Agenda do dia ${widget.selectedDay!.day}',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _dayAppointments.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> appointmentMap =
                            _dayAppointments[index] as Map<String, dynamic>;
                        return AppointmentsListTile(
                          appointment: _dayAppointments[index],
                          date: widget.selectedDay!,
                          onTap: () =>
                              widget.openEditScreen(appointmentMap, null),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}

class MyCalendarDay extends StatelessWidget {
  final DateTime day;
  final Color? backgroundColor;
  final Color? color;
  const MyCalendarDay({
    required this.day,
    this.backgroundColor,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              day.day.toString(),
              style: TextStyle(
                color: color ?? AppColors.primary.withOpacity(.75),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
