import 'package:flutter/material.dart';

class VacancyProcessField {
  final String label;
  final String value;

  const VacancyProcessField({required this.label, required this.value});
}

class VacancyCommissionMember {
  final String name;
  final String phone;
  final String? avatarUrl;

  const VacancyCommissionMember({
    required this.name,
    required this.phone,
    this.avatarUrl,
  });
}

class VacancyProcessItem {
  final int cycle;
  final String title;
  final String description;
  final String date;
  final IconData icon;
  final Color color;

  //! Detail
  final String? detailTitle;
  final String? detailDescription;
  final List<VacancyProcessField> fields;
  final List<VacancyCommissionMember> commission;

  const VacancyProcessItem({
    required this.cycle,
    required this.title,
    required this.description,
    required this.date,
    required this.icon,
    required this.color,
    this.detailTitle,
    this.detailDescription,
    this.fields = const [],
    this.commission = const [],
  });
}
