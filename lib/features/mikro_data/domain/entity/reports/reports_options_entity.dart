class ReportsOptionsEntity {
  final int id;
  final DateTime dateFrom;
  final DateTime dateTo;
  final String fileExtension;

  const ReportsOptionsEntity({
    required this.id,
    required this.dateFrom,
    required this.dateTo,
    required this.fileExtension,
  });
}
