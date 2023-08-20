import 'package:flutter/material.dart';

import 'package:agenda/utils/bills.dart';
import 'package:agenda/utils/constants.dart';
import 'package:intl/intl.dart';

class BillsListTile extends StatelessWidget {
  final Map<String, dynamic> bill;
  final int day;
  final Function()? onTap;

  const BillsListTile({
    required this.bill,
    required this.day,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
                backgroundColor: billsMarkers[bill['marker']].color,
                child: Icon(
                  billsMarkers[bill['marker']].icon,
                  color: AppColors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          bill['title'],
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            overflow: TextOverflow.ellipsis,
                          ),
                          softWrap: true,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          NumberFormat.currency(
                            locale: 'pt_BR',
                            symbol: 'R\$',
                          ).format(bill['value']),
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          paymentTypes[bill['paymentType']],
                          style: TextStyle(
                            color: AppColors.primary.withOpacity(.5),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        day == DateTime.now().day
                            ? Icon(
                                Icons.circle,
                                size: 10,
                                color: Colors.greenAccent[700],
                              )
                            : Text(
                                day.toString(),
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
