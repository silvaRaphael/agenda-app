import 'package:agenda/repositories/bills.dart';
import 'package:agenda/widgets/bills_list_tile.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:agenda/widgets/appointments_list_tile.dart';
import 'package:agenda/widgets/my_tab.dart';

import 'package:agenda/repositories/appointments.dart';

import 'package:agenda/utils/week_days.dart';
import 'package:agenda/utils/constants.dart';

class HomeTab extends StatefulWidget {
  final Function(Map<String, dynamic>, List, DateTime) openEditScreen;

  const HomeTab({
    required this.openEditScreen,
    super.key,
  });

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late AppointmentsRepository appointmentsRepository;
  late BillsRepository billsRepository;
  late List weekDayAppointments;

  DateTime now = DateTime.now();

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
    appointmentsRepository = context.watch<AppointmentsRepository>();
    billsRepository = context.watch<BillsRepository>();

    List<List<dynamic>> notificationBillsList = [
      ['Hoje', billsRepository.dayBills(now.day)],
      [
        'Em 1 dia',
        billsRepository.dayBills(now.add(const Duration(days: 1)).day)
      ],
      [
        'Em 2 dias',
        billsRepository.dayBills(now.add(const Duration(days: 2)).day)
      ]
    ];

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
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: monthWeeks.length,
              itemBuilder: (context, index) {
                DateTime week = firstDayOfWeek.add(Duration(days: index * 7));
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  margin: const EdgeInsets.only(top: 24),
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

                          if (weekDayAppointments.isEmpty) {
                            return Container();
                          }

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 30,
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
                                          DateTime.parse('${weekDay}Z'),
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Aqui está suas próximas contas',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: notificationBillsList.length,
              itemBuilder: (context, index) {
                if (notificationBillsList[index][1]?.length == 0) {
                  return Container();
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Text(
                      notificationBillsList[index][0].toString(),
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 8),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: notificationBillsList.length,
                      itemBuilder: (context, childIndex) {
                        int day = DateTime.now().add(Duration(days: index)).day;
                        if (childIndex >
                            notificationBillsList[index][1].length - 1) {
                          return Container();
                        }
                        return BillsListTile(
                          bill: notificationBillsList[index][1]?[childIndex],
                          day: day,
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
