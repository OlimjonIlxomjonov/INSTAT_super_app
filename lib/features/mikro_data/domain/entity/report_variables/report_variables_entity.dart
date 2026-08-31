class ReportVariablesEntity {
  final int id;
  final int dataReport;
  final String label;
  final String value;
  final String createdAt;

  const ReportVariablesEntity({
    required this.id,
    required this.dataReport,
    required this.label,
    required this.value,
    required this.createdAt,
  });
}
