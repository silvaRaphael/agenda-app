import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'package:agenda/screens/tabs/home.dart';
import 'package:agenda/screens/tabs/calendar.dart';
import 'package:agenda/screens/add_appointment.dart';
import 'package:agenda/screens/edit_appointment.dart';

import 'package:agenda/repositories/appointments.dart';

import 'package:agenda/components/my_tab.dart';

import 'package:agenda/utils/constants.dart';
import 'package:agenda/utils/models.dart';

class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen>
    with TickerProviderStateMixin {
  late AppointmentsRepository appointmentsRepository;

  int _tabIndex = 0;

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

  void _openAddScreen() {
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

  void _openEditScreen(
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

  @override
  Widget build(BuildContext context) {
    appointmentsRepository = context.watch<AppointmentsRepository>();

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
              ? Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: GestureDetector(
                    onTap: _openAddScreen,
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
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {},
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
                    Icons.calendar_month_outlined,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: [
              HomeTab(openEditScreen: _openEditScreen),
              CalendarTab(openEditScreen: _openEditScreen),
              const MyTab(
                children: [
                  Center(
                    child: Text('Cobranças'),
                  ),
                ],
              ),
            ][_tabIndex],
          ),
          // bottom navbar
          Positioned(
            left: 10,
            right: 10,
            bottom: 10,
            child: SizedBox(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 3,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.grey,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: _bottomNavBarItemsList.map((item) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _tabIndex = item.index;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: item.index == _tabIndex
                                ? AppColors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Icon(
                            item.index == _tabIndex
                                ? item.iconActive
                                : item.icon,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
