import 'package:agenda/screens/add_bill.dart';
import 'package:agenda/screens/tabs/edit_bill.dart';
import 'package:agenda/widgets/bills_list_tile.dart';
import 'package:agenda/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'package:agenda/screens/tabs/home.dart';
import 'package:agenda/screens/tabs/calendar.dart';
import 'package:agenda/screens/add_appointment.dart';
import 'package:agenda/screens/edit_appointment.dart';
import 'package:agenda/screens/tabs/biils.dart';

import 'package:agenda/repositories/appointments.dart';
import 'package:agenda/repositories/bills.dart';

import 'package:agenda/utils/constants.dart';
import 'package:agenda/utils/models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AppointmentsRepository appointmentsRepository;
  late BillsRepository billsRepository;

  int _tabIndex = 0;
  DateTime now = DateTime.now();

  final List<ModelNavBarItem> _bottomNavBarItemsList = const [
    ModelNavBarItem(
      index: 0,
      icon: Icons.home_outlined,
      iconActive: Icons.home_rounded,
    ),
    ModelNavBarItem(
      index: 1,
      icon: Icons.event_outlined,
      iconActive: Icons.event_rounded,
    ),
    ModelNavBarItem(
      index: 2,
      icon: Icons.attach_money_outlined,
      iconActive: Icons.attach_money_rounded,
    ),
  ];

  void _openAddAppointmentScreen() {
    List<DateTime> sortedMultiSelectedDays =
        appointmentsRepository.multiSelectedDates..sort();

    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => appointmentsRepository.isMultiSelectActive &&
                sortedMultiSelectedDays.isNotEmpty
            ? AddAppointmentScreen(
                date: sortedMultiSelectedDays.first,
                dates: sortedMultiSelectedDays,
              )
            : AddAppointmentScreen(
                date: appointmentsRepository.selectedDate!,
                usedMarkers: appointmentsRepository
                    .dayAppointments(appointmentsRepository.selectedDate)
                    .map((appointment) => appointment['marker'])
                    .toList(),
              ),
      ),
    );
  }

  void _openEditAppointmentScreen(
      Map<String, dynamic> appointment, List dayAppointments, DateTime date) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => EditAppointmentScreen(
          date: DateTime.parse(date.toString()),
          usedMarkers: dayAppointments
              .map((appointment) => appointment['marker'])
              .toList(),
          appointment: appointment,
        ),
      ),
    );
  }

  void _openAddBillScreen() {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => AddBillScreen(
          day: billsRepository.selectedDay!,
        ),
      ),
    );
  }

  void _openEditBillScreen(Map<String, dynamic> bill, int day) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => EditBillScreen(day: day, bill: bill),
      ),
    );
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

    int notificationCount = 0;
    for (var element in notificationBillsList) {
      element[1].forEach((item) {
        notificationCount += 1;
      });
    }

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppColors.white,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: AppColors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Text(getCurrentGreeting()),
        ),
        titleTextStyle: TextStyle(
          color: AppColors.primary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        foregroundColor: AppColors.primary,
        centerTitle: false,
        backgroundColor: AppColors.white,
        elevation: 0,
        actions: [
          _tabIndex == 1 && appointmentsRepository.selectedDate != null ||
                  appointmentsRepository.multiSelectedDates.isNotEmpty
              ? appBarAddButton(_openAddAppointmentScreen)
              : Container(),
          _tabIndex == 2 && billsRepository.selectedDay != null
              ? appBarAddButton(_openAddBillScreen)
              : Container(),
          Stack(
            children: [
              notificationCount == 0
                  ? Container()
                  : Positioned(
                      top: 10,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.dark.withOpacity(1),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          notificationCount.toString(),
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Builder(builder: (context) {
                  return GestureDetector(
                    onTap: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.black12,
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Icon(
                          Icons.notifications_none_rounded,
                          size: 18,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
      endDrawer: Drawer(
        width: MediaQuery.of(context).size.width * .7,
        backgroundColor: AppColors.white,
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: notificationCount == 0
                  ? Text(
                      'Nenhuma notificação ainda',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.start,
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Você tem contas à vencer',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 12),
                        ListView.builder(
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
                                  itemCount:
                                      notificationBillsList[index][1].length,
                                  itemBuilder: (context, childIndex) {
                                    int day = DateTime.now()
                                        .add(Duration(days: index))
                                        .day;
                                    return BillsListTile(
                                      bill: notificationBillsList[index][1]
                                          ?[childIndex],
                                      day: day,
                                      onTap: () {
                                        billsRepository.setSelectedDay(day);
                                        Scaffold.of(context).closeEndDrawer();
                                        if (_tabIndex != 2) {
                                          setState(() {
                                            _tabIndex = 2;
                                          });
                                        }
                                      },
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: [
              HomeTab(openEditScreen: _openEditAppointmentScreen),
              CalendarTab(openEditScreen: _openEditAppointmentScreen),
              BillsTab(openEditScreen: _openEditBillScreen),
            ][_tabIndex],
          ),
          Positioned(
            left: 10,
            right: 10,
            bottom: 10,
            child: BottomNavBar(
              bottomNavBarItemsList: _bottomNavBarItemsList,
              tabIndex: _tabIndex,
              onTap: (int index) {
                setState(() {
                  _tabIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget appBarAddButton(void Function()? onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: GestureDetector(
        onTap: onTap,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.black12,
              ),
              borderRadius: BorderRadius.circular(100),
            ),
            child: const Icon(
              Icons.add,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}
