import 'package:flutter/material.dart';

import 'package:agenda/utils/models.dart';

List<String> paymentTypes = ['Crédito', 'Débito'];

List<ModelBillsMarkers> billsMarkers = const [
  ModelBillsMarkers(
    label: 'Pessoal',
    color: Colors.green,
    icon: Icons.person_outline,
  ),
  ModelBillsMarkers(
    label: 'Serviços',
    color: Colors.purple,
    icon: Icons.online_prediction_outlined,
  ),
  ModelBillsMarkers(
    label: 'Casa',
    color: Colors.pink,
    icon: Icons.home_outlined,
  ),
  ModelBillsMarkers(
    label: 'Mantimentos',
    color: Colors.indigo,
    icon: Icons.shopping_bag_outlined,
  ),
  ModelBillsMarkers(
    label: 'Trabalho',
    color: Colors.teal,
    icon: Icons.business_center_outlined,
  ),
];
