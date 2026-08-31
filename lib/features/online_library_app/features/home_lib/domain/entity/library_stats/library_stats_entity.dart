class LibraryStatsEntity {
  final int allOnline, saved, loans, activeLoans;
  final bool ok;

  LibraryStatsEntity({
    required this.allOnline,
    required this.saved,
    required this.loans,
    required this.activeLoans,
    required this.ok,
  });
}
