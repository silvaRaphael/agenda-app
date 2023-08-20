import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:agenda/repositories/appointments.dart';

import 'package:agenda/widgets/app_bar.dart';
import 'package:agenda/widgets/appointments_markers_list.dart';
import 'package:agenda/widgets/inline_radio.dart';
import 'package:agenda/widgets/outline_input.dart';
import 'package:agenda/widgets/icon_text_button.dart';

import 'package:agenda/utils/appointments.dart';
import 'package:agenda/utils/constants.dart';

class AddAppointmentScreen extends StatefulWidget {
  final DateTime date;
  final List<DateTime>? dates;
  final List<dynamic>? usedMarkers;

  const AddAppointmentScreen({
    required this.date,
    this.dates,
    this.usedMarkers,
    super.key,
  });

  @override
  State<AddAppointmentScreen> createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends State<AddAppointmentScreen> {
  late AppointmentsRepository appointmentsRepository;

  late MyTextEditingController _title;
  final MyTextEditingController _description = MyTextEditingController();
  int _group = 0;
  int _marker = 0;

  void initTextControllers() {
    _title = MyTextEditingController(
      validator: MyInputValidator(
        condition: (value) => value.trim().isNotEmpty,
        errorMessage: 'É necessário dar um título',
      ),
    );
  }

  void _setGroup(group) {
    setState(() {
      _group = group;
    });
  }

  void _setMarker(marker) {
    setState(() {
      _marker = marker;
    });
  }

  void _addAppointment() {
    if (!_title.validate()) return;

    var appointmentObject = {
      'title': _title.text.trim(),
      'description': _description.text,
      'group': _group,
      'marker': _marker,
    };

    if (widget.dates != null) {
      for (var day in widget.dates!) {
        appointmentsRepository.create(
          date: day,
          {'id': randomID(), ...appointmentObject},
        );
      }
    } else {
      appointmentsRepository.create(
        date: widget.date,
        {'id': randomID(), ...appointmentObject},
      );
    }

    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();

    initTextControllers();
  }

  @override
  Widget build(BuildContext context) {
    appointmentsRepository = context.watch<AppointmentsRepository>();

    return Scaffold(
      appBar: const GoBackAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  kToolbarHeight,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.dates != null
                            ? '${months[widget.date.month - 1]}\n${widget.dates!.map((day) => day.day.toString().padLeft(2, '0'))}/${widget.date.month.toString().padLeft(2, '0')}/${widget.date.year}'
                            : '${months[widget.date.month - 1]}\n${widget.date.day.toString().padLeft(2, '0')}/${widget.date.month.toString().padLeft(2, '0')}/${widget.date.year}',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 32,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 42),
                      MyOutlineInput(
                        controller: _title,
                        keyboardType: TextInputType.text,
                        labelText: 'Título',
                        hintText: 'Digite um título',
                      ),
                      const SizedBox(height: 18),
                      MyOutlineInput(
                        controller: _description,
                        keyboardType: TextInputType.multiline,
                        labelText: 'Descrição',
                        hintText: 'Digite uma descrição',
                      ),
                      const SizedBox(height: 18),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Grupo',
                            style: TextStyle(
                              color: AppColors.primary,
                            ),
                          ),
                          Row(
                            children: [
                              MyInlineRadio(
                                label: 'Pessoal',
                                value: 0,
                                selected: _group,
                                onChanged: () => _setGroup(0),
                              ),
                              MyInlineRadio(
                                label: 'Profissional',
                                value: 1,
                                selected: _group,
                                onChanged: () => _setGroup(1),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Marcador',
                            style: TextStyle(
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          AppointmentsMarkersList(
                            markers: markers,
                            blockedMarkers: widget.usedMarkers,
                            onTap: _setMarker,
                            marker: _marker,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Column(
                    children: [
                      MyIconTextButton(
                        label: widget.dates != null
                            ? 'Adicionar Agendas'
                            : 'Adicionar Agenda',
                        icon: Icons.add,
                        onPressed: _addAppointment,
                        color: AppColors.white,
                        backgroundColor: Colors.black54,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      const SizedBox(height: 18),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
