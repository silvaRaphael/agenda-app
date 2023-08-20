import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:agenda/widgets/my_tab.dart';
import 'package:agenda/widgets/appointments_list_tile.dart';

import 'package:agenda/repositories/appointments.dart';

import 'package:agenda/utils/week_days.dart';
import 'package:agenda/utils/constants.dart';
import 'package:agenda/utils/appointments.dart';

class CalendarTab extends StatefulWidget {
  final Function(Map<String, dynamic>, List, DateTime) openEditScreen;

  const CalendarTab({
    required this.openEditScreen,
    super.key,
  });

  @override
  State<CalendarTab> createState() => _CalendarTabState();
}

class _CalendarTabState extends State<CalendarTab> {
  late AppointmentsRepository appointmentsRepository;
  late List dayAppointments;

  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    appointmentsRepository = context.watch<AppointmentsRepository>();

    dayAppointments = appointmentsRepository
        .dayAppointments(appointmentsRepository.selectedDate);

    return MyTab(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime(2000),
            lastDay: DateTime(2100),
            availableGestures: AvailableGestures.horizontalSwipe,
            weekendDays: const [7, 6],
            startingDayOfWeek: StartingDayOfWeek.sunday,
            eventLoader: appointmentsRepository.dayAppointments,
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
              appointmentsRepository.setSelectedDate(null);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (selectedDay.month != focusedDay.month) return;

              if (appointmentsRepository.isMultiSelectActive) {
                appointmentsRepository.setMultiSelectedDates(selectedDay);
              } else {
                if (appointmentsRepository.selectedDate == selectedDay) {
                  appointmentsRepository.setSelectedDate(null);
                } else {
                  appointmentsRepository.setSelectedDate(selectedDay);
                }
                _focusedDay = focusedDay;
              }
            },
            onDayLongPressed: (selectedDay, focusedDay) {
              if (selectedDay.month != focusedDay.month) return;

              if (appointmentsRepository.isMultiSelectActive) {
                appointmentsRepository.setIsMultiSelectActive(false);
                appointmentsRepository.multiSelectedDates.clear();
              } else {
                appointmentsRepository.setSelectedDate(null);
                appointmentsRepository.setIsMultiSelectActive(true);
                appointmentsRepository.setMultiSelectedDates(selectedDay);
                _focusedDay = focusedDay;
              }
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
              todayBuilder: dayBuilder,
              defaultBuilder: dayBuilder,
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
              // weekend days
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
            ),
          ),
        ),
        dayAppointments.isEmpty || appointmentsRepository.selectedDate == null
            ? Container()
            : Column(
                children: [
                  Text(
                    'Agenda do dia ${appointmentsRepository.selectedDate!.day}',
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
                      itemCount: dayAppointments.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> appointmentMap =
                            dayAppointments[index] as Map<String, dynamic>;
                        return AppointmentsListTile(
                          appointment: dayAppointments[index],
                          date: appointmentsRepository.selectedDate!,
                          onTap: () => widget.openEditScreen(
                            appointmentMap,
                            appointmentsRepository.dayAppointments(
                              appointmentsRepository.selectedDate,
                            ),
                            appointmentsRepository.selectedDate!,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ],
    );
  }

  MyCalendarDay? dayBuilder(
      BuildContext context, DateTime day, DateTime focusedDay) {
    day = DateTime(day.year, day.month, day.day);
    DateTime? selectedDate = appointmentsRepository.selectedDate;

    if (appointmentsRepository.selectedDate != null) {
      selectedDate = DateTime(
        appointmentsRepository.selectedDate!.year,
        appointmentsRepository.selectedDate!.month,
        appointmentsRepository.selectedDate!.day,
      );
    }

    if (selectedDate == day) {
      return MyCalendarDay(
        day: day,
        backgroundColor: Colors.indigo,
        color: AppColors.white,
      );
    }

    if (appointmentsRepository.isMultiSelectActive &&
        appointmentsRepository.multiSelectedDates
            .contains(DateTime.parse('${day}Z'))) {
      return MyCalendarDay(
        day: day,
        backgroundColor: Colors.greenAccent[700],
        color: AppColors.white,
      );
    }

    DateTime now = DateTime.now();
    if (now.day == day.day) {
      return MyCalendarDay(
        day: day,
        backgroundColor: Colors.grey[500],
        color: AppColors.white,
      );
    }

    return MyCalendarDay(
      day: day,
      backgroundColor: appointmentsRepository.isMultiSelectActive &&
              appointmentsRepository.multiSelectedDates.contains(day)
          ? Colors.greenAccent[700]
          : null,
      color: appointmentsRepository.isMultiSelectActive &&
              appointmentsRepository.multiSelectedDates.contains(day)
          ? AppColors.white
          : [6, 7].contains(day.weekday)
              ? AppColors.error
              : AppColors.primary,
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
