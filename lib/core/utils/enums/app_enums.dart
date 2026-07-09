enum CoursesLayout { grid, list }

enum CalendarLayout { month, week }

enum TicketStatus { approved, rejected, pending }

enum BookCardType { bought, market, library }

enum ArticleStatus { confirmed, pending, rejected, draft, inReview }

enum LastActionsStatus { inReview, accepted, addedExpert, rejected }

extension LastActionsStatusX on LastActionsStatus {
  static LastActionsStatus fromString(String value) {
    switch (value) {
      case 'in_review':
        return LastActionsStatus.inReview;
      case 'added_expert':
        return LastActionsStatus.addedExpert;
      case 'rejected':
        return LastActionsStatus.rejected;
      case 'accepted':
      default:
        return LastActionsStatus.accepted;
    }
  }
}

enum AnnotationLanguageEnum { uz, en, ru }

enum PaymentStatusEnum { paid, pending, notBought }
