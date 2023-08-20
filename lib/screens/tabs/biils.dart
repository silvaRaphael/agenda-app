import 'package:agenda/repositories/bills.dart';
import 'package:agenda/utils/week_days.dart';
import 'package:agenda/widgets/bills_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

import 'package:agenda/widgets/my_tab.dart';

import 'package:agenda/utils/constants.dart';

class BillsTab extends StatefulWidget {
  final Function(Map<String, dynamic>, List, DateTime) openEditScreen;

  const BillsTab({
    required this.openEditScreen,
    super.key,
  });

  @override
  State<BillsTab> createState() => _BillsTabState();
}

class _BillsTabState extends State<BillsTab> {
  late BillsRepository billsRepository;

  final ScrollController _monthDaysListController = ScrollController();

  double _calculateMonthDayListOffSet(int? day) {
    day ??= DateTime.now().day;
    int dayOffset = day * (40 + 10) - 10;
    int lastDayOffset = 31 * (40 + 10) - 10;
    double screenCenter = MediaQuery.of(context).size.width / 2;

    if (dayOffset < screenCenter) {
      return 0;
    }
    if (dayOffset > lastDayOffset - screenCenter) {
      return (lastDayOffset - screenCenter * 2 + 40).toDouble();
    }
    return dayOffset - screenCenter;
  }

  void _scrollMonthDaysListController(int? day, Duration? duration) {
    WidgetsBinding.instance.addPostFrameCallback((context) {
      _monthDaysListController.animateTo(
        _calculateMonthDayListOffSet(day),
        duration: duration ?? const Duration(microseconds: 1),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void initState() {
    super.initState();

    _scrollMonthDaysListController(null, null);
  }

  @override
  void dispose() {
    _monthDaysListController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    billsRepository = context.watch<BillsRepository>();

    _scrollMonthDaysListController(
      billsRepository.selectedDay,
      const Duration(milliseconds: 250),
    );

    return MyTab(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '${NumberFormat.currency(
                  locale: 'pt_BR',
                  symbol: 'R\$',
                ).format(3142)} em contas no mês',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 40,
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: 31,
                controller: _monthDaysListController,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  bool isToday = DateTime.now().day == index + 1;
                  bool isSelected = billsRepository.selectedDay == index + 1;

                  return GestureDetector(
                    onTap: () {
                      billsRepository
                          .setSelectedDay(isSelected ? null : index + 1);
                    },
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.indigo
                              : isToday
                                  ? Colors.grey[500]
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(
                            (index + 1).toString().padLeft(2, '0'),
                            style: TextStyle(
                              color: isToday || isSelected
                                  ? AppColors.white
                                  : AppColors.primary.withOpacity(.75),
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 26),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 30,
                itemBuilder: (context, index) {
                  int day = index + 1;

                  if (billsRepository.list[day] == null) {
                    return Container();
                  }

                  DateTime now = DateTime.now();

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 30,
                        child: Text(
                          '$day\n${weekDaysMondayFirst[DateTime(now.year, now.month, day).weekday - 1].substring(0, 3)}',
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
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: billsRepository.list[day]?.length,
                            itemBuilder: (context, index) {
                              if (billsRepository.list[day] == null) {
                                return Container();
                              }

                              return BillsListTile(
                                bill: billsRepository.list[day]?[index],
                                day: day,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
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
