import 'package:flutter/material.dart';

import 'package:agenda/components/markers_list.dart';
import 'package:agenda/components/inline_radio.dart';
import 'package:agenda/components/outline_input.dart';
import 'package:agenda/components/icon_text_button.dart';

import 'package:agenda/utils/api.dart';
import 'package:agenda/utils/appointments.dart';
import 'package:agenda/utils/constants.dart';
import 'package:flutter/services.dart';

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
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppColors.white,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: AppColors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        foregroundColor: AppColors.primary,
        centerTitle: false,
        backgroundColor: AppColors.white,
        elevation: 0,
        leadingWidth: 200,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    child: const Icon(Icons.keyboard_arrow_left, size: 22),
                  ),
                ),
                const Text(
                  'Voltar',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.days != null
                            ? '${months[widget.day.month - 1]}\n${widget.days!.map((day) => day.day.toString().padLeft(2, '0'))}/${widget.day.month.toString().padLeft(2, '0')}/${widget.day.year}'
                            : '${months[widget.day.month - 1]}\n${widget.day.day.toString().padLeft(2, '0')}/${widget.day.month.toString().padLeft(2, '0')}/${widget.day.year}',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 32,
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
                  const SizedBox(height: 18),
                  Column(
                    children: [
                      MyIconTextButton(
                        label: widget.days != null
                            ? 'Adicionar Agendamentos'
                            : 'Adicionar Agendamento',
                        icon: Icons.add,
                        onPressed: _addAppointment,
                        color: Colors.black.withOpacity(.85),
                        backgroundColor: AppColors.grey,
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
