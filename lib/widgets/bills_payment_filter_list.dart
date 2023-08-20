import 'package:agenda/utils/constants.dart';
import 'package:flutter/material.dart';

class BillsPaymentFilterList extends StatelessWidget {
  final int? paymentType;
  final List<String> paymentTypes;
  final void Function(int?)? onTap;

  const BillsPaymentFilterList({
    required this.paymentType,
    required this.paymentTypes,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: ['Todos', ...paymentTypes]
            .asMap()
            .map((index, mapPaymentType) {
              bool isSelected = (index == 0 && paymentType == null) ||
                  index - 1 == paymentType;

              return MapEntry(
                index,
                GestureDetector(
                  onTap: onTap == null
                      ? null
                      : () => onTap!(index == 0 ? null : index - 1),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        width: 1,
                        color: AppColors.dark,
                      ),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Icon(
                            Icons.circle,
                            size: 10,
                            color: isSelected
                                ? Colors.greenAccent[700]
                                : AppColors.primary.withOpacity(.5),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 18),
                          child: Text(
                            mapPaymentType.toString(),
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            })
            .values
            .toList(),
      ),
    );
  }
}
