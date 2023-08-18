import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:table_calendar/table_calendar.dart';

import 'package:agenda/screens/add_appointment.dart';
import 'package:agenda/screens/edit_appointment.dart';

import 'package:agenda/components/app_bar.dart';

import 'package:agenda/utils/appointments.dart';
import 'package:agenda/utils/constants.dart';
import 'package:agenda/utils/api.dart';
import 'package:agenda/utils/week_days.dart';

class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool addAppointmentButtonVisible = false;
  bool multiSelectDays = false;

  DateTime firstDayOfWeek = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day - DateTime.now().weekday % 7);
  DateTime lastDayOfMonth =
      DateTime(DateTime.now().year, DateTime.now().month + 1, 0);

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final List<DateTime> _multiSelectedDays = [];

  late int remainingWeeks;
  List<List> monthWeeksAccordion = [];

  Map<DateTime, List> _appointments = {};
  List _dayAppointments = [];

  void _onTabChanged() {
    setState(() {
      addAppointmentButtonVisible = _tabController.index == 1;
    });
  }

  void _getAppointments() {
    Map<DateTime, List> appointments = AppointmentsRepository(null).getAll();

    setState(() {
      _appointments = appointments;
    });
  }

  void _getDayAppointments(DateTime? day) {
    setState(() {
      _dayAppointments = day == null ? [] : _getAppointmentsForDay(day);
    });
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
      if (multiSelectDays) {
        _multiSelectedDays.clear();
        multiSelectDays = false;
        initAppointments(null);
      } else {
        initAppointments(_selectedDay!);
      }
    });
  }

  void _openEditScreen(Map<String, dynamic> appointment, DateTime? day) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => EditAppointmentScreen(
          day: day != null
              ? DateTime.parse('${day.toString()}Z')
              : _selectedDay!,
          usedMarkers: _dayAppointments
              .map((appointment) => appointment['marker'])
              .toList(),
          appointment: appointment,
        ),
      ),
    ).then((value) => initAppointments(
        day != null ? DateTime.parse('${day.toString()}Z') : _selectedDay!));
  }

  List _getAppointmentsForDay(DateTime day) {
    final formattedDay = DateTime(day.year, day.month, day.day);

    final appointmentsForDay = _appointments[formattedDay];

    return appointmentsForDay ?? [];
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );

    _tabController.addListener(_onTabChanged);

    initAppointments(_focusedDay);

    remainingWeeks = ((lastDayOfMonth.difference(DateTime.now()).inDays +
                DateTime.now().weekday) /
            7)
        .ceil();

    monthWeeksAccordion =
        List.generate(remainingWeeks, (index) => [index, index == 0]);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        navBar: navbarLight,
        backButton: false,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.tertiary,
          tabs: const [
            Tab(
              icon: Icon(Icons.list_alt_outlined),
              text: 'Agendamentos',
            ),
            Tab(
              icon: Icon(Icons.calendar_month_outlined),
              text: 'Agenda',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const BouncingScrollPhysics(),
        children: [
          MyTab(
            children: [
              Column(
                children: [
                  const SizedBox(height: 18),
                  Text(
                    'Agendamentos por Semana',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 18),
                  ExpansionPanelList(
                    elevation: 0,
                    expansionCallback: (int index, bool isExpanded) {
                      setState(() {
                        for (var element in monthWeeksAccordion) {
                          element[1] = false;
                        }
                        monthWeeksAccordion[index][1] = !isExpanded;
                      });
                    },
                    expandedHeaderPadding: const EdgeInsets.all(0),
                    animationDuration: const Duration(milliseconds: 500),
                    children:
                        monthWeeksAccordion.map<ExpansionPanel>((monthWeek) {
                      return ExpansionPanel(
                        canTapOnHeader: true,
                        backgroundColor: Colors.transparent,
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          DateTime week = firstDayOfWeek
                              .add(Duration(days: monthWeek[0] * 7));
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 54),
                              child: Text(
                                'Dia ${week.day} a Dia ${week.add(const Duration(days: 6)).day}',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        },
                        body: Builder(
                          builder: (context) {
                            DateTime week = firstDayOfWeek
                                .add(Duration(days: monthWeek[0] * 7));
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 7,
                              itemBuilder: (context, index) {
                                DateTime weekDay =
                                    week.add(Duration(days: index));

                                List weekDayAppointments =
                                    _getAppointmentsForDay(weekDay);

                                if (weekDayAppointments.isEmpty) {
                                  return Container();
                                }

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Dia ${weekDay.day} | ',
                                            style: TextStyle(
                                              color: AppColors.primary,
                                              fontSize: 20,
                                            ),
                                          ),
                                          Text(
                                            weekDays[index],
                                            style: TextStyle(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          weekDay.day == DateTime.now().day
                                              ? const Text(
                                                  ' (Hoje)',
                                                  style: TextStyle(
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              : Container(),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Column(
                                        children: weekDayAppointments
                                            .map((appointment) {
                                          Map<String, dynamic> appointmentMap =
                                              appointment
                                                  as Map<String, dynamic>;

                                          List<String> multWordTItle =
                                              appointmentMap['title']
                                                  .split(' ');
                                          String abbrTitle =
                                              appointmentMap['title'].length >=
                                                      2
                                                  ? appointmentMap['title']
                                                      .substring(0, 2)
                                                      .toUpperCase()
                                                  : appointmentMap['title']
                                                      .toUpperCase();

                                          if (multWordTItle.length > 1) {
                                            abbrTitle =
                                                '${multWordTItle.first[0]}${multWordTItle.last[0]}'
                                                    .toUpperCase();
                                          }

                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4),
                                            child: InkWell(
                                              onTap: () => _openEditScreen(
                                                  appointmentMap, weekDay),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child: Row(
                                                children: [
                                                  CircleAvatar(
                                                    maxRadius: 20,
                                                    backgroundColor: appointmentMap[
                                                                    'marker']
                                                                .runtimeType ==
                                                            int
                                                        ? markers[appointmentMap[
                                                            'marker']] // Cor do marcador
                                                        : AppColors.primary,
                                                    child: Text(
                                                      abbrTitle,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 18),
                                                  Text(
                                                    appointmentMap['title'],
                                                    style: TextStyle(
                                                      color: AppColors.primary,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        isExpanded: monthWeek[1],
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 18),
                ],
              ),
            ],
          ),
          MyTab(
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
                  eventLoader: _getAppointmentsForDay,
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _selectedDay = null;
                      _focusedDay = focusedDay;
                    });
                    _getDayAppointments(_selectedDay);
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
                        _selectedDay =
                            _selectedDay == selectedDay ? null : selectedDay;
                        _focusedDay = focusedDay;
                      }
                    });
                    _getDayAppointments(multiSelectDays ? null : _selectedDay);
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
                        _selectedDay = null;
                        _focusedDay = focusedDay;
                        _getDayAppointments(_selectedDay);
                      }
                    });
                  },
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  headerStyle: HeaderStyle(
                    titleTextFormatter: (date, locale) =>
                        '${months[date.month - 1]} ${date.year}',
                    titleTextStyle: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
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
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Mês',
                    CalendarFormat.week: 'Semana',
                  },
                  calendarBuilders: CalendarBuilders(
                    selectedBuilder: (context, day, focusedDay) =>
                        MyCalendarDay(
                      day: day,
                      backgroundColor: AppColors.tertiary,
                      color: Colors.white,
                    ),
                    todayBuilder: (context, day, focusedDay) => MyCalendarDay(
                      day: day,
                      backgroundColor: AppColors.accent,
                      color: Colors.white,
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
                                color:
                                    appointmentMap['marker'].runtimeType == int
                                        ? markers[appointmentMap[
                                            'marker']] // Cor do marcador
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
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    defaultBuilder: (context, day, focusedDay) => MyCalendarDay(
                      day: day,
                      backgroundColor:
                          multiSelectDays && _multiSelectedDays.contains(day)
                              ? Colors.green
                              : null,
                      color: multiSelectDays && _multiSelectedDays.contains(day)
                          ? Colors.white
                          : [6, 7].contains(day.weekday)
                              ? AppColors.error
                              : AppColors.primary,
                    ),
                  ),
                ),
              ),
              _dayAppointments.isEmpty || _selectedDay == null
                  ? Container()
                  : Column(
                      children: [
                        Text(
                          'Agendamentos do Dia ${_selectedDay?.day}',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Column(
                          children: _dayAppointments.map((appointment) {
                            Map<String, dynamic> appointmentMap =
                                appointment as Map<String, dynamic>;

                            List<String> multWordTItle =
                                appointmentMap['title'].split(' ');
                            String abbrTitle =
                                appointmentMap['title'].length >= 2
                                    ? appointmentMap['title']
                                        .substring(0, 2)
                                        .toUpperCase()
                                    : appointmentMap['title'].toUpperCase();

                            if (multWordTItle.length > 1) {
                              abbrTitle =
                                  '${multWordTItle.first[0]}${multWordTItle.last[0]}'
                                      .toUpperCase();
                            }

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 4,
                              ),
                              child: InkWell(
                                onTap: () =>
                                    _openEditScreen(appointmentMap, null),
                                borderRadius: BorderRadius.circular(100),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      maxRadius: 20,
                                      backgroundColor: appointmentMap['marker']
                                                  .runtimeType ==
                                              int
                                          ? markers[appointmentMap[
                                              'marker']] // Cor do marcador
                                          : AppColors.primary,
                                      child: Text(
                                        abbrTitle,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 18),
                                    Text(
                                      appointmentMap['title'],
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 80),
                      ],
                    ),
            ],
          ),
        ],
      ),
      floatingActionButton: !addAppointmentButtonVisible
          ? null
          : _selectedDay != null
              ? FloatingActionButton.extended(
                  onPressed: _openAddScreen,
                  label: const Text('Adicionar Agendamento'),
                  backgroundColor: AppColors.primary,
                  elevation: 2,
                  highlightElevation: 2,
                  icon: const Icon(
                    Icons.add,
                  ),
                )
              : multiSelectDays && _multiSelectedDays.isNotEmpty
                  ? FloatingActionButton.extended(
                      onPressed: _openAddScreen,
                      label: const Text('Adicionar Agendamentos'),
                      backgroundColor: AppColors.primary,
                      elevation: 2,
                      highlightElevation: 2,
                      icon: const Icon(
                        Icons.add,
                      ),
                    )
                  : null,
    );
  }
}

class MyTab extends StatelessWidget {
  final List<Widget> children;
  const MyTab({
    required this.children,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width,
            minHeight: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                kToolbarHeight * 2 -
                kBottomNavigationBarHeight -
                18,
          ),
          child: Column(children: children),
        ),
      ),
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
                color: color ?? AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
