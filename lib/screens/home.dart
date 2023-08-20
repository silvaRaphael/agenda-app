import 'package:agenda/screens/add_bill.dart';
import 'package:agenda/screens/tabs/edit_bill.dart';
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

class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen>
    with TickerProviderStateMixin {
  late AppointmentsRepository appointmentsRepository;
  late BillsRepository billsRepository;

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
                    Icons.notifications_none_rounded,
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
              HomeTab(openEditScreen: _openEditAppointmentScreen),
              CalendarTab(openEditScreen: _openEditAppointmentScreen),
              BillsTab(openEditScreen: _openEditBillScreen),
            ][_tabIndex],
          ),
          // bottom navbar
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
