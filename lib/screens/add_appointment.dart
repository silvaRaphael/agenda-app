import 'package:flutter/material.dart';

import 'package:agenda/components/markers_list.dart';
import 'package:agenda/components/inline_radio.dart';
import 'package:agenda/components/outline_input.dart';
import 'package:agenda/components/app_bar.dart';
import 'package:agenda/components/icon_text_button.dart';

import 'package:agenda/utils/api.dart';
import 'package:agenda/utils/appointments.dart';
import 'package:agenda/utils/constants.dart';

class AddAppointmentScreen extends StatefulWidget {
  final DateTime day;
  final List<DateTime>? days;
  final List<dynamic>? usedMarkers;
  const AddAppointmentScreen({
    required this.day,
    this.days,
    this.usedMarkers,
    super.key,
  });

  @override
  State<AddAppointmentScreen> createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends State<AddAppointmentScreen> {
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

    if (widget.days != null) {
      for (var day in widget.days!) {
        AppointmentsRepository(day)
            .create({'id': randomID(), ...appointmentObject});
      }
    } else {
      AppointmentsRepository(widget.day)
          .create({'id': randomID(), ...appointmentObject});
    }

    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();

    initTextControllers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        navBar: navbarLight,
        title: widget.days != null
            ? '${meses[widget.day.month - 1]} - ${widget.days!.map((day) => day.day.toString().padLeft(2, '0'))}/${widget.day.month.toString().padLeft(2, '0')}/${widget.day.year}'
            : '${meses[widget.day.month - 1]} - ${widget.day.day.toString().padLeft(2, '0')}/${widget.day.month.toString().padLeft(2, '0')}/${widget.day.year}',
      ),
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
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
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
                    ],
                  ),
                  const SizedBox(height: 18),
                  Column(
                    children: [
                      MyMarkersList(
                        markers: markers,
                        blockedMarkers: widget.usedMarkers,
                        onTap: _setMarker,
                        marker: _marker,
                      ),
                      const SizedBox(height: 18),
                      MyIconTextButton(
                        label: widget.days != null
                            ? 'Adicionar Agendamentos'
                            : 'Adicionar Agendamento',
                        icon: Icons.add,
                        onPressed: _addAppointment,
                      ),
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
