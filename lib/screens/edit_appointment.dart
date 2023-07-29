import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:agenda/components/markers_list.dart';
import 'package:agenda/components/icon_button.dart';
import 'package:agenda/components/inline_radio.dart';
import 'package:agenda/components/outline_input.dart';
import 'package:agenda/components/app_bar.dart';
import 'package:agenda/components/icon_text_button.dart';

import 'package:agenda/utils/api.dart';
import 'package:agenda/utils/appointments.dart';
import 'package:agenda/utils/constants.dart';

class EditAppointmentScreen extends StatefulWidget {
  final DateTime day;
  final Map<String, dynamic> appointment;
  final List<dynamic>? usedMarkers;
  const EditAppointmentScreen({
    required this.day,
    required this.appointment,
    this.usedMarkers,
    super.key,
  });

  @override
  State<EditAppointmentScreen> createState() => _EditAppointmentScreenState();
}

class _EditAppointmentScreenState extends State<EditAppointmentScreen> {
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

    AppointmentsRepository(widget.day).update({
      'id': widget.appointment['id'],
      'title': _title.text.trim(),
      'description': _description.text,
      'group': _group,
      'marker': _marker,
    }, id: widget.appointment['id']);

    Navigator.pop(context);
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
              'Tem certeza que quer excluir este agendamento?',
              style: TextStyle(
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MyIconButton(
                  iconData: Icons.close,
                  backgroundColor: AppColors.primary.withOpacity(.5),
                  onTap: () => Navigator.of(context).pop(),
                ),
                MyIconTextButton(
                  label: 'Excluir Agendamento',
                  icon: CupertinoIcons.trash,
                  backgroundColor: AppColors.error,
                  onPressed: _deleteAppointment,
                  width: MediaQuery.of(context).size.width - 60 - 80,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _deleteAppointment() {
    AppointmentsRepository(widget.day).delete(id: widget.appointment['id']);

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
    return Scaffold(
      appBar: MyAppBar(
        navBar: navbarLight,
        title:
            '${meses[widget.day.month - 1]} - ${widget.day.day.toString().padLeft(2, '0')}/${widget.day.month.toString().padLeft(2, '0')}/${widget.day.year}',
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
                        blockedMarkers: widget.usedMarkers == null
                            ? null
                            : widget.usedMarkers!
                                .where((marker) =>
                                    marker != widget.appointment['marker'])
                                .toList(),
                        marker: _marker,
                        onTap: _setMarker,
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyIconButton(
                            iconData: CupertinoIcons.trash,
                            backgroundColor: AppColors.error,
                            onTap: _showConfirmDeleteAppointment,
                          ),
                          MyIconTextButton(
                            label: 'Editar Agendamento',
                            icon: Icons.edit,
                            onPressed: _editAppointment,
                            width: MediaQuery.of(context).size.width - 60 - 80,
                          ),
                        ],
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
