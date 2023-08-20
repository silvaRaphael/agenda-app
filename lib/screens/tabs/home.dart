import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:agenda/components/appointments_list_tile.dart';
import 'package:agenda/components/my_tab.dart';

import 'package:agenda/repositories/appointments.dart';

import 'package:agenda/utils/week_days.dart';
import 'package:agenda/utils/constants.dart';

class HomeTab extends StatefulWidget {
  final Function(Map<String, dynamic>, List, DateTime) openEditScreen;
  final List<dynamic> Function(DateTime day) getAppointmentsForDay;
  final Map<DateTime, List> appointments;

  const HomeTab({
    required this.openEditScreen,
    required this.getAppointmentsForDay,
    required this.appointments,
    super.key,
  });

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late List weekDayAppointments;

  DateTime firstDayOfWeek = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day - DateTime.now().weekday % 7,
  );

  DateTime lastDayOfMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month + 1,
    0,
  );

  late int remainingWeeks;

  List monthWeeks = [];

  @override
  void initState() {
    super.initState();

    remainingWeeks = ((lastDayOfMonth.difference(DateTime.now()).inDays +
                DateTime.now().weekday) /
            7)
        .ceil();

    monthWeeks = List.generate(remainingWeeks, (index) => 1);
  }

  @override
  Widget build(BuildContext context) {
    return MyTab(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Aqui está a sua agenda do mês',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(height: 26),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: monthWeeks.length,
              itemBuilder: (context, index) {
                DateTime week = firstDayOfWeek.add(Duration(days: index * 7));
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  margin: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 14,
                        ),
                        child: Text(
                          'Dia ${week.day} a ${week.add(const Duration(days: 6)).day}',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 7,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          DateTime weekDay = week.add(Duration(days: index));

                          weekDayAppointments = context
                              .watch<AppointmentsRepository>()
                              .dayAppointments(weekDay);

                          print(weekDay);
                          print(weekDayAppointments);

                          if (weekDayAppointments.isEmpty) {
                            return Container();
                          }

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 26,
                                child: Text(
                                  '${weekDay.day}\n${weekDays[index].substring(0, 3)}',
                                  style: TextStyle(
                                    color: AppColors.primary.withOpacity(.5),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.only(
                                    left: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(
                                        color: AppColors.dark,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: weekDayAppointments.length,
                                    itemBuilder: (context, index) {
                                      Map<String, dynamic> appointmentMap =
                                          weekDayAppointments[index]
                                              as Map<String, dynamic>;
                                      return AppointmentsListTile(
                                        appointment: weekDayAppointments[index],
                                        date: weekDay,
                                        onTap: () => widget.openEditScreen(
                                          appointmentMap,
                                          weekDayAppointments,
                                          weekDay,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
