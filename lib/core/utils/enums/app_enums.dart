enum CoursesLayout { grid, list }

enum CalendarLayout { month, week }

enum TicketStatus { open, inProgress, closed }

enum BookCardType { bought, market, library }

enum ArticleStatus {
  confirmed,
  pending,
  rejected,
  draft,
  inReview,
  waitingForPayment,
}

enum MicroDataRequestStatus {
  accepted,
  inReview,
  rejected,
  pendingPayment,
  draft,
}

enum LastActionsStatus {
  inReview,
  accepted,
  addedExpert,
  rejected,
  waitingForPayment,
}

extension LastActionsStatusX on LastActionsStatus {
  static LastActionsStatus fromString(String value) {
    switch (value) {
      case 'in_review':
        return LastActionsStatus.inReview;
      case 'added_expert':
        return LastActionsStatus.addedExpert;
      case 'rejected':
        return LastActionsStatus.rejected;
      case 'waiting_for_payment':
        return LastActionsStatus.waitingForPayment;
      case 'accepted':
      default:
        return LastActionsStatus.accepted;
    }
  }
}

enum AnnotationLanguageEnum { uz, en, ru }

enum PaymentStatusEnum { paid, pending, notBought }
