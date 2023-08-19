import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:agenda/screens/tabs/home.dart';
import 'package:agenda/screens/tabs/calendar.dart';
import 'package:agenda/screens/add_appointment.dart';
import 'package:agenda/screens/edit_appointment.dart';

import 'package:agenda/components/my_tab.dart';

import 'package:agenda/utils/constants.dart';
import 'package:agenda/utils/models.dart';
import 'package:agenda/utils/api.dart';

class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen>
    with TickerProviderStateMixin {
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

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<DateTime> _multiSelectedDays = [];
  bool multiSelectDays = false;
  bool addAppointmentButtonVisible = false;

  Map<DateTime, List> _appointments = {};
  List _dayAppointments = [];

  void _getDayAppointments(DateTime? day) {
    setState(() {
      _dayAppointments = day == null ? [] : _getAppointmentsForDay(day);
    });
  }

  void _getAppointments() {
    Map<DateTime, List> appointments = AppointmentsRepository(null).getAll();

    setState(() {
      _appointments = appointments;
    });
  }

  List _getAppointmentsForDay(DateTime day) {
    final formattedDay = DateTime(day.year, day.month, day.day);

    final appointmentsForDay = _appointments[formattedDay];

    return appointmentsForDay ?? [];
  }

  void initAppointments(DateTime? day) {
    _getAppointments();
    _getDayAppointments(day);
  }

  void _openAddScreen() {
    List<DateTime> sortedMultiSelectedDays = _multiSelectedDays..sort();

    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => multiSelectDays && _multiSelectedDays.isNotEmpty
            ? AddAppointmentScreen(
                day: sortedMultiSelectedDays.first,
                days: sortedMultiSelectedDays,
              )
            : AddAppointmentScreen(
                day: _selectedDay!,
                usedMarkers: _dayAppointments
                    .map((appointment) => appointment['marker'])
                    .toList(),
              ),
      ),
    ).then((value) {
      setState(() {
        _selectedDay = null;
        if (multiSelectDays) {
          _multiSelectedDays.clear();
          multiSelectDays = false;
        }
      });
      initAppointments(null);
    });
  }

  void _openEditScreen(Map<String, dynamic> appointment, DateTime? day) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => EditAppointmentScreen(
          day: day != null ? DateTime.parse(day.toString()) : _selectedDay!,
          usedMarkers: _dayAppointments
              .map((appointment) => appointment['marker'])
              .toList(),
          appointment: appointment,
        ),
      ),
    ).then((value) {
      setState(() {
        _selectedDay = null;
        if (multiSelectDays) {
          _multiSelectedDays.clear();
          multiSelectDays = false;
        }
      });
      initAppointments(null);
    });
  }

  @override
  void initState() {
    super.initState();

    initAppointments(_focusedDay);
  }

  @override
  Widget build(BuildContext context) {
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
          _selectedDay != null || _multiSelectedDays.isNotEmpty
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
              HomeTab(
                openEditScreen: _openEditScreen,
                getAppointmentsForDay: _getAppointmentsForDay,
                appointments: _appointments,
              ),
              CalendarTab(
                openEditScreen: _openEditScreen,
                getAppointmentsForDay: _getAppointmentsForDay,
                selectedDay: _selectedDay,
                setSelectedDay: (p0) {
                  setState(() {
                    _selectedDay = p0;
                  });
                },
                multiSelectDays: (p0) {
                  setState(() {
                    multiSelectDays = p0;
                  });
                },
                multiSelectedDays: (p0) {
                  setState(() {
                    _multiSelectedDays = p0;
                  });
                },
                setDayAppointments: (p0) {
                  setState(() {
                    _dayAppointments = p0;
                  });
                },
              ),
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
