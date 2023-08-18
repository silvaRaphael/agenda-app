import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:table_calendar/table_calendar.dart';

import 'package:agenda/screens/add_appointment.dart';
import 'package:agenda/screens/edit_appointment.dart';

import 'package:agenda/components/appointments_list_tile.dart';
import 'package:agenda/components/my_tab.dart';

import 'package:agenda/utils/api.dart';
import 'package:agenda/utils/appointments.dart';
import 'package:agenda/utils/week_days.dart';
import 'package:agenda/utils/models.dart';
import 'package:agenda/utils/constants.dart';

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
  int _tabIndex = 0;
  // final List<Widget> _tabs = [];

  DateTime firstDayOfWeek = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day - DateTime.now().weekday % 7);
  DateTime lastDayOfMonth =
      DateTime(DateTime.now().year, DateTime.now().month + 1, 0);

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final List<DateTime> _multiSelectedDays = [];

  late int remainingWeeks;
  List<List> monthWeeks = [];

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

    monthWeeks = List.generate(remainingWeeks, (index) => [index, index == 0]);
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
                    Icons.add,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
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
              MyTab(
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
                          DateTime week =
                              firstDayOfWeek.add(Duration(days: index * 7));
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
                                    'Dia ${week.day} a Dia ${week.add(const Duration(days: 6)).day}',
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
                                    DateTime weekDay =
                                        week.add(Duration(days: index));

                                    List weekDayAppointments =
                                        _getAppointmentsForDay(weekDay);

                                    if (weekDayAppointments.isEmpty) {
                                      return Container();
                                    }

                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 26,
                                          child: Text(
                                            '${weekDay.day}\n${weekDays[index].substring(0, 3)}',
                                            style: TextStyle(
                                              color: AppColors.primary
                                                  .withOpacity(.5),
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
                                              itemCount:
                                                  weekDayAppointments.length,
                                              itemBuilder: (context, index) {
                                                Map<String, dynamic>
                                                    appointmentMap =
                                                    weekDayAppointments[index]
                                                        as Map<String, dynamic>;
                                                return AppointmentsListTile(
                                                  appointment:
                                                      weekDayAppointments[
                                                          index],
                                                  date: weekDay,
                                                  onTap: () => _openEditScreen(
                                                      appointmentMap, weekDay),
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
                            _selectedDay = _selectedDay == selectedDay
                                ? null
                                : selectedDay;
                            _focusedDay = focusedDay;
                          }
                        });
                        _getDayAppointments(
                            multiSelectDays ? null : _selectedDay);
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
                            '${meses[date.month - 1]} ${date.year}',
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
                        selectedBuilder: (context, day, focusedDay) =>
                            MyCalendarDay(
                          day: day,
                          backgroundColor: Colors.indigo,
                          color: AppColors.white,
                        ),
                        todayBuilder: (context, day, focusedDay) =>
                            MyCalendarDay(
                          day: day,
                          backgroundColor: Colors.blue[700],
                          color: AppColors.white,
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
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 1),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        appointmentMap['marker'].runtimeType ==
                                                int
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
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        defaultBuilder: (context, day, focusedDay) =>
                            MyCalendarDay(
                          day: day,
                          backgroundColor: multiSelectDays &&
                                  _multiSelectedDays.contains(day)
                              ? Colors.greenAccent[700]
                              : null,
                          color: multiSelectDays &&
                                  _multiSelectedDays.contains(day)
                              ? AppColors.white
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
                                          backgroundColor: appointmentMap[
                                                          'marker']
                                                      .runtimeType ==
                                                  int
                                              ? markers[appointmentMap[
                                                  'marker']] // Cor do marcador
                                              : AppColors.primary,
                                          child: Text(
                                            abbrTitle,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: AppColors.white,
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
                    children: const [
                      ModelNavBarItem(
                        index: 0,
                        icon: Icons.home_outlined,
                        iconActive: Icons.home,
                      ),
                      ModelNavBarItem(
                        index: 1,
                        icon: Icons.event_note_outlined,
                        iconActive: Icons.event_note,
                      ),
                      ModelNavBarItem(
                        index: 2,
                        icon: Icons.attach_money,
                        iconActive: Icons.attach_money_outlined,
                      ),
                    ].map((item) {
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
      floatingActionButton: _selectedDay == null
          ? null
          : FloatingActionButton(
              onPressed: _openAddScreen,
              backgroundColor: AppColors.primary,
              elevation: 2,
              highlightElevation: 2,
              child: const Icon(
                Icons.add,
              ),
            ),
      // floatingActionButton: !addAppointmentButtonVisible
      //     ? null
      //     : _selectedDay != null
      //         ? FloatingActionButton.extended(
      //             onPressed: _openAddScreen,
      //             label: const Text('Adicionar Agendamento'),
      //             backgroundColor: AppColors.primary,
      //             elevation: 2,
      //             highlightElevation: 2,
      //             icon: const Icon(
      //               Icons.add,
      //             ),
      //           )
      //         : multiSelectDays && _multiSelectedDays.isNotEmpty
      //             ? FloatingActionButton.extended(
      //                 onPressed: _openAddScreen,
      //                 label: const Text('Adicionar Agendamentos'),
      //                 backgroundColor: AppColors.primary,
      //                 elevation: 2,
      //                 highlightElevation: 2,
      //                 icon: const Icon(
      //                   Icons.add,
      //                 ),
      //               )
      //             : null,
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
