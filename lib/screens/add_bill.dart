import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:agenda/repositories/bills.dart';

import 'package:agenda/widgets/app_bar.dart';
import 'package:agenda/widgets/outline_input.dart';
import 'package:agenda/widgets/inline_radio.dart';
import 'package:agenda/widgets/bills_markers_list.dart';
import 'package:agenda/widgets/icon_text_button.dart';

import 'package:agenda/utils/bills.dart';
import 'package:agenda/utils/constants.dart';
import 'package:agenda/utils/formatters.dart';

class AddBillScreen extends StatefulWidget {
  final int day;

  const AddBillScreen({required this.day, super.key});

  @override
  State<AddBillScreen> createState() => _AddBillScreenState();
}

class _AddBillScreenState extends State<AddBillScreen> {
  late BillsRepository billsRepository;

  late MyTextEditingController _title;
  late MyTextEditingController _value;
  final MyTextEditingController _description = MyTextEditingController();
  int _paymentType = 0;
  int _marker = 0;

  void initTextControllers() {
    _title = MyTextEditingController(
      validator: MyInputValidator(
        condition: (value) => value.trim().isNotEmpty,
        errorMessage: 'É necessário dar um título',
      ),
    );
    _value = MyTextEditingController(
      validator: MyInputValidator(
        condition: (value) => value.trim().isNotEmpty,
        errorMessage: 'É necessário dar um valor',
      ),
    );
  }

  void _setPaymentType(int paymentType) {
    setState(() {
      _paymentType = paymentType;
    });
  }

  void _setMarker(int marker) {
    setState(() {
      _marker = marker;
    });
  }

  void _addBill() {
    if (!_title.validate()) return;
    if (!_value.validate()) return;

    var billObject = {
      'title': _title.text.trim(),
      'value': double.parse(
          _value.text.trim().replaceAll('.', '').replaceAll(',', '.')),
      'description': _description.text,
      'paymentType': _paymentType,
      'marker': _marker,
    };

    billsRepository.create(
      day: widget.day,
      {'id': randomID(), ...billObject},
    );

    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();

    initTextControllers();
  }

  @override
  Widget build(BuildContext context) {
    billsRepository = context.watch<BillsRepository>();

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
                        'Conta dia ${widget.day.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 32,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 18),
                      MyOutlineInput(
                        controller: _title,
                        keyboardType: TextInputType.text,
                        labelText: 'Título',
                        hintText: 'Digite um título',
                      ),
                      const SizedBox(height: 18),
                      MyOutlineInput(
                        controller: _value,
                        maxLength: 7,
                        keyboardType: const TextInputType.numberWithOptions(),
                        labelText: 'Valor',
                        hintText: 'Digite um valor',
                        onChanged: (String value) {
                          value = formatCurrency(value);
                          _value.value = TextEditingValue(
                            text: value,
                            selection: TextSelection.fromPosition(
                              TextPosition(offset: value.length),
                            ),
                          );
                        },
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
                            'Pagamento',
                            style: TextStyle(
                              color: AppColors.primary,
                            ),
                          ),
                          Row(
                            children: paymentTypes.asMap().entries.map((entry) {
                              return MyInlineRadio(
                                label: entry.value,
                                value: entry.key,
                                selected: _paymentType,
                                onChanged: () => _setPaymentType(entry.key),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Marcador',
                                style: TextStyle(
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.success,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  billsMarkers[_marker].label,
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          BillsMarkersList(
                            markers: billsMarkers,
                            marker: _marker,
                            onTap: _setMarker,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Column(
                    children: [
                      MyIconTextButton(
                        label: 'Adicionar Conta',
                        icon: Icons.add,
                        onPressed: _addBill,
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
