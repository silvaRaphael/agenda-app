import 'package:flutter/material.dart';

import 'package:agenda/utils/appointments.dart';
import 'package:agenda/utils/constants.dart';

class AppointmentsListTile extends StatelessWidget {
  final dynamic appointment;
  final DateTime date;
  final Function()? onTap;

  const AppointmentsListTile({
    required this.appointment,
    required this.date,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> appointmentMap = appointment as Map<String, dynamic>;

    List<String> multWordTItle = appointmentMap['title'].split(' ');
    String abbrTitle = appointmentMap['title'].length >= 2
        ? appointmentMap['title'].substring(0, 2).toUpperCase()
        : appointmentMap['title'].toUpperCase();

    if (multWordTItle.length > 1) {
      abbrTitle =
          '${multWordTItle.first[0]}${multWordTItle.last[0]}'.toUpperCase();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: InkWell(
        onTap: onTap,
        highlightColor: AppColors.grey,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(width: 1, color: AppColors.dark),
          ),
          child: Row(
            children: [
              CircleAvatar(
                maxRadius: 20,
                backgroundColor: appointmentMap['marker'].runtimeType == int
                    ? markers[appointmentMap['marker']]
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
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      appointmentMap['title'],
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        overflow: TextOverflow.ellipsis,
                      ),
                      softWrap: true,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          ['Pessoal', 'Profissional'][appointmentMap['group']],
                          style: TextStyle(
                            color: AppColors.primary.withOpacity(.5),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        date.day == DateTime.now().day
                            ? Icon(
                                Icons.circle,
                                size: 10,
                                color: Colors.greenAccent[700],
                              )
                            : Text(
                                date.day.toString(),
                                style: TextStyle(
                                  color: AppColors.primary.withOpacity(.5),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                ),
                                textAlign: TextAlign.end,
                              )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
