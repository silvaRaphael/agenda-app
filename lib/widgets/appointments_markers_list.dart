import 'package:flutter/material.dart';

import 'package:agenda/widgets/icon_button.dart';

class AppointmentsMarkersList extends StatelessWidget {
  final List markers;
  final List? blockedMarkers;
  final int marker;
  final void Function(int index)? onTap;

  const AppointmentsMarkersList({
    required this.markers,
    this.blockedMarkers,
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
                    horizontal: 4,
                  ),
                  child: MyIconButton(
                    iconData: blockedMarkers != null &&
                            blockedMarkers!.contains(index)
                        ? Icons.block
                        : Icons.near_me_outlined,
                    size: 40,
                    backgroundColor:
                        index == marker ? mapMarker : mapMarker.withOpacity(.5),
                    borderRadius: BorderRadius.circular(100),
                    onTap: blockedMarkers != null &&
                            blockedMarkers!.contains(index)
                        ? null
                        : onTap == null
                            ? null
                            : () => onTap!(index),
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
