import 'package:flutter/material.dart';

import 'package:agenda/widgets/icon_button.dart';

import 'package:agenda/utils/models.dart';

class BillsMarkersList extends StatelessWidget {
  final List<ModelBillsMarkers> markers;
  final int marker;
  final void Function(int index)? onTap;

  const BillsMarkersList({
    required this.markers,
    required this.marker,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: markers
            .asMap()
            .map((index, mapMarker) {
              return MapEntry(
                index,
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                  ),
                  child: MyIconButton(
                    iconData: mapMarker.icon,
                    size: 50,
                    backgroundColor: index == marker
                        ? mapMarker.color
                        : mapMarker.color.withOpacity(.5),
                    borderRadius: BorderRadius.circular(100),
                    onTap: onTap == null ? null : () => onTap!(index),
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
