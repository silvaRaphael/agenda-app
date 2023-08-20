import 'package:agenda/repositories/appointments.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';

import 'package:agenda/components/app_bar.dart';
import 'package:agenda/components/markers_list.dart';
import 'package:agenda/components/icon_button.dart';
import 'package:agenda/components/inline_radio.dart';
import 'package:agenda/components/outline_input.dart';
import 'package:agenda/components/icon_text_button.dart';

import 'package:agenda/utils/appointments.dart';
import 'package:agenda/utils/constants.dart';

class EditAppointmentScreen extends StatefulWidget {
  final DateTime date;
  final Map<String, dynamic> appointment;
  final List<dynamic>? usedMarkers;

  const EditAppointmentScreen({
    required this.date,
    required this.appointment,
    this.usedMarkers,
    super.key,
  });

  @override
  State<EditAppointmentScreen> createState() => _EditAppointmentScreenState();
}

class _EditAppointmentScreenState extends State<EditAppointmentScreen> {
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

    _title.text = widget.appointment['title'];
    _description.text = widget.appointment['description'];
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

  void _editAppointment() {
    if (!_title.validate()) return;

    appointmentsRepository.update(
      {
        'id': widget.appointment['id'],
        'title': _title.text.trim(),
        'description': _description.text,
        'group': _group,
        'marker': _marker,
      },
      date: widget.date,
      id: widget.appointment['id'],
    );

    Navigator.of(context).pop();
  }

  void _showConfirmDeleteAppointment() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Confirmação de Exclusão',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            Text(
              'Tem certeza que quer excluir está agenda?',
              style: TextStyle(
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyIconTextButton(
                  label: 'Excluir Agenda',
                  icon: CupertinoIcons.trash,
                  backgroundColor: AppColors.error,
                  onPressed: _deleteAppointment,
                  borderRadius: BorderRadius.circular(100),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _deleteAppointment() {
    appointmentsRepository.delete(
      date: widget.date,
      id: widget.appointment['id'],
    );

    Navigator.of(context)
      ..pop()
      ..pop();
  }

  @override
  void initState() {
    super.initState();

    initTextControllers();
    _setGroup(widget.appointment['group']);
    _setMarker(widget.appointment['marker']);
  }

  @override
  Widget build(BuildContext context) {
    appointmentsRepository = context.read<AppointmentsRepository>();

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
                        '${months[widget.date.month - 1]}\n${widget.date.day.toString().padLeft(2, '0')}/${widget.date.month.toString().padLeft(2, '0')}/${widget.date.year}',
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
                              MyMarkersList(
                                markers: markers,
                                blockedMarkers: widget.usedMarkers,
                                onTap: _setMarker,
                                marker: _marker,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MyIconButton(
                            iconData: CupertinoIcons.trash,
                            backgroundColor: AppColors.error,
                            onTap: _showConfirmDeleteAppointment,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          const SizedBox(width: 18),
                          MyIconTextButton(
                            label: 'Editar Agenda',
                            icon: Icons.edit_note_rounded,
                            onPressed: _editAppointment,
                            color: AppColors.white,
                            backgroundColor: Colors.black54,
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ],
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
