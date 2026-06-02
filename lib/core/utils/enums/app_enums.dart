enum CoursesLayout { grid, list }

enum CalendarLayout { month, week }

enum TicketStatus { approved, rejected, pending }

enum BookCardType { bought, market, library }

enum ArticleStatus { confirmed, pending, rejected, draft }

enum LastActionsStatus { inReview, sent, pending }

extension LastActionsStatusX on LastActionsStatus {
  static LastActionsStatus fromString(String value) {
    switch (value) {
      case 'in_review':
        return LastActionsStatus.inReview;
      case 'pending':
        return LastActionsStatus.pending;
      case 'sent':
      default:
        return LastActionsStatus.sent;
    }
  }
}

enum AnnotationLanguageEnum { uz, en, ru }
