import 'package:flutter/material.dart';

import 'package:agenda/utils/appointments.dart';
import 'package:agenda/utils/constants.dart';

// ignore: must_be_immutable
class AppointmentsListTile extends StatelessWidget {
  dynamic appointment;
  final Function()? onTap;

  AppointmentsListTile({
    required this.appointment,
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: 1, color: AppColors.dark),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(100),
        child: Row(
          children: [
            CircleAvatar(
              maxRadius: 20,
              backgroundColor: appointmentMap['marker'].runtimeType == int
                  ? markers[appointmentMap['marker']] // Cor do marcador
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
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                Text(
                  ['Pessoal', 'Profissional'][appointmentMap['group']],
                  style: TextStyle(
                    color: AppColors.primary.withOpacity(.5),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
