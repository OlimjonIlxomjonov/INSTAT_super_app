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

//! `data-requests/` va uning `processes/` qaytaradigan status qiymatlari
enum MicroDataRequestStatus {
  draft,
  inReview,
  inProcess,
  agreementAccepted,
  headAgreementAccepted,
  waitingForPayment,
  paid,
  finished,
  rejected,
  unknown,
}

extension MicroDataRequestStatusX on MicroDataRequestStatus {
  static MicroDataRequestStatus fromString(String value) {
    switch (value) {
      case 'draft':
        return MicroDataRequestStatus.draft;
      case 'in_review':
        return MicroDataRequestStatus.inReview;
      case 'in_process':
        return MicroDataRequestStatus.inProcess;
      case 'agreement_accepted':
        return MicroDataRequestStatus.agreementAccepted;
      case 'head_agreement_accepted':
        return MicroDataRequestStatus.headAgreementAccepted;
      case 'waiting_for_payment':
        return MicroDataRequestStatus.waitingForPayment;
      case 'paid':
        return MicroDataRequestStatus.paid;
      case 'finished':
        return MicroDataRequestStatus.finished;
      case 'rejected':
      case 'failed':
        return MicroDataRequestStatus.rejected;
      default:
        return MicroDataRequestStatus.unknown;
    }
  }
}

//! Maqola va so'rov jarayonlaridagi status qiymatlari
enum LastActionsStatus {
  draft,
  sent,
  inReview,
  inProcess,
  accepted,
  agreementAccepted,
  headAgreementAccepted,
  addedExpert,
  rejected,
  waitingForPayment,
  paid,
  finished,
  published,
  unknown,
}

extension LastActionsStatusX on LastActionsStatus {
  static LastActionsStatus fromString(String value) {
    switch (value) {
      case 'draft':
        return LastActionsStatus.draft;
      case 'sent':
        return LastActionsStatus.sent;
      case 'in_review':
        return LastActionsStatus.inReview;
      case 'in_process':
        return LastActionsStatus.inProcess;
      case 'agreement_accepted':
        return LastActionsStatus.agreementAccepted;
      case 'head_agreement_accepted':
        return LastActionsStatus.headAgreementAccepted;
      case 'paid':
        return LastActionsStatus.paid;
      case 'finished':
        return LastActionsStatus.finished;
      case 'added_expert':
        return LastActionsStatus.addedExpert;
      case 'rejected':
      case 'failed':
        return LastActionsStatus.rejected;
      case 'waiting_for_payment':
        return LastActionsStatus.waitingForPayment;
      case 'published':
        return LastActionsStatus.published;
      case 'accepted':
      case 'approved':
      case 'confirmed':
        return LastActionsStatus.accepted;
      default:
        return LastActionsStatus.unknown;
    }
  }
}

/// Bosh sahifadagi almashtirsa bo'ladigan bo'limlar.
/// Tartibi shu ro'yxatdagidek — default holat shu.
enum HomeSectionId {
  banners,
  activeCourses,
  popularCourses,
  activeBooks,
  popularBooks,
  userArticles,
  userRequests,
  vacancies,
}

extension HomeSectionIdX on HomeSectionId {
  static HomeSectionId? fromName(String value) {
    for (final id in HomeSectionId.values) {
      if (id.name == value) return id;
    }
    return null;
  }
}

enum AnnotationLanguageEnum { uz, en, ru }

enum PaymentStatusEnum { paid, pending, notBought }

enum LessonTestErrorKind { faceNotFound, faceNotVerified, server, unknown }
