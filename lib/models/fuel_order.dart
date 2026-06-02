import 'package:flutter/material.dart';

enum OrderStatus { enRuta, confirmado, pendiente }

class FuelOrder {
  final String id;
  final String productName;
  final OrderStatus status;
  final String volumeLiters;
  final String secondaryLabel;
  final String secondaryValue;
  final IconData secondaryIcon;
  final String dateLabel;

  const FuelOrder({
    required this.id,
    required this.productName,
    required this.status,
    required this.volumeLiters,
    required this.secondaryLabel,
    required this.secondaryValue,
    required this.secondaryIcon,
    required this.dateLabel,
  });
}
